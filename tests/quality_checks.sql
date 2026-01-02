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
