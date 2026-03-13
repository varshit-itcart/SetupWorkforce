// Prisma model file, not using TypeORM

// Prisma model, plain TypeScript class
export class User {
  id!: string;

  email!: string;

  passwordHash!: string;

  firstName!: string;

  lastName!: string;

  role!: string;

  createdAt!: Date;

  updatedAt!: Date;
}
