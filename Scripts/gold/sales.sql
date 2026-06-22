-- use DataWarehouse

CREATE VIEW gold.fact_sales as
SELECT
    sd.sls_ord_num    as order_number ,
    pr.product_key,
    cu.customer_key     ,
    sd.sls_order_dt    as order_date,
    sd.sls_ship_dt     as shipping_date,
    sd.sls_due_dt      as due_date,
    sd.sls_sales       as sales_amount,
    sd.sls_quantity     as quality,
    sd.sls_price 
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr
on sd.sls_prd_key = pr.prd_key
LEFT JOIN gold.dim_customers cu 
ON sd.sls_cust_id =cu.customer_id