-- ---------------------------------------------------------
-- Step 1: Create the database
-- ---------------------------------------------------------
CREATE DATABASE your_database;
USE your_database;
-- Now you are using your database which you just created.
-- Now we have to populate this database with the tables.

-- ---------------------------------------------------------
-- Step 2: Define the store table
-- Each store has a unique ID, name, location, and a manager (linked later)
-- we cannot link manager yet because manager table (employees) table has not been created yet. 
-- ---------------------------------------------------------

CREATE TABLE store (
  store_id INT PRIMARY KEY,
  store_name VARCHAR(50),
  location VARCHAR(100),
  manager_id INT
);

Describe store;
-- Give information about specific table.

-- ---------------------------------------------------------
-- Step 3: Define the employee table
-- Employees belong to stores and can have different roles
-- ---------------------------------------------------------

CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  birth_date DATE,
  salary INT,
  job_role VARCHAR(50),
  store_id INT,
  FOREIGN KEY(store_id) REFERENCES store(store_id) ON DELETE SET NULL
);
-- See On Delete Set NULL in the Introduction file

-- ---------------------------------------------------------
-- Step 4: Add foreign key from store to employee for manager relationship
-- This links manager_id in store table to emp_id in employee table
-- ---------------------------------------------------------

ALTER TABLE store
ADD FOREIGN KEY(manager_id) REFERENCES employee(emp_id)
ON DELETE SET NULL;

-- ---------------------------------------------------------
-- Step 5: Define the customer table
-- Stores basic information about customers
-- ---------------------------------------------------------

CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(50),
  contact_details VARCHAR(100)
);

-- ---------------------------------------------------------
-- Step 6: Define the sales table
-- Records each sale, with references to employee and customer
-- ---------------------------------------------------------

CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  sale_date DATE,
  emp_id INT,
  customer_id INT,
  total_amount DECIMAL(10,2),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE SET NULL,
  FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Step 7: Define the supplier table
-- Stores supplier details and their associated store
-- ---------------------------------------------------------

