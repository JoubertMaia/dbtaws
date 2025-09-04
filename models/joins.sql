 With Prod as (
Select 
ct.category_name, sp.company_name, pd.product_name,
pd.unit_price, pd.product_id
FROM {{source('sources','products')}} pd
left join {{source ('sources', 'suppliers')}} sp on (pd.supplier_id = sp.supplier_id)
left join {{source ('sources', 'categories')}} ct on (pd.category_id = ct.category_id)
), orddeai as (
    select pd.*, od.order_id, od.quantity, od.discount
    from {{ ref('orderdetails')}} od
    LEFT JOIN prod pd on (od.product_id = pd.product_id)

), ordrs as (
    SELECT ord.order_date, ord.order_id, cs.company_name customer, em.name employee, em.age, em.lenghtofservice
   FROM  {{source ('sources', 'orders')}} ord 
   left join {{ref ('customers')}} cs on (ord.customer_id = cs.customer_id)
   left join {{ref ('employees')}} em on (ord.employee_id = em.employee_id)
   left join {{source ('sources', 'shippers')}} sh on  (ord.ship_via = sh.shipper_id)

),  finaljoin as (
    Select od.*, ord.order_date, ord.customer, ord.employee, ord.age, ord.lenghtofservice
    from orddeai as od
    inner join ordrs ord on (od.order_id = ord.order_id)

) 

select * from finaljoin

