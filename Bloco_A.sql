--Bloco A 

--1. Listar os 20 pedidos com status delivered mais recentes, ordenados pela data de entrega.
SELECT
    order_id as "ID do Pedido",
    customer_id as "ID do Cliente",
    order_delivered_customer_date as "Data de Entrega"
FROM olist_orders_dataset
WHERE order_status = 'delivered'
ORDER BY order_delivered_customer_date desc
limit 20;



--2. Listar todos os produtos de uma categoria específica (usando a tabela de tradução para filtrar pelo nome em português).

select 	
	prod.product_id as "ID do Produto",
	prod.product_category_name as "Categoria do Produto"
from olist_products_dataset prod
where prod.product_category_name = 'informatica_acessorios';



--3. Listar os métodos de pagamento distintos utilizados na base (SELECT distinct payment_type).

select distinct 
	pay.payment_type as "Tipos de Pagementos"
from olist_order_payments_dataset pay;



--4. Listar os produtos com peso (product_weight_g) acima de 10kg, ordenados do mais pesado para o mais leve.

select 
	opd.product_id as "ID do Produto",
	opd.product_category_name as "Categoria do Produto",
	opd.product_weight_g as "Peso do Produto (g)"
from olist_products_dataset opd
where opd.product_weight_g > 10000
order by product_weight_g desc;

