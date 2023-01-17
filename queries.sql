--------------------------------------------------------
--  Create a table named ADMIN with its attributes
--------------------------------------------------------

CREATE TABLE ADMIN  (	
"ADMIN_ID" VARCHAR2(10 BYTE), 
"PERSONAL_INFO_ID" VARCHAR2(10 BYTE), 
"ADMIN_PASSWORD" VARCHAR2(20 BYTE))

--------------------------------------------------------
--  Show each doctor name, gender, age and the total number of patient they had diagnosed in ascending order based on number of patient diagnosed
--------------------------------------------------------

SELECT DOCTOR.DOCTOR_ID, NAME, GENDER, AGE, COUNT(PATIENT_ID) AS "NUMBER OF PATIENTS DIAGNOSED" FROM DOCTOR 
INNER JOIN PERSONAL_INFO ON DOCTOR.PERSONAL_INFO_ID = PERSONAL_INFO.PERSONAL_INFO_ID 
INNER JOIN MEDICAL_RECORD ON DOCTOR.DOCTOR_ID = MEDICAL_RECORD.DOCTOR_ID 
GROUP BY DOCTOR.DOCTOR_ID,NAME,GENDER,AGE
ORDER BY COUNT(PATIENT_ID) ASC; 

--------------------------------------------------------
--  Show a list of patient names with their phone number, IC number, age, gender, email and appointment date time who have appointments within a few months (April 2023 to July 2023) in ascending order based on the appointment date. 
--------------------------------------------------------

SELECT NAME, PHONE_NUMBER, IC_NO, AGE, GENDER, EMAIL, APPOINTMENT_DATE_TIME FROM PATIENT INNER JOIN PERSONAL_INFO ON PATIENT.PERSONAL_INFO_ID = PERSONAL_INFO.PERSONAL_INFO_ID 
INNER JOIN APPOINTMENT ON APPOINTMENT.PATIENT_ID = PATIENT.PATIENT_ID
WHERE APPOINTMENT_DATE_TIME > date '2023-4-1' AND APPOINTMENT_DATE_TIME <= date '2023-7-31'
ORDER BY APPOINTMENT_DATE_TIME ASC;

--------------------------------------------------------
--   State all positions of clinic assistant and the number of assistants in each position.
--------------------------------------------------------

SELECT POSITION, COUNT(CLINIC_ASSISTANT_ID) AS "NUMBER OF ASSISTANT" FROM CLINIC_ASSISTANT 
GROUP BY POSITION ;

--------------------------------------------------------
--  Show all patient names, diagnosis, treatment name, treatment period, description, payment amount and date for prescription in descending order based on payment amount.
--------------------------------------------------------

SELECT PERSONAL_INFO.NAME AS "PATIENT NAME", MEDICAL_RECORD.DIAGNOSIS, TREATMENT_NAME, MEDICATION_PERIOD_DAY, DESCRIPTION AS "PRESCRIPTION DESCRIPTION", PAYMENT_AMOUNT, PAYMENT_DATE
FROM MEDICAL_RECORD INNER JOIN DOCTOR ON DOCTOR.DOCTOR_ID = MEDICAL_RECORD.DOCTOR_ID 
INNER JOIN PATIENT ON PATIENT.PATIENT_ID = MEDICAL_RECORD.PATIENT_ID 
INNER JOIN PERSONAL_INFO ON PATIENT.PERSONAL_INFO_ID = PERSONAL_INFO.PERSONAL_INFO_ID
INNER JOIN PERSONAL_INFO ON DOCTOR.PERSONAL_INFO_ID = PERSONAL_INFO.PERSONAL_INFO_ID
INNER JOIN PRESCRIPTION ON PRESCRIPTION.PRESCRIPTION_ID = MEDICAL_RECORD.PRESCRIPTION_ID
INNER JOIN TREATMENT ON TREATMENT.TREATMENT_ID = PRESCRIPTION.TREATMENT_ID 
INNER JOIN PAYMENT ON PAYMENT.PATIENT_ID = PATIENT.PATIENT_ID
INNER JOIN RECEIPT ON PAYMENT.RECEIPT_ID = RECEIPT.RECEIPT_ID
ORDER BY PAYMENT_AMOUNT DESC; 

--------------------------------------------------------
--  Show the medicine name, current quantity of medicine, actual price of medicine, expiry date, remaining day of medicine before expiration from inventory and show the alert message to stock up if the quantity of medicine item is less than 250.
--------------------------------------------------------

SELECT MEDICINE_NAME, INVENTORY_RECORD.QUANTITY AS "CURRENT QUANTITY", ACTUAL_PRICE, ROUND (EXPIRY_DATE - SYSDATE) AS "REMAINING DAY BEFORE EXPIRY",
CASE
    WHEN INVENTORY_RECORD.QUANTITY < 250 THEN 'Alert! The item is less than 250, must stock up soon.'
    ELSE 'No need to stock up.'
END
AS "MESSAGE"
FROM INVENTORY_RECORD 
INNER JOIN MEDICINE_INFO ON INVENTORY_RECORD.MEDICINE_ID = MEDICINE_INFO.MEDICINE_ID

--------------------------------------------------------
--  Search the insurance between different insurance companies that have any different insurance amount that can be claimed, and show the biggest amount of insurance and with the patient name.
--------------------------------------------------------

SELECT NAME, INSURANCE_COMPANY, INSURANCE_AMOUNT AS "BIGGEST INSURANCE AMOUNT", INSURANCE_DATE FROM INSURANCE 
INNER JOIN
(SELECT PERSONAL_INFO.*, PATIENT.PATIENT_ID AS "ID" FROM PATIENT INNER JOIN PERSONAL_INFO ON PATIENT.PERSONAL_INFO_ID = PERSONAL_INFO.PERSONAL_INFO_ID)
ON INSURANCE.PATIENT_ID = "ID"
WHERE INSURANCE_AMOUNT = (SELECT MAX(INSURANCE_AMOUNT) FROM INSURANCE);

--------------------------------------------------------
--  Show all patient names, vaccination type and name received, and vaccination period month.
--------------------------------------------------------

SELECT NAME, VACCINATION_TYPE, VACCINATION_NAME, VACCINATION_PERIOD_MONTH 
FROM (SELECT NAME, PATIENT_ID AS "PATIENT" FROM PATIENT INNER JOIN PERSONAL_INFO ON PATIENT.PERSONAL_INFO_ID = PERSONAL_INFO.PERSONAL_INFO_ID)
INNER JOIN VACCINATION ON VACCINATION.PATIENT_ID = PATIENT;

--------------------------------------------------------
--  Add a new admin from the clinic_assistant with personal_info_id 'PI014'
--------------------------------------------------------

INSERT INTO ADMIN (ADMIN_ID,NAME,PERSONAL_INFO_ID,ADMIN_PASSWORD) 
values ('A006','PI014','admin6dcbivahdsbvfv');

--------------------------------------------------------
--  Update the quantity of a specific medicine item in inventory by medicine ID
--------------------------------------------------------

UPDATE INVENTORY_RECORD
SET QUANTITY = 1000 WHERE MEDICINE_ID = 'M0004';

--------------------------------------------------------
--  Delete a specific admin by admin ID
--------------------------------------------------------

DELETE FROM ADMIN WHERE ADMIN_ID = 'A006';

--------------------------------------------------------
--  Alter the PATIENT table by deleting the COMPANY_NAME attribute.
--------------------------------------------------------

ALTER TABLE PATIENT
DROP COLUMN COMPANY_NAME; 

