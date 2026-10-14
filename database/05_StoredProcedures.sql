/*
 Sistema de Gestão de Doação de Sangue
 Script: 05_StoredProcedures.sql
 Responsável: Oslerson Abílio Muveca
 Tecnologia: Microsoft SQL Server
*/

CREATE OR ALTER PROCEDURE pa_RegistarUtilizador
    @nome VARCHAR(50),
    @apelido VARCHAR(50),
    @sexo CHAR(1),
    @data_nascimento DATE,
    @telefone VARCHAR(15),
    @email VARCHAR(100),
    @palavra_passe VARCHAR(255),
    @endereco VARCHAR(150),
    @tipo_utilizador VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE email = @email
    )
    BEGIN
        SELECT 'Já existe um utilizador com este e-mail.' AS mensagem;
        RETURN;
    END;

    INSERT INTO Utilizador (
        nome,
        apelido,
        sexo,
        data_nascimento,
        telefone,
        email,
        palavra_passe,
        endereco,
        tipo_utilizador
    )
    VALUES (
        @nome,
        @apelido,
        @sexo,
        @data_nascimento,
        @telefone,
        @email,
        @palavra_passe,
        @endereco,
        @tipo_utilizador
    );

    SELECT 'Utilizador registado com sucesso.' AS mensagem;
END;
GO

/*segunda procedure para registar dadoe*/

CREATE OR ALTER PROCEDURE pa_RegistarDador
    @id_utilizador INT,
    @id_tipo_sanguineo INT,
    @peso DECIMAL(5,2),
    @cidade VARCHAR(100),
    @bairro VARCHAR(100),
    @ultima_doacao DATE = NULL,
    @disponibilidade BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Utilizador não encontrado.' AS mensagem;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM Dador
        WHERE id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Este utilizador já está registado como dador.' AS mensagem;
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Tipo sanguíneo não encontrado.' AS mensagem;
        RETURN;
    END;

    INSERT INTO Dador (
        id_utilizador,
        id_tipo_sanguineo,
        peso,
        cidade,
        bairro,
        ultima_doacao,
        disponibilidade
    )
    VALUES (
        @id_utilizador,
        @id_tipo_sanguineo,
        @peso,
        @cidade,
        @bairro,
        @ultima_doacao,
        @disponibilidade
    );

    SELECT 'Dador registado com sucesso.' AS mensagem;
END;
GO

/* terceira procedure para registar doacao*/

CREATE OR ALTER PROCEDURE pa_RegistarDoacao
    @id_dador INT,
    @id_hospital INT,
    @data_doacao DATE,
    @quantidade DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Dador
        WHERE id_dador = @id_dador
    )
    BEGIN
        SELECT 'Dador não encontrado.' AS mensagem;
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM Hospital
        WHERE id_hospital = @id_hospital
    )
    BEGIN
        SELECT 'Hospital não encontrado.' AS mensagem;
        RETURN;
    END;

    IF @quantidade <= 0
    BEGIN
        SELECT 'A quantidade de sangue deve ser superior a zero.' AS mensagem;
        RETURN;
    END;

    INSERT INTO Doacao (
        id_dador,
        id_hospital,
        data_doacao,
        quantidade
    )
    VALUES (
        @id_dador,
        @id_hospital,
        @data_doacao,
        @quantidade
    );

    UPDATE Dador
    SET ultima_doacao = @data_doacao
    WHERE id_dador = @id_dador;

    SELECT 'Doação registada com sucesso.' AS mensagem;
END;
GO


/* quarta procedure para registar pedido de sangue*/
CREATE OR ALTER PROCEDURE pa_RegistarPedidoSangue
    @id_hospital INT,
    @id_tipo_sanguineo INT,
    @quantidade_bolsas INT,
    @urgencia VARCHAR(20),
    @data_pedido DATE,
    @estado VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Hospital
        WHERE id_hospital = @id_hospital
    )
    BEGIN
        SELECT 'Hospital não encontrado.' AS mensagem;
        RETURN;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Tipo sanguíneo não encontrado.' AS mensagem;
        RETURN;
    END;

    IF @quantidade_bolsas <= 0
    BEGIN
        SELECT 'A quantidade de bolsas deve ser superior a zero.' AS mensagem;
        RETURN;
    END;

    INSERT INTO PedidoDeSangue (
        id_hospital,
        id_tipo_sanguineo,
        quantidade_bolsas,
        urgencia,
        data_pedido,
        estado
    )
    VALUES (
        @id_hospital,
        @id_tipo_sanguineo,
        @quantidade_bolsas,
        @urgencia,
        @data_pedido,
        @estado
    );

    SELECT 'Pedido de sangue registado com sucesso.' AS mensagem;
