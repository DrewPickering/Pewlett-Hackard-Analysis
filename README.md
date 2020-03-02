# Challenge Pewlett-Hackard-Analysis

Pewlett Hackard seeks insight on future retirements across their organization in order to make plans to minimize turnover impact to the business.  They have 6 data tables in csv format with employee, department, titles, salary and manager information.  These data tables were placed into a database to allow querries to be built and run so that insights can be extracted.

Summary Findings:
    
    Number of individuals retiring = 36,619, (based on current number of employees born between 1952 and 1956, and hire dates between 1985 and 1989)
    
    Number of individuals being hired = 32,957 (or 90% of retiring count, expecting 10% role consolidation and productivity improvements through innovation) 
    
    Number of individuals currently employed and born in 1965, which are targetted to be in mentorship program = 1,549

    Further analysis needs to be performed on what titles or roles will need to be replaced due to retirements, so that those roles with the greatest pending vacated positions can be targetted for talent development and talent acquisition programs.

Utized SQL Queries 
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
  
 -- select the most recent titles
SELECT emp_no, title, from_date, to_date 
INTO current_titles
FROM
(SELECT emp_no, title, from_date, to_date,
     ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY to_date DESC) rn
   FROM titles
  ) tmp WHERE rn = 1;  

--view new table current_titles 
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

-- Find duplicate titles by emp_no in salaries (ensure no duplicate employee records)
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

-- Get total count of employees ready for mentoring
SELECT COUNT(emp_no)
FROM mentor_ready;

-- Get total sum of expected retirements
SELECT SUM(de.count)
FROM dept_retirements as de; 
