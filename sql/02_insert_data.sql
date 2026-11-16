-- Homer Consulting | Part II.A.2 | Script #2
-- Populates the seven tables created by Script #1 (01_create_tables.sql).
-- Data is built around "today" = November 2026, so that:
--   * "this calendar year" = 2026, "current month" = November 2026
--   * assignments in November 2026 have NULL Date_Ended and Hours_Used
--   * ongoing projects have NULL Total_Cost
-- Insert order follows the foreign keys:
--   SKILL -> CLIENT -> DEPARTMENT -> EMPLOYEE -> (set managers)
--   -> PROJECT -> TRAINING -> ASSIGNMENT
-- All constraints from Script #1 stay enabled while this runs.

SET DEFINE OFF

-- Clear existing rows (children first) so the script can be re-run
DELETE FROM ASSIGNMENT;
DELETE FROM TRAINING;
DELETE FROM PROJECT;
UPDATE DEPARTMENT SET Manager_ID = NULL;
DELETE FROM EMPLOYEE;
DELETE FROM DEPARTMENT;
DELETE FROM CLIENT;
DELETE FROM SKILL;

-- 1. SKILL (7 key skills, 4 categories; AWS has no trained employee yet)
INSERT INTO SKILL (Code, Name, Category)
VALUES ('SQL', 'Oracle SQL and Database Design', 'Data');
INSERT INTO SKILL (Code, Name, Category)
VALUES ('PBI', 'Power BI Reporting', 'Data');
INSERT INTO SKILL (Code, Name, Category)
VALUES ('PY', 'Python Programming', 'Programming');
INSERT INTO SKILL (Code, Name, Category)
VALUES ('JAVA', 'Java Application Development', 'Programming');
INSERT INTO SKILL (Code, Name, Category)
VALUES ('FIN', 'Financial Modeling', 'Business');
INSERT INTO SKILL (Code, Name, Category)
VALUES ('PM', 'Project Management', 'Business');
INSERT INTO SKILL (Code, Name, Category)
VALUES ('AWS', 'AWS Cloud Architecture', 'Cloud');

-- 2. CLIENT (11 clients: .edu, .gov, .org, .com, other (.io), and one
--    with no web address; clients 1010 and 1011 are potential clients
--    with no projects yet)
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1001, 'Allegheny State University', '400 Forbes Ave', 'Pittsburgh', 'PA', '15213', 'Higher Education', 'https://www.alleghenystate.edu', '412-555-1001', 'Harper', 'Lisa');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1002, 'Three Rivers Community College', '88 Ridge Ave', 'Pittsburgh', 'PA', '15212', 'Higher Education', 'https://www.trcc.edu', '412-555-1002', 'Coleman', 'Mark');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1003, 'Steel City Retail Inc.', '1200 Penn Ave', 'Pittsburgh', 'PA', '15222', 'Retail', 'https://www.steelcityretail.com', '412-555-1003', 'Bennett', 'Rachel');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1004, 'Riverside Food Bank', '35 Water St', 'Pittsburgh', 'PA', '15219', 'Non-Profit', 'https://www.riversidefoodbank.org', '412-555-1004', 'Ortiz', 'Maria');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1005, 'Commonwealth Revenue Office', '300 Market St', 'Harrisburg', 'PA', '17101', 'Government', 'https://www.revenue.pa.gov', '717-555-1005', 'Fischer', 'Thomas');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1006, 'Keystone Logistics LLC', '900 Freeport Rd', 'Pittsburgh', 'PA', '15238', 'Logistics', 'https://www.keystonelogistics.com', '412-555-1006', 'Reed', 'Brian');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1007, 'Monongahela Capital Partners', '2 PPG Pl', 'Pittsburgh', 'PA', '15222', 'Financial Services', 'https://www.moncapital.com', '412-555-1007', 'Hughes', 'Caroline');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1008, 'Allegheny Public Health Agency', '542 Fourth Ave', 'Pittsburgh', 'PA', '15219', 'Government', 'https://www.aphealth.gov', '412-555-1008', 'Ward', 'Denise');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1009, 'Brightpath Cloud Labs', '4000 Butler St', 'Pittsburgh', 'PA', '15201', 'Technology', 'https://www.brightpathlabs.io', '412-555-1009', 'Price', 'Jordan');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1010, 'Ohio Valley Arts Council', '77 Liberty Ave', 'Pittsburgh', 'PA', '15222', 'Arts', 'https://www.ovartscouncil.org', '412-555-1010', 'Sullivan', 'Helen');
INSERT INTO CLIENT (Client_ID, Name, Street, City, State, Zip_Code, Industry, Web_Address, Phone, Contact_LName, Contact_Fname)
VALUES (1011, 'Hilltop Family Bakery', '15 Main St', 'Sewickley', 'PA', '15143', 'Food Service', NULL, '412-555-1011', 'Marino', 'Joe');

