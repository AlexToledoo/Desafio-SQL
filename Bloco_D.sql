--Bloco D 


--1. Clientes cujo gasto total está acima da média geral de gasto por cliente.

select 
	cust.customer_unique_id as "ID do Cliente",
	cust.customer_city as "Cidade",
	cust.customer_state as "Estado",
	sum(item.price + item.freight_value) as "Faturamento Total"
from olist_customers_dataset cust
join olist_orders_dataset ord on ord.customer_id = cust.customer_id 
join olist_order_items_dataset item on item.order_id = ord.order_id 
group by cust.customer_unique_id, cust.customer_city, cust.customer_state 
having sum(item.price + item.freight_value ) >= (
	select avg("Gasto Total do CLiente")
	from(
		select
			cust.customer_unique_id,
			sum(item.price + item.freight_value) as "Gasto Total do CLiente"
		from olist_customers_dataset cust
		join olist_orders_dataset ord on cust.customer_id  = ord.customer_id  
		join olist_order_items_dataset item on item.order_id = ord.order_id 
		group by cust.customer_unique_id  
	)
)
order by "Faturamento Total"



--2. Produtos que nunca receberam avaliação (NOT EXISTS / NOT IN).

select 
	prod.product_id as "ID do Produto",
	prod.product_category_name as " Categoria do Produto"
from olist_products_dataset prod
where prod.product_id not in(
	select
		item.product_id 
	from olist_order_items_dataset item 
	join olist_order_reviews_dataset reviw on reviw.order_id = item.order_id 
	where item.product_id = prod.product_id 
	)
order by prod.product_category_name;



--3. Vendedores que venderam produtos de mais de 5 categorias diferentes (subquery com COUNT(DISTINCT ...)).

select
    ord.seller_id as "ID do Vendedor",
    COUNT(DISTINCT prod.product_category_name) as "Quantidade de Categorias",
    sell.seller_city as "Cidade do Vendedor",
    sell.seller_state as "Estado"
from olist_order_items_dataset ord
join olist_products_dataset prod on ord.product_id = prod.product_id
join olist_sellers_dataset sell on sell.seller_id = ord.seller_id 
group by ord.seller_id, sell.seller_city, sell.seller_state
having count(DISTINCT prod.product_category_name) > 5
order by "Quantidade de Categorias" desc;

--4. Pedidos cujo valor de frete (freight_value) é maior que o valor total dos itens do próprio pedido (subquery correlacionada comparando as duas somas).

select
    ord.order_id as "ID do Pedido",
    SUM(ord.freight_value) as "Frete Total",
    SUM(ord.price) as "Valor dos Pordutos"
from olist_order_items_dataset ord
group by ord.order_id
HAVING SUM(ord.freight_value) > (
    select SUM(ord2.price)
    from olist_order_items_dataset ord2
    where ord2.order_id = ord.order_id
)
order by "Frete Total";
