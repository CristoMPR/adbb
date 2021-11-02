/* 
 * Commands used to create a simple trigger between 2 tables: Employees and Employee_Audit
 * Usage: 
 *   sudo su postgres
 *   psql
 *   \i example-triggers.sql
 */

/* Remove all existing tables */
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Employee_Audit;



CREATE TABLE "Employees" (
  "EmployeeId" INT NOT NULL,
  "LastName" VARCHAR(20) NOT NULL,
  "FirstName" VARCHAR(20) NOT NULL,
  "Title" VARCHAR(30),
  "ReportsTo" INT,
  "BirthDate" TIMESTAMP,
  "HireDate" TIMESTAMP,
  "Address" VARCHAR(70),
  "City" VARCHAR(40),
  "State" VARCHAR(40),
  "Country" VARCHAR(40),
  "PostalCode" VARCHAR(10),
  "Phone" VARCHAR(24),
  "Fax" VARCHAR(24),
  "Email" VARCHAR(60),
  CONSTRAINT "PK_Employees" PRIMARY KEY  ("EmployeeId")
);



CREATE TABLE "Employee_Audit" (
  "EmployeeId" INT NOT NULL,
  "LastName" VARCHAR(20) NOT NULL,
  "FirstName" VARCHAR(20) NOT NULL,
  "UserName" VARCHAR(20) NOT NULL,
  "EmpAdditionTime" VARCHAR(20) NOT NULL
);



CREATE OR REPLACE FUNCTION employee_insert_trigger_fnc()
  RETURNS trigger AS
$$
BEGIN
  INSERT INTO "Employee_Audit" ( "EmployeeId", "LastName", "FirstName","UserName" ,"EmpAdditionTime")
    VALUES(NEW."EmployeeId",NEW."LastName",NEW."FirstName",current_user,current_date);
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';



CREATE TRIGGER employee_insert_trigger
  AFTER INSERT
  ON "Employees"
  FOR EACH ROW
  EXECUTE PROCEDURE employee_insert_trigger_fnc();



INSERT INTO "Employees" VALUES(10,' Expósito','Izquierdo','Manager',1,'1962-02-18 00:00:00','2010-08-14 00:00:00','11120 Jasper Ave NW','Edmonton','AB','Spain','T5K 2N1','+1 780 428-9482','+1 780 428-3457','cexposit@ull.edu.es');



SELECT * FROM "Employees" WHERE "EmployeeId" = 10;



SELECT * FROM "Employee_Audit";

