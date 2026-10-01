/*
 Sistema de Gestão de Doação de Sangue
 Script: 00_CriarBaseDados.sql
 Tecnologia: Microsoft SQL Server
 Autor: Leonilde José Mugabe
*/

IF DB_ID('BD_DoacaoSangue') IS NOT NULL
BEGIN
    DROP DATABASE BD_DoacaoSangue;
END;
GO

CREATE DATABASE BD_DoacaoSangue;
GO

USE BD_DoacaoSangue;
GO