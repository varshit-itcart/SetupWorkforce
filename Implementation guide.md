# Implementation Guide - AiXWorkForce360 Backend

## Quick Start

### 1. Initialize Project

```bash
mkdir aixworkforce360-backend
cd aixworkforce360-backend
npm init -y
```

### 2. Install Dependencies

```bash
# Core dependencies
npm install express typescript ts-node @types/node @types/express
npm install cors helmet dotenv uuid
npm install prisma @prisma/client
npm install jsonwebtoken bcrypt
npm install zod express-validator
npm install socket.io
npm install winston
npm install bull ioredis
npm install multer
npm install date-fns

# Type definitions
npm install -D @types/cors @types/bcrypt @types/jsonwebtoken @types/multer
npm install -D nodemon ts-node-dev
npm install -D jest @types/jest ts-jest supertest @types/supertest
npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
npm install -D prettier eslint-config-prettier
```

### 3. TypeScript Configuration

**tsconfig.json:**
```json
{
  \"compilerOptions\": {
    \"target\": \"ES2020\",
    \"module\": \"commonjs\",
    \"lib\": [\"ES2020\"],
    \"outDir\": \"./dist\",
    \"rootDir\": \"./src\",
    \"strict\": true,
    \"esModuleInterop\": true,
    \"skipLibCheck\": true,
    \"forceConsistentCasingInFileNames\": true,
    \"resolveJsonModule\": true,
    \"moduleResolution\": \"node\",
    \"declaration\": true,
    \"declarationMap\": true,
    \"sourceMap\": true,
    \"experimentalDecorators\": true,
    \"emitDecoratorMetadata\": true,
    \"strictPropertyInitialization\": false
  },
  \"include\": [\"src/**/*\"],
  \"exclude\": [\"node_modules\", \"dist\", \"**/*.test.ts\"]
}
```

### 4. Initialize Prisma

```bash
npx prisma init
```

---

## Core Implementation Examples

### 1. Server Setup (src/server.ts)

```typescript
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { createServer } from 'http';
import { Server as SocketIOServer } from 'socket.io';
import routes from './routes';
import { errorMiddleware } from './middleware/error.middleware';
import { auditMiddleware } from './middleware/audit.middleware';
import { setupWebSocket } from './websocket';
import { logger } from './utils/logger';

export class Server {
  public app: Application;
  public httpServer: any;
  public io: SocketIOServer;

  constructor() {
    this.app = express();
    this.httpServer = createServer(this.app);
    this.io = new SocketIOServer(this.httpServer, {
      cors: {
        origin: process.env.CORS_ORIGIN?.split(',') || 'http://localhost:3000',
        credentials: true,
      },
    });

    this.initializeMiddlewares();
    this.initializeRoutes();
    this.initializeWebSocket();
    this.initializeErrorHandling();
  }

  private initializeMiddlewares(): void {
    this.app.use(helmet());
    this.app.use(cors({
      origin: process.env.CORS_ORIGIN?.split(',') || 'http://localhost:3000',
      credentials: true,
    }));
    this.app.use(express.json({ limit: '10mb' }));
    this.app.use(express.urlencoded({ extended: true, limit: '10mb' }));
    this.app.use(auditMiddleware);
  }

  private initializeRoutes(): void {
    this.app.get('/health', (req, res) => {
      res.json({ status: 'ok', timestamp: new Date().toISOString() });
    });
    this.app.use('/api/v1', routes);
  }

  private initializeWebSocket(): void {
    setupWebSocket(this.io);
  }

  private initializeErrorHandling(): void {
    this.app.use(errorMiddleware);
  }

  public listen(port: number): void {
    this.httpServer.listen(port, () => {
      logger.info(`🚀 Server running on port ${port}`);
      logger.info(`📡 Environment: ${process.env.NODE_ENV}`);
    });
  }
}
```

### 2. Entry Point (src/index.ts)

```typescript
import dotenv from 'dotenv';
import { Server } from './server';
import { prisma } from './database/connection';
import { logger } from './utils/logger';

dotenv.config();

const PORT = parseInt(process.env.PORT || '8000', 10);

async function bootstrap() {
  try {
    // Test database connection
    await prisma.$connect();
    logger.info('✅ Database connected successfully');

    // Start server
    const server = new Server();
    server.listen(PORT);

    // Graceful shutdown
    process.on('SIGTERM', async () => {
      logger.info('SIGTERM received, shutting down gracefully');
      await prisma.$disconnect();
      process.exit(0);
    });

  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}

bootstrap();
```

### 3. Database Connection (src/database/connection.ts)

```typescript
import { PrismaClient } from '@prisma/client';
import { logger } from '../utils/logger';

const prismaClientSingleton = () => {
  return new PrismaClient({
    log: process.env.NODE_ENV === 'development' 
      ? ['query', 'error', 'warn'] 
      : ['error'],
  });
};

declare global {
  var prisma: undefined | ReturnType<typeof prismaClientSingleton>;
}

export const prisma = globalThis.prisma ?? prismaClientSingleton();

if (process.env.NODE_ENV !== 'production') {
  globalThis.prisma = prisma;
}

// Graceful shutdown
prisma.$on('beforeExit' as never, async () => {
  logger.info('Prisma client disconnecting...');
});
```

