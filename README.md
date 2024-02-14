# Crypto Analytics Project



![Crypto Analytics](https://images.pexels.com/photos/8370752/pexels-photo-8370752.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1)



## Project Introduction

I have been tasked with analyzing data about crypto currencies. As a data engineer, my manager has shared some csv files with me containing information needed to answer some questions for the company executives. During the course of reading this project, I will take you on a step by step process on how I loaded and analysed the data to help answer relevant business questions.



## Task 1 - Setting up the database

#### Using psl (An interactive terminal-based front-end to PostgreSQL), I created a user called cryptoverse_admin with CREATEDB and CREATEROLE attributes.


This command will create a new user with the specified privileges.

```sql

CREATE USER cryptoverse_admin WITH CREATEDB CREATEROLE PASSWORD **********;

```


#### Using the user from the first step, I created a database called metaverse.


This command creates a new database named metaverse with cryptoverse_admin as its owner.

```sql

CREATE DATABASE metaverse OWNER cryptoverse_admin;

```

Below shows the list of databases with their respective owners. In psql, you can get the list of databases using the \l meta-command. 

Peep metaverse and cryptoverse_admin. 😉

![Screenshot (992)](https://github.com/victorcezeh/Crypto_Analytics_Project/assets/129629266/ec2e8645-f4e0-45ad-a265-b0a250076a71)



#### I proceeded to create a schema in the metaverse database called raw.

This command will create a new schema named raw in the metaverse database.

```sql
CREATE SCHEMA raw;

```


Below shows the list of all database schemas with their respective owners. In psql, you can get the list of all schemas using the \dn meta-command. 

Peep the raw schema and cryptoverse_admin. 😉

![Screenshot (993)](https://github.com/victorcezeh/Crypto_Analytics_Project/assets/129629266/7fafd5a5-eca4-42f1-a66a-e0a74222b42a)


