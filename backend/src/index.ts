import dotenv from 'dotenv';
import { Server } from './server';
import { prisma } from './database/connection';
import { logger } from './utils/logger';

dotenv.config();

const PORT = parseInt(process.env.PORT || '8000', 10);

async function startServer() {
  try {
    await prisma.$connect();
    logger.info('✅ Database connected successfully');

    const server = new Server();
    server.listen(PORT);
    logger.info(`🚀 Server started on port ${PORT}`);

    process.on('SIGTERM', async () => {
      logger.info('SIGTERM received, shutting down gracefully');
      await prisma.$disconnect();
      process.exit(0);
    });
    process.on('SIGINT', async () => {
      logger.info('SIGINT received, shutting down gracefully');
      await prisma.$disconnect();
      process.exit(0);
    });
  } catch (error) {
    logger.error({ msg: 'Failed to start server', error });
    process.exit(1);
  }
}

startServer();
