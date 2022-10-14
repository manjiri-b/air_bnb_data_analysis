-- write your table creation sql here!
DROP TABLE IF EXISTS air_bnb_NYC_data;

CREATE TABLE air_bnb_NYC_data (
    id int PRIMARY KEY,
    listing_name text NOT NULL,
    host_name varchar(50) NOT NULL,
    neighborhood varchar(15) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    room_type varchar(20) NOT NULL,
    price integer NOT NULL CHECK (price > 0),
    minimum_nights smallint NOT NULL CHECK (minimum_nights > 0),
    number_of_reviews smallint NOT NULL CHECK (number_of_reviews >= 0),
    availability_365 smallint NOT NULL CHECK (availability_365 > 0)
);