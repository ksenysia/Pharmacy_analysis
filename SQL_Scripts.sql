

--Ефективність працівників: кількість продажів, виручка та години
select employee.id_employee, count(sale.id_sale), sum(receipt_item.quantity* p.price) as revenue,sum(ws.hours_worked) as sum_hours
from employee
join sale on employee.id_employee=sale.id_employee
    join receipt_item on sale.id_receipt=receipt_item.id_receipt
join pharmacy.product p on receipt_item.id_product = p.id_product
join pharmacy.work_schedule ws on employee.id_employee = ws.id_employee
group by employee.id_employee
order by 3 desc
--товар ціна якого більше 200грн
select product.id_product, product.name,price
from product
where price > 200
-- кількість продажів по місяцю
select count(sale.id_sale),date_trunc('month',date_time) as month
from sale
group by 2
--середня ціна за категорію
select product.category, avg(product.price)
from product
group by 1
--найдорожчий товар
select id_product, max(price),name
from product
group by 1
order by 2 desc
limit 1
-- покупець в якого кількість покупок більше 3
select customer.id_customer,  count(id_sale)
from customer
join sale on customer.id_customer = sale.id_customer
group by 1
having count(id_sale)>3
--Працівники, старші за середній вік
select *
from employee
where age> (
    select avg(age)
    from employee
    )


--Остання дата покупки кожного клієнта
select customer.id_customer, max(s.date_time)
from customer
 join pharmacy.sale s on customer.id_customer = s.id_customer
group by  1

--Топ-працівник за місячними продажами
WITH employee_sales AS (
    SELECT
        e.id_employee,
        e.last_name,
        e.first_name,
        DATE_TRUNC('month', s.date_time) AS month,
        SUM(ri.quantity * p.price) AS total_sales
    FROM pharmacy.employee e
    JOIN pharmacy.sale s ON e.id_employee = s.id_employee
    JOIN pharmacy.receipt_item ri ON s.id_receipt = ri.id_receipt
    JOIN pharmacy.product p ON ri.id_product = p.id_product
    GROUP BY e.id_employee, e.last_name, e.first_name, DATE_TRUNC('month', s.date_time)
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_sales DESC) AS rn
    FROM employee_sales
)
SELECT *
FROM ranked
WHERE rn = 1;
--Другий найуспішніший працівник за продажами в місті
with vutorg as (select employee.id_employee, p.city,SUM(ri.quantity * pr.price) AS total_sales
from employee
join pharmacy.sale s on employee.id_employee = s.id_employee
join pharmacy.pharmacy p on p.id_pharmacy = s.id_pharmacy
join pharmacy.receipt_item ri on s.id_receipt = ri.id_receipt
join pharmacy.product pr on ri.id_product = pr.id_product
group by 1,2),
ranked as(
select *, row_number() over (partition by city order by total_sales desc) as rn2
from vutorg
)
select *
from ranked
where rn2=2
--товари які купуються найчастіше за кількістю чеків
select p.id_product,count( distinct ri.id_receipt) as count_receipts
from receipt_item ri
join product p on ri.id_product= p.id_product
group by 1
order by 2 desc

--найприбутковіші категорії
select product.category,sum(ri.quantity*product.price) as total_sale
from product
join pharmacy.receipt_item ri on product.id_product = ri.id_product
group by 1
order by 2 desc
-- топ категорія в кожному місяці
with tra as (select p.category, date_trunc('month',s.date_time) as month,sum(ri.quantity*p.price) as total_sale
from sale s
    join pharmacy.receipt r on s.id_receipt = r.id_receipt
    join pharmacy.receipt_item ri on r.id_receipt = s.id_receipt
    join pharmacy.product p on p.id_product = ri.id_product

group  by 1, 2
order by 3 desc),

 ran as (select *, row_number() over (partition by month order by total_sale desc) as rn
from tra)
select *
from ran
where rn=1
order by month

-- середній чек по містах
select avg(sale.id_receipt), p.city
from sale
join pharmacy.receipt r on r.id_receipt = sale.id_receipt
join pharmacy.pharmacy p on p.id_pharmacy = sale.id_pharmacy
group by 2
--працівники, які зробили більше ніж 10 продажів
select employee.id_employee, count(s.id_sale)
from employee
join pharmacy.sale s on employee.id_employee = s.id_employee
group by 1
having count(s.id_sale)>10



-- топ аптека по кількості продажів
select pharmacy.id_pharmacy,count(distinct(s.id_sale))
from pharmacy
join pharmacy.sale s on pharmacy.id_pharmacy = s.id_pharmacy
group by 1
order by 2 desc
limit 1

--топ аптека по виторгу
select p.id_pharmacy, sum(ri.quantity*p2.price) as revenue
from sale
join pharmacy.receipt r on sale.id_receipt = r.id_receipt
join pharmacy.receipt_item ri on r.id_receipt = ri.id_receipt
join pharmacy.pharmacy p on p.id_pharmacy = sale.id_pharmacy
join pharmacy.sale s on r.id_receipt = s.id_receipt
join pharmacy.product p2 on p2.id_product = ri.id_product
group by 1
order by 2 desc
--10 найбільших продажів по чеках та аптеках
select receipt.id_receipt, sum (quantity *price) as revenue,p2.id_pharmacy, p2.name
from receipt
join pharmacy.receipt_item ri on receipt.id_receipt = ri.id_receipt
join pharmacy.product p on p.id_product = ri.id_product
join pharmacy.sale s on receipt.id_receipt = s.id_receipt
join pharmacy.pharmacy p2 on s.id_pharmacy = p2.id_pharmacy
group by 1,3,4
order by 2 desc
limit 10;
--Аналіз клієнтів за обсягом та середнім чеком
select customer.id_customer,count(s.id_sale),sum(receipt_item.quantity* p.price) as sum_receipt,sum(receipt_item.quantity* p.price)/ count(s.id_sale) as avg_receipt
from customer
 join pharmacy.sale s on customer.id_customer = s.id_customer
join receipt_item on s.id_receipt=receipt_item.id_receipt
join pharmacy.product p on receipt_item.id_product = p.id_product
group by 1
order by 3 desc
limit 20