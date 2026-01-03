-- This Gold layer contains the final dimension and fact tables (Star Schema).
-- It performs business-oriented transformations and combines data from the Silver layer to support reporting and analytics.

------------------------------------------------------
--Transform and create VIEW for gold.dim_customers
------------------------------------------------------

CREATE VIEW gold.dim_customers AS

Select 
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr  -- CRM is the Master for gender Information --Dat Integration is done here from 2 tables gender col to one gender col
		 ELSE COALESCE(ca.gen, 'n/a')					-- If CRM gender is missing or not available,fall back to ERP gender value; default to 'n/a' if still null(here null comes from joining as we are doing left join)
	END  AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci 
LEFT JOIN silver.erp_cust_az12 ca 
ON			ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la 
ON ci.cst_key=la.cid


------------------------------------------------------
--Transform and create VIEW for gold.dim_products
------------------------------------------------------

CREATE VIEW  gold.dim_products AS 

SELECT 
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key, --This is surrogate key acts like a primary key for dimension tables if P.K is not availabe from source system , ORDER BY ensures surrogate keys are assigned in a consistent order
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.maintenance,
	pc.subcat AS subcategory,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id=pc.id
WHERE prd_end_dt IS NULL  -- Filter out all historical data (removing previous data of a particular prd and using only current data where prd_end is NULL)

------------------------------------------------------
--Transform and create VIEW for gold.fact_sales
------------------------------------------------------

CREATE VIEW gold.fact_sales AS

SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key, --sd.sls_prd_key --use the dimension's surrogate keys instead of ID's to easily connect facts with dimensions,
	cu.customer_key,				--sd.sls_cust_id,
	sd.sls_order_dt AS order_date ,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key =pr.product_number
	LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id =cu.customer_id
