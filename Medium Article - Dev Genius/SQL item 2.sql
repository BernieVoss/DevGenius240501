/*
2. Write a SQL query to traverse a hierarchical data structure stored in a single table. Consider an employees table with columns employee_id, manager_id, and name. Write a query that retrieves all employees along with the names of their managers recursively, up to a specified level (e.g., level 3).

The following solutions uses PostGreSQL
*/

CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  manager_id INT,
  name VARCHAR(50),
  FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

INSERT INTO employees (employee_id, manager_id, name)
VALUES (1, NULL, 'John Doe'),  -- CEO (top level)
       (2, 1, 'Jane Smith'),
       (3, 1, 'Mike Jones'),
       (4, 2, 'Alice Johnson'),
       (5, 3, 'Bob Williams'),
       (6, 4, 'Charlie Brown'),
       (7, 5, 'David Miller')
;

with recursive employee_managers as (
  select employee_id,
  		manager_id,
  		name,
  		name as manager_name,
  		1 as level
  from employees
  where manager_id is null
  
  union all
  
  select employee.employee_id,
  		employee.manager_id,
  		employee.name,
  		employee_manager.name as manager_name,
  		employee_manager.level +1 as level
  from employees as employee
  	inner join employee_managers as employee_manager on employee.manager_id = employee_manager.employee_id
  where employee_manager.level < 3
  )
  
  select employee_id,
  		manager_id,
        name,
        manager_name,
        level
  from employee_managers
  order by employee_id
  