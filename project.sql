SPOOL project.out
SET ECHO ON
/*
CIS 353
 - Database Design Project
Cade Baker
Kehlsey Lewis
Filipe Castanheira
Owen Dunn
*/
-- Drop the tables (in case they already exist)
--
DROP TABLE Customer         CASCADE CONSTRAINTS;
DROP TABLE Customer_Phones  CASCADE CONSTRAINTS;
DROP TABLE Booking          CASCADE CONSTRAINTS;
DROP TABLE Employee         CASCADE CONSTRAINTS;
DROP TABLE Billing          CASCADE CONSTRAINTS;
DROP TABLE Vehicle          CASCADE CONSTRAINTS;
DROP TABLE Manages          CASCADE CONSTRAINTS;
--
--
CREATE TABLE  Customer
(
custID         INTEGER,
firstName      CHAR(15)    NOT NULL,
lastName       CHAR(15)    NOT NULL,
driverLicense  CHAR(20)    NOT NULL,
DOB            DATE        NOT NULL,
--
-- cIC1_KEY: custIDs are the primary keys in the table
CONSTRAINT cIC1_KEY PRIMARY KEY (custID),
--
-- cIC2_AGE: customer must be at least 21
CONSTRAINT cIC2_AGE CHECK (DOB < TO_DATE('12/5/1996', 'MM/DD/YYYY'))
);
--
--
CREATE TABLE Customer_Phones
(
custID         INTEGER,
phoneNum       CHAR(13)   NOT NULL,
--
-- cpIC1_KEY: custID and phoneVal is the primary key in the table
CONSTRAINT cpIC1_KEY PRIMARY KEY (custID, phoneNum),
--
-- cpIC2_FKEY: custID references custID in Customer
CONSTRAINT cpIC2_FKEY FOREIGN KEY (custID) REFERENCES Customer(custID)
		   ON DELETE CASCADE
);
--
--
CREATE TABLE Employee
(
employeeSSN    INTEGER    NOT NULL,
firstName      CHAR(15)   NOT NULL,
lastName       CHAR(15)   NOT NULL,
sex            CHAR(6)    NOT NULL,
salary         INTEGER    NOT NULL,
DOB            DATE       NOT NULL,
vehicleVIN     CHAR(17),
inspectDate    DATE,
inspectResult  CHAR(4),
--
-- eIC1_KEY: employeeSSN is the primary key in the table
CONSTRAINT eIC1_KEY PRIMARY KEY (employeeSSN),
-- eIC2_SSNCHECK: Check that the employee SSN is 9 digits, contains
-- only digits, and is in range 100000000-999999999
CONSTRAINT eIC2_SSNCHECK CHECK (employeeSSN > 100000000 AND employeeSSN < 999999999),
--
-- eIC3_AGE: Check if the employee is at least 18
CONSTRAINT eIC3 CHECK (DOB < TO_DATE('11/30/1999', 'MM/DD/YYYY'))
);
--
--
CREATE TABLE  Vehicle
(
vin          CHAR(17)      NOT NULL,
make         CHAR(15)      NOT NULL,
model        CHAR(15)      NOT NULL,
year         INTEGER       NOT NULL,
rate         INTEGER       NOT NULL,
mileage      INTEGER       NOT NULL,
color        CHAR(10)      NOT NULL,
--
-- vIC1_KEY: The vin is the primary key
CONSTRAINT vIC1_KEY PRIMARY KEY (vin),
--
-- vIC2_AUDICHECK: If make is Audi, the rate must be greater than $100
CONSTRAINT vIC2_AUDIRATE CHECK (NOT(make = 'Audi' AND rate < 500))
);
--
--
CREATE TABLE Booking
(
bookingID      INTEGER,
startDate      DATE       NOT NULL,
endDate        DATE       NOT NULL,
carVIN         CHAR(17)   NOT NULL,
custID         INTEGER    NOT NULL,
employeeSSN    INTEGER    NOT NULL,
--
-- bIC1_KEY: bookingID is the primary key in the table
CONSTRAINT bIC1_KEY PRIMARY KEY (bookingID),
--
-- bIC2_FKEY: carVin references carVIn in Vehicle
CONSTRAINT bIC2_FKEY FOREIGN KEY (carVIN) REFERENCES Vehicle(vin)
		   ON DELETE SET NULL,
--
-- bIC3_FKEY: custID references custID in Customer
CONSTRAINT bIC3_FKEY FOREIGN KEY (custID) REFERENCES Customer(custID)
		   ON DELETE CASCADE,
--
-- bIC4_FKEY: employeeSSN references employeeSSN in Employee
CONSTRAINT bIC4_FKEY FOREIGN KEY (employeeSSN) REFERENCES Employee(employeeSSN)
		   ON DELETE SET NULL,
--
-- bIC5_VAIDDATE: ensure the start date is before the end date
CONSTRAINT bIC5_VAIDDATE CHECK (startDate < endDate)
);
--
--
CREATE TABLE  Billing
(
bookingID       INTEGER    NOT NULL,
billAddress     CHAR(50),
amountOwed      INTEGER,
amountPaid      INTEGER,
creditCardNum   CHAR(19)   NOT NULL,
creditCardType  CHAR(10)   NOT NULL,
dateDue         DATE       DEFAULT NULL,
--
-- biIC1_BILLWITHID: Every bill must be tied to a booking id.
CONSTRAINT biIC1_FKEY FOREIGN KEY (bookingID) REFERENCES Booking(bookingID)
           ON DELETE CASCADE,
--
-- biIC2_KEY: The bookingID and dateDue are the primary keys
CONSTRAINT biIC2_KEY PRIMARY KEY (bookingID,dateDue),
--
-- biIC3_AMTLOGIC: amountPaid is less than or equal to amountOwed
CONSTRAINT biIC3_AMTLOGIC CHECK (amountPaid <= amountOwed),
--
-- biIC4_CARDTYPE: Credit card has to be either Mastercard, Visa, AMEX, or Discover
CONSTRAINT biIC4_CARDTYPE CHECK (creditCardType = 'Mastercard' OR creditCardType = 'Visa' OR creditCardType = 'AMEX' OR
								creditCardType = 'Discover'),
--
-- biIC5_VALIDAMT: Amount paid must be greater than or equal to zero
CONSTRAINT biIC5_VALIDAMT CHECK (amountPaid >= 0)
);
--
--
CREATE TABLE Manages
(
employeeSSN    INTEGER    NOT NULL,
managerSSN     INTEGER,
--
-- mIC1_FKEY: employeeSSN references Employee ssn from Employee table
CONSTRAINT mIC1_FKEY FOREIGN KEY (employeeSSN) REFERENCES Employee(employeeSSN),
--
-- mIC2_FKEY: managerSSN references Employee ssn from Employee table
CONSTRAINT mIC2_FKEY FOREIGN KEY (managerSSN) REFERENCES Employee(employeeSSN)
);
--
--
SET FEEDBACK OFF
--< The INSERT statements that populate the tables> Important: Keep the number of rows in each table small enough so that the results of your queries can be verified by hand. See the Sailors database as an example.
--
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
INSERT INTO Customer VALUES (29, 'John',     'von Grollmann', 'B261462061547', TO_DATE('08/22/1953', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (89, 'Crawford', 'Dowers',        'B676624379988', TO_DATE('03/22/1955', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (88, 'Lars',     'Ingram',        'B115423769456', TO_DATE('04/29/1958', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (23, 'Con',      'Goodhand',      'B773290897872', TO_DATE('10/10/1965', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (55, 'Gray',     'Shorton',       'B139745073325', TO_DATE('06/03/1957', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (4,  'Carter',   'Redferne',      'B248616467291', TO_DATE('03/08/1968', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (9,  'Meriel',   'Marland',       'B620176458845', TO_DATE('04/01/1994', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (56, 'Gena',     'Wilkowski',     'B952432544942', TO_DATE('05/24/1952', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (98, 'Tim',      'Daile',         'B603397588072', TO_DATE('06/20/1965', 'MM/DD/YYYY'));
INSERT INTO Customer VALUES (54, 'Hilarius', 'Ranyard',       'B117685754408', TO_DATE('09/10/1973', 'MM/DD/YYYY'));
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
INSERT INTO Customer_Phones VALUES (29, '(810)224-2552');
INSERT INTO Customer_Phones VALUES (29, '(810)443-2453');
INSERT INTO Customer_Phones VALUES (89, '(813)221-6798');
INSERT INTO Customer_Phones VALUES (88, '(443)225-3532');
INSERT INTO Customer_Phones VALUES (23, '(228)664-2246');
INSERT INTO Customer_Phones VALUES (55, '(390)221-4598');
INSERT INTO Customer_Phones VALUES (4,  '(332)789-2683');
INSERT INTO Customer_Phones VALUES (9,  '(887)442-5731');
INSERT INTO Customer_Phones VALUES (56, '(378)221-7743');
INSERT INTO Customer_Phones VALUES (98, '(554)221-7785');
INSERT INTO Customer_Phones VALUES (54, '(889)446-2566');
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
INSERT INTO Employee VALUES (841606366, 'Hewett',   'Sumption',   'Male',   '109381.39',  TO_DATE('07/26/1967', 'MM/DD/YYYY'),
							'1HL456234050304H1', TO_DATE('05/22/2017', 'MM/DD/YYYY'), 'Pass');
INSERT INTO Employee VALUES (949064604, 'Mack',     'Gauld',      'Male',   '76245.54',   TO_DATE('03/26/1976', 'MM/DD/YYYY'),
							'2E245WB330G1394FF', TO_DATE('02/28/2017', 'MM/DD/YYYY'), 'Fail');
INSERT INTO Employee VALUES (367343136, 'Juana',    'Jeannot',    'Female', '132272.35',  TO_DATE('10/14/1999', 'MM/DD/YYYY'),
							'HIT1BYE3803034M21', TO_DATE('05/12/2017', 'MM/DD/YYYY'), 'Fail');
INSERT INTO Employee VALUES (739865735, 'Donielle', 'McGuggy',    'Female', '59397.76',   TO_DATE('09/9/1971',  'MM/DD/YYYY'),
							'1HL456234050304H1', TO_DATE('07/14/2017', 'MM/DD/YYYY'), 'Pass');
INSERT INTO Employee VALUES (311710664, 'Miller',   'Guinan',     'Male',   '29490.82',   TO_DATE('01/23/1967', 'MM/DD/YYYY'),
							'5BL456REBMUN0NV14', TO_DATE('11/12/2017', 'MM/DD/YYYY'), 'Pass');
INSERT INTO Employee VALUES (599405184, 'Fenelia',  'Lambis',     'Female', '65860.71',   TO_DATE('05/28/1958', 'MM/DD/YYYY'),
							'F56789TETTF030413', TO_DATE('11/20/2017', 'MM/DD/YYYY'), 'Pass');
INSERT INTO Employee VALUES (567169645, 'Shir',     'Bridgwater', 'Female', '64136.82',   TO_DATE('08/8/1994',  'MM/DD/YYYY'),
							'2E245WB330G1394FF', TO_DATE('10/04/2017', 'MM/DD/YYYY'), 'Pass');
INSERT INTO Employee VALUES (924747806, 'Edouard',  'Buckthorpe', 'Male',   '42483.51',   TO_DATE('04/6/1950',  'MM/DD/YYYY'),
							'VROOM62340VR0M229', TO_DATE('11/25/2017', 'MM/DD/YYYY'), 'Fail');
INSERT INTO Employee VALUES (344276769, 'Riley',    'McKeighen',  'Male',   '147753.21',  TO_DATE('08/1/1969',  'MM/DD/YYYY'),
							'HIT1BYE3803034M21', TO_DATE('11/28/2017', 'MM/DD/YYYY'), 'Pass');
INSERT INTO Employee VALUES (713782826, 'Fletcher', 'Ingerfield', 'Male',   '133674.79',  TO_DATE('12/5/1965',  'MM/DD/YYYY'),
							'2FL24673203384SXN', TO_DATE('11/30/2017', 'MM/DD/YYYY'), 'Pass');
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
INSERT INTO Vehicle VALUES ('1HL456234050304H1', 'Audi',  'R8',           2017, 500, 500,    'black');
INSERT INTO Vehicle VALUES ('2E245WB330G1394FF', 'Chevy', 'Equinox',      2017, 90,  10000,  'white');
INSERT INTO Vehicle VALUES ('F56789TETTF030413', 'Chevy', 'Malibu',       2014, 70,  5000,   'red');
INSERT INTO Vehicle VALUES ('5BL456REBMUN0NV14', 'Ford',  'Fusion',       2014, 70,  30000,  'silver');
INSERT INTO Vehicle VALUES ('HIT1BYE3803034M21', 'Gmc',   'Sierra',       2017, 110, 6000,   'black');
INSERT INTO Vehicle VALUES ('VROOM62340VR0M229', 'Dodge', 'Charger',      2016, 100, 10000,  'red');
INSERT INTO Vehicle VALUES ('2FL24673203384SXN', 'Dodge', 'Grand Caravan',2015, 60,  100000, 'silver');
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--Booking(bookingID, startDate, endDate, vehicleVIN, custID, employeeSSN)
INSERT INTO Booking VALUES (70, TO_DATE('11/22/2017', 'MM/DD/YYYY'), TO_DATE('12/01/2017', 'MM/DD/YYYY'),
							'F56789TETTF030413', 29, '841606366');
INSERT INTO Booking VALUES (69, TO_DATE('12/15/2017', 'MM/DD/YYYY'), TO_DATE('12/28/2017', 'MM/DD/YYYY'),
							'2E245WB330G1394FF', 89, '949064604');
INSERT INTO Booking VALUES (68, TO_DATE('10/15/2016', 'MM/DD/YYYY'), TO_DATE('11/01/2016', 'MM/DD/YYYY'),
							'5BL456REBMUN0NV14', 88, '367343136');
INSERT INTO Booking VALUES (67, TO_DATE('06/01/2016', 'MM/DD/YYYY'), TO_DATE('06/15/2016', 'MM/DD/YYYY'),
							'HIT1BYE3803034M21', 23, '739865735');
INSERT INTO Booking VALUES (66, TO_DATE('03/24/2016', 'MM/DD/YYYY'), TO_DATE('03/29/2017', 'MM/DD/YYYY'),
							'VROOM62340VR0M229', 55, '311710664');
INSERT INTO Booking VALUES (65, TO_DATE('02/21/2016', 'MM/DD/YYYY'), TO_DATE('02/28/2017', 'MM/DD/YYYY'),
							'2FL24673203384SXN', 4, '567169645');
INSERT INTO Booking VALUES (64, TO_DATE('10/24/2015', 'MM/DD/YYYY'), TO_DATE('10/26/2015', 'MM/DD/YYYY'),
							'1HL456234050304H1', 9, '924747806');
INSERT INTO Booking VALUES (63, TO_DATE('02/10/2017', 'MM/DD/YYYY'), TO_DATE('02/23/2017', 'MM/DD/YYYY'),
							'1HL456234050304H1', 9, '344276769');
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--Billing(bookingID, billAddress, amountOwed, amountPaid, CCNum, CCType, dateDue)

INSERT INTO Billing VALUES (70, '6815 Driving Lane',        630, 500,  '1234567812345678', 'Visa',
							TO_DATE('12/01/2017','MM/DD/YYYY'));
INSERT INTO Billing VALUES (69, '9501 Candycane lane',      1170,  50,   '2234567812345678', 'Visa',
							TO_DATE('11/28/2017', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (68, '6915 Silverlake rd',       1190, 1000, '3234567812345678', 'Mastercard',
							TO_DATE('11/01/2016', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (67, '5013 48 ave',              1540, 1000, '4234567812345678', 'Visa',
							TO_DATE('06/15/2016', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (66, '4011 Lake Michigan Drive', 500, 500,  '5234567812345678', 'Mastercard',
							TO_DATE('03/29/2017', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (65, '4596 Pierce st',           420,  200,  '6234567812345679', 'Discover',
							TO_DATE('01/15/2017', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (64, '5162 Garfield rd',         1000,  50,   '7234567812345678', 'AMEX',
							TO_DATE('10/26/2015', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (63, '2316 Bear Lake rd',        6500, 3000, '8234567812345678', 'Visa',
							TO_DATE('02/23/2017', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (64, '7546 Peirce st',           3000, 600,  '9234567812345677', 'Discover',
							TO_DATE('09/22/2016', 'MM/DD/YYYY'));
INSERT INTO Billing VALUES (65, '4940 Lake Michigan Drive', 220,  0,    '1124567812345678', 'Mastercard',
							TO_DATE('02/28/2017', 'MM/DD/YYYY'));
------------------------------------------------------------------------
------------------------------------------------------------------------
INSERT INTO Manages VALUES (841606366, 713782826);
INSERT INTO Manages VALUES (949064604, 841606366);
INSERT INTO Manages VALUES (367343136, 713782826);
INSERT INTO Manages VALUES (739865735, 367343136);
INSERT INTO Manages VALUES (311710664, 739865735);
INSERT INTO Manages VALUES (311710664, 367343136);
INSERT INTO Manages VALUES (599405184, 841606366);
INSERT INTO Manages VALUES (567169645, 949064604);
INSERT INTO Manages VALUES (924747806, 949064604);
INSERT INTO Manages VALUES (344276769, NULL);
INSERT INTO Manages VALUES (713782826, NULL);
--
--
SET FEEDBACK ON
COMMIT;
-- < One query (per table) of the form: SELECT * FROM table; in order to print out your database >
-- Print out the database state.
SELECT * FROM Customer;
SELECT * FROM Customer_Phones;
SELECT * FROM Employee;
SELECT * FROM Vehicle;
SELECT * FROM Booking;
SELECT * FROM Billing;
--
--
-- < The  SQL queries >. Include the following for each query:
--1.A comment line stating the query number and the feature(s) it demonstrates e.g. – Q25 – correlated subquery).
--2.A comment line stating the query in English.
--3.The SQL code for the query.
--
--
--
/* Q1 - A join involving at least four relations
Find the customers who rented a Charger and the employee who booked and cleaned the vehicle.
Find the customers first name, last name, ID, and the employee's social securty number
*/
SELECT C.custID, C.firstName, C.lastName, E.employeeSSN 
FROM BOOKING B, CUSTOMER C, EMPLOYEE E, VEHICLE V
WHERE V.model = 'Charger' AND V.VIN = E.vehicleVIN AND V.VIN = B.carVIN AND
      B.custID = C.custID
ORDER BY C.CustID;
--
--
--
/* Q2 - Self-join
Find pairs of booking IDs such that the value of the amount paid is more than 50% of the amount owned of the first booking ID (in the pair). The second booking ID in the pair has similar information to the first booking ID. The pairs are listed once only.
*/
SELECT B1.bookingID, B2.bookingID
FROM   Billing B1, Billing B2
WHERE  B1.amountPaid > 0.5 * B1.amountOwed AND
       B1.amountPaid > B2.amountPaid       AND
       B1.bookingID < B2.bookingID;
--
--
--
/* Q3 - UNION, INTERSECT, and/or MINUS.
For every employee that gave a failure on their latest vehicle
inspection and has a salary of more than 100000: Find the employee SSN,
first name, and last name.
*/
SELECT employeeSSN, firstName, lastName
FROM   Employee
WHERE  salary > 100000
       INTERSECT
SELECT employeeSSN, firstName, lastName
FROM   Employee
WHERE  inspectResult = 'Fail';
--
--
--
/* Q4 - SUM, AVG, MAX, and/or MIN
Find the maximum, average, and minimum amount owed in every billing process.
*/
SELECT MAX(amountOwed) as maxAmountOwed, AVG(amountOwed) as averageAmountOwed, MIN(amountOwed) as minAmountOwed
FROM   Billing;
--
--
--
/* Q5 - GROUP BY, HAVING, and ORDER BY,
For every vehicle that has more than 1 employee working on it: 
Find the Vehicle's VIN number and the number of employees working on it.
Order by the vehicle VIN.
*/
SELECT   E.vehicleVIN, COUNT(*)
FROM     Employee E
GROUP BY E.vehicleVIN
HAVING   COUNT(*) > 1
ORDER BY E.vehicleVIN;
--
--
--
/* Q6 - A correlated subquery
For every customer that has booked a vehicle and payed with a VISA: Find
the customer ID, first name, last name
*/
SELECT C.custID, C.firstName, C.lastName
FROM Customer C, Booking B1
WHERE C.custID =  B1.custID AND
      EXISTS (SELECT *
              FROM Billing B2
              WHERE B1.bookingID = B2.bookingID AND
                    B2.creditCardType = 'Visa')
ORDER BY C.custID;
--
--
--
/* Q7 - Non-correlated subquery
For every customer who did not booked an Audi: Find the customer's ID, first and last name, driver license and date of birth. Sort the results by the customer's last name.
*/
SELECT C.custID, C.firstName, C.lastName, C.driverLicense, C.DOB
FROM   Customer C
WHERE  C.custID NOT IN
       (SELECT B.custID
        FROM   Booking B, vehicle V
        WHERE  B.carVIN = V.vin AND V.make = 'Audi')
ORDER BY C.lastName;
--
--
--
/* Q8 - Relational DIVISION query
For every employee who works on every Audi vehicle: Find the employee's ssn, last name, first name, sex, date of birth, salary, the inspection date and its consequent result. Sort the results by the employee's last name.
*/
SELECT E.employeeSSN, E.lastName, E.firstName, E.sex, E.DOB, E.salary, E.inspectDate, E.inspectResult
FROM   employee E
WHERE  NOT EXISTS (
       (SELECT V.vin
        FROM   Vehicle V
        WHERE  V.make = 'Audi')
       MINUS
       (SELECT E.vehicleVIN
        FROM   Vehicle V
        WHERE  E.vehicleVIN = V.vin))
ORDER BY E.lastName;
--
--
--
/* Q9 - Outer join query
Find the employee's social security name, first and last name for every employee. Also show the booking ID and the its vehicleVIN that the employees are responsible for.
*/
SELECT E.employeeSSN, E.firstName, E.lastName, B.bookingID, B.carVIN
FROM   Employee E LEFT OUTER JOIN Booking B ON E.employeeSSN = B.employeeSSN;
----
--
--
/* Q10 - RANK query
Find the rank of the salary 59397.76 among all salaries.
*/
SELECT RANK (59397.76) WITHIN GROUP
       (ORDER BY salary) "Rank of salary 59397.76"
FROM   Employee;
--
--
--
/* Q11 - Top-N query
Find the employee's social security number, first and last name, sex, date of birth, and salary of the three highest paid employees.
*/
SELECT employeeSSN, firstName, lastName, sex, DOB, salary
FROM   (SELECT * FROM Employee ORDER BY salary DESC)
WHERE  ROWNUM < 4;
--
--
--
-- < The insert/delete/update statements to test the enforcement of ICs>
--Include the following items for every IC that you test (Important: see the next section titled “Submit a final report” regarding which ICs to test).
--A comment line stating: Testing: < IC name>
--A SQL INSERT, DELETE, or UPDATE that will test the IC.
--
--TESTING: cIC1_KEY Attempt to insert a new Customer with an existing Customer ID
INSERT INTO Customer VALUES (29, 'Cade',     'Baker', 'B364411226547', TO_DATE('05/16/1980', 'MM/DD/YYYY'));
--
--TESTING: bIC2_FKEY Attempt to insert a booking with a car vin number that doesn't exist
INSERT INTO Booking VALUES (71, TO_DATE('12/04/2017', 'MM/DD/YYYY'), TO_DATE('12/10/2017', 'MM/DD/YYYY'),
							'F884548IO335208E2', 29, '841606366');
--
--TESTING: biIC5_VALIDAMT: Attempt to insert a negative amount paid for the billing
INSERT INTO Billing VALUES (70, '6815 Driving Lane',        630, -20,  '1234567812345678', 'Visa',
							TO_DATE('12/04/2017','MM/DD/YYYY'));
--
--TESTING: vIC2_AUDIRATE: Attempt to update the rate of renting an Audi to less than $500
UPDATE Vehicle SET rate= 480 WHERE vin='1HL456234050304H1';
--
--
COMMIT;
--
SPOOL OFF
