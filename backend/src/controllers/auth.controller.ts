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
			const { email, password, firstName, lastName, role } = req.body;

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
				},
				select: {
					id: true,
					email: true,
					firstName: true,
					lastName: true,
					role: true,
				},
			});

			// Generate tokens
			const accessToken = generateAccessToken({
				id: user.id,
				email: user.email,
				role: user.role,
			});
			const refreshToken = await generateRefreshToken(user.id);

			res.status(201).json({
				user,
				accessToken,
				refreshToken,
			});
		} catch (error) {
			next(error);
		}
	}

	// Add login, refresh, logout methods as needed
}
