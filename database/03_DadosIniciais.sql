/*
=========================================================
 Sistema de Gestão de Doação de Sangue
 Script: 03_DadosIniciais.sql
 Tecnologia: Microsoft SQL Server
 Autor: Leonilde José Mugabe
=========================================================
*/

USE BD_DoacaoSangue;
GO

-- =====================================================
-- DADOS INICIAIS - TIPO SANGUÍNEO
-- =====================================================

INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('A', '+');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('A', '-');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('B', '+');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('B', '-');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('AB', '+');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('AB', '-');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('O', '+');
INSERT INTO TipoSanguineo (grupo_sanguineo, fator_rh) VALUES ('O', '-');
GO


-- =====================================================
-- DADOS INICIAIS - UTILIZADORES
-- =====================================================

INSERT INTO Utilizador
(nome, apelido, sexo, data_nascimento, telefone, email, palavra_passe, endereco, tipo_utilizador)
VALUES
('Leonilde','Mugabe','F','2002-04-18','841234567','leonilde@doasangue.mz','123456','Maputo','Administrador'),

('Carlos','Mabunda','M','1998-06-12','842345678','carlos@doasangue.mz','123456','Maputo','Dador'),

('Anabela','Cumbe','F','1995-03-22','843456789','anabela@doasangue.mz','123456','Maputo','Dador'),

('Joel','Manhique','M','1999-09-30','844567890','joel@doasangue.mz','123456','Maputo','Dador'),

('Hospital','Central de Maputo','M','1980-01-01','21357900','info@hcm.gov.mz','123456','Maputo','Hospital'),

('Hospital','José Macamo','M','1980-01-01','21405292','macamo@misau.gov.mz','123456','Maputo','Hospital');
GO


-- =====================================================
-- DADOS INICIAIS - HOSPITAIS
-- =====================================================

INSERT INTO Hospital
(nome_hospital, provincia, distrito, endereco, telefone, email) VALUES
('Hospital Central de Maputo','Cidade de Maputo','KaMpfumo','Avenida Agostinho Neto, nº 164','21357900','info@hcm.gov.mz'),

('Hospital Geral José Macamo','Cidade de Maputo','KaMubukwana','Avenida OUA, nº 1033','21405292','macamo@misau.gov.mz'),

('Hospital Geral de Mavalane','Cidade de Maputo','KaMubukwana','Avenida FPLM, nº 2260','21460034','ugea.hgmavalane@misau.gov.mz');
GO

INSERT INTO Dador
(id_utilizador, id_tipo_sanguineo, peso, cidade, bairro, ultima_doacao, disponibilidade)
VALUES
(2, 8, 72.50, 'Maputo', 'Malhangalene', '2026-07-15', 1),
(3, 1, 60.80, 'Maputo', 'Magoanine', '2026-06-10', 1),
(4, 5, 81.20, 'Maputo', 'Alto-Maé', NULL, 1);