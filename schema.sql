/* Database schema to keep the structure of entire database. */
CREATE DATABASE vet_clinic;

CREATE TABLE animals (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT,
  neutered BOOLEAN NOT NULL,
  weight_kg DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(255);

CREATE TABLE owners (id SERIAL PRIMARY KEY, full_name VARCHAR(255) NOT NULL, age INT NOT NULL);

CREATE TABLE species (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL);

ALTER TABLE animals ADD CONSTRAINT pk_animals PRIMARY KEY (id);
ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);

CREATE TABLE vets (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, age INT NOT NULL, date_of_graduation DATE NOT NULL);
CREATE TABLE specializations (species_id INT NOT NULL, vet_id INT NOT NULL, PRIMARY KEY (species_id, vet_id), FOREIGN KEY (species_id) REFERENCES species(id), FOREIGN KEY (vet_id) REFERENCES vets(id));
CREATE TABLE visits (animal_id INT NOT NULL, vet_id INT NOT NULL, date_of_visit DATE NOT NULL, FOREIGN KEY (animal_id) REFERENCES animals(id), FOREIGN KEY (vet_id) REFERENCES vets(id));

ALTER TABLE owners ADD COLUMN email VARCHAR(120);

create index idx_animal_id on visits(animal_id);