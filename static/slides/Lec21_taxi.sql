## Demo

# https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
# https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv

### Basics

.timer on

SELECT count(*) FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

DESCRIBE SELECT * FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

CREATE VIEW taxi AS SELECT * FROM read_parquet("/data/nyctaxi/yellow_*.parquet");


### Payment types

CREATE TABLE payment_types AS
SELECT * FROM (
  VALUES
    (0, 'Flex Fare trip'),
    (1, 'Credit card'),
    (2, 'Cash'),
    (3, 'No charge'),
    (4, 'Dispute'),
    (5, 'Unknown'),
    (6, 'Voided trip')
) AS t(payment_type, payment_type_desc);

### Tip percentage

SELECT avg(tip_amount / fare_amount) AS mean_tip_frac, payment_type 
  FROM taxi
  GROUP BY payment_type
  ORDER BY payment_type;


SELECT min(fare_amount), max(fare_amount), min(tip_amount), max(tip_amount) FROM taxi;

SUMMARIZE SELECT fare_amount, tip_amount FROM taxi;

SELECT round(avg(tip_amount / fare_amount),4) AS mean_tip_frac, payment_type, count(*) AS n
  FROM taxi
  WHERE tip_amount >= 0 AND fare_amount > 0 
  GROUP BY payment_type 
  ORDER BY payment_type;


### Cost per mile

SELECT 
    PULocationID pickup_zone,
    AVG(fare_amount / trip_distance) fare_per_mile,
    COUNT(*) num_rides 
FROM taxi
WHERE trip_distance > 0
GROUP BY PULocationID
ORDER BY PULocationID;


SELECT * FROM (
  SELECT 
    PULocationID pickup_zone,
    ROUND(AVG(fare_amount),2) fare_amount,
    ROUND(AVG(trip_distance),2) trip_distance,
    ROUND(AVG(fare_amount / trip_distance), 2) fare_per_mile,
    COUNT(*) num_rides 
  FROM taxi
  WHERE trip_distance > 0 AND fare_amount
  GROUP BY PULocationID
  ORDER BY PULocationID
) NATURAL LEFT JOIN (
 SELECT LocationID AS pickup_zone, * FROM read_csv("/data/nyctaxi/taxi_zone_lookup.csv")
) ORDER BY fare_per_mile DESC;


SELECT * FROM (
  SELECT 
    PULocationID pickup_zone,
    ROUND(quantile_cont(fare_amount, 0.5),2) fare_amount,
    ROUND(quantile_cont(trip_distance, 0.5),2) trip_distance,
    ROUND(quantile_cont(fare_amount / trip_distance, 0.5), 2) fare_per_mile,
    COUNT(*) num_rides 
  FROM taxi
  WHERE trip_distance > 0 AND fare_amount
  GROUP BY PULocationID
  ORDER BY PULocationID
) NATURAL LEFT JOIN (
 SELECT LocationID AS pickup_zone, * FROM read_csv("/data/nyctaxi/taxi_zone_lookup.csv")
) ORDER BY fare_per_mile DESC;
