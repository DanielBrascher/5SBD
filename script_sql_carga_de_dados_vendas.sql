-- =====================================================================
-- SCRIPT DE CRIAÇÃO E CARGA DE DADOS (SEED) - SISTEMA DE VENDAS
-- COMPATÍVEL COM ORACLE DATABASE (23ai / 19c / Oracle APEX)
-- =====================================================================

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- ---------------------------------------------------------------------
-- 1. ESTRUTURA DAS TABELAS (DDL)
-- ---------------------------------------------------------------------

-- Removendo tabelas anteriores se existirem
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_venda_item CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_venda CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_produto CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_categoria CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_cliente CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_vendedor CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE tb_calendario CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE tb_categoria (
    id_categoria NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL
);

CREATE TABLE tb_produto (
    id_produto NUMBER PRIMARY KEY,
    id_categoria NUMBER NOT NULL,
    sku VARCHAR2(30) UNIQUE NOT NULL,
    nome VARCHAR2(150) NOT NULL,
    preco_unit NUMBER(10, 2) NOT NULL,
    ativo CHAR(1) DEFAULT 'S' CHECK (ativo IN ('S', 'N')),
    CONSTRAINT fk_prod_cat FOREIGN KEY (id_categoria) REFERENCES tb_categoria(id_categoria)
);

CREATE TABLE tb_cliente (
    id_cliente NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    cpf VARCHAR2(14) UNIQUE NOT NULL,
    telefone VARCHAR2(20),
    dt_cadastro DATE DEFAULT SYSDATE,
    ativo CHAR(1) DEFAULT 'S' CHECK (ativo IN ('S', 'N'))
);

CREATE TABLE tb_vendedor (
    id_vendedor NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    dt_admissao DATE DEFAULT SYSDATE,
    ativo CHAR(1) DEFAULT 'S' CHECK (ativo IN ('S', 'N'))
);

CREATE TABLE tb_venda (
    id_venda NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    id_vendedor NUMBER NOT NULL,
    dt_venda DATE NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('FECHADA', 'ABERTA', 'CANCELADA')),
    canal VARCHAR2(20) CHECK (canal IN ('SITE', 'APP', 'LOJA', 'TELEFONE')),
    valor_bruto NUMBER(10, 2) NOT NULL,
    desconto_total NUMBER(10, 2) DEFAULT 0,
    valor_liquido NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_venda_cli FOREIGN KEY (id_cliente) REFERENCES tb_cliente(id_cliente),
    CONSTRAINT fk_venda_vend FOREIGN KEY (id_vendedor) REFERENCES tb_vendedor(id_vendedor)
);

CREATE TABLE tb_venda_item (
    id_item NUMBER PRIMARY KEY,
    id_venda NUMBER NOT NULL,
    id_produto NUMBER NOT NULL,
    quantidade NUMBER(5) NOT NULL,
    preco_unit NUMBER(10, 2) NOT NULL,
    desconto_item NUMBER(10, 2) DEFAULT 0,
    valor_total NUMBER(10, 2) NOT NULL,
    CONSTRAINT fk_item_venda FOREIGN KEY (id_venda) REFERENCES tb_venda(id_venda),
    CONSTRAINT fk_item_prod FOREIGN KEY (id_produto) REFERENCES tb_produto(id_produto)
);

CREATE TABLE tb_calendario (
    dt_ref DATE PRIMARY KEY,
    ano NUMBER(4) NOT NULL,
    mes NUMBER(2) NOT NULL,
    dia NUMBER(2) NOT NULL,
    trimestre NUMBER(1) NOT NULL,
    nome_mes VARCHAR2(20) NOT NULL,
    dia_semana NUMBER(1) NOT NULL,
    nome_dia_semana VARCHAR2(20) NOT NULL
);

-- ---------------------------------------------------------------------
-- 2. POPULANDO TB_CATEGORIA
-- ---------------------------------------------------------------------
INSERT INTO tb_categoria (id_categoria, nome) VALUES (1, 'Tecnologia e Informática');
INSERT INTO tb_categoria (id_categoria, nome) VALUES (2, 'Eletrodomésticos');
INSERT INTO tb_categoria (id_categoria, nome) VALUES (3, 'Móveis e Decoração');
INSERT INTO tb_categoria (id_categoria, nome) VALUES (4, 'Papelaria e Escritório');
INSERT INTO tb_categoria (id_categoria, nome) VALUES (5, 'Esporte e Lazer');

