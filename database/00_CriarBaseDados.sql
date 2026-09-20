-/*
=========================================================
 Sistema de Gestão de Doação de Sangue
 Script: 00_CriarBaseDados.sql
 Tecnologia: Microsoft SQL Server
 Autor: Leonilde José Mugabe
=========================================================
*/

-- Remove a base de dados caso já exista
IF DB_ID('BD_DoacaoSangue') IS NOT NULL
BEGIN
    DROP DATABASE BD_DoacaoSangue;
END;
GO

-- Cria a base de dados
CREATE DATABASE BD_DoacaoSangue;
GO

-- Seleciona a base de dados
USE BD_DoacaoSangue;
GO