-- 3. DEPARTMENT (managers are filled in after EMPLOYEE is loaded,
--    because EMPLOYEE.Dept_Code needs the department to exist first)
INSERT INTO DEPARTMENT (Dept_Code, Name, Location, Phone, Manager_ID)
VALUES ('EXE', 'Executive Office', 'Pittsburgh, PA - Floor 10', '412-555-0100', NULL);
INSERT INTO DEPARTMENT (Dept_Code, Name, Location, Phone, Manager_ID)
VALUES ('ADM', 'Administration', 'Pittsburgh, PA - Floor 2', '412-555-0110', NULL);
INSERT INTO DEPARTMENT (Dept_Code, Name, Location, Phone, Manager_ID)
VALUES ('MKT', 'Marketing', 'Pittsburgh, PA - Floor 3', '412-555-0120', NULL);
INSERT INTO DEPARTMENT (Dept_Code, Name, Location, Phone, Manager_ID)
VALUES ('ANA', 'Data Analytics', 'Pittsburgh, PA - Floor 6', '412-555-0130', NULL);
INSERT INTO DEPARTMENT (Dept_Code, Name, Location, Phone, Manager_ID)
VALUES ('SWE', 'Software Engineering', 'Pittsburgh, PA - Floor 7', '412-555-0140', NULL);
INSERT INTO DEPARTMENT (Dept_Code, Name, Location, Phone, Manager_ID)
VALUES ('FIN', 'Financial Advisory', 'Pittsburgh, PA - Floor 8', '412-555-0150', NULL);

