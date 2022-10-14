-- write your COPY statement to import a csv here

COPY air_bnb_NYC_data
FROM '/Users/manjiribhandarwar/Documents/GitHub/homework06-manjiri-b/air_bnb_data_NYC.csv'
DELIMITER ','
CSV HEADER;
