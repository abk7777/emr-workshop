SELECT EXTRACT (
        HOUR
        FROM tpep_pickup_datetime
    ) AS hour,
    avg(fare_amount) AS average_fare
FROM emrworkshop.taxi
GROUP BY 1
ORDER BY 1;

SELECT TipPrctCtgry,
    COUNT (DISTINCT TripID) TripCt
FROM (
        SELECT TripID,
            (
                CASE
                    WHEN fare_prct < 0.7 THEN 'FL70'
                    WHEN fare_prct < 0.8 THEN 'FL80'
                    WHEN fare_prct < 0.9 THEN 'FL90'
                    ELSE 'FL100'
                END
            ) FarePrctCtgry,
            (
                CASE
                    WHEN tip_prct < 0.1 THEN 'TL10'
                    WHEN tip_prct < 0.15 THEN 'TL15'
                    WHEN tip_prct < 0.2 THEN 'TL20'
                    ELSE 'TG20'
                END
            ) TipPrctCtgry
        FROM (
                SELECT TripID,
                    (fare_amount / total_amount) AS fare_prct,
                    (extra / total_amount) AS extra_prct,
                    (mta_tax / total_amount) AS tip_prct,
                    (tolls_amount / total_amount) AS mta_taxprct,
                    (tip_amount / total_amount) AS tolls_prct,
                    (improvement_surcharge / total_amount) AS imprv_suchrgprct,
                    total_amount
                FROM (
                        SELECT *,
                            (
                                CAST(pickup_longitude AS VARCHAR(100)) || '_' || CAST(pickup_latitude AS VARCHAR(100))
                            ) AS TripID
                        FROM emrworkshop.taxi
                        WHERE total_amount > 0
                    ) AS t
            ) AS t
    ) ct
GROUP BY TipPrctCtgry;

SELECT DAY_OF_WEEK(tpep_dropoff_datetime) as day_of_week, AVG(tip_amount) AS average_tip FROM emrworkshop.taxi GROUP BY 1 ORDER BY 1
