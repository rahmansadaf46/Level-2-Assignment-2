-- Active: 1747563587031@@127.0.0.1@5432@conservation_db@public
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT NOT NULL REFERENCES species (species_id),
    ranger_id INT NOT NULL REFERENCES rangers (ranger_id),
    location VARCHAR(50) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes VARCHAR(255)
);

INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');
SELECT * FROM rangers;

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');
SELECT * FROM species;

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);
SELECT * FROM sightings;

-- Problem 1: Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains');

-- Problem 2: Count unique species ever sighted.
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- Problem 3: Find all sightings where the location includes "Pass".
SELECT * FROM sightings
WHERE location like '%Pass';

-- Problem 4: List each ranger's name and their total number of sightings.  
SELECT name, count(ranger_id) as total_sightings FROM sightings
JOIN rangers USING(ranger_id)
GROUP BY name;

-- Problem 5: List all species that have never been sighted.
SELECT common_name FROM species
LEFT JOIN sightings USING(species_id)
WHERE sighting_id IS NULL;

-- Problem 6: Show the most recent 2 sightings.
SELECT common_name, sighting_time, name FROM sightings
JOIN species USING(species_id)
JOIN rangers USING(ranger_id)
ORDER BY sighting_time DESC LIMIT 2;

-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE extract(year from discovery_date) < 1800;

SELECT * FROM species;

-- Problem 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT sighting_id,
    CASE
        WHEN EXTRACT(hour from sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(hour from sighting_time) >= 12 AND EXTRACT(hour from sighting_time) < 17 THEN 'Afternoon'
        WHEN EXTRACT(hour from sighting_time) >= 17 THEN 'Evening'
    END 
    AS time_of_day FROM sightings;