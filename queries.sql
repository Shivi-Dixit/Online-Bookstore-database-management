Create Database Online_Bookstore;
use Online_Bookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
set foreign_key_checks = 1;
select * from books;
select * from customers;
select * from orders;
show create table orders;

SELECT Customer_ID FROM Customers WHERE Customer_ID IN (84, 137, 216, 433);
SELECT Book_ID FROM Books WHERE Book_ID IN (169, 301, 261, 343);

-- 1) Retrieve all books in the 'Fiction' genre.
Select * from Books
where Genre = 'Fiction'; 

-- 2) Find books published after the year 1950.
Select * from Books
where Published_Year > 1950;

-- 3) List all the customers from the Canada:
Select * from Customers
where country = 'Canada';

-- 4) Show orders placed in November 2023:
Select * from Orders 
where Order_Date Between '2023-11-01' And '2023-11-30';

-- 5) Retrieve the total stocks of books available:
Select sum(Stock) as total_stock from Books;

-- 6) Find the details of the most expensive books:
Select * from Books 
Order by price 
desc limit 1;

-- 7) Show all customers who ordered more than 1 qauntity of a book:
select * from orders
where Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where Total_amount > 20;

-- 9) List all genres available in the books table:
select distinct Genre from Books;

-- 10) Find the book with the lowest stock:
select * from books order by stock limit 1;

-- 11) Calculate the total revenue generated from all ordered:
select sum(Total_Amount) from orders;

-- Advance Questions:
-- 1) Retrieve the total number of books sold for each genre:
select * from orders;
select * from books;

Select b.genre, sum(o.quantity) as Total_Book_sold
from orders o
join Books b on o.book_id = b.book_id
group by b.genre;

-- 2) Find the average price of books in the 'fantasy' genre:
select avg(price) as Average_Price
from books where genre = "fantasy";

-- 3) List customers who have placed at least 2 orders:
select * from customers;
select * from orders;
select o.customer_id, c.Name, count(o.order_id) as Order_count
from orders o
join customers c on o.customer_id= c.customer_id
group by o.customer_id, c.name
having count(order_id) >= 2;

-- Find most frequently ordered book:
select o.Book_id, b.title, count(o.order_id) as order_count
from orders o
join books b on o.book_id = b.book_id
group by b.book_id, b.title
order by order_count desc limit 1;

-- 5) show the top 3 most expensive books of 'fantasy' Genre:
select * from books
where genre = 'fantasy'
order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select sum(o.Quantity) total_quantity, b.Author from orders o
join books b on o.book_id = b.book_id
group by b.Author;

-- List the cities where customers who spent over $30 are located:
select distinct c.city, o.Total_amount
from orders o join customers c on c.customer_id = o.customer_id
where o.total_amount > 300;

-- 8)find the customers who spent most on orders:
select * from orders;
select * from customers;
select distinct c.name, c.customer_id, sum(o.Total_Amount) as total_spent from orders o
join customers c on c.customer_id = o.customer_id
group by c.customer_id, c.name order by Total_spent desc limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title, b.stock, 
coalesce(sum(o.quantity),0) 
as order_quantity, b.stock - coalesce(sum(o.quantity),0) 
as remaining_quantity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id;



 
