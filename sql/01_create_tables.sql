-- Homer Consulting | Part II.A.1 | Script #1
-- Recreates the seven tables with named, enabled constraints.
-- Constraint names follow tablename_columnname_type (PK, FK, CK, NN, UK).
DROP TABLE ASSIGNMENT CASCADE CONSTRAINTS;
DROP TABLE TRAINING CASCADE CONSTRAINTS;
DROP TABLE PROJECT CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE CLIENT CASCADE CONSTRAINTS;
DROP TABLE SKILL CASCADE CONSTRAINTS;

-- 1. Skill catalog
CREATE TABLE SKILL (
    Code       VARCHAR2(20)  CONSTRAINT Skill_Code_PK PRIMARY KEY,
    Name       VARCHAR2(100) CONSTRAINT Skill_Name_NN NOT NULL,
    Category   VARCHAR2(50)  CONSTRAINT Skill_Category_NN NOT NULL
);

-- 2. Clients, including prospective clients with no projects
CREATE TABLE CLIENT (
    Client_ID       NUMBER(6)     CONSTRAINT Client_Client_ID_PK PRIMARY KEY,
    Name            VARCHAR2(100) CONSTRAINT Client_Name_NN NOT NULL,
    Street          VARCHAR2(120),
    City            VARCHAR2(80),
    State           VARCHAR2(30),
    Zip_Code        VARCHAR2(12),
    Industry        VARCHAR2(80),
    Web_Address     VARCHAR2(255),
    Phone           VARCHAR2(25),
    Contact_LName   VARCHAR2(60),
    Contact_Fname   VARCHAR2(60)
);

-- 3. Department: Manager_ID FK is added only at end of script.
-- Manager_ID is nullable during initial loading to break the
-- circular insert dependency (fill it with UPDATE after employees).
CREATE TABLE DEPARTMENT (
    Dept_Code     VARCHAR2(10)  CONSTRAINT Department_Dept_Code_PK PRIMARY KEY,
    Name          VARCHAR2(100) CONSTRAINT Department_Name_NN NOT NULL,
    Location      VARCHAR2(100),
    Phone         VARCHAR2(25),
    Manager_ID    NUMBER(6)
);

-- 4. Employees (an employee may have no supervisor, e.g., CEO)
CREATE TABLE EMPLOYEE (
    Emp_Num       NUMBER(6)     CONSTRAINT Employee_Emp_Num_PK PRIMARY KEY,
    LName         VARCHAR2(60)  CONSTRAINT Employee_LName_NN NOT NULL,
    FName         VARCHAR2(60)  CONSTRAINT Employee_FName_NN NOT NULL,
    Title         VARCHAR2(100),
    DOB           DATE          CONSTRAINT Employee_DOB_NN NOT NULL,
    Hire_Date     DATE DEFAULT SYSDATE
                                CONSTRAINT Employee_Hire_Date_NN NOT NULL,
    Super_ID      NUMBER(6),
    Dept_Code     VARCHAR2(10)  CONSTRAINT Employee_Dept_Code_NN NOT NULL,
    CONSTRAINT Employee_Super_ID_FK FOREIGN KEY (Super_ID)
        REFERENCES EMPLOYEE (Emp_Num),
    CONSTRAINT Employee_Dept_Code_FK FOREIGN KEY (Dept_Code)
        REFERENCES DEPARTMENT (Dept_Code),
    -- Required (c): employee must be at least 17 at hiring time.
    CONSTRAINT Employee_DOB_Hire_Date_CK CHECK (
        Hire_Date >= ADD_MONTHS(DOB, 204)
    )
);

