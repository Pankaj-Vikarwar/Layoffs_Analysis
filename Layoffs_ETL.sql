-- Creating database.

CREATE DATABASE layoffs;  

-- Using that database we just created.

USE layoffs;  

SELECT *
FROM layoffs_raw;

-- Making duplicate table.

CREATE TABLE layoffs_1  
LIKE layoffs_raw;

SELECT *
FROM layoffs_1;

-- Copying all records from other table with raw data.

INSERT layoffs_1  
SELECT *
FROM layoffs_raw;

-- Checking which one are duplicates rows.

SELECT *,  
ROW_NUMBER() OVER(PARTITION BY
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
)
AS srl_num
FROM layoffs_1;

CREATE TABLE `layoffs_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `srl_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_2;

-- Made new table with serial number column.

INSERT INTO layoffs_2  
SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
)
FROM layoffs_1;

SELECT *
FROM layoffs_2
WHERE srl_num > 1;

-- Checking duplicate records only.

SELECT *  
FROM layoffs_2
WHERE srl_num > 1;

SET SQL_SAFE_UPDATES = 0;

-- Deleted duplicate rows.

DELETE  
FROM layoffs_2
WHERE srl_num > 1;

SELECT *
FROM layoffs_2;

-- Standardizing Data

-- Removed extra spaces in company column.
 
UPDATE layoffs_2 
SET company = TRIM(company);

-- Assigning correct information in columns.

SELECT DISTINCT industry
FROM layoffs_2 ORDER BY 1;

UPDATE layoffs_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_2 ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_2 ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM COUNTRY)
FROM layoffs_2 ORDER BY 1;

UPDATE layoffs_2
SET country = TRIM(TRAILING '.' FROM COUNTRY);

-- Assigning correct data types to column

SELECT `date`
FROM layoffs_2;

UPDATE layoffs_2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_2;

-- Filling the Null or empty fields with data

SELECT *
FROM layoffs_2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_2
WHERE industry IS NULL
OR industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_2 t1
JOIN layoffs_2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL 
OR t1.industry IS NOT NULL;

UPDATE layoffs_2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_2 t1
JOIN layoffs_2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * FROM layoffs_2
WHERE industry IS NULL;

SELECT * 
FROM layoffs_2
WHERE company = 'juul';

-- Delete records with no data on specific columns and have no purpose.

DELETE 
FROM layoffs_2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Removing unecessary column.alter

ALTER TABLE layoffs_2
DROP COLUMN srl_num;

SELECT *
FROM layoffs_2;

















































