/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


START TRANSACTION;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

START TRANSACTION;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

START TRANSACTION;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

START TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, AVG(escape_attempts) AS average_escape_attempts FROM animals GROUP BY neutered ORDER BY average_escape_attempts DESC;
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species ORDER BY species;
SELECT species, AVG(escape_attempts) AS average_escape_attempts FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species ORDER BY species;

SELECT name FROM animals WHERE owner_id = 4;
SELECT name FROM animals WHERE species_id = 1;
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON animals.owner_id = owners.id;
SELECT species.name, COUNT(*) AS animal_count FROM species LEFT JOIN animals ON animals.species_id = species.id GROUP BY species.name;
SELECT animals.name FROM animals INNER JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Jennifer Orwell' AND animals.species_id = 2;
SELECT animals.name FROM animals INNER JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
SELECT owners.full_name, COUNT(*) AS animal_count FROM owners LEFT JOIN animals ON animals.owner_id = owners.id GROUP BY owners.full_name ORDER BY animal_count DESC LIMIT 1;


SELECT animals.name FROM animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'William Tatcher' ORDER BY visits.date_of_visit DESC LIMIT 1;
SELECT COUNT(DISTINCT animal_id) AS num_animals FROM visits WHERE vet_id = 3;
SELECT vets.name, ARRAY_TO_STRING(ARRAY_AGG(species.name), ', ') AS specialties FROM vets LEFT JOIN specializations ON vets.id = specializations.vet_id LEFT JOIN species ON specializations.species_id = species.id GROUP BY vets.name;
SELECT animals.name FROM animals INNER JOIN visits ON animals.id = visits.animal_id WHERE visits.vet_id = 3 AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';
SELECT animals.name, COUNT(visits.animal_id) AS num_visits FROM animals INNER JOIN visits ON animals.id = visits.animal_id GROUP BY animals.name ORDER BY num_visits DESC LIMIT 1;
SELECT animals.name FROM animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON visits.vet_id = vets.id WHERE vets.name = 'Maisy Smith' ORDER BY visits.date_of_visit ASC LIMIT 1;
SELECT animals.name, vets.name, visits.date_of_visit FROM animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON visits.vet_id = vets.id ORDER BY visits.date_of_visit DESC LIMIT 1;
SELECT COUNT(*) AS num_visits FROM visits WHERE NOT EXISTS (SELECT * FROM specializations WHERE specializations.vet_id = visits.vet_id AND specializations.species_id = visits.animal_id);
SELECT s.name AS recommended_specialty FROM species s JOIN (SELECT a.species_id, COUNT(*) AS visit_count FROM visits v JOIN vets vet ON v.vet_id = vet.id JOIN animals a ON v.animal_id = a.id JOIN owners o ON a.owner_id = o.id WHERE vet.name = 'Maisy Smith' GROUP BY a.species_id ORDER BY visit_count DESC LIMIT 1) most_visited_species ON s.id = most_visited_species.species_id;
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits WHERE animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits WHERE vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners WHERE email = 'owner_18327@mail.com';
