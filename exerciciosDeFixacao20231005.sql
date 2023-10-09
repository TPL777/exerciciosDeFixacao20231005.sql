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