END;
GO

/* quinta procedure para registar campanha de doacao de sangue*/

CREATE OR ALTER PROCEDURE pa_RegistarCampanha
    @id_hospital INT,
    @titulo VARCHAR(150),
    @descricao VARCHAR(MAX),
    @local VARCHAR(150),
    @data DATE,
    @hora TIME
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Hospital
        WHERE id_hospital = @id_hospital
    )
    BEGIN
        SELECT 'Hospital não encontrado.' AS mensagem;
        RETURN;
    END;

    IF @data < CAST(GETDATE() AS DATE)
    BEGIN
        SELECT 'A data da campanha não pode estar no passado.' AS mensagem;
        RETURN;
    END;

    INSERT INTO Campanha (
        id_hospital,
        titulo,
        descricao,
        local,
        data,
        hora
    )
    VALUES (
        @id_hospital,
        @titulo,
        @descricao,
        @local,
        @data,
        @hora
    );

    SELECT 'Campanha registada com sucesso.' AS mensagem;
END;
GO

/* sexta procedure para registar notificacao*/

CREATE OR ALTER PROCEDURE pa_RegistarNotificacao
    @id_utilizador INT,
    @mensagem VARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Utilizador não encontrado.' AS mensagem;
        RETURN;
    END;

    INSERT INTO Notificacao (
        id_utilizador,
        mensagem,
        data_envio,
        lida
    )
    VALUES (
        @id_utilizador,
        @mensagem,
        GETDATE(),
        0
    );

    SELECT 'Notificação registada com sucesso.' AS mensagem;
END;
GO

/* sétima procedure para actualizar estado do pedido de sangue*/

CREATE OR ALTER PROCEDURE pa_ActualizarEstadoPedido
    @id_pedido INT,
    @estado VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM PedidoDeSangue
        WHERE id_pedido = @id_pedido
    )
    BEGIN
        SELECT 'Pedido de sangue não encontrado.' AS mensagem;
        RETURN;
    END;

    UPDATE PedidoDeSangue
    SET estado = @estado
    WHERE id_pedido = @id_pedido;

    SELECT 'Estado do pedido actualizado com sucesso.' AS mensagem;
END;
GO

/* oitava procedure para consultar dadores disponiveis*/

CREATE OR ALTER PROCEDURE pa_ConsultarDadoresDisponiveis
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.nome,
        U.apelido,
        TS.grupo_sanguineo,
        TS.fator_rh,
        U.telefone,
        D.cidade,
        D.bairro
    FROM Dador D
    INNER JOIN Utilizador U
        ON D.id_utilizador = U.id_utilizador
    INNER JOIN TipoSanguineo TS
        ON D.id_tipo_sanguineo = TS.id_tipo_sanguineo
    WHERE D.disponibilidade = 1
    ORDER BY U.nome, U.apelido;
END;
GO

/* nona procedure para actualizar dados do dador*/

CREATE OR ALTER PROCEDURE pa_ActualizarDador
    @id_dador INT,
    @id_tipo_sanguineo INT,
    @peso DECIMAL(5,2),
    @cidade VARCHAR(100),
    @bairro VARCHAR(100),
    @ultima_doacao DATE = NULL,
    @disponibilidade BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Dador
        WHERE id_dador = @id_dador
    )
    BEGIN
        THROW 50001, 'Dador nao encontrado.', 1;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        THROW 50002, 'Tipo sanguineo nao encontrado.', 1;
    END;

    IF @peso IS NULL OR @peso <= 0
    BEGIN
        THROW 50003, 'O peso deve ser superior a zero.', 1;
    END;

    UPDATE Dador
    SET
        id_tipo_sanguineo = @id_tipo_sanguineo,
        peso = @peso,
        cidade = @cidade,
        bairro = @bairro,
        ultima_doacao = @ultima_doacao,
        disponibilidade = @disponibilidade
    WHERE id_dador = @id_dador;

    SELECT 'Dador actualizado com sucesso.' AS mensagem;
END;
GO

/* décima procedure para pesquisar dador por tipo sanguineo*/

