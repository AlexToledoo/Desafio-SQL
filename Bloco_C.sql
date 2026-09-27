--Bloco C

-- C.1 — Faturamento total por estado do cliente.

select 
	cust.customer_state as "Estado",
	SUM(item.price + item.freight_value) as "Faturamento Total"
from olist_orders_dataset ord
join olist_customers_dataset cust on cust.customer_id = ord.customer_id 
join olist_order_items_dataset item on item.order_id = ord.order_id 
where ord.order_status = 'delivered'
group by cust.customer_state
order by "Faturamento Total"  desc;


--2. Top 10 vendedores por faturamento.

select 
	sell.seller_id as "ID do Vendedor",
	sell.seller_city  as "Cidade do Vendedor",
	sell.seller_state as " Etsado do Vendedor",
	SUM(item.price) "Faturamento"
from olist_order_items_dataset item
join olist_sellers_dataset sell on item.seller_id = sell.seller_id 
group by sell.seller_id, sell.seller_city, sell.seller_state 
order by "Faturamento" desc
limit 10;


--3. Ticket médio por categoria de produto.
select 
	prod.product_category_name as "Categoria",
	avg(item.price) as "Ticket Médio"
from olist_products_dataset prod
join olist_order_items_dataset item on item.product_id = prod.product_id 
group by prod.product_category_name;


--4. Vendedores com nota média de avaliação abaixo de 3 (HAVING AVG(...) < 3).
 select
 	sell.seller_id as "ID do Vendedor",
 	sell.seller_city as "Cidade",
 	sell.seller_state as "Estado",
 	round(avg(reviw.review_score), 2) as "Nota Média",
 	count(reviw.review_id)
 from olist_order_items_dataset item
 join olist_order_reviews_dataset reviw on reviw.order_id = item.order_id 
 join olist_sellers_dataset sell on sell.seller_id = item.seller_id 
 group by sell.seller_id, sell.seller_city, sell.seller_state 
 having 
 	avg(reviw.review_score) < 3
 	and 
 	count(reviw.review_id) >= 10
 order by "Nota Média"


--5. Quantidade de pedidos por forma de pagamento (GROUP BY payment_type).

select 
	pay.payment_type as "Tipos de Pagamento",
	count(pay.payment_type  ) as "Quantidade"
from olist_orders_dataset ord
join olist_order_payments_dataset pay on pay.order_id = ord.order_id 
group by pay.payment_type
order by "Quantidade" asc;


--6. Peso médio dos produtos por categoria.

select 	
	prod.product_category_name as "Categoria dos Produtos",
	ROUND(AVG(prod.product_weight_g),2) as "Peso Médio(g)"
from olist_products_dataset prod 
group by prod.product_category_name
order by "Peso Médio(g)";


--7. Número médio de parcelas (AVG(payment_installments)) por categoria de produto.

select 
	prod.product_category_name as "Categoria dos Produtos",
	AVG(pay.payment_installments ) as "Quantidade de Parcelas"
from olist_order_payments_dataset pay
join olist_order_items_dataset ord on ord.order_id  = pay.order_id 
join olist_products_dataset prod on ord.product_id = prod.product_id 
group by payment_installments, prod.product_category_name
order by "Quantidade de Parcelas";