### 4. Authentication Middleware (src/middleware/auth.middleware.ts)

```typescript
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { prisma } from '../database/connection';
import { UnauthorizedError } from '../utils/errors';

export interface AuthRequest extends Request {
  user?: {
    id: string;
    email: string;
    role: string;
  };
}

export const authMiddleware = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      throw new UnauthorizedError('No token provided');
    }

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET!
    ) as { id: string; email: string; role: string };

    // Verify user still exists and is active
    const user = await prisma.user.findUnique({
      where: { id: decoded.id },
      select: { id: true, email: true, role: true, isActive: true },
    });

    if (!user || !user.isActive) {
      throw new UnauthorizedError('Invalid token');
    }

    req.user = {
      id: user.id,
      email: user.email,
      role: user.role,
    };

    next();
  } catch (error) {
    next(new UnauthorizedError('Invalid or expired token'));
  }
};
```

### 5. RBAC Middleware (src/middleware/rbac.middleware.ts)

```typescript
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
```

### 6. Audit Middleware (src/middleware/audit.middleware.ts)

```typescript
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
            entityId: req.params.id || null,
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
```

### 7. Error Middleware (src/middleware/error.middleware.ts)

```typescript
import { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';

export const errorMiddleware = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  logger.error('Error:', {
    message: error.message,
    stack: error.stack,
    path: req.path,
    method: req.method,
  });

  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
        details: error.details,
      },
    });
  }

  // Prisma errors
  if (error.constructor.name.includes('Prisma')) {
    return res.status(400).json({
      error: {
        code: 'DATABASE_ERROR',
        message: 'A database error occurred',
      },
    });
  }

  // JWT errors
  if (error.name === 'JsonWebTokenError') {
    return res.status(401).json({
      error: {
        code: 'INVALID_TOKEN',
        message: 'Invalid token',
      },
    });
  }

  // Default error
  res.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
    },
  });
};
```

### 8. Custom Errors (src/utils/errors.ts)

```typescript
export class AppError extends Error {
  constructor(
    public statusCode: number,
    public code: string,
    public message: string,
    public details?: any
  ) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

export class BadRequestError extends AppError {
  constructor(message: string, details?: any) {
    super(400, 'BAD_REQUEST', message, details);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(401, 'UNAUTHORIZED', message);
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = 'Forbidden') {
    super(403, 'FORBIDDEN', message);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(404, 'NOT_FOUND', `${resource} not found`);
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(409, 'CONFLICT', message);
  }
}

export class ValidationError extends AppError {
  constructor(message: string, details?: any) {
    super(422, 'VALIDATION_ERROR', message, details);
  }
}
```

### 9. JWT Utilities (src/utils/jwt.ts)

```typescript
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { prisma } from '../database/connection';

export interface TokenPayload {
  id: string;
  email: string;
  role: string;
}

export const generateAccessToken = (payload: TokenPayload): string => {
  return jwt.sign(payload, process.env.JWT_SECRET!, {
    expiresIn: process.env.JWT_EXPIRES_IN || '1h',
  });
};

export const generateRefreshToken = async (
  userId: string,
  ipAddress?: string,
  userAgent?: string
): Promise<string> => {
  const token = uuidv4();
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

  await prisma.refreshToken.create({
    data: {
      userId,
      token,
      expiresAt,
      ipAddress,
      userAgent,
    },
  });

  return token;
};

export const verifyRefreshToken = async (token: string): Promise<string | null> => {
  const refreshToken = await prisma.refreshToken.findUnique({
    where: { token },
  });

  if (
    !refreshToken ||
    refreshToken.revoked ||
    refreshToken.expiresAt < new Date()
  ) {
    return null;
  }

  return refreshToken.userId;
};

export const revokeRefreshToken = async (token: string): Promise<void> => {
  await prisma.refreshToken.update({
    where: { token },
    data: {
      revoked: true,
      revokedAt: new Date(),
    },
  });
};
```

### 10. Auth Controller Example (src/controllers/auth.controller.ts)

