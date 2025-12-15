CREATE SCHEMA Pharmacy;

SET search_path TO Pharmacy;

-- Create Supplier table first, since other tables depend on it
CREATE TABLE Supplier (
    id_supplier INT PRIMARY KEY,
    name VARCHAR(255),
    contacts VARCHAR(255),
    edrpou_code VARCHAR(20)
);

-- Create Pharmacy table next
CREATE TABLE Pharmacy (
    id_pharmacy INT PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255)
);

-- Create Customer table
CREATE TABLE Customer (
    id_customer INT PRIMARY KEY,
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    gender VARCHAR(50),
    age INT,
    phone VARCHAR(20)
);

-- Create Employee table
CREATE TABLE Employee (
    id_employee INT PRIMARY KEY,
    last_name VARCHAR(255),
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    gender VARCHAR(50),
    age INT,
    phone VARCHAR(20)
);

-- Create Prescription table
CREATE TABLE Prescription (
    id_prescription INT PRIMARY KEY,
    number VARCHAR(50),
    doctor VARCHAR(255),
    issue_date DATE
);

-- Create Product table which references Supplier
CREATE TABLE Product (
    id_product INT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(255),
    manufacturer VARCHAR(255),
    dosage_form VARCHAR(255),
    price DECIMAL(10, 2),
    id_supplier INT,
    FOREIGN KEY (id_supplier) REFERENCES Supplier(id_supplier)
);

-- Create Receipt table, no references to Sale; it's only for the id_receipt
CREATE TABLE Receipt (
    id_receipt INT PRIMARY KEY
);

-- Create Sale table which references Pharmacy, Customer, Employee, Prescription, and Receipt
CREATE TABLE Sale (
    id_sale INT PRIMARY KEY,
    date_time TIMESTAMP,
    payment_type VARCHAR(50),
    id_pharmacy INT,
    id_customer INT,
    id_employee INT,
    id_prescription INT,
    id_receipt INT,
    FOREIGN KEY (id_pharmacy) REFERENCES Pharmacy(id_pharmacy),
    FOREIGN KEY (id_customer) REFERENCES Customer(id_customer),
    FOREIGN KEY (id_employee) REFERENCES Employee(id_employee),
    FOREIGN KEY (id_prescription) REFERENCES Prescription(id_prescription),
    FOREIGN KEY (id_receipt) REFERENCES Receipt(id_receipt)
);

-- Create Receipt_Item table which references Product and Receipt
CREATE TABLE Receipt_Item (
    id_item INT PRIMARY KEY,
    quantity INT,
    id_product INT,
    id_receipt INT,
    FOREIGN KEY (id_product) REFERENCES Product(id_product),
    FOREIGN KEY (id_receipt) REFERENCES Receipt(id_receipt)
);

-- Create Work_Schedule table which references Employee
CREATE TABLE Work_Schedule (
    id_work INT PRIMARY KEY,
    id_employee INT,
    work_date DATE,
    hours_worked DECIMAL(5, 2),  -- Added column for hours worked
    FOREIGN KEY (id_employee) REFERENCES Employee(id_employee)
);

