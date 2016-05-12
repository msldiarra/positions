

-- Create owners
INSERT INTO Owner (Name) VALUES
  ('Mamadou Lamine DIARRA'),
  ('Ange PETE'),
  ('Issa SIDIBE');

-- Create contact type
INSERT INTO ContactType (Type) VALUES
  ('Manager'),
  ('Assistant'),
  ('Driver');

-- Contact info
INSERT INTO ContactInfo (PhoneNumber) VALUES
  ('+33660278604'),
  ('+33658055325'),
  ('+33658055325');

-- Create contacts drivers and owners
INSERT INTO Contact (FirstName, LastName, ContactInfoId, ContactTypeId) VALUES
  ('Mamadou', 'Diarra', 1, 3),
  ('Ange', 'Pete', 2, 1),
  ('Issa', 'Sidibe', 3, 1);


  -- Create Cars
INSERT INTO Car (Name, Reference, OwnerId) VALUES
  ('Taxi 1', 'A000000', 2), --Ange
  ('Taxi 2', 'A000001', 2), --Ange
  ('Taxi 3', 'A000002', 3), --Issa
  ('Taxi 4', 'A000003', 3); --Issa


-- Car driver contact
INSERT INTO CarDriverContact (CarId, ContactId) VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 1);


-- Create zone
INSERT INTO Zone (Name) VALUES
  ('Paris'),
  ('Lyon');

INSERT INTO Location (Latitude, Longitude) VALUES
  -- Ile de France, France
  (49.241504, 3.5590069),
  (48.1200811, 1.44617),
  -- Lyon, France
  (45.808425, 4.898393),
  (45.707486, 4.7718489);

INSERT INTO Bounds (ZoneId, NorthEastId, SouthwestId) VALUES
  (1 , 1, 2), -- Zone Paris, NorthEast 1, SouthWest 2
  (2 , 3, 4); -- Zone Lyon, NorthEast 3, SouthWest 4