-- 5. Projects; a NULL Total_Cost denotes an ongoing project.
CREATE TABLE PROJECT (
    Proj_Number   NUMBER(6)      CONSTRAINT Project_Proj_Number_PK PRIMARY KEY,
    Title         VARCHAR2(120)  CONSTRAINT Project_Title_NN NOT NULL,
    Start_Date    DATE DEFAULT SYSDATE
                                CONSTRAINT Project_Start_Date_NN NOT NULL,
    Total_Cost    NUMBER(12,2),
    Dept_Code     VARCHAR2(10)   CONSTRAINT Project_Dept_Code_NN NOT NULL,
    Client_ID     NUMBER(6)      CONSTRAINT Project_Client_ID_NN NOT NULL,
    Code          VARCHAR2(20)   CONSTRAINT Project_Code_NN NOT NULL,
    CONSTRAINT Project_Dept_Code_FK FOREIGN KEY (Dept_Code)
        REFERENCES DEPARTMENT (Dept_Code),
    CONSTRAINT Project_Client_ID_FK FOREIGN KEY (Client_ID)
        REFERENCES CLIENT (Client_ID),
    CONSTRAINT Project_Code_FK FOREIGN KEY (Code)
        REFERENCES SKILL (Code),
    -- Additional CHECK #1: project costs cannot be negative.
    CONSTRAINT Project_Total_Cost_CK CHECK (Total_Cost >= 0)
);

-- 6. Training history; repeated training for a skill is allowed.
CREATE TABLE TRAINING (
    Train_Num       NUMBER(8)     CONSTRAINT Training_Train_Num_PK PRIMARY KEY,
    Code            VARCHAR2(20)  CONSTRAINT Training_Code_NN NOT NULL,
    Emp_Num         NUMBER(6)     CONSTRAINT Training_Emp_Num_NN NOT NULL,
    Name            VARCHAR2(100) CONSTRAINT Training_Name_NN NOT NULL,
    Date_Acquired   DATE          CONSTRAINT Training_Date_Acquired_NN NOT NULL,
    Comments        VARCHAR2(500),
    CONSTRAINT Training_Code_FK FOREIGN KEY (Code)
        REFERENCES SKILL (Code),
    CONSTRAINT Training_Emp_Num_FK FOREIGN KEY (Emp_Num)
        REFERENCES EMPLOYEE (Emp_Num)
);

-- 7. Monthly project assignments; an employee can work on
-- the same project in multiple months (new Assign_Num each time).
CREATE TABLE ASSIGNMENT (
    Assign_Num      NUMBER(8)     CONSTRAINT Assignment_Assign_Num_PK PRIMARY KEY,
    Proj_Number     NUMBER(6)     CONSTRAINT Assignment_Proj_Number_NN NOT NULL,
    Emp_Num         NUMBER(6)     CONSTRAINT Assignment_Emp_Num_NN NOT NULL,
    Date_Assigned   DATE DEFAULT SYSDATE
                                CONSTRAINT Assignment_Date_Assigned_NN NOT NULL,
    Date_Ended      DATE,
    Hours_Used      NUMBER(8,2),
    CONSTRAINT Assignment_Proj_Number_FK FOREIGN KEY (Proj_Number)
        REFERENCES PROJECT (Proj_Number),
    CONSTRAINT Assignment_Emp_Num_FK FOREIGN KEY (Emp_Num)
        REFERENCES EMPLOYEE (Emp_Num),
    -- Required (b): Date_Ended must be within the same month as Date_Assigned.
    CONSTRAINT Assignment_Date_Ended_CK CHECK (
        Date_Ended IS NULL OR
        (Date_Ended >= Date_Assigned AND
         TRUNC(Date_Ended, 'MM') = TRUNC(Date_Assigned, 'MM'))
    ),
    -- Additional CHECK #2: hours used cannot be negative.
    CONSTRAINT Assignment_Hours_Used_CK CHECK (Hours_Used >= 0),
    -- Additional CHECK #3: Date_Ended and Hours_Used are both NULL
    -- (current month) or both filled in (month completed).
    CONSTRAINT Assignment_Ended_Hours_CK CHECK (
        (Date_Ended IS NULL AND Hours_Used IS NULL) OR
        (Date_Ended IS NOT NULL AND Hours_Used IS NOT NULL)
    )
);

ALTER TABLE DEPARTMENT
    ADD CONSTRAINT Department_Manager_ID_FK
    FOREIGN KEY (Manager_ID)
    REFERENCES EMPLOYEE (Emp_Num);