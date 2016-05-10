--
-- Table creation
--
CREATE TABLE IF NOT EXISTS Owner (
  Id SERIAL PRIMARY KEY,
  Name VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Car (
  Id SERIAL PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Reference VARCHAR(15) NOT NULL,
  OwnerId INTEGER NOT NULL,
  Description VARCHAR(255) NOT NULL DEFAULT 'NO_DESCRIPTION',
  Available BOOLEAN NOT NULL DEFAULT TRUE,
  Enabled BOOLEAN NOT NULL DEFAULT TRUE,
  ActivityStartDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS CarActivityEndDate (
  Id SERIAL PRIMARY KEY,
  CarId INTEGER NOT NULL,
  EndDate TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS CarDriverContact (
  Id SERIAL PRIMARY KEY,
  CarId INTEGER NOT NULL,
  ContactId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS OwnerContact (
  OwnerId INTEGER NOT NULL,
  ContactId INTEGER NOT NULL
);


CREATE TABLE IF NOT EXISTS Contact (
  Id SERIAL PRIMARY KEY,
  FirstName VARCHAR(100) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  ContactInfoId INTEGER NOT NULL,
  ContactTypeId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS ContactType (
  Id SERIAL PRIMARY KEY,
  Type VARCHAR(100) NOT NULL -- manager, assistant, driver
);

CREATE TABLE IF NOT EXISTS ContactInfo (
  Id SERIAL PRIMARY KEY,
  PhoneNumber VARCHAR(15) NOT NULL
);


CREATE TABLE IF NOT EXISTS Location (
  Id SERIAL PRIMARY KEY,
  Latitude DECIMAL NOT NULL,
  Longitude DECIMAL NOT NULL
);

CREATE TABLE IF NOT EXISTS CarLocation (
  Id SERIAL PRIMARY KEY,
  CarId INTEGER NOT NULL,
  LocationId INTEGER NOT NULL,
  Time TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS Zone (
  Id SERIAL PRIMARY KEY,
  Name VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Bounds ( -- could be named ZoneLocation
  Id SERIAL PRIMARY KEY,
  ZoneId INTEGER NOT NULL,
  NorthEastId INTEGER NOT NULL,
  SouthwestId INTEGER NOT NULL
);


CREATE VIEW CarPosition AS
  SELECT Car.Id As Id, Car.Reference AS Reference, Contact.FirstName as DriverName, ContactInfo.PhoneNumber as PhoneNumber,
    Car.Available as Available, LatestCarLocation.LocationId as LocationId,
    LatestCarLocation.Time as Time
  FROM Car
    INNER JOIN CarDriverContact on Car.Id = CarDriverContact.CarId
    INNER JOIN Contact on Contact.Id = CarDriverContact.ContactId
    INNER JOIN ContactInfo on Contact.ContactInfoId = ContactInfo.Id
    --INNER JOIN CarLocation on Car.Id = CarLocation.CarId
    LEFT JOIN (
      SELECT DISTINCT ON(CarId) Id, CarId, LocationId, Time
      FROM CarLocation
      ORDER BY CarId, Time DESC
    ) LatestCarLocation ON Car.Id = LatestCarLocation.CarId;



CREATE RULE Position_UPDATE AS ON UPDATE TO CarPosition DO INSTEAD (
  UPDATE Car SET Available = NEW.Available WHERE Id = OLD.Id; INSERT INTO CarLocation (CarId, LocationId, Time) VALUES (OLD.Id, NEW.LocationId, NEW.Time)
);

--UPDATE Car SET Available = true;
--INSERT INTO Location (Latitude, Longitude) VALUES (NEW.Latitude, NEW.Longitude)
--INSERT INTO CarLocation (CarId, LocationId, Time) VALUES (OLD.CarId, currval('location_id_seq'), NEW.Time)

--
-- Constraints
--

ALTER TABLE Car
  ADD CONSTRAINT FK_Car_Owner FOREIGN KEY (OwnerId) REFERENCES Owner (Id);

ALTER TABLE CarActivityEndDate
  ADD CONSTRAINT FK_CarActivityEndDate_Car FOREIGN KEY (CarId) REFERENCES Car (Id);

ALTER TABLE CarDriverContact
  ADD CONSTRAINT FK_CarDriverContact_Car FOREIGN KEY (CarId) REFERENCES Car (Id),
  ADD CONSTRAINT FK_OwnerContact_Contact FOREIGN KEY (ContactId) REFERENCES Contact (Id);

ALTER TABLE Contact
  ADD CONSTRAINT FK_Contact_ContactInfo FOREIGN KEY (ContactInfoId) REFERENCES ContactInfo (Id);

ALTER TABLE OwnerContact
  ADD CONSTRAINT FK_OwnerContact_Contact FOREIGN KEY (ContactId) REFERENCES Contact (Id),
  ADD CONSTRAINT FK_OwnerContact_Owner FOREIGN KEY (OwnerId) REFERENCES Owner (Id);


ALTER TABLE CarLocation
  ADD CONSTRAINT FK_CarLocation_Car FOREIGN KEY (CarId) REFERENCES Car (Id),
  ADD CONSTRAINT FK_CarLocation_Location FOREIGN KEY (LocationId) REFERENCES Location (Id);

ALTER TABLE Bounds
  ADD CONSTRAINT FK_Bounds_NorthEastId FOREIGN KEY (NorthEastId) REFERENCES Location (Id),
  ADD CONSTRAINT FK_Bounds_SouthwestId FOREIGN KEY (SouthwestId) REFERENCES Location (Id);