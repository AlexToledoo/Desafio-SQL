--Bloco E


--1. Classificar pedidos por prazo de entrega: "adiantado", "no prazo" ou "atrasado"(comparando data real x estimada).

select
    order_id as "ID do Pedido",
    order_estimated_delivery_date as "Data Estimada",
    order_delivered_customer_date as "Data de entrega",
    CASE
        WHEN order_delivered_customer_date < order_estimated_delivery_date THEN 'Adiantado'
        WHEN order_delivered_customer_date = order_estimated_delivery_date THEN 'No Prazo'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Atrasado'
        ELSE 'Não Entregue'
    END as "Classificação"
from olist_orders_dataset
order by "Data de entrega" desc;


--2. Classificar clientes por faixa de gasto total: "bronze", "prata", "ouro".

select 
	cust.customer_unique_id as "ID do Cliente",
	SUM(item.price + item.freight_value) as "Gasto Total",
	CASE
		when SUM(item.price + item.freight_value) <= 2000 then 'Bronze'
		when SUM(item.price + item.freight_value) <= 10000 then 'Prata'
		else 'Ouro'
	end as "Categoria do Cliente"
from olist_orders_dataset ord
join olist_customers_dataset cust on cust.customer_id = ord.customer_id
join olist_order_items_dataset item on item.order_id = ord.order_id
where ord.order_status = 'delivered'
group by cust.customer_unique_id 
order by"Gasto Total";

--3. Classificar produtos por faixa de peso: "leve", "médio", "pesado" (com base em product_weight_g).

select
    product_id as "ID do Produto",
    product_weight_g as "Peso do Produto (G)",
    CASE
        WHEN product_weight_g <= 1000 THEN 'Leve'
        WHEN product_weight_g <= 5000 THEN 'Médio'
        ELSE 'Pesado'
    END as "Faixa de Peso"
from olist_products_dataset
order by "Peso do Produto (G)";



--4. Classificar pagamentos como "à vista" ou "parcelado", e dentro de parcelado sinalizar parcelamentos longos (payment_installments > 6).

select
    order_id as "ID do Pedido",
    payment_type as "Tipo de Pagamento",
    payment_installments as "Parcelas",
    CASE
        WHEN payment_installments <= 1 THEN 'à vista'
        ELSE 'parcelado'
    END as "Modalidade",
    CASE
        WHEN payment_installments > 6 THEN 'parcelamento longo'
        ELSE 'parcelamento normal'
    END as "Classificação de Pagamento"
from olist_order_payments_dataset
order by "Parcelas" desc;

