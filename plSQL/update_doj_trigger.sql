set serveroutput on;

CREATE TABLE EMPLOYEE (EMPID NUMBER(10) PRIMARY KEY,NAME VARCHAR2(30),DOJ DATE);


INSERT INTO EMPLOYEE  VALUES (1, 'John Doe', TO_DATE('2023-01-15', 'YYYY-MM-DD'));

INSERT INTO EMPLOYEE  VALUES (2, 'Jane Smith', TO_DATE('2022-05-10', 'YYYY-MM-DD'));

select * from EMPLOYEE;

create or replace trigger ultratrigger
before update on EMPLOYEE
referencing new as n old as o
for each row
begin
  :n.doj := sysdate;
end;
/

update EMPLOYEE set name = 'James Charles' where empid = 1;


select * from EMPLOYEE;

/*

     EMPID NAME 			  DOJ
---------- ------------------------------ ---------
	 1 John Doe			  15-JAN-23
	 2 Jane Smith			  10-MAY-22

     EMPID NAME 			  DOJ
---------- ------------------------------ ---------
	 1 James Charles		  13-NOV-24
	 2 Jane Smith			  10-MAY-22

*/