CREATE OR ALTER PROCEDURE pa_PesquisarDadorPorTipoSanguineo
    @id_tipo_sanguineo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        THROW 50004, 'Tipo sanguineo nao encontrado.', 1;
    END;

    SELECT
        D.id_dador,
        U.nome,
        U.apelido,
        TS.grupo_sanguineo,
        TS.fator_rh,
        U.telefone,
        D.cidade,
        D.bairro,
        D.disponibilidade
    FROM Dador D
    INNER JOIN Utilizador U
        ON D.id_utilizador = U.id_utilizador
    INNER JOIN TipoSanguineo TS
        ON D.id_tipo_sanguineo = TS.id_tipo_sanguineo
    WHERE D.id_tipo_sanguineo = @id_tipo_sanguineo
    ORDER BY U.nome, U.apelido;
END;
GO

/* décima primeira procedure para actualizar disponibilidade do dador*/

CREATE OR ALTER PROCEDURE pa_ActualizarDisponibilidadeDador
    @id_dador INT,
    @disponibilidade BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Dador
        WHERE id_dador = @id_dador
    )
    BEGIN
        THROW 50005, 'Dador nao encontrado.', 1;
    END;

    UPDATE Dador
    SET disponibilidade = @disponibilidade
    WHERE id_dador = @id_dador;

    SELECT 'Disponibilidade do dador actualizada com sucesso.' AS mensagem;
END;
GO

/* décima segunda procedure para listar pedidos de sangue pendentes*/

CREATE OR ALTER PROCEDURE pa_ListarPedidosPendentes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.id_pedido,
        H.nome_hospital,
        TS.grupo_sanguineo,
        TS.fator_rh,
        P.quantidade_bolsas,
        P.urgencia,
        P.data_pedido,
        P.estado
    FROM PedidoDeSangue P
    INNER JOIN Hospital H
        ON P.id_hospital = H.id_hospital
    INNER JOIN TipoSanguineo TS
        ON P.id_tipo_sanguineo = TS.id_tipo_sanguineo
    WHERE P.estado = 'Pendente'
    ORDER BY
        CASE
            WHEN P.urgencia = 'Alta' THEN 1
            WHEN P.urgencia = 'Media' THEN 2
            WHEN P.urgencia = 'Baixa' THEN 3
            ELSE 4
        END,
        P.data_pedido ASC;
END;
GO

/* décima terceira procedure para listar doacoes por dador*/

CREATE OR ALTER PROCEDURE pa_ListarDoacoesPorDador
    @id_dador INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Dador
        WHERE id_dador = @id_dador
    )
    BEGIN
        THROW 50006, 'Dador nao encontrado.', 1;
    END;

    SELECT
        D.id_doacao,
        U.nome,
        U.apelido,
        H.nome_hospital,
        D.data_doacao,
        D.quantidade
    FROM Doacao D
    INNER JOIN Dador DA
        ON D.id_dador = DA.id_dador
    INNER JOIN Utilizador U
        ON DA.id_utilizador = U.id_utilizador
    INNER JOIN Hospital H
        ON D.id_hospital = H.id_hospital
    WHERE D.id_dador = @id_dador
    ORDER BY D.data_doacao DESC;
END;
GO

/* décima quarta procedure para listar campanhas de doacao de sangue*/

CREATE OR ALTER PROCEDURE pa_ListarCampanhas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.id_campanha,
        H.nome_hospital,
        C.titulo,
        C.descricao,
        C.local,
        C.data,
        C.hora
    FROM Campanha C
    INNER JOIN Hospital H
        ON C.id_hospital = H.id_hospital
    ORDER BY C.data ASC, C.hora ASC;
END;
GO

/* décima quinta procedure para autenticar utilizador*/

CREATE OR ALTER PROCEDURE pa_AutenticarUtilizador
    @email VARCHAR(100),
    @palavra_passe VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE email = @email
          AND palavra_passe = @palavra_passe
    )
    BEGIN
        SELECT
            id_utilizador,
            nome,
            apelido,
            email,
            tipo_utilizador,
            'Autenticacao efectuada com sucesso.' AS mensagem
        FROM Utilizador
        WHERE email = @email
          AND palavra_passe = @palavra_passe;
    END
    ELSE
    BEGIN
        SELECT
            'E-mail ou palavra-passe incorrectos.' AS mensagem;
    END;
END;
GO

