-- from the terminal run:
-- psql < air_traffic.sql

DROP DATABASE IF EXISTS air_traffic;

CREATE DATABASE air_traffic;

\c air_traffic

CREATE TABLE airports (
  id SERIAL PRIMARY KEY,
  code TEXT CONSTRAINT codechk CHECK (char_length(code) = 3),
  city_name TEXT,
  country TEXT
);

CREATE TABLE flights
(
  id SERIAL PRIMARY KEY,
  departure TIMESTAMP NOT NULL,
  arrival TIMESTAMP NOT NULL,
  airline TEXT NOT NULL,
  from_airport INTEGER REFERENCES airports (id) ON DELETE CASCADE,
  to_airport INTEGER REFERENCES airports (id) ON DELETE CASCADE
);

CREATE TABLE tickets
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  flight INTEGER REFERENCES flights (id) ON DELETE SET NULL,
  seat TEXT NOT NULL
);

INSERT INTO airports
  (code,city_name,country)
VALUES
  ('DCA','Washington DC','United States'),('NRT','Tokyo','Japan'),('SEA','Seattle','United States'),
  ('LHR','London','United States'),('LAX','Los Angeles','United States'),('LAS','Las Vegas','United States'),
  ('MEX','Mexico City','Mexico'),('CDG','Paris','France'),('CMN','Casablanca','Morocco'),
  ('DXB','Dubai','UAE'),('PEK','Beijing','China'),('JFK','New York City','United States'),
  ('CLT','Charlotte','United States'),('CID','Cedar Rapids','United States'),('ORD','Chicago','United States'),
  ('MSY','New Orleans','United States'),('GRU','Sao Paulo','Brazil'),('SCL','Santiago','Chile');

INSERT INTO flights (departure, arrival, airline, from_airport, to_airport)
VALUES 
  ('2018-04-08 09:00:00','2018-04-08 12:00:00','United',1,3),
  ('2018-12-19 12:45:00', '2018-12-19 16:15:00','British Airways',2,4),
  ('2018-01-02 07:00:00', '2018-01-02 08:03:00','Delta',5,6),
  ('2018-04-15 16:50:00', '2018-04-15 21:00:00','Delta',3,7),
  ('2018-08-01 18:30:00', '2018-08-01 21:50:00','TUI Fly Belgium',8,9),
  ('2018-10-31 01:15:00', '2018-10-31 12:55:00','Air China',10,11),
  ('2019-02-06 06:00:00', '2019-02-06 07:47:00','United',12,13),
  ('2018-12-22 14:42:00', '2018-12-22 15:56:00','American Airlines',14,15),
  ('2019-02-06 16:28:00', '2019-02-06 19:18:00','American Airlines',13,16),
  ('2019-01-20 19:30:00', '2019-01-20 22:45:00','Avianca Brasil',17,18);

INSERT INTO tickets
  (first_name, last_name, flight, seat)
VALUES
  ('Jennifer', 'Finch', 1, '33B'),
  ('Thadeus', 'Gathercoal', 2, '8A'),
  ('Sonja', 'Pauley', 3, '12F'), 
  ('Jennifer', 'Finch', 4, '20A'), 
  ('Waneta', 'Skeleton', 5, '23D'), 
  ('Thadeus', 'Gathercoal', 6, '18C'),
  ('Berkie', 'Wycliff', 7, '9E'),
  ('Alvin', 'Leathes', 8, '1A'),
  ('Berkie', 'Wycliff', 9, '32B'),
  ('Cory', 'Squibbes', 10, '10D');

-- Sample Query to show five earliest flights by departure time and departure city
SELECT departure, city_name 
FROM flights 
JOIN airports ON airports.id = from_airport 
ORDER BY departure 
LIMIT 5;

-- Sample Query to show all flights
SELECT b.departure,a.city_name AS from,d.city_name AS to
FROM airports a 
JOIN flights b ON a.id = b.to_airport 
JOIN flights c ON b.to_airport = c.to_airport 
JOIN airports d ON d.id = c.from_airport;

-- Sample Query to show all airports sorted by country and city names
SELECT * 
from airports 
ORDER BY country,city_name;