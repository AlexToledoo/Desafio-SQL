--Bloco B

--1. Relatório com categoria do produto (traduzida), valor do item, cidade do vendedor.

select
    coalesce(transl.product_category_name_english, prod.product_category_name) AS "Categoria",
    item.price as "Valor do Item",
    sell.seller_city as "Cidade do Vendendor",
    sell.seller_state as "Estado"
FROM olist_order_items_dataset  item
JOIN olist_products_dataset prod ON prod.product_id = item.product_id
JOIN olist_sellers_dataset sell ON sell.seller_id = item.seller_id
left join product_category_name_translation transl on transl.product_category_name = prod.product_category_name 
LIMIT 100;


--2. Identificar pedidos com atraso na entrega, comparando data estimada com data real de entrega (join entre orders e customers).

select 
	ord.order_id as "ID do Pedido",
	cust.customer_city "Cidade do Cliente",
	cust.customer_state as "Estado",
	ord.order_estimated_delivery_date as "Estimativa de Entrega",
	ord.order_delivered_customer_date as "Entregue ao Cliente em",
	(coalesce(
			nullif(ord.order_delivered_customer_date, '')::date,
			current_date
		) 
		- nullif(ord.order_estimated_delivery_date,'')::date
	) as "Dias de Atraso"
from olist_orders_dataset ord
join olist_customers_dataset cust on cust.customer_id = ord.customer_id 
where ord.order_status = 'delivered'
	and coalesce(
			nullif(ord.order_delivered_customer_date, '')::date,
			current_date
		) > nullif(ord.order_estimated_delivery_date,'')::date
order by "Dias de Atraso" desc
limit 50;



--3. Listar pedidos e suas formas de pagamento, incluindo pedidos pagos em mais de uma parcela (join entre orders e order_payments).

select 
	ord.order_id as "ID do Pedido",
	ord.order_status as "Status do Pedido",
	ord.order_purchase_timestamp as "Data do Pedido",
	pay.payment_type as "Tipo do Pagamento",
	pay.payment_installments  as "Parcelas",
	pay.payment_value as " Valor do Pedidos"
from olist_orders_dataset ord
join olist_order_payments_dataset pay on ord.order_id = pay.order_id
order by ord.order_purchase_timestamp desc
limit 100;




--4. Listar produtos junto com a categoria traduzida, incluindo produtos cuja categoria não possui tradução cadastrada (LEFT JOIN com product_category_name_translation).

select 
	prod.product_id as "ID do Produto",
	prod.product_category_name as "Categoria",
	transl.product_category_name_english as "tradução"
from olist_products_dataset prod
left join product_category_name_translation transl on prod.product_category_name = transl.product_category_name ;



--5. Identificar pedidos em que o cliente e o vendedor são do mesmo estado.

select 
	ord.order_id as "ID do Pedido",
	cust.customer_city as "Cidade do Cliente",
	cust.customer_state as "Estado do Cliente",
	sell.seller_city as "Cidade do Vendedor",
	sell.seller_state "Estado do Vendedor" 
from olist_orders_dataset ord
join olist_customers_dataset cust on ord.customer_id = cust.customer_id 
join olist_order_items_dataset item on item.order_id = ord.order_id
join olist_sellers_dataset sell on item.seller_id = sell.seller_id 
where cust.customer_state = sell.seller_state;