```typescript
import { Response, NextFunction } from 'express';
import bcrypt from 'bcrypt';
import { AuthRequest } from '../middleware/auth.middleware';
import { prisma } from '../database/connection';
import {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
  revokeRefreshToken,
} from '../utils/jwt';
import {
  BadRequestError,
  UnauthorizedError,
  ConflictError,
} from '../utils/errors';

export class AuthController {
  async register(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { email, password, firstName, lastName, role, department, position } = req.body;

      // Check if user exists
      const existingUser = await prisma.user.findUnique({
        where: { email },
      });

      if (existingUser) {
        throw new ConflictError('Email already registered');
      }

      // Hash password
      const passwordHash = await bcrypt.hash(password, 10);

      // Create user
      const user = await prisma.user.create({
        data: {
          email,
          passwordHash,
          firstName,
          lastName,
          role: role || 'employee',
          department,
          position,
        },
        select: {
          id: true,
          email: true,
          firstName: true,
          lastName: true,
          role: true,
          department: true,
          position: true,
          createdAt: true,
        },
      });

      // Generate tokens
      const accessToken = generateAccessToken({
        id: user.id,
        email: user.email,
        role: user.role,
      });

      const refreshToken = await generateRefreshToken(
        user.id,
        req.ip,
        req.headers['user-agent']
      );

      res.status(201).json({
        user,
        accessToken,
        refreshToken,
      });
    } catch (error) {
      next(error);
    }
  }

  async login(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { email, password } = req.body;

      // Find user
      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user || !user.passwordHash) {
        throw new UnauthorizedError('Invalid credentials');
      }

      // Verify password
      const isValidPassword = await bcrypt.compare(password, user.passwordHash);

      if (!isValidPassword) {
        throw new UnauthorizedError('Invalid credentials');
      }

      if (!user.isActive) {
        throw new UnauthorizedError('Account is inactive');
      }

      // Update last login
      await prisma.user.update({
        where: { id: user.id },
        data: { lastLogin: new Date() },
      });

      // Generate tokens
      const accessToken = generateAccessToken({
        id: user.id,
        email: user.email,
        role: user.role,
      });

      const refreshToken = await generateRefreshToken(
        user.id,
        req.ip,
        req.headers['user-agent']
      );

      res.json({
        user: {
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          role: user.role,
          department: user.department,
          position: user.position,
        },
        accessToken,
        refreshToken,
      });
    } catch (error) {
      next(error);
    }
  }

  async refresh(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken) {
        throw new BadRequestError('Refresh token required');
      }

      const userId = await verifyRefreshToken(refreshToken);

      if (!userId) {
        throw new UnauthorizedError('Invalid refresh token');
      }

      const user = await prisma.user.findUnique({
        where: { id: userId },
        select: { id: true, email: true, role: true, isActive: true },
      });

      if (!user || !user.isActive) {
        throw new UnauthorizedError('User not found or inactive');
      }

      // Generate new tokens
      const accessToken = generateAccessToken({
        id: user.id,
        email: user.email,
        role: user.role,
      });

      const newRefreshToken = await generateRefreshToken(
        user.id,
        req.ip,
        req.headers['user-agent']
      );

      // Revoke old refresh token
      await revokeRefreshToken(refreshToken);

      res.json({
        accessToken,
        refreshToken: newRefreshToken,
      });
    } catch (error) {
      next(error);
    }
  }

  async logout(req: AuthRequest, res: Response, next: NextFunction) {
    try {
      const { refreshToken } = req.body;

      if (refreshToken) {
        await revokeRefreshToken(refreshToken);
      }

      res.json({ message: 'Logged out successfully' });
    } catch (error) {
      next(error);
    }
  }
}

export const authController = new AuthController();
```

### 11. Auth Routes (src/routes/auth.routes.ts)

```typescript
import { Router } from 'express';
import { authController } from '../controllers/auth.controller';
import { validateRequest } from '../middleware/validation.middleware';
import { loginSchema, registerSchema } from '../validators/auth.validator';

const router = Router();

router.post('/register', validateRequest(registerSchema), authController.register);
router.post('/login', validateRequest(loginSchema), authController.login);
router.post('/refresh', authController.refresh);
router.post('/logout', authController.logout);

export default router;
```

### 12. Validation Example (src/validators/auth.validator.ts)

```typescript
import { z } from 'zod';

export const registerSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email address'),
    password: z.string().min(8, 'Password must be at least 8 characters'),
    firstName: z.string().min(1, 'First name is required'),
    lastName: z.string().min(1, 'Last name is required'),
    role: z.enum(['admin', 'hr_director', 'hr_manager', 'manager', 'employee']).optional(),
    department: z.string().optional(),
    position: z.string().optional(),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z.string().email('Invalid email address'),
    password: z.string().min(1, 'Password is required'),
  }),
});
```

### 13. Validation Middleware (src/middleware/validation.middleware.ts)

```typescript
import { Request, Response, NextFunction } from 'express';
import { AnyZodObject, ZodError } from 'zod';
import { ValidationError } from '../utils/errors';

export const validateRequest = (schema: AnyZodObject) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const errors = error.errors.map(err => ({
          path: err.path.join('.'),
          message: err.message,
        }));
        next(new ValidationError('Validation failed', errors));
      } else {
        next(error);
      }
    }
  };
};
```

---

## Next Steps

1. **Set up Prisma schema** based on DATABASE_SCHEMA.md
2. **Generate migrations**: `npx prisma migrate dev --name init`
3. **Implement remaining controllers** following the auth controller pattern
4. **Add WebSocket handlers** for real-time features
5. **Set up background jobs** for SLA monitoring and notifications
6. **Add file upload** using multer
7. **Write tests** for critical endpoints
8. **Set up Docker** for containerization
9. **Configure CI/CD** for automated deployment

Refer to the API_ENDPOINTS.md for all endpoint specifications to implement.