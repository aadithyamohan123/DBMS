set serveroutput on;

CREATE TABLE employee_leaves (
    employee_id NUMBER PRIMARY KEY,
    leave_balance NUMBER DEFAULT 30, 
    leaves_taken NUMBER DEFAULT 0  
);

INSERT INTO employee_leaves (employee_id, leave_balance, leaves_taken)
VALUES (101, 30, 0);

INSERT INTO employee_leaves (employee_id, leave_balance, leaves_taken)
VALUES (102, 25, 5);

INSERT INTO employee_leaves (employee_id, leave_balance, leaves_taken)
VALUES (103, 20, 10);

INSERT INTO employee_leaves (employee_id, leave_balance, leaves_taken)
VALUES (104, 15, 15);

INSERT INTO employee_leaves (employee_id, leave_balance, leaves_taken)
VALUES (105, 10, 20);

COMMIT;

create or replace package LeaveManagemen
as
  procedure grantleave(empid in NUMBER, leavedays in NUMBER);
  function remleave(empid in number) return number;
end LeaveManagemen;
/

create or replace package body LeaveManagemen
as

  exrl exception;
  
  procedure grantleave(empid in number,leavedays in number)
  is
  v_leave employee_leaves.leave_balance%type;
  begin
    
    select leave_balance into v_leave from employee_leaves where employee_id = empid;
    
    if v_leave < leavedays then
      raise exrl;
    end if;
    
    update employee_leaves set leave_balance = leave_balance - leavedays , leaves_taken = leaves_taken + leavedays where employee_id = empid;
    
    dbms_output.put_line('Leave granted');
    
  exception
    when exrl then
      dbms_output.put_line('Insufficient remaining leaves for employee id: '||empid);
    when others then
      dbms_output.put_line('Error:'||sqlerrm);
  end grantleave;
  
  
  function remleave(empid in number)
  return number
  is
  v_leave employee_leaves.leave_balance%type;
  begin
    select leave_balance into v_leave from employee_leaves where employee_id = empid;
      
    return v_leave;
  exception
    when others then
      dbms_output.put_line('Error: '||sqlerrm);
      return -1;
  end remleave;

end LeaveManagemen;
/

select * from employee_leaves;


declare
  remaining_leaves number;
begin
  LeaveManagemen.grantleave(101,10);
  LeaveManagemen.grantleave(104,20);
  remaining_leaves := LeaveManagemen.remleave(101);
  dbms_output.put_line('Remaining leaves: '||remaining_leaves);
end;
/|

/*

EMPLOYEE_ID LEAVE_BALANCE LEAVES_TAKEN
----------- ------------- ------------
	101	       30	     0
	102	       25	     5
	103	       20	    10
	104	       15	    15
	105	       10	    20
Leave granted
Insufficient remaining leaves for employee id: 104
Remaining leaves: 20

*/
