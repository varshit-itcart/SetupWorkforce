import { Response, NextFunction } from 'express';
import { AuthRequest } from './auth.middleware';
import { ForbiddenError } from '../utils/errors';

const ROLE_HIERARCHY: Record<string, number> = {
  admin: 5,
  hr_director: 4,
  hr_manager: 3,
  manager: 2,
  employee: 1,
};

export const requireRole = (...allowedRoles: string[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return next(new ForbiddenError('Authentication required'));
    }

    const userRole = req.user.role;
    const userLevel = ROLE_HIERARCHY[userRole] || 0;
    
    const hasPermission = allowedRoles.some(
      role => userLevel >= ROLE_HIERARCHY[role]
    );

    if (!hasPermission) {
      return next(
        new ForbiddenError(`Insufficient permissions. Required: ${allowedRoles.join(' or ')}`)
      );
    }

    next();
  };
};