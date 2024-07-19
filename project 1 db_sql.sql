-- CREATING DATABASE STRUCTURE
---------------------------------

-- Create Database
CREATE DATABASE COMP_ENG_DEPT;

-- Connect to the Database
\C COMP_ENG_DEPT;

-- Create Schemas
CREATE SCHEMA ADMIN;

CREATE SCHEMA STUDENT;

CREATE SCHEMA STAFF;

-- Create Admin Data Table
CREATE TABLE ADMIN.ADMIN_DATA (
    ID SERIAL PRIMARY KEY,
    FNAME VARCHAR(255) NOT NULL,
    LNAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD VARCHAR(255) NOT NULL
);

-- Create Course Data Table
CREATE TABLE STUDENT.COURSE_DATA (
    ID SERIAL PRIMARY KEY,
    COURSE_ID VARCHAR(50) UNIQUE NOT NULL,
    NAME VARCHAR(255) NOT NULL
);

-- Create the course_enrollment table
CREATE TABLE STUDENT.COURSE_ENROLLMENT (
    ID SERIAL PRIMARY KEY,
    STUDENT_ID VARCHAR(50) REFERENCES STUDENT.STUDENT_DATA(STUDENT_ID),
    COURSE_ID VARCHAR(50) REFERENCES STUDENT.COURSE_DATA(COURSE_ID)
);

-- Create Student Data Table
CREATE TABLE STUDENT.STUDENT_DATA (
    ID SERIAL PRIMARY KEY,
    STUDENT_ID VARCHAR(50) UNIQUE NOT NULL,
    FNAME VARCHAR(255) NOT NULL,
    LNAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD VARCHAR(255) NOT NULL,
    ISTA BOOLEAN DEFAULT FALSE
);

-- Create Payment Table
CREATE TABLE STUDENT.PAYMENT (
    ID SERIAL PRIMARY KEY,
    STUDENT_ID VARCHAR(50) REFERENCES STUDENT.STUDENT_DATA(STUDENT_ID),
    PAYED_AMOUNT DECIMAL(10, 2) NOT NULL,
    DATE DATE NOT NULL
);

-- Create Account Table
CREATE TABLE STUDENT.ACCOUNT (
    ID SERIAL PRIMARY KEY,
    STUDENT_ID VARCHAR(50) REFERENCES STUDENT.STUDENT_DATA(STUDENT_ID),
    ACCOUNT_BALANCE DECIMAL(10, 2) NOT NULL
);

-- Create Staff Data Table
CREATE TABLE STAFF.STAFF_DATA (
    ID SERIAL PRIMARY KEY,
    FNAME VARCHAR(255) NOT NULL,
    LNAME VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD VARCHAR(255) NOT NULL
);

-- Create Lecture Assignment Table
CREATE TABLE STAFF.LECTURE_ASSIGNMENT (
    ID SERIAL PRIMARY KEY,
    STAFF_ID INTEGER REFERENCES STAFF.STAFF_DATA(ID),
    COURSE_ID VARCHAR(50) REFERENCES STUDENT.COURSE_DATA(COURSE_ID)
);

-- DROP TABLE IF EXISTS student.ta_assignment;
-- Create TA Assignment Table
CREATE TABLE STUDENT.TA_ASSIGNMENT (
    ID SERIAL PRIMARY KEY,
    LECTURE_ID INTEGER REFERENCES STAFF.LECTURE_ASSIGNMENT(ID),
    STUDENT_ID VARCHAR(50) REFERENCES STUDENT.STUDENT_DATA(STUDENT_ID)
);

-- CREATING DATABASE FUNCTIONS AND TRIGGERS
-----------------------------------------

