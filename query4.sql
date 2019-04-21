SELECT DISTINCT 
	OP5.product_id, 
	OP5.product_title,                            
	OP5.product_description,                               

	/* toepassing van naive bayes */
	(0.1 + OP6.country_count) * 
        (0.1 + OP7.hour_count) * 
        (0.1 + OP8.day_count)  as 'rank'
FROM 
	orders_products OP5
LEFT JOIN (

	/* de query uit de vorige stap */
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
					OP3.order_country = 
                                        OP1.order_country AND 
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
	/* eind van query uit vorige stap */

) AS OP6 ON OP5.product_id = OP6.product_id

LEFT JOIN (

	/* de query uit de vorige stap, maar nu met order_hour */
	SELECT DISTINCT
		OP1.order_hour,
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
					OP3.order_hour = OP1.order_hour 
                                        AND 
					OP3.product_id = OP2.product_id
			) AS float) 

			/ 

			CAST((
				SELECT 
					COUNT(*) 
				FROM orders_products OP4
			) AS float)

		) AS decimal(10,10)) as 'hour_count'
	FROM 
		orders_products OP1, 
		orders_products OP2
	GROUP BY
		OP1.order_hour,
		OP2.product_id
	/* eind van query uit vorige stap */

) AS OP7 ON OP5.product_id = OP7.product_id


LEFT JOIN (

	/* de query uit de vorige stap, maar nu met order_day */
	SELECT DISTINCT
		OP1.order_day,
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
					OP3.order_hour = OP1.order_day 
                                        AND 
					OP3.product_id = OP2.product_id
			) AS float) 

			/ 

			CAST((
				SELECT 
					COUNT(*) 
				FROM orders_products OP4
			) AS float)

		) AS decimal(10,10)) as 'day_count'
	FROM 
		orders_products OP1, 
		orders_products OP2
	GROUP BY
		OP1.order_day,
		OP2.product_id
	/* eind van query uit vorige stap */

) AS OP8 ON OP5.product_id = OP8.product_id

WHERE 
	/* ook de WHERE is licht aangepast, we nemen nu het land, */ 
        /* uur en dag mee in onze criteria omdat er natuurlijk    */ 
        /* meerdere wegingen zijn (per factor uniek)              */

	(OP5.product_title LIKE '%lorem%' OR 
	OP5.product_description LIKE '%lorem%') AND
	OP6.order_country = 'China' AND 
	OP7.order_hour = 8 AND 
	OP8.order_day = 2

ORDER BY                    
	rank DESC