create database emp_casestudy;

# 1. Create the Employee Table 
CREATE TABLE 
Employee 
(
    empno INT PRIMARY KEY NOT NULL,
    ename VARCHAR(20) NOT NULL,
    job VARCHAR(20) NOT NULL DEFAULT 'CLERK',
    mgr INT,
    hiredate DATE,
    sal DECIMAL(10,2) NOT NULL CHECK (sal >= 0),
    comm DECIMAL(10,2),
    deptno INT
);

INSERT INTO Employee (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES
(7369, 'SMITH', 'CLERK', 7902, '1890-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);
select *from employee;

ALTER TABLE Employee 
ADD CONSTRAINT fk_employee_deptno
FOREIGN KEY (deptno) REFERENCES Department(deptno);


# 2. Create the Dept Table 
CREATE TABLE 
Department 
(
    deptno INT PRIMARY KEY,
    dname VARCHAR(20),
    loc VARCHAR(20)
);

INSERT INTO Department (deptno, dname, loc)
VALUES
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEW YORK');

# 3. List of Names and salary of the employee whose salary is greater than 1000
SELECT 
ename, 
sal
FROM Employee
WHERE sal > 1000;

# 4. List of details of the employees who have joined before end of September 81
SELECT *
FROM Employee
WHERE hiredate < '1981-09-30';

# 5. List of Employee Names having I as second character
SELECT ename
FROM Employee
WHERE ename LIKE '_I%';

# 6. List of Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary
SELECT 
ename AS Employee_Name,
sal AS Salary,
sal * 0.4 AS Allowances,
sal * 0.1 AS PF,
sal + (sal * 0.4) - (sal * 0.1) AS Net_Salary
FROM Employee;

# 7. List of Employee Names with designations who does not report to anybody
SELECT ename, job
FROM Employee
WHERE mgr IS NULL;

# 8. List of Empno, Ename and Salary in the ascending order of salary
SELECT empno, ename, sal
FROM Employee
ORDER BY sal ASC;

# 9. N. of jobs available in the Organization 
SELECT 
COUNT(DISTINCT job) AS num_of_jobs
FROM Employee;

# 10. Total payable salary of salesman category
SELECT 
SUM(sal) AS total_payable_salary
FROM Employee
WHERE job = 'SALESMAN';

# 11. List of average monthly salary for each job within each department   
SELECT 
d.dname as Department, 
e.job, 
AVG(e.sal) AS avg_monthly_salary
FROM Employee e
INNER JOIN Department d ON e.deptno = d.deptno
GROUP BY d.dname, e.job
ORDER BY d.dname,avg_monthly_salary DESC;

# 12.List of EMPNAME, SALARY and DEPTNAME in which the employee is working.
SELECT 
e.ename AS EMPNAME,
e.sal AS SALARY,
d.dname AS DEPTNAME
FROM Employee e
INNER JOIN Department d ON e.deptno = d.deptno
ORDER BY salary DESC;

# 13. Create the Job Grades Table 
CREATE TABLE 
JobGrades 
(
    grade CHAR(1) PRIMARY KEY,
    lowest_sal INT NOT NULL,
    highest_sal INT NOT NULL
);
INSERT INTO JobGrades (grade, lowest_sal, highest_sal)
VALUES
('A', 0, 999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);

#14. Display the last name, salary and  Corresponding Grade
SELECT 
e.ename as Last_Name, 
e.sal, j.grade
FROM Employee e
INNER JOIN JobGrades j ON e.sal BETWEEN j.lowest_sal AND j.highest_sal
ORDER BY e.sal desc;

#15. List of Emp name and the Manager name under whom the Employee works 
SELECT 
CONCAT(e.ename ,' ', ' reports to ',' ', m.ename ) as Emp_Reports_to_Mgr
FROM Employee e
INNER JOIN Employee m ON e.mgr = m.empno;

# 16. Empname and Total sal where Total Sal (sal + Comm)
SELECT ename, 
CASE WHEN sal + comm IS NULL THEN sal ELSE sal + comm END AS total_sal
FROM Employee;

# 17. List of Empname and Sal whose empno is a odd number
SELECT ename, sal
FROM Employee
WHERE empno % 2 = 1;

# 18. List of Empname , Rank of sal in Organisation , Rank of Sal in their department
SELECT 
e.ename,
DENSE_RANK() OVER (ORDER BY e.sal DESC) AS organization_rank,
DENSE_RANK() OVER (PARTITION BY e.deptno ORDER BY e.sal DESC) AS department_rank
FROM Employee e;

# 19. List of Top 3 Empnames based on their Salary
SELECT 
ename as Top_3_earners
FROM Employee
ORDER BY sal DESC
LIMIT 3;

# 20. List of Empname who has highest Salary in Each Department.
SELECT 
e.ename,
e.sal,
d.dname
FROM Employee e
INNER JOIN Department d ON e.deptno = d.deptno
WHERE e.sal = (SELECT MAX(e1.sal)
FROM Employee e1
WHERE e1.deptno = e.deptno);





