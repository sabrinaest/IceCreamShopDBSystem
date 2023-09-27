# Sunshine Scoops: Icecream Shop Database System

https://github.com/sabrinaest/IceCreamShopDBSystem/assets/102570901/8ba604d6-6484-444f-8bf2-4e000f273b90

## 📝 Program Description

Sunshine Scoops is a database-driven website developed for managing an ice cream shop's operations. Each database entity has its own dedicated page to streamline CRUD operations. Users can add new customers, register them in a rewards program, add new containers (cups, cones, dipped cones, etc.) and expand the menu items. The application manages customer orders, supports multiple suborders, and computes subtotals. The database follows the pre-planned ER diagram. It employs normalization techniques to optimize data organization and reduce redundancy. 

## ✨ Features

* **Database Design**: Built using a detailed ER diagram and schema for clear data relations.

* **Data Normalization**: Applied techniques to reduce redundancy and ensure data integrity.

* **Entity-Specific Management**: Each database entity has dedicated pages, simplifying CRUD operations.

* **Rewards Program Integration**: Register customers directly into a loyalty program and earn points with each purchase.

* **Order Management System**: An integrated system processes customer orders, categorizes suborders, and computes subtotals.

* **Database Scripts**: DDL (Data Definition Language) and DML (Data Manipulation Language) scripts included for efficient database setup and operations.

## 📐 Database Design

![image](https://github.com/sabrinaest/IceCreamShopDBSystem/assets/102570901/838c371e-9963-4b76-acf2-5b8b8bf3df5e)

## 🛠️ Setup and Installation

1. Clone the Repository:

   ```
   git clone https://github.com/sabrinaest/IceCreamShopDBSystem.git
   ```

2. Navigate to Project Directory:

   ```
   cd SunshineScoops
   ```

4. Install Dependencies:

   ```
   npm install
   ```

5. Setup Database:
   * Launch you database management tool (eg. phpMyAdmin).
   * Create a new database named 'sunshinescoops'.
   * Import the provided DDL and DML scripts to structure and populate the database.

6. Configure Database Connector:
   * Locate the 'db-connector.js' file located in the database folder
   * Fill in your MySQL 'username' and 'password' in the following section:
     ```
     const pool = mysql.createPool({
     connectionLimit : 10,
     host            : 'localhost',
     user            : 'YOUR_MYSQL_USERNAME',
     password        : 'YOUR_MYSQL_PASSWORD'',
     database        : 'sunshinescoops'
     ```
     
   * For example if your username is 'yourname123' and password is 'password567' then it should look like this:
     ```
     const pool = mysql.createPool({
     connectionLimit : 10,
     host            : 'localhost',
     user            : 'yourname123',
     password        : 'password567',
     database        : 'sunshinescoops'
     ```

   * Don't forget to save your changes!

7. Start the application:

   ```
   node app.js
   ```

8. Launch your preferred browser and visit http://localhost:52990/ to interact with Sunshine Scoops!
   
## 📚 Documentation & References
