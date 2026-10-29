-- Create the Clique Bait database
CREATE DATABASE [Data Intelligence and Analytics Hub];
GO

USE [Data Intelligence and Analytics Hub];
GO


-- PART A ----> Q#01 SOLUTION

-- Create Researchers table
CREATE TABLE Researchers (
    researcher_id INT IDENTITY(1,1) PRIMARY KEY,
    researcher_name VARCHAR(55),
    researcher_email VARCHAR(55),
    researcher_phone VARCHAR(55),
    researcher_areaof_experience VARCHAR(55),
);
GO


-- Create Projects table
CREATE TABLE Projects (
    project_id INT IDENTITY(1,1) PRIMARY KEY,
    project_title VARCHAR(55),
    project_description VARCHAR(55),
    start_date DATE ,
    end_date DATE,
    funding_source VARCHAR(55)
);
GO


-- Create Datasets table
CREATE TABLE Datasets (
    Dataset_id INT IDENTITY(1,1) PRIMARY KEY,
    Dataset_name VARCHAR(55),
    Dataset_description VARCHAR(55),
    source VARCHAR(55),
	size INT
);
GO



-- Create Results table
CREATE TABLE Results (
    result_id INT IDENTITY(101,1) PRIMARY KEY,
    result_description VARCHAR(55),
    metrics VARCHAR(55),
	insights VARCHAR(55)
);
GO



-- Create Project_Researcher table
CREATE TABLE Project_Researcher (
    project_id INT  ,
    researcher_id INT,
	FOREIGN KEY(project_id) REFERENCES Projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY(researcher_id) REFERENCES Researchers(researcher_id)  ON DELETE CASCADE,
);
GO



-- Create Project_Dataset table
CREATE TABLE Project_Dataset (
    project_id INT  ,
    dataset_id INT,
	FOREIGN KEY(project_id) REFERENCES Projects(project_id)  ON DELETE CASCADE,
    FOREIGN KEY(dataset_id) REFERENCES Datasets(dataset_id)  ON DELETE CASCADE,
);
GO



-- Create Project_Result table
CREATE TABLE Project_Result (
    project_id INT  ,
    result_id INT,
	FOREIGN KEY(project_id) REFERENCES Projects(project_id)  ON DELETE CASCADE,
    FOREIGN KEY(result_id) REFERENCES Results(result_id)  ON DELETE CASCADE,
);
GO


-- PART A ----> Q#02 SOLUTION


-- Insert sample data into Researchers
INSERT INTO Researchers ( researcher_name, researcher_email, researcher_phone, researcher_areaof_experience)
VALUES 
( 'Ali Zafar', 'ali.zafar@nu.edu.pk', '111111111111', 'Data Mining'),
( 'Sara Khan', 'sara.khan@nu.edu.pk', '222222222222', 'Vision Systems'),
('Hamza Noor', 'hamza.noor@nu.edu.pk', '33333333333', 'Data Streams'),
( 'Rabia Shiekh', 'rabia.shiekh@nu.edu.pk', '444444444444', 'Image Procssing'), 
( 'Umar Shiekh', 'umar.shiekh@nu.edu.pk', '555555555555', 'IoT');
GO



-- Insert sample data into Projects
INSERT INTO Projects ( project_title, project_description, start_date,end_date,funding_source)
VALUES 
( 'Data Lake Exploration', 'Explore large-scale data lakes', '2021-01-01', '2022-12-31','Intel'),
( 'Data Stream Mining', 'Real-time stream processing', '2020-03-15','2023-05-30','Intel'),
( 'Image Analysis', 'Medical image segmentation', '2022-01-10', '2022-06-10','HealthOrg'),
( 'Smart Systems', 'IoT-based automation', '2021-02-01', '2021-08-01','TechWave'),
( 'DATA Vision Model', 'Computer vision model for documents', '2021-07-01', '2022-10-01','Intel');
GO


