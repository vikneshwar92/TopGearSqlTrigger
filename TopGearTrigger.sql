--Create the Employee_Test table
CREATE TABLE Employee_Test (Emp_ID INT Identity, Emp_name Varchar(100), Emp_Sal Decimal (10,2))

--Create the Employee_Test_Audit table
CREATE TABLE Employee_Test_Audit (Emp_ID int, Emp_name varchar(100), Emp_Sal decimal (10,2),
Audit_Action varchar(100), Audit_Timestamp datetime)

--Insert statements for Employee_Test table
INSERT INTO Employee_Test VALUES ('Anees',1000);
INSERT INTO Employee_Test VALUES ('Rick',1200); 
INSERT INTO Employee_Test VALUES ('John',1100);
INSERT INTO Employee_Test VALUES ('Stephen',1300);
INSERT INTO Employee_Test VALUES ('Maria',1400);

select * from Employee_Test
select * from Employee_Test_Audit

--Define following types of Triggers on Employee_Test table.
--Use Employee_Test_Audit table to insert records on Trigger action

--1. After Insert Trigger This trigger is fired after an INSERT on the table. 

Create trigger Insert_Emp_Test on Employee_Test
After Insert 
As
Begin
Declare @Emp_ID int,@Emp_name Varchar(100),@Emp_Sal Decimal(10,2)
select @Emp_ID = inserted.Emp_ID ,@Emp_name = inserted.Emp_name,@Emp_Sal = inserted.Emp_Sal from inserted
insert into Employee_Test_Audit values (@Emp_ID,@Emp_name,@Emp_Sal,'Inserted',GETDATE())
End

--2. AFTER UPDATE Trigger This trigger is fired after an update on the table.

Create trigger Update_Emp_Test on Employee_Test
After Update
As
Begin
Declare @Emp_ID int,@Emp_name Varchar(100),@Emp_Sal Decimal(10,2),@Action varchar(50)
select @Emp_ID = inserted.Emp_ID ,@Emp_name = inserted.Emp_name,@Emp_Sal = inserted.Emp_Sal from inserted
if UPDATE(Emp_ID)
begin
set @Action = 'EmpId updated'
end
if UPDATE(Emp_name)
begin
set @Action = 'EmpName Updated'
end
if UPDATE(Emp_Sal)
begin
set @Action = 'EmpSal updated'
end
insert into Employee_Test_Audit values (@Emp_ID,@Emp_name,@Emp_Sal,@Action,GETDATE())
end

update Employee_Test set Emp_sal = 5000 where Emp_name = 'Anees'
update Employee_Test set Emp_name = 'Sania' where Emp_ID = 5

--3. AFTER DELETE Trigger This trigger is fired after a delete on the table.
Create trigger Delete_Emp_Test on Employee_Test
After delete
As
Begin
Declare @Emp_ID int,@Emp_name varchar(100),@Emp_Sal decimal(10,2)
select @Emp_ID = deleted.Emp_ID,@Emp_name = deleted.Emp_name,@Emp_Sal = deleted.Emp_Sal from deleted
insert into Employee_Test_Audit values (@Emp_ID,@Emp_name,@Emp_Sal,'Deleted',GETDATE())
End

select * from Employee_Test_Audit

delete from Employee_Test where Emp_ID = 4

--4. Instead Of Triggers 
--	a. INSTEAD OF INSERT Trigger. 

Create trigger Instead_Insert_Emp_Test on Employee_Test
Instead of insert
As
Begin
Declare @Emp_ID int,@Emp_name Varchar(100),@Emp_Sal Decimal(10,2),@Action varchar(50)
select @Emp_ID = inserted.Emp_ID ,@Emp_name = inserted.Emp_name,@Emp_Sal = inserted.Emp_Sal from inserted
IF(@Emp_name = 'Maria')
Begin
RaisError('Employee Name with Maria cannot be inserted',16,1)
rollback
insert into Employee_Test_Audit Values (@Emp_ID,@Emp_name,@Emp_Sal,'cannot be inserted',GETDATE())
end
ElSE
begin
insert into Employee_Test values (@Emp_name,@Emp_Sal)
insert into Employee_Test_Audit Values (@Emp_ID,@Emp_name,@Emp_Sal,'Instead of Inserted',GETDATE())
end
End

Select * from Employee_Test
Select * from Employee_Test_Audit
INSERT INTO Employee_Test VALUES ('Joseph',2200);
INSERT INTO Employee_Test VALUES ('Maria',1400);

--	b. INSTEAD OF UPDATE Trigger.
Create trigger Instead_Update_Emp_Test on Employee_Test
Instead of update
AS
Begin
Declare @Emp_ID int,@Emp_name varchar(100),@Emp_Sal decimal(10,2)
select @Emp_ID = inserted.Emp_ID ,@Emp_name = inserted.Emp_name,@Emp_Sal = inserted.Emp_Sal from inserted
if(@Emp_Sal > 9500)
Begin
RaisError('Salary Cannot be more than 9500',16,1)
rollback 
insert into Employee_Test_Audit Values (@Emp_ID,@Emp_name,@Emp_Sal,'Cannot be updated',GETDATE())
End
ElSE
begin
update Employee_Test set Emp_Sal=@Emp_Sal where Emp_ID=@Emp_ID or Emp_name=@Emp_name
insert into Employee_Test_Audit Values (@Emp_ID,@Emp_name,@Emp_Sal,'Instead of Update',GETDATE())
end
End

Select * from Employee_Test
Select * from Employee_Test_Audit

update Employee_Test set Emp_sal=9200 where Emp_ID=5

--	c. INSTEAD OF DELETE Trigger.
Create trigger Instead_Delete_Emp_Test on Employee_Test
Instead of Delete
AS
Begin
Declare @Emp_ID int,@Emp_name varchar(100),@Emp_Sal decimal(10,2)
select @Emp_ID = deleted.Emp_ID ,@Emp_name = deleted.Emp_name,@Emp_Sal = deleted.Emp_Sal from deleted
if(@Emp_name='Joseph')
Begin
RaisError('Employee with name Joseph cannot be deleted',16,1)
rollback 
insert into Employee_Test_Audit Values (@Emp_ID,@Emp_name,@Emp_Sal,'Cannot be Deleted',GETDATE())
End
ElSE
begin
Delete from Employee_Test where Emp_ID=@Emp_ID or Emp_name=@Emp_name
insert into Employee_Test_Audit Values (@Emp_ID,@Emp_name,@Emp_Sal,'Instead of Delete',GETDATE())
end
End

select * from Employee_Test
Select * from Employee_Test_Audit

delete from Employee_Test where Emp_name='Joseph'
delete from Employee_Test where Emp_ID=6

delete from Employee_Test Where Emp_name='John'