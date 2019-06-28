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

-- 自訂函數 case when
BEGIN
case
when x>y then 
select "Big";
when x<y THEN
select "small";
ELSE 
select "equal";
end case;
end

BEGIN
DECLARE result varchar(10) default '';
case XA
when 1 then set result = 'a';
when 10 then set result = 'b';
when 100 then set result = 'c';
end case;
return result;
end;


--while do迴圈
BEGIN
	declare i int default 1;
    declare j int default 66 ;
    while i<10 DO
        set i = i + 1;
    end while;
END

--REPEAT迴圈
BEGIN
	declare i , s int default 0;
	REPEAT
    set i = i+1;
    set s = s+i;
	until i >= x
    end REPEAT;
    return s;
END

-- 無窮迴圈
BEGIN
	declare i int default 0;
	yijie:LOOP
    	if i < 7 then
			select 'hello world';
         else
            leave yijie;
         end if;
         set i = i+1;
	end loop yijie;
    select i;
END


BEGIN
	declare i int default 0;
	yijie:loop
    	if i <7 THEN
        	select 'hello word';
        elseIF i>10 THEN
        	leave yijie;
        ELSE
        	select 'restart';
        	set i = 100;
        	ITERATE yijie;
         end IF;
         set i = i+1;
    end loop yijie;
    select i;
    end


    --錯誤訊息處理
    BEGIN

	declare exit HANDLER for SQLSTATE '23000'
        BEGIN
			SELECT 'OOOP!';
        END;
	INSERT INTO students (cid,cname,csex,cbirthday) values
	(id,name,sex,birthday);
    select 'OK';
END


--mysql 箭頭指向
BEGIN
	declare i int;
    declare vexit int default 0;
    declare id int default 0;
    declare name varchar(10) DEFAULT '';
    declare curs cursor FOR
    	select cid,cname from students;
    open curs;
    
    fetch curs into id,name;
    close curs;
    
    select concat(id,':',name);
END

--游標尋訪
BEGIN
    declare vexit int default 0;
    declare id int default 0;
    declare name varchar(10) DEFAULT '';
    declare curs cursor FOR
    	select cid,cname from students;
    declare CONTINUE HANDLER FOR NOT FOUND set vexit  =1;
    open curs;
    yijie:loop
        fetch curs into id,name;
        if vexit = 1 then 
            leave yijie;
        end if;
        select concat(id,':',name);
    END LOOP yijie;
    close curs;
END


--游標尋訪並更新
BEGIN
	declare flag int default 0;
    declare id,scoree int default 0;
    declare name varchar(10) default "";
    declare newstatus varchar(10) default "";
	declare curs cursor for 
    select cid,cname,score from students;
   	declare continue handler for not found set flag = 1;
    
    open curs;
    
    yijie: LOOP
    	FETCH curs into id,name,scoree;
        if flag = 1 THEN
        	leave yijie;
        end if;
        if scoree >=60 
        	then set newstatus = "及格";
        else
        	set newstatus  = '不及格';
        end if;
    	select concat(name,':',scoree);
    	UPDATE students set status = newstatus where cid = id;
    end loop yijie;
    close curs;


END