--業務銷售前3名
--未扣運費
select e.EmployeeID,concat(e.firstname," ",e.lastname) as employeename,sum(od.unitprice*od.quantity*(1-od.discount)) as fprice from orders as o 
left join employees as e on e.employeeid = o.employeeid 
left join `order details` as od on od.orderid = o.orderid 
where year(o.shippeddate)>=1997 
group by e.employeeid 
order by fprice desc ;

--扣除運費
select e.employeeid,concat(e.firstname," ",e.lastname)as name,sum(fp.fprice)as total 
from employees as e
left join (select o.orderid,o.employeeid,(sum(od.unitprice*od.quantity*(1-od.discount))-o.freight) as fprice from orders as o 
           left join `order details` as od on o.orderid = od.orderid where year(o.shippeddate)>=1997 group by orderid) as fp on fp.employeeid = e.employeeid 
           group by e.employeeid 
           order by total desc;

------------------------------------------------
--所有城市銷售狀況前3名
--未扣運費
select concat(e.firstname," ",e.lastname) as name,o.ShipCountry,o.shipcity,sum(od.UnitPrice*od.Quantity*(1-od.Discount))as total from orders as o 
left join `order details` as od on o.OrderID = od.OrderID 
left join employees as e on e.EmployeeID = o.EmployeeID 
group by shipcity 
order by total desc limit 3;

--join型 條件關聯欄位名稱一樣可以使用 useing  where 型則不行


--每個城市的顧客及員工


--where 型 條件關聯
select e.employeeid,e.firstname,e.lastname,o.orderid from employees as e ,
orders as o where e.employeeid = o.employeeid;



--自定義函數
-- 需用到  delimiter  修改結尾符號
--語法
delimiter ##
create function f1(x int , y int)
    -> returns int
    -> begin
    -> return x+y;
    -> end ##
delimiter ;

select f1(10,3);


--in 只管接收傳進來的參數
--out 只管內部返回的參數
--inout 以上2者兼具

delimiter ##
create procedure shownopass() --()內型態 in out inout
    -> begin
    -> select * from myscore where avg>70;
    -> select * from myscore where avg<70;
    -> end ##;

delimiter ;

call shownopass();


delimiter ##
create procedure p2(IN s int , OUT pass int,OUT down int)
    -> begin
    -> select count(*) into pass from students where score >= s;
    -> select count(*) into down from students where score < s;
    -> end ##

delimiter ;
call p2(60,@pass,@down);


--if 判斷
create procedure yijie02(in score int)
    -> begin
    -> IF score >=60 then
    -> SELECT 'PASS';
    -> END IF;
    -> end; ##

create procedure yijie04(in score int)
    -> begin
    -> if score >=90 then
    -> select 'A';
    -> elseif score >=80 then
    -> select 'B';
    -> elseif score >=70 then
    -> select 'C';
    -> elseif score >=60 then
    -> select 'C';
    -> else
    -> select 'D';
    -> else
    -> select 'E';
    -> end if;
    -> end; ##