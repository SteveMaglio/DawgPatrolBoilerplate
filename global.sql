-- LOCKER ROOM INFO
drop database DawgPatrol;

create database DawgPatrol;

use DawgPatrol;


create table if not exists LockerRoom
(
    locker_room_sex VARCHAR(6) primary key,
    num_toilets     INT not null,
    sauna_capacity  INT not null,
    towels          INT not null
--    bathroom int, -- foreign key to bathroom entity tuple
--  sauna int-- foreign key to sauna entity tuple
);

create table if not exists Locker
(
    locker_num       INT primary key,
    is_big_locker    boolean,
    locker_room_name VARCHAR(6), -- references LockerRoom (locker_room_sex)
    CONSTRAINT fk_2
        FOREIGN KEY (locker_room_name) REFERENCES LockerRoom (locker_room_sex) on UPDATE cascade on DELETE CASCADE
);

create table if not exists ComboLock
(
    lock_id     INT primary key,
    combination VARCHAR(10) not null,
    locker_num  INT, -- foreign key references Locker (locker_num)
    CONSTRAINT fk_1
        FOREIGN KEY (locker_num) REFERENCES Locker (locker_num) on UPDATE cascade on DELETE CASCADE
);


-- SECTION INFO

create table if not exists Section
(
    section_id   INT primary key,
    section_name VARCHAR(25) not null,
    floor_num    INT         not null
);

create table if not exists BodyZone
(
    body_zone_id   int primary key,
    body_zone_name VARCHAR(20) not null
);

