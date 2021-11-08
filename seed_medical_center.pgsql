-- from the terminal run:
-- psql < seed_medical_center.pgsql
-- Notes: primary physician may not be doctor within medical center.
-- Made decision that doctors_patients table is redundant to visits.

DROP DATABASE IF EXISTS medical_center;

CREATE DATABASE medical_center;

\c medical_center

CREATE TABLE offices
(
    id SERIAL PRIMARY KEY,
    building TEXT,
    floor TEXT,
    room_number TEXT NOT NULL
);

CREATE TABLE doctors
(
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    office_id INTEGER REFERENCES offices (id) ON DELETE SET NULL
);

CREATE TABLE patients
(
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    primary_physician INTEGER REFERENCES doctors (id) ON DELETE SET NULL
);

CREATE TABLE illnesses
(
    id SERIAL PRIMARY KEY,
    illness_name TEXT NOT NULL
);

-- CREATE TABLE doctors_patients
-- (
--     id SERIAL PRIMARY KEY,
--     doctor_id INTEGER REFERENCES doctors (id) ON DELETE CASCADE,
--     patient_id INTEGER REFERENCES patients (id) ON DELETE CASCADE
-- );

CREATE TABLE visits
(
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER REFERENCES doctors (id) ON DELETE SET NULL,
    patient_id INTEGER REFERENCES patients (id) ON DELETE SET NULL,
    visit_date DATE
);

CREATE TABLE patients_illnesses
(
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients (id) ON DELETE CASCADE,
    illness_id INTEGER REFERENCES illnesses (id) ON DELETE SET NULL,
    visit_diagnosed INTEGER REFERENCES visits (id) ON DELETE SET NULL
);

INSERT INTO offices (building,floor,room_number)
VALUES ('Lawrence Wing',4,401), 
('Cybil Hall',3,317),
('Pediatric',1,'102A'),
('Urgent Care',2,'207');

INSERT INTO doctors (first_name,last_name, office_id)
VALUES ('Carl','Spergoff',1),
('Paula','Nguyen',3),
('Pietr','Wozyniak',2),
('Naomi','Sparklin',4),
('Rikesh','Pawel',4);

INSERT INTO doctors (first_name,last_name)
VALUES ('Ananya','Gopal');

INSERT INTO patients (first_name,last_name,birth_date,primary_physician)
VALUES ('Zoe','Saldana','1980-05-02',1),
('Richard','Feynman','1940-07-21',1),
('Wanda','Sykes','1952-08-22',2),
('Eloise','Jones','2001-01-01',2);

INSERT INTO patients (first_name,last_name,birth_date)
VALUES ('Kelly','Clarkson','1980-05-31');

INSERT INTO illnesses (illness_name)
VALUES ('Chicken Pox'),('Excess Gas'),('Fractured Pelvis'),('Tonsilitis');

-- INSERT INTO doctors_patients (doctor_id,patient_id)
-- VALUES (1,1),(1,2),(2,3),(2,4),(3,4),(5,3);

INSERT INTO visits (doctor_id,patient_id,visit_date)
VALUES (1,1,'2021-03-04'),(1,2,'2021-05-07'),(2,3,'2020-11-30'),(2,4,'2021-08-15'),(3,4,'2021-10-13'),(5,3,'2020-12-31'),(2,4,'2020-09-23');

INSERT INTO patients_illnesses (patient_id, illness_id, visit_diagnosed)
VALUES (1,2,1),(1,3,1),(2,4,2),(3,1,3),(3,4,5),(4,2,4);

-- Potentially indices to add:
-- CREATE INDEX patient_idx ON patients (first_name, last_name);
-- CREATE INDEX doctor_idx ON doctors (first_name,last_name);

-- Sample Query to get count of each doctor's total visits since start of this year
SELECT doctors.first_name AS doctor_first_name, doctors.last_name AS doctor_last_name, COUNT(*) AS total_visits
FROM visits
JOIN doctors on doctor_id = doctors.id
WHERE visit_date >= '2021-01-01'
GROUP BY doctors.first_name, doctors.last_name
ORDER BY doctors.first_name DESC;

-- Sample Query to return all doctor/patient relationships
SELECT DISTINCT patients.first_name AS patient_first_name,
patients.last_name AS patient_last_name,
doctors.first_name AS doctor_first_name,
doctors.last_name AS doctor_last_names
FROM visits 
JOIN doctors on doctor_id = doctors.id 
JOIN patients ON patient_id = patients.id;