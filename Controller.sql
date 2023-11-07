/*EEI4366/ EEX4366 Data Modeling and Database Systems Mini Project */;

/*Name : W.M.D.H.Gunarathna */;


/*Call Database*/
USE suwapiyasa_db;
SET SQL_SAFE_UPDATES = 0;


DROP VIEW IF EXISTS `PatientSurgeryView`;
CREATE VIEW `PatientSurgeryView` AS
SELECT DISTINCT
    p.p_ID AS PatientID,
    CONCAT(p.Initials, ' ', p.LastName) AS PatientName,
    CONCAT(l.bedNumber, '-', l.roomNumber) AS Location,
    s.surgeryName AS SurgeryName,
    s.date AS SurgeryDate
FROM
    patient p
JOIN
    surgery s ON p.p_ID = s.patientNumber
JOIN
    location l ON p.location_ID = l.l_ID;
    
/* Show Query Result set 'PatientSurgeryView'*/    
SELECT * FROM `PatientSurgeryView`;




/*Create a table called ‘MedInfo’ */
DROP TABLE IF EXISTS `MedInfo`;
CREATE TABLE `MedInfo` (
    MedName varchar(50) NOT NULL PRIMARY KEY,
    QuantityAvailable int,
    ExpirationDate date
);


/*To load data to ‘MedInfo’ using ‘Medication’ / ‘Medicine’ table (use the table name you
have given) after a new record is entered into that table */

DROP TRIGGER IF EXISTS `InsertMedicationTrigger`;
DELIMITER //
CREATE TRIGGER `InsertMedicationTrigger`
AFTER INSERT ON Medication 
FOR EACH ROW
BEGIN
    INSERT INTO MedInfo (MedName, QuantityAvailable, ExpirationDate)
    VALUES (NEW.name, NEW.QOH, NEW.expirationDate);
END;
//
DELIMITER ;


/*Inserting Data for the table `medication` */
INSERT INTO `medication` (`m_ID`, `name`, `QOH`, `QO`, `cost`, `expirationDate`) VALUES
  ('MED006', 'Adderall', 150, 40, 15.99, '2025-12-31'),
  ('MED007', 'Azithromycin', 250, 16, 17.49, '2026-06-30'),
  ('MED008', 'Ativan', 175, 26, 14.99, '2025-11-15'),
  ('MED009', 'calcitriol', 140, 11, 22.99, '2024-10-20'),
  ('MED010', 'Amlodipine', 130, 9, 16.75, '2025-08-25');
    
SELECT * FROM `MedInfo`; /*SHOW TRIGGER RESULT SET` */



/*To automatically update the values in ‘MedInfo’ table when the inserted values in
‘Medication’ / ‘Medicine’ table get updated. */

DROP TRIGGER IF EXISTS `UpdateMedicationTrigger`;
DELIMITER //
CREATE TRIGGER `UpdateMedicationTrigger`
AFTER UPDATE ON Medication 
FOR EACH ROW
BEGIN
    UPDATE MedInfo
    SET QuantityAvailable = NEW.QOH, ExpirationDate = NEW.expirationDate
    WHERE MedName = NEW.name;
END;
//
DELIMITER ;

/*Updating Data for the table `medication` */
UPDATE medication SET `QOH` = 60  WHERE name = 'Adderall' ;

SELECT * FROM `MedInfo`; /*SHOW UPDATED TRIGGER RESULT SET` */


/*To delete the values in ‘MedInfo’ table when the inserted values in ‘Medication’ /
‘Medicine’ table get deleted */

DROP TRIGGER IF EXISTS `DeleteMedicationTrigger`;
DELIMITER //
CREATE TRIGGER `DeleteMedicationTrigger`
AFTER DELETE ON Medication 
FOR EACH ROW
BEGIN
    DELETE FROM MedInfo WHERE MedName = OLD.name;
END;
//
DELIMITER ;

/*Deleting Data for the table `medication` */
DELETE FROM medication WHERE name = 'Azithromycin';

SELECT * FROM `MedInfo`; /*SHOW UPDATED TRIGGER RESULT SET` */



/*create a stored procedure*/
DROP PROCEDURE IF EXISTS `GetMedicationCount`;
DELIMITER //
CREATE PROCEDURE `GetMedicationCount`(
    IN patientID VARCHAR(10),
    INOUT medicationCount INT
)
BEGIN
    SELECT COUNT(*) INTO medicationCount
    FROM MediPatient
    WHERE p_ID = patientID;
END //
DELIMITER ;

/*Output stored procedure*/

-- Create session variable
SET @output := 0;

-- Call the SP
CALL GetMedicationCount('P001', @output);

-- Get result set
SELECT @output AS MedicationCount;


/*Create a function to calculate the number of days remaining for the expiration of a medication*/
DROP FUNCTION IF EXISTS `DaysRemainingForExpiry`;
DELIMITER //
CREATE FUNCTION `DaysRemainingForExpiry`(expirationDate DATE)
RETURNS INT
READS SQL DATA /*function only reads data and doesn't modify it*/
BEGIN
    DECLARE remainingDays INT;
    SET remainingDays = DATEDIFF(expirationDate, CURDATE());
    RETURN remainingDays;
END //
DELIMITER ;

/*Inserting Data for the table `medication` */
INSERT INTO `medication` (`m_ID`, `name`, `QOH`, `QO`, `cost`, `expirationDate`) VALUES
  ('MED011', 'Ciprofloxacin', 150, 11, 22.99, '2023-08-20'),
  ('MED012', 'Cyclobenzaprine', 140, 9, 16.75, '2023-09-05');
  
/*Retrieve Medications with Less Than a Month for Expiry*/
SELECT
    m.m_ID AS MedicationID,
    m.name AS MedicationName,
    m.QOH AS QuantityOnHand,
    m.cost AS Cost,
    m.expirationDate AS ExpirationDate,
    DaysRemainingForExpiry(m.expirationDate) AS DaysRemaining
FROM
    medication m
WHERE
    DaysRemainingForExpiry(m.expirationDate) <= 30;



/*Store some data regarding the Staff and Patient in two xml files and load those data to the created tables using a SQL query.*/

set global local_infile=1;

LOAD XML LOCAL INFILE 'D:\EEI4366 Mini Project\staff.xml'
INTO TABLE employees
ROWS IDENTIFIED BY '<staff>';

SELECT * FROM `employees`;



