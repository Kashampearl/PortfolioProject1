
USE employees_db
---SQL PROJECT
--QUESTION 1 
--- Display the Minimum Salary

SELECT min(salary)
FROM employees;

--QUESTION 2
--Display the highest salary
SELECT MAX(salary)
FROM employees;

--QUESTION 3
--Display the total salary of all employees.
SELECT SUM(salary)
FROM employees;


--QUESTION 4
--Display the average salary for all employees
SELECT AVG(salary)
FROM employees;

--QUESTION 5
---Issue a query to count the number of rows in the employee table. The result should be just one row.
SELECT COUNT(*)
FROM employees;

--QUESTION 6
--Issue a query to count the number of employees that make commission. The result should be just one row.
--Your count will usually not count blank rows
SELECT COUNT(commission_pct)
FROM employees;

--QUESTION 7
--Issue a query to count the number of employees’ first name column. The result should be just one row.
SELECT COUNT(first_name)
FROM employees;

---Question 8
--Display all employees that make less than Peter Hall.

SELECT  salary
FROM employees
WHERE salary < (SELECT salary
FROM employees
WHERE first_name = 'Peter' AND last_name = 'Hall')

--Question 9
--Display all the employees in the same department as Lisa Ozer.

SELECT first_name, last_name, department_id 
FROM employees
WHERE department_id =  (SELECT department_id 
FROM employees
WHERE first_name = 'Lisa' AND last_name = 'Ozer')

--Question 10
---Display all the employees in the same department as Martha Sullivan and that make more than TJ Olson.

--step 1 get to see her depatment id
SELECT first_name, last_name, department_id --depatment id = 50
FROM employees
WHERE first_name = 'Martha' AND last_name = 'Sullivan'

---Step 2 get to see the salary of TJ Olson ---salary 2100
SELECT first_name, last_name, salary
FROM employees
WHERE first_name = 'TJ' AND last_name = 'Olson';

--Step 3 merge the 2 queries using their diff filters
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE department_id = (SELECT department_id --depatment id = 50
FROM employees
WHERE first_name = 'Martha' AND last_name = 'Sullivan') AND salary > (SELECT salary
FROM employees
WHERE first_name = 'TJ' AND last_name = 'Olson')

--Question 11
--Display all the departments that exist in the departments table that are not in the employees’ table.
--Do not use a where clause.27-11 = 16 departments

SELECT DISTINCT department_id FROM departments --27
EXCEPT
SELECT DISTINCT department_id FROM employees---11

--Question 12
--Display all the departments that exist in department tables that are also in the employees’ table.
--Do not use a where clause.

SELECT DISTINCT department_id FROM departments --27
INTERSECT
SELECT DISTINCT department_id FROM employees---11

--Question 13
--Display all the departments name, street address, postal code, city, and state of each department. 
--Use the departments and locations table for this query.

SELECT department_name,street_address,postal_code,city,state_province,departments.
location_id AS dept_loc_id,locations.location_id AS loc_loc_id
FROM departments
INNER JOIN locations
ON departments.location_id = locations.location_id;

--Question 14
--Display the first name and salary of all the employees in the accounting departments. 

SELECT  first_name,salary
FROM employees
WHERE department_id = 
(SELECT department_id
FROM departments
WHERE department_name = 'Accounting');


--Question 15
---Display all the last name of all the employees whose department location id are 1700 and 1800.

SELECT last_name
FROM employees
WHERE department_id IN (SELECT department_id FROM departments
WHERE location_id IN (1700, 1800));

--Question 16
--Display the phone number of all the employees in the Marketing department.

SELECT phone_number
FROM employees
WHERE department_id = (
SELECT department_id 
FROM departments WHERE department_name = 'Marketing');

--QUESTION 17
--Display all the employees in the Shipping and Marketing departments who make more than 3100.

SELECT first_name, salary,department_id
FROM employees
WHERE department_id IN 
(SELECT department_id FROM departments WHERE department_name IN ('Shipping', 'Marketing')
AND salary > 3100);

--QUESTION 18
--Write an SQL query to print the first three characters of FIRST_NAME from employee’s table.

