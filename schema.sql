-- Banking Management System Database Schema
-- Run this file first to set up your MySQL database

CREATE DATABASE IF NOT EXISTS banking_db;
USE banking_db;

-- Bank Table
CREATE TABLE IF NOT EXISTS bank (
    bank_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_name VARCHAR(100) NOT NULL,
    bank_code VARCHAR(20) UNIQUE NOT NULL,
    established_date DATE,
    headquarters VARCHAR(200)
);

-- Branch Table
CREATE TABLE IF NOT EXISTS branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_id INT NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    phone VARCHAR(20),
    FOREIGN KEY (bank_id) REFERENCES bank(bank_id) ON DELETE CASCADE
);

-- Customer Table
CREATE TABLE IF NOT EXISTS customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    bank_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    date_of_birth DATE,
    national_id VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bank_id) REFERENCES bank(bank_id) ON DELETE CASCADE
);

-- Employee Table
CREATE TABLE IF NOT EXISTS employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(100),
    salary DECIMAL(12, 2),
    hire_date DATE,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Account Table (parent)
CREATE TABLE IF NOT EXISTS account (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    account_type ENUM('saving', 'current') NOT NULL,
    status ENUM('active', 'inactive', 'closed') DEFAULT 'active',
    opened_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- Saving Account (IS A relationship)
CREATE TABLE IF NOT EXISTS saving_account (
    account_id INT PRIMARY KEY,
    interest_rate DECIMAL(5, 2) DEFAULT 4.50,
    min_balance DECIMAL(12, 2) DEFAULT 1000.00,
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

-- Current Account (IS A relationship)
CREATE TABLE IF NOT EXISTS current_account (
    account_id INT PRIMARY KEY,
    overdraft_limit DECIMAL(12, 2) DEFAULT 0.00,
    monthly_fee DECIMAL(8, 2) DEFAULT 0.00,
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

-- Loan Table
CREATE TABLE IF NOT EXISTS loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_amount DECIMAL(15, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    loan_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    status ENUM('pending', 'approved', 'rejected', 'closed') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- Payment Table
CREATE TABLE IF NOT EXISTS payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    payment_amount DECIMAL(15, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    FOREIGN KEY (loan_id) REFERENCES loan(loan_id) ON DELETE CASCADE
);

-- Employee manages Account (manage relationship)
CREATE TABLE IF NOT EXISTS manages (
    employee_id INT NOT NULL,
    account_id INT NOT NULL,
    managed_since TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (employee_id, account_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (account_id) REFERENCES account(account_id)
);

-- Sample Data
INSERT INTO bank (bank_name, bank_code, established_date, headquarters) VALUES
('National Bank Ltd', 'NBL001', '1990-01-15', 'Dhaka, Bangladesh');

INSERT INTO branch (bank_id, branch_name, branch_code, address, city, phone) VALUES
(1, 'Dhaka Main Branch', 'NBL-DK-01', '123 Motijheel C/A', 'Dhaka', '+880-2-9551234'),
(1, 'Chittagong Branch', 'NBL-CTG-01', '456 Agrabad', 'Chittagong', '+880-31-7891234');

INSERT INTO customer (bank_id, first_name, last_name, email, phone, address, date_of_birth, national_id) VALUES
(1, 'Rahim', 'Uddin', 'rahim@example.com', '+880-1711-000001', 'Dhanmondi, Dhaka', '1985-06-15', 'NID001'),
(1, 'Karim', 'Ahmed', 'karim@example.com', '+880-1711-000002', 'Gulshan, Dhaka', '1990-03-22', 'NID002');

INSERT INTO employee (branch_id, first_name, last_name, email, phone, position, salary, hire_date) VALUES
(1, 'Sumaiya', 'Islam', 'sumaiya@nbl.com', '+880-1811-000001', 'Account Manager', 55000.00, '2018-05-01'),
(1, 'Rafiq', 'Hassan', 'rafiq@nbl.com', '+880-1811-000002', 'Loan Officer', 60000.00, '2016-08-15');

INSERT INTO account (customer_id, account_number, balance, account_type, status) VALUES
(1, 'ACC-0000001', 25000.00, 'saving', 'active'),
(1, 'ACC-0000002', 150000.00, 'current', 'active'),
(2, 'ACC-0000003', 50000.00, 'saving', 'active');

INSERT INTO saving_account (account_id, interest_rate, min_balance) VALUES
(1, 5.00, 1000.00),
(3, 4.50, 1000.00);

INSERT INTO current_account (account_id, overdraft_limit, monthly_fee) VALUES
(2, 10000.00, 200.00);

INSERT INTO loan (customer_id, loan_amount, interest_rate, loan_type, start_date, end_date, status) VALUES
(2, 500000.00, 9.5, 'Home Loan', '2024-01-01', '2029-01-01', 'approved');

INSERT INTO payment (loan_id, payment_amount, payment_method, status) VALUES
(1, 10500.00, 'Bank Transfer', 'completed'),
(1, 10500.00, 'Bank Transfer', 'completed');
