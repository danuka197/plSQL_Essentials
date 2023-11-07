
/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


/*EEI4366/ EEX4366 Data Modeling and Database Systems TMA 2 */;
/*Reg : 421643720 */;
/*Name : W.M.D.H.Gunarathna */;



CREATE DATABASE /*!32312 IF NOT EXISTS*/`suwapiyasa_db` /*!40100 DEFAULT CHARACTER SET latin1 */;


/*Call Database*/
USE suwapiyasa_db;

/*Table structure for  `employees` table */
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `empNumber` varchar(10) NOT NULL,
  `empName` varchar(50) NOT NULL,
  `empGender` varchar(50) NOT NULL,
  `empAddress` varchar(10) NOT NULL,
  `tepNo1` int(10) NOT NULL,
  `tepNo2` int(10) ,
 
  PRIMARY KEY (`empNumber`),
  
  -- check that no number is not a digit
  CONSTRAINT chk_phone CHECK (`tepNo1` not like '%[^0-9]%')  
  
);


/*Table structure for  `surgeon` table */
DROP TABLE IF EXISTS `surgeon`;
CREATE TABLE `surgeon` (
  `s_ID` varchar(10) NOT NULL,
  `contractType` varchar(50) NOT NULL,
  `contractLength` varchar(50) NOT NULL,
  
 
  PRIMARY KEY (`s_ID`),
  
  -- Check constraint to ensure only specific contract types are allowed
  CONSTRAINT `chkContractType` CHECK (`contractType` IN ('Full-time', 'Part-time', 'Contractor')),
  
    -- Surgeon is an Employee
  CONSTRAINT `fk_EmpSurgeon` FOREIGN KEY (`s_ID`) REFERENCES `employees`(`empNumber`) ON DELETE CASCADE ON UPDATE CASCADE
 
);