-- TRIGGER TO ASSIGN GRADES BASED ON MARKS
CREATE OR REPLACE FUNCTION set_grade()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.marks >= 80 THEN
        NEW.grade := 'A+';
    ELSIF NEW.marks >= 75 THEN
        NEW.grade := 'A';
    ELSIF NEW.marks >= 70 THEN
        NEW.grade := 'B+';
    ELSIF NEW.marks >= 65 THEN
        NEW.grade := 'B';
    ELSIF NEW.marks >= 60 THEN
        NEW.grade := 'C+';
    ELSIF NEW.marks >= 55 THEN
        NEW.grade := 'C';
    ELSIF NEW.marks >= 50 THEN
        NEW.grade := 'D+';
    ELSIF NEW.marks >= 45 THEN
        NEW.grade := 'D';
    ELSIF NEW.marks >= 40 THEN
        NEW.grade := 'E';
    ELSE
        NEW.grade := 'F';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER grade_trigger
BEFORE INSERT OR UPDATE ON student.course_enrollment
FOR EACH ROW
EXECUTE FUNCTION set_grade();



-- Create Function to Calculate Outstanding Fees for a Specific Student
CREATE OR REPLACE FUNCTION calculate_outstanding_fees(student_id_input VARCHAR)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    WITH fee_data AS (
        SELECT
            sd.student_id,
            sd.fname,
			sd.lname,
            a.account_balance,
            COALESCE(SUM(p.payed_amount), 0) AS total_payed_amount
        FROM
            student.student_data sd
        LEFT JOIN
            student.payment p ON sd.student_id = p.student_id
        LEFT JOIN
            student.account a ON sd.student_id = a.student_id
        WHERE
            sd.student_id = student_id_input
        GROUP BY
            sd.student_id, sd.fname, sd.lname, a.account_balance
    )
    SELECT JSON_BUILD_OBJECT(
            'student_id', fd.student_id,
            'fname', fd.fname,
			'lname', fd.lname,
            'outstanding_fees', fd.account_balance - fd.total_payed_amount
    ) INTO result
    FROM fee_data fd;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Example usage
SELECT calculate_outstanding_fees('11238012');

-- Trigger Function to update Account Balance
CREATE OR REPLACE FUNCTION admin.update_account_balance()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the account balance after a payment is made
    UPDATE student.account
    SET account_balance = account_balance - NEW.payed_amount
    WHERE student_id = NEW.student_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger on student.payment table
-- Create Trigger on student.payment Table
CREATE TRIGGER payment_after_insert
AFTER INSERT ON student.payment
FOR EACH ROW
EXECUTE FUNCTION admin.update_account_balance();

-- Create Function to Authenticate User Login
CREATE OR REPLACE FUNCTION student.auth_student_login(
    user_identifier VARCHAR,
    user_password VARCHAR
)
RETURNS BOOLEAN AS $$
DECLARE
    authenticated BOOLEAN := FALSE;
BEGIN
    -- Check authentication using student_id
	SELECT FALSE INTO authenticated;
    SELECT TRUE INTO authenticated
    FROM student.student_data
    WHERE (student_id = user_identifier OR email = user_identifier) AND password = user_password;
    RETURN authenticated;
END;
$$ LANGUAGE plpgsql;

-- USE CASE for AUTH
SELECT student.auth_student_login('11238011','passwrd11238011')

-- Function to get Details for Dashboard
CREATE OR REPLACE FUNCTION student.dashDetails(student_id_input VARCHAR)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT JSON_BUILD_OBJECT(
        'fname', sd.fname,
        'lname', sd.lname,
        'student_id', sd.student_id,
        'account_balance', COALESCE(a.account_balance, 0)
    ) INTO result
    FROM student.student_data sd
    LEFT JOIN student.account a ON sd.student_id = a.student_id
    WHERE sd.student_id = student_id_input;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Example usage
SELECT student.dashDetails('11238011');

