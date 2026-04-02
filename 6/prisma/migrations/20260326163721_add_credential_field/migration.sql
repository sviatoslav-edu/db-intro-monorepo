-- CreateTable
CREATE TABLE "achievement" (
    "id" SERIAL NOT NULL,
    "game_id" INTEGER NOT NULL,
    "logo_id" INTEGER,
    "title" VARCHAR(32) NOT NULL,
    "description" VARCHAR(255),

    CONSTRAINT "achievement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content" (
    "id" SERIAL NOT NULL,
    "profile_id" INTEGER NOT NULL,
    "game_id" INTEGER NOT NULL,
    "title" VARCHAR(32) NOT NULL,
    "description" VARCHAR(256),
    "data" BYTEA NOT NULL,

    CONSTRAINT "content_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credential" (
    "id" SERIAL NOT NULL,
    "login" VARCHAR(12) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "password_hash" VARCHAR(100) NOT NULL,
    "is_admin" BOOLEAN NOT NULL,

    CONSTRAINT "credential_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game" (
    "id" SERIAL NOT NULL,
    "studio_id" INTEGER NOT NULL,
    "publisher_id" INTEGER NOT NULL,
    "title" VARCHAR(32) NOT NULL,
    "price" MONEY,
    "data" BYTEA NOT NULL,
    "description" VARCHAR(255),

    CONSTRAINT "game_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_media" (
    "id" SERIAL NOT NULL,
    "game_id" SERIAL NOT NULL,
    "media_id" SERIAL NOT NULL,

    CONSTRAINT "game_media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_tag" (
    "id" SERIAL NOT NULL,
    "game_id" SERIAL NOT NULL,
    "tag_id" SERIAL NOT NULL,

    CONSTRAINT "game_tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "media" (
    "id" SERIAL NOT NULL,
    "data" BYTEA NOT NULL,

    CONSTRAINT "media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile" (
    "id" SERIAL NOT NULL,
    "credential_id" INTEGER NOT NULL,
    "pfp_id" INTEGER,
    "name" VARCHAR(32) NOT NULL,
    "about" VARCHAR(256),
    "created_date" DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT "profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile_achievement" (
    "id" SERIAL NOT NULL,
    "profile_id" SERIAL NOT NULL,
    "achievement_id" SERIAL NOT NULL,

    CONSTRAINT "profile_achievement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase" (
    "id" SERIAL NOT NULL,
    "credential_id" INTEGER NOT NULL,
    "game_id" INTEGER NOT NULL,
    "price" MONEY NOT NULL,
    "created_date" DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT "purchase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "review" (
    "id" SERIAL NOT NULL,
    "profile_id" INTEGER NOT NULL,
    "game_id" INTEGER NOT NULL,
    "recommend" BOOLEAN NOT NULL,
    "words" VARCHAR(255),

    CONSTRAINT "review_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "signature" (
    "id" SERIAL NOT NULL,
    "profile_id" INTEGER NOT NULL,
    "author_id" INTEGER NOT NULL,
    "signature" VARCHAR(256) NOT NULL,
    "created_date" DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT "signature_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "studio" (
    "id" SERIAL NOT NULL,
    "logo_id" INTEGER,
    "title" VARCHAR(32) NOT NULL,
    "about" VARCHAR(256),

    CONSTRAINT "studio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tag" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(10) NOT NULL,

    CONSTRAINT "tag_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "credential_login_key" ON "credential"("login");

-- CreateIndex
CREATE UNIQUE INDEX "credential_email_key" ON "credential"("email");

-- CreateIndex
CREATE UNIQUE INDEX "game_tag_game_id_tag_id_key" ON "game_tag"("game_id", "tag_id");

-- CreateIndex
CREATE UNIQUE INDEX "profile_credential_id_key" ON "profile"("credential_id");

-- CreateIndex
CREATE UNIQUE INDEX "profile_achievement_profile_id_achievement_id_key" ON "profile_achievement"("profile_id", "achievement_id");

-- CreateIndex
CREATE UNIQUE INDEX "unique_purchase" ON "purchase"("credential_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "unique_review" ON "review"("profile_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "tag_name_key" ON "tag"("name");

-- AddForeignKey
ALTER TABLE "achievement" ADD CONSTRAINT "achievement_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "achievement" ADD CONSTRAINT "achievement_logo_id_fkey" FOREIGN KEY ("logo_id") REFERENCES "media"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "content" ADD CONSTRAINT "content_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "content" ADD CONSTRAINT "content_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "game" ADD CONSTRAINT "game_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "studio"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "game" ADD CONSTRAINT "game_studio_id_fkey" FOREIGN KEY ("studio_id") REFERENCES "studio"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "game_media" ADD CONSTRAINT "game_media_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "game_media" ADD CONSTRAINT "game_media_media_id_fkey" FOREIGN KEY ("media_id") REFERENCES "media"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "game_tag" ADD CONSTRAINT "game_tag_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "game_tag" ADD CONSTRAINT "game_tag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tag"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "profile" ADD CONSTRAINT "profile_credential_id_fkey" FOREIGN KEY ("credential_id") REFERENCES "credential"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "profile" ADD CONSTRAINT "profile_pfp_id_fkey" FOREIGN KEY ("pfp_id") REFERENCES "media"("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "profile_achievement" ADD CONSTRAINT "profile_achievement_achievement_id_fkey" FOREIGN KEY ("achievement_id") REFERENCES "achievement"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "profile_achievement" ADD CONSTRAINT "profile_achievement_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "purchase" ADD CONSTRAINT "purchase_credential_id_fkey" FOREIGN KEY ("credential_id") REFERENCES "credential"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "purchase" ADD CONSTRAINT "purchase_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "signature" ADD CONSTRAINT "signature_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "signature" ADD CONSTRAINT "signature_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "studio" ADD CONSTRAINT "studio_logo_id_fkey" FOREIGN KEY ("logo_id") REFERENCES "media"("id") ON DELETE SET NULL ON UPDATE NO ACTION;
