-- EDA - Análise Exploratória de Dados

-- Aqui vamos apenas explorar os dados para encontrar tendências, padrões ou qualquer item interessante, como outliers (dados fora da curva).


SELECT * FROM world_layoffs.layoffs_staging2;

-- CONSULTAS SIMPLES

-- Busca o valor máximo de demissões registrado em um único dia
SELECT MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Analisando a Porcentagem para entender o tamanho dessas demissões
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Quais empresas demitiram "1", o que significa basicamente 100% da força de trabalho
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;
-- Pelo que parece, são em sua maioria startups que fecharam as portas durante este período.

-- Se ordenarmos por 'funds_raised_millions', podemos ver o tamanho de algumas dessas empresas
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- Me chamou atenção: Britishvolt, captaram cerca de 2.4 bilhões e faliram - prejuízo pesado.


-- CONSULTAS INTERMEDIÁRIAS (Utilizando principalmente GROUP BY) --------------------------------------------------------------------------------------------------

-- Empresas com a maior demissão registrada em um único layoff
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY 2 DESC
LIMIT 5;

-- Empresas com o maior volume total de layoffs
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Layoffs por location (cidade/estado)
SELECT location, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- Total de layoffs por país (nos últimos 3 anos ou conforme o dataset)
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total de layoffs por ano
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

-- Total de layoffs por setor (indústria)
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total de layoffs por estágio da empresa (Series A, B, Post-IPO, etc)
-- No final do código vou deixar um comentário explicando sobre o que cada estágio significa, levando em conta que eu não sabia sobre esses termos
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- CONSULTAS AVANÇADAS ------------------------------------------------------------------------------------------------------------------------------------

-- Anteriormente vimos as empresas com mais demissões. Agora vamos olhar isso por ano. É um pouco mais complexo.
-- 1. RANKING DAS TOP 3 EMPRESAS QUE MAIS DEMITIRAM POR ANO
-- Esta consulta é complexa pois exige dois níveis de agregação: primeiro por ano/empresa, depois o ranking.

-- Definimos a primeira CTE 'Company_Year' para consolidar os dados brutos de demissões por empresa e ano.
WITH Company_Year AS  
(
SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(date)
), 

-- Criamos a segunda CTE 'Company_Year_Rank' baseada na primeira. 
-- O objetivo aqui é aplicar a função DENSE_RANK() para criar o ranking dentro de cada "partição" (ano).
Company_Year_Rank AS (
SELECT company, years, total_laid_off, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL -- Remove registros sem data definida para não sujar o ranking
)

-- Agora selecionamos os dados da CTE de ranking, filtrando apenas o Top 3
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
ORDER BY years ASC, total_laid_off DESC;


-- ------------------------------------------------------------------------------------------------------------------

-- 2. TOTAL ACUMULADO (ROLLING TOTAL) DE DEMISSÕES POR MÊS
-- Aqui queremos ver o total de layoffs do mês atual somado a todos os meses anteriores.

-- Primeiro, isolamos o total de layoffs por mês/ano em uma CTE chamada 'DATE_CTE'.
WITH DATE_CTE AS  
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL -- Garante que meses nulos não entrem no cálculo
GROUP BY dates
ORDER BY dates ASC
)

-- No SELECT final, usamos a Window Function SUM(...) OVER() para criar o acumulado.
-- O 'ORDER BY dates ASC' dentro do OVER garante que a soma siga a linha do tempo corretamente.
SELECT dates, total_laid_off, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;