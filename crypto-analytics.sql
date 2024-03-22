-- Number of buy and sell transactions for Bitcoin

SELECT 
    txn_type, 
    COUNT(txn_type) AS transaction_count
FROM 
    raw.transactions
WHERE 
    ticker = 'BTC'
GROUP BY 
    txn_type;



/* For each year, calculate the following buy and sell metrics for Bitcoin:
a. Total transaction count
b. Total quantity
c. Average quantity */

SELECT 
   EXTRACT(YEAR FROM txn_date::DATE) AS txn_year,
   txn_type,
   COUNT(txn_id) AS txn_count,
   SUM(quantity) AS total_quantity,
   AVG(quantity) AS average_quantity
FROM 
   raw.transactions
WHERE 
   ticker = 'BTC'
GROUP BY 
   txn_year, txn_type
ORDER BY 
   txn_year, txn_type;



-- Monthly total quantity purchased and sold for Ethereum in 2020

SELECT 
    EXTRACT(MONTH FROM txn_date::DATE) AS calendar_month,
    SUM(quantity) FILTER (WHERE txn_type = 'BUY') AS buy_quantity,
    SUM(quantity) FILTER (WHERE txn_type = 'SELL') AS sell_quantity
FROM 
    raw.transactions
WHERE 
    ticker = 'ETH' 
    AND txn_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY 
    calendar_month
ORDER BY 
    calendar_month;


-- Who are the top 3 members with the most bitcoin quantity?

with buy as(
select
	member_id,
	sum(quantity) as bought_btc
from raw.transactions
where txn_type = 'BUY' and ticker = 'BTC'
group by member_id
)

, sell as (
select 
	member_id
	,sum(quantity) as sold_btc
from raw.transactions
where txn_type = 'SELL' and ticker = 'BTC'
group by member_id
)

select 
	members.first_name
	,buy.bought_btc - sell.sold_btc as total_quantity
from buy 
full join sell using (member_id)
join raw.members
using (member_id)
order by total_quantity desc
limit 3;
