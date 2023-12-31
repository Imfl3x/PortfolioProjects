# Us HouseHold Income Exploratory Data Analysis
    #Looked at Area of the land and Water
    #Combined the tables using an Inner JOIN
    # Removed mean of zero due to the data not being reported correctly
    # Looking at the state level for highest and lowest of median and mean
    # Looked at different types
    # Look at different citys and income within those city


SELECT * 
FROM us_household_income
;

SELECT * 
FROM us_household_income_statistics
;

# Looking at the Top ten by State_Name for Land
SELECT State_Name,
SUM(ALand),
SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

# Looking at the Top ten by State_Name for Water
SELECT State_Name,
SUM(ALand),
SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;


#

SELECT u.State_Name,
County,
Type,
`Primary`,
Mean,
Median
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
;

# Lowest states with the Avgerage income
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5;


# Higest states with the most Avgerage income
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

# Highest Median income by State
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;

# Lowest Median income by State
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 10;


SELECT
Type,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY 1
ORDER BY 1 DESC
LIMIT 10
;

# Looking at the Type sorted by the Highest Mean income
SELECT
Type,
COUNT(Type),
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10
;

# Looking at the Type sorted by the Highest Median income
    # Filter out the outliers
SELECT
Type,
COUNT(Type),
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
WHERE MEAN <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 10
;

SELECT *
FROM us_household_income
WHERE Type = 'Community'
;

#Highest AVG household income for each City
SELECT u.State_Name,City, ROUND(AVG(Mean),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC
;

SELECT u.State_Name,City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.ID
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC
;


