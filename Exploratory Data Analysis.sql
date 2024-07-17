-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

/* Maximum number of laid_off and the percentage*/
SELECT MAX(total_laid_off) AS MAX_Laid_off,
		MAX(percentage_laid_off) AS Percent_laid_off
FROM layoffs_staging2;

/*Sum of laid_off by Company*/
SELECT company, SUM(total_laid_off) AS Total_laidoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY Total_laidoffs DESC;

/*Amazon had the highest sum of laid offs with a total of 27,840 SHOCKING*/

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) AS Total_laidoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY Total_laidoffs DESC;

/*This shows that the retail industry had the highest amount of laid offs*/

SELECT country, SUM(total_laid_off) AS Total_laidoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY Total_laidoffs DESC;
/*This shows that United States had the highest amount of laid offs*/

SELECT YEAR(`date`) AS `YEAR`, SUM(total_laid_off)AS Total_laidoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY Total_laidoffs DESC;
/*This shows the Years with the total amount of laid offs*/

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY `Month`;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS Total_laidoffs
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
)
SELECT `Month`,Total_laidoffs, SUM(Total_laidoffs) OVER(ORDER BY `Month`) AS RollingTotal
FROM Rolling_Total;


/*Grouping By Year*/
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS Total_layoff
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC;

WITH Company_year AS
(
SELECT company, YEAR(`date`) AS `Year`, SUM(total_laid_off) AS Total_layoff
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
Company_Year_Rank AS(
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year` ORDER BY Total_layoff DESC) AS Ranking
FROM Company_year
WHERE `Year` IS NOT NULL
/*ORDER BY Ranking ASC*/
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

