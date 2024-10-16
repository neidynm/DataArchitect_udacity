-- Return a list of employees with Job Titles and Department Names
SELECT 
    "e"."emp_id" AS "Employee ID", 
    "e"."emp_nm" AS "Employee Name",
    "e"."email" AS "E-mail",
    "e"."hire_dt" AS "Hire Date",
    "p"."job_title" AS "Job Title",
    "d"."department_nm" AS "Department Name"
FROM "Employment_history" AS "eh"
LEFT JOIN "Employee" AS "e" ON "e"."employee_id" = "eh"."employee_id"
LEFT JOIN "Position" AS "p" ON "p"."position_id" = "eh"."position_id"
LEFT JOIN "Department" AS "d" ON "d"."department_id" = "eh"."department_id";


--Insert Web Programmer as a new job title
INSERT INTO "Position" ("job_title") VALUES ('Web Programmer');
-- Checks to confirm that value is inserted.
SELECT * FROM "Position";


-- How many employees are in each department?
SELECT 
    COUNT("e"."emp_id") AS "Employee", 
    "d"."department_nm" AS "Department_Name"
FROM 
    "Employment_history" AS "eh"
    LEFT JOIN "Employee" AS "e" ON "eh"."employee_id" = "e"."employee_id"
    LEFT JOIN "Department" AS "d" ON "d"."department_id" = "eh"."department_id"
WHERE  "eh"."end_dt" > CURRENT_DATE --checks if employee is still in the company
GROUP BY  "d"."department_nm";

--Correct the job title from web programmer to web developer
UPDATE "Position"
SET "job_title" = 'Web Developer' 
WHERE "job_title" = 'Web Programmer';

-- Checks to confirm that value is updated
SELECT * FROM "Position";


-- Delete the job title Web Developer from the database
DELETE FROM "Position" WHERE "job_title" = 'Web Developer';

-- Checks to confirm that table was updated.
SELECT * FROM "Position";


-- Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.

SELECT 
    "e"."emp_nm" AS "Employee",
    "p"."job_title" AS "Title",
    "d"."department_nm" AS "Department",
    "m"."emp_nm" AS "Manager",
    "eh"."start_dt" AS "Start Date",
    "eh"."end_dt" AS "End Date"
FROM "Employment_history" AS "eh"
LEFT JOIN "Employee" AS "e" ON "e"."employee_id" = "eh"."employee_id"
LEFT JOIN "Employee" AS "m" ON "eh"."manager_id" = "m"."employee_id"
LEFT JOIN "Position" AS "p" ON "p"."position_id" = "eh"."position_id"
LEFT JOIN "Department" AS "d" ON "d"."department_id" = "eh"."department_id" 
WHERE "e"."emp_nm" = 'Toni Lembeck'
ORDER BY "eh"."start_dt" DESC;


---Create a view that returns all employee attributes; results should resemble initial Excel file
CREATE VIEW employe_view
AS
    (SELECT 
        "e"."emp_id" AS "Emp_ID",
        "e"."emp_nm" AS "Emp_NM",
        "e"."email" AS "Email",
        "e"."hire_dt" AS "hire_dt", 
        "p"."job_title" AS "Title",
        "s"."salary" AS "salary",
        "d"."department_nm" AS "Department",
        "m"."emp_nm" AS "Manager",
        "eh"."start_dt" AS "Start Date",
        "eh"."end_dt" AS "End Date",
        "l"."location_nm" AS "location",
        "l"."address" AS "address",
        "city"."city_nm" AS "city",
        "state"."state_nm" AS "state",
        "ed"."education_lvl" AS "education_lvl"
    FROM "Employment_history" AS "eh"
        LEFT JOIN "Employee" AS "e" ON "e"."employee_id" = "eh"."employee_id"
        LEFT JOIN "Employee" AS "m" ON "eh"."manager_id" = "m"."employee_id"
        LEFT JOIN "Position" AS "p" ON "p"."position_id" = "eh"."position_id"
        LEFT JOIN "Department" AS "d" ON "d"."department_id" = "eh"."department_id" 
        LEFT JOIN "Salary" AS "s" ON "s"."salary_id" = "eh"."salary_id"
        LEFT JOIN "Location" AS "l" ON "l"."location_id" = "eh"."location_id"
        LEFT JOIN "City" AS "city" ON "city"."city_id" = "l"."city_id"
        LEFT JOIN "State" AS "state" ON "state"."city_id" = "city"."city_id"
        LEFT JOIN "Education_lvl"  AS "ed" ON "ed"."education_lvl_id" = "eh"."education_lvl_id");
        


--Create a stored procedure with parameters that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) when given an employee name.

DROP FUNCTION get_employees_history(varchar(50));

CREATE OR REPLACE FUNCTION get_employees_history("employee_name" varchar(50))
RETURNS table(Employee varchar(50), 
              Title varchar(100), 
              Department  varchar(50),
              Manager varchar(50),
              StartDate date,
              EndDate date
             ) 
          language 'plpgsql' 
AS $$
BEGIN
  RETURN QUERY 
         SELECT 
            "e"."emp_nm" AS "Employee",
            "p"."job_title" AS "Title",
            "d"."department_nm" AS "Department",
            "m"."emp_nm" AS "Manager",
            "eh"."start_dt" AS "StartDate",
            "eh"."end_dt" AS "EndDate"
        FROM "Employment_history" AS "eh"
            LEFT JOIN "Employee" AS "e" ON "e"."employee_id" = "eh"."employee_id"
            LEFT JOIN "Employee" AS "m" ON "eh"."manager_id" = "m"."employee_id"
            LEFT JOIN "Position" AS "p" ON "p"."position_id" = "eh"."position_id"
            LEFT JOIN "Department" AS "d" ON "d"."department_id" = "eh"."department_id" 
        WHERE "e"."emp_nm" = employee_name
        ORDER BY "eh"."start_dt" DESC ;
END;
$$;

SELECT * FROM get_employees_history('Toni Lembeck');


--Create a non-management user named NoMgr. Show the code of how your would grant access to the database, but revoke access to the salary data.
create user NoMgr;
revoke SELECT on "Employment_history" from NoMgr ;
revoke SELECT on "Salary" from NoMgr ;

grant select ("employment_history_id" , "position_id", "location_id", "education_lvl_id","department_id", "manager_id" ,"start_dt", "end_dt" ,  "emp_id")  on "Employment_history" to NoMgr;


   