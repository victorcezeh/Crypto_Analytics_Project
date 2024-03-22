# Crypto Analytics Project



![Crypto Analytics](https://images.pexels.com/photos/8370752/pexels-photo-8370752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1)



## Project Introduction

I've been assigned the task of analyzing cryptocurrency data as a data engineer. My manager has provided CSV files containing crucial information required to address inquiries from company executives. This project will walk you through the process of loading and analyzing the data, step by step, to derive insights and answer pertinent business questions.


## Table of Contents

- [Task 1 - Setting up the database.](#task-1---setting-up-the-database)
- [Task 2 - Answering business questions.](#task-2---answering-business-questions)
  - [1. How many buy and sell transactions are there for Bitcoin?](#1-how-many-buy-and-sell-transactions-are-there-for-bitcoin)
  - [2. For each year, calculate the following buy and sell metrics for bitcoin:](#2-for-each-year-calculate-the-following-buy-and-sell-metrics-for-bitcoin)
  - [3. What was the **monthly** total quantity **purchased and sold** for Ethereum in 2020?](#3-what-was-the-monthly-total-quantity-purchased-and-sold-for-ethereum-in-2020)
  - [4. Who are the top 3 members with the most bitcoin quantity?](#4-who-are-the-top-3-members-with-the-most-bitcoin-quantity)
- [Tools Used](#Tools-Used)
- [Project Structure](#Project-Structure)
- [Acknowledgement](#Acknowledgement)


## Task 1 - Setting up the database.

#### Using psql (an interactive terminal-based front-end to PostgreSQL), I created a user named 'cryptoverse_admin' with the attributes CREATEDB and CREATEROLE.


This command will create a new user with the specified privileges, along with a password.

```sql

CREATE USER cryptoverse_admin WITH CREATEDB CREATEROLE PASSWORD **********;

```


#### Using the user from the first step, I created a database called metaverse.


This command creates a new database named **metaverse** with **cryptoverse_admin** as its owner.

```sql

CREATE DATABASE metaverse OWNER cryptoverse_admin;

```

Below shows the list of databases with their respective owners. In psql, you can get the list of databases using the ` \l meta-command `. 

Peep metaverse and cryptoverse_admin. 😉

![Screenshot (992)](https://github.com/victorcezeh/Crypto_Analytics_Project/assets/129629266/ec2e8645-f4e0-45ad-a265-b0a250076a71)



#### I proceeded to create a schema in the metaverse database called **raw**.

This command will create a new schema named raw in the metaverse database.

```sql
CREATE SCHEMA raw;

```


Below shows the list of all database schemas with their respective owners. In psql, you can get the list of all schemas using the ` \dn meta-command `. 

Peep the raw schema and cryptoverse_admin. 😉

![Schema & Admin](https://github.com/victorcezeh/Crypto_Analytics_Project/assets/129629266/7fafd5a5-eca4-42f1-a66a-e0a74222b42a)


#### Data Importation

I used DBeaver UI, a SQL client software application and a database administration tool, to add the Members, Prices, and Transactions tables.

![DBeaver UI)](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/f8d51df1-b596-4ea5-9078-0865055c95f2)

#### Sneak peak into the various table imported tables.

## Members table

The Members table contains information about users registered on the cryptocurrency platform.

![Members](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/ed406474-1b49-404d-8730-cbbac877851d)

## Prices table

The Prices table records historical price data for various cryptocurrencies.

![Prices](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/e33623cc-58ff-4aa3-82e7-6773062fef1c)

## Transactions table

The Transactions table tracks all transactions executed on the cryptocurrency platform.

![Transactions)](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/b8360907-25ff-4240-a873-ca11c1201fc9)






## Task 2 - Answering business questions.

### 1. How many buy and sell transactions are there for Bitcoin?

```sql
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

```

#### Result of SQL Query

| txn_type    | transaction_count |
|-------------|-------------------|
| SELL        | 2,044             |
| BUY         | 10,440            |

![Result of SQL Query](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/dbf008d1-64b3-4eec-9527-1ce3303d65e6)


### 2. For each year, calculate the following buy and sell metrics for bitcoin:

- Total transaction count
- Total quantity
- Average quantity

 ```sql
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
```

#### Result of SQL Query
![Result of SQL Query](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/25e3a3fa-909f-453e-a112-a120a316c002)



### 3. What was the **monthly** total quantity **purchased and sold** for Ethereum in 2020?

```sql

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
```
#### Result of SQL Query
![Result of SQL Query](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/aef0e3d9-1aa0-42a3-9d34-49ba3e340639)


### 4. Who are the top 3 members with the most bitcoin quantity?

```sql
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
```

#### Result of SQL Query
#### Top 3 Members with the Most Bitcoin Quantity.

| First Name | Total Quantity |
|------------|----------------|
| Nandita    | 3775           |
| Leah       | 3649           |
| Ayush      | 3554           |

![Result of SQL Query](https://github.com/victorcezeh/crypto-analytics-project/assets/129629266/7f54772a-04a8-4c4e-ace2-9717190524e6)


## Tools Used

- [Dbeaver](https://dbeaver.io/download/) (version 24.0.0)
- [SQL Shell (psql)](https://www.postgresql.org/download/)
  

## Project Structure

`README.md`: This file serves as the project documentation, providing an overview of the project, its purpose, and other relevant information.

`crypto-analytics.py`: This file contains a Python script with each SQL statement added to a variable representing the corresponding business question number.

`crypto-analytics.sql`: This file contains all the SQL statements written in the README.md file, with each SQL statement representing the corresponding business question.

`members.csv`: This file contains information about the members or users registered on the cryptocurrency platform.

`prices.csv`: This file contains historical price data for various cryptocurrencies. 

`transactions.csv`: This file tracks all transactions executed on the cryptocurrency platform.


## Acknowledgement

A heartfelt thank you to [Altschool Africa](https://altschoolafrica.com/) for providing me with the necessary skillset to tackle this project.