CREATE TABLE supplier (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(50),
  supply_type VARCHAR(50),
  store_id INT,
  FOREIGN KEY(store_id) REFERENCES store(store_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Step 8: Insert sample data into store and employee tables
-- Store and employee are linked via manager_id and store_id
-- ---------------------------------------------------------

-- First add employee and keep the store_id NULL,
-- then add the store which it manages, 
-- then update the employee store id to the right one.
INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(101, 'John', 'Doe', '1985-06-15', 50000, 'Manager', NULL);

INSERT INTO store (store_id, store_name, location, manager_id) VALUES
(1, 'Downtown Store', 'New York', 101);

UPDATE employee
SET store_id = 1
WHERE emp_id = 101;

Select * from employee;
INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(102, 'Sarah', 'Lee', '1990-08-22', 45000, 'Manager', NULL);

INSERT INTO store (store_id, store_name, location, manager_id) VALUES
(2, 'City Mall Outlet', 'Los Angeles', 102);

UPDATE employee
SET store_id = 2
WHERE emp_id = 102;
SELECT * FROM employee;

INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(103, 'Michael', 'Smith', '1982-04-10', 60000, 'Cashier', 2);


INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(104, 'Emily', 'Davis', '1995-03-25', 40000, 'Manager', NULL);

INSERT INTO store (store_id, store_name, location, manager_id) VALUES
(3, 'Suburban Market', 'Chicago', 104);

UPDATE employee
SET store_id = 3
WHERE emp_id = 104;

INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(105, 'James', 'Brown', '1988-11-02', 48000, 'Sales Assosiate', 3);

INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(106, 'Anna', 'White', '1993-09-17', 42000, 'Manager', NULL);

INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(107, 'Robert', 'Wilson', '1987-12-30', 47000, 'Stock Clerk', 4);

INSERT INTO store (store_id, store_name, location, manager_id) VALUES
(4, 'Metro Plaza', 'Houston', 106);

UPDATE employee
SET store_id = 4
WHERE emp_id = 106;

INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(107, 'Robert', 'Wilson', '1987-12-30', 47000, 'Stock Clerk', 4);

-- See what we have stored
SELECT * FROM employee;

-- ---------------------------------------------------------
-- Step 9: Insert customers
-- ---------------------------------------------------------

INSERT INTO customer (customer_id, customer_name, contact_details) VALUES
(201, 'Alice Johnson', 'alice@email.com'),
(202, 'Bob Williams', 'bob@email.com'),
(203, 'Charlie Davis', 'charlie@email.com'),
(204, 'Diana Miller', 'diana@email.com'),
(205, 'Ethan Moore', 'ethan@email.com');

-- ---------------------------------------------------------
-- Step 10: Insert sales data
-- Each sale links to an employee and a customer
-- ---------------------------------------------------------

INSERT INTO sales (sale_id, sale_date, emp_id, customer_id, total_amount) VALUES
(301, '2024-03-20', 101, 201, 150.00),
(302, '2024-03-21', 102, 202, 80.00),
(303, '2024-03-22', 103, 203, 200.00),
(304, '2024-03-23', 104, 204, 120.00),
(305, '2024-03-24', 105, 205, 300.00);

-- ---------------------------------------------------------
-- Step 11: Insert supplier data
-- Each supplier is assigned to one store
-- ---------------------------------------------------------


INSERT INTO supplier (supplier_id, supplier_name, supply_type, store_id) VALUES
(401, 'Fresh Supplies', 'Groceries', 1),
(402, 'Tech Distributors', 'Electronics', 2),
(403, 'Home Essentials Co.', 'Furniture', 3),
(404, 'Style Apparel', 'Clothing', 4);


-- 1. Total sales by store (top-performing stores)
SELECT s.store_name, SUM(sa.total_amount) AS total_revenue
FROM store s
JOIN employee e ON s.store_id = e.store_id
JOIN sales sa ON e.emp_id = sa.emp_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

SELECT e.first_name, SUM(sa.total_amount) AS total_revenue
FROM employee e
JOIN sales sa ON sa.emp_id = e.emp_id
GROUP BY first_name;

-- 2. Total sales by employee (top-performing employee)
SELECT e.first_name, e.last_name, SUM(s.total_amount) AS total_sales
FROM employee e
JOIN sales s ON s.emp_id = e.emp_id
GROUP BY e.emp_id
ORDER BY total_sales DESC;


-- 3. Total spending by customer (top customers)
SELECT c.customer_name, SUM(s.total_amount) AS total_spent
FROM customer c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- 4. Number of purchases per customer (most frequent buyers)
SELECT c.customer_name, COUNT(s.sale_id) AS purchase_count
FROM customer c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id
ORDER BY purchase_count DESC;

SELECT * from sales;

-- 5. Revenue per location (regional performance)
SELECT st.location, SUM(sa.total_amount) AS location_sales
FROM store st
JOIN employee e ON st.store_id = e.store_id
JOIN sales sa ON e.emp_id = sa.emp_id
GROUP BY st.location
ORDER BY location_sales DESC;

-------------------------------


INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(121, 'Drew', 'Diaz', '1990-09-14', 49163, 'Manager', NULL),
(123, 'Taylor', 'Anderson', '1996-03-22', 58608, 'Manager', NULL),
(125, 'Morgan', 'Foster', '1985-10-24', 49103, 'Manager', NULL),
(128, 'Jordan', 'Carter', '1982-08-12', 56630, 'Manager', NULL),
(132, 'Riley', 'Evans', '1985-11-13', 58816, 'Manager', NULL),
(136, 'Alex', 'Diaz', '1984-06-12', 45193, 'Manager', NULL),
(140, 'Cameron', 'Hayes', '1994-03-04', 46574, 'Manager', NULL),
(143, 'Taylor', 'Brooks', '1990-03-17', 46287, 'Manager', NULL);


INSERT INTO store (store_id, store_name, location, manager_id) VALUES
(29, 'Store 29', 'Las Vegas', 121),
(30, 'Store 30', 'Austin', 123),
(31, 'Store 31', 'Boston', 125),
(32, 'Store 32', 'San Diego', 128),
(33, 'Store 33', 'Denver', 132),
(34, 'Store 34', 'Denver', 136),
(35, 'Store 35', 'Denver', 140),
(36, 'Store 36', 'Miami', 143);

SELECT * from store;

UPDATE employee SET store_id = 29 WHERE emp_id = 121;
UPDATE employee SET store_id = 30 WHERE emp_id = 123;
UPDATE employee SET store_id = 31 WHERE emp_id = 125;
UPDATE employee SET store_id = 32 WHERE emp_id = 128;
UPDATE employee SET store_id = 33 WHERE emp_id = 132;
UPDATE employee SET store_id = 34 WHERE emp_id = 136;
UPDATE employee SET store_id = 35 WHERE emp_id = 140;
UPDATE employee SET store_id = 36 WHERE emp_id = 143;


INSERT INTO employee (emp_id, first_name, last_name, birth_date, salary, job_role, store_id) VALUES
(122, 'Jordan', 'Foster', '1981-05-14', 46087, 'Sales Associate', 29),
(124, 'Taylor', 'Diaz', '2000-01-19', 56202, 'Cashier', 30),
(126, 'Taylor', 'Brooks', '1996-12-05', 59275, 'Sales Associate', 31),
(127, 'Alex', 'Diaz', '1983-11-16', 53810, 'Sales Associate', 31),
(129, 'Jamie', 'Brooks', '1980-11-19', 44000, 'Cashier', 32),
(130, 'Jamie', 'James', '1987-01-09', 42756, 'Cashier', 32),
(131, 'Alex', 'Foster', '1996-07-13', 47328, 'Stock Clerk', 32),
(133, 'Drew', 'Garcia', '1980-01-22', 44620, 'Cashier', 33),
(134, 'Taylor', 'Garcia', '1987-02-06', 43051, 'Sales Associate', 33),
(135, 'Casey', 'Foster', '1994-08-08', 59794, 'Sales Associate', 33),
(137, 'Alex', 'Garcia', '1999-03-28', 40717, 'Sales Associate', 34),
(138, 'Morgan', 'Carter', '1997-03-12', 41616, 'Stock Clerk', 34),
(139, 'Riley', 'Hayes', '1983-10-19', 47156, 'Sales Associate', 34),
(141, 'Drew', 'Carter', '1991-01-24', 52108, 'Sales Associate', 35),
(142, 'Skyler', 'James', '1982-09-05', 59858, 'Stock Clerk', 35),
(144, 'Jordan', 'Diaz', '1991-03-31', 56392, 'Sales Associate', 36),
(145, 'Skyler', 'Evans', '1997-10-09', 50903, 'Stock Clerk', 36);


select * FROM employee;


INSERT INTO supplier (supplier_id, supplier_name, supply_type, store_id) VALUES
(421, 'Highschool', 'Clothing', 29),
(422, 'Highschool 2', 'Electronics', 33),
(423, '123 Supply', 'Snacks', 3),
(424, 'Supplier and CO', 'Groceries', 4),
(425, 'Mobile Manufacturers 2', 'Snacks', 35),
(426, 'FedEx', 'Clothing', 30),
(427, 'Products Ltd', 'Clothing', 36),
(428, 'wood Corp', 'Furniture', 34),
(429, 'Mobile Manufacturers', 'Clothing', 2),
(430, 'Highschool 3', 'Furniture', 3);


INSERT INTO customer (customer_id, customer_name, contact_details) VALUES
(221, 'Alice Johnson', 'alice.johnson221@email.com'),
(222, 'Bob Williams', 'bob.williams222@email.com'),
(223, 'Charlie Brown', 'charlie.brown223@email.com'),
(224, 'Diana Miller', 'diana.miller224@email.com'),
(225, 'Ethan Davis', 'ethan.davis225@email.com'),
(226, 'Fiona Garcia', 'fiona.garcia226@email.com'),
(227, 'George Martinez', 'george.martinez227@email.com'),
(228, 'Hannah Wilson', 'hannah.wilson228@email.com'),
(229, 'Ian Anderson', 'ian.anderson229@email.com'),
(230, 'Jasmine Johnson', 'jasmine.johnson230@email.com'),
(231, 'Kevin Miller', 'kevin.miller231@email.com'),
(232, 'Laura Brown', 'laura.brown232@email.com'),
(233, 'Mike Garcia', 'mike.garcia233@email.com'),
(234, 'Nina Davis', 'nina.davis234@email.com'),
(235, 'Oscar Jones', 'oscar.jones235@email.com'),
(236, 'Paula Martinez', 'paula.martinez236@email.com'),
(237, 'Quinn Anderson', 'quinn.anderson237@email.com'),
(238, 'Rachel Johnson', 'rachel.johnson238@email.com'),
(239, 'Sam Wilson', 'sam.wilson239@email.com'),
(240, 'Tina Williams', 'tina.williams240@email.com'),
(241, 'Uma Brown', 'uma.brown241@email.com'),
(242, 'Victor Garcia', 'victor.garcia242@email.com'),
(243, 'Wendy Jones', 'wendy.jones243@email.com'),
(244, 'Xavier Miller', 'xavier.miller244@email.com'),
(245, 'Yara Martinez', 'yara.martinez245@email.com'),
(246, 'Zane Davis', 'zane.davis246@email.com'),
(247, 'Liam Johnson', 'liam.johnson247@email.com'),
(248, 'Emma Wilson', 'emma.wilson248@email.com'),
(249, 'Noah Williams', 'noah.williams249@email.com'),
(250, 'Olivia Garcia', 'olivia.garcia250@email.com'),
(251, 'Ava Martinez', 'ava.martinez251@email.com'),
(252, 'James Brown', 'james.brown252@email.com'),
(253, 'Lucas Jones', 'lucas.jones253@email.com'),
(254, 'Mia Anderson', 'mia.anderson254@email.com'),
(255, 'Sophia Davis', 'sophia.davis255@email.com');

SELECT * FROM sales;
INSERT INTO sales (sale_id, sale_date, emp_id, customer_id, total_amount) VALUES
(321, '2024-04-14', 107, 221, 115.44),
(322, '2024-04-07', 102, 222, 119.87),
(323, '2024-04-09', 105, 225, 264.15),
(324, '2024-03-27', 121, 244, 168.48),
(325, '2024-04-09', 123, 230, 283.73),
(326, '2024-03-31', 125, 235, 230.68),
(327, '2024-03-26', 125, 246, 139.87),
(328, '2024-04-13', 107, 202, 217.81),
(329, '2024-04-06', 123, 226, 219.11),
(330, '2024-03-26', 125, 204, 110.05),
(331, '2024-03-28', 125, 235, 182.03),
(332, '2024-04-12', 135, 255, 328.98),
(333, '2024-04-07', 143, 237, 137.03),
(334, '2024-04-15', 137, 235, 90.7),
(335, '2024-04-02', 125, 230, 353.4),
(336, '2024-03-24', 135, 247, 325.31),
(337, '2024-04-02', 129, 246, 85.49),
(338, '2024-04-04', 141, 241, 362.08),
(339, '2024-04-12', 130, 202, 129.57),
(340, '2024-03-21', 138, 249, 274.88),
(341, '2024-04-12', 143, 250, 206.11),
(342, '2024-04-07', 128, 251, 253.93),
(343, '2024-04-09', 142, 233, 308.23),
(344, '2024-04-08', 103, 242, 280.83),
(345, '2024-03-21', 104, 241, 105.37),
(346, '2024-03-26', 134, 253, 299.41),
(347, '2024-04-09', 106, 252, 161.36),
(348, '2024-03-30', 134, 251, 167.99),
(349, '2024-04-11', 138, 203, 373.83),
(350, '2024-03-27', 143, 237, 173.7),
(351, '2024-04-12', 140, 239, 388.35),
(352, '2024-03-29', 126, 244, 331.64),
(353, '2024-03-23', 139, 255, 105.38),
(354, '2024-04-07', 135, 229, 160.64),
(355, '2024-04-13', 128, 224, 107.97),
(356, '2024-03-27', 136, 225, 288.4),
(357, '2024-04-08', 143, 225, 219.73),
(358, '2024-03-31', 126, 205, 205.8),
(359, '2024-03-28', 105, 225, 114.44),
(360, '2024-03-28', 106, 229, 184.91),
(361, '2024-03-25', 136, 253, 365.62),
(362, '2024-03-23', 143, 245, 306.92),
(363, '2024-04-14', 138, 230, 238.2),
(364, '2024-03-28', 137, 233, 351.35),
(365, '2024-03-24', 141, 232, 319.31),
(366, '2024-04-04', 103, 228, 147.01),
(367, '2024-04-01', 107, 252, 221.56),
(368, '2024-03-21', 139, 245, 147.45),
(369, '2024-03-30', 134, 249, 231.68),
(370, '2024-04-05', 134, 250, 245.64),
(371, '2024-03-24', 106, 251, 189.62),
(372, '2024-04-15', 145, 250, 99.91),
(373, '2024-03-27', 124, 247, 146.82),
(374, '2024-04-15', 128, 223, 253.4),
(375, '2024-04-05', 103, 205, 178.4),
(376, '2024-03-31', 105, 250, 328.59),
(377, '2024-03-31', 133, 237, 118.05),
(378, '2024-04-01', 130, 225, 339.27),
(379, '2024-03-24', 126, 226, 180.82),
(380, '2024-04-14', 140, 255, 325.79);