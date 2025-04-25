-- Create SEQUENCES (at least two, used in insertions)
CREATE SEQUENCE graduate_seq;
CREATE SEQUENCE registration_seq;

-- 1. Create AWARD table
CREATE TABLE Award (
    AwardID NUMBER PRIMARY KEY,
    AwardName VARCHAR2(100) NOT NULL,
    Description VARCHAR2(200)
);

-- 2. Create GRADUATE table
CREATE TABLE Graduate (
    GraduateID NUMBER PRIMARY KEY,
    Grad_Last_Name VARCHAR2(50) NOT NULL,
    Grad_First_Name VARCHAR2(50) NOT NULL,
    GradAccommodations VARCHAR2(200),
    Grad_Status VARCHAR2(20) NOT NULL,
    Photo VARCHAR2(255),
    DegreeProgram VARCHAR2(50) NOT NULL,
    Grad_Email VARCHAR2(100) UNIQUE NOT NULL
);

-- 3. Create CEREMONY table
CREATE TABLE Ceremony (
    CeremonyID NUMBER PRIMARY KEY,
    GuestSpeaker VARCHAR2(100),
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    CeremonyLocation VARCHAR2(100) NOT NULL,
    CeremonyDate DATE NOT NULL,
    VenueID NUMBER NOT NULL
);

-- 4. Create VENUE table
CREATE TABLE Venue (
    VenueID NUMBER PRIMARY KEY,
    VenueName VARCHAR2(100) NOT NULL,
    VenueCap NUMBER NOT NULL,
    VenueAddress VARCHAR2(150) UNIQUE NOT NULL
);

-- 5. Create REGISTRATION table
CREATE TABLE Registration (
    RegistrationID NUMBER PRIMARY KEY,
    RequestedTickets NUMBER NOT NULL,
    RegDate DATE DEFAULT SYSDATE,
    RegStatus VARCHAR2(20) NOT NULL,
    GraduateID NUMBER NOT NULL,
    CeremonyID NUMBER NOT NULL,
    FOREIGN KEY (GraduateID) REFERENCES Graduate(GraduateID),
    FOREIGN KEY (CeremonyID) REFERENCES Ceremony(CeremonyID)
);

-- 6. Create TICKET table
CREATE TABLE Ticket (
    TicketID NUMBER PRIMARY KEY,
    TicketStatus VARCHAR2(20) NOT NULL
);

-- 7. Create GUEST table
CREATE TABLE Guest (
    GuestID NUMBER PRIMARY KEY,
    GuestAccommodations VARCHAR2(200),
    GuestName VARCHAR2(100) NOT NULL,
    TicketID NUMBER NOT NULL,
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);

-- 8. Create RECEIVES relationship table
CREATE TABLE Receives (
    AwardID NUMBER NOT NULL,
    GraduateID NUMBER NOT NULL,
    PRIMARY KEY (AwardID, GraduateID),
    FOREIGN KEY (AwardID) REFERENCES Award(AwardID),
    FOREIGN KEY (GraduateID) REFERENCES Graduate(GraduateID)
);

-- 9. Create REQUESTS relationship table
CREATE TABLE Requests (
    TicketID NUMBER NOT NULL,
    RegistrationID NUMBER NOT NULL,
    PRIMARY KEY (TicketID, RegistrationID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (RegistrationID) REFERENCES Registration(RegistrationID)
);

-- Create sequences used for generating primary keys
CREATE SEQUENCE graduate_seq;-- Create the sequence to auto-generate GraduateID values
CREATE SEQUENCE registration_seq;

-- ========== INSERT DATA ==========
-- Insert into Graduate using graduate_seq
INSERT INTO Graduate VALUES (
    graduate_seq.NEXTVAL, 'Doe', 'John', NULL, 'approved', NULL, 'Computer Science', 'jdoe@temple.edu'
);
INSERT INTO Graduate VALUES (
    graduate_seq.NEXTVAL, 'Smith', 'Jane', 'Wheelchair access', 'pending', NULL, 'Psychology', 'jsmith@temple.edu'
);



-- Insert into Award
INSERT INTO Award VALUES (1, 'Summa Cum Laude', 'Top 5% of class');
INSERT INTO Award VALUES (2, 'Research Excellence', NULL);

-- Insert into Receives
INSERT INTO Receives VALUES (1, 1);
INSERT INTO Receives VALUES (2, 2);

-- Insert into Venue
INSERT INTO Venue VALUES (1, 'Liacouras Center', 5000, '1776 N Broad St');
INSERT INTO Venue VALUES (2, 'Howard Gittis Student Center', 1200, '1755 N 13th St');

-- Insert into Ceremony
INSERT INTO Ceremony VALUES (
    1, 'Dr. Alice', TO_TIMESTAMP('2025-05-10 10:00', 'YYYY-MM-DD HH24:MI'),
    TO_TIMESTAMP('2025-05-10 12:00', 'YYYY-MM-DD HH24:MI'),
    'Main Hall', DATE '2025-05-10', 1
);
INSERT INTO Ceremony VALUES (
    2, 'Dean Brown', TO_TIMESTAMP('2025-05-11 14:00', 'YYYY-MM-DD HH24:MI'),
    TO_TIMESTAMP('2025-05-11 16:00', 'YYYY-MM-DD HH24:MI'),
    'Auditorium', DATE '2025-05-11', 2
);

-- Insert into Registration using registration_seq
INSERT INTO Registration VALUES (
    registration_seq.NEXTVAL, 3, SYSDATE, 'confirmed', 1, 1  
);
INSERT INTO Registration VALUES (
    registration_seq.NEXTVAL, 2, SYSDATE, 'pending', 2, 2
);

-- Insert into Ticket
INSERT INTO Ticket VALUES (101, 'assigned');
INSERT INTO Ticket VALUES (102, 'unassigned');

-- Insert into Requests
INSERT INTO Requests VALUES (101, 1);
INSERT INTO Requests VALUES (102, 2);

-- Insert into Guest
INSERT INTO Guest VALUES (1, NULL, 'Emily Doe', 101);
INSERT INTO Guest VALUES (2, 'Requires interpreter', 'Tom Smith', 102);

-- COMMIT CHANGES
COMMIT;

-- ========== CREATE INDEXES ==========
-- Create index on RegStatus (frequently queried by status)
CREATE INDEX idx_regstatus ON Registration(RegStatus);

-- Create index on CeremonyLocation (used in joins or filters)
CREATE INDEX idx_ceremony_location ON Ceremony(CeremonyLocation);

-- Create index on DegreeProgram (used in searches)
CREATE INDEX idx_degree_program ON Graduate(DegreeProgram);

-- ========== SAMPLE SUMMARY QUERIES ==========
-- 1. Show guest names and their assigned graduates
SELECT g.GuestName, gr.Grad_First_Name, gr.Grad_Last_Name
FROM Guest g
JOIN Ticket t ON g.TicketID = t.TicketID
JOIN Requests r ON t.TicketID = r.TicketID
JOIN Registration reg ON r.RegistrationID = reg.RegistrationID
JOIN Graduate gr ON reg.GraduateID = gr.GraduateID;

-- 2. Number of graduates per ceremony with ceremony info
SELECT c.CeremonyID, c.CeremonyDate, COUNT(DISTINCT r.GraduateID) AS Grad_Count
FROM Ceremony c
JOIN Registration r ON c.CeremonyID = r.CeremonyID
GROUP BY c.CeremonyID, c.CeremonyDate;
