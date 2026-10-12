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

/*segunda procedure para registar dador*/

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