SELECT SUBSTRING (first_name,1,3) AS abv_first_name
FROM employees;

--QUESTION 19
--Display all the employees who were hired before Tayler Fox.

SELECT first_name,last_name,hire_date 
FROM employees
WHERE hire_date <
(SELECT hire_date FROM employees WHERE first_name = 'Tayler' AND last_name = 'Fox');

--QUESTION 20
--Display names and salary of the employees in executive department

SELECT first_name, last_name, salary
FROM employees
WHERE department_id =
(SELECT department_id
FROM departments
WHERE department_name = 'Executive')

--Question 21
--Display the employees whose job ID is the same as that of employee 141.

SELECT first_name, last_name,job_id 
FROM employees
WHERE job_id = (SELECT job_id
FROM employees WHERE employee_id = 141);

--QUESTION 22
--For each employee, display the employee number, last name, salary, and salary increased by 15% and 
--expressed as a whole number. Label the column New Salary.

SELECT employee_id,last_name,salary, 
CONVERT(INT,ROUND((salary + (0.15 * salary)),0))  AS 'New Salary'
FROM employees;

--To convert the salary to 15%, i used the actual salary * 15% of the actual salary.
--In the New Salary column, to get rid of the excess zeros,i used the CONVERT function to convert the new salary
-- to an integer ie whole number without decimals

--USING CAST FUNCTION TO CONVERT DECIMALS TO INTERGERS AN ALTERNATIVE TO THE CONVERT FUNCTION
SELECT employee_id,last_name,salary, CAST(ROUND((salary + (0.15 * salary)),0) AS INT)  AS 'New Salary'
FROM employees;

--QUESTION 23
--Write an SQL query to print the FIRST_NAME and LAST_NAME from employees table into a single column 
--COMPLETE_NAME A space char should separate them.

SELECT first_name, last_name, CONCAT (first_name,' ', last_name) AS COMPLETE_NAME
FROM employees;

--Question 24
--Display all the employees and their salaries that make more than Abel

SELECT first_name, last_name,salary
FROM employees
WHERE salary < (
SELECT salary FROM employees WHERE first_name = 'Neena');
---It seem thare is no employee with the name Abel in the dataset

--Question 25
--Create a query that displays the employees’ last names and commission amounts. If an employee does not earn
--commission, put “no commission”.Label the column COMM. 

SELECT last_name, commission_pct, 'No Commission' AS COMM
FROM employees
WHERE commission_pct IS NULL
UNION
SELECT last_name, commission_pct, CAST(commission_pct AS VARCHAR) AS COMM
FROM employees
WHERE commission_pct IS NOT NULL

--USING A CASE STATEMENT TO SOLVE THE QUESTION ABOVE IS ANOTHER ALTERNATIVE TOO

SELECT last_name, commission_pct,
CASE WHEN commission_pct IS NULL THEN 'no commission'
	 ELSE CONVERT(VARCHAR, commission_pct) END AS COMM
FROM employees;

--QUESTION 26
--.) Create a unique listing of all jobs that are in department 80.
--Include the location of department in the output

SELECT DISTINCT job_id, emp.department_id, location_id
FROM employees AS emp
LEFT JOIN departments AS dep
ON emp.department_id = dep.department_id
WHERE emp.department_id = 80;

--question 27
--Write a query to display the employee’s last name, department name, location ID, 
--and city of all employees who earn a commission.

SELECT last_name,department_name,dep.location_id,city
FROM employees AS emp
JOIN departments AS dep
ON emp.department_id = dep.department_id
JOIN locations AS loc
ON dep.location_id = loc.location_id
WHERE commission_pct IS NOT NULL;   

--QUESTION 28
--Create a query to display the name and hire date of any employee
--hired after employee Davies.

SELECT first_name, last_name,hire_date
FROM employees 
WHERE hire_date > ( SELECT hire_date FROM employees WHERE last_name = 'Davies' );

-- QUESTION 29
--Write an SQL query to show one row twice in results from a table.

SELECT * FROM departments
UNION ALL
SELECT * FROM departments
ORDER BY department_id;