-- ---------------------------------------------------------------------
-- 3. POPULANDO TB_CLIENTE
-- ---------------------------------------------------------------------
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (1, 'Ana Silva', 'ana.silva@email.com', '12345678901', '(11) 98083-9221', TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (2, 'Bruno Santos', 'bruno.santos@email.com', '23456789012', '(31) 98821-7207', TO_DATE('2026-03-13', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (3, 'Carlos Oliveira', 'carlos.oliveira@email.com', '34567890123', '(21) 98343-9167', TO_DATE('2025-11-17', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (4, 'Daniela Lima', 'daniela.lima@email.com', '45678901234', '(51) 98291-7183', TO_DATE('2025-12-09', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (5, 'Eduardo Pereira', 'eduardo.pereira@email.com', '56789012345', '(41) 98106-6449', TO_DATE('2026-05-02', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (6, 'Fernanda Souza', 'fernanda.souza@email.com', '67890123456', '(11) 98733-6273', TO_DATE('2026-03-11', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (7, 'Gabriel Costa', 'gabriel.costa@email.com', '78901234567', '(51) 98089-3999', TO_DATE('2025-12-17', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (8, 'Helena Rodrigues', 'helena.rodrigues@email.com', '89012345678', '(21) 99828-5201', TO_DATE('2026-01-22', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (9, 'Igor Alves', 'igor.alves@email.com', '90123456789', '(21) 99507-2954', TO_DATE('2025-12-10', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (10, 'Juliana Martins', 'juliana.martins@email.com', '01234567890', '(31) 98021-8062', TO_DATE('2025-10-27', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (11, 'Lucas Ribeiro', 'lucas.ribeiro@email.com', '11223344556', '(21) 99418-5861', TO_DATE('2026-02-11', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (12, 'Mariana Carvalho', 'mariana.carvalho@email.com', '22334455667', '(31) 98521-7026', TO_DATE('2026-03-15', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (13, 'Nicolas Gomes', 'nicolas.gomes@email.com', '33445566778', '(31) 98342-9607', TO_DATE('2026-04-16', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (14, 'Olivia Pinto', 'olivia.pinto@email.com', '44556677889', '(41) 98324-5263', TO_DATE('2026-02-07', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (15, 'Pedro Rocha', 'pedro.rocha@email.com', '55667788990', '(31) 98887-5847', TO_DATE('2026-04-28', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (16, 'Rafaela Barbosa', 'rafaela.barbosa@email.com', '66778899001', '(41) 99799-2829', TO_DATE('2026-04-08', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (17, 'Samuel Teixeira', 'samuel.teixeira@email.com', '77889900112', '(41) 98264-4095', TO_DATE('2025-12-19', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (18, 'Tatiana Castro', 'tatiana.castro@email.com', '88990011223', '(31) 99213-4457', TO_DATE('2025-12-13', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (19, 'Vinicius Melo', 'vinicius.melo@email.com', '99001122334', '(21) 98233-3883', TO_DATE('2026-04-28', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (20, 'Yasmin Cardoso', 'yasmin.cardoso@email.com', '00112233445', '(21) 98971-2489', TO_DATE('2026-04-19', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (21, 'Andreia Santos', 'andreia.santos@email.com', '12312312312', '(21) 98338-9045', TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (22, 'Caio Ferreira', 'caio.ferreira@email.com', '45645645645', '(31) 99521-3925', TO_DATE('2025-11-28', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (23, 'Letícia Neves', 'leticia.neves@email.com', '78978978978', '(31) 98545-7765', TO_DATE('2026-02-04', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (24, 'Rodrigo Dias', 'rodrigo.dias@email.com', '98798798798', '(31) 98702-9889', TO_DATE('2025-11-19', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_cliente (id_cliente, nome, email, cpf, telefone, dt_cadastro, ativo) VALUES (25, 'Camila Fonseca', 'camila.fonseca@email.com', '65465465465', '(31) 98239-5870', TO_DATE('2025-12-05', 'YYYY-MM-DD'), 'S');

-- ---------------------------------------------------------------------
-- 4. POPULANDO TB_VENDEDOR
-- ---------------------------------------------------------------------
INSERT INTO tb_vendedor (id_vendedor, nome, email, dt_admissao, ativo) VALUES (1, 'Marcos Pontes', 'marcos.pontes@vendas.com', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_vendedor (id_vendedor, nome, email, dt_admissao, ativo) VALUES (2, 'Patricia Ramos', 'patricia.ramos@vendas.com', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_vendedor (id_vendedor, nome, email, dt_admissao, ativo) VALUES (3, 'Roberto Carlos', 'roberto.carlos@vendas.com', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_vendedor (id_vendedor, nome, email, dt_admissao, ativo) VALUES (4, 'Sandra Alencar', 'sandra.alencar@vendas.com', TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_vendedor (id_vendedor, nome, email, dt_admissao, ativo) VALUES (5, 'Thiago Silva', 'thiago.silva@vendas.com', TO_DATE('2025-02-01', 'YYYY-MM-DD'), 'S');
INSERT INTO tb_vendedor (id_vendedor, nome, email, dt_admissao, ativo) VALUES (6, 'Regina Duarte', 'regina.duarte@vendas.com', TO_DATE('2025-05-15', 'YYYY-MM-DD'), 'S');

-- ---------------------------------------------------------------------
-- 5. POPULANDO TB_PRODUTO
-- ---------------------------------------------------------------------
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (1, 1, 'PROD-NOTE-01', 'Notebook Gamer Core i7 16GB', 4500.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (2, 1, 'PROD-MOU-02', 'Mouse Sem Fio Ergonômico', 120.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (3, 1, 'PROD-KEY-03', 'Teclado Mecânico RGB', 250.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (4, 1, 'PROD-MON-04', 'Monitor UltraWide 29 polegadas', 1100.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (5, 2, 'PROD-GEL-05', 'Geladeira Frost Free 400L', 3200.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (6, 2, 'PROD-MIC-06', 'Micro-ondas Digital 30L', 650.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (7, 2, 'PROD-AIR-07', 'Fritadeira Elétrica Airfryer', 450.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (8, 2, 'PROD-LIQ-08', 'Liquidificador 1200W', 180.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (9, 3, 'PROD-CAD-09', 'Cadeira de Escritório Presidente', 850.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (10, 3, 'PROD-MES-10', 'Mesa de Escritório em L', 450.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (11, 3, 'PROD-SOF-11', 'Sofá Retrátil 3 Lugares', 1900.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (12, 3, 'PROD-EST-12', 'Estante para Livros Multiuso', 350.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (13, 4, 'PROD-AGE-13', 'Agenda Executiva 2026', 45.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (14, 4, 'PROD-CAN-14', 'Kit Canetas Coloridas Gel (12 un)', 35.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (15, 4, 'PROD-RES-15', 'Resma de Papel A4 500 fls', 28.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (16, 4, 'PROD-ORG-16', 'Organizador de Mesa Acrílico', 60.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (17, 5, 'PROD-BIK-17', 'Bicicleta Aro 29 Alumínio 21M', 1500.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (18, 5, 'PROD-TAP-18', 'Tapete de Yoga Antiderrapante', 80.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (19, 5, 'PROD-GAR-19', 'Garrafa Térmica Esportiva 750ml', 95.00, 'S');
INSERT INTO tb_produto (id_produto, id_categoria, sku, nome, preco_unit, ativo) VALUES (20, 5, 'PROD-BOC-20', 'Bola de Futebol Oficial', 120.00, 'S');

-- ---------------------------------------------------------------------
-- 6. POPULANDO TB_VENDA E TB_VENDA_ITEM (AMOSTRA DAS VENDAS)
-- ---------------------------------------------------------------------
INSERT INTO tb_venda (id_venda, id_cliente, id_vendedor, dt_venda, status, canal, valor_bruto, desconto_total, valor_liquido) VALUES (1, 21, 2, TO_DATE('2026-05-17', 'YYYY-MM-DD'), 'FECHADA', 'SITE', 1685.00, 208.50, 1476.50);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (1, 1, 13, 3, 45.00, 0.00, 135.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (2, 1, 9, 1, 850.00, 127.50, 722.50);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (3, 1, 18, 2, 80.00, 0.00, 160.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (4, 1, 8, 3, 180.00, 81.00, 459.00);

INSERT INTO tb_venda (id_venda, id_cliente, id_vendedor, dt_venda, status, canal, valor_bruto, desconto_total, valor_liquido) VALUES (2, 7, 6, TO_DATE('2026-05-08', 'YYYY-MM-DD'), 'ABERTA', 'TELEFONE', 12870.00, 771.00, 12099.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (5, 2, 5, 3, 3200.00, 480.00, 9120.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (6, 2, 9, 3, 850.00, 255.00, 2295.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (7, 2, 20, 3, 120.00, 36.00, 324.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (8, 2, 8, 2, 180.00, 0.00, 360.00);

INSERT INTO tb_venda (id_venda, id_cliente, id_vendedor, dt_venda, status, canal, valor_bruto, desconto_total, valor_liquido) VALUES (3, 5, 5, TO_DATE('2026-05-07', 'YYYY-MM-DD'), 'FECHADA', 'APP', 9600.00, 960.00, 8640.00);
INSERT INTO tb_venda_item (id_item, id_venda, id_produto, quantidade, preco_unit, desconto_item, valor_total) VALUES (9, 3, 5, 3, 3200.00, 960.00, 8640.00);

-- ---------------------------------------------------------------------
-- 7. POPULANDO TB_CALENDARIO (GERAÇÃO AUTOMÁTICA DE TODOS OS DIAS DE 2026)
-- ---------------------------------------------------------------------
INSERT INTO tb_calendario (dt_ref, ano, mes, dia, trimestre, nome_mes, dia_semana, nome_dia_semana)
SELECT 
    dt AS dt_ref,
    EXTRACT(YEAR FROM dt) AS ano,
    EXTRACT(MONTH FROM dt) AS mes,
    EXTRACT(DAY FROM dt) AS dia,
    TO_NUMBER(TO_CHAR(dt, 'Q')) AS trimestre,
    INITCAP(TO_CHAR(dt, 'Month', 'NLS_DATE_LANGUAGE=PORTUGUESE')) AS nome_mes,
    TO_NUMBER(TO_CHAR(dt, 'D')) AS dia_semana,
    INITCAP(TO_CHAR(dt, 'Day', 'NLS_DATE_LANGUAGE=PORTUGUESE')) AS nome_dia_semana
FROM (
    SELECT TO_DATE('2026-01-01', 'YYYY-MM-DD') + LEVEL - 1 AS dt
    FROM DUAL
    CONNECT BY LEVEL <= 365
);

-- Finalizando com Commit
COMMIT;