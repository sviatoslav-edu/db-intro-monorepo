const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  await prisma.user.create({
    data: { login: "kirilli", email: "Kirili@test.com", password_hash: "test"  }
  });

  const users = await prisma.user.findMany();
  console.log(users);
}
main();