--QUESTION 30
--Display the highest, lowest, sum, and average salary of all employees. Label the columns Maximum,
--Minimum, Sum, and Average, respectively. Round your results to the nearest whole number.

SELECT CAST(ROUND(MAX(salary),0)AS int) AS maximum, 
CAST(ROUND(MIN(salary),0) AS int) AS minimum, 
CAST(ROUND(SUM(salary),0) AS INT) AS sum, 
CAST(ROUND(AVG(salary),0) AS int) AS average
FROM employees;

--QUESTION 31
--Write an SQL query to show the top n (say 10) records of a table.

SELECT TOP 10 * 
FROM employees;

--QUESTION 32
--Display the MINIMUN, MAXIMUM, SUM AND AVERAGE salary of each job type. 

SELECT job_id, MIN(salary) AS minimum,
MAX(salary) AS maximum,
SUM(salary) AS sum,
CAST(AVG(salary)AS INT) AS average
FROM employees
GROUP BY job_id;

--QUESTION 33
--Display all the employees and their managers from the employees’ table.
--This question will use a self join, that is joining a table against itself, some cool stuff in sql

SELECT emp.employee_id,
emp.first_name AS emp_first_name, 
emp.last_name AS emp_first_name,
emp.manager_id,
man.first_name AS man_first_name, 
man.last_name AS man_last_name
FROM employees AS emp
JOIN employees AS man
ON emp.manager_id = man.employee_id;

--QUESTION 34
--Determine the number of managers without listing them. Label the column NUMBER of managers.
--Hint: use manager_id column to determine the number of managers.

SELECT  COUNT (manager_id) AS NUMBER_of_managers
FROM employees;

--QUESTION 35
--Write a query that displays the difference between the HIGHEST AND LOWEST salaries. Label the column DIFFERENCE
SELECT MAX(salary) - MIN(salary) AS 'difference'
FROM employees;

--QUESTION 36
--Display the sum salary of all employees in each department.

SELECT department_id, SUM(salary) AS sum_salary
FROM employees
GROUP BY department_id
ORDER BY  sum_salary DESC;

--QUESTION 37
--Write a query to display each department's name, location, number of employees, and the average salary of employees
--in the department. Label the column NAME, LOCATION, NUMBER OF PEOPLE, respectively.

SELECT department_name AS NAME,
location_id AS LOCATION, 
COUNT(employee_id) AS NUMBER_OF_PEOPLE,
CAST(AVG(salary)AS INT) AS 'AVG SAL'
FROM departments AS dep
INNER JOIN employees AS emp
ON dep.department_id = emp.department_id
GROUP BY department_name, location_id;

--	QUESTION 38
--Write an SQL query to find the position of the alphabet (‘J’) in the first name column
--‘Julia’ from employee’s table.
SELECT first_name, CHARINDEX('J',first_name)
FROM employees;

--QUESTION 39
--Create a query to display the employee number and last name of all employees who earns more than the average salary. 
--Sort the result in ascending order of salary.


SELECT employee_id, last_name
FROM employees
WHERE AVG(salary) = (
SELECT AVG(salary) FROM employees)
GROUP BY employee_id
ORDER BY AVG(salary);

--QUESTION 40
--Write a query that displays the employee number and last names of all employees who work in a department
--with any employees whose last name contains a letter U.

SELECT employee_id, last_name
FROM employees
WHERE department_id IN (
SELECT department_id
FROM employees
WHERE last_name LIKE ('%U%') )


--QUESTION 41
--Display the last name, department number and job id of all employees whose department location ID is 1700.

SELECT last_name, emp.department_id, job_id
FROM employees AS emp
INNER JOIN departments AS dept
ON emp.department_id = dept.department_id
WHERE location_id = 1700;

--QUESTION 42
--Display the last name and salary of every employee who reports to king.

SELECT * FROM employees
SELECT * FROM departments


--QUESTION 43
--Display the department number, last name, job ID of every employee in Executive department.

SELECT emp.department_id, last_name, department_name
FROM employees AS emp
INNER JOIN departments AS dep
ON emp.department_id = dep.department_id
WHERE department_name = 'Executive';

