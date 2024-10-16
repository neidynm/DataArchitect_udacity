-- Section that allows the database to reset 
DROP TABLE IF EXISTS "Employment_history" CASCADE;
DROP TABLE IF EXISTS "Salary" CASCADE;
DROP TABLE IF EXISTS "Employee" CASCADE;
DROP TABLE IF EXISTS "Department" CASCADE;
DROP TABLE IF EXISTS "Education_lvl" CASCADE;
DROP TABLE IF EXISTS  "Location" CASCADE;
DROP TABLE IF EXISTS  "State" CASCADE;
DROP TABLE IF EXISTS "Position" CASCADE;
DROP TABLE IF EXISTS  "City" CASCADE;

-- BEGIN script to create tables
CREATE TABLE "Position" (
  "position_id" SERIAL PRIMARY KEY,
  "job_title" varchar(100)
);

CREATE TABLE "Salary" (
  "salary_id" SERIAL PRIMARY KEY,
  "salary" int
);

CREATE TABLE "Department" (
  "department_id"  SERIAL PRIMARY KEY,
  "department_nm" varchar(50)
);

CREATE TABLE "Employee" (
  "employee_id" SERIAL PRIMARY KEY,
  "emp_id" varchar(8),
  "emp_nm" varchar(50),
  "email" varchar(100),
  "hire_dt" date
);

CREATE TABLE "Education_lvl" (
  "education_lvl_id" SERIAL PRIMARY KEY,
  "education_lvl" varchar(50)
);

CREATE TABLE "Location" (
  "location_id" SERIAL PRIMARY KEY,
  "city_id" int,
  "address" varchar(100),
  "location_nm" varchar(50)
);

CREATE TABLE "City" (
  "city_id" SERIAL PRIMARY KEY,
  "city_nm" varchar(50)
);

CREATE TABLE "State" (
  "state_id" SERIAL PRIMARY KEY,
  "state_nm" varchar(2),
  "city_id" int,
  CONSTRAINT "FK_State.city_id"
    FOREIGN KEY ("city_id")
      REFERENCES "City"("city_id")
);

CREATE TABLE "Employment_history" (
  "employment_history_id" SERIAL PRIMARY KEY,
  "position_id" int,
  "salary_id" int,
  "location_id" int,
  "education_lvl_id" int,
  "department_id" int,
  "manager_id" int,
  "start_dt" date,
  "end_dt" date,
  "employee_id" int
);

ALTER TABLE "Employment_history" add CONSTRAINT "FK_Employment_history.location_id"
    FOREIGN KEY ("location_id")
      REFERENCES "Location"("location_id");

ALTER TABLE "Employment_history"  add  CONSTRAINT "FK_Employment_history.department_id"
    FOREIGN KEY ("department_id")
      REFERENCES "Department"("department_id");

ALTER TABLE "Employment_history"add CONSTRAINT "FK_Employment_history.employee_id"
    FOREIGN KEY ("employee_id")
      REFERENCES "Employee"("employee_id");
      
 ALTER TABLE "Employment_history" add  CONSTRAINT "FK_Employment_history.position_id"
    FOREIGN KEY ("position_id")
      REFERENCES "Position"("position_id");

 ALTER TABLE "Employment_history" add CONSTRAINT "FK_Employment_history.salary_id"
    FOREIGN KEY ("salary_id")
      REFERENCES "Salary"("salary_id");
      
 ALTER TABLE "Employment_history" add  CONSTRAINT "FK_Employment_history.manager_id"
    FOREIGN KEY ("manager_id")
      REFERENCES "Employee"("employee_id");
--- END script to create the initial tables and respective Foreign and Primary keys

-- BEGIN: loading information to the tables
INSERT INTO "Position" ("job_title")
SELECT DISTINCT "job_title" FROM "proj_stg";

INSERT INTO "Salary" ("salary") 
SELECT  DISTINCT "salary" FROM "proj_stg";

INSERT INTO "Department" ("department_nm")
SELECT DISTINCT "department_nm" FROM "proj_stg";

INSERT INTO "Employee" ("emp_id", "emp_nm", "email", "hire_dt")
SELECT DISTINCT "emp_id", "emp_nm", "email", "hire_dt"  FROM "proj_stg";

INSERT INTO "Education_lvl" ("education_lvl")
SELECT DISTINCT "education_lvl" FROM "proj_stg";

INSERT INTO "City" ("city_nm")
SELECT DISTINCT "city" FROM "proj_stg";

INSERT INTO "Location" ("city_id", "address", "location_nm")
SELECT DISTINCT "c"."city_id",  "ps"."address", "ps"."location"
FROM "proj_stg" AS "ps" LEFT JOIN "City" AS "c" ON "c"."city_nm" = "ps"."city";

INSERT INTO "State" ("state_nm","city_id")
SELECT DISTINCT  "ps"."state", "c"."city_id"
FROM "proj_stg" AS "ps" LEFT JOIN "City" AS "c" ON "c"."city_nm" = "ps"."city";

INSERT INTO "Employment_history" ("position_id", "salary_id", "location_id", 
                                  "education_lvl_id", "department_id", "manager_id", 
                                  "start_dt", "end_dt", "employee_id")
SELECT DISTINCT  "p"."position_id","s"."salary_id",  "l"."location_id",
                "el"."education_lvl_id", "d"."department_id","manager"."employee_id",
                "ps"."start_dt","ps"."end_dt", "empl"."employee_id"
FROM "proj_stg" AS "ps" 
LEFT JOIN "Position" AS "p" ON "p"."job_title" = "ps"."job_title"
LEFT JOIN "Salary" AS "s" ON "s"."salary" = "ps"."salary"
LEFT JOIN "Location" AS "l" ON "l"."address" = "ps"."address" AND "l"."location_nm" = "ps"."location"
LEFT JOIN "Education_lvl" AS "el" ON "el"."education_lvl" = "ps"."education_lvl"
LEFT JOIN "Department" AS "d" ON "d"."department_nm" = "ps"."department_nm"
LEFT JOIN "Employee" AS "manager" ON "manager"."emp_nm" = "ps"."manager"
LEFT JOIN "Employee" AS "empl" ON "empl"."emp_id" = "ps"."emp_id";

--END Loading the initial information to the tables.