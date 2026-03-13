import { Router } from 'express';
import authRoutes from './auth.routes';
import userRoutes from './user.routes';
import employeeRoutes from './employee.routes';
import caseRoutes from './case.routes';
import decisionRoutes from './decision.routes';
import policyRoutes from './policy.routes';
import analyticsRoutes from './analytics.routes';
import governanceRoutes from './governance.routes';
import notificationRoutes from './notification.routes';
import taskRoutes from './task.routes';
import onboardingRoutes from './onboarding.routes';
import integrationRoutes from './integration.routes';
import settingsRoutes from './settings.routes';
import activityRoutes from './activity.routes';
import fileRoutes from './file.routes';

const router = Router();

// Mount routes
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/employees', employeeRoutes);
router.use('/cases', caseRoutes);
router.use('/decisions', decisionRoutes);
router.use('/policies', policyRoutes);
router.use('/analytics', analyticsRoutes);
router.use('/governance', governanceRoutes);
router.use('/notifications', notificationRoutes);
router.use('/tasks', taskRoutes);
router.use('/onboarding', onboardingRoutes);
router.use('/integrations', integrationRoutes);
router.use('/settings', settingsRoutes);
router.use('/activities', activityRoutes);
router.use('/files', fileRoutes);

export default router;
