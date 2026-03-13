import { Request, Response, NextFunction } from 'express';
import { prisma } from '../database/connection';
import { AuthRequest } from './auth.middleware';

export const auditMiddleware = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  const startTime = Date.now();

  // Capture response
  const originalSend = res.send;
  res.send = function (data: any) {
    res.locals.responseBody = data;
    return originalSend.call(this, data);
  };

  res.on('finish', async () => {
    try {
      const duration = Date.now() - startTime;

      // Only log non-GET requests or errors
      if (req.method !== 'GET' || res.statusCode >= 400) {
        await prisma.auditLog.create({
          data: {
            userId: req.user?.id,
            userEmail: req.user?.email,
            action: `${req.method} ${req.path}`,
            entityType: extractEntityType(req.path),
            entityId: Array.isArray(req.params.id) ? req.params.id[0] : req.params.id || null,
            ipAddress: req.ip,
            userAgent: req.headers['user-agent'] || '',
            requestMethod: req.method,
            requestPath: req.path,
            statusCode: res.statusCode,
            errorMessage: res.statusCode >= 400 ? res.locals.responseBody : null,
          },
        });
      }
    } catch (error) {
      console.error('Audit logging failed:', error);
    }
  });

  next();
};

function extractEntityType(path: string): string {
  const match = path.match(/\/api\/v1\/(\w+)/);
  return match ? match[1] : 'unknown';
}