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
    start_datetime      date,
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


INSERT INTO Section
VALUES (7, 'Weight Room', 3),
       (4, 'Yoga Room', 2);

INSERT INTO Machine
VALUES (10, 'Bench', 135, 7, 34),
       (13, 'Squat Rack', 600, 7, 54);

INSERT INTO BodyZoneMachineInfo
VALUES (7, 13),
       (4, 10);


INSERT INTO Employee
VALUES (100000, 'Alison', 'Cecilia', 'Picerno', 0, '2003-07-11', 'Manager', 40, null, 7, 1),
       (100001, 'Margot', 'Arden', 'Johnson', 0, '1999-12-12', 'Trainer', 17, 10, 4, 0);



INSERT INTO Class
Values (99, 'Yoga', 10, '14-02-23 09.00.00', 60, 10),
       (100, 'Spin', 21, '17-03-22 04.00.00', 75, 15);


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


USE `DawgPatrol` ;

INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,165);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,210);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,258);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,272);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,233);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,27);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,179);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,28);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,92);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,23);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,169);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,253);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,248);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,250);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,147);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,239);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,151);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,64);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,82);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,291);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,155);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,241);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,126);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,256);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,75);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,257);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,296);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,273);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,122);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,176);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,80);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,286);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,22);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,195);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,283);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,228);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,107);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,174);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,219);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,214);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,251);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,32);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,269);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,265);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,79);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,238);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,250);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,199);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,101);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,258);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,118);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,255);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,61);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,282);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,11);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,163);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,239);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,78);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,171);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,217);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,239);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,140);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,207);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,109);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,92);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,127);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,117);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,225);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,285);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,228);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,265);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,45);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,244);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,84);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,148);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,293);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,2);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,18);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,10);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,298);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,269);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,130);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,7);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,35);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,134);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,185);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,216);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,183);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,146);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,235);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,199);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,254);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,208);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,287);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,273);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,203);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,295);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,10);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,290);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,57);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,20);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,163);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,145);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,43);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,102);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,14);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,275);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,187);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,208);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,112);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,195);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,165);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,121);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,161);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,247);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,261);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,245);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,277);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,73);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,17);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,287);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,297);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,197);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,193);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,67);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,59);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,50);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,51);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,20);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,40);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,188);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,186);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,153);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,227);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,64);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,174);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,137);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,240);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,233);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,170);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,171);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,124);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,234);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,229);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,212);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,6);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,245);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,66);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,89);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,95);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,213);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,185);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,197);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,231);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,34);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,209);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,116);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,214);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,294);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,71);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,220);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,92);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,58);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,159);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,66);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,133);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,228);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,108);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,298);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,17);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,162);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,126);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,300);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,125);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,4);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,299);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,92);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,183);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,29);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,221);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,161);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,173);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,245);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,169);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,81);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,33);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,190);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,39);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,178);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,145);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,274);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,60);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,234);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,8);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,198);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,56);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,116);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,286);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,231);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,21);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,74);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,201);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,199);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,248);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,202);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,262);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,80);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,197);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,224);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,271);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,79);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,70);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,130);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,158);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,240);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,53);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,49);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,271);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,259);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,198);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,31);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,90);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,63);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,98);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,260);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,5);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,205);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,258);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,113);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,245);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,47);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,299);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,188);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,138);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,150);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,262);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,284);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,31);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,248);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,167);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,296);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,140);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,99);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,291);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,113);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,141);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,234);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,149);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,267);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,95);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,177);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,258);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,117);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,8);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,9);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,91);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,223);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,73);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (2,44);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,2);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,115);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,267);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,111);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,120);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,59);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (1,12);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,273);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,106);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (9,222);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (7,195);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (4,167);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,125);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,19);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (5,142);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (3,266);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (6,28);
INSERT INTO BodyZoneMachineInfo(body_zone_id,machine_id) VALUES (8,243);



INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('bicep',1);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('triceps',2);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('quad',3);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('calf',4);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('glute',5);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('shoulder',6);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('chest',7);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('hamstring',8);
INSERT INTO BodyZone(body_zone_name,body_zone_id) VALUES ('back',9);










INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Joe Versus the Volcano',109,'2023-03-24',69,23,1);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Steal This Movie!',97,'2024-2-15',48,54,2);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Turkish Delight (Turks fruit)',90,'2024-3-29',70,19,3);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Fist of Legend (Jing wu ying xiong)',87,'2022-8-21',110,45,4);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('The Care Bears Adventure in Wonderland',119,'2023-7-12',107,53,5);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Bye Bye Braverman',80,'2022-4-30',40,14,6);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Bounce: Behind the Velvet Rope',105,'2023-9-1',116,60,7);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Gun the Man Down',33,'2022-7-13',88,24,8);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Hate (Haine, La)',35,'2024-2-22',63,29,9);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Internet',116,'2022-12-16',98,57,10);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Indian in the Cupboard, The',138,'2022-10-15',63,58,11);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Tank Girl',68,'2023-4-10',44,28,12);
INSERT INTO Class(class_name,instructor_id,start_datetime,duration_in_minutes,class_capacity,class_id) VALUES ('Reagan',13,'2023-5-12',69,44,13);


INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-14-42',565,1);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-70-15',61,2);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('05-57-19',436,3);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-39-42',769,4);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-79-51',701,5);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-18-03',93,6);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-87-51',650,7);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-11-74',742,8);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-29-69',335,9);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-54-71',278,10);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-85-59',15,11);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-49-95',772,12);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-67-31',164,13);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-27-54',754,14);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('02-92-64',858,15);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('61-73-22',234,16);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-21-02',811,17);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-83-32',410,18);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-30-54',20,19);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('72-37-03',603,20);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-17-30',72,21);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-27-10',123,22);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-47-26',793,23);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-03-42',148,24);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-21-10',544,25);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-41-16',135,26);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-50-25',824,27);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-35-05',855,28);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('73-69-75',18,29);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-32-47',84,30);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-93-32',623,31);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-22-32',142,32);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-32-20',186,33);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-35-00',814,34);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-52-51',284,35);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-85-19',960,36);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-45-04',979,37);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-52-28',107,38);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-94-28',636,39);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-19-66',266,40);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-41-26',335,41);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-88-37',679,42);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('82-81-20',875,43);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-36-02',843,44);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-05-24',759,45);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-88-17',982,46);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-63-97',424,47);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-12-89',376,48);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-03-19',919,49);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-92-92',744,50);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-60-99',165,51);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('82-17-26',137,52);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-71-95',549,53);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-71-88',866,54);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-84-34',22,55);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-25-44',373,56);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-25-00',565,57);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-74-97',276,58);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-48-11',119,59);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-09-87',822,60);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-66-19',593,61);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-32-08',618,62);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-57-41',679,63);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-31-57',344,64);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-58-27',847,65);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-68-92',68,66);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-05-73',219,67);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-91-11',480,68);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-82-67',805,69);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-02-81',413,70);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-63-84',134,71);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-47-37',799,72);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-64-60',514,73);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-26-98',986,74);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-44-09',668,75);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-81-70',379,76);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-87-18',935,77);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-54-96',620,78);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-15-21',759,79);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-38-16',974,80);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-84-94',527,81);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-06-01',222,82);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-17-98',893,83);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-90-96',946,84);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-51-32',649,85);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-05-93',275,86);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-76-18',699,87);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-19-65',891,88);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-47-42',128,89);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-26-02',428,90);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-02-37',946,91);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-09-07',523,92);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-48-46',129,93);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-26-87',928,94);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-19-88',473,95);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-76-55',608,96);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-07-69',332,97);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('02-57-68',286,98);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-55-60',38,99);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-43-61',400,100);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-31-95',747,101);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-10-38',916,102);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-77-04',771,103);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('85-50-45',112,104);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-19-72',742,105);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-47-70',903,106);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('82-35-10',80,107);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('05-71-56',425,108);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-60-85',946,109);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-60-10',255,110);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-37-47',305,111);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-04-19',392,112);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-17-01',564,113);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-27-63',329,114);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-85-15',91,115);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-40-47',514,116);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-97-07',943,117);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-01-26',55,118);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-70-35',20,119);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-96-77',102,120);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-84-73',986,121);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-07-35',665,122);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-11-14',450,123);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-08-55',285,124);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-23-23',919,125);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-22-15',851,126);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-62-83',813,127);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-04-89',896,128);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('61-74-61',595,129);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('31-17-86',581,130);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-73-89',43,131);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-69-95',997,132);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-05-39',134,133);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-95-86',901,134);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-53-55',590,135);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-37-12',37,136);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-99-78',903,137);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-78-02',871,138);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-51-03',920,139);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-77-84',948,140);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-00-52',648,141);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-56-85',305,142);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-58-46',707,143);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-18-57',581,144);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-98-09',331,145);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-12-54',897,146);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-15-08',729,147);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-66-10',256,148);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('47-51-24',507,149);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-19-13',862,150);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-79-32',316,151);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-71-14',114,152);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-82-61',300,153);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-20-06',707,154);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-17-33',624,155);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-62-26',742,156);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-70-78',38,157);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-49-65',76,158);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-07-04',387,159);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-59-27',381,160);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-20-94',847,161);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-94-26',2,162);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-41-73',984,163);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-81-60',623,164);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-99-27',612,165);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-61-90',183,166);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-34-34',201,167);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-61-94',82,168);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-52-96',91,169);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-37-13',940,170);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-81-33',403,171);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-59-10',630,172);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-22-63',891,173);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-85-91',835,174);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-95-67',886,175);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-98-07',696,176);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-36-51',336,177);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-63-27',493,178);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-09-69',634,179);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-46-87',65,180);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-74-09',298,181);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-73-70',373,182);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-27-78',708,183);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-35-26',424,184);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-03-28',83,185);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-25-72',895,186);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-89-63',960,187);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-16-45',58,188);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-73-22',73,189);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-33-12',199,190);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-58-98',357,191);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-71-05',663,192);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-37-19',300,193);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-62-40',53,194);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-97-13',42,195);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-03-40',335,196);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-41-49',295,197);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-47-49',650,198);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-97-38',652,199);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('31-38-38',439,200);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-33-37',197,201);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-22-98',835,202);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-91-74',648,203);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-83-34',348,204);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-71-68',39,205);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-52-51',353,206);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('61-39-66',164,207);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-62-49',37,208);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-67-37',405,209);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-36-45',164,210);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-13-76',466,211);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-88-63',523,212);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-08-67',117,213);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-67-84',562,214);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-50-65',462,215);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-15-93',23,216);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-24-87',334,217);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-65-03',260,218);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-11-44',634,219);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-23-17',283,220);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-64-87',623,221);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-36-86',4,222);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-76-04',608,223);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-26-61',206,224);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-23-96',410,225);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-42-16',19,226);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-25-67',189,227);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-80-72',678,228);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-79-19',165,229);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-30-23',946,230);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-93-78',279,231);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-65-85',504,232);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-76-58',128,233);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-19-22',919,234);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-54-19',655,235);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-62-85',215,236);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-23-85',332,237);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-62-17',280,238);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-24-79',80,239);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-47-45',229,240);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-01-78',142,241);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-25-91',571,242);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-82-61',344,243);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-88-52',617,244);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-89-40',701,245);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-89-64',24,246);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-33-47',294,247);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-62-51',447,248);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-49-45',58,249);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-32-67',191,250);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-58-18',666,251);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-91-61',952,252);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-57-56',513,253);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-71-28',568,254);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-60-81',37,255);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-52-12',825,256);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-49-10',834,257);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-34-40',803,258);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-19-90',742,259);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('75-27-38',642,260);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-87-81',919,261);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-30-98',133,262);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('94-05-64',428,263);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-85-98',450,264);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-84-27',550,265);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-93-45',194,266);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-66-28',391,267);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-71-89',464,268);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-47-55',896,269);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-20-50',615,270);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-59-84',649,271);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-13-65',268,272);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-73-15',972,273);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-93-38',331,274);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-33-07',433,275);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-92-44',690,276);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-33-78',294,277);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-92-10',54,278);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-73-99',167,279);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-47-61',618,280);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-13-47',431,281);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-93-58',734,282);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-05-94',988,283);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-12-10',758,284);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-84-22',571,285);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('77-27-93',486,286);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('61-23-05',780,287);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-21-43',457,288);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-50-45',367,289);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-44-05',226,290);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-16-38',518,291);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-39-58',42,292);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-20-19',198,293);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-29-65',806,294);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-79-47',717,295);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-61-37',282,296);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-71-80',184,297);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-41-91',667,298);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-77-49',743,299);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-01-98',474,300);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-45-32',72,301);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('85-10-39',33,302);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-51-19',183,303);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-71-37',816,304);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-59-33',332,305);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-70-98',997,306);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-88-36',940,307);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-71-25',802,308);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-96-62',502,309);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-25-84',618,310);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('30-28-04',95,311);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-65-58',769,312);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-66-46',926,313);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-36-58',5,314);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-54-51',772,315);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-98-63',181,316);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('30-18-31',15,317);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-74-74',389,318);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('20-79-72',435,319);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-12-97',336,320);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-19-27',396,321);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-01-65',752,322);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-92-03',500,323);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-47-50',305,324);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('30-27-37',68,325);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-28-06',727,326);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-45-45',432,327);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-35-94',221,328);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-59-20',832,329);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-25-94',381,330);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-26-35',384,331);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-58-99',956,332);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-79-52',480,333);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-71-41',819,334);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-11-98',285,335);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-68-34',229,336);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-49-24',649,337);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-46-98',613,338);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-01-06',555,339);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-55-75',579,340);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('11-99-89',109,341);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-35-79',487,342);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('77-41-07',47,343);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-26-56',980,344);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-13-46',833,345);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('22-08-90',15,346);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-43-69',581,347);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-72-97',693,348);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-96-01',960,349);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-12-68',142,350);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-44-05',757,351);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-75-47',128,352);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-73-06',625,353);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-65-30',235,354);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-27-28',68,355);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-66-57',799,356);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-01-91',857,357);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-53-98',979,358);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-66-38',780,359);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-60-76',357,360);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-26-42',129,361);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-82-99',803,362);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('11-61-83',443,363);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-25-65',946,364);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-62-99',624,365);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-89-35',731,366);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-13-92',42,367);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-61-84',588,368);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-44-61',595,369);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-38-38',442,370);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-55-94',659,371);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-14-00',765,372);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-26-01',825,373);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-13-97',500,374);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-76-58',81,375);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-68-79',848,376);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('94-55-35',530,377);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-02-65',119,378);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-82-50',907,379);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-89-85',592,380);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-40-76',518,381);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-44-41',690,382);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('82-75-04',306,383);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-54-71',960,384);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-94-11',264,385);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-87-24',745,386);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-55-88',549,387);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-97-44',642,388);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-31-05',173,389);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-42-50',630,390);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-07-53',949,391);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-52-59',428,392);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-34-68',531,393);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('30-04-74',82,394);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-43-60',633,395);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-98-65',268,396);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-81-38',336,397);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-11-91',244,398);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-80-42',82,399);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-57-70',842,400);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-18-84',464,401);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-77-53',682,402);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-82-34',530,403);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-00-05',199,404);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-67-89',966,405);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-54-37',285,406);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-13-48',891,407);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-25-93',43,408);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-51-31',24,409);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-98-83',78,410);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-92-45',284,411);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-92-95',718,412);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-28-98',164,413);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-82-61',175,414);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-70-95',396,415);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-74-30',788,416);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-94-56',345,417);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-64-10',216,418);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-84-09',759,419);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('85-73-84',876,420);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-31-63',517,421);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-03-05',590,422);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-20-41',941,423);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-85-74',793,424);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('75-33-28',317,425);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-52-77',869,426);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-08-94',856,427);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-66-02',42,428);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-41-76',915,429);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-24-59',571,430);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-91-50',857,431);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-38-04',918,432);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-69-54',886,433);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-89-93',577,434);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-72-12',524,435);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-73-49',412,436);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-09-43',810,437);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-58-46',673,438);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-65-46',832,439);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('61-37-57',886,440);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-05-62',825,441);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('72-30-53',398,442);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-72-55',472,443);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-03-61',549,444);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-71-09',990,445);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-74-63',513,446);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-13-51',888,447);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-71-79',974,448);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-35-76',983,449);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-24-79',5,450);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-73-29',971,451);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-25-51',189,452);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-73-18',549,453);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-38-21',449,454);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-98-06',146,455);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-48-62',472,456);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-02-76',332,457);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-70-78',86,458);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-78-33',270,459);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-66-96',175,460);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-21-26',146,461);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-40-62',696,462);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-35-20',127,463);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-66-34',974,464);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-32-58',893,465);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-10-90',845,466);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-72-97',634,467);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-29-54',824,468);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-81-13',723,469);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-85-65',500,470);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-75-78',189,471);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-28-42',432,472);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-45-33',819,473);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-69-95',396,474);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-92-84',921,475);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-16-35',731,476);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-10-40',579,477);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-74-99',747,478);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-83-61',237,479);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-59-05',841,480);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-13-54',280,481);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-52-69',668,482);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-38-77',11,483);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-42-68',693,484);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-86-64',211,485);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-99-25',996,486);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-02-95',413,487);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-59-58',395,488);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-76-19',892,489);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-88-53',279,490);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-95-10',810,491);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-72-28',676,492);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('11-33-84',198,493);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-07-14',956,494);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-11-03',997,495);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-51-87',388,496);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-84-47',43,497);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-01-09',346,498);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-67-57',135,499);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-05-10',305,500);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-68-59',483,501);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-74-61',926,502);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-59-23',162,503);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-00-75',940,504);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-88-34',522,505);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-21-46',92,506);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-94-28',661,507);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-34-14',189,508);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-51-54',184,509);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-66-84',999,510);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-16-37',180,511);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-74-62',150,512);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-13-16',633,513);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-40-79',608,514);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-77-06',417,515);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-80-22',163,516);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-16-69',883,517);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-74-81',218,518);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-55-20',376,519);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-49-86',212,520);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-57-89',641,521);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-38-21',418,522);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('73-89-43',347,523);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('73-88-00',662,524);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-00-32',756,525);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-59-27',33,526);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-33-88',445,527);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-40-35',238,528);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-05-65',667,529);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-81-56',824,530);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-50-92',346,531);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-06-13',175,532);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-94-15',507,533);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-15-79',654,534);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-99-70',971,535);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-62-11',865,536);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-57-58',747,537);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-02-12',712,538);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-80-89',53,539);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-96-65',229,540);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-53-89',201,541);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-03-51',42,542);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('11-93-11',675,543);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-89-72',757,544);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-51-43',220,545);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-37-28',723,546);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-39-37',298,547);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-06-31',969,548);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-76-71',678,549);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-23-05',821,550);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-68-12',764,551);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-33-39',96,552);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('82-23-92',337,553);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-81-68',813,554);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-99-54',16,555);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-13-65',875,556);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-97-10',68,557);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('77-89-40',447,558);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-17-32',987,559);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('42-01-75',18,560);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-18-29',229,561);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-61-02',928,562);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-31-18',191,563);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-63-96',562,564);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-74-13',461,565);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-54-32',358,566);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-08-36',330,567);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-03-90',943,568);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-60-98',255,569);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-89-60',919,570);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-86-86',348,571);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-05-85',447,572);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-92-77',819,573);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-35-94',666,574);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-92-78',711,575);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-65-26',219,576);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-03-48',822,577);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-14-63',987,578);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-97-69',78,579);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-73-23',782,580);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-51-34',855,581);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-40-64',699,582);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-00-97',513,583);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-46-73',364,584);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-22-53',757,585);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('77-50-74',806,586);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-17-55',940,587);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-71-78',912,588);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-72-56',688,589);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-51-23',742,590);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-82-03',123,591);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-00-31',943,592);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-90-87',237,593);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-27-71',972,594);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-22-56',85,595);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('42-32-23',814,596);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-00-46',832,597);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-45-26',201,598);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-25-60',162,599);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-36-21',984,600);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-06-40',328,601);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-92-22',854,602);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-73-08',167,603);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-57-09',48,604);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-97-80',918,605);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-21-81',100,606);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-69-83',146,607);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-43-91',191,608);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-46-41',410,609);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-51-15',198,610);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-06-92',229,611);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-50-18',625,612);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-20-35',661,613);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-51-57',599,614);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-11-84',635,615);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-56-98',523,616);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-57-83',829,617);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('73-74-20',920,618);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-22-84',790,619);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-16-01',487,620);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-28-03',140,621);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-54-05',680,622);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-79-65',847,623);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-30-45',581,624);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-75-13',949,625);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-98-46',986,626);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-47-58',142,627);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-31-97',806,628);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-31-31',790,629);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-46-06',603,630);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-28-50',948,631);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-95-41',191,632);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-43-23',284,633);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-09-26',866,634);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-46-54',419,635);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-75-70',269,636);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-81-60',654,637);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-09-02',9,638);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-60-22',763,639);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-26-90',590,640);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-24-31',966,641);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-00-52',503,642);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-70-04',904,643);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-48-27',611,644);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-17-82',11,645);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-94-45',675,646);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-16-76',760,647);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-90-88',908,648);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-17-24',336,649);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('72-99-20',997,650);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-11-40',278,651);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-70-91',858,652);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-71-69',197,653);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-85-84',833,654);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('42-02-08',347,655);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('31-64-49',745,656);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-81-56',499,657);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-35-44',286,658);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-80-92',472,659);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-69-64',498,660);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-83-23',713,661);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('46-51-34',841,662);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-60-92',316,663);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-44-42',735,664);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-68-29',606,665);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-89-85',661,666);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-54-88',747,667);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-40-66',186,668);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-29-40',866,669);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-53-62',110,670);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('15-82-87',54,671);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-83-73',110,672);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-72-49',298,673);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-23-19',354,674);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-66-58',173,675);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-23-51',857,676);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-60-83',890,678);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-69-82',608,679);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-76-69',594,680);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-28-05',47,681);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-02-00',232,682);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-79-86',126,683);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-43-27',45,684);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-80-73',915,685);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-33-31',93,686);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-41-67',336,687);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-27-13',428,688);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-69-25',264,689);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('02-61-13',25,690);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-19-49',802,691);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-69-25',95,692);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-87-85',914,693);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-76-33',215,694);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-61-67',760,695);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('61-84-19',229,696);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-71-69',527,697);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-09-20',223,698);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-85-44',371,699);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-92-05',462,700);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-19-42',876,701);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-57-00',767,702);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-92-37',857,703);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-51-40',701,704);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-52-65',751,705);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-66-92',47,706);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-67-28',8,707);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-59-46',718,708);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-09-69',146,709);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-06-22',472,710);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-51-96',675,711);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-57-97',384,712);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-53-07',488,713);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-36-12',940,714);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-08-52',184,715);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('02-77-94',790,716);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-64-00',745,717);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-53-84',659,718);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-60-56',793,719);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-77-94',499,720);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-60-32',856,721);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-80-11',336,722);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-15-17',190,723);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('05-13-62',529,724);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-56-29',623,725);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-40-35',119,726);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-08-78',336,727);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-73-63',518,728);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-06-58',747,729);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('20-18-55',37,730);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-87-96',623,731);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-03-69',713,732);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-05-65',269,733);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-68-52',759,734);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-91-33',631,735);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('05-05-46',680,736);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-52-25',988,737);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-91-51',355,738);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-04-29',263,739);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-42-87',233,740);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-94-50',320,741);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-13-59',175,742);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('02-96-53',928,743);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-61-69',99,744);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-87-27',875,745);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-66-79',849,746);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-97-61',443,747);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-66-67',623,748);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('22-63-13',701,749);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-70-79',699,750);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-95-44',347,751);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-07-42',43,752);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-27-32',305,753);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-10-71',790,754);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-73-85',449,755);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-40-31',398,756);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-27-76',940,757);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-50-05',999,758);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-85-43',123,759);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-61-81',107,760);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('59-71-65',27,761);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-86-13',662,762);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-01-64',433,763);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-28-07',789,764);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-55-21',842,765);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-06-46',244,766);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-33-42',608,767);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-15-85',48,768);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-31-32',914,769);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-17-73',215,770);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-38-16',24,771);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-98-60',16,772);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-26-73',819,773);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('75-04-13',43,774);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-33-76',863,775);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-59-56',856,776);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('64-96-05',503,777);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('31-29-52',118,778);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-64-25',162,779);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-58-99',109,780);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('20-66-15',765,781);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-68-08',906,782);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-87-60',846,783);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-70-05',102,784);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-44-01',895,785);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-00-35',184,786);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-87-88',307,787);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-80-17',739,788);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-70-80',492,789);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-51-48',725,790);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('35-25-28',636,791);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-04-57',243,792);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-44-23',47,793);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('20-06-50',289,794);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-09-14',903,795);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-26-57',54,796);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-08-87',883,797);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('29-91-01',712,798);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('47-33-73',797,799);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-89-90',571,800);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('85-72-10',353,801);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-23-86',576,802);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-51-63',732,803);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-99-31',530,804);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-14-21',226,805);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('50-37-93',413,806);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-91-01',428,807);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-33-88',518,808);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-31-55',346,809);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-02-75',57,810);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-91-12',575,811);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-19-46',347,812);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('82-73-95',262,813);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-76-09',621,814);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-51-03',264,815);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-36-13',23,816);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-78-71',267,817);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-27-38',223,818);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-12-96',142,819);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-32-43',851,820);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-16-84',473,821);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-90-68',199,822);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-87-06',450,823);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-83-01',537,824);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-17-83',934,825);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-03-30',996,826);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-12-55',782,827);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('68-29-46',799,828);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-02-03',219,829);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('72-92-40',772,830);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-36-58',181,831);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('73-33-07',772,832);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-12-61',396,833);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-90-88',299,834);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-20-21',321,835);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-26-17',226,836);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-65-51',983,837);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('58-00-48',431,838);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-23-54',43,839);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-77-03',256,840);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-13-45',943,841);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('11-36-20',883,842);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('00-34-02',997,843);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-55-50',222,844);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-47-63',616,845);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-16-70',984,846);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-63-38',373,847);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('12-09-69',608,848);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-57-73',816,849);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-40-58',941,850);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-34-89',788,851);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('89-78-46',85,852);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-21-43',611,853);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-79-54',666,854);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-21-57',235,855);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-52-99',549,856);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-14-72',140,857);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-65-84',679,858);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-77-68',300,859);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-98-59',624,860);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-25-36',492,861);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-74-00',153,862);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-69-47',772,863);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('16-87-62',388,864);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-04-43',83,865);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-60-70',612,866);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-25-12',423,867);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('93-69-03',617,868);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-02-29',263,869);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-71-05',226,870);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-80-61',708,871);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('14-19-69',371,872);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-36-08',850,873);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-45-18',81,874);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-42-77',335,875);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('96-85-94',576,876);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-88-10',979,877);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-80-36',518,878);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-58-32',614,879);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-95-92',513,880);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('31-09-90',943,881);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-64-37',698,882);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-70-01',78,883);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-71-24',943,884);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-53-06',134,885);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('80-93-52',707,886);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('47-25-20',128,887);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-25-42',768,888);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-84-89',203,889);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-27-43',655,890);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-28-05',690,891);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('62-71-53',476,892);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-72-33',279,893);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('34-63-38',379,894);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-74-85',928,895);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-90-46',48,896);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-90-71',606,897);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-19-22',118,898);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-98-26',608,899);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-58-31',876,900);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('03-70-35',417,901);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('94-28-82',306,902);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('26-29-27',854,903);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('07-36-22',678,904);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-77-47',627,905);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-15-63',946,906);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-71-49',165,907);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('22-78-86',92,908);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('11-35-28',845,909);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('75-42-41',919,910);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-66-12',314,911);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('69-65-34',358,912);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-95-54',835,913);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('21-20-72',763,914);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-22-13',631,915);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-56-23',637,916);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-83-25',71,917);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('84-29-64',282,918);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-62-72',904,919);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('76-12-07',91,920);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-07-13',987,921);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('36-92-39',727,922);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('17-43-66',180,923);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('32-20-57',68,924);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-25-81',769,925);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('74-57-23',768,926);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('33-77-73',171,927);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('27-37-44',636,928);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-41-00',24,929);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('13-61-98',687,930);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('04-63-53',400,931);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('24-83-57',61,932);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('51-52-42',461,933);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-62-20',440,934);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('70-88-50',969,935);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-26-61',701,936);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('71-99-23',836,937);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-87-74',39,938);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('91-29-05',336,939);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('63-79-32',425,940);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('65-04-03',935,941);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('57-89-98',773,942);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('52-13-38',4,943);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-64-28',631,944);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('30-75-26',718,945);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('20-38-28',43,946);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-06-94',711,947);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('19-20-77',268,948);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('90-64-56',966,949);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('86-22-16',168,950);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('43-90-55',309,951);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('79-59-08',144,952);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('08-09-73',306,953);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('56-87-93',18,954);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('09-44-94',650,955);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('92-15-32',782,956);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('95-91-87',690,957);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('49-04-07',989,958);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('41-28-87',819,959);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('20-62-98',753,960);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-05-89',162,961);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-65-66',903,962);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-18-76',345,963);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-06-23',312,964);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('01-59-34',805,965);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('98-28-81',940,966);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('45-75-37',616,967);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('05-49-48',699,968);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('54-58-93',639,969);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('23-11-28',419,970);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('78-66-35',5,971);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('99-39-29',829,972);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-31-60',187,973);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('44-25-38',387,974);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('37-26-68',571,975);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('38-54-15',790,976);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('40-46-38',983,977);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('25-44-35',285,978);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('88-46-84',886,979);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('18-71-52',214,980);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('10-36-44',606,981);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('22-04-94',890,982);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('85-25-68',464,983);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('72-28-04',3,984);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('67-98-86',814,985);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-58-28',150,986);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('06-27-02',265,987);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('83-60-15',966,988);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('97-49-53',822,989);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('81-65-40',473,990);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('55-12-93',735,991);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('30-28-86',110,992);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('53-32-82',413,993);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('66-44-48',683,994);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('85-66-73',613,995);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('28-60-67',334,996);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('60-15-14',585,997);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('87-37-22',229,998);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('48-29-63',732,999);
INSERT INTO ComboLock(combination,locker_num,lock_id) VALUES ('39-73-85',328,1000);



INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Andris','Léane','Plumbe',false,'1997-11-18','Account Executive',39,29,5,true,1);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Teddy','Åsa','Lorraway',true,'1989-08-08','Marketing Assistant',33,127,10,false,2);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Davon','Lài','Cheshire',false,'1984-09-19','Account Executive',27,77,7,false,3);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Clevie','Laurélie','Portt',true,'1987-08-06','Senior Developer',34,86,8,false,4);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Trevor','Intéressant','Trobridge',false,'1980-10-31','Payment Adjustment Coordinator',15,54,4,false,5);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Isobel','Sòng','Armfirld',true,'1991-12-11','Payment Adjustment Coordinator',38,99,3,false,6);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Barret','Céline','Cathrall',true,'1983-10-29','Senior Cost Accountant',15,45,6,true,7);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Janean','Stévina','Lancastle',false,'1986-05-11','Software Test Engineer I',18,65,3,true,8);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Freeman','Aí','Bolderoe',false,'1993-12-08','Assistant Professor',33,76,4,false,9);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Daisy','Mén','Kunze',false,'2000-10-31','Marketing Assistant',28,1,2,true,10);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Adamo','Vérane','Corsan',false,'2002-09-11','Nurse Practicioner',24,19,5,true,11);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Esme','Anaé','Dodgshon',false,'1993-09-22','Accounting Assistant IV',37,101,7,false,12);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Denise','Camélia','Reveley',false,'1993-09-04','Account Executive',41,51,10,false,13);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Carina','Réjane','Kigelman',false,'1984-03-23','Dental Hygienist',18,115,8,false,14);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lawton','Laurélie','Shafier',false,'1989-04-15','Graphic Designer',34,69,4,false,15);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Jessa','Angélique','Haire',false,'1996-12-11','GIS Technical Architect',24,84,1,false,16);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Dur','Véronique','Errowe',false,'2001-01-28','Mechanical Systems Engineer',43,45,6,true,17);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Adriaens','Judicaël','Haet',true,'1997-06-21','Paralegal',33,106,3,true,18);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Sawyer','Sélène','Jurasz',true,'1989-01-02','Account Coordinator',16,135,5,false,19);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Blinnie','Lài','Acreman',false,'1985-03-24','Human Resources Manager',35,81,2,true,20);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Deb','Sòng','Svanetti',true,'2002-01-09','Health Coach I',36,52,10,true,21);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Janina','Pål','Roylance',false,'1997-06-08','Associate Professor',39,55,7,false,22);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Therine','Léa','Pegg',false,'1990-06-30','Office Assistant II',17,47,9,true,23);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Gerardo','Geneviève','Fine',false,'1984-10-02','Budget/Accounting Analyst II',15,89,2,false,24);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Tomas','Pål','Downs',true,'1986-11-15','Computer Systems Analyst IV',19,136,3,false,25);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Rayner','Maëly','Huard',true,'1994-12-26','Associate Professor',27,69,8,true,26);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Paige','Mélina','Mepham',false,'1989-03-11','Staff Scientist',26,125,10,false,27);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Denney','Lèi','Doble',true,'1984-05-29','Statistician II',26,53,5,true,28);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Julee','Maëly','Daykin',false,'1994-12-13','Analog Circuit Design manager',26,22,9,true,29);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Kylen','Eléonore','Ryce',false,'2002-10-30','Account Executive',22,145,8,false,30);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Gabie','Maïlys','Enoch',false,'1994-01-29','Tax Accountant',22,90,2,true,31);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Madelin','Dù','Claibourn',true,'1995-04-06','Sales Associate',15,149,1,true,32);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Sayre','Kuí','O''Halloran',true,'1994-05-21','Marketing Assistant',17,128,4,true,33);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Verge','Camélia','Durnall',true,'2002-06-27','VP Marketing',45,143,7,false,34);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Eda','Amélie','Fullegar',false,'1996-10-07','Structural Engineer',35,142,10,false,35);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Oralle','Léandre','Mordue',false,'1989-04-24','Sales Representative',35,41,6,false,36);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lorelei','Clémence','Loche',false,'1999-07-02','Cost Accountant',15,80,1,true,37);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Eran','Maéna','Selway',false,'1986-07-20','Structural Engineer',16,99,7,false,38);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Ardella','Méline','Ubsdale',false,'2000-03-29','Environmental Tech',33,59,3,true,39);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Stanton','Cunégonde','Riddich',true,'2001-07-21','Programmer Analyst III',21,110,9,true,40);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Binny','Marlène','Lecount',false,'2000-03-02','Physical Therapy Assistant',44,26,5,false,41);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Cly','Dorothée','Puttnam',false,'2000-07-23','Desktop Support Technician',28,40,4,false,42);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Shirlene','Mélinda','Hellin',false,'1999-01-06','Pharmacist',33,120,4,true,43);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Adriena','Ophélie','Aluard',true,'2002-05-13','Dental Hygienist',19,149,1,true,44);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Demetris','Yáo','Brandom',true,'1988-08-29','Statistician III',42,145,10,true,45);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Alika','Cunégonde','Barens',false,'1992-08-12','Recruiter',15,62,9,false,46);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Cirillo','Célia','Alliston',true,'1981-10-25','Software Consultant',41,57,5,true,47);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Laurianne','Yú','Drewet',false,'1987-10-04','Recruiting Manager',15,41,7,false,48);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Fiorenze','Hélèna','Mc Faul',false,'1991-07-08','Senior Sales Associate',26,17,6,false,49);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Cheslie','Ruò','MacGarrity',false,'1993-03-27','Biostatistician II',23,139,10,true,50);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lotte','Yáo','Lowther',false,'1984-08-23','Paralegal',42,90,9,false,51);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Denys','Dà','Elfe',false,'2000-01-22','Chemical Engineer',39,119,8,false,52);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lee','Andréanne','Stanyan',true,'1986-03-16','Account Executive',25,106,5,true,53);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Elizabet','Personnalisée','Bottle',true,'1980-09-04','Accounting Assistant IV',20,145,4,true,54);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Donella','Åke','Loude',false,'1993-03-18','Assistant Professor',29,119,6,false,55);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Adham','Ráo','Poluzzi',true,'1998-03-18','Librarian',24,110,3,false,56);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Margaret','Béatrice','McKellar',true,'1985-04-25','Financial Advisor',22,136,6,true,57);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Gerty','Mahélie','Josefovic',true,'1992-01-29','Senior Quality Engineer',34,142,7,false,58);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Dara','Anaëlle','Klamman',true,'1999-05-03','Electrical Engineer',19,44,9,true,59);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Naoma','Maéna','Brockton',false,'1989-05-23','Engineer I',35,14,1,true,60);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Curcio','Réjane','Ringsell',false,'1988-04-08','Help Desk Technician',40,117,4,true,61);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Leopold','Gaétane','Bugs',true,'1995-05-24','Human Resources Manager',22,138,5,true,62);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Merissa','Méng','Geockle',false,'1995-10-19','General Manager',26,137,2,false,63);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Cyndie','Fèi','Alfuso',false,'1995-04-19','Safety Technician IV',19,45,5,true,64);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Wadsworth','Géraldine','Hansley',false,'1992-03-16','Teacher',36,3,9,true,65);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Jehu','Cloé','Hemphill',true,'1999-11-24','Teacher',22,59,6,false,66);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Danya','Marie-ève','Grosier',false,'1986-10-01','Accounting Assistant I',41,17,2,false,67);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Analise','Geneviève','Poor',true,'1987-11-28','Marketing Assistant',30,128,10,false,68);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Maurice','Maéna','Julian',false,'1996-04-07','Account Representative I',43,44,4,false,69);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Granville','Måns','Sarginson',true,'1988-04-26','Accounting Assistant II',35,77,7,false,70);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Amy','Médiamass','McEachern',true,'1984-03-03','Mechanical Systems Engineer',36,133,6,true,71);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Joceline','Torbjörn','Keast',true,'1981-11-09','Database Administrator II',37,77,4,false,72);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Wilburt','Méghane','Abbatini',false,'1985-09-14','Structural Analysis Engineer',15,112,9,false,73);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Kean','Göran','MacKeever',false,'1987-10-02','VP Product Management',26,93,2,true,74);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Fleur','Vérane','Buchan',false,'2001-03-06','Programmer Analyst III',24,90,5,false,75);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Alfi','Laurène','Laingmaid',false,'1994-04-29','Assistant Media Planner',38,105,3,true,76);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lin','Valérie','Kubek',false,'1986-07-15','Assistant Manager',45,79,10,true,77);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Vaclav','Renée','Bover',true,'1990-11-08','Geologist III',38,100,7,true,78);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Mariele','Inès','Jellico',false,'1983-03-01','Senior Developer',26,6,5,true,79);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Klara','Bénédicte','Lamanby',false,'1983-04-11','Tax Accountant',24,40,9,false,80);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Paulie','Gaëlle','Brazer',false,'1986-01-13','Structural Engineer',21,141,8,false,81);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Noland','Thérèsa','Arnaldy',false,'1986-12-06','Web Developer III',15,109,3,true,82);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Hedda','Dafnée','Woolfenden',true,'1989-12-17','VP Accounting',43,24,10,false,83);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Tailor','Dafnée','Nisco',false,'1988-07-08','Junior Executive',30,81,4,false,84);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Leupold','Chloé','Scobie',true,'1984-11-14','Occupational Therapist',41,96,8,false,85);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Dorrie','Mélinda','Maletratt',false,'2002-03-24','Administrative Assistant I',43,96,5,false,86);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lin','Örjan','Chalfont',false,'1992-06-14','Administrative Assistant III',35,81,1,true,87);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Dorthy','Maïlis','Erdis',false,'1984-08-30','Food Chemist',35,14,9,false,88);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Ebenezer','Sélène','McNelly',true,'1993-05-28','Registered Nurse',31,29,7,true,89);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Amby','Anaé','Meedendorpe',false,'1991-12-10','Senior Sales Associate',45,60,2,false,90);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Bradly','Danièle','Aspinal',false,'1986-01-29','Analyst Programmer',27,123,4,false,91);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Rip','Laurélie','Megarrell',true,'1982-05-11','Dental Hygienist',21,96,5,true,92);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lavinie','Léone','Slyford',true,'2003-03-14','Structural Engineer',22,78,2,true,93);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Glen','Maïlis','Castledine',false,'1981-06-12','Registered Nurse',14,144,3,true,94);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Rudyard','Amélie','Henner',true,'1994-11-17','Database Administrator II',31,89,10,true,95);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Eliza','Gaëlle','Le Surf',true,'1995-07-03','General Manager',29,17,9,true,96);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Barron','Illustrée','Raspin',false,'1982-01-11','Librarian',32,27,8,false,97);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Reinaldos','Cloé','Bonniface',true,'1986-06-04','Administrative Assistant III',18,122,6,true,98);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Hestia','Maïlys','Dibb',false,'1984-01-31','Marketing Manager',38,27,4,false,99);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Monroe','Loïca','Hubbucks',true,'1988-02-18','Associate Professor',42,16,5,false,100);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Ariana','Börje','Hehir',false,'1995-05-13','Food Chemist',37,12,6,true,101);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Nellie','Mélys','McCurlye',false,'1991-10-06','Data Coordinator',36,80,8,true,102);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Kirby','Lyséa','Janton',true,'1984-11-30','Programmer I',19,59,3,false,103);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Ray','Kallisté','Strong',true,'1993-04-07','Community Outreach Specialist',34,60,10,true,104);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Kaitlynn','Maëlle','Allett',true,'2002-11-13','Geological Engineer',34,139,9,false,105);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Wood','Laïla','Clewarth',true,'1992-04-14','Community Outreach Specialist',13,9,3,true,106);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Carr','Lucrèce','Aylmore',true,'1981-01-21','Social Worker',14,77,8,true,107);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Riva','Réservés','Lester',true,'1982-07-12','Pharmacist',33,142,9,false,108);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Giulietta','Personnalisée','Hostan',true,'1983-08-24','VP Sales',31,126,1,false,109);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Allys','Yáo','Diggons',true,'1999-12-21','Structural Analysis Engineer',20,17,6,true,110);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Gunar','Maëlla','Blackhurst',true,'1988-02-20','Occupational Therapist',17,120,7,false,111);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Emanuele','Torbjörn','Wyldbore',true,'1999-10-10','Senior Cost Accountant',25,64,4,false,112);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Issiah','Pò','Devons',false,'1984-06-08','Recruiting Manager',35,88,9,false,113);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Bernette','Gisèle','Trigg',true,'1992-03-02','Safety Technician III',35,77,7,false,114);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Kyle','Gisèle','Mashal',true,'2001-05-24','Engineer II',26,99,10,false,115);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Marley','Dafnée','Spragge',false,'1993-05-10','Chief Design Engineer',22,65,3,false,116);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Gabriello','Kuí','Blumer',false,'1989-01-08','Speech Pathologist',15,28,6,true,117);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Jami','Faîtes','Carmel',true,'1992-11-02','Help Desk Technician',34,88,2,true,118);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Nannie','Ruò','Rowthorne',true,'1993-07-26','Financial Analyst',35,52,4,true,119);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Heath','Laïla','Kringe',false,'2002-07-03','Teacher',13,63,9,true,120);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Alyss','Annotée','Suart',true,'1993-02-03','Legal Assistant',17,100,7,true,121);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Merv','Eléa','Feare',false,'1988-02-11','Account Representative III',39,43,6,false,122);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Celestina','Loïs','Sidaway',false,'1999-11-01','Recruiter',29,132,2,false,123);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Oby','Intéressant','Kleszinski',true,'1983-12-19','Marketing Assistant',16,60,1,false,124);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Emmet','Méghane','Joselson',true,'1985-03-09','Account Representative II',13,94,4,false,125);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Delmer','Nélie','Stear',false,'1997-01-09','Account Representative IV',18,63,8,false,126);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Wolf','Håkan','Coppin',false,'1994-09-06','Structural Engineer',32,65,1,false,127);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Reta','Almérinda','Rimell',false,'1990-01-23','Recruiter',38,102,9,true,128);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Duncan','Östen','Brinkler',true,'1984-11-05','Software Engineer I',28,98,2,false,129);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Maurizia','Agnès','Browne',false,'1993-06-09','Cost Accountant',35,45,5,false,130);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Fonzie','Maëlys','Yeats',true,'1985-08-05','Recruiting Manager',37,13,3,true,131);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Dell','Maïly','Tommasi',true,'1989-01-03','Assistant Media Planner',43,87,6,false,132);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Riccardo','Eugénie','Marjot',true,'1985-08-17','Payment Adjustment Coordinator',34,93,4,false,133);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Kerwin','Anaïs','Dinjes',true,'1981-10-19','Paralegal',30,80,5,true,134);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Nikki','Eliès','Cornill',false,'1985-05-13','Research Nurse',24,123,4,false,135);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Early','Faîtes','Oldacres',true,'1982-10-30','Cost Accountant',21,12,7,true,136);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Brenna','Faîtes','Endecott',true,'1981-08-29','Web Developer I',13,115,2,false,137);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Lucretia','Léa','Leber',true,'1986-01-25','Statistician IV',43,10,10,true,138);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Benjy','Michèle','Elbourn',false,'1985-06-18','Design Engineer',29,48,6,false,139);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Sigfried','Marie-noël','Earingey',true,'2003-02-12','Quality Engineer',33,32,1,false,140);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Dorothy','Athéna','Kless',true,'1988-10-28','Account Coordinator',24,17,9,true,141);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Cathryn','Táng','Whooley',true,'1988-02-08','Account Executive',34,113,8,false,142);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Barbra','Personnalisée','Talman',true,'1980-11-26','Accountant IV',30,46,3,false,143);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Vere','Maïté','Statham',false,'1996-03-16','Paralegal',26,43,8,true,144);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Rhys','Mylène','Danilowicz',true,'1983-06-28','Biostatistician I',32,60,9,true,145);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Faye','Edmée','Pergens',true,'1996-09-04','Account Coordinator',20,81,5,true,146);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Gussi','Styrbjörn','Edridge',true,'1992-03-29','VP Accounting',22,111,1,true,147);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Coralyn','Aimée','Bratch',false,'1992-04-12','Information Systems Manager',37,3,6,true,148);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Rock','Audréanne','Offner',true,'1992-08-09','Electrical Engineer',45,122,4,true,149);
INSERT INTO Employee(first_name,middle_name,last_name,is_male,DoB,job_title,hourly_wage_in_dollars,reports_to,section_assigned_to,currently_on_shift,employee_id) VALUES ('Janella','Lén','Sturges',false,'2000-02-03','Legal Assistant',19,127,3,false,150);

