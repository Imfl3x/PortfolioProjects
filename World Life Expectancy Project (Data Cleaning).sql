#World Life Expectancy Project (Data Cleaning)


SELECT * 
FROM world_life_expectancy
;

 
 # Removing Duplicates
 SELECT Country,
 Year,
 CONCAT(Country,Year),
 COUNT(CONCAT(COUNTRY,YEAR))
FROM world_life_expectancy
GROUP BY Country,Year, CONCAT(COUNTRY,YEAR)
HAVING COUNT(CONCAT(Country,Year)) >1
;

SELECT *
FROM (
     SELECT ROW_ID,
     CONCAT(COUNTRY,YEAR),
     ROW_NUMBER() OVER(PARTITION BY CONCAT(COUNTRY,YEAR) ORDER BY CONCAT(COUNTRY,YEAR)) AS Row_NUM
     FROM world_life_expectancy
     ) AS Row_table
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy 
WHERE 
    Row_ID IN (
    SELECT ROW_ID
FROM (
     SELECT ROW_ID,
     CONCAT(COUNTRY,YEAR),
     ROW_NUMBER() OVER(PARTITION BY CONCAT(COUNTRY,YEAR) ORDER BY CONCAT(COUNTRY,YEAR)) AS Row_NUM
     FROM world_life_expectancy
     ) AS Row_table
WHERE Row_Num > 1
)
;

# Populating Data by removing blank data or Nulls
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;


SELECT DISTINCT(STATUS) 
FROM world_life_expectancy
WHERE Status <> ''
;


SELECT DISTINCT (Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT (Country)
                  FROM world_life_expectancy
                  WHERE Status = 'Developing'
                  )
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT *
FROM world_life_expectancy
WHERE STATUS IS NULL
;

# Cleaning up data that has blank values
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT Country,
Year,
`Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;


SELECT 
t1.Country,t1.Year,t1.`Life expectancy`,
t2.Country,t2.Year,t2.`Life expectancy`,
t3.Country,t3.Year,t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
WHERE t1.`Life expectancy`= ''
;


SELECT *
FROM world_life_expectancy
;