/* décima sexta procedure para consultar utilizador por id*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ConsultarUtilizador
    @id_utilizador INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Utilizador não encontrado.' AS mensagem;
        RETURN;
    END;

    SELECT
        id_utilizador,
        nome,
        apelido,
        sexo,
        data_nascimento,
        telefone,
        email,
        endereco,
        tipo_utilizador
    FROM Utilizador
    WHERE id_utilizador = @id_utilizador;
END;
GO

/* décima sétima procedure para actualizar dados do utilizador*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ActualizarUtilizador
    @id_utilizador INT,
    @nome VARCHAR(50),
    @apelido VARCHAR(50),
    @sexo CHAR(1),
    @data_nascimento DATE,
    @telefone VARCHAR(15),
    @email VARCHAR(100),
    @palavra_passe VARCHAR(255),
    @endereco VARCHAR(150),
    @tipo_utilizador VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Utilizador não encontrado.' AS mensagem;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE email = @email
          AND id_utilizador <> @id_utilizador
    )
    BEGIN
        SELECT 'Já existe outro utilizador com este e-mail.' AS mensagem;
        RETURN;
    END;

    UPDATE Utilizador
    SET
        nome = @nome,
        apelido = @apelido,
        sexo = @sexo,
        data_nascimento = @data_nascimento,
        telefone = @telefone,
        email = @email,
        palavra_passe = @palavra_passe,
        endereco = @endereco,
        tipo_utilizador = @tipo_utilizador
    WHERE id_utilizador = @id_utilizador;

    SELECT 'Utilizador actualizado com sucesso.' AS mensagem;
END;
GO


/* décima oitava procedure para consultar notificacoes do utilizador*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ConsultarNotificacoes
    @id_utilizador INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Utilizador
        WHERE id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Utilizador não encontrado.' AS mensagem;
        RETURN;
    END;

    SELECT
        id_notificacao,
        mensagem,
        data_envio,
        lida
    FROM Notificacao
    WHERE id_utilizador = @id_utilizador
    ORDER BY data_envio DESC;
END;
GO

/* décima nona procedure para marcar notificacao como lida*/


USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_MarcarNotificacaoComoLida
    @id_notificacao INT,
    @id_utilizador INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Notificacao
        WHERE id_notificacao = @id_notificacao
          AND id_utilizador = @id_utilizador
    )
    BEGIN
        SELECT 'Notificação não encontrada para este utilizador.' AS mensagem;
        RETURN;
    END;

    UPDATE Notificacao
    SET lida = 1
    WHERE id_notificacao = @id_notificacao
      AND id_utilizador = @id_utilizador;

    SELECT 'Notificação marcada como lida com sucesso.' AS mensagem;
END;
GO


/* vigésima procedure para consultar pedidos de sangue por hospital e estado*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ConsultarPedidosSangue
    @id_hospital INT = NULL,
    @estado VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.id_pedido,
        H.nome_hospital,
        TS.grupo_sanguineo,
        TS.fator_rh,
        P.quantidade_bolsas,
        P.urgencia,
        P.data_pedido,
        P.estado
    FROM PedidoDeSangue P
    INNER JOIN Hospital H
        ON P.id_hospital = H.id_hospital
    INNER JOIN TipoSanguineo TS
        ON P.id_tipo_sanguineo = TS.id_tipo_sanguineo
    WHERE
        (@id_hospital IS NULL OR P.id_hospital = @id_hospital)
        AND (@estado IS NULL OR P.estado = @estado)
    ORDER BY P.data_pedido DESC;
END;
GO


/* vigésima primeira procedure para registar hospital*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_RegistarHospital
    @nome_hospital VARCHAR(100),
    @provincia VARCHAR(50),
    @distrito VARCHAR(50),
    @endereco VARCHAR(150),
    @telefone VARCHAR(15),
    @email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Hospital
        WHERE email = @email
    )
    BEGIN
        SELECT 'Já existe um hospital com este e-mail.' AS mensagem;
        RETURN;
    END;

    INSERT INTO Hospital (
        nome_hospital,
        provincia,
        distrito,
        endereco,
        telefone,
        email
    )
    VALUES (
        @nome_hospital,
        @provincia,
        @distrito,
        @endereco,
        @telefone,
        @email
    );

    SELECT 'Hospital registado com sucesso.' AS mensagem;
END;
GO

/* vigésima segunda procedure para consultar hospitais*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ConsultarHospitais
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        id_hospital,
        nome_hospital,
        provincia,
        distrito,
        endereco,
        telefone,
        email
    FROM Hospital
    ORDER BY nome_hospital ASC;
END;
GO


/* vigésima terceira procedure para actualizar hospital*/
CREATE OR ALTER PROCEDURE pa_ActualizarHospital
    @id_hospital INT,
    @nome_hospital VARCHAR(100),
    @provincia VARCHAR(50),
    @distrito VARCHAR(50),
    @endereco VARCHAR(150),
    @telefone VARCHAR(15),
    @email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Hospital
        WHERE id_hospital = @id_hospital
    )
    BEGIN
        THROW 50001, 'Hospital não encontrado.', 1;
    END;

    UPDATE Hospital
    SET nome_hospital = @nome_hospital,
        provincia = @provincia,
        distrito = @distrito,
        endereco = @endereco,
        telefone = @telefone,
        email = @email
    WHERE id_hospital = @id_hospital;

    SELECT 'Hospital actualizado com sucesso.' AS Mensagem;
