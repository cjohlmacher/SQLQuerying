-- from the terminal run:
-- psql < seed_medical_center.pgsql

-- Assumes a player always stays with the same team.

DROP DATABASE IF EXISTS soccer_league;

CREATE DATABASE soccer_league;

\c soccer_league

CREATE TABLE seasons (
    id SERIAL PRIMARY KEY,
    start_date DATE,
    end_date DATE
);

CREATE TABLE referees (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    team_name TEXT NOT NULL
);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    team_1 INTEGER REFERENCES teams (id) ON DELETE SET NULL,
    team_2 INTEGER REFERENCES teams (id) ON DELETE SET NULL,
    season_id INTEGER REFERENCES seasons (id) ON DELETE SET NULL,
    match_date DATE
);

CREATE TABLE matches_referees (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches (id) ON DELETE CASCADE,
    referee_id INTEGER REFERENCES referees (id) ON DELETE CASCADE
);

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT NOT NULL,
    team_id INTEGER REFERENCES teams (id) ON DELETE SET NULL
);

CREATE TABLE goals (
    id SERIAL PRIMARY KEY,
    match_id INTEGER REFERENCES matches (id) ON DELETE CASCADE,
    player_id INTEGER REFERENCES players (id) ON DELETE SET NULL
);

INSERT INTO seasons (start_date, end_date) 
VALUES 
('2021-07-15','2021-10-13');

INSERT INTO referees (first_name, last_name)
VALUES
('Carl','Schwarz'),('Alice','Li');

INSERT INTO teams (team_name)
VALUES ('Tigers'),('Doves'),('Aardvarks'),('Butterflies');

INSERT INTO matches (team_1,team_2,season_id,match_date)
VALUES 
(1,2,1,'2021-07-25'),(3,4,1,'2021-07-24'),(1,3,1,'2021-07-21'),(2,4,1,'2021-07-22'),
(2,1,1,'2021-07-23'),(4,3,1,'2021-07-24'),(2,4,1,'2021-08-05'),(3,1,1,'2021-08-07');

INSERT INTO matches_referees (match_id,referee_id)
VALUES 
(1,1),(2,1),(2,2),(3,2),(4,1),(5,2),(6,1),(7,2),(8,1);

INSERT INTO players (first_name, last_name, team_id)
VALUES 
('Brooklyn','Meyers',1),('Ruthra','Anand',1),('Ronald','McDonald',1),('Sylvia','Lee',1),
('Wesley','Thompson',1),('Fiona','Lawrence',1),('Houston','Powers',2),('Anna','Lapinski',2),
('Ollie','Alexander',2),('Portia','Knowles',2),('Pietr','Svornoff',2),('Olivia','Nguyen',2),
('Sanjay','Patel',3),('Kieran','O''Donell',3),('Regina','Phalange',3),('Stephen','Parks',3),
('Callie','Ortega',3),('Barbara','Walton',3),('Andrew','Gill',4),('Tess','Montague',4),
('Annette','Faroh',4),('William','Quincy',4),('Chaz','Anthony',4);

INSERT INTO goals (match_id, player_id)
VALUES 
(1,1),(1,7),(1,8),(1,2),
(2,13),(2,15),(2,16),(2,23),
(3,1),(3,2),(3,15),
(4,7),(4,8),(4,20),(4,21),
(5,1),(5,2),(5,7),
(6,19),(6,17),(6,23),
(7,21),
(8,2),(8,4),(8,15),(8,17);

-- Sample Query to show all games for team Doves in 2021
SELECT match_date, a.team_name, b.team_name 
FROM matches m 
JOIN teams a ON team_1 = a.id 
JOIN teams b ON team_2 = b.id 
WHERE match_date > '2021-01-01' 
AND (a.team_name = 'Doves' OR b.team_name = 'Doves');

-- Sample Query to show the score of each game in 2021
SELECT match_id,team_name,COUNT(*) as score
FROM goals g
JOIN matches m ON match_id = m.id
JOIN players p ON player_id = p.id
JOIN teams t ON team_id = t.id
WHERE match_date > '2021-01-01'
GROUP BY match_id, team_name
ORDER BY match_id,score DESC;

-- Sample Query to show team standings in Season 1
SELECT team_name,COUNT(*) as total_goals
FROM goals g
JOIN matches m ON match_id = m.id
JOIN players p ON player_id = p.id
JOIN teams t ON team_id = t.id
WHERE season_id = 1
GROUP BY team_name
ORDER BY total_goals DESC;

-- Sample Query to show players with the most career goals
SELECT first_name,last_name,COUNT(*) as total_goals
FROM goals g
JOIN matches m ON match_id = m.id
JOIN players p ON player_id = p.id
JOIN teams t ON team_id = t.id
WHERE season_id = 1
GROUP BY first_name,last_name
ORDER BY total_goals DESC;