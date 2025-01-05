USE world_layoffs;
SELECT * FROM layoffs_staging;

Insert layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging; 

WITH duplicate_CTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage,funds_raised_millions, country) AS row_num
    FROM layoffs_staging
)
SELECT * 
FROM duplicate_CTE 
WHERE row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
SELECT * FROM layoffs_staging;

Insert into layoffs_staging2 
SELECT *,ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage,funds_raised_millions, country) AS row_num
FROM layoffs_staging;	


ALTER TABLE layoffs_staging2
drop column row_num;

ALTER TABLE layoffs_staging2
add column row_num INT;

SELECT * FROM layoffs_staging2;


SELECT * FROM layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE ROW_NUM>1;


UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT DISTINCT company 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` IS NOT NULL;


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` date;

SELECT * FROM layoffs_staging2 
WHERE industry IS NULL OR industry ='';

UPDATE layoffs_staging2
SET industry = null
where industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.Company=t2.Company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS not NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;