SELECT DISTINCT 
	product_id as 'id', 
	product_title as 'title', 
	product_description as 'description'  
FROM 
	orders_products 
WHERE 
	/* we zoeken hier in de product_title en   */
        /* product_description met de LIKE functie */

	product_title LIKE '%lorem%' OR 
	product_description LIKE '%lorem%'