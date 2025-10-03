-- QUESTÃO 1: nome do curso, número e data de início de cada turma de cada curso.

SELECT tb_curso.nome AS curso, tb_turma.numero AS turma, tb_turma.inicio 
FROM tb_curso 
INNER JOIN tb_turma ON tb_curso.id = tb_turma.curso_id;

-- QUESTÃO 2: nome do curso, número da turma, nome e CPF dos alunos de cada curso e cada turma. 
-- Os nomes das colunas devem ser curso, turma, aluno e cpf.

SELECT curso, turma, aluno, cpf
FROM
	(
		SELECT tb_curso.nome AS curso, *
		FROM
		(
			SELECT tb_turma.numero AS turma, * 
				FROM
				(
					SELECT tb_aluno.nome AS aluno, *
					FROM tb_matricula 
					INNER JOIN tb_aluno ON tb_matricula.aluno_id = tb_aluno.cpf
				)
				AS juncao_aluno_matricula 
				INNER JOIN tb_turma ON tb_turma.id = juncao_aluno_matricula.turma_id
		) AS juncao_aluno_matricula_turma
		INNER JOIN tb_curso ON tb_curso.id = juncao_aluno_matricula_turma.curso_id
	) AS juncao_aluno_matricula_turma_curso
	

--QUESTÃO 3: listagem de data e nota de todas avaliações já ocorridas, juntamente com
--nome, nota obtida por cada aluno em cada avaliação, e também qual a porcentagem de
--nota obtida em relação à nota da avaliação. Os resultados devem estar ordenados da
--avaliação mais recente para a mais antiga, e, para cada avaliação, os nomes dos alunos
--devem estar ordenados em ordem crescente. A porcentagem deve ter duas casas decimais.

SELECT data, nota, nome, nota_obtida, ROUND(((nota_obtida / nota) * 100), 2) AS porcentagem
FROM
(
	SELECT *
	FROM tb_avaliacao 
	INNER JOIN tb_resultado ON tb_resultado.avaliacao_id = tb_avaliacao.id
) AS juncao_avaliacao_resultado
INNER JOIN tb_aluno ON juncao_avaliacao_resultado.aluno_id = tb_aluno.cpf
ORDER BY data DESC, nome

--QUESTÃO 4 : nome e nota total dos alunos da turma 10 
--(ATENÇÃO: você deve restringir a turma pelo número 10 dela, e não pelo id 2).

SELECT nome, SUM(nota_obtida) AS total
FROM
(
	SELECT * 
	FROM
	(
		SELECT *
		FROM tb_aluno
		INNER JOIN tb_resultado ON tb_aluno.cpf = tb_resultado.aluno_id
	) AS juncao_resultado_aluno
	INNER JOIN tb_avaliacao ON juncao_resultado_aluno.avaliacao_id = tb_avaliacao.id
) AS juncao_resultado_aluno_avaliacao
INNER JOIN tb_turma ON juncao_resultado_aluno_avaliacao.turma_id = tb_turma.id
WHERE numero = 10
GROUP BY(nome)