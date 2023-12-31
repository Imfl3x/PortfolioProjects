#US Household Income Data Cleaning
    #Changed the name of miss spelling in the dataset
    #Removed Duplicates
    #Found issues in the state_name and populated the correct State_Names
    #Replaced values missing for County and Place

ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO id;

SELECT * 
FROM us_household_income
;

SELECT * 
FROM us_household_income_statistics
;

SELECT COUNT(id)
FROM us_household_income_statistics
;

SELECT COUNT(id)
FROM us_household_income
;

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY ID
HAVING COUNT(id) >1
;



SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY ID) row_num
FROM us_household_income
) AS Duplicates
WHERE row_num >1
;

# Removing Duplicate records for household income
DELETE FROM us_household_income
WHERE  row_id IN (
     SELECT row_id
     FROM (
         SELECT row_id,
         id,
         ROW_NUMBER() OVER(PARTITION BY id ORDER BY ID) row_num
         FROM us_household_income
         ) AS Duplicates
     WHERE row_num >1
     )
;


# Checking for Duplicatese in Household Income statistics table
SELECT id,
COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY 1
;

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;


UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;

SELECT DISTINCT State_AB
FROM us_household_income
ORDER BY 1
;

SELECT *
FROM us_household_income
WHERE Place = ''
ORDER BY 1
;

SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND  City = 'Vinemont'
;


SELECT Type, Count(Type)
FROM us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

SELECT ALand,AWater
FROM us_household_income 
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;




