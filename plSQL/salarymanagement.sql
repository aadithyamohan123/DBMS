set serveroutput on;

create table employee(empid number primary key, empname varchar2(25) not null, dept varchar2(25) not null , salary number not null);

INSERT INTO employee (empid, empname, dept, salary) 
VALUES (1, 'John Doe', 'HR', 50000);

INSERT INTO employee (empid, empname, dept, salary) 
VALUES (2, 'Jane Smith', 'Finance', 60000);

INSERT INTO employee (empid, empname, dept, salary) 
VALUES (3, 'Alice Johnson', 'IT', 75000);

INSERT INTO employee (empid, empname, dept, salary) 
VALUES (4, 'Bob Brown', 'Marketing', 55000);

INSERT INTO employee (empid, empname, dept, salary) 
VALUES (5, 'Charlie White', 'Sales', 65000);

INSERT INTO employee (empid, empname, dept, salary) 
VALUES (6, 'Charlie Black', 'IT', 25000);

select * from employee;

create or replace package SalaryManagement
as
  procedure updatesalary(emplid in number, tsalary in number);
  function totsalary(tdept in varchar2) return number;
end SalaryManagement;
/

create or replace package body SalaryManagement
as
  procedure updatesalary(emplid in number, tsalary in number)
  is 
  begin
    update employee set salary = tsalary where empid = emplid;
    
    dbms_output.put_line('The employee salary has been updated');
  
  exception
    when others then
      dbms_output.put_line('Error: '||sqlerrm);
  end updatesalary;
  
  
  function totsalary(tdept in varchar2)
  return number
  is
  v_sal employee.salary%type;
  totsal number;
  begin
    
    select sum(salary) into v_sal from employee where dept = tdept;
    
    totsal := v_sal;
    return totsal;
  
  exception
    when others then
      dbms_output.put_line('Error: '||sqlerrm);
      return null;
  
  end totsalary;

end SalaryManagement;
/

declare 
  totalsal number;
begin
  SalaryManagement.updatesalary(3,90000);
  totalsal := SalaryManagement.totsalary('IT');
  dbms_output.put_line(totalsal);
end;
/

select * from employee;

/*

     EMPID EMPNAME		     DEPT			   SALARY
---------- ------------------------- ------------------------- ----------
	 1 John Doe		     HR 			    50000
	 2 Jane Smith		     Finance			    60000
	 3 Alice Johnson	     IT 			    75000
	 4 Bob Brown		     Marketing			    55000
	 5 Charlie White	     Sales			    65000
	 6 Charlie Black	     IT 			    25000
The employee salary has been updated
115000

     EMPID EMPNAME		     DEPT			   SALARY
---------- ------------------------- ------------------------- ----------
	 1 John Doe		     HR 			    50000
	 2 Jane Smith		     Finance			    60000
	 3 Alice Johnson	     IT 			    90000
	 4 Bob Brown		     Marketing			    55000
	 5 Charlie White	     Sales			    65000
	 6 Charlie Black	     IT 			    25000

*/
