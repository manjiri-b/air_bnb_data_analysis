# Overview

Source of Data:
1. Name / Title: New York City AirBnB Open Data
2. Link to Data: https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data/metadata
3. Source / Origin:
	* Author or Creator: Air BnB
	* Publication Date: 2019
	* Publisher: Kaggle
	* Version or Data Accessed: 17 February 2022
4. License: CC0: Public Domain
5. Can You Use this Data Set for Your Intended Use Case? Yes because it contains information about prices of listings,
the neighborhood of listings and the number of reviews of each listing among other things.

Columns and Expected Types based on Pandas:
- id: int64
- listing_name: string object
- host_name: string object
- neighborhood: string object
- latitude and longitude: float64
- room_type: string object
- price: int64
- minimum_nights: int64
- number_of_reviews: int64
- availability_365: int64

# Table Design

Since the csv file was cleaned up to drop nulls, all the columns have the NOT NULL constraint.

- id: set as PRIMARY KEY as it is unique and will not be changed.
- listing_name: text type as strings in column have a high deviation in length
- host_name: varchar(50). Set it as 50 as a safe choice upon inspection of column strings lengths.
- neighborhood: varchar(15). Longest named neighborhood is "Staten Island" with length 13, so chose 15 (slightly more)
  to be safe
- latitude and longitude: double precision were used as in original data structures they have variable
  precision numbers. Double precision used instead of real as it is more precise. Calculations will not be done on
  these columns (rare that it will) which is why decided not to use numeric
- room_type: max length of string in column is 15 so I chose 20 for length of varchar (extra just in case)
- price: Price in original dataset is int so left it as int
- minimum_nights: max is 1250 so chose smallint as it is sufficient to capture data
- number_of_reviews: max is 629 so chose smallint as it is sufficient to capture data (i.e. max smallint > max reviews)
- availability_365: max is 365 so chose smallint as it is sufficient to capture data

Constraints: price, minimum_nights, and availability_365 should be > 0 due to logic. If these were
0 then there is no point of that listing existing. number_of_reviews is strictly positive.

# Import

ERROR 1
homework06=# COPY air_bnb_NYC_data FROM '/Users/manjiribhandarwar/Documents/GitHub/homework06-manjiri-b/air_bnb_data_NYC.csv' DELIMITER ',' CSV HEADER;
ERROR:  new row for relation "air_bnb_nyc_data" violates check constraint "air_bnb_nyc_data_availability_365_check"
DETAIL:  Failing row contains (5022, Entire Apt: Spacious Studio/Loft by central park, Laura, Manhattan, 40.79851, -73.94399, Entire home/apt, 80, 10, 9, 0).
CONTEXT:  COPY air_bnb_nyc_data, line 6: "5022,Entire Apt: Spacious Studio/Loft by central park,Laura,Manhattan,40.79851,-73.94399,Entire home..."

To fix this further cleaned up csv file, dropped rows where 'availability_365' column == 0.

ERROR 2
homework06=# COPY air_bnb_NYC_data FROM '/Users/manjiribhandarwar/Documents/GitHub/homework06-manjiri-b/air_bnb_data_NYC.csv' DELIMITER ',' CSV HEADER;
ERROR:  null value in column "host_name" of relation "air_bnb_nyc_data" violates not-null constraint
DETAIL:  Failing row contains (100184, Bienvenue, null, Queens, 40.72413, -73.76133, Private room, 50, 1, 43, 88).
CONTEXT:  COPY air_bnb_nyc_data, line 321: "100184,Bienvenue,,Queens,40.72413,-73.76133,Private room,50,1,43,88"

Dropped rows with null values in host_name and listing_name column to fix this.

