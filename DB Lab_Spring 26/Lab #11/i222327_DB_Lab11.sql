-- ABC Super Store SQL Schema
-- Retail Super Store case study

DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS purchase_order_item;
DROP TABLE IF EXISTS purchase_order;
DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS customer_order;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS shipper;

CREATE TABLE supplier (
    supplier_id      INT PRIMARY KEY,
    supplier_name    VARCHAR(100) NOT NULL UNIQUE,
    contact_person   VARCHAR(100),
    phone            VARCHAR(20) UNIQUE,
    email            VARCHAR(120) UNIQUE,
    address          VARCHAR(255)
);

CREATE TABLE category (
    category_id      INT PRIMARY KEY,
    category_name    VARCHAR(100) NOT NULL UNIQUE,
    description      VARCHAR(255)
);

CREATE TABLE product (
    product_id       INT PRIMARY KEY,
    product_name     VARCHAR(120) NOT NULL,
    category_id      INT NOT NULL,
    supplier_id      INT NOT NULL,
    unit_price       DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_qty        INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    reorder_level    INT NOT NULL DEFAULT 0 CHECK (reorder_level >= 0),
    unit             VARCHAR(30),
    CONSTRAINT uq_product_name_supplier UNIQUE (product_name, supplier_id),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES category(category_id),
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE customer (
    customer_id       INT PRIMARY KEY,
    customer_name     VARCHAR(120) NOT NULL,
    phone             VARCHAR(20) UNIQUE,
    email             VARCHAR(120) UNIQUE,
    address           VARCHAR(255),
    registration_date DATE NOT NULL,
    status            VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT ck_customer_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE employee (
    employee_id       INT PRIMARY KEY,
    employee_name     VARCHAR(120) NOT NULL,
    designation       VARCHAR(60) NOT NULL,
    phone             VARCHAR(20) UNIQUE,
    email             VARCHAR(120) UNIQUE,
    hire_date         DATE NOT NULL,
    salary            DECIMAL(12,2) CHECK (salary >= 0)
);

CREATE TABLE shipper (
    shipper_id        INT PRIMARY KEY,
    shipper_name      VARCHAR(120) NOT NULL UNIQUE,
    phone             VARCHAR(20) UNIQUE,
    email             VARCHAR(120) UNIQUE
);

CREATE TABLE customer_order (
    order_id          INT PRIMARY KEY,
    customer_id       INT NOT NULL,
    employee_id       INT NOT NULL,
    order_date        DATE NOT NULL,
    order_method      VARCHAR(20) NOT NULL,
    order_status      VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    total_amount      DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    CONSTRAINT ck_order_method
        CHECK (order_method IN ('PHONE', 'FAX', 'EMAIL')),
    CONSTRAINT ck_order_status
        CHECK (order_status IN ('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_order_employee
        FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE order_item (
    order_id          INT NOT NULL,
    product_id        INT NOT NULL,
    quantity          INT NOT NULL CHECK (quantity > 0),
    unit_price        DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    discount_percent  DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (discount_percent >= 0 AND discount_percent <= 100),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id) REFERENCES customer_order(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE purchase_order (
    purchase_id       INT PRIMARY KEY,
    supplier_id       INT NOT NULL,
    employee_id       INT NOT NULL,
    purchase_date     DATE NOT NULL,
    status            VARCHAR(20) NOT NULL DEFAULT 'ORDERED',
    total_cost        DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total_cost >= 0),
    CONSTRAINT ck_purchase_status
        CHECK (status IN ('ORDERED', 'RECEIVED', 'CANCELLED')),
    CONSTRAINT fk_purchase_supplier
        FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    CONSTRAINT fk_purchase_employee
        FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE TABLE purchase_order_item (
    purchase_id       INT NOT NULL,
    product_id        INT NOT NULL,
    quantity          INT NOT NULL CHECK (quantity > 0),
    cost_price        DECIMAL(10,2) NOT NULL CHECK (cost_price >= 0),
    PRIMARY KEY (purchase_id, product_id),
    CONSTRAINT fk_purchaseitem_purchase
        FOREIGN KEY (purchase_id) REFERENCES purchase_order(purchase_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_purchaseitem_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE shipment (
    shipment_id       INT PRIMARY KEY,
    order_id          INT NOT NULL UNIQUE,
    shipper_id        INT NOT NULL,
    employee_id       INT NOT NULL,
    shipment_date     DATE,
    delivery_date     DATE,
    shipment_status   VARCHAR(20) NOT NULL DEFAULT 'BOOKED',
    tracking_no       VARCHAR(50) UNIQUE,
    CONSTRAINT ck_shipment_status
        CHECK (shipment_status IN ('BOOKED', 'IN_TRANSIT', 'DELIVERED', 'RETURNED')),
    CONSTRAINT ck_delivery_dates
        CHECK (delivery_date IS NULL OR shipment_date IS NULL OR delivery_date >= shipment_date),
    CONSTRAINT fk_shipment_order
        FOREIGN KEY (order_id) REFERENCES customer_order(order_id),
    CONSTRAINT fk_shipment_shipper
        FOREIGN KEY (shipper_id) REFERENCES shipper(shipper_id),
    CONSTRAINT fk_shipment_employee
        FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);