-- 4. EMPLOYEE (inserted top-down so every Super_ID already exists)
--    100 = CEO; 130/140/150/110/120 = department heads;
--    134, 144, 152 were hired in Q2 2026
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (100, 'Chen', 'Margaret', 'Chief Executive Officer', TO_DATE('1968-04-22','YYYY-MM-DD'), TO_DATE('2008-03-03','YYYY-MM-DD'), NULL, 'EXE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (101, 'Brooks', 'Daniel', 'Executive Assistant', TO_DATE('1990-07-15','YYYY-MM-DD'), TO_DATE('2019-02-11','YYYY-MM-DD'), 100, 'EXE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (110, 'Patel', 'Anita', 'Administration Manager', TO_DATE('1978-01-30','YYYY-MM-DD'), TO_DATE('2013-05-20','YYYY-MM-DD'), 100, 'ADM');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (120, 'Rossi', 'Laura', 'Marketing Manager', TO_DATE('1982-06-18','YYYY-MM-DD'), TO_DATE('2014-08-04','YYYY-MM-DD'), 100, 'MKT');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (130, 'Walker', 'James', 'Analytics Director', TO_DATE('1975-09-09','YYYY-MM-DD'), TO_DATE('2010-06-14','YYYY-MM-DD'), 100, 'ANA');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (140, 'Johnson', 'Robert', 'Engineering Director', TO_DATE('1977-02-14','YYYY-MM-DD'), TO_DATE('2011-09-12','YYYY-MM-DD'), 100, 'SWE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (150, 'Murphy', 'Patrick', 'Finance Director', TO_DATE('1972-11-11','YYYY-MM-DD'), TO_DATE('2012-01-09','YYYY-MM-DD'), 100, 'FIN');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (111, 'Nguyen', 'Kevin', 'Office Coordinator', TO_DATE('1995-11-03','YYYY-MM-DD'), TO_DATE('2021-09-07','YYYY-MM-DD'), 110, 'ADM');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (121, 'Kim', 'Jason', 'Marketing Specialist', TO_DATE('1997-02-25','YYYY-MM-DD'), TO_DATE('2022-03-14','YYYY-MM-DD'), 120, 'MKT');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (131, 'Garcia', 'Sofia', 'Principal Data Scientist', TO_DATE('1985-12-01','YYYY-MM-DD'), TO_DATE('2009-08-17','YYYY-MM-DD'), 130, 'ANA');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (134, 'Hassan', 'Omar', 'Junior Data Analyst', TO_DATE('2004-05-19','YYYY-MM-DD'), TO_DATE('2026-04-06','YYYY-MM-DD'), 130, 'ANA');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (132, 'Okafor', 'David', 'Data Analyst', TO_DATE('1992-03-27','YYYY-MM-DD'), TO_DATE('2018-06-25','YYYY-MM-DD'), 131, 'ANA');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (133, 'Li', 'Mei', 'BI Analyst', TO_DATE('1994-08-12','YYYY-MM-DD'), TO_DATE('2020-11-16','YYYY-MM-DD'), 131, 'ANA');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (141, 'Schmidt', 'Anna', 'Lead Software Engineer', TO_DATE('1986-10-21','YYYY-MM-DD'), TO_DATE('2014-03-17','YYYY-MM-DD'), 140, 'SWE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (144, 'Ivanova', 'Elena', 'Junior Developer', TO_DATE('2008-01-15','YYYY-MM-DD'), TO_DATE('2026-05-18','YYYY-MM-DD'), 140, 'SWE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (142, 'Lopez', 'Carlos', 'Software Engineer', TO_DATE('1991-05-05','YYYY-MM-DD'), TO_DATE('2019-08-26','YYYY-MM-DD'), 141, 'SWE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (143, 'Brown', 'Emily', 'Software Engineer', TO_DATE('1993-09-30','YYYY-MM-DD'), TO_DATE('2020-02-10','YYYY-MM-DD'), 141, 'SWE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (145, 'Wright', 'Tyler', 'QA Engineer', TO_DATE('1996-07-08','YYYY-MM-DD'), TO_DATE('2021-07-19','YYYY-MM-DD'), 141, 'SWE');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (151, 'Silva', 'Ana', 'Senior Financial Analyst', TO_DATE('1988-04-03','YYYY-MM-DD'), TO_DATE('2016-01-25','YYYY-MM-DD'), 150, 'FIN');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (152, 'Taylor', 'Grace', 'Financial Analyst', TO_DATE('2002-09-17','YYYY-MM-DD'), TO_DATE('2026-06-22','YYYY-MM-DD'), 151, 'FIN');
INSERT INTO EMPLOYEE (Emp_Num, LName, FName, Title, DOB, Hire_Date, Super_ID, Dept_Code)
VALUES (153, 'Moore', 'Ethan', 'Financial Analyst', TO_DATE('1999-12-12','YYYY-MM-DD'), TO_DATE('2024-08-19','YYYY-MM-DD'), 151, 'FIN');

-- 5. Assign department managers now that employees exist
UPDATE DEPARTMENT SET Manager_ID = 100 WHERE Dept_Code = 'EXE';
UPDATE DEPARTMENT SET Manager_ID = 110 WHERE Dept_Code = 'ADM';
UPDATE DEPARTMENT SET Manager_ID = 120 WHERE Dept_Code = 'MKT';
UPDATE DEPARTMENT SET Manager_ID = 130 WHERE Dept_Code = 'ANA';
UPDATE DEPARTMENT SET Manager_ID = 140 WHERE Dept_Code = 'SWE';
UPDATE DEPARTMENT SET Manager_ID = 150 WHERE Dept_Code = 'FIN';

-- 6. PROJECT (NULL Total_Cost = ongoing project).
--    ADM, MKT and EXE run no projects.
--    2026 starts: Q1 = 2004, 2005; Q2 = 2006, 2007;
--                 Q3 = 2008, 2009, 2010; Q4 = 2011, 2012
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2001, 'Sales Data Warehouse', TO_DATE('2025-03-03','YYYY-MM-DD'), 185000, 'ANA', 1003, 'SQL');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2002, 'Grant Portal Modernization', TO_DATE('2025-09-08','YYYY-MM-DD'), 142500, 'SWE', 1001, 'JAVA');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2003, 'Revenue Forecast Model', TO_DATE('2025-11-03','YYYY-MM-DD'), 64000, 'FIN', 1005, 'FIN');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2004, 'Donor Analytics Dashboard', TO_DATE('2026-01-12','YYYY-MM-DD'), 58250, 'ANA', 1004, 'PBI');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2005, 'Inventory Microservices', TO_DATE('2026-02-02','YYYY-MM-DD'), NULL, 'SWE', 1006, 'JAVA');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2006, 'Student Retention Analysis', TO_DATE('2026-04-13','YYYY-MM-DD'), 47800, 'ANA', 1002, 'PY');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2007, 'Tax Compliance Review', TO_DATE('2026-05-04','YYYY-MM-DD'), 89400, 'FIN', 1005, 'FIN');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2008, 'Cloud Migration Assessment', TO_DATE('2026-07-06','YYYY-MM-DD'), NULL, 'SWE', 1009, 'AWS');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2009, 'Customer Churn Model', TO_DATE('2026-08-03','YYYY-MM-DD'), NULL, 'ANA', 1003, 'PY');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2010, 'Investment Risk Report', TO_DATE('2026-09-14','YYYY-MM-DD'), 36500, 'FIN', 1007, 'FIN');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2011, 'Public Health Data Pipeline', TO_DATE('2026-10-05','YYYY-MM-DD'), NULL, 'ANA', 1008, 'SQL');
INSERT INTO PROJECT (Proj_Number, Title, Start_Date, Total_Cost, Dept_Code, Client_ID, Code)
VALUES (2012, 'Volunteer Scheduling App', TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, 'SWE', 1004, 'PM');