--QUESTION 44
--Display all last name, their department name and id from employees and department tables.
SELECT last_name, dep. department_name, emp.department_id
FROM employees AS emp
INNER JOIN departments AS dep
ON emp.department_id = dep.department_id;

--QUESTION 45
--Display all the last name department name, id and location from employees, department, and locations tables.

SELECT last_name, dep.department_name, emp.department_id, city
FROM employees AS emp
INNER JOIN departments AS dep
ON emp.department_id = dep.department_id
INNER JOIN LOCATIONS AS loc
ON dep.location_id = loc.location_id;

--QUESTION 46
--Write an SQL query to print all employee details from the employees table order by DEPARTMENT Descending

SELECT *
FROM employees
ORDER BY department_id DESC;

--QUESTION 47
--Write a query to determine who earns more than Mr. Tobias:

SELECT first_name, last_name, employee_id, salary
FROM employees
WHERE salary > (SELECT salary
FROM employees
WHERE last_name = 'Tobias')

--QUESTION 48
--Write a query to determine who earns more than Mr. Taylor:

SELECT first_name, last_name, employee_id, salary
FROM employees
WHERE salary > (SELECT MAX (salary)
FROM employees
WHERE first_name = 'Tailor' OR last_name = 'Taylor' )

--QUESTION 49
--Find the job with the highest average salary. 

SELECT TOP 1 job_id, CAST(AVG(salary) AS INT) AS AVGsalary
FROM employees
GROUP BY job_id
ORDER BY AVGsalary DESC;

--QUESTION 50
--Find the employees that make more than Taylor and are in department 80. 

SELECT first_name, last_name, employee_id, salary, department_id
FROM employees
WHERE department_id = 80 AND salary > (
SELECT salary
FROM employees
WHERE last_name = 'Taylor' AND department_id = 80 );

--QUESTION 51
--Display all department names and their full street address.

SELECT department_name, street_address
FROM departments AS dep
INNER JOIN LOCATIONS AS loc
ON dep.location_id = loc.location_id;

--QUESTION 52
--Write a query to display the number of people with the same job.
 
SELECT job_id, COUNT(employee_id) AS No_of_Staff
FROM employees
GROUP BY job_id;

--SELECT 53
--Write an SQL query to fetch “FIRST_NAME” from employees table in upper case
SELECT UPPER (first_name) AS FIRST_NAME
FROM employees;

--QUESTION 54
--Display the full name and salary of the employee that makes the most in departments 50 and 80.

SELECT TOP 1 first_name, last_name, salary
FROM employees
WHERE department_id IN (50, 80)
ORDER BY salary DESC;

--QUESTION 55
--.) Display the department names for the departments 10, 20 and 30.
SELECT department_name
FROM departments
WHERE department_id IN (10,20,30)

--QUESTION 56
--Display all the manager id and department names of all the departments in United Kingdom (UK).
SELECT  manager_id, department_name
FROM departments AS dep
INNER JOIN LOCATIONS AS loc
ON dep.location_id = loc.location_id
WHERE country_id = 'UK'

--QUESTION 57
--Display the full name and phone numbers of all employees who are not in location id 1700. 

SELECT first_name, last_name,phone_number
FROM employees AS emp
INNER JOIN departments AS dep
ON emp.department_id = dep.department_id
WHERE location_id !=  1700
 
--QUESTION 58
--Display the full name, department name and hire date of all employees that were hired after Shelli Baida

SELECT first_name, last_name, department_name, hire_date
FROM employees AS emp
INNER JOIN departments as dep
ON emp.department_id = dep.department_id
WHERE hire_date > (
SELECT hire_date
FROM employees
WHERE first_name = 'Shelli' AND last_name = 'Baida')

--QUESTION 59
--Display the full name and salary of all employees who make the same salary as Janette King

SELECT first_name, last_name, salary 
FROM employees
WHERE salary = (
SELECT salary
FROM employees
WHERE first_name = 'Janette' AND last_name = 'King');

--QUESTION 60
--Display the full name hire date and salary of all employees who were hired in 2007 and make more than Elizabeth Bates.