END;
GO

/* vigésima quarta procedure para remover hospital*/

USE BD_DoacaoSangue;

CREATE OR ALTER PROCEDURE pa_RemoverHospital
    @id_hospital INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM Hospital
        WHERE id_hospital = @id_hospital
    )
    BEGIN
        THROW 50001, 'Hospital não encontrado.', 1;
    END;

    DELETE FROM Hospital
    WHERE id_hospital = @id_hospital;

    SELECT 'Hospital removido com sucesso.' AS Mensagem;
END;
GO


/* vigésima quinta procedure para registar tipo sanguineo*/
USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_RegistarTipoSanguineo
    @grupo_sanguineo VARCHAR(5),
    @fator_rh VARCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE grupo_sanguineo = @grupo_sanguineo
          AND fator_rh = @fator_rh
    )
    BEGIN
        SELECT 'Este tipo sanguíneo já está registado.' AS mensagem;
        RETURN;
    END;

    INSERT INTO TipoSanguineo (
        grupo_sanguineo,
        fator_rh
    )
    VALUES (
        @grupo_sanguineo,
        @fator_rh
    );

    SELECT 'Tipo sanguíneo registado com sucesso.' AS mensagem;
END;
GO

/* vigésima sexta procedure para consultar tipos sanguineos*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ConsultarTiposSanguineos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        id_tipo_sanguineo,
        grupo_sanguineo,
        fator_rh
    FROM TipoSanguineo
    ORDER BY grupo_sanguineo ASC, fator_rh ASC;
END;
GO

/* vigésima sétima procedure para Actualizar o tipo Sanguineo*/

USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_ActualizarTipoSanguineo
    @id_tipo_sanguineo INT,
    @grupo_sanguineo VARCHAR(5),
    @fator_rh VARCHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Tipo sanguíneo não encontrado.' AS mensagem;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE grupo_sanguineo = @grupo_sanguineo
          AND fator_rh = @fator_rh
          AND id_tipo_sanguineo <> @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Este tipo sanguíneo já está registado.' AS mensagem;
        RETURN;
    END;

    UPDATE TipoSanguineo
    SET grupo_sanguineo = @grupo_sanguineo,
        fator_rh = @fator_rh
    WHERE id_tipo_sanguineo = @id_tipo_sanguineo;

    SELECT 'Tipo sanguíneo actualizado com sucesso.' AS mensagem;
END;
GO

/* vigésima oitava procedure para remover tipo sanguineo*/


USE BD_DoacaoSangue;
GO

CREATE OR ALTER PROCEDURE pa_RemoverTipoSanguineo
    @id_tipo_sanguineo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM TipoSanguineo
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Tipo sanguíneo não encontrado.' AS mensagem;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM Dador
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Não é possível remover este tipo sanguíneo porque está associado a dadores.' AS mensagem;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM PedidoDeSangue
        WHERE id_tipo_sanguineo = @id_tipo_sanguineo
    )
    BEGIN
        SELECT 'Não é possível remover este tipo sanguíneo porque está associado a pedidos de sangue.' AS mensagem;
        RETURN;
    END;

    DELETE FROM TipoSanguineo
    WHERE id_tipo_sanguineo = @id_tipo_sanguineo;

    SELECT 'Tipo sanguíneo removido com sucesso.' AS mensagem;
END;
GO