/*Table structure for  `nurse` table */
DROP TABLE IF EXISTS `nurse`;
CREATE TABLE `nurse` (
  `n_ID` varchar(10) NOT NULL,
  `grade` varchar(50) NOT NULL,
  `experience` varchar(50) NOT NULL,
  `skill` varchar(10) NOT NULL,
  `surgeryName` varchar(10) NULL,
 
  PRIMARY KEY (`n_ID`),
  
  -- check that nurse number grade 
  CONSTRAINT `chkNurseGrade` CHECK (`grade` IN ('A', 'B', 'C', 'D')),
  
  -- nurse is an Employee
  CONSTRAINT `fk_EmpNurse` FOREIGN KEY (`n_ID`) REFERENCES `employees`(`empNumber`) ON DELETE CASCADE ON UPDATE CASCADE,
  
  -- nurse attend surgery
  CONSTRAINT `fk_surgeryNurse` FOREIGN KEY (`surgeryName`) REFERENCES `surgery`(`surgeryName`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Table structure for  `doctor` table */
DROP TABLE IF EXISTS `doctor`;
CREATE TABLE `doctor` (
  `d_ID` varchar(10) NOT NULL,
  `speciality` varchar(50) NOT NULL,
 
 
  PRIMARY KEY (`d_ID`),
  
  -- check that doctor number is start with "D or d"
  CONSTRAINT `chkSpeciality` CHECK (speciality IN ('Cardiology', 'Dermatology', 'Pediatrics', 'Oncology','Other')),
  
  -- Doctor is an Employee
  CONSTRAINT `fk_EmpDoctor` FOREIGN KEY (`d_ID`) REFERENCES `employees`(`empNumber`) ON DELETE CASCADE ON UPDATE CASCADE
  
);

/*Table structure for  `patient` table */
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `p_ID` varchar(10) NOT NULL,
  `Initials` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `age` int(3) NOT NULL,
  `address` varchar(50) NOT NULL,
  `bloodType` varchar(50) NOT NULL,
  `tepNo1` int(10) NOT NULL,
  `tepNo2` int(10) NOT NULL,
  `allergies1` varchar(50) NOT NULL,
  `allergies2` varchar(50) NOT NULL,
  `allergies3` varchar(50) NOT NULL,
  
  `d_ID` varchar(10) NOT NULL,
  
  `location_ID` varchar(10) NOT NULL,
 
  PRIMARY KEY (`p_ID`),
  
   -- Check constraint for blood type
  CONSTRAINT `chk_bloodType` CHECK (bloodType IN ('A', 'B', 'AB', 'O', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+')),
  
  -- Patient has a Doctor
  CONSTRAINT `fk_patientDoctor` FOREIGN KEY (`d_ID`) REFERENCES doctor(`d_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  
  -- Patient has a location
  CONSTRAINT `fk_patientLocation` FOREIGN KEY (`location_ID`) REFERENCES `location`(`l_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Table structure for  `surgery` table */
DROP TABLE IF EXISTS `surgery`;
CREATE TABLE `surgery` (
  `surgeryName` varchar(10) NOT NULL,
  `patientNumber` varchar(50) NOT NULL,
  `time` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `category` varchar(50) NOT NULL,
  `theatre` varchar(50) NOT NULL,
  `specialNeeds` varchar(50) NOT NULL,
  
 
  PRIMARY KEY (`surgeryName`,`patientNumber`),
  
  
   -- Patient has a Surgery
  CONSTRAINT `fk_patientSurgery` FOREIGN KEY (`patientNumber`) REFERENCES `patient`(`p_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Table structure for  `medication` table */
DROP TABLE IF EXISTS `medication`;
CREATE TABLE `medication` (
  `m_ID` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `QOH` int NOT NULL,
  `QO` int NOT NULL,
  `cost` float(50) NOT NULL,
  `expirationDate` varchar(50) NOT NULL,
 
  PRIMARY KEY (`m_ID`)
  
);

/*Table structure for  `location` table */
DROP TABLE IF EXISTS `location`;
CREATE TABLE `location` (

  `l_ID` varchar(10) NOT NULL,
  `bedNumber` int NOT NULL,
  `roomNumber` int NOT NULL,
  `nursingUnit` int NOT NULL,
  
  PRIMARY KEY (`l_ID`,`bedNumber`,`roomNumber`)
  
  
);

/*Table structure for  `Head Doctor` table */
DROP TABLE IF EXISTS `headDoctor`;
CREATE TABLE `headDoctor` (
  `d_ID` varchar(10) NOT NULL,
  `Head_ID` varchar(10) NOT NULL,
  
  PRIMARY KEY (`d_ID`,`Head_ID`),
  
   -- Head doctor is an Doctor
  CONSTRAINT `fk_headDoc` FOREIGN KEY (`d_ID`) REFERENCES `doctor`(`d_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Table structure for  `surgenSurgery` table */
DROP TABLE IF EXISTS `surgenSurgery`;
CREATE TABLE `surgenSurgery` (
  `surgeryName` varchar(10) NOT NULL,
  `s_ID` varchar(10) NOT NULL,
  `theatreInfo` varchar(50) NOT NULL,
  
  PRIMARY KEY (`surgeryName`,`s_ID`),
  
  CONSTRAINT `fk_surgenSurgery_surName` FOREIGN KEY (`surgeryName`) REFERENCES `surgery`(`surgeryName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_surgenSurgery_s_ID` FOREIGN KEY (`s_ID`) REFERENCES `surgeon`(`s_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Table structure for  `Medi_patient` table */
DROP TABLE IF EXISTS `MediPatient`;
CREATE TABLE `MediPatient` (
  `m_ID` varchar(10) NOT NULL,
  `p_ID` varchar(10) NOT NULL,
  
  PRIMARY KEY (`m_ID`,`p_ID`),
  
  CONSTRAINT `fk_MediPatient_medication` FOREIGN KEY (`m_ID`) REFERENCES `medication` (`m_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_MediPatient_Patient` FOREIGN KEY (`p_ID`) REFERENCES `patient` (`p_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

/*Show list of all tables in suwapiyasa database */
show tables;

/*Data for the table `emplyees` */
INSERT INTO `employees` (`empNumber`, `empName`, `empGender`, `empAddress`, `tepNo1`, `tepNo2`) VALUES
    ('s001', 'Sarath', 'male', 'kurunegala', '0710000001', '0710000001'),
    ('s002', 'Piumi', 'female', 'kurunegala', '0710000002', null),
    ('s003', 'Kamal', 'male', 'Polgahawela', '0770000001', '0780000003'),
    ('d001', 'Piyal', 'male', 'Kandy', '0710000011', '0710000021'),
    ('d002', 'Samanthi', 'female', 'kurunegala', '0712000002', null),
    ('d003', 'Heshan', 'male', 'Polgahawela', '0710500001', '0750000003'),
    ('n001', 'Kumara', 'male', 'Alawwa', '0710000004', '0710000004'),
    ('n002', 'Thilini', 'female', 'Kandy', '0780000001', null),
    ('n003', 'Dilini', 'female', 'Alawwa', '0760000008', '0710000007');

SELECT * FROM `employees`;

/*Data for the table `surgeon` */
INSERT INTO `surgeon` (`s_ID`, `contractType`, `contractLength`) VALUES
  ('s001', 'Full-time', '2 years'),
  ('s002', 'Part-time', '1 year'),
  ('s003', 'Full-time', '3 years');

SELECT * FROM `surgeon`;        

/*Data for the table `doctor` */
INSERT INTO `doctor` (`d_ID`, `speciality`) VALUES
('D001', 'Cardiology'),
('D002', 'Other'),
('D003', 'Dermatology');

SELECT * FROM `doctor`; 

/*Data for the table `location` */
INSERT INTO `location` (`l_ID`, `bedNumber`, `roomNumber`, `nursingUnit`) VALUES
  ('LOC001', 101, 201, 1),
  ('LOC001', 102, 201, 1),
  ('LOC001', 103, 201, 1),
  ('LOC002', 201, 101, 2),
  ('LOC002', 202, 101, 2);

SELECT * FROM `location`; 

/*Data for the table `medication` */
INSERT INTO `medication` (`m_ID`, `name`, `QOH`, `QO`, `cost`, `expirationDate`) VALUES
  ('MED001', 'Aspirin', 100, 20, 5.99, '2024-12-31'),
  ('MED002', 'Ibuprofen', 50, 15, 7.49, '2025-06-30'),
  ('MED003', 'Acetaminophen', 75, 25, 4.99, '2024-11-15'),
  ('MED004', 'Amoxicillin', 40, 10, 12.99, '2023-10-20'),
  ('MED005', 'Loratadine', 30, 8, 6.75, '2024-08-25');

SELECT * FROM `medication`; 

/*Data for the table `patient` */
INSERT INTO `patient` (`p_ID`, `Initials`, `LastName`, `age`, `address`, `bloodType`, `tepNo1`, `tepNo2`, `allergies1`, `allergies2`, `allergies3`, `d_ID`, `location_ID`) VALUES
  ('P001', 'J. K.', 'Kumara', 45, 'Anuradhapura', 'A', 0715892454, 0755892454, 'Pollen', 'Peanuts', 'Cats', 'D001', 'LOC001'),
  ('P002', 'S.', 'Saman', 73, 'Kelaniya', 'O', 0775892454, 0785892454, 'Dust', 'Shellfish', 'Penicillin', 'D002', 'LOC002'),
  ('P003', 'M.', 'Bandara', 61, 'Colombo', 'B', 0745892454, 0715893454, 'Mold', 'Eggs', 'Aspirin', 'D003', 'LOC003'),
  ('P004', 'G.', 'Sandun', 39, 'Kurunegala', 'A', 0715892444,0715852454, 'Grass', 'Dairy', 'Sulfites', 'D001', 'LOC002'),
  ('P005', 'R.', 'Kumari', 51, 'Kurunegala', 'A', 0715892459, 0716892454, 'Pollen', 'Fish', 'Latex', 'D002', 'LOC001');

SELECT * FROM `patient`; 

/*Data for the table `surgery` */
INSERT INTO `surgery` (`surgeryName`, `patientNumber`, `time`, `date`, `category`, `theatre`, `specialNeeds`)
VALUES
  ('S001', 'P001', '10:00 AM', '2023-09-15', 'Orthopedic', 'Theatre 1', 'None'),
  ('S002', 'P002', '2:30 PM', '2023-08-25', 'Cardiology', 'Theatre 2', 'Heart monitoring'),
  ('S003', 'P003', '9:45 AM', '2023-10-05', 'Gastroenterology', 'Theatre 3', 'Fasting required'),
  ('S004', 'P004', '3:15 PM', '2023-07-18', 'Dermatology', 'Theatre 1', 'Skin sensitivity testing'),
  ('S005', 'P005', '11:30 AM', '2023-11-12', 'Ophthalmology', 'Theatre 2', 'Eye dilation');

SELECT * FROM `surgery`; 

/*Data for the table `nurse` */
INSERT INTO `nurse` (`n_ID`, `grade`, `experience`, `skill`, `surgeryName`)
VALUES
  ('N001', 'A', '5 years', 'ICU', 'S001'),
  ('N002', 'B', '3 years', 'Pediatrics', 'S002'),
  ('N003', 'C', '2 years', 'Cardiology', NULL),
  ('N004', 'A', '7 years', 'Surgery', 'S003'),
  ('N005', 'D', '1 year', 'Emergency', 'S004');

SELECT * FROM `nurse`; 

/*Data for the table `headDoctor` */
INSERT INTO `headDoctor` (`d_ID`, `Head_ID`) VALUES
  ('D001', 'D002'),
  ('D003', 'D003');

SELECT * FROM `headDoctor`; 

/*Data for the table `surgenSurgery` */
INSERT INTO `surgenSurgery` (`surgeryName`, `s_ID`, `theatreInfo`)
VALUES
  ('S001', 'D001', 'Theatre 1, Floor 3'),
  ('S002', 'D002', 'Theatre 2, Floor 1'),
  ('S003', 'D003', 'Theatre 3, Floor 2'),
  ('S004', 'D001', 'Theatre 1, Floor 3'),
  ('S005', 'D002', 'Theatre 2, Floor 1');
  
  SELECT * FROM `surgenSurgery`; 
  
  /*Data for the table `MediPatient` */
  INSERT INTO `MediPatient` (`m_ID`, `p_ID`) VALUES
  ('MED001', 'P001'),
  ('MED002', 'P002'),
  ('MED003', 'P001'),
  ('MED004', 'P003'),
  ('MED005', 'P004');

  SELECT * FROM `MediPatient`; 
