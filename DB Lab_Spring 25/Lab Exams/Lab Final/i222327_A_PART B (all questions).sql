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



-- PART B ----> Q#01 (PART#01) SOLUTION



CREATE TABLE UserStartDateLog (
CookieID VARCHAR(50),
OldStartDate DATETIME2,
AttemptedStartDate DATETIME2,
LogTime DATETIME,
Reason VARCHAR(100),
PRIMARY KEY (CookieID, LogTime),
FOREIGN KEY (CookieID) REFERENCES Users(cookie_id) ON DELETE CASCADE
);
GO

CREATE PROCEDURE UpdateUserCookieStartDateSafely
@cookie_id VARCHAR(50),
@new_start_time DATETIME
AS
BEGIN    
DECLARE @current_start_date DATETIME2;
DECLARE @Message VARCHAR(200);
DECLARE @Reason VARCHAR(100);
    
BEGIN TRY
SELECT @current_start_date = start_date
FROM Users
WHERE cookie_id = @cookie_id;
        
IF @current_start_date IS NULL
BEGIN
SET @Reason = 'Cookie ID does not exist';
INSERT INTO UserStartDateLog (CookieID, OldStartDate, AttemptedStartDate, Reason)
VALUES (@cookie_id, NULL, @new_start_time, @Reason);
SET @Message = 'Update rejected: ' + @Reason;
SELECT @Message AS Result;
RETURN;
   
END
        
IF ABS(DATEDIFF(DAY, @current_start_date, @new_start_time)) <= 30
BEGIN
UPDATE Users
SET start_date = @new_start_time
WHERE cookie_id = @cookie_id;
SET @Message = 'Start date updated ' + @cookie_id;
SELECT @Message AS Result;
END
ELSE
BEGIN
SET @Reason = 'Date change exceeds 30 days limit';
INSERT INTO UserStartDateLog (CookieID, OldStartDate, AttemptedStartDate, Reason)
VALUES (@cookie_id, @current_start_date, @new_start_time, @Reason);
SET @Message = 'Update rejected: ' + @Reason;
SELECT @Message AS Result;
END
    END TRY
BEGIN CATCH

END CATCH
END;
GO


EXEC UpdateUserCookieStartDateSafely ;
GO

drop procedure UpdateUserCookieStartDateSafely

drop table UserStartDateLog

-- PART B ----> Q#01 (PART#02) SOLUTION

CREATE PROCEDURE GetCampaignPeriod
@CampaignID INT,@StartDate DATETIME OUTPUT, @EndDate DATETIME OUTPUT
AS
BEGIN
SELECT @StartDate = start_date, @EndDate = end_date
FROM Campaign_identifier
WHERE campaign_id = @CampaignID;
END;
GO

CREATE PROCEDURE GenerateUserActivityReport
@CampaignID INT
AS
BEGIN
DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

EXEC GetCampaignPeriod @CampaignID, @StartDate OUTPUT, @EndDate OUTPUT;

IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
BEGIN
SELECT 
u.user_id,
u.cookie_id,
COUNT(e.visit_id) AS total_events,
SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS total_page_views,
SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS total_purchases,
@StartDate AS campaign_start,
@EndDate AS campaign_end
FROM Users u
LEFT JOIN Events e ON u.cookie_id = e.cookie_id
AND e.event_time BETWEEN @StartDate AND @EndDate
WHERE EXISTS (
SELECT 1
FROM Events e2
JOIN Page_hierarchy ph ON e2.page_id = ph.page_id
JOIN Campaign_identifier ci ON ph.product_id = ci.campaign_id
WHERE e2.cookie_id = u.cookie_id
AND ci.campaign_id = @CampaignID
)
GROUP BY u.user_id, u.cookie_id;
END
END;
GO

-- Test GenerateUserActivityReport
EXEC GenerateUserActivityReport @CampaignID = 1;
GO

drop procedure GenerateUserActivityReport

drop procedure GetCampaignPeriod



-- PART B ----> Q#02 SOLUTION

CREATE FUNCTION fn_AvgEventsPerUserByCategory (@product_category VARCHAR(50))
RETURNS DECIMAL(10, 2)
AS
BEGIN
DECLARE @total_events INT;
DECLARE @total_users INT;
DECLARE @avg_events DECIMAL(10, 2);


SELECT @total_events = COUNT(e.visit_id)
FROM Events e
JOIN Page_hierarchy ph ON e.page_id = ph.page_id
JOIN Users u ON e.cookie_id = u.cookie_id
WHERE ph.product_category = @product_category;


SELECT @total_users = COUNT(DISTINCT u.user_id)
FROM Users u
JOIN Events e ON u.cookie_id = e.cookie_id
JOIN Page_hierarchy ph ON e.page_id = ph.page_id
WHERE ph.product_category = @product_category;

SET @avg_events = CASE WHEN @total_users = 0 THEN 0 ELSE CAST(@total_events AS DECIMAL(10, 2)) / @total_users END;

RETURN @avg_events;
END;
GO

-- Test the function
SELECT dbo.fn_AvgEventsPerUserByCategory('Seafood') AS avg_events_per_user;
SELECT dbo.fn_AvgEventsPerUserByCategory('Fish') AS avg_events_per_user;
GO

drop function fn_AvgEventsPerUserByCategory



-- PART B ----> Q#03 SOLUTION

CREATE TRIGGER trg_UpdateUserStartDate
ON Users
AFTER UPDATE
AS
BEGIN
IF UPDATE(start_date)
BEGIN
INSERT INTO user_audit_log (user_id, old_start_date, new_start_date, operation)
SELECT d.user_id,d.start_date,i.start_date,'UPDATE'
FROM deleted d
INNER JOIN inserted i ON d.user_id = i.user_id;
END

END;
GO

-- Test the trigger
BEGIN TRANSACTION;
UPDATE Users
SET start_date = '2025-06-15 12:00:00'
WHERE user_id = 1;
ROLLBACK;
GO


DROP TRIGGER trg_UpdateUserStartDate