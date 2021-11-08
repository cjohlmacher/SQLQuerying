-- from the terminal run:
-- psql < outer_space.sql

DROP DATABASE IF EXISTS outer_space;

CREATE DATABASE outer_space;

\c outer_space

CREATE TABLE galaxies (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE celestial_bodies
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT,
  galaxy INTEGER REFERENCES galaxies (id) ON DELETE SET NULL
);

CREATE TABLE orbits 
(
  id SERIAL PRIMARY KEY,
  satellite INTEGER REFERENCES celestial_bodies (id) ON DELETE CASCADE,
  parent_body INTEGER REFERENCES celestial_bodies (id) ON DELETE CASCADE,
  orbital_period_in_years FLOAT
);

INSERT INTO galaxies (name) 
VALUES ('Milky Way');

INSERT INTO celestial_bodies (name,type,galaxy) 
VALUES ('The Sun','star',1),('Proxima Centauri','star',1),('Gliese 876','star',1),('Earth','planet',1),
('Mars','planet',1),('Venus','planet',1),('Neptune','planet',1),('Proxima Centauri b','exoplanet',1),
('Gliese 876 b','exoplanet',1),('The Moon','moon',1),('Phobos','moon',1),('Deimos','moon',1),
('Naiad','moon',1),('Thalassa','moon',1),('Despina','moon',1),('Galatea','moon',1), 
('Larissa','moon',1), ('S/2004 N 1','moon',1), ('Proteus','moon',1), ('Triton','moon',1),
('Nereid','moon',1),('Halimede','moon',1), ('Sao','moon',1), ('Laomedeia','moon',1), 
('Psamathe','moon',1),('Neso','moon',1);

INSERT INTO orbits (satellite,parent_body,orbital_period_in_years)
VALUES 
(4,1,1.00),(5,1,1.88),(6,1,0.62),(7,1,164.8),(8,2,0.03),(9,3,0.23);

INSERT INTO orbits (satellite, parent_body)
VALUES 
(10,4),(11,5),(12,5),(13,7),
(14,7),(15,7),(16,7),(17,7),
(18,7),(19,7),(20,7),(21,7),
(22,7),(23,7),(24,7),(25,7),
(26,7);

-- Sample Query to list what galaxy each celestial body belongs to
SELECT celestial_bodies.name,galaxies.name 
FROM celestial_bodies 
JOIN galaxies ON galaxy = galaxies.id;

-- Sample Query to list the number of moons each planet/exoplanet has
SELECT name, COUNT(*) AS number_of_moons
FROM celestial_bodies 
JOIN orbits ON celestial_bodies.id = parent_body
WHERE type = 'exoplanet' OR type = 'planet'
GROUP BY name;

-- Sample Query to list the number of satellites each celestial body has
SELECT name,type, COUNT(*) AS number_of_satellites
FROM celestial_bodies 
JOIN orbits ON celestial_bodies.id = parent_body
GROUP BY name,type
ORDER BY type DESC,name;