SELECT first_name, last_name, hire_date, salary
FROM employees
WHERE YEAR (hire_date) = 2007 AND salary > (
SELECT salary
FROM employees
WHERE first_name = 'Elizabeth' AND last_name = 'Bates');

--QUESTION 61
--Issue a query to display all departments whose average salary is greater than $8000. 

SELECT department_id, avg(salary) AS AVGSalary
FROM employees
GROUP BY department_id, salary
HAVING avg(salary) > 8000
ORDER BY AVGSalary; 

--QUESTION 62
--Issue a query to display all departments whose maximum salary is greater than 10000.

SELECT department_id, MAX(salary) AS maxSalary
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000


--QUESTION 63
-- Issue a query to display the job title and total monthly salary for each job that has a total salary exceeding $13,000.
--Exclude any job title that looks like rep and sort the result by total monthly salary.

SELECT job_title, SUM(salary) AS SUMSalary
FROM employees AS emp
INNER JOIN jobs
ON emp.job_id = jobs.job_id
GROUP BY job_title
HAVING SUM(salary) > 13000 AND job_title NOT LIKE ('%REP%')
ORDER BY SUM(salary);

--QUESTION 64
--Issue a query to display the department id, department name, location id and city of departments 20 and 50

SELECT emp.department_id, department_name, dep.location_id, city
FROM employees AS emp
INNER JOIN departments AS dep
ON emp.employee_id = dep.department_id
INNER JOIN LOCATIONS AS loc
ON dep.location_id = loc.location_id
WHERE emp.department_id IN (20,50);

--QUESTION 65
--Issue a query to display the city and department name that are having a location id of 1400. 

SELECT city, department_name
FROM LOCATIONS AS loc
INNER JOIN departments AS dep
ON loc.location_id = dep.location_id
WHERE loc.location_id = 1400;

--QUESTION 66
--Display the salary of last name, job id and salary of all employees whose salary is equal to the minimum salary

SELECT last_name, job_id, employee_id, salary
FROM employees
GROUP BY salary, last_name, job_id, employee_id
HAVING salary = (
SELECT MIN(salary)
FROM employees)

--QUESTION 67
--Display the departments who have a minimum salary greater that of department 50.
SELECT department_id, employee_id, salary
FROM employees
WHERE salary > 
(SELECT Min(salary) FROM employees) AND department_id = 50
ORDER BY salary DESC;


--QUESTION 68
--Issue a query to display all employees who make more than Timothy Gates and less than Harrison Bloom.

SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
SELECT salary FROM employees WHERE first_name = 'Timothy' AND last_name = 'Gates') AND salary < (
SELECT salary FROM employees WHERE first_name = 'Harrison' AND last_name = 'Bloom' )

--	QUESTION 69
--Issue a query to display all employees who are in Lindsey Smith or Joshua Patel department,
--who make more than Ismael Sciarra and were hired in 2007 and 2008.

SELECT first_name, last_name, department_id,salary,hire_date
FROM employees
WHERE department_id IN (
SELECT department_id FROM employees WHERE first_name = 'Lindsey' AND last_name = 'Smith' 
OR first_name = 'Joshua' AND last_name = 'Patel')
AND salary > ( SELECT salary FROM employees WHERE first_name = 'Ismael' AND last_name = 'Sciarra' )
AND YEAR (hire_date) IN (2007, 2008)
ORDER BY salary DESC;

--QUESTION 70
--Issue a query to display the full name, 10-digit phone number, salary, department name, 
--street address, postal code, city,and state province of all employees.

SELECT first_name, last_name, employee_id, phone_number,salary, department_name,
street_address, postal_code, city, state_province
FROM employees AS emp
JOIN departments AS dep
ON emp.department_id = dep.department_id
JOIN LOCATIONS AS loc
ON dep.location_id = loc.location_id;

--QUESTION 71
--Write an SQL query that fetches the unique values of DEPARTMENT from employees table and prints its length.

SELECT DISTINCT department_id, len(department_id) AS LEN
FROM employees

--QUESTION 72
--Write an SQL query to print all employee details from the Worker table order by FIRST_NAME Ascending.

SELECT *
FROM employees
ORDER BY first_name;