/* 
 * Commands used to create a simple trigger between 2 tables: Employees and Employee_Audit
 * Usage: 
 *   sudo su postgres
 *   psql
 *   \i example-triggers.sql
 */

/* Remove all the tables in 'public'  schema */
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

/* Remove all existing tables */
DROP TABLE IF EXISTS COMPANY;
DROP TABLE IF EXISTS AUDIT;

/* Create table 'COMPANY' */
CREATE TABLE COMPANY (
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);

/* Create table 'AUDIT' */
CREATE TABLE AUDIT (
   EMP_ID INT NOT NULL,
   ENTRY_DATE TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION auditlogfunc() RETURNS TRIGGER AS $example_table$
   BEGIN
      INSERT INTO AUDIT(EMP_ID, ENTRY_DATE) VALUES (new.ID, current_timestamp);
      RETURN NEW;
   END;
$example_table$ LANGUAGE plpgsql;



/* Create trigger 'employee_insert_trigger' */
CREATE TRIGGER example_trigger AFTER INSERT ON COMPANY
FOR EACH ROW EXECUTE PROCEDURE auditlogfunc();



INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'Paul', 32, 'California', 20000.00 );

SELECT * FROM COMPANY;

SELECT * FROM AUDIT;
