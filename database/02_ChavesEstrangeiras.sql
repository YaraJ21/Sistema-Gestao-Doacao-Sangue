/*
=========================================================
 Sistema de Gestão de Doação de Sangue
 Script: 02_ChavesEstrangeiras.sql
 Tecnologia: Microsoft SQL Server
 Autor: Leonilde José Mugabe
=========================================================
*/

USE BD_DoacaoSangue;
GO

-- =====================================================
-- RELAÇÃO 1:1 - Utilizador -> Dador
-- =====================================================

ALTER TABLE Dador
ADD CONSTRAINT UQ_Dador_Utilizador UNIQUE (id_utilizador);
GO

ALTER TABLE Dador
ADD CONSTRAINT FK_Dador_Utilizador
FOREIGN KEY (id_utilizador)
REFERENCES Utilizador(id_utilizador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - TipoSanguineo -> Dador
-- =====================================================

ALTER TABLE Dador
ADD CONSTRAINT FK_Dador_TipoSanguineo
FOREIGN KEY (id_tipo_sanguineo)
REFERENCES TipoSanguineo(id_tipo_sanguineo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - Hospital -> Campanha
-- =====================================================

ALTER TABLE Campanha
ADD CONSTRAINT FK_Campanha_Hospital
FOREIGN KEY (id_hospital)
REFERENCES Hospital(id_hospital)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - Hospital -> PedidoDeSangue
-- =====================================================

ALTER TABLE PedidoDeSangue
ADD CONSTRAINT FK_Pedido_Hospital
FOREIGN KEY (id_hospital)
REFERENCES Hospital(id_hospital)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - TipoSanguineo -> PedidoDeSangue
-- =====================================================

ALTER TABLE PedidoDeSangue
ADD CONSTRAINT FK_Pedido_TipoSanguineo
FOREIGN KEY (id_tipo_sanguineo)
REFERENCES TipoSanguineo(id_tipo_sanguineo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - Dador -> Doacao
-- =====================================================

ALTER TABLE Doacao
ADD CONSTRAINT FK_Doacao_Dador
FOREIGN KEY (id_dador)
REFERENCES Dador(id_dador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - Hospital -> Doacao
-- =====================================================

ALTER TABLE Doacao
ADD CONSTRAINT FK_Doacao_Hospital
FOREIGN KEY (id_hospital)
REFERENCES Hospital(id_hospital)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =====================================================
-- RELAÇÃO 1:N - Utilizador -> Notificacao
-- =====================================================

ALTER TABLE Notificacao
ADD CONSTRAINT FK_Notificacao_Utilizador
FOREIGN KEY (id_utilizador)
REFERENCES Utilizador(id_utilizador)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO