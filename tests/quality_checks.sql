--1) Quality Check
--check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
--------------------------------------------------------------------
select 
cst_id,count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is NULL 

--2) Check for unwanted spaces in string values 
select cst_firstname from bronze.crm_cust_info where cst_firstname!= TRIM(cst_firstname)
select cst_lastname from bronze.crm_cust_info where cst_lastname!= TRIM(cst_lastname)

--3) Data Standardization & Consistency 
Select Distinct cst_gndr from bronze.crm_cust_info
Select Distinct cst_marital_status from bronze.crm_cust_info

--------------------------------------------------------------------

--------------------------------------------------------------------
-- Check the Quality of Silver - Re-run the quality check queries from bronze layer to verify the quality of data in the silver layer
--------------------------------------------------------------------
--1) 
select 
cst_id,count(*)
from silver.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is NULL 

--2)
select cst_firstname from silver.crm_cust_info where cst_firstname!= TRIM(cst_firstname)
select cst_lastname from silver.crm_cust_info where cst_lastname!= TRIM(cst_lastname)

--3) 
Select Distinct cst_gndr from silver.crm_cust_info
Select Distinct cst_marital_status from silver.crm_cust_info

select * from silver.crm_cust_info

--------------------------------------------------------------------
-- for table bronze.crm_prd_info
--------------------------------------------------------------------
--1)--

select 
prd_id,count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) >1 or prd_id is NULL 

select prd_nm from bronze.crm_prd_info where prd_nm !=TRIM(prd_nm)

select prd_cost from bronze.crm_prd_info where prd_cost < 0  or prd_cost is null
select prd_cost from silver.crm_prd_info where prd_cost < 0  or prd_cost is null

Select * from bronze.crm_prd_info where prd_end_dt<prd_start_dt
Select * from silver.crm_prd_info where prd_end_dt<prd_start_dt

select * from silver.crm_prd_info

--------------------------------------------------------------------
-- for table bronze.crm_sales_details
--------------------------------------------------------------------
SELECT NULLIF(sls_order_dt,0) as sls_order_dt from bronze.crm_sales_details
where sls_order_dt<0 or LEN(sls_order_dt) !=8 or sls_order_dt>20500101 or sls_order_dt < 19000101

select * from bronze.crm_sales_details
where sls_order_dt>sls_ship_dt or sls_order_dt > sls_due_dt  

select * from bronze.crm_sales_details
where sls_sales !=sls_quantity * sls_price 
OR sls_sales is null or sls_quantity is NULL or sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price<=0 

select * from silver.crm_sales_details

--------------------------------------------------------------------
-- for table bronze.erp_cust_az12
--------------------------------------------------------------------
Select Distinct bdate from bronze.erp_cust_az12 where bdate<1924-01-01 or bdate > GETDATE()

select distinct gen,
CASE WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
	 WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
	 ELSE 'n/a' END as gen
from bronze.erp_cust_az12

select * from silver.erp_cust_az12

--------------------------------------------------------------------
-- for table bronze.erp_loc_a101;
--------------------------------------------------------------------

SELECT DISTINCT cntry from bronze.erp_loc_a101;
SELECT DISTINCT cntry from silver.erp_loc_a101;
select * from silver.erp_loc_a101;

--------------------------------------------------------------------
-- for table bronze.erp_px_cat_g1v2
--------------------------------------------------------------------

select * from bronze.erp_px_cat_g1v2 where cat!=TRIM(cat) or subcat!=TRIM(subcat) or maintenance!=TRIM(maintenance)
--Data Standardization and Consistency
Select DISTINCT cat from bronze.erp_px_cat_g1v2

select * from silver.erp_px_cat_g1v2

-----------------------------------------------------------------------------------------------------------
-- Quality Chekc for Gold Layer after joining three tables ,to identify duplicates after joining 3 tables
--gold.dim_customers 
-----------------------------------------------------------------------------------------------------------

WITH cust_joined AS (
    SELECT 
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM silver.crm_cust_info ci 
    LEFT JOIN silver.erp_cust_az12 ca 
        ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la 
        ON ci.cst_key = la.cid
)
SELECT
    cst_id,
    COUNT(*) AS record_count
FROM cust_joined
GROUP BY cst_id
HAVING COUNT(*) > 1;

select distinct gender from gold.dim_customers 

-----------------------------------------------------------------------------------------------------------
--gold.dim_products
-----------------------------------------------------------------------------------------------------------

with prd_joined as (
SELECT 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id=pc.id
WHERE prd_end_dt IS NULL
)

select prd_key,COUNT(*) from prd_joined group by prd_key having COUNT(*)>1

select * from gold.dim_products


-----------------------------------------------------------------------------------------------------------
--gold.fact_sales
-----------------------------------------------------------------------------------------------------------

select * from gold.fact_sales

--Fact Check - check if all dimension tables can successfully join to the fact table
select * from gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON c.customer_key=f.customer_key
WHERE c.customer_key IS NULL

select * from gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key=f.product_key
WHERE p.product_key IS NULL
