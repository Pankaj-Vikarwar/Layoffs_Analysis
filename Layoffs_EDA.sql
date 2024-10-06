CREATE TABLE layoffs_cleaned
SELECT * FROM layoffs_2;

-- Sorting by date

SELECT * 
FROM layoffs_cleaned ORDER By `date`;

-- Top 10 laidoff companies by percentage

SELECT * 
FROM layoffs_cleaned
WHERE percentage_laid_off <1
ORDER BY percentage_laid_off DESC
LIMIT 10;

-- Company with maximum laidoff

SELECT * 
FROM layoffs_cleaned
WHERE total_laid_off = 
( 
SELECT MAX(total_laid_off)
 FROM layoffs_cleaned
 );
 
 -- Liquidated companies with 100% laidoff
 
 -- Sorting by company size
 
SELECT * 
FROM layoffs_cleaned
WHERE percentage_laid_off = 
( 
SELECT MAX(percentage_laid_off)
 FROM layoffs_cleaned
 )
 ORDER BY total_laid_off DESC;
 
 -- Sorting by funding
 
SELECT * 
FROM layoffs_cleaned
WHERE percentage_laid_off = 
( 
SELECT MAX(percentage_laid_off)
 FROM layoffs_cleaned
 )
 ORDER BY funds_raised_millions DESC;
 
-- Total laidoffs by companies

SELECT company, SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company
ORDER BY 2 DESC;

-- Total laidoff of timeline

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_cleaned;

-- Duration of Laidoff in companies

SELECT company, SUM(total_laid_off), MIN(`date`), MAX(`date`)
FROM layoffs_cleaned
GROUP BY company
ORDER BY 2 DESC;

-- Total laidoffs by industry type

SELECT industry, SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY industry
ORDER BY 2 DESC;

-- Total laidoffs by country

SELECT country, SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY country
ORDER BY 2 DESC;

-- Total laid of by Year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- Total laid of by Stage of company in

SELECT stage, SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY stage
ORDER BY 2 DESC;

-- Month Over Month Layoffs

WITH MOM_cte AS (
SELECT SUBSTRING(`date`,1,7) `Month`, SUM(total_laid_off) total_laidoffs
FROM layoffs_cleaned
WHERE SUBSTRING(`date`,6,2) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_laidoffs, SUM(total_laidoffs) OVER(ORDER BY `Month`) MOM_laidoffs
FROM MOM_cte;

-- layoffs by companies each year

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
WHERE total_laid_off IS NOT NULL
GROUP BY company, YEAR(`date`)
ORDER BY 1,2;

-- Ranking the laidoff by companies each year

WITH Company_CTE (Company, `Year`, total_laid_off) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) `Rank`
FROM Company_CTE
WHERE `Year` IS NOT NULL
ORDER BY `Rank`;

-- Top 5 laidoffs companies by Years

WITH Company_CTE (Company, `Year`, total_laid_off) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
),
Company_CTE_2 AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) `Rank`
FROM Company_CTE
WHERE `Year` IS NOT NULL
)
SELECT *
FROM Company_CTE_2
WHERE `Rank` <= 5;

-- Top 5 laidoffs industry by Years

WITH industry_CTE (industry, `Year`, total_laid_off) AS (
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_cleaned
GROUP BY industry, YEAR(`date`)
),
industry_CTE_2 AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) `Rank`
FROM industry_CTE
WHERE `Year` IS NOT NULL
)
SELECT *
FROM industry_CTE_2
WHERE `Rank` <= 5;
















 
 
 