create table if not exists Machine
(
    machine_id           INT primary key,
    machine_name         VARCHAR(30) not null,
    max_weight           INT         not null,
    section              INT, -- references Section (section_id), -- foreign key for the Section entity
    wait_time_in_minutes INT, -- could potentially be a TIME instead of int primitive

    CONSTRAINT fk_5
        FOREIGN KEY (section) REFERENCES Section (section_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists BodyZoneMachineInfo
(
    body_zone_id int, -- references BodyZone (body_zone_id),
    machine_id   int, -- references Machine (machine_id),
    PRIMARY KEY (body_zone_id, machine_id),
    CONSTRAINT fk_3
        FOREIGN KEY (body_zone_id) REFERENCES BodyZone (body_zone_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_4
        FOREIGN KEY (machine_id) REFERENCES Machine (machine_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists Employee
(
    employee_id            INT primary key,
    first_name             VARCHAR(40) not null,
    middle_name            VARCHAR(40) not null,
    last_name              VARCHAR(40) not null,
    is_male                bool,
    DoB                    date,
    job_title              VARCHAR(40), -- potential foreign key to a Jobs entity
    hourly_wage_in_dollars INT,
    reports_to             INT,         -- references Employee (employee_id), -- foreign key to Employee entity
    section_assigned_to    INT,         -- references Section (section_id),
    currently_on_shift     bool,

    CONSTRAINT fk_16
        FOREIGN KEY (reports_to) REFERENCES Employee (employee_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_17
        FOREIGN KEY (section_assigned_to) REFERENCES Section (section_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists Class
(
    class_id            INT primary key,
    class_name          VARCHAR(40),
    instructor_id       INT, -- references Employee (employee_id), -- foreign key to Employee entity,
    start_datetime      datetime,
    duration_in_minutes INT not null,
    class_capacity      INT not null,
    -- location            INT references Section (section_id)    -- foreign key to Section entity
    CONSTRAINT fk_18
        FOREIGN KEY (instructor_id) REFERENCES Employee (employee_id) on UPDATE cascade on DELETE CASCADE
);


create table if not exists Student
(
    NUid               INT primary key,
    stu_first          VARCHAR(40) not null,
    stu_middle         VARCHAR(40) not null,
    stu_last           VARCHAR(40) not null,
    is_male            bool,
    DoB                date,
    height_in_cm       INT         not null,
    weight_in_lbs      INT         not null,
    currently_in_gym   bool,
    lock_used          INT,        -- references ComboLock (lock_id),
    locker_room_used   VARCHAR(6), -- references Locker(locker_room_sex),
    section_being_used INT,        -- references Section(section_id),
    class_being_used   INT,        -- references Class (class_id),
    -- locker_used      INT references Locker(locker_num),

    CONSTRAINT fk_7
        FOREIGN KEY (lock_used) REFERENCES ComboLock (lock_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_8
        FOREIGN KEY (locker_room_used) REFERENCES LockerRoom (locker_room_sex) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_9
        FOREIGN KEY (section_being_used) REFERENCES Section (section_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_10
        FOREIGN KEY (class_being_used) REFERENCES Class (class_id) on UPDATE cascade on DELETE CASCADE


);


create table if not exists PR
(
    pr_id           int primary key,
    student_id      INT not null, -- references Student(NUid), -- foreign key to students
    pr_name_or_type VARCHAR(30),
    pr_weight       INT,
    pr_reps         INT,

    CONSTRAINT fk_6
        FOREIGN KEY (student_id) REFERENCES Student (NUid) on UPDATE cascade on DELETE CASCADE
);


-- STUDENT/TEAM INFO


create table if not exists GymCrushInfo
(
    crusher_id INT not null, -- references Student (NUid),
    crush_id   INT not null, -- references Student (NUid),
    PRIMARY KEY (crusher_id, crush_id),

    CONSTRAINT fk_11
        FOREIGN KEY (crusher_id) REFERENCES Student (NUid) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_12
        FOREIGN KEY (crush_id) REFERENCES Student (NUid) on UPDATE cascade on DELETE CASCADE
);

create table if not exists Sport
(
    sport_id    INT primary key,
    sport_name  VARCHAR(40) not null,
    num_players INT         not null
);


create table if not exists Team
(
    team_id   INT primary key,
    team_name VARCHAR(50) not null,
    num_wins  INT         not null,
    sport     INT, -- references Sport (sport_id),
    CONSTRAINT fk_13
        FOREIGN KEY (sport) REFERENCES Sport (sport_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists TeamInfo
(
    student_id INT not null, -- references Student (nuid), -- foreign key to students table
    team_id    INT not null, -- references Team (team_id), -- foreign key to Teams table
    PRIMARY KEY (team_id, student_id),
    CONSTRAINT fk_14
        FOREIGN KEY (student_id) REFERENCES Student (nuid) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_15
        FOREIGN KEY (team_id) REFERENCES Team (team_id) on UPDATE cascade on DELETE CASCADE
);


-- EMPLOYEE INFO

create table if not exists Music
(
    song_id            INT primary key,
    song_name          VARCHAR(40),
    employee_player_id INT, -- references Employee (employee_id), -- foreign key to Employee entity,
    artist             TEXT,
    genre              TEXT,
    -- location            INT references Section (section_id)    -- foreign key to Section entity
    CONSTRAINT fk_19
        FOREIGN KEY (employee_player_id) REFERENCES Employee (employee_id) on UPDATE cascade on DELETE CASCADE

);


-- TO DO:
-- SCHEDULE
-- MUSIC
-- QUEUE
-- CLASS


INSERT INTO Sport
VALUES (1, 'Soccer', 11),
       (2, 'Basketball, 5'),
       (3, 'Volleyball', 6),
       (4, 'Badminton', 2),
       (5, 'Handball', 8);

INSERT INTO Music
VALUES (1, 'Levitating', 1, 'Dua Lipa', 'Pop'),
       (2, 'Ric Flair Drip', 1, '21 Savage', 'Rap'),
       (3, 'Thunderstruck', 1, 'AC/DC', 'Rock'),
       (4, 'Life Is Good', 2, 'Drake', 'Rap'),
       (5, 'Flashing Lights', 2, 'Kanye West', 'Rap'),
       (6, 'Work', 3, 'Rihanna', 'Pop');

INSERT INTO Team
VALUES (1, 'Arsenal', 11, 1),
       (2, 'Chelsea, 5', 1),
       (3, 'Bad Boys for Life', 6, 4),
       (4, 'BumpSetSpikeTheseFools', 2, 3),
       (5, 'Nerds HC', 8, 5);

INSERT INTO TeamInfo
VALUES (1, 1),
       (2,1),
       (3,1),
       (3,3),
       (4,2),
       (5,3),
       (6,2),
       (2,4);
