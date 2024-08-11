-- p1

USE pandemic;

SELECT COUNT(1) FROM pandemic.infectious_cases ic 

 -- p2


DROP TABLE IF EXISTS Countries;

CREATE TABLE Countries (
    CountryID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Entity VARCHAR(255) UNIQUE,
    Code VARCHAR(8) NULL
);


INSERT INTO Countries (Entity, Code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;


DROP TABLE IF EXISTS Disease_Cases;

CREATE TABLE Disease_Cases (
    CaseID INT PRIMARY KEY AUTO_INCREMENT,
    CountryID INT,
    Year INT,
    Number_yaws FLOAT,
    polio_cases FLOAT,
    cases_guinea_worm FLOAT,
    Number_rabies FLOAT,
    Number_malaria FLOAT,
    Number_hiv FLOAT,
    Number_tuberculosis FLOAT,
    Number_smallpox INT,
    Number_cholera_cases FLOAT,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);


INSERT INTO Disease_Cases (CountryID, Year, Number_yaws, polio_cases, cases_guinea_worm, Number_rabies, Number_malaria, Number_hiv, Number_tuberculosis, Number_smallpox, Number_cholera_cases)
SELECT 
    c.CountryID,
    ic.Year,
    ic.Number_yaws,
    ic.polio_cases,
    ic.cases_guinea_worm,
    ic.Number_rabies,
    ic.Number_malaria,
    ic.Number_hiv,
    ic.Number_tuberculosis,
    ic.Number_smallpox,
    ic.Number_cholera_cases
FROM 
    infectious_cases ic
JOIN 
    Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code;
   
 -- p3
   
SELECT 
    CountryID,
    AVG(Number_rabies) AS avg_rabies,
    MIN(Number_rabies) AS min_rabies,
    MAX(Number_rabies) AS max_rabies,
    SUM(Number_rabies) AS sum_rabies
FROM 
    Disease_Cases
WHERE 
    Number_rabies IS NOT NULL
GROUP BY 
    CountryID
ORDER BY 
    avg_rabies DESC
LIMIT 10;

-- p4

ALTER TABLE Disease_Cases
ADD COLUMN First_Jan_Date DATE;

UPDATE Disease_Cases
SET First_Jan_Date = STR_TO_DATE(CONCAT(Year, '-01-01'), '%Y-%m-%d');

ALTER TABLE Disease_Cases
ADD COLUMN Cur_Date DATE;

UPDATE Disease_Cases
SET Cur_Date = CURDATE();

ALTER TABLE Disease_Cases
ADD COLUMN Year_Difference INT;

UPDATE Disease_Cases
SET Year_Difference = YEAR(Cur_Date) - YEAR(First_Jan_Date);
   
SELECT First_Jan_Date, Cur_Date, Year_Difference
FROM Disease_Cases


 -- p5

DROP FUNCTION IF EXISTS YearDifference;

DELIMITER //

CREATE FUNCTION YearDifference(input_year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE start_date DATE;
    DECLARE diff_years INT;
    
    SET First_Jan_Date = DATE(CONCAT(input_year, '-01-01'));
    
    SET diff_years = TIMESTAMPDIFF(YEAR, start_date, CURDATE());
    

    RETURN diff_years;
END //

DELIMITER ;


-- SELECT YearDifference(1980);

SELECT
	Year_Difference,
    Year,
    YearDifference(Year) AS year_difference
FROM
    Disease_Cases;



