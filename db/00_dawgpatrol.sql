SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `DawgPatrol` ;
CREATE SCHEMA IF NOT EXISTS `DawgPatrol` DEFAULT CHARACTER SET latin1 ;
USE `DawgPatrol` ;


create table if not exists `DawgPatrol`.`LockerRoom`
(
    locker_room_sex VARCHAR(6) primary key,
    num_toilets     INT not null,
    sauna_capacity  INT not null,
    towels          INT not null
);

create table if not exists `DawgPatrol`.`Locker`
(
    locker_num       INT primary key,
    is_big_locker    boolean,
    locker_room_name VARCHAR(6),
    CONSTRAINT fk_2
        FOREIGN KEY (locker_room_name) REFERENCES LockerRoom (locker_room_sex) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`ComboLock`
(
    lock_id     INT primary key,
    combination VARCHAR(10) not null,
    locker_num  INT,
    CONSTRAINT fk_1
        FOREIGN KEY (locker_num) REFERENCES Locker (locker_num) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`Section`
(
    section_id   INT primary key,
    section_name VARCHAR(25) not null,
    floor_num    INT         not null
);

create table if not exists `DawgPatrol`.`BodyZone`
(
    body_zone_id   int primary key,
    body_zone_name VARCHAR(20) not null
);

create table if not exists `DawgPatrol`.`Machine`
(
    machine_id           INT primary key,
    machine_name         VARCHAR(30) not null,
    max_weight           INT         not null,
    section              INT,
    wait_time_in_minutes INT,

    CONSTRAINT fk_5
        FOREIGN KEY (section) REFERENCES Section (section_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`BodyZoneMachineInfo`
(
    body_zone_id int,
    machine_id   int,
    PRIMARY KEY (body_zone_id, machine_id),
    CONSTRAINT fk_3
        FOREIGN KEY (body_zone_id) REFERENCES BodyZone (body_zone_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_4
        FOREIGN KEY (machine_id) REFERENCES Machine (machine_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`Employee`
(
    employee_id            INT primary key,
    first_name             VARCHAR(40) not null,
    middle_name            VARCHAR(40) not null,
    last_name              VARCHAR(40) not null,
    is_male                bool,
    DoB                    date,
    job_title              VARCHAR(40), -- potential foreign key to new a Jobs entity
    hourly_wage_in_dollars INT,
    reports_to             INT,
    section_assigned_to    INT,
    currently_on_shift     bool,

    CONSTRAINT fk_16
        FOREIGN KEY (reports_to) REFERENCES Employee (employee_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_17
        FOREIGN KEY (section_assigned_to) REFERENCES Section (section_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`Class`
(
    class_id            INT primary key,
    class_name          VARCHAR(40),
    instructor_id       INT,
    start_datetime      datetime,
    duration_in_minutes INT not null,
    class_capacity      INT not null,
    -- location            INT references Section (section_id)    -- foreign key to Section entity
    CONSTRAINT fk_18
        FOREIGN KEY (instructor_id) REFERENCES Employee (employee_id) on UPDATE cascade on DELETE CASCADE
);


create table if not exists `DawgPatrol`.`Student`
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
    lock_used          INT,
    locker_room_used   VARCHAR(6),
    section_being_used INT,
    class_being_used   INT,

    CONSTRAINT fk_7
        FOREIGN KEY (lock_used) REFERENCES ComboLock (lock_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_8
        FOREIGN KEY (locker_room_used) REFERENCES LockerRoom (locker_room_sex) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_9
        FOREIGN KEY (section_being_used) REFERENCES Section (section_id) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_10
        FOREIGN KEY (class_being_used) REFERENCES Class (class_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`PR`
(
    pr_id           int primary key,
    student_id      INT not null,
    pr_name_or_type VARCHAR(30),
    pr_weight       INT,
    pr_reps         INT,

    CONSTRAINT fk_6
        FOREIGN KEY (student_id) REFERENCES Student (NUid) on UPDATE cascade on DELETE CASCADE
);

-- STUDENT/TEAM INFO


create table if not exists `DawgPatrol`.`GymCrushInfo`
(
    crusher_id INT not null,
    crush_id   INT not null,
    PRIMARY KEY (crusher_id, crush_id),

    CONSTRAINT fk_11
        FOREIGN KEY (crusher_id) REFERENCES Student (NUid) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_12
        FOREIGN KEY (crush_id) REFERENCES Student (NUid) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`Sport`
(
    sport_id    INT primary key,
    sport_name  VARCHAR(40) not null,
    num_players INT         not null
);


create table if not exists `DawgPatrol`.`Team`
(
    team_id   INT primary key,
    team_name VARCHAR(50) not null,
    num_wins  INT         not null,
    sport     INT,
    CONSTRAINT fk_13
        FOREIGN KEY (sport) REFERENCES Sport (sport_id) on UPDATE cascade on DELETE CASCADE
);

create table if not exists `DawgPatrol`.`TeamInfo`
(
    student_id INT not null,
    team_id    INT not null,
    PRIMARY KEY (team_id, student_id),
    CONSTRAINT fk_14
        FOREIGN KEY (student_id) REFERENCES Student (nuid) on UPDATE cascade on DELETE CASCADE,
    CONSTRAINT fk_15
        FOREIGN KEY (team_id) REFERENCES Team (team_id) on UPDATE cascade on DELETE CASCADE
);


-- EMPLOYEE INFO

create table if not exists `DawgPatrol`.`Music`
(
    song_id            INT primary key,
    song_name          VARCHAR(40),
    employee_player_id INT,
    artist             TEXT,
    genre              TEXT,
    CONSTRAINT fk_19
        FOREIGN KEY (employee_player_id) REFERENCES Employee (employee_id) on UPDATE cascade on DELETE CASCADE

);

INSERT INTO LockerRoom
VALUES ('Male', 4, 6, 87),
       ('Female', 10, 1, 60);

INSERT INTO Locker
VALUES (10, 0, 'Female'),
       (12, 1, 'Male'),
       (13, 1, 'Male'),
       (14, 0, 'Male'),
       (15, 0, 'Male'),
       (16, 1, 'Male'),
       (17, 0, 'Male');

INSERT INTO ComboLock
VALUES (47, '9878', 10),
       (103, '7776', 12);

INSERT INTO Section
VALUES (7, 'Weight Room', 3),
       (4, 'Yoga Room', 2);

INSERT INTO BodyZone
VALUES (7, 'Glutes'),
       (4, 'Biceps');

INSERT INTO Machine
VALUES (10, 'Bench', 135, 7, 34),
       (13, 'Squat Rack', 600, 7, 54);

INSERT INTO BodyZoneMachineInfo
VALUES (7, 13),
       (4, 10);


INSERT INTO Employee
VALUES (10, 'Alison', 'Cecilia', 'Picerno', 0, '2003-07-11', 'Manager', 40, null, 7, 1),
       (21, 'Margot', 'Arden', 'Johnson', 0, '1999-12-12', 'Trainer', 17, 10, 4, 0);



INSERT INTO Class
Values (7, 'Yoga', 10, '14-02-23 09.00.00', 60, 10),
       (10, 'Spin', 21, '17-03-22 04.00.00', 75, 15);


INSERT INTO Student
VALUES (001029293, 'Stephen', 'Gallagher', 'Magliocchino', True, '2002-02-13', 185, 180, True, 47, 'Male', 7, 7),
       (001283393, 'Connor', 'IDK', 'Garmey', True, '2003-11-07', 160, 165, True, 103, 'Male', 4, 10),
       (001093393, 'Robert', 'Maxwell', 'Leroux', True, '2002-04-20', 160, 165, True, null, 'Male', 4, 10);

INSERT INTO GymCrushInfo
VALUES (001029293, 001283393);


INSERT INTO PR
VALUES (10, 001029293, 'bench press', 275, 10);


INSERT INTO Sport
VALUES (1, 'Soccer', 11),
       (2, 'Basketball', 5),
       (3, 'Volleyball', 6),
       (4, 'Badminton', 2),
       (5, 'Handball', 8);

INSERT INTO Music
VALUES (1, 'Levitating', 10, 'Dua Lipa', 'Pop'),
       (2, 'Ric Flair Drip', 10, '21 Savage', 'Rap'),
       (3, 'Thunderstruck', 10, 'AC/DC', 'Rock'),
       (4, 'Life Is Good', 21, 'Drake', 'Rap'),
       (5, 'Flashing Lights', 21, 'Kanye West', 'Rap'),
       (6, 'Work', 10, 'Rihanna', 'Pop');

INSERT INTO Team
VALUES (1, 'Arsenal', 11, 1),
       (2, 'Chelsea', 5, 1),
       (3, 'Bad Boys for Life', 6, 4),
       (4, 'BumpSetSpikeTheseFools', 2, 3),
       (5, 'Nerds HC', 8, 5);

INSERT INTO TeamInfo
VALUES (001029293, 1),
       (001029293, 3),
       (001283393, 3),
       (001283393, 2),
       (001283393, 4);

select * from Locker;