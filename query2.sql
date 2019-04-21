SELECT DISTINCT
	OP1.order_country,
	OP2.product_id,

	/* in deze cast zit een telling van rijen uniek voor */
        /* selectie gedeeld door het aantal rijen in de      */ 
        /* database, we eindigen met een decimal omdat de    */
        /* getallen soms erg klein achter de komma zijn.     */

	CAST((

		CAST((
			SELECT 
				COUNT(*) 
			FROM 
				orders_products OP3 
			WHERE 
				OP3.order_country = OP1.order_country 
                                AND 
				OP3.product_id = OP2.product_id
		) AS float) 

		/ 

		CAST((
			SELECT 
				COUNT(*) 
			FROM orders_products OP4
		) AS float)

	) AS decimal(10,10)) as 'country_count'
FROM 
	orders_products OP1, 
	orders_products OP2
GROUP BY
	OP1.order_country,
	OP2.product_id