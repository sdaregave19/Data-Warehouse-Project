-- use DataWarehouse

CREATE VIEW gold.dim_product as
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
    pn.prd_id  ,
    pn.cat_id ,
    pn.prd_key ,
    pn.prd_nm ,
    pn.prd_cost ,
    pn.prd_line ,
    pn.prd_start_dt ,
    pn.prd_end_dt,
    px.cat,
    px.subcat,
    px.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 px
ON pn.cat_id=px.id
WHERE prd_end_dt is null    --filter out all historical data


  