Função para Contagem de Livros por Gênero:
  
DELIMITER //

CREATE FUNCTION total_livros_por_genero(nome_genero VARCHAR(255)) RETURNS INT
BEGIN
    DECLARE total INT;
    SET total = 0;

    DECLARE done INT DEFAULT 0;
    DECLARE genre_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM Genero WHERE nome_genero = nome_genero;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    FETCH cur INTO genre_id;

    IF done = 0 THEN
        SELECT COUNT(*) INTO total FROM Livro WHERE id_genero = genre_id;
    END IF;

    CLOSE cur;

    RETURN total;
END //

DELIMITER ;

Função para Listar Livros de um Autor Específico:

DELIMITER //

CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255)) RETURNS TEXT
BEGIN
    DECLARE lista TEXT;
    SET lista = '';

    DECLARE done INT DEFAULT 0;
    DECLARE author_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM Autor WHERE primeiro_nome = primeiro_nome AND ultimo_nome = ultimo_nome;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    FETCH cur INTO author_id;

    IF done = 0 THEN
        SELECT GROUP_CONCAT(Livro.titulo SEPARATOR ', ') INTO lista
        FROM Livro_Autor
        JOIN Livro ON Livro_Autor.id_livro = Livro.id
        WHERE Livro_Autor.id_autor = author_id;
    END IF;

    CLOSE cur;

    RETURN lista;
END //

DELIMITER ;

Função para Atualizar Resumos de Livros:

DELIMITER //

CREATE FUNCTION atualizar_resumos()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livro_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM Livro;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    WHILE done = 0 DO
        FETCH cur INTO livro_id;
        UPDATE Livro SET resumo = CONCAT(resumo, ' Este é um excelente livro!') WHERE id = livro_id;
    END WHILE;

    CLOSE cur;
END //

DELIMITER ;

Função para Obter a Média de Livros por Editora:

DELIMITER //

CREATE FUNCTION media_livros_por_editora() RETURNS DECIMAL(10,2)
BEGIN
    DECLARE total_editoras INT;
    DECLARE total_livros INT;
    DECLARE media DECIMAL(10,2);

    SELECT COUNT(*) INTO total_editoras FROM Editora;
    SELECT COUNT(*) INTO total_livros FROM Livro;

    IF total_editoras > 0 THEN
        SET media = total_livros / total_editoras;
    ELSE
        SET media = 0;
    END IF;

    RETURN media;
END //

DELIMITER ;

Função para Listar Autores sem Livros Publicados:

DELIMITER //

CREATE FUNCTION autores_sem_livros() RETURNS TEXT
BEGIN
    DECLARE lista TEXT;
    SET lista = '';

    SELECT GROUP_CONCAT(CONCAT(primeiro_nome, ' ', ultimo_nome) SEPARATOR ', ')
    INTO lista
    FROM Autor
    WHERE id NOT IN (SELECT DISTINCT id_autor FROM Livro_Autor);

    RETURN lista;
END //

DELIMITER ;

 Pode-se chamar essas funções conforme necessário para obter os resultados desejados
EXEMPLO:

Para contar os livros de um gênero específico:
   
SELECT total_livros_por_genero('Romance');

Para listar os livros de um autor específico:

SELECT listar_livros_por_autor('João', 'Silva');

Para atualizar os resumos de todos os livros:

CALL atualizar_resumos();

Para obter a média de livros por editora:

SELECT media_livros_por_editora();

Para listar autores sem livros publicados:

SELECT autores_sem_livros();

