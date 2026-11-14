-- Homer Consulting | Part II.A.1 | Script #1
-- Recreates the seven tables with named, enabled constraints.
DROP TABLE ASSIGNMENT CASCADE CONSTRAINTS;
DROP TABLE TRAINING CASCADE CONSTRAINTS;
DROP TABLE PROJECT CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE CLIENT CASCADE CONSTRAINTS;
DROP TABLE SKILL CASCADE CONSTRAINTS;

-- 1. Skill catalog
CREATE TABLE SKILL (
    Code       VARCHAR2(20)  CONSTRAINT pk_skill PRIMARY KEY,
    Name       VARCHAR2(100) CONSTRAINT nn_skill_name NOT NULL,
    Category   VARCHAR2(50)  CONSTRAINT nn_skill_category NOT NULL
);

-- 2. Clients, including prospective clients with no projects
CREATE TABLE CLIENT (
    Client_ID       NUMBER(6)     CONSTRAINT pk_client PRIMARY KEY,
    Name            VARCHAR2(100) CONSTRAINT nn_client_name NOT NULL,
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
    Dept_Code     VARCHAR2(10)  CONSTRAINT pk_department PRIMARY KEY,
    Name          VARCHAR2(100) CONSTRAINT nn_dept_name NOT NULL,
    Location      VARCHAR2(100),
    Phone         VARCHAR2(25),
    Manager_ID    NUMBER(6)
);

-- 4. Employees (an employee may have no supervisor, e.g., CEO)
CREATE TABLE EMPLOYEE (
    Emp_Num       NUMBER(6)     CONSTRAINT pk_employee PRIMARY KEY,
    LName         VARCHAR2(60)  CONSTRAINT nn_emp_lname NOT NULL,
    FName         VARCHAR2(60)  CONSTRAINT nn_emp_fname NOT NULL,
    Title         VARCHAR2(100),
    DOB           DATE          CONSTRAINT nn_emp_dob NOT NULL,
    Hire_Date     DATE DEFAULT SYSDATE
                                CONSTRAINT nn_emp_hire_date NOT NULL,
    Super_ID      NUMBER(6),
    Dept_Code     VARCHAR2(10)  CONSTRAINT nn_emp_dept NOT NULL,
    CONSTRAINT fk_emp_supervisor FOREIGN KEY (Super_ID)
        REFERENCES EMPLOYEE (Emp_Num),
    CONSTRAINT fk_emp_department FOREIGN KEY (Dept_Code)
        REFERENCES DEPARTMENT (Dept_Code),
    -- Required: employee must be at least 17 at hiring time.
    CONSTRAINT ck_emp_min_age CHECK (
        Hire_Date >= ADD_MONTHS(DOB, 204)
    )
);

-- 5. Projects; a NULL Total_Cost denotes an ongoing project.
CREATE TABLE PROJECT (
    Proj_Number   NUMBER(6)      CONSTRAINT pk_project PRIMARY KEY,
    Title         VARCHAR2(120)  CONSTRAINT nn_proj_title NOT NULL,
    Start_Date    DATE DEFAULT SYSDATE
                                CONSTRAINT nn_proj_start_date NOT NULL,
    Total_Cost    NUMBER(12,2),
    Dept_Code     VARCHAR2(10)   CONSTRAINT nn_proj_dept NOT NULL,
    Client_ID     NUMBER(6)      CONSTRAINT nn_proj_client NOT NULL,
    Code          VARCHAR2(20)   CONSTRAINT nn_proj_skill NOT NULL,
    CONSTRAINT fk_proj_department FOREIGN KEY (Dept_Code)
        REFERENCES DEPARTMENT (Dept_Code),
    CONSTRAINT fk_proj_client FOREIGN KEY (Client_ID)
        REFERENCES CLIENT (Client_ID),
    CONSTRAINT fk_proj_skill FOREIGN KEY (Code)
        REFERENCES SKILL (Code),
    -- Additional CHECK #1: project costs cannot be negative.
    CONSTRAINT ck_proj_nonneg_cost CHECK (Total_Cost >= 0)
);

-- 6. Training history; repeated training for a skill is allowed.
CREATE TABLE TRAINING (
    Train_Num       NUMBER(8)     CONSTRAINT pk_training PRIMARY KEY,
    Code            VARCHAR2(20)  CONSTRAINT nn_train_skill NOT NULL,
    Emp_Num         NUMBER(6)     CONSTRAINT nn_train_emp NOT NULL,
    Name            VARCHAR2(100) CONSTRAINT nn_train_name NOT NULL,
    Date_Acquired   DATE          CONSTRAINT nn_train_date NOT NULL,
    Comments        VARCHAR2(500),
    CONSTRAINT fk_train_skill FOREIGN KEY (Code)
        REFERENCES SKILL (Code),
    CONSTRAINT fk_train_employee FOREIGN KEY (Emp_Num)
        REFERENCES EMPLOYEE (Emp_Num)
);

-- 7. Monthly project assignments; an employee can work on
-- the same project in multiple months (new Assign_Num each time).
CREATE TABLE ASSIGNMENT (
    Assign_Num      NUMBER(8)     CONSTRAINT pk_assignment PRIMARY KEY,
    Proj_Number     NUMBER(6)     CONSTRAINT nn_asg_project NOT NULL,
    Emp_Num         NUMBER(6)     CONSTRAINT nn_asg_employee NOT NULL,
    Date_Assigned   DATE DEFAULT SYSDATE
                                CONSTRAINT nn_asg_date_assigned NOT NULL,
    Date_Ended      DATE,
    Hours_Used      NUMBER(8,2),
    CONSTRAINT fk_asg_project FOREIGN KEY (Proj_Number)
        REFERENCES PROJECT (Proj_Number),
    CONSTRAINT fk_asg_employee FOREIGN KEY (Emp_Num)
        REFERENCES EMPLOYEE (Emp_Num),
    CONSTRAINT ck_asg_same_month CHECK (
        Date_Ended IS NULL OR
        (Date_Ended >= Date_Assigned AND
         TRUNC(Date_Ended, 'MM') = TRUNC(Date_Assigned, 'MM'))
    ),
    CONSTRAINT ck_asg_nonneg_hours CHECK (Hours_Used >= 0),
    CONSTRAINT ck_asg_complete_pair CHECK (
        (Date_Ended IS NULL AND Hours_Used IS NULL) OR
        (Date_Ended IS NOT NULL AND Hours_Used IS NOT NULL)
    )
);

ALTER TABLE DEPARTMENT
    ADD CONSTRAINT fk_dept_manager
    FOREIGN KEY (Manager_ID)
    REFERENCES EMPLOYEE (Emp_Num);
