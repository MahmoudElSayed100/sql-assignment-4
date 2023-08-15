SELECT secustomer.customer_id,
	SUM(sepayment.amount) AS total_revenue,
	AVG(sefilm.rental_duration) AS avg_rental_duration
FROM customer as secustomer
INNER JOIN rental as serental -- we connected customer table with rental table 
ON secustomer.customer_id = serental.customer_id
INNER JOIN payment as sepayment -- we can get the sum of payment
ON sepayment.rental_id = serental.rental_id
INNER JOIN inventory as seinventory
ON seinventory.inventory_id = serental.inventory_id
INNER JOIN film as sefilm
ON sefilm.film_id = seinventory.film_id
GROUP BY secustomer.customer_id


-- 2. customers who have never rented films but have made payments
-- we want rental id = null and a left outer join
SELECT
	seC.customer_id,
	CONCAT(seC.first_name,' ', seC.last_name) AS fullName
FROM customer as seC
LEFT OUTER JOIN rental as seR
ON seR.customer_id = seC.customer_id
where seR.rental_id is NULL

--3 correlation between customer rental freq and the avg rating of rented films
WITH CTE_rentalCount_avgRating AS(
SELECT
seC.customer_id,
COUNT(seR.rental_id) as rentalCount,
AVG(seF.film_id) as avgRating
FROM customer as seC
LEFT OUTER JOIN rental as seR
ON seC.customer_id = seR.customer_id
LEFT OUTER JOIN inventory as seI
ON seR.inventory_id = seI.inventory_id
LEFT OUTER JOIN film as seF
ON seI.film_id = seF.film_id
GROUP BY seC.customer_id
)
SELECT 
CORR(rentalCount, avgRating)
FROM CTE_rentalCount_avgRating;

-- Determine the avg number of films rented per customer, broken down by city(groupy by city)
SELECT 
seCty.city,
AVG(rcperc.Rcount) as avgFilmsRentedPCustomer
FROM city as seCty
--we use left join to ensure all city are included even with they don't have rentals
LEFT OUTER JOIN address as seAd
ON seCty.city_id = seAd.city_id
LEFT OUTER JOIN customer as seC
ON seAd.address_id = seC.address_id
LEFT OUTER JOIN (
	SELECT seR.customer_id,
	COUNT(seR.rental_id) as Rcount
	FROM rental as seR
	GROUP BY seR.customer_id
) as rcperc
ON seC.customer_id = rcperc.customer_id
GROUP BY seCty.city;


-- films that have been rentedd more than the avg numbe rof times and are currently not in inventory







