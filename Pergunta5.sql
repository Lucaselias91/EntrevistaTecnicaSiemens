SELECT  a.nome as nome,
		n.nota,
		a.valor  
FROM alunos a 
JOIN notas n 
  ON a.valor BETWEEN n.valor_min AND n.valor_max
WHERE n.nota >= 8 
ORDER BY n.nota desc, a.nome asc
UNION 
SELECT  NULL,
		n.nota,
		a.valor  
FROM alunos a 
JOIN notas n 
  ON a.valor BETWEEN n.valor_min AND n.valor_max
WHERE n.nota < 8 
ORDER BY n.nota desc, a.valor asc;