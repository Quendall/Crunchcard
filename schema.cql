DROP KEYSPACE IF EXISTS card;
CREATE KEYSPACE card WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1}
                      AND DURABLE_WRITES = FALSE;
USE card;

--#region //// Users /////////////////////////////////////

DROP TABLE IF EXISTS card.user;

CREATE TABLE IF NOT EXISTS card.user (
    user_id    UUID,      -- snowflake
    deleted    BOOLEAN,   -- never delete - is this necessary?
    email      TEXT,
    flags      INT,       -- user flags - bitfield -  see card.user_flag table
    name       TEXT,      -- user display name
    phone      TEXT,      -- required mfa - start with sms, offer app eventually
    updated_at TIMESTAMP, -- user profile last saved on date
    username   TEXT,      -- must be globally unique
    PRIMARY KEY (user_id)
);

DROP TABLE IF EXISTS card.user_flag;
CREATE TABLE IF NOT EXISTS card.user_flag (
    bit_shift     INT,  --bit left shift
    description   TEXT,
    first_used_on TIMESTAMP,
    name          TEXT, -- snake_case name
    operator      TEXT, -- bitwise left shift operator. The << symbol is used to shift the bits of the first operand to the left by the number of positions specified by the second operand.
    value         INT,
    PRIMARY KEY (bit_shift)
);

/*
-- In a bitfield the bitwise left shift operator 1 << 3 means that we are shifting the value of 1 three bits to the left.
-- This is equivalent to multiplying 1 by 2^3 or 8. Therefore, 1 << 3 is equal to 8.

Operator    Shift   Power   Result  Calculation
1<<0        0       2^0     1       1 x 2^0
1<<1        1       2^1     2       1 x 2^1
1<<2        2       2^2     4       1 x 2^2
1<<3        3       2^3     8       1 x 2^3
1<<4        4       2^4     16      1 x 2^4
1<<5        5       2^5     32      1 x 2^5
1<<6        6       2^6     64      1 x 2^6
1<<7        7       2^7     128     1 x 2^7
1<<8        8       2^8     256     1 x 2^8
1<<9        9       2^9     512     1 x 2^9
1<<10       10      2^10    1024    1 x 2^10
1<<11       11      2^11    2048    1 x 2^11
1<<12       12      2^12    4096    1 x 2^12


 */

--#endregion //// Users //////////////////////////////////

--#region //// cards /////////////////////////////////////

DROP TABLE IF EXISTS card.folder;
CREATE TABLE IF NOT EXISTS card.folder (
    user_id UUID, -- snowflake
    set_id  UUID,
    folder  TEXT,
    PRIMARY KEY ( user_id, set_id )
);

CREATE TYPE IF NOT EXISTS card.PARTICIPANT (
    user_id         UUID,
    name            TEXT,
    email           TEXT,
    role_id         INT  -- 0=owner, 1=editor, 2=view_only
);

CREATE TABLE IF NOT EXISTS card.card_set (
    set_id      UUID,
    title       TEXT,
    description TEXT,
    folder      TEXT,
    permissions MAP<UUID, FROZEN<PARTICIPANT>>,
    PRIMARY KEY ( folder, set_id )
);

DROP TABLE IF EXISTS card.card;
CREATE TABLE IF NOT EXISTS card.card (
    card_id       UUID,
    set_id        UUID,
    is_deleted    BOOLEAN,
    card_question TEXT,
    card_answer   TEXT,
    updated_at    TIMESTAMP,
    created_at    TIMESTAMP,
    PRIMARY KEY ((set_id), card_id)
);

--#endregion //// cards //////////////////////////////////

-- CREATE TABLE IF NOT EXISTS card.folder (
--     -- folder_parent_id    UUID,    -- maybe add folder hierarchy later
--     folder_id          UUID,
--     folder_name        TEXT,
--     folder_description TEXT,
--     PRIMARY KEY ( folder_id )
-- );

-- CREATE TABLE IF NOT EXISTS card.card (
--     card_id    UUID,
--     set_id     UUID,
--     is_deleted BOOLEAN,
--     card_question TEXT,
--     card_answer  TEXT,
--     updated_at TIMESTAMP,
--     created_at TIMESTAMP,
--     PRIMARY KEY (( set_id, card_id ), created_at, updated_at)
-- ) WITH CLUSTERING ORDER BY (created_at DESC);

-- DROP TABLE IF EXISTS card.card;
-- CREATE TABLE IF NOT EXISTS card.card (
--     card_id    UUID,
--     set_id     UUID,
--     is_deleted BOOLEAN,
--     card_question TEXT,
--     card_answer  TEXT,
--     updated_at TIMESTAMP,
--     created_at TIMESTAMP,
--     PRIMARY KEY ( ( set_id ), card_id, created_at)
-- ) WITH CLUSTERING ORDER BY (created_at DESC);