-- from the terminal run:
-- psql < seed_medical_center.pgsql
-- Linking post to region will happen a lot.

DROP DATABASE IF EXISTS craigslist;

CREATE DATABASE craigslist;

\c craigslist

CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    region_name TEXT UNIQUE NOT NULL
);

CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    location_name TEXT NOT NULL
);

CREATE TABLE location_region (
    id SERIAL PRIMARY KEY,
    location_id INTEGER REFERENCES locations (id) ON DELETE CASCADE,
    region_id INTEGER REFERENCES regions (id) ON DELETE CASCADE
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    preferred_region INTEGER REFERENCES regions (id) ON DELETE SET NULL
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(30),
    text TEXT,
    creator INTEGER REFERENCES users (id) ON DELETE SET NULL,
    location INTEGER REFERENCES locations (id) ON DELETE SET NULL
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE posts_category (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts (id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES category (id) ON DELETE CASCADE
);

INSERT INTO regions (region_name)
VALUES 
    ('San Francisco, California'),
    ('Atlanta, Georgia'),
    ('New York City, New York'),
    ('Boston, Massachusetts'),
    ('London, England'),
    ('Buenos Aires, Argentina'),
    ('Mexico City, Mexico'),
    ('Vancouver, Canada'),
    ('Seattle, Washington'),
    ('Paris, France');

INSERT INTO locations (location_name)
VALUES 
    ('South Bay'), ('East Bay'),('San Jose'),('San Francisco'),('Manhattan'),('Brooklyn'),('Bronx'),('Staten Island'),('Cambridge'),('Boston'),('Provincetown'),('Cape Cod'),('Seattle'),('Bellevue'),('Palermo'),('Recoleta'),('La Boca'),('Retiro'),('Hartford');

INSERT INTO location_region (location_id, region_id)
VALUES
    (1,1),(2,1),(3,1),(4,1),
    (5,3),(6,3),(7,3),(8,3),
    (9,4),(10,4),(11,4),(12,4),
    (13,9),(14,9),
    (15,6),(16,6),(17,6),(18,6),
    (19,3),(19,4);

INSERT INTO users (username, password, preferred_region)
VALUES
    ('wonderwoman','12345678',1),
    ('salamiguy','password',2),
    ('cuckoobird','987654321',1),
    ('crazyguy123','passcode',1),
    ('noone89','1345328',4),
    ('seattleman','password',9),
    ('catsanddogsluvr','catsanddogs',9),
    ('eltoro12','123415',6),
    ('casanova','passcode',6),
    ('user12345','password12345',2),
    ('novelareina','1345135',6),
    ('canadiandude','passwordeh',8);

INSERT INTO users (username, password)
VALUES ('nomadlad','12345678');

INSERT INTO posts (title, text, creator, location)
VALUES 
    ('Need Salad Tongs','I will pay anything for salad tongs for my salad!',2,2),
    ('Selling used candle','It is only half burnt',5,4),
    ('Want free plant food?','I have plant food for free just mail order me $1000',3,2),
    ('Want free plant food?','I have plant food for free just mail order me $1000',3,3),
    ('Apartment for Rent','Renting 2 bedroom apartment for $10000/month',4,1),
    ('Apartment for Rent','Renting 2 bedroom apartment for $1100/month',7,4),
    ('Need pool floaties','Going to pool party. I cannot swim',4,9),
    ('Honda Accord for Sale','Has 3 tires in good condition and the axel is very good',1,9),
    ('Te quiero, me reina','Por favor, vamos a Australia!',9,6);

INSERT INTO category (category_name) 
VALUES ('Events'),('Cars'),('Housing'),('Miscellaneous'),('Missed Connections'),('Home and Garden');

INSERT INTO posts_category (post_id, category_id) 
VALUES 
    (1,4),(1,6),(2,4),(2,6),(3,4),(3,6),(4,4),(4,6),(5,3),(6,3),(7,4),(8,2),(9,5);

-- CREATE INDEX region_idx ON regions (region_name);

--Sample query mapping each location to its region(s)
SELECT location_name,region_name 
FROM locations 
JOIN location_region ON locations.id = location_id 
JOIN regions ON regions.id = region_id;

--Sample query showing all posts from San Francisco, California
SELECT title,text,region_name 
FROM posts 
JOIN locations ON location = locations.id 
JOIN location_region ON location_id = locations.id 
JOIN regions ON region_id = regions.id 
WHERE region_name = 'San Francisco, California';








