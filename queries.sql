-- write your queries underneath each number:
 
-- 1. the total number of rows in the database
SELECT COUNT(*) FROM air_bnb_nyc_data;

-- 2. show the first 15 rows, but only display 3 columns (your choice)
SELECT listing_name, neighborhood, price FROM air_bnb_nyc_data LIMIT 15;

-- 3. do the same as above, but chose a column to sort on, and sort in descending order
SELECT listing_name, neighborhood, price
    FROM air_bnb_nyc_data
    ORDER BY price desc
    LIMIT 15;

-- 4. add a new column without a default value
ALTER TABLE air_bnb_nyc_data
  ADD COLUMN total_minimum_expenditure integer;

-- 5. set the value of that new column
UPDATE air_bnb_nyc_data
    SET total_minimum_expenditure = price * minimum_nights;

-- 6. show only the unique (non duplicates) of a column of your choice
SELECT DISTINCT ON (neighborhood) neighborhood
	FROM air_bnb_nyc_data;

-- 7.group rows together by a column value (your choice) and use an aggregate function to calculate something about that group
SELECT
	neighborhood,
	ROUND( AVG( price ), 2 ) AS average_price
FROM
	air_bnb_nyc_data
GROUP BY
	neighborhood;

-- 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups
SELECT neighborhood,
    COUNT(*)
    FROM air_bnb_nyc_data
    GROUP BY neighborhood
    HAVING COUNT(*) > 10000;

-- 9. What is the count of each room_type?
SELECT room_type,
    COUNT(*)
    FROM air_bnb_nyc_data
    GROUP BY room_type;

-- 10. What is the average price by room_type?
SELECT
	room_type,
	ROUND( AVG( price ), 2 ) AS average_price
FROM
	air_bnb_nyc_data
GROUP BY
	room_type;

-- 11. Most expensive listing(s) in terms of total_minimum_expenditure.
SELECT listing_name, neighborhood, total_minimum_expenditure FROM air_bnb_nyc_data
WHERE total_minimum_expenditure = (
   SELECT MAX (total_minimum_expenditure)
   FROM air_bnb_nyc_data
);

-- 12. Least expensive listing(s) in terms of total_minimum_expenditure.
SELECT listing_name, neighborhood, total_minimum_expenditure FROM air_bnb_nyc_data
WHERE total_minimum_expenditure = (
   SELECT MIN (total_minimum_expenditure)
   FROM air_bnb_nyc_data
);

SELECT year FROM country_stats
WHERE year = (
   SELECT MIN (year)
   FROM country_stats
);
