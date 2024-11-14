set serveroutput on;

create table patients(pid number primary key, pname varchar2(20) not null, address varchar2(20) not null);
create table details(pid number  , disease varchar2(20) not null, docname varchar2(20) not null, admdate date not null, discharged char(1) not null, amtpaid number not null, constraint fk_pid_details foreign key (pid) references patients(pid) );
create table history(pid number , pname varchar2(20) not null, address varchar2(20) not null, disease varchar2(20) not null, docname varchar2(20) not null, dishdate date not null, constraint fk_pid_history foreign key (pid) references patients(pid));


INSERT INTO patients (pid, pname, address) VALUES (1, 'John Doe', '123 Main St');
INSERT INTO patients (pid, pname, address) VALUES (2, 'Jane Smith', '456 Elm St');
INSERT INTO patients (pid, pname, address) VALUES (3, 'Robert Brown', '789 Oak St');
INSERT INTO patients (pid, pname, address) VALUES (4, 'Emily Davis', '101 Pine St');
INSERT INTO patients (pid, pname, address) VALUES (5, 'Michael Johnson', '202 Maple St');
INSERT INTO patients (pid, pname, address) VALUES (6, 'Alice Brown', '234 Birch Rd');
INSERT INTO patients (pid, pname, address) VALUES (7, 'Bob White', '345 Cedar Ln');
INSERT INTO patients (pid, pname, address) VALUES (8, 'Tom Green', '567 Pine Ave');

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (1, 'Cold', 'Dr. Adams', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Y', 100);

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (2, 'Flu', 'Dr. Adams', TO_DATE('2024-01-03', 'YYYY-MM-DD'), 'Y', 150);

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (4, 'Fever', 'Dr. Adams', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Y', 120);

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (3, 'Headache', 'Dr. Baker', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Y', 200);

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (6, 'Cold', 'Dr. Baker', TO_DATE('2024-02-04', 'YYYY-MM-DD'), 'Y', 250); 

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (7, 'Asthma', 'Dr. Clark', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Y', 180);

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (5, 'Diabetes', 'Dr. Clark', TO_DATE('2024-03-02', 'YYYY-MM-DD'), 'Y', 160);

INSERT INTO details (pid, disease, docname, admdate, discharged, amtpaid) 
VALUES (8, 'Cough', 'Dr. Davis', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'N', 130);


INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (1, 'John Doe', '123 Main St', 'Cold', 'Dr. Adams', TO_DATE('2024-01-01', 'YYYY-MM-DD'));

INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (2, 'Jane Smith', '456 Elm St', 'Flu', 'Dr. Adams', TO_DATE('2024-01-03', 'YYYY-MM-DD'));

INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (4, 'Emily Davis', '101 Pine St', 'Fever', 'Dr. Adams', TO_DATE('2024-01-10', 'YYYY-MM-DD'));

INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (3, 'Robert Brown', '789 Oak St', 'Headache', 'Dr. Baker', TO_DATE('2024-02-01', 'YYYY-MM-DD'));

INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (6, 'Alice Brown', '234 Birch Rd', 'Cold', 'Dr. Baker', TO_DATE('2024-02-04', 'YYYY-MM-DD')); 

INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (7, 'Bob White', '345 Cedar Ln', 'Asthma', 'Dr. Clark', TO_DATE('2024-03-01', 'YYYY-MM-DD'));

INSERT INTO history (pid, pname, address, disease, docname, dishdate) 
VALUES (5, 'Michael Johnson', '202 Maple St', 'Flu', 'Dr. Clark', TO_DATE('2024-03-02', 'YYYY-MM-DD'));


create or replace function amt(admn in date, dis in date)
return number
is 
retamt number;
begin
  retamt := dis - admn + 1;
  return retamt*1000;
end amt;
/

  


create or replace trigger ultratrigger
before update of discharged on details
referencing old as o new as n
for each row 
declare
exp1 exception;
v_date date;
v_name patients.pname%type;
v_addr patients.address%type;
paidamt number;
begin
  dbms_output.put_line('Enter the discharged date: ');
  v_date := to_date(&v_date,'YYYY-MM-DD');
  
  if (to_char(v_date,'dy') = 'sun') then
    raise exp1;
  
  else
    select pname,address into v_name,v_addr from patients where pid = :n.pid;
    insert into history values(:n.pid,v_name,v_addr,:n.disease,:n.docname,v_date);
    paidamt := amt(:n.admdate,v_date);
    dbms_output.put_line('Paid amount: '||paidamt);
    
    :n.amtpaid := paidamt;

  end if;
  
  
exception
  when exp1 then
    dbms_output.put_line('Sunday discharges not possible');
end;
/


update details set discharged = 'Y' where pid = 8;

select * from history where pid = 8;













select d.docname,qname.npatient,p.pname,p.address from (patients p inner join details d on p.pid = d.pid)
inner join 
(select d.docname,count(DISTINCT p.pid) as npatient from patients p inner join details d on p.pid = d.pid group by d.docname ) qname
on 
d.docname = qname.docname
order by d.docname,p.pname;



select h.disease, count(DISTINCT h.pid) as no_of_patients from patients p inner join history h on p.pid = h.pid group by h.disease order by h.disease;

/*
input: '2024-04-17'

Output:

Enter value for v_date: old  13:   v_date := to_date(&v_date,'YYYY-MM-DD');
new  13:   v_date := to_date('2024-04-17','YYYY-MM-DD');
Enter the discharged date:
Paid amount: 17000

       PID PNAME		ADDRESS 	     DISEASE
---------- -------------------- -------------------- --------------------
DOCNAME 	     DISHDATE
-------------------- ---------
	 8 Tom Green		567 Pine Ave	     Cough
Dr. Davis	     17-APR-24


DOCNAME 	       NPATIENT PNAME		     ADDRESS
-------------------- ---------- -------------------- --------------------
Dr. Adams		      3 Emily Davis	     101 Pine St
Dr. Adams		      3 Jane Smith	     456 Elm St
Dr. Adams		      3 John Doe	     123 Main St
Dr. Baker		      2 Alice Brown	     234 Birch Rd
Dr. Baker		      2 Robert Brown	     789 Oak St
Dr. Clark		      2 Bob White	     345 Cedar Ln
Dr. Clark		      2 Michael Johnson      202 Maple St
Dr. Davis		      1 Tom Green	     567 Pine Ave

DISEASE 	     NO_OF_PATIENTS
-------------------- --------------
Asthma				  1
Cold				  2
Cough				  1
Fever				  1
Flu				  2
Headache			  1

*/


