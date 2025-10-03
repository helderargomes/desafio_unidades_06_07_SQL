create table tb_curso (
    id int4 not null,
    carga_horaria int4,
    nome varchar(255),
    nota_minima numeric,
    nota_prevista numeric,
    valor numeric,
    primary key (id)
);

create table tb_turma (
    id int4 not null,
    inicio date,
    numero int4,
    vagas int4,
    curso_id int4,
    primary key (id),
    foreign key (curso_id) references tb_curso
);

create table tb_aluno (
    cpf varchar(255) not null,
    nascimento date,
    nome varchar(255),
    primary key (cpf)
);

create table tb_matricula (
    data date,
    prestacoes int4,
    aluno_id varchar(255) not null,
    turma_id int4 not null,
    primary key (aluno_id, turma_id),
    foreign key (aluno_id) references tb_aluno,
    foreign key (turma_id) references tb_turma
);

create table tb_avaliacao (
    id int4 not null,
    data date,
    nota numeric,
    turma_id int4,
    primary key (id),
    foreign key (turma_id) references tb_turma
);

create table tb_resultado (
    nota_obtida numeric,
    aluno_id varchar(255) not null,
    avaliacao_id int4 not null,
    primary key (aluno_id, avaliacao_id),
    foreign key (aluno_id) references tb_aluno,
    foreign key (avaliacao_id) references tb_avaliacao
);

-- CURSO HTML
INSERT INTO tb_curso (id, nome, carga_horaria, valor, nota_prevista, nota_minima) VALUES (1, 'HTML Básico', 10, 80.0, 100.0, 70.0);

-- DUAS TURMAS PARA O CURSO HTML
INSERT INTO tb_turma (id, numero, inicio, vagas, curso_id) VALUES (1, 1, '2017-09-10', 30, 1);
INSERT INTO tb_turma (id, numero, inicio, vagas, curso_id) VALUES (2, 10, '2022-05-20', 30, 1);

-- QUATRO ALUNOS
INSERT INTO tb_aluno (cpf, nome, nascimento) VALUES ('736376983-19', 'Carlos Silva', '1990-07-21');
INSERT INTO tb_aluno (cpf, nome, nascimento) VALUES ('353847901-22', 'Maria Clara', '1991-09-03');
INSERT INTO tb_aluno (cpf, nome, nascimento) VALUES ('444123123-44', 'Ana Portes', '1995-05-21');
INSERT INTO tb_aluno (cpf, nome, nascimento) VALUES ('555098098-55', 'Pedro Tiago', '2001-10-15');

-- DUAS MATRICULAS NA TURMA 1, E TRES MATRICULAS NA TURMA 2
INSERT INTO tb_matricula (turma_id, aluno_id, data, prestacoes) VALUES (1, '736376983-19', '2017-09-05', 6);
INSERT INTO tb_matricula (turma_id, aluno_id, data, prestacoes) VALUES (1, '353847901-22', '2017-09-06', 12);

INSERT INTO tb_matricula (turma_id, aluno_id, data, prestacoes) VALUES (2, '736376983-19', '2022-05-13', 1);
INSERT INTO tb_matricula (turma_id, aluno_id, data, prestacoes) VALUES (2, '444123123-44', '2022-05-13', 6);
INSERT INTO tb_matricula (turma_id, aluno_id, data, prestacoes) VALUES (2, '555098098-55', '2022-05-15', 10);

-- DUAS AVALIACOES NA TURMA 1, E DUAS AVALIACOES NA TURMA 2
INSERT INTO tb_avaliacao (id, nota, data, turma_id) VALUES (1, 40.0, '2017-10-20', 1);
INSERT INTO tb_avaliacao (id, nota, data, turma_id) VALUES (2, 60.0, '2017-11-30', 1);

INSERT INTO tb_avaliacao (id, nota, data, turma_id) VALUES (3, 50.0, '2022-06-20', 2);
INSERT INTO tb_avaliacao (id, nota, data, turma_id) VALUES (4, 50.0, '2022-07-20', 2);

-- RESULTADOS PARA CADA ALUNO EM CADA AVALIACAO DA TURMA 1 
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('736376983-19', 1, 35.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('353847901-22', 1, 36.5);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('736376983-19', 2, 47.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('353847901-22', 2, 52.4);

-- RESULTADOS PARA CADA ALUNO EM CADA AVALIACAO DA TURMA 2
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('736376983-19', 3, 30.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('444123123-44', 3, 50.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('555098098-55', 3, 40.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('736376983-19', 4, 35.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('444123123-44', 4, 45.0);
INSERT INTO tb_resultado (aluno_id, avaliacao_id, nota_obtida) VALUES ('555098098-55', 4, 35.5);

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

SELECT 
CONCAT((EXTRACT(DAY FROM data)), '/', 
	   (
		   CASE 
		   WHEN EXTRACT(MONTH FROM data) < 10 THEN CONCAT('0', EXTRACT(MONTH FROM data))
		   ELSE CAST((EXTRACT(MONTH FROM data)) AS TEXT)
		   END
	   ), '/', 
	   EXTRACT(YEAR FROM data)) AS data,
nota, nome, nota_obtida, ROUND(((nota_obtida / nota) * 100), 2) AS porcentagem
FROM
(
	SELECT *
	FROM tb_avaliacao 
	INNER JOIN tb_resultado ON tb_resultado.avaliacao_id = tb_avaliacao.id
) AS juncao_avaliacao_resultado
INNER JOIN tb_aluno ON juncao_avaliacao_resultado.aluno_id = tb_aluno.cpf
ORDER BY (EXTRACT(YEAR FROM data), EXTRACT(MONTH FROM data), EXTRACT(DAY FROM data)) DESC, nome

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





	
	

