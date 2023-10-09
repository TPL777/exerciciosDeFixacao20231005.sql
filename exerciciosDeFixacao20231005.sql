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

