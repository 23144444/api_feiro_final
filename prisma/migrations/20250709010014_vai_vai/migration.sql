-- CreateEnum
CREATE TYPE "Categoria" AS ENUM ('FRUTAS', 'LEGUMES', 'VERDURAS', 'TEMPEROS');

-- CreateEnum
CREATE TYPE "Unidade" AS ENUM ('UN', 'KG', 'CX');

-- CreateEnum
CREATE TYPE "StatusPedido" AS ENUM ('EM_ANDAMENTO', 'FINALIZADO', 'CANCELADO', 'PENDENTE', 'ENTREGUE', 'EM_PREPARACAO', 'EM_ROTA', 'RETORNANDO');

-- CreateEnum
CREATE TYPE "StatusFeirante" AS ENUM ('Aberto', 'Fechado');

-- CreateEnum
CREATE TYPE "StatusFeira" AS ENUM ('Aberto', 'Fechado');

-- CreateTable
CREATE TABLE "feirantes" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(60) NOT NULL,
    "email" VARCHAR(60) NOT NULL,
    "senha" VARCHAR(60) NOT NULL,
    "telefone" VARCHAR(60) NOT NULL,
    "endereco" VARCHAR(60) NOT NULL,
    "banca" VARCHAR(100),
    "avaliacao" DOUBLE PRECISION DEFAULT 0,
    "totalAvaliacoes" INTEGER DEFAULT 0,
    "foto" TEXT,
    "avatar" TEXT,
    "especialidade" VARCHAR(100),
    "status" "StatusFeirante" DEFAULT 'Aberto',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "adminId" VARCHAR(36),
    "feiraId" INTEGER,

    CONSTRAINT "feirantes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mercadorias" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(60) NOT NULL,
    "preco" DECIMAL(10,2) NOT NULL,
    "quantidade" DECIMAL(10,2) NOT NULL,
    "categoria" "Categoria" NOT NULL DEFAULT 'FRUTAS',
    "unidade" "Unidade" NOT NULL DEFAULT 'UN',
    "foto" TEXT NOT NULL,
    "emoji" VARCHAR(10),
    "destaque" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "feirante_id" INTEGER NOT NULL,

    CONSTRAINT "mercadorias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cestas" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "preco" DECIMAL(10,2) NOT NULL,
    "desconto" VARCHAR(50),
    "imagem" TEXT,
    "emoji" VARCHAR(10),
    "categoria" VARCHAR(50),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "feirante_id" INTEGER NOT NULL,

    CONSTRAINT "cestas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cestas_recorrentes" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "frequencia" VARCHAR(50) NOT NULL,
    "dia_entrega" VARCHAR(50) NOT NULL,
    "preco" DECIMAL(10,2) NOT NULL,
    "ativa" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "usuario_id" VARCHAR(36) NOT NULL,
    "feirante_id" INTEGER NOT NULL,

    CONSTRAINT "cestas_recorrentes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fotos_mercadoria" (
    "id" SERIAL NOT NULL,
    "descricao" VARCHAR(60) NOT NULL,
    "url" TEXT NOT NULL,
    "mercadoria_id" INTEGER NOT NULL,
    "feirante_id" INTEGER NOT NULL,

    CONSTRAINT "fotos_mercadoria_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usuarios" (
    "id" VARCHAR(36) NOT NULL,
    "nome" VARCHAR(60) NOT NULL,
    "email" VARCHAR(60) NOT NULL,
    "telefone" VARCHAR(60) NOT NULL DEFAULT '',
    "endereco" VARCHAR(60) NOT NULL DEFAULT '',
    "bairro" VARCHAR(60) NOT NULL DEFAULT '',
    "senha" VARCHAR(60) NOT NULL,
    "nivel" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "codigoRecuperacao" TEXT,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pedidos" (
    "id" SERIAL NOT NULL,
    "valor_total" DECIMAL(10,2) NOT NULL,
    "status" "StatusPedido" NOT NULL DEFAULT 'PENDENTE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "usuario_id" VARCHAR(36) NOT NULL,
    "adminId" VARCHAR(36),

    CONSTRAINT "pedidos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pedido_items" (
    "id" SERIAL NOT NULL,
    "quantidade" DECIMAL(10,2) NOT NULL,
    "preco_unitario" DECIMAL(10,2) NOT NULL,
    "pedido_id" INTEGER NOT NULL,
    "mercadoria_id" INTEGER NOT NULL,

    CONSTRAINT "pedido_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "carrinho" (
    "id" SERIAL NOT NULL,
    "quantidade" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "mercadoria_id" INTEGER NOT NULL,
    "usuario_id" VARCHAR(36) NOT NULL,

    CONSTRAINT "carrinho_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admins" (
    "id" VARCHAR(36) NOT NULL,
    "nome" VARCHAR(60) NOT NULL,
    "email" VARCHAR(40) NOT NULL,
    "senha" VARCHAR(60) NOT NULL,
    "nivel" SMALLINT NOT NULL DEFAULT 2,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "admins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feiras" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "endereco" VARCHAR(255) NOT NULL,
    "status" "StatusFeira" NOT NULL DEFAULT 'Aberto',
    "horario" VARCHAR(100) NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "imagem" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "feiras_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CestaToMercadoria" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_CestaRecorrenteToMercadoria" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "_CestaToMercadoria_AB_unique" ON "_CestaToMercadoria"("A", "B");

-- CreateIndex
CREATE INDEX "_CestaToMercadoria_B_index" ON "_CestaToMercadoria"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_CestaRecorrenteToMercadoria_AB_unique" ON "_CestaRecorrenteToMercadoria"("A", "B");

-- CreateIndex
CREATE INDEX "_CestaRecorrenteToMercadoria_B_index" ON "_CestaRecorrenteToMercadoria"("B");

-- AddForeignKey
ALTER TABLE "feirantes" ADD CONSTRAINT "feirantes_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "admins"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feirantes" ADD CONSTRAINT "feirantes_feiraId_fkey" FOREIGN KEY ("feiraId") REFERENCES "feiras"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mercadorias" ADD CONSTRAINT "mercadorias_feirante_id_fkey" FOREIGN KEY ("feirante_id") REFERENCES "feirantes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cestas" ADD CONSTRAINT "cestas_feirante_id_fkey" FOREIGN KEY ("feirante_id") REFERENCES "feirantes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cestas_recorrentes" ADD CONSTRAINT "cestas_recorrentes_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cestas_recorrentes" ADD CONSTRAINT "cestas_recorrentes_feirante_id_fkey" FOREIGN KEY ("feirante_id") REFERENCES "feirantes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotos_mercadoria" ADD CONSTRAINT "fotos_mercadoria_mercadoria_id_fkey" FOREIGN KEY ("mercadoria_id") REFERENCES "mercadorias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotos_mercadoria" ADD CONSTRAINT "fotos_mercadoria_feirante_id_fkey" FOREIGN KEY ("feirante_id") REFERENCES "feirantes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedidos" ADD CONSTRAINT "pedidos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedidos" ADD CONSTRAINT "pedidos_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "admins"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedido_items" ADD CONSTRAINT "pedido_items_pedido_id_fkey" FOREIGN KEY ("pedido_id") REFERENCES "pedidos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedido_items" ADD CONSTRAINT "pedido_items_mercadoria_id_fkey" FOREIGN KEY ("mercadoria_id") REFERENCES "mercadorias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "carrinho" ADD CONSTRAINT "carrinho_mercadoria_id_fkey" FOREIGN KEY ("mercadoria_id") REFERENCES "mercadorias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "carrinho" ADD CONSTRAINT "carrinho_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CestaToMercadoria" ADD CONSTRAINT "_CestaToMercadoria_A_fkey" FOREIGN KEY ("A") REFERENCES "cestas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CestaToMercadoria" ADD CONSTRAINT "_CestaToMercadoria_B_fkey" FOREIGN KEY ("B") REFERENCES "mercadorias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CestaRecorrenteToMercadoria" ADD CONSTRAINT "_CestaRecorrenteToMercadoria_A_fkey" FOREIGN KEY ("A") REFERENCES "cestas_recorrentes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CestaRecorrenteToMercadoria" ADD CONSTRAINT "_CestaRecorrenteToMercadoria_B_fkey" FOREIGN KEY ("B") REFERENCES "mercadorias"("id") ON DELETE CASCADE ON UPDATE CASCADE;
