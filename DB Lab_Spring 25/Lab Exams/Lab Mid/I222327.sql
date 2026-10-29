-- QUERY #02
SELECT * 
FROM Staff 
WHERE RIGHT(FirstName, 1) = RIGHT(LastName, 1);




--QUERY #06

SELECT * 
FROM patients 
WHERE LEN(FirstName) >= 3 
AND SUBSTRING(FirstName, LEN(FirstName)-1, 1) = 'V'




-- QUERY #01

CREATE VIEW DoctorAppointmentView AS
SELECT    d.DoctorID,  CONCAT(d.FirstName, d.LastName) AS dn,  d.specialization,  COUNT(a.AppointmentID) AS ta
FROM doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName, d.specialization

DROP VIEW DoctorAppointmentView





--QUERY #04

SELECT * 
FROM Admissions	 
WHERE  DischargeDate IS NOT NULL;



--QUERY #05

SELECT *  
FROM staff s1  
WHERE EXISTS (  
    SELECT 1  
    FROM staff s2  
    WHERE s1.FirstName = s2.FirstName  
    AND s1.role = s2.role  
    AND s1.StaffID <> s2.StaffID  
);









--QUERY #03
SELECT   p.PatientID, p.FirstName AS P1, a.AppointmentID,  a.AppointmentDate,  UPPER(LEFT(d.LastName, 3)) AS dl
FROM patients p
JOIN Appointments a ON p.PatientID = a.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate DESC;


--QUERY #09

SELECT * 
FROM Patients 
WHERE DOB = (SELECT MIN(DOB) FROM Patients);


--QUERY #08
SELECT  p.PatientID,  p.FirstName,p.LastName, COUNT(a.AppointmentID) AS a
FROM Patients p
LEFT JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.FirstName,P.LastName



--QUERY #07

SELECT 
    p.PatientID, p.FirstName,P.LastName,  COUNT(a.AppointmentID) AS ta,   SUM(DATEDIFF(DAY,a.DischargeDate, a.AdmissionDate)) AS td
FROM Patients p
JOIN Appointments a ON p.PatientID = a.PatientID
WHERE a.RoomType IN ('Private', 'ICU')
GROUP BY p.PatientID, p.FirstName,P.LastName
HAVING COUNT(a.AppointmentID) > 1;
