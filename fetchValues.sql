set serveroutput on;

CREATE TABLE EMPLOYEES (
    EMP_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50),
    DEPARTMENT VARCHAR2(50),
    SALARY NUMBER
);

INSERT INTO EMPLOYEES VALUES (1, 'John Doe', 'HR', 5000);
INSERT INTO EMPLOYEES VALUES (2, 'Jane Smith', 'Finance', 6000);
INSERT INTO EMPLOYEES VALUES (3, 'Sam Brown', 'IT', 7000);
COMMIT;


create or replace procedure fetchvalues (tbl in varchar2 , condt in varchar2)
is
  sqlquery varchar2(1000);
  type record_type is table of varchar2(4000);
  result record_type;
begin
  sqlquery := 'select EMP_ID || chr(9) || NAME || chr(9) || DEPARTMENT || chr(9) || SALARY as result_string' || ' from '||tbl || ' where '|| condt;
  
  dbms_output.put_line('Executing query: '||sqlquery);
  
  execute immediate sqlquery bulk collect into result;
  
  for i in result.first .. result.last loop
    dbms_output.put_line(result(i));
  end loop;
  
exception
  when others then
    dbms_output.put_line('Error has occured:' || sqlerrm);
end fetchvalues;
/


begin
  fetchvalues('EMPLOYEES','SALARY > (select avg(SALARY) from EMPLOYEES)');
end;
/

/* Output 

Executing query: select EMP_ID || chr(9) || NAME || chr(9) || DEPARTMENT || chr(9) || SALARY as result_string from EMPLOYEES where SALARY > (select avg(SALARY) from EMPLOYEES)
3	Sam Brown	IT	7000

*/