-- Insert sample data into Datasets
INSERT INTO Datasets ( Dataset_name, Dataset_description, source,size)
VALUES 
( 'eHealth', 'Electronic health records', 'Hospital', '200'),
( 'aEnergy', 'Energy grid usage', 'Utility', '300'),
( 'eRetail', 'Retail transaction logs', 'Retailer', '250'),
( 'iSurvey', 'Survey respinses', 'Research Lab', '150'),
( 'eMarket', 'E-commerece datasets', 'Vendor', '400')
GO

-- Insert sample data into Results
INSERT INTO Results ( result_description, metrics, insights)
VALUES 
( 'Clustering Report', 'Silhoutte Score', 'Good sepration'),
( 'Regression Eval',  'MAE, RMSE', 'error within range'),
( 'Classification Output', 'Accuracy, F1', 'Acceptable'),
( 'Image Metrics', 'IoU, Dice', 'High accuracy'),
( 'Text Summary', 'Precision/Recall', 'Balanced results')
GO


-- Insert sample data into Project_Researcher
INSERT INTO Project_Researcher ( project_id, researcher_id)
VALUES 
( 1,1),
( 1,3),
( 2,1),
( 2,2),
( 2,3),
(4,5),
(5,4)
GO


-- Insert sample data into Project_Dataset
INSERT INTO Project_Dataset ( project_id, dataset_id)
VALUES 
( 1,1),
( 1,3),
( 2,5),
( 3,2),
( 4,4),
(5,1)
GO



-- Insert sample data into Project_Result
INSERT INTO Project_Result ( project_id, result_id)
VALUES 
( 1,101),
( 1,102),
( 2,103),
( 2,104),
( 5,105)
GO


-- PART A ----> Q#03 SOLUTION

-- Query #01
SELECT TOP 1 *
FROM (
SELECT TOP 2 project_id, project_title, project_description, start_date, end_date, funding_source, DATEDIFF(DAY, start_date, end_date) AS duration
FROM Projects
ORDER BY DATEDIFF(DAY, start_date, end_date) DESC
) AS second_longest
ORDER BY duration;
GO

-- Query #02
CREATE VIEW project_details
AS
SELECT 
UPPER(REPLACE(project_title, ' ', '')) AS PT,
YEAR(start_date) AS StartYear,
FORMAT(end_date, 'MMMM dd, yyyy') AS end_date
FROM Projects
WHERE YEAR(end_date) != YEAR(GETDATE()) AND funding_source IS NOT NULL;
GO

-- Query #03
SELECT project_id, project_title, funding_source
FROM Projects p1
WHERE DATEDIFF(DAY, start_date, end_date) > ALL (
SELECT DATEDIFF(DAY, start_date, end_date)
FROM Projects p2
WHERE p2.funding_source = p1.funding_source
AND p2.project_id != p1.project_id
);
GO

-- Query #04
SELECT project_id, project_title, funding_source
FROM Projects
WHERE project_title LIKE '%data%'
GROUP BY project_id, project_title, funding_source
HAVING COUNT(*) >= 2;
GO

-- Query #05
SELECT UPPER(p.project_title) AS ProjectTitle,UPPER(d.dataset_name) AS dataset_title, d.size
FROM Projects p
JOIN Project_Dataset pd ON p.project_id = pd.project_id
JOIN Datasets d ON pd.dataset_id = d.dataset_id
WHERE d.dataset_name LIKE '_e%'
ORDER BY d.dataset_name DESC;
GO

-- Query #06
SELECT p.project_id,p.project_title,COUNT(pr.result_id) AS TotalResults,COUNT(DISTINCT prr.researcher_id) AS DistinctResearchers
FROM Projects p
LEFT JOIN Project_Result pr ON p.project_id = pr.project_id
LEFT JOIN Project_Researcher prr ON p.project_id = prr.project_id
WHERE p.start_date < '2023-01-01'
GROUP BY p.project_id, p.project_title
HAVING COUNT(pr.result_id) > 1;
GO