業務銷售前3名  1101025
select e.EmployeeID,concat(e.firstname," ",e.lastname) as employeename,sum(od.unitprice*od.quantity*(1-od.discount)) as total from orders as o 
left join employees as e on e.employeeid = o.employeeid 
left join `order details` as od on od.orderid = o.orderid 
where year(o.shippeddate)>=1997 
group by e.employeeid 
order by total desc ;