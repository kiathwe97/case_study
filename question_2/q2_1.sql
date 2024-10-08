WITH t1 AS (
    SELECT cust.id, COALESCE(SUM(c.price), 0) AS spending
    FROM q2schema.customer cust
    LEFT JOIN q2schema.transaction txn ON cust.id = txn.customer_id
    LEFT JOIN q2schema.car c ON txn.car_serial_number = c.serial_number
    LEFT JOIN q2schema.car_model cm ON c.car_model_id = cm.id
    GROUP BY cust.id
)

SELECT cust.name, t1.spending
FROM t1 LEFT JOIN q2schema.customer cust ON t1.id = cust.id;