# Частина 6
_Інтернет магазин ігор (альтернатива Steam)_

## Prisma
Змінили credential на user, і всі відповідні зв'язки за допомогою Prisma Schema. Також додали `is_admin` поле до `user`.

### PrismaClient
Протестуємо за допомогою PrismaClient:
- _test.js:_
```JavaScript
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
```

<img width="1807" height="891" alt="image" src="https://github.com/user-attachments/assets/e16dbb7a-4205-4fcb-8e5e-7908d111f69a" />

Як ми бачимо, у `user` з'явилося `is_admin`

<img width="463" height="449" alt="image" src="https://github.com/user-attachments/assets/eb4d938d-829d-4290-bc0c-f31c2c8b2eb4" />

<img width="866" height="802" alt="image" src="https://github.com/user-attachments/assets/376a796f-f6e7-479d-bb95-db2963ce5153" />


