-- Homer Consulting | Part II.A.3
-- Lists the complete content of every table, formatted for printing.
-- Run after 01_create_tables.sql and 02_insert_data.sql.

SET LINESIZE 150
SET PAGESIZE 100
SET NULL '---'

-- 1. SKILL
COLUMN Code     FORMAT A6  HEADING 'Code'
COLUMN Name     FORMAT A32 HEADING 'Skill Name'
COLUMN Category FORMAT A12 HEADING 'Category'

SELECT Code, Name, Category
FROM   SKILL
ORDER  BY Category, Code;

CLEAR COLUMNS

-- 2. DEPARTMENT
COLUMN Dept_Code  FORMAT A5   HEADING 'Dept|Code'
COLUMN Name       FORMAT A22  HEADING 'Department Name'
COLUMN Location   FORMAT A26  HEADING 'Location'
COLUMN Phone      FORMAT A12  HEADING 'Phone'
COLUMN Manager_ID FORMAT 9999 HEADING 'Mgr|ID'

SELECT Dept_Code, Name, Location, Phone, Manager_ID
FROM   DEPARTMENT
ORDER  BY Dept_Code;

CLEAR COLUMNS

-- 3. EMPLOYEE
COLUMN Emp_Num   FORMAT 9999 HEADING 'Emp|Num'
COLUMN LName     FORMAT A10  HEADING 'Last Name'
COLUMN FName     FORMAT A10  HEADING 'First Name'
COLUMN Title     FORMAT A26  HEADING 'Title'
COLUMN DOB       FORMAT A10  HEADING 'Date of|Birth'
COLUMN Hire_Date FORMAT A10  HEADING 'Hire Date'
COLUMN Super_ID  FORMAT 9999 HEADING 'Super|ID'
COLUMN Dept_Code FORMAT A5   HEADING 'Dept|Code'

SELECT Emp_Num, LName, FName, Title,
       TO_CHAR(DOB, 'MM/DD/YYYY')       AS DOB,
       TO_CHAR(Hire_Date, 'MM/DD/YYYY') AS Hire_Date,
       Super_ID, Dept_Code
FROM   EMPLOYEE
ORDER  BY Emp_Num;

CLEAR COLUMNS

-- 4. CLIENT
COLUMN Client_ID   FORMAT 9999 HEADING 'Client|ID'
COLUMN Name        FORMAT A30  HEADING 'Client Name'
COLUMN Address     FORMAT A28  HEADING 'Address' WORD_WRAPPED
COLUMN Industry    FORMAT A18  HEADING 'Industry'
COLUMN Web_Address FORMAT A33  HEADING 'Web Address'
COLUMN Phone       FORMAT A12  HEADING 'Phone'
COLUMN Contact     FORMAT A16  HEADING 'Contact'

SELECT Client_ID, Name,
       Street || ', ' || City || ', ' || State || ' ' || Zip_Code AS Address,
       Industry, Web_Address, Phone,
       Contact_FName || ' ' || Contact_LName AS Contact
FROM   CLIENT
ORDER  BY Client_ID;

CLEAR COLUMNS

-- 5. PROJECT  (Total_Cost '---' = ongoing project)
COLUMN Proj_Number FORMAT 9999 HEADING 'Proj|Num'
COLUMN Title       FORMAT A28  HEADING 'Project Title'
COLUMN Start_Date  FORMAT A10  HEADING 'Start Date'
COLUMN Total_Cost  FORMAT A12  HEADING 'Total Cost' JUSTIFY RIGHT
COLUMN Dept_Code   FORMAT A5   HEADING 'Dept|Code'
COLUMN Client_ID   FORMAT 9999 HEADING 'Client|ID'
COLUMN Code        FORMAT A5   HEADING 'Skill|Code'

SELECT Proj_Number, Title,
       TO_CHAR(Start_Date, 'MM/DD/YYYY')  AS Start_Date,
       TO_CHAR(Total_Cost, '$999,999.99') AS Total_Cost,
       Dept_Code, Client_ID, Code
FROM   PROJECT
ORDER  BY Proj_Number;

CLEAR COLUMNS

-- 6. TRAINING
COLUMN Train_Num     FORMAT 9999 HEADING 'Train|Num'
COLUMN Code          FORMAT A5   HEADING 'Skill|Code'
COLUMN Emp_Num       FORMAT 9999 HEADING 'Emp|Num'
COLUMN Name          FORMAT A35  HEADING 'Training Name'
COLUMN Date_Acquired FORMAT A10  HEADING 'Date|Acquired'
COLUMN Comments      FORMAT A35  HEADING 'Comments' WORD_WRAPPED

SELECT Train_Num, Code, Emp_Num, Name,
       TO_CHAR(Date_Acquired, 'MM/DD/YYYY') AS Date_Acquired,
       Comments
FROM   TRAINING
ORDER  BY Train_Num;

CLEAR COLUMNS

-- 7. ASSIGNMENT  ('---' = assignment in the current month)
COLUMN Assign_Num    FORMAT 9999   HEADING 'Assign|Num'
COLUMN Proj_Number   FORMAT 9999   HEADING 'Proj|Num'
COLUMN Emp_Num       FORMAT 9999   HEADING 'Emp|Num'
COLUMN Date_Assigned FORMAT A10    HEADING 'Date|Assigned'
COLUMN Date_Ended    FORMAT A10    HEADING 'Date|Ended'
COLUMN Hours_Used    FORMAT 990.99 HEADING 'Hours|Used'

SELECT Assign_Num, Proj_Number, Emp_Num,
       TO_CHAR(Date_Assigned, 'MM/DD/YYYY') AS Date_Assigned,
       TO_CHAR(Date_Ended, 'MM/DD/YYYY')    AS Date_Ended,
       Hours_Used
FROM   ASSIGNMENT
ORDER  BY Assign_Num;

CLEAR COLUMNS