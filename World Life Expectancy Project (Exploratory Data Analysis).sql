# World Life Expectancy Project (Exploratory Data Analysis)
    #Data Cleaning
    #Insights of the data

SELECT *
FROM world_life_expectancy
;

# Looking at the increase in life expectancy in each country over last 15 years
SELECT Country,
MIN(`Life expectancy`),
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_Years ASC
;

#Looking at life expectancy of the world over the last 15 years
SELECT Year,
ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

SELECT *
FROM world_life_expectancy
;

# Looking to see if Life_Exp is correlated with GDP
SELECT Country,
ROUND(AVG(`Life expectancy`),1) AS Life_Exp,
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

# Findings show a high correlation with the higher the GDP the more likely the life_Exp increases 
# and the Lower GDP the country will have a lower Life_Exp
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END ) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END ),1) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END ) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END ),1) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

# What is the AVG life exp between Status

SELECT Status,
ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status,
COUNT(DISTINCT Country),
ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

# Looking at BMI by each Country by life_Exp

SELECT Country,
ROUND(AVG(`Life expectancy`),1) AS Life_Exp,
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;


# Looking at Adult Mortality rolling total (Using a window function)

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY YEAR) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;
