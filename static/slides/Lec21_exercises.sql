## Exercise 1

### 1. The total costs in payroll for this company

SELECT SUM(salary) FROM employees;

### 2. The number of employees in each department who earn more than $35,000

SELECT dept, COUNT(*) AS n
FROM employees
WHERE salary > 35000
GROUP BY dept;


## Exercise 2

### 1. What percentage of the total payroll does each department account for?

-- Subquery version
SELECT dept, ROUND(100.0 * SUM(salary) / (SELECT SUM(salary) FROM employees), 2) AS pct_payroll
FROM employees
GROUP BY dept;

-- CTE version
WITH total AS (
  SELECT SUM(salary) AS total_salary FROM employees
)
SELECT dept, ROUND(100.0 * SUM(salary) / total_salary, 2) AS pct_payroll
FROM employees CROSS JOIN total
GROUP BY dept, total_salary;

### 2. Create a table with a new column abv_avg

-- Subquery version
SELECT *, round(salary-avg,2) AS diff
FROM employees
NATURAL JOIN  (
  SELECT dept, round(avg(salary),2) AS avg FROM employees GROUP BY dept
) dept_avg
ORDER BY dept, diff;

-- CTE version
WITH dept_avg AS (
  SELECT dept, round(avg(salary),2) AS avg FROM employees GROUP BY dept
)
SELECT *, round(salary-avg,2) AS diff
FROM employees
NATURAL JOIN dept_avg
ORDER BY dept, diff;

## ┌─────────┬───────────────────┬─────────┬────────────┬──────────┬─────────┐
## │  name   │       email       │ salary  │    dept    │   avg    │  diff   │
## │ varchar │      varchar      │ double  │  varchar   │  double  │ double  │
## ├─────────┼───────────────────┼─────────┼────────────┼──────────┼─────────┤
## │ Alice   │ alice@company.com │ 52000.0 │ Accounting │ 41666.67 │ 10333.0 │
## │ Bob     │ bob@company.com   │ 40000.0 │ Accounting │ 41666.67 │ -1667.0 │
## │ Carol   │ carol@company.com │ 30000.0 │ Sales      │  37000.0 │ -7000.0 │
## │ Dave    │ dave@company.com  │ 33000.0 │ Accounting │ 41666.67 │ -8667.0 │
## │ Eve     │ eve@company.com   │ 44000.0 │ Sales      │  37000.0 │  7000.0 │
## │ Frank   │ frank@comany.com  │ 37000.0 │ Sales      │  37000.0 │     0.0 │
## └─────────┴───────────────────┴─────────┴────────────┴──────────┴─────────┘


## Exercise 3

SELECT sum(seats) FROM flights NATURAL LEFT JOIN planes; # Wrong

SELECT sum(seats) FROM flights LEFT JOIN planes USING (tailnum); # Correct