-- 7. TRAINING (some employees repeat a training to renew a skill)
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4001, 'FIN', 100, 'Corporate Finance Executive Program', TO_DATE('2012-09-17','YYYY-MM-DD'), 'Executive education, 5-day program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4002, 'PM', 100, 'PMP Certification', TO_DATE('2015-04-10','YYYY-MM-DD'), 'Passed PMP exam');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4003, 'PM', 110, 'Agile Fundamentals Workshop', TO_DATE('2018-10-01','YYYY-MM-DD'), '2-day in-house workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4004, 'PBI', 120, 'Power BI for Marketing Dashboards', TO_DATE('2021-06-07','YYYY-MM-DD'), 'Online course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4005, 'SQL', 130, 'Oracle SQL Fundamentals', TO_DATE('2011-03-14','YYYY-MM-DD'), 'College course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4006, 'PM', 130, 'PMP Certification', TO_DATE('2017-11-06','YYYY-MM-DD'), 'Passed PMP exam');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4007, 'SQL', 130, 'Advanced Oracle SQL', TO_DATE('2019-05-20','YYYY-MM-DD'), 'Renewal of SQL skill');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4008, 'SQL', 131, 'Oracle SQL Fundamentals', TO_DATE('2016-02-08','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4009, 'PY', 131, 'Python for Data Analysis', TO_DATE('2020-09-14','YYYY-MM-DD'), 'Online course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4010, 'PBI', 131, 'Power BI Data Modeling', TO_DATE('2023-03-13','YYYY-MM-DD'), 'Workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4011, 'PY', 131, 'Python Machine Learning Refresher', TO_DATE('2025-06-09','YYYY-MM-DD'), 'Renewal of Python skill');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4012, 'SQL', 132, 'Oracle SQL Fundamentals', TO_DATE('2018-07-09','YYYY-MM-DD'), 'New-hire training');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4013, 'PBI', 132, 'Power BI Data Modeling', TO_DATE('2022-01-24','YYYY-MM-DD'), 'Workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4014, 'PY', 132, 'Python for Data Analysis', TO_DATE('2024-04-15','YYYY-MM-DD'), 'Online course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4015, 'PBI', 132, 'Power BI Advanced DAX', TO_DATE('2025-10-20','YYYY-MM-DD'), 'Renewal of Power BI skill');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4016, 'PBI', 133, 'Power BI Data Modeling', TO_DATE('2021-05-17','YYYY-MM-DD'), 'Workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4017, 'SQL', 133, 'Oracle SQL Fundamentals', TO_DATE('2021-08-02','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4018, 'PY', 134, 'Python Bootcamp for New Hires', TO_DATE('2026-05-11','YYYY-MM-DD'), 'Internal new-hire training');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4019, 'SQL', 134, 'Oracle SQL Fundamentals', TO_DATE('2026-06-15','YYYY-MM-DD'), 'Internal new-hire training');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4020, 'JAVA', 140, 'Java Programming I', TO_DATE('2012-02-13','YYYY-MM-DD'), 'College course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4021, 'PM', 140, 'Agile Fundamentals Workshop', TO_DATE('2016-09-12','YYYY-MM-DD'), '2-day in-house workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4022, 'JAVA', 141, 'Java Programming I', TO_DATE('2014-06-02','YYYY-MM-DD'), 'College course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4023, 'SQL', 141, 'Oracle SQL Fundamentals', TO_DATE('2015-01-12','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4024, 'JAVA', 141, 'Java 17 Upgrade', TO_DATE('2022-06-06','YYYY-MM-DD'), 'Renewal of Java skill');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4025, 'JAVA', 142, 'Java Programming I', TO_DATE('2019-11-04','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4026, 'PY', 142, 'Python for Data Analysis', TO_DATE('2023-08-21','YYYY-MM-DD'), 'Online course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4027, 'JAVA', 143, 'Java Programming I', TO_DATE('2020-03-09','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4028, 'JAVA', 144, 'Java Onboarding Bootcamp', TO_DATE('2026-07-20','YYYY-MM-DD'), 'Internal new-hire training');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4029, 'JAVA', 145, 'Java Testing with JUnit', TO_DATE('2021-10-11','YYYY-MM-DD'), 'Workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4030, 'PM', 145, 'Agile Fundamentals Workshop', TO_DATE('2024-02-05','YYYY-MM-DD'), '2-day in-house workshop');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4031, 'FIN', 150, 'Financial Modeling Certificate', TO_DATE('2012-05-07','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4032, 'FIN', 150, 'Advanced Valuation Methods', TO_DATE('2020-05-11','YYYY-MM-DD'), 'Renewal of finance skill');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4033, 'FIN', 151, 'Financial Modeling Certificate', TO_DATE('2016-04-04','YYYY-MM-DD'), 'Technical program');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4034, 'PBI', 151, 'Power BI for Finance', TO_DATE('2022-09-19','YYYY-MM-DD'), 'Online course');
INSERT INTO TRAINING (Train_Num, Code, Emp_Num, Name, Date_Acquired, Comments)
VALUES (4035, 'FIN', 153, 'Financial Modeling Certificate', TO_DATE('2025-03-03','YYYY-MM-DD'), 'Technical program');

