/*
=========================================================
 Sistema de Gestão de Doação de Sangue
 Script: 01_Tabelas.sql
 Tecnologia: Microsoft SQL Server
 Autor: Leonilde José Mugabe
=========================================================
*/

USE BD_DoacaoSangue;
GO
-- =====================================================
-- TABELA: Utilizador
-- =====================================================

CREATE TABLE Utilizador (
    id_utilizador INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    apelido VARCHAR(50) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    palavra_passe VARCHAR(255) NOT NULL,
    endereco VARCHAR(150) NOT NULL,
    tipo_utilizador VARCHAR(20) NOT NULL
);
GO

-- =====================================================
-- TABELA: TipoSanguineo
-- =====================================================

CREATE TABLE TipoSanguineo (
    id_tipo_sanguineo INT IDENTITY(1,1) PRIMARY KEY,
    grupo_sanguineo VARCHAR(5) NOT NULL,
    fator_rh CHAR(1) NOT NULL
);
GO

-- =====================================================
-- TABELA: Hospital
-- =====================================================

CREATE TABLE Hospital (
    id_hospital INT IDENTITY(1,1) PRIMARY KEY,
    nome_hospital VARCHAR(100) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL,
    endereco VARCHAR(150) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL
);
GO

-- =====================================================
-- TABELA: Dador
-- =====================================================

CREATE TABLE Dador (
    id_dador INT IDENTITY(1,1) PRIMARY KEY,
    id_utilizador INT NOT NULL,
    id_tipo_sanguineo INT NOT NULL,
    peso DECIMAL(5,2) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    ultima_doacao DATE NULL,
    disponibilidade BIT NOT NULL
);
GO

-- =====================================================
-- TABELA: Campanha
-- =====================================================

CREATE TABLE Campanha (
    id_campanha INT IDENTITY(1,1) PRIMARY KEY,
    id_hospital INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descricao VARCHAR(MAX) NOT NULL,
    local VARCHAR(150) NOT NULL,
    data DATE NOT NULL,
    hora TIME NOT NULL
);
GO

-- =====================================================
-- TABELA: PedidoDeSangue
-- =====================================================

CREATE TABLE PedidoDeSangue (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    id_hospital INT NOT NULL,
    id_tipo_sanguineo INT NOT NULL,
    quantidade_bolsas INT NOT NULL,
    urgencia VARCHAR(20) NOT NULL,
    data_pedido DATE NOT NULL,
    estado VARCHAR(30) NOT NULL
);
GO

-- =====================================================
-- TABELA: Doacao
-- =====================================================

CREATE TABLE Doacao (
    id_doacao INT IDENTITY(1,1) PRIMARY KEY,
    id_dador INT NOT NULL,
    id_hospital INT NOT NULL,
    data_doacao DATE NOT NULL,
    quantidade DECIMAL(5,2) NOT NULL
);
GO

-- =====================================================
-- TABELA: Notificacao
-- =====================================================

CREATE TABLE Notificacao (
    id_notificacao INT IDENTITY(1,1) PRIMARY KEY,
    id_utilizador INT NOT NULL,
    mensagem VARCHAR(300) NOT NULL,
    data_envio DATETIME NOT NULL,
    lida BIT NOT NULL
);
GO