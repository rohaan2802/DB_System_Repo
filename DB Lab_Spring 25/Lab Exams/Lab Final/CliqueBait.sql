-- Create the Clique Bait database
CREATE DATABASE CliqueBait;
GO

USE CliqueBait;
GO

-- Create Campaign_identifier table
CREATE TABLE Campaign_identifier (
    campaign_id INT PRIMARY KEY,
    products VARCHAR(50) NOT NULL,
    campaign_name VARCHAR(100) NOT NULL,
    start_date DATETIME2 NOT NULL,
    end_date DATETIME2 NOT NULL
);
GO

-- Create Event_identifier table
CREATE TABLE Event_identifier (
    event_type INT PRIMARY KEY,
    event_name VARCHAR(50) NOT NULL
);
GO

-- Create Page_hierarchy table
CREATE TABLE Page_hierarchy (
    page_id INT PRIMARY KEY,
    page_name VARCHAR(50) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    product_id INT NOT NULL
);
GO

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    cookie_id VARCHAR(50) NOT NULL UNIQUE,
    start_date DATETIME2 NOT NULL
);
GO

-- Create Events table
CREATE TABLE Events (
    visit_id INT PRIMARY KEY,
    cookie_id VARCHAR(50) NOT NULL,
    page_id INT NOT NULL,
    event_type INT NOT NULL,
    sequence_number INT NOT NULL,
    event_time DATETIME2 NOT NULL,
    CONSTRAINT FK_Events_Users FOREIGN KEY (cookie_id) REFERENCES Users(cookie_id),
    CONSTRAINT FK_Events_Page_hierarchy FOREIGN KEY (page_id) REFERENCES Page_hierarchy(page_id),
    CONSTRAINT FK_Events_Event_identifier FOREIGN KEY (event_type) REFERENCES Event_identifier(event_type)
);
GO

-- Create UserStartDateLog table (for UpdateUserCookieStartDateSafely)
CREATE TABLE UserStartDateLog (
    CookieID VARCHAR(50),
    OldStartDate DATETIME2,
    AttemptedStartDate DATETIME2,
    LogTime DATETIME2 DEFAULT SYSDATETIME(),
    Reason VARCHAR(100),
    PRIMARY KEY (CookieID, LogTime),
    CONSTRAINT FK_UserStartDateLog_Users FOREIGN KEY (CookieID) REFERENCES Users(cookie_id)
);
GO

-- Create user_audit_log table (for trigger)
CREATE TABLE user_audit_log (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    old_start_date DATETIME2,
    new_start_date DATETIME2,
    change_time DATETIME2 DEFAULT SYSDATETIME(),
    operation VARCHAR(55),
    CONSTRAINT FK_user_audit_log_Users FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
GO

-- Insert sample data into Campaign_identifier
INSERT INTO Campaign_identifier (campaign_id, products, campaign_name, start_date, end_date)
VALUES 
(1, 'Lobster', 'Summer Seafood', '2025-01-01 00:00:00', '2025-12-31 23:59:59'),
(2, 'Salmon', 'Winter Fish Fest', '2025-02-01 00:00:00', '2025-06-30 23:59:59');
GO

-- Insert sample data into Event_identifier
INSERT INTO Event_identifier (event_type, event_name)
VALUES 
(1, 'page_view'),
(2, 'purchase'),
(3, 'add_to_cart'),
(4, 'view_campaign');
GO

-- Insert sample data into Page_hierarchy
INSERT INTO Page_hierarchy (page_id, page_name, product_category, product_id)
VALUES 
(1, 'Lobster Page', 'Seafood', 101),
(2, 'Crab Page', 'Seafood', 102),
(3, 'Salmon Page', 'Fish', 103),
(4, 'Tuna Page', 'Fish', 104);
GO

-- Insert sample data into Users
INSERT INTO Users (user_id, cookie_id, start_date)
VALUES 
(1, 'user123', '2025-01-11 00:00:00'),
(2, 'user456', '2025-01-01 00:00:00'),
(3, 'user789', '2025-02-01 00:00:00');
GO

-- Insert sample data into Events
INSERT INTO Events (visit_id, cookie_id, page_id, event_type, sequence_number, event_time)
VALUES 
(1, 'user123', 1, 1, 1, '2025-01-02 10:00:00'), -- page_view on Lobster
(2, 'user123', 1, 2, 2, '2025-01-02 10:05:00'), -- purchase on Lobster
(3, 'user456', 2, 1, 1, '2025-01-02 11:00:00'), -- page_view on Crab
(4, 'user456', 2, 3, 2, '2025-01-02 11:10:00'), -- add_to_cart on Crab
(5, 'user123', 3, 1, 3, '2025-01-02 10:15:00'), -- page_view on Salmon
(6, 'user456', 1, 2, 3, '2025-01-02 11:15:00'), -- purchase on Lobster
(7, 'user789', 4, 1, 1, '2025-02-02 09:00:00'), -- page_view on Tuna
(8, 'user789', 4, 4, 2, '2025-02-02 09:05:00'); -- view_campaign on Tuna
