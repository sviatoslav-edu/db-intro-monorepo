const { PrismaPg } = require("@prisma/adapter-pg");
const { PrismaClient } = require("@prisma/client");

const adapter = new PrismaPg({ connectionString: "postgresql://postgres:admin@localhost:5432/postgres?schema=public" });
const prisma = new PrismaClient({ adapter });

async function main() {
  await prisma.user.create({
    data: { login: "kirilli", email: "Kirili@test.com", password_hash: "test"  }
  });

  const users = await prisma.user.findMany();
  console.log(users);
}
main();
