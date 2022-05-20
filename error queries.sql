-- common errors
SELECT * FROM Lender_Products WHERE lender_code IS NULL; -- 1

SELECT * FROM Lender_Rates_Elements WHERE lender_code IS NULL;

SELECT * FROM Member_Eligibility WHERE lender_code IS NULL;

SELECT * FROM Member_Eligibility WHERE lender_code NOT IN (SELECT lender_id FROM Lender);

SELECT * FROM Lender_Rates_Elements WHERE lender_code NOT IN (SELECT lender_id FROM Lender);

-- Lender_Products errors

SELECT * FROM Lender_Products WHERE lender_code IS NULL OR product_code IS NULL OR has_issues IS NULL; -- 1

SELECT * FROM Lender_Products WHERE sub_product_url IS NULL AND has_issues NOT IN (4,5,6,7); -- 2

SELECT * FROM Lender_Products WHERE lender_code NOT IN (SELECT lender_id FROM Lender); -- 3

SELECT * FROM Lender_Products WHERE product_code NOT IN (SELECT product_code FROM Products_Main); -- 4

SELECT * FROM Lender_Products WHERE has_issues NOT IN (0,1,2,3,4,5,6,7); -- 5

SELECT *
FROM Lender_Products
GROUP BY lender_code, product_code
HAVING COUNT(*) > 1; -- 6

SELECT * FROM Lender_Products
WHERE online_app NOT IN  (SELECT id FROM online_application)
OR instant_prequal NOT IN (SELECT id FROM instant_prequalification)
OR online_app IS NULL
OR instant_prequal IS NULL; -- 7

SELECT *
FROM Lender_Products
WHERE has_issues = 0
AND NOT EXISTS (SELECT *
				FROM Lender_Rates_Elements
                WHERE Lender_Rates_Elements.lender_code = Lender_Products.lender_code
                AND Lender_Rates_Elements.product_code = Lender_Products.product_code); -- 8

-- Lender Rate Errors
SELECT * FROM Lender_Rates_Elements WHERE lender_code IS NULL OR product_code IS NULL; -- 1

SELECT * FROM Lender_Rates_Elements WHERE NOT EXISTS (SELECT * FROM Lender_Products
													  WHERE Lender_Rates_Elements.lender_code = Lender_Products.lender_code
                                                      AND Lender_Rates_Elements.product_code = Lender_Products.product_code); -- 2
                                                      
SELECT * FROM Lender_Rates_Elements WHERE EXISTS (SELECT * FROM Lender_Products
												  WHERE Lender_Rates_Elements.lender_code = Lender_Products.lender_code
												  AND Lender_Rates_Elements.product_code = Lender_Products.product_code
                                                  AND Lender_Products.product_code != 0); -- 3

-- come back for 4


SELECT * 
FROM Lender_Rates_Elements 
WHERE lender_code IS NOT NULL 
AND product_code IS NOT NULL 
AND lowest_rate_id IS NULL 
AND highest_rate_id IS NULL; -- 5

-- Scraped Data Errors

-- 1: limits to be defined

SELECT * FROM Scraped_data WHERE Lowest_Rate > Highest_Rate; -- 2

SELECT * FROM Scraped_data WHERE Highest_Rate < Lowest_Rate; -- 3

SELECT * FROM Scraped_data WHERE Auto_Age_From > Auto_Age_To; -- 4

SELECT * FROM Scraped_data WHERE Auto_Age_To < Auto_Age_From; -- 5

SELECT * FROM Scraped_data WHERE Minimum_Term > Maximum_Term; -- 6

SELECT * FROM Scraped_data WHERE Maximum_Term < Minimum_Term; -- 7

SELECT * FROM Scraped_data WHERE Minimum_Loan > Maximum_Loan; -- 8

SELECT * FROM Scraped_data WHERE Maximum_Loan < Minimum_Loan; -- 9

SELECT *
FROM Scraped_data
WHERE NOT EXISTS (SELECT *
					FROM Lender_Rates_Elements
                    WHERE Lender_Rates_Elements.Lender_Code = Scraped_data.Lender_Code
                    AND Lender_Rates_Elements.Product_Code = Scraped_data.Product_Code); -- 10

SELECT * FROM Scraped_data WHERE Lowest_Rate IS NULL OR Lowest_Rate = ""; -- 11

-- Membership Eligiblity errors

SELECT * FROM Member_Eligibility WHERE eligibility_level NOT IN (1,2,3,4); -- 1

SELECT *
FROM Member_Eligibility
WHERE eligibility_level = 1
AND (state_fips_code IS NOT NULL OR county_fips_code IS NOT NULL)
AND lender_code IS NOT NULL; -- 2

SELECT lender_code,state_fips_code,county_fips_code
FROM Member_Eligibility
WHERE eligibility_level = 2
AND county_fips_code IS NOT NULL
AND state_fips_code NOT IN (SELECT state_fips FROM usa_states)
AND lender_code IS NOT NULL; -- 3


SELECT *
FROM Member_Eligibility
WHERE lender_code IS NOT NULL
AND eligibility_level = 3
AND NOT EXISTS (SELECT State_Code_FIPS, County_Code_FIPS 
				FROM FIPS_Data
                WHERE State_Code_FIPS = Member_Eligibility.state_fips_code
                AND County_Code_FIPS = Member_Eligibility.county_fips_code)
ORDER BY lender_code; -- 4


