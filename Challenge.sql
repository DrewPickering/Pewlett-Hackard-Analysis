
-- Challenge created SQL Queries begin at line 122
-- Coursework Excersises SQL Queries (Below to Line 120) 

-- Basic join example
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining departments and dept_manager tables w\ aliases
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info	
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables w/ aliases
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date 
INTO current_emp	
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO dept_retirements
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


-- Employee with Salary 
SELECT emp_no,
		first_name,
		last_name,
		gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Drop the emp_info table
DROP TABLE emp_info;

-- Employee with Salary and Department - 2 joins
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');


SELECT *
FROM retirement_info;


-- List from retirement_info for Sales Dept Only
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_retire_info
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d
ON (d.dept_no = de.dept_no)
WHERE de.dept_no IN ('d007');

-- List from retirement_info for Sales and Development Dept
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_develop_mentors
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments as d
ON (d.dept_no = de.dept_no)
WHERE de.dept_no IN ('d007', 'd005');


--Challenge SQL Queries (below)

-- Find duplicate titles by emp_no in titles
SELECT
  emp_no,
  count(*)
FROM titles
GROUP BY
  emp_no
HAVING count(*) > 1;

-- show the duplicate records/rows in titles
SELECT * FROM
  (SELECT *, count(*)
  OVER
    (PARTITION BY
      emp_no
    ) AS count
  FROM titles) tableWithCount
  WHERE tableWithCount.count > 1;
  
-- Create table with ONLY the most recent titles
SELECT emp_no, title, from_date, to_date 
INTO current_titles
FROM
(SELECT emp_no, title, from_date, to_date,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY to_date DESC) rn
   FROM titles
  ) tmp WHERE rn = 1;  

-- Display table
SELECT *
FROM current_titles;

-- Find duplicate titles by emp_no in retirement_info
SELECT
  emp_no,
  count(*)
FROM retirement_info
GROUP BY
  emp_no
HAVING count(*) > 1;

-- Find duplicate titles by emp_no in salaries
SELECT
  emp_no,
  count(*)
FROM salaries
GROUP BY
  emp_no
HAVING count(*) > 1;

-- Challenge Table Number of titles retiring
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ct.title,
	ct.from_date,
	s.salary
INTO titles_retiring
FROM retirement_info as ri
INNER JOIN current_titles as ct
ON (ri.emp_no = ct.emp_no)
INNER JOIN salaries as s
ON (ri.emp_no = s.emp_no);

-- Challenge Table ready for mentor
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ct.title,
	ct.from_date,
	ct.to_date
INTO mentor_ready
FROM employees as e
INNER JOIN current_titles as ct
ON (e.emp_no = ct.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND to_date IN ('9999-01-01');

-- Get total count of employees ready for mentorship
SELECT COUNT(emp_no)
FROM mentor_ready;

-- Get total sum of all employees retiring 
SELECT SUM(de.count)
FROM dept_retirements as de;

