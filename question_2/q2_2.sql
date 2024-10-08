with curr_mth_txn_by_mfg AS (
    SELECT mfg.id, COUNT(c.price) AS total
    FROM q2schema.transaction txn
    LEFT JOIN q2schema.car c ON txn.car_serial_number = c.serial_number
    LEFT JOIN q2schema.car_model cm ON c.car_model_id = cm.id
    LEFT JOIN q2schema.manufacturer mfg ON cm.manufacturer_id = mfg.id
    WHERE EXTRACT(MONTH FROM txn.date_txn) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM txn.date_txn) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY mfg.id
)

SELECT *
FROM (
    SELECT mfg.name,
        COALESCE(curr_mth_txn_by_mfg.total, 0)                                   AS total,
        dense_rank() OVER (ORDER BY COALESCE(curr_mth_txn_by_mfg.total, 0) DESC) AS rank
    FROM q2schema.manufacturer mfg
    LEFT JOIN curr_mth_txn_by_mfg on mfg.id = curr_mth_txn_by_mfg.id
) t
WHERE t.rank <= 3;