ERROR 3
ERROR:  value too long for type character varying(100)
CONTEXT:  COPY air_bnb_nyc_data, line 7144, column listing_name: "Entire pvt. house for rent ,2 floors
 3 bdrms., 2.5  baths. Newly renovated,avail. From Nov (Phone n..."

Changed data type of listing_name column to text as it can be of varying length.

# Database Information

```
1.
postgres=# \l
                                           List of databases
    Name    |       Owner       | Encoding | Collate | Ctype |            Access privileges
------------+-------------------+----------+---------+-------+-----------------------------------------
 homework06 | manjiribhandarwar | UTF8     | C       | C     |
 postgres   | manjiribhandarwar | UTF8     | C       | C     |
 template0  | manjiribhandarwar | UTF8     | C       | C     | =c/manjiribhandarwar                   +
            |                   |          |         |       | manjiribhandarwar=CTc/manjiribhandarwar
 template1  | manjiribhandarwar | UTF8     | C       | C     | =c/manjiribhandarwar                   +
            |                   |          |         |       | manjiribhandarwar=CTc/manjiribhandarwar
(4 rows)
```
```
2.
homework06=# \dt
                   List of relations
 Schema |       Name       | Type  |       Owner
--------+------------------+-------+-------------------
 public | air_bnb_nyc_data | table | manjiribhandarwar
(1 row)
```
```
3.
homework06=# \d air_bnb_nyc_data
                      Table "public.air_bnb_nyc_data"
      Column       |         Type          | Collation | Nullable | Default
-------------------+-----------------------+-----------+----------+---------
 id                | integer               |           | not null |
 listing_name      | text                  |           | not null |
 host_name         | character varying(50) |           | not null |
 neighborhood      | character varying(15) |           | not null |
 latitude          | double precision      |           | not null |
 longitude         | double precision      |           | not null |
 room_type         | character varying(20) |           | not null |
 price             | integer               |           | not null |
 minimum_nights    | smallint              |           | not null |
 number_of_reviews | smallint              |           | not null |
 availability_365  | smallint              |           | not null |
Indexes:
    "air_bnb_nyc_data_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "air_bnb_nyc_data_availability_365_check" CHECK (availability_365 > 0)
    "air_bnb_nyc_data_minimum_nights_check" CHECK (minimum_nights > 0)
    "air_bnb_nyc_data_number_of_reviews_check" CHECK (number_of_reviews >= 0)
    "air_bnb_nyc_data_price_check" CHECK (price > 0)
```

# Query Results
```
### 1. the total number of rows in the database
 count
-------
 31342
(1 row)
```
```
### 2. show the first 15 rows, but only display 3 columns (your choice)
                   listing_name                   | neighborhood | price
--------------------------------------------------+--------------+-------
 Clean & quiet apt home by the park               | Brooklyn     |   149
 Skylit Midtown Castle                            | Manhattan    |   225
 THE VILLAGE OF HARLEM....NEW YORK !              | Manhattan    |   150
 Cozy Entire Floor of Brownstone                  | Brooklyn     |    89
 Large Cozy 1 BR Apartment In Midtown East        | Manhattan    |   200
 Large Furnished Room Near B'way                  | Manhattan    |    79
 Cute & Cozy Lower East Side 1 bdrm               | Manhattan    |   150
 Beautiful 1br on Upper West Side                 | Manhattan    |   135
 Central Manhattan/near Broadway                  | Manhattan    |    85
 Lovely Room 1, Garden, Best Area, Legal rental   | Brooklyn     |    89
 Wonderful Guest Bedroom in Manhattan for SINGLES | Manhattan    |    85
 Only 2 stops to Manhattan studio                 | Brooklyn     |   140
 Perfect for Your Parents + Garden                | Brooklyn     |   215
 Chelsea Perfect                                  | Manhattan    |   140
 Hip Historic Brownstone Apartment with Backyard  | Brooklyn     |    99
(15 rows)
```
```
### 3. do the same as above, but chose a column to sort on, and sort in descending order
                    listing_name                    | neighborhood  | price
----------------------------------------------------+---------------+-------
 1-BR Lincoln Center                                | Manhattan     | 10000
 2br - The Heart of NYC: Manhattans Lower East Side | Manhattan     |  9999
 Quiet, Clean, Lit @ LES & Chinatown                | Manhattan     |  9999
 Beautiful/Spacious 1 bed luxury flat-TriBeCa/Soho  | Manhattan     |  8500
 Film Location                                      | Brooklyn      |  8000
 East 72nd Townhouse by (Hidden by Airbnb)          | Manhattan     |  7703
 70' Luxury MotorYacht on the Hudson                | Manhattan     |  7500
 Gem of east Flatbush                               | Brooklyn      |  7500
 3000 sq ft daylight photo studio                   | Manhattan     |  6800
 Luxury TriBeCa Apartment at an amazing price       | Manhattan     |  6500
 Apartment New York                                +| Manhattan     |  6500
 Hell’s Kitchens                                    |               |
 Park Avenue Mansion by (Hidden by Airbnb)          | Manhattan     |  6419
 UWS 1BR w/backyard + block from CP                 | Manhattan     |  6000
 Midtown Manhattan great location (Gramacy park)    | Manhattan     |  5100
 Victorian Film location                            | Staten Island |  5000
(15 rows)
```
```
###  4. add a new column without a default value
ALTER TABLE

Used this to check if the column was added:
homework06=# \d air_bnb_nyc_data
                          Table "public.air_bnb_nyc_data"
          Column           |         Type          | Collation | Nullable | Default
---------------------------+-----------------------+-----------+----------+---------
 id                        | integer               |           | not null |
 listing_name              | text                  |           | not null |
 host_name                 | character varying(50) |           | not null |
 neighborhood              | character varying(15) |           | not null |
 latitude                  | double precision      |           | not null |
 longitude                 | double precision      |           | not null |
 room_type                 | character varying(20) |           | not null |
 price                     | integer               |           | not null |
 minimum_nights            | smallint              |           | not null |
 number_of_reviews         | smallint              |           | not null |
 availability_365          | smallint              |           | not null |
 total_minimum_expenditure | integer               |           |          |
Indexes:
    "air_bnb_nyc_data_pkey" PRIMARY KEY, btree (id)
Check constraints:
    "air_bnb_nyc_data_availability_365_check" CHECK (availability_365 > 0)
    "air_bnb_nyc_data_minimum_nights_check" CHECK (minimum_nights > 0)
    "air_bnb_nyc_data_number_of_reviews_check" CHECK (number_of_reviews >= 0)
    "air_bnb_nyc_data_price_check" CHECK (price > 0)

```
```
### 5. set the value of that new column. Value of new column was set to the multiplication of the
price and minimum_nights column.

Result of Query:
UPDATE 31342

Checking if the Query Worked Properly by Displaying the first 5 rows of the price, minimum_nights and
total_minimum_expenditure columns.

homework06=# SELECT price, minimum_nights, total_minimum_expenditure FROM air_bnb_nyc_data LIMIT 5;
 price | minimum_nights | total_minimum_expenditure
-------+----------------+---------------------------
    52 |              2 |                       104
    55 |              4 |                       220
    50 |              3 |                       150
    70 |              1 |                        70
    89 |              4 |                       356
(5 rows)
```
```
### 6. show only the unique (non duplicates) of a column of your choice: neighborhood.
 neighborhood
---------------
 Bronx
 Brooklyn
 Manhattan
 Queens
 Staten Island
(5 rows)
```
```
### 7. group rows together by a column value (your choice) and use an aggregate
function to calculate something about that group.

        neighborhood;
 neighborhood  | average_price
---------------+---------------
 Queens        |        100.04
 Brooklyn      |        132.95
 Staten Island |        114.23
 Manhattan     |        214.20
 Bronx         |         89.08
(5 rows)
```
```
### 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups

Grouping query with filter result:
 neighborhood | count
--------------+-------
 Brooklyn     | 12248
 Manhattan    | 13555
(2 rows)

Grouping query without filter (as it is a new grouping query)
 neighborhood  | count
---------------+-------
 Queens        |  4297
 Brooklyn      | 12248
 Staten Island |   331
 Manhattan     | 13555
 Bronx         |   911
(5 rows)
```
```
### 9. What is the count of each room_type?
    room_type    | count
-----------------+-------
 Entire home/apt | 16525
 Shared room     |   861
 Private room    | 13956
(3 rows)
```
```
### 10.What is the average price by room_type?

    room_type    | average_price
-----------------+---------------
 Entire home/apt |        224.64
 Shared room     |         66.07
 Private room    |         93.98
(3 rows)
```
```
### 11. Most expensive listing(s) in terms of total_minimum_expenditure.

                 listing_name                 | neighborhood | total_minimum_expenditure
----------------------------------------------+--------------+---------------------------
 Luxury TriBeCa Apartment at an amazing price | Manhattan    |                   1170000
(1 row)
```
```
### 12. Least expensive listing(s) in terms of total_minimum_expenditure.

                    listing_name                    | neighborhood | total_minimum_expenditure
----------------------------------------------------+--------------+---------------------------
 IT'S SIMPLY CONVENIENT!                            | Queens       |                        10
 Spacious 2-bedroom Apt in Heart of Greenpoint      | Brooklyn     |                        10
 Gigantic Sunny Room in Park Slope-Private Backyard | Brooklyn     |                        10
 Room with a view                                   | Brooklyn     |                        10
 Bronx Apart                                        | Bronx        |                        10
(5 rows)
```