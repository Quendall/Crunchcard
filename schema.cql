CREATE KEYSPACE cardset_space WITH replication = {'class': 'NetworkTopologyStrategy', 'AWS_US_WEST_2' : 3} AND durable_writes = true;
  USE cardset_space;

CREATE TABLE user (
    user_id UUID PRIMARY KEY,
    username TEXT,
    nickname TEXT,
    email TEXT,
);

-- CREATE TABLE cardset (
--     cardset_id UUID PRIMARY KEY,
--     title TEXT,
--     description TEXT,
--     folder TEXT,
-- );

CREATE TABLE card (
    card_id UUID PRIMARY KEY,
    card_question TEXT,
    card_answer TEXT,
    card_created_on TIMESTAMP,
    card_modified_on TIMESTAMP,
    cardset_id UUID,
    cardset_title TEXT,
    cardset_description TEXT,
    permissions map<UUID, TINYINT>, -- {user, permission bit}
    folder TEXT
);

-- INSERT INTO monkey_species (species, common_name, population, average_size) VALUES ('Saguinus niger', 'Black tamarin', 10000, 500);
-- SELECT * FROM monkey_species;

DROP KEYSPACE cardset_space;