-- courseEnroll function to get courses enrolled
CREATE OR REPLACE FUNCTION student.courseEnroll(student_id_input VARCHAR)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT JSON_AGG(JSON_BUILD_OBJECT(
        'course_id', cd.course_id,
        'course_name', cd.name,
        'credit_hour', cd.credit_hour,
        'staff_fname', st.fname,
        'staff_lname', st.lname,
        'TA_name', (SELECT CONCAT(ta.fname, ' ', ta.lname) 
                    FROM student.student_data ta
                    WHERE ta.student_id = t.student_id),
        'grade', ce.grade
    )) INTO result
    FROM student.course_enrollment ce
    JOIN student.course_data cd ON ce.course_id = cd.course_id
    LEFT JOIN staff.lecture_assignment la ON la.course_id = ce.id
    LEFT JOIN staff.staff_data st ON la.staff_id = st.id
    LEFT JOIN student.ta_assignment t ON t.lecture_id = la.id
    WHERE ce.student_id = student_id_input;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Example usage
SELECT student.courseEnroll('11238011');

-- FUNCTION TO CHECK TA STATUS
CREATE OR REPLACE FUNCTION student.isTA(student_id VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    is_ta BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM student.student_data WHERE student.student_data.student_id = sid) INTO is_ta;
    RETURN is_ta;
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT student.isTA("11238011");

-- FUNCTION TO GET CLASSLIST
CREATE OR REPLACE FUNCTION staff.getClasslist(lecture_assignment_id INT)
RETURNS JSON AS $$
BEGIN
    RETURN (
SELECT json_build_object(
            'course_data', json_build_object(
                'course_code', c.course_id,
                'course_name', c.name
            ),
            'lecturer_data', json_build_object(
                'fname', l.fname,
                'lname', l.lname,
                'email', l.email
            ),
            'ta_data', json_agg(
                json_build_object(
                    'id', s.student_id,
                    'fname', s.fname,
                    'lname', s.lname,
                    'email', s.email
                )
            ),
            'student_data', (SELECT json_agg(
                 json_build_object(
                    'fname', st.fname,
                    'lname', st.lname,
                    'student_id', st.student_id,
                    'email', st.email
                )
	)
	FROM student.course_enrollment ce
        JOIN student.student_data st ON ce.student_id = st.student_id
        JOIN staff.lecture_assignment la ON ce.id = la.id
        -- JOIN student.course_data c ON ce.course_id = c.course_id
        -- JOIN staff.staff_data l ON la.staff_id = l.id
        -- LEFT JOIN student.ta_assignment ta ON la.id = ta.lecture_id
        -- LEFT JOIN student.student_data s ON ta.student_id = s.student_id
        WHERE la.id = 138
	GROUP BY st.fname, st.lname, st.student_id, st.email)
            )
        FROM student.course_enrollment ce
        -- JOIN student.student_data st ON ce.student_id = st.student_id
        JOIN staff.lecture_assignment la ON ce.id = la.id
        JOIN student.course_data c ON ce.course_id = c.course_id
        JOIN staff.staff_data l ON la.staff_id = l.id
        LEFT JOIN student.ta_assignment ta ON la.id = ta.lecture_id
        LEFT JOIN student.student_data s ON ta.student_id = s.student_id
        WHERE la.id = 138
GROUP BY c.course_id, c.name, l.fname, l.lname, l.email
);
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT staff.getClasslist(138);

-- STAFF AUTHENTICATION
DROP FUNCTION staff.auth_staff_login(VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION staff.auth_staff_login(semail VARCHAR, spassword VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM staff.staff_data
        WHERE staff_data.email = semail
        AND staff_data.password = spassword
    );
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT staff.auth_staff_login('gmills@university.edu','Dr. ills1771');

-- GET DASHBOARD DETAILS
CREATE OR REPLACE FUNCTION staff.dashDetails(sid INT)
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT json_build_object(
            'id', s.id,
            'fname', s.fname,
            'lname', s.lname,
            'email', s.email,
            'courses', json_agg(
                json_build_object(
                    'course_code', cd.course_id,
                    'course_name', cd.name
                  -- 'students', json_build_array(
                  --       json_build_object(
                  --           'fname', st.fname,
                  --           'lname', st.lname,
                  --           'student_id', st.student_id,
                  --           'email', st.email
                  --       )
                  --   )  
                )
            )
        )
        FROM staff.staff_data s
        JOIN staff.lecture_assignment la ON s.id = la.staff_id
        JOIN student.course_enrollment ce ON la.id = ce.id
        JOIN student.course_data cd ON ce.course_id = cd.course_id
        -- JOIN student.student_data st ON ce.student_id = st.student_id
        WHERE s.id = sid
GROUP BY s.id, s.fname, s.lname, s.email
    );
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT staff.dashDetails(1);

-- ADD STUDENT MARKS
CREATE OR REPLACE FUNCTION staff.addGrade(lecture_assignment_id INT, s_id VARCHAR, s_marks INT)
RETURNS TEXT AS $$
BEGIN
    UPDATE student.course_enrollment
    SET marks = s_marks
    WHERE id = lecture_assignment_id
    AND student_id = s_id;
	return 'Graded Successfully';
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT * FROM staff.addGrade(138, '11238048', 80);

-- ADD COURSES TO DATABASE
CREATE OR REPLACE FUNCTION admin.addCourse(course_code TEXT, course_name TEXT, chour INT)
RETURNS TEXT AS $$
BEGIN
    INSERT INTO student.course_data (course_id, name, credit_hour)
    VALUES (course_code, course_name, chour);
	RETURN 'COURSE ADDED SUCCESSFULLY';
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT * FROM admin.addCourse('CPEN 301', 'Numerical Methods', 4);

-- DELETE COURSE STORED IN DATABASE
CREATE OR REPLACE FUNCTION admin.deleteCourse(course_code TEXT)
RETURNS TEXT AS $$
BEGIN
    DELETE FROM student.course_data
    WHERE course_id=course_code;
	RETURN 'COURSE REMOVED SUCCESSFULLY';
END;
$$ LANGUAGE plpgsql;
-- USE CASE
SELECT * FROM admin.deleteCourse('CPEN 301');



-- INSERTING SAMPLE DATA INTO DATABASE
------------------------------------------

-- Insert Sample Data into Student Data
INSERT INTO student.student_data (student_id, fname, lname, email, password, isTA) VALUES
('11238011', 'Edward', 'Agyemang', 'edmang.st.ug.edu.gh', 'password11238011', FALSE),
('11238012', 'Ishaan', 'Bhardwaj', 'isdwaj.st.ug.edu.gh', 'password11238012', FALSE),
('11238013', 'Afua', 'Ayisibea', 'afibea.st.ug.edu.gh', 'password11238013', FALSE),
('11238014', 'Ebenezer', 'Arthur', 'ebthur.st.ug.edu.gh', 'password11238014', FALSE),
('11238015', 'Andrews', 'Kwarteng', 'anteng.st.ug.edu.gh', 'password11238015', FALSE),
('11238016', 'Samia', 'Soleiman', 'saiman.st.ug.edu.gh', 'password11238016', FALSE),
('11238017', 'Abena', 'Nhyira', 'abyira.st.ug.edu.gh', 'password11238017', FALSE),
('11238018', 'Mohammed', 'Tanko', 'moanko.st.ug.edu.gh', 'password11238018', FALSE),
('11238019', 'Vanessa', 'Aryertey', 'vartey.st.ug.edu.gh', 'password11238019', FALSE),
('11238020', 'Mohammed', 'Haqq', 'mohaqq.st.ug.edu.gh', 'password11238020', FALSE),
('11238021', 'Bernadine', 'Adusei', 'beusei.st.ug.edu.gh', 'password11238021', FALSE),
('11238022', 'Samuel', 'Antwi', 'santwi.st.ug.edu.gh', 'password11238022', FALSE),
('11238023', 'Peggy', 'Esinam', 'peinam.st.ug.edu.gh', 'password11238023', FALSE),
('11238024', 'Prince', 'Philips', 'prlips.st.ug.edu.gh', 'password11238024', FALSE),
('11238025', 'Joshua', 'Nuku-Tagbor', 'jonubor.st.ug.edu.gh', 'password11238025', FALSE),
('11238026', 'Isaac', 'Sedem', 'isedem.st.ug.edu.gh', 'password11238026', FALSE),
('11238027', 'Marvin', 'Asare', 'masare.st.ug.edu.gh', 'password11238027', FALSE),
('11238028', 'Yasmeen', 'Doku', 'yadoku.st.ug.edu.gh', 'password11238028', FALSE),
('11238029', 'Donatus', 'Dodzi', 'doodzi.st.ug.edu.gh', 'password11238029', FALSE),
('11238030', 'Mawuli', 'Amevenku', 'maenku.st.ug.edu.gh', 'password11238030', FALSE),
('11238031', 'Freda', 'Apetsi', 'fretsi.st.ug.edu.gh', 'password11238031', FALSE),
('11238032', 'Jonathan', 'Kudiabor', 'joabor.st.ug.edu.gh', 'password11238032', FALSE),
('11238033', 'Desmond', 'Aflete', 'delete.st.ug.edu.gh', 'password11238033', FALSE),
('11238034', 'Pius', 'Obile', 'pidile.st.ug.edu.gh', 'password11238034', FALSE),
('11238035', 'Mohammed', 'Awal', 'moawal.st.ug.edu.gh', 'password11238035', FALSE),
('11238036', 'Iddrisu', 'Tahiru', 'idhiru.st.ug.edu.gh', 'password11238036', FALSE),
('11238037', 'Latifah', 'Abubakar', 'labakar.st.ug.edu.gh', 'password11238037', FALSE),
('11238038', 'Jeffery', 'Quansah', 'jensah.st.ug.edu.gh', 'password11238038', FALSE),
('11238039', 'Stephen', 'Nyarko', 'starko.st.ug.edu.gh', 'password11238039', FALSE),
('11238040', 'John', 'Edward', 'joward.st.ug.edu.gh', 'password11238040', FALSE),
('11238041', 'Chioma', 'Praise', 'chaise.st.ug.edu.gh', 'password11238041', FALSE),
('11238042', 'Hayet', 'Dabanka', 'habanka.st.ug.edu.gh', 'password11238042', FALSE),
('11238043', 'Jeffery', 'Eririe', 'jeirie.st.ug.edu.gh', 'password11238043', FALSE),
('11238044', 'Kwesi', 'Agyapong', 'kwpong.st.ug.edu.gh', 'password11238044', FALSE),
('11238045', 'David', 'Tetteh', 'datteh.st.ug.edu.gh', 'password11238045', FALSE),
('11238046', 'Sena', 'Anyomi', 'seyomi.st.ug.edu.gh', 'password11238046', FALSE),
('11238047', 'Matthew', 'Mensah', 'mansah.st.ug.edu.gh', 'password11238047', FALSE),
('11238048', 'Isaac', 'Wenide', 'isnide.st.ug.edu.gh', 'password11238048', FALSE),
('11238049', 'Cyril', 'Nyavor', 'cyavor.st.ug.edu.gh', 'password11238049', FALSE),
('11238050', 'Kwesi', 'Wadie', 'kwadie.st.ug.edu.gh', 'password11238050', FALSE),
('11238051', 'Daniel', 'Agyin', 'dagyin.st.ug.edu.gh', 'password11238051', FALSE),
('11238052', 'David', 'Ntow', 'dantow.st.ug.edu.gh', 'password11238052', FALSE),
('11238053', 'Fareed', 'Opare', 'fapare.st.ug.edu.gh', 'password11238053', FALSE),
('11238054', 'Obed', 'Ninson', 'obnson.st.ug.edu.gh', 'password11238054', FALSE),
('11238055', 'Vincent', 'Anewah', 'viewah.st.ug.edu.gh', 'password11238055', FALSE),
('11238056', 'David', 'Baffour', 'baffour.st.ug.edu.gh', 'password11238056', FALSE),
('11238057', 'Kafu', 'Kemeh', 'kaemeh.st.ug.edu.gh', 'password11238057', FALSE),
('11238058', 'Jonathan', 'Boadu', 'jooadu.st.ug.edu.gh', 'password11238058', FALSE),
('11238059', 'Daniel', 'Tetteh', 'dantteh.st.ug.edu.gh', 'password11238059', FALSE),
('11238060', 'Shadrack', 'Nkrumah', 'shumah.st.ug.edu.gh', 'password11238060', FALSE),
('11238061', 'Isaac', 'Banor', 'isanor.st.ug.edu.gh', 'password11238061', FALSE),
('11238062', 'Samuel', 'Idana', 'sadana.st.ug.edu.gh', 'password11238062', FALSE),
('11238063', 'Derrick', 'Amponsah', 'densah.st.ug.edu.gh', 'password11238063', FALSE),
('11238064', 'Kelvin', 'Gyabaah', 'kebaah.st.ug.edu.gh', 'password11238064', FALSE),
('11238065', 'Prince', 'Nyanyun', 'prinyun.st.ug.edu.gh', 'password11238065', FALSE),
('11238066', 'Philemon', 'Ansrogya', 'phogya.st.ug.edu.gh', 'password11238066', FALSE),
('11238067', 'Nkansah', 'Tabi', 'nkabi.st.ug.edu.gh', 'password11238067', FALSE),
('11238068', 'Asamoah', 'Fosu', 'asfosu.st.ug.edu.gh', 'password11238068', FALSE),
('11238069', 'Samuel', 'Amponsah', 'sansah.st.ug.edu.gh', 'password11238069', FALSE),
('11238070', 'Kwaku', 'Ofori', 'kwofori.st.ug.edu.gh', 'password11238070', FALSE);

-- Populate the student.account table
INSERT INTO student.account (student_id, account_balance)
VALUES
('11238011', 1000.00),
('11238012', 1500.50),
('11238013', 500.00),
('11238014', 2000.75),
('11238015', 1200.60),
('11238016', 300.45),
('11238017', 1800.90),
('11238018', 2500.00),
('11238019', 450.10),
('11238020', 3500.20),
('11238021', 400.00),
('11238022', 2100.30),
('11238023', 500.00),
('11238024', 1400.00),
('11238025', 3200.00),
('11238026', 1700.00),
('11238027', 800.00),
('11238028', 1600.00),
('11238029', 2200.00),
('11238030', 1800.00),
('11238031', 1300.00),
('11238032', 1900.00),
('11238033', 900.00),
('11238034', 600.00),
('11238035', 2700.00),
('11238036', 700.00),
('11238037', 1400.00),
('11238038', 1200.00),
('11238039', 800.00),
('11238040', 1000.00),
('11238041', 1500.00),
('11238042', 2000.00),
('11238043', 1700.00),
('11238044', 1100.00),
('11238045', 900.00),
('11238046', 1400.00),
('11238047', 2100.00),
('11238048', 1300.00),
('11238049', 1600.00),
('11238050', 1500.00),
('11238051', 2000.00),
('11238052', 1200.00),
('11238053', 1700.00),
('11238054', 1800.00),
('11238055', 1500.00),
('11238056', 2000.00),
('11238057', 1400.00),
('11238058', 1700.00),
('11238059', 1300.00),
('11238060', 900.00),
('11238061', 800.00),
('11238062', 1500.00),
('11238063', 1900.00),
('11238064', 2000.00),
('11238065', 1500.00),
('11238066', 1700.00),
('11238067', 1200.00),
('11238068', 900.00),
('11238069', 1000.00),
('11238070', 2000.00);

-- Populate course_enrollment table
INSERT INTO student.course_enrollment (student_id, course_id) VALUES
('11238011', 'SENG 102'),
('11238012', 'SENG 104'),
('11238013', 'SENG 106'),
('11238014', 'SENG 108'),
('11238015', 'SENG 112'),
('11238016', 'CPEN 104'),
('11238017', 'UGRC 150'),
('11238018', 'SENG 102'),
('11238019', 'SENG 104'),
('11238020', 'SENG 106'),
('11238021', 'SENG 108'),
('11238022', 'SENG 112'),
('11238023', 'CPEN 104'),
('11238024', 'UGRC 150'),
('11238025', 'SENG 102'),
('11238026', 'SENG 104'),
('11238027', 'SENG 106'),
('11238028', 'SENG 108'),
('11238029', 'SENG 112'),
('11238030', 'CPEN 104'),
('11238031', 'UGRC 150'),
('11238032', 'SENG 102'),
('11238033', 'SENG 104'),
('11238034', 'SENG 106'),
('11238035', 'SENG 108'),
('11238036', 'SENG 112'),
('11238037', 'CPEN 104'),
('11238038', 'UGRC 150'),
('11238039', 'SENG 102'),
('11238040', 'SENG 104'),
('11238041', 'SENG 106'),
('11238042', 'SENG 108'),
('11238043', 'SENG 112'),
('11238044', 'CPEN 104'),
('11238045', 'UGRC 150'),
('11238046', 'SENG 102'),
('11238047', 'SENG 104'),
('11238048', 'SENG 106'),
('11238049', 'SENG 108'),
('11238050', 'SENG 112'),
('11238051', 'CPEN 104'),
('11238052', 'UGRC 150'),
('11238053', 'SENG 102'),
('11238054', 'SENG 104'),
('11238055', 'SENG 106'),
('11238056', 'SENG 108'),
('11238057', 'SENG 112'),
('11238058', 'CPEN 104'),
('11238059', 'UGRC 150'),
('11238060', 'SENG 102');

-- Populate the student.course_data table
INSERT INTO student.course_data (course_id, name)
VALUES
('SENG 102', 'Calculus II: Multivariable'),
('SENG 104', 'Mechanics II: Dynamics'),
('SENG 106', 'Applied Electricity'),
('SENG 108', 'Basic Electronics'),
('SENG 112', 'Engineering Computational Tools'),
('CPEN 104', 'Engineering Design'),
('UGRC 150', 'Critical Thinking & Practical Reasoning');

-- Populate the student.payment table
INSERT INTO student.payment (student_id, payed_amount, date)
VALUES
('11238020', 500.00, '2023-06-01'),
('11238021', 450.00, '2023-06-02'),
('11238022', 400.00, '2023-06-03'),
('11238023', 550.00, '2023-06-04'),
('11238024', 600.00, '2023-06-05'),
('11238025', 470.00, '2023-06-06'),
('11238026', 520.00, '2023-06-07'),
('11238027', 480.00, '2023-06-08'),
('11238028', 530.00, '2023-06-09'),
('11238029', 410.00, '2023-06-10'),
('11238030', 460.00, '2023-06-11'),
('11238031', 495.00, '2023-06-12'),
('11238032', 490.00, '2023-06-13'),
('11238033', 505.00, '2023-06-14'),
('11238034', 475.00, '2023-06-15'),
('11238035', 515.00, '2023-06-16'),
('11238036', 425.00, '2023-06-17');

-- Function to generate password based on a pattern
CREATE OR REPLACE FUNCTION generate_password(full_name VARCHAR(255))
RETURNS VARCHAR(255) AS $$
DECLARE
    password VARCHAR(255);
BEGIN
    -- Generate password based on a pattern (e.g., first 4 characters of first name + last 4 characters of last name + random number)
    password := LEFT(full_name, 4) || RIGHT(full_name, 4) || CAST(FLOOR(RANDOM() * 10000) AS VARCHAR);
    RETURN password;
END;
$$ LANGUAGE plpgsql;

-- Populate the staff.staff_data table
INSERT INTO staff.staff_data (fname, lname, email, password)
VALUES
('Godfrey', 'Mills', 'gmills@university.edu', generate_password('Dr. Godfrey Mills')),
('Robert A.', 'Sowah', 'rsowah@university.edu', generate_password('Prof. Robert A. Sowah')),
('Percy', 'Okae', 'pokae@university.edu', generate_password('Dr. Percy Okae')),
('Nii Longdon', 'Sowah', 'nlsowah@university.edu', generate_password('Dr. Nii Longdon Sowah')),
('Isaac', 'Aboagye', 'iaboagye@university.edu', generate_password('Dr. Isaac Aboagye')),
('Margaret Ansah', 'Richardson', 'marichardson@university.edu', generate_password('Dr. Margaret Ansah Richardson')),
('Prosper', 'Azaglo', 'pazaglo@university.edu', generate_password('Mr. Prosper Azaglo')),
('Gifty', 'Osei', 'gosei@university.edu', generate_password('Mrs. Gifty Osei')),
('Stephen K.', 'Armoo', 'sarmoo@university.edu', generate_password('Mr. Stephen K. Armoo')),
('Agyare', 'Debra', 'adebra@university.edu', generate_password('Mr. Agyare Debra')),
('Prosper', 'Afriyie', 'pafriyie@university.edu', generate_password('Mr. Prosper Afriyie')),
('Francis', 'Boachie', 'fboachie@university.edu', generate_password('Mr. Francis Boachie')),
('George K.', 'Anni', 'ganni@university.edu', generate_password('Mr. George K. Anni')),
('Jemima', 'Owusu-Tweneboah', 'jowusu@university.edu', generate_password('Mrs. Jemima Owusu-Tweneboah')),
('Ebo', 'Bentil', 'ebentil@university.edu', generate_password('Mr. Ebo Bentil')),
('John', 'Assiamah', 'jassiamah@university.edu', generate_password('Mr. John Assiamah')),
('Kenneth', 'Broni', 'kbroni@university.edu', generate_password('Mr. Kenneth Broni'));

-- Populate the lecture_assignment table
UPDATE staff.lecture_assignment (staff_id, course_id)
SELECT
    courses.course_id AS course_id
FROM
    (SELECT course_id FROM student.course_data ORDER BY RANDOM() LIMIT 20) AS courses;

-- Verify the populated data
SELECT * FROM staff.lecture_assignment;

-- Example assuming student_data is correctly populated
INSERT INTO student.ta_assignment (lecture_id, student_id)
VALUES
(1, '11238020'),
(10, '11238021'),
(20, '11238022'),
(30, '11238023'),
(40, '11238024'),
(50, '11238025'),
(60, '11238026'),
(70, '11238027'),
(80, '11238028'),
(90, '11238029'),
(100, '11238030'),
(110, '11238031'),
(5, '11238032'),
(15, '11238033'),
(25, '11238034'),
(35, '11238035'),
(45, '11238036'),
(55, '11238037'),
(119, '11238038');





-- -- Dummy SQL FOR REFERENCE
-- CREATE OR REPLACE FUNCTION student.add_courses(
-- 	json_request text)
--     RETURNS text
--     LANGUAGE 'plpgsql'
--     COST 100
--     VOLATILE PARALLEL UNSAFE
-- AS $BODY$
-- DECLARE 
--     json_result_obj TEXT DEFAULT '';
-- 	vr_course_code TEXT DEfault '';
-- 	vr_course_name TEXT DEFAULT '';
-- BEGIN
-- -- 	{"course_code": "CPEN211", "course_name": "Database"}
-- 	vr_course_code := json_request::json ->> 'course_code';
-- 	vr_course_name := json_request::json ->> 'course_name';
-- --       json_result_obj= json_build_object('success',true,'data',array_to_json(array_agg(row_to_json(t))));
--  insert into ses.courses(course_code, course_name)
--  values(vr_course_code,vr_course_name);
--  return 'Course Saved Successfully';
-- -- IF  json_result_obj IS NULL THEN
-- --      json_result_obj = json_build_object('success',false,'msg','Error Loading Data');
-- -- END IF;
-- --   RETURN json_result_obj;
-- END;
-- $BODY$;

-- ALTER FUNCTION ses.add_courses(text)
--     OWNER TO postgres;