-- 8. ASSIGNMENT (one row per employee, per project, per month).
--    Project 2002 has no work in Nov-Dec 2025 and project 2005 has no
--    work in Apr-May 2026 (discontinued, then resumed).
--    November 2026 rows are the current month: Date_Ended and
--    Hours_Used are NULL.
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3001, 2001, 131, TO_DATE('2025-03-03','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3002, 2001, 132, TO_DATE('2025-03-10','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 96);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3003, 2001, 131, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 140);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3004, 2001, 132, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 130);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3005, 2001, 133, TO_DATE('2025-04-07','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3006, 2001, 131, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-23','YYYY-MM-DD'), 90);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3007, 2001, 133, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-23','YYYY-MM-DD'), 85);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3008, 2002, 141, TO_DATE('2025-09-08','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3009, 2002, 142, TO_DATE('2025-09-08','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 105);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3010, 2002, 141, TO_DATE('2025-10-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 150);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3011, 2002, 142, TO_DATE('2025-10-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 140);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3012, 2002, 143, TO_DATE('2025-10-13','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 80);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3013, 2003, 151, TO_DATE('2025-11-03','YYYY-MM-DD'), TO_DATE('2025-11-28','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3014, 2003, 153, TO_DATE('2025-11-03','YYYY-MM-DD'), TO_DATE('2025-11-28','YYYY-MM-DD'), 115);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3015, 2003, 151, TO_DATE('2025-12-01','YYYY-MM-DD'), TO_DATE('2025-12-19','YYYY-MM-DD'), 80);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3016, 2003, 153, TO_DATE('2025-12-01','YYYY-MM-DD'), TO_DATE('2025-12-19','YYYY-MM-DD'), 70);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3017, 2003, 132, TO_DATE('2025-12-08','YYYY-MM-DD'), TO_DATE('2025-12-19','YYYY-MM-DD'), 40);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3018, 2002, 141, TO_DATE('2026-01-05','YYYY-MM-DD'), TO_DATE('2026-01-30','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3019, 2002, 143, TO_DATE('2026-01-05','YYYY-MM-DD'), TO_DATE('2026-01-30','YYYY-MM-DD'), 125);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3020, 2004, 131, TO_DATE('2026-01-12','YYYY-MM-DD'), TO_DATE('2026-01-30','YYYY-MM-DD'), 100);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3021, 2004, 132, TO_DATE('2026-01-12','YYYY-MM-DD'), TO_DATE('2026-01-30','YYYY-MM-DD'), 95);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3022, 2002, 140, TO_DATE('2026-02-02','YYYY-MM-DD'), TO_DATE('2026-02-13','YYYY-MM-DD'), 30);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3023, 2002, 141, TO_DATE('2026-02-02','YYYY-MM-DD'), TO_DATE('2026-02-20','YYYY-MM-DD'), 90);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3024, 2004, 131, TO_DATE('2026-02-02','YYYY-MM-DD'), TO_DATE('2026-02-27','YYYY-MM-DD'), 130);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3025, 2004, 132, TO_DATE('2026-02-02','YYYY-MM-DD'), TO_DATE('2026-02-27','YYYY-MM-DD'), 125);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3026, 2005, 142, TO_DATE('2026-02-02','YYYY-MM-DD'), TO_DATE('2026-02-27','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3027, 2004, 133, TO_DATE('2026-02-09','YYYY-MM-DD'), TO_DATE('2026-02-27','YYYY-MM-DD'), 90);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3028, 2005, 145, TO_DATE('2026-02-09','YYYY-MM-DD'), TO_DATE('2026-02-27','YYYY-MM-DD'), 95);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3029, 2004, 132, TO_DATE('2026-03-02','YYYY-MM-DD'), TO_DATE('2026-03-20','YYYY-MM-DD'), 70);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3030, 2004, 133, TO_DATE('2026-03-02','YYYY-MM-DD'), TO_DATE('2026-03-20','YYYY-MM-DD'), 60);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3031, 2005, 142, TO_DATE('2026-03-02','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 130);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3032, 2005, 143, TO_DATE('2026-03-02','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3033, 2005, 145, TO_DATE('2026-03-02','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 125);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3034, 2006, 131, TO_DATE('2026-04-13','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 80);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3035, 2006, 133, TO_DATE('2026-04-13','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 85);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3036, 2006, 131, TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-29','YYYY-MM-DD'), 140);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3037, 2006, 133, TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-29','YYYY-MM-DD'), 135);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3038, 2007, 151, TO_DATE('2026-05-04','YYYY-MM-DD'), TO_DATE('2026-05-29','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3039, 2007, 153, TO_DATE('2026-05-04','YYYY-MM-DD'), TO_DATE('2026-05-29','YYYY-MM-DD'), 100);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3040, 2006, 132, TO_DATE('2026-05-11','YYYY-MM-DD'), TO_DATE('2026-05-29','YYYY-MM-DD'), 70);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3041, 2005, 142, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-30','YYYY-MM-DD'), 140);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3042, 2006, 131, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-12','YYYY-MM-DD'), 40);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3043, 2006, 133, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-19','YYYY-MM-DD'), 75);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3044, 2007, 151, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-30','YYYY-MM-DD'), 130);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3045, 2007, 153, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-30','YYYY-MM-DD'), 125);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3046, 2005, 145, TO_DATE('2026-06-08','YYYY-MM-DD'), TO_DATE('2026-06-30','YYYY-MM-DD'), 100);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3047, 2005, 142, TO_DATE('2026-07-01','YYYY-MM-DD'), TO_DATE('2026-07-31','YYYY-MM-DD'), 135);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3048, 2005, 145, TO_DATE('2026-07-01','YYYY-MM-DD'), TO_DATE('2026-07-31','YYYY-MM-DD'), 140);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3049, 2007, 151, TO_DATE('2026-07-01','YYYY-MM-DD'), TO_DATE('2026-07-31','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3050, 2007, 153, TO_DATE('2026-07-01','YYYY-MM-DD'), TO_DATE('2026-07-24','YYYY-MM-DD'), 90);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3051, 2008, 141, TO_DATE('2026-07-06','YYYY-MM-DD'), TO_DATE('2026-07-31','YYYY-MM-DD'), 95);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3052, 2005, 142, TO_DATE('2026-08-03','YYYY-MM-DD'), TO_DATE('2026-08-31','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3053, 2007, 151, TO_DATE('2026-08-03','YYYY-MM-DD'), TO_DATE('2026-08-21','YYYY-MM-DD'), 70);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3054, 2008, 141, TO_DATE('2026-08-03','YYYY-MM-DD'), TO_DATE('2026-08-31','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3055, 2009, 131, TO_DATE('2026-08-03','YYYY-MM-DD'), TO_DATE('2026-08-31','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3056, 2009, 132, TO_DATE('2026-08-03','YYYY-MM-DD'), TO_DATE('2026-08-31','YYYY-MM-DD'), 60);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3057, 2008, 140, TO_DATE('2026-08-10','YYYY-MM-DD'), TO_DATE('2026-08-28','YYYY-MM-DD'), 40);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3058, 2005, 145, TO_DATE('2026-09-01','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3059, 2008, 141, TO_DATE('2026-09-01','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 110);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3060, 2009, 131, TO_DATE('2026-09-01','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 120);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3061, 2008, 132, TO_DATE('2026-09-08','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 60);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3062, 2009, 134, TO_DATE('2026-09-14','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 45);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3063, 2010, 150, TO_DATE('2026-09-14','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 30);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3064, 2010, 151, TO_DATE('2026-09-14','YYYY-MM-DD'), TO_DATE('2026-09-30','YYYY-MM-DD'), 70);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3065, 2005, 142, TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 125);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3066, 2005, 145, TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 115);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3067, 2008, 141, TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 100);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3068, 2009, 131, TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 115);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3069, 2009, 134, TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 70);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3070, 2010, 151, TO_DATE('2026-10-01','YYYY-MM-DD'), TO_DATE('2026-10-16','YYYY-MM-DD'), 50);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3071, 2008, 132, TO_DATE('2026-10-05','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 45);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3072, 2008, 144, TO_DATE('2026-10-05','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 90);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3073, 2009, 132, TO_DATE('2026-10-05','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 50);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3074, 2011, 130, TO_DATE('2026-10-05','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 40);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3075, 2011, 134, TO_DATE('2026-10-12','YYYY-MM-DD'), TO_DATE('2026-10-30','YYYY-MM-DD'), 35);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3076, 2005, 142, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3077, 2005, 145, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3078, 2008, 141, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3079, 2008, 144, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3080, 2009, 131, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3081, 2009, 134, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3082, 2011, 130, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3083, 2011, 134, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3084, 2012, 140, TO_DATE('2026-11-02','YYYY-MM-DD'), NULL, NULL);
INSERT INTO ASSIGNMENT (Assign_Num, Proj_Number, Emp_Num, Date_Assigned, Date_Ended, Hours_Used)
VALUES (3085, 2012, 145, TO_DATE('2026-11-09','YYYY-MM-DD'), NULL, NULL);

COMMIT;