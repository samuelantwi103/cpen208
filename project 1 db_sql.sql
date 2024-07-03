-- CREATING DATABASE STRUCTURE
---------------------------------

-- Create Database
CREATE DATABASE comp_eng_dept;

-- Connect to the Database
\c comp_eng_dept;

-- Create Schemas
CREATE SCHEMA admin;
CREATE SCHEMA student;
CREATE SCHEMA staff;

-- Create Admin Data Table
CREATE TABLE admin.admin_data (
    id SERIAL PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create Course Data Table
CREATE TABLE student.course_data (
    id SERIAL PRIMARY KEY,
    course_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL
);

-- Create the course_enrollment table
CREATE TABLE student.course_enrollment (
    id SERIAL PRIMARY KEY,
    student_id VARCHAR(50) REFERENCES student.student_data(student_id),
    course_id VARCHAR(50) REFERENCES student.course_data(course_id)
);

-- Create Student Data Table
CREATE TABLE student.student_data (
    id SERIAL PRIMARY KEY,
    student_id VARCHAR(50) UNIQUE NOT NULL,
    fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    isTA BOOLEAN DEFAULT FALSE
);

-- Create Payment Table
CREATE TABLE student.payment (
    id SERIAL PRIMARY KEY,
    student_id VARCHAR(50) REFERENCES student.student_data(student_id),
    payed_amount DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL
);

-- Create Account Table
CREATE TABLE student.account (
    id SERIAL PRIMARY KEY,
    student_id VARCHAR(50) REFERENCES student.student_data(student_id),
    account_balance DECIMAL(10, 2) NOT NULL
);

-- Create Staff Data Table
CREATE TABLE staff.staff_data (
    id SERIAL PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Create Lecture Assignment Table
CREATE TABLE staff.lecture_assignment (
    id SERIAL PRIMARY KEY,
    staff_id INTEGER REFERENCES staff.staff_data(id),
    course_id VARCHAR(50) REFERENCES student.course_data(course_id)
);

-- DROP TABLE IF EXISTS student.ta_assignment;
-- Create TA Assignment Table
CREATE TABLE student.ta_assignment (
    id SERIAL PRIMARY KEY,
    lecture_id INTEGER REFERENCES staff.lecture_assignment(id),
    student_id VARCHAR(50) REFERENCES student.student_data(student_id)
);

-- CREATING DATABASE FUNCTIONS AND TRIGGERS
-----------------------------------------

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
-- Create Trigger Function to Update Account Balance
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
INSERT INTO staff.lecture_assignment (staff_id, course_id)
SELECT 
    staff.id AS staff_id,
    courses.course_id AS course_id
FROM
    (SELECT id FROM staff.staff_data) AS staff,
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

