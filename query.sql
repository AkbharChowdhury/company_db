CREATE TABLE employee(
    employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(120) NOT NULL,
	last_name VARCHAR(120) NOT NULL,
  	birth_date DATE NOT NULL,
	sex CHAR(1) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 17500.00,
	supervisor_id INT NULL,
	branch_id INT NULL,
	CONSTRAINT valid_sex CHECK (sex IN ('M','F')),
	FOREIGN KEY (supervisor_id)
	REFERENCES employee (employee_id) 
	ON DELETE SET NULL

);

CREATE TABLE branch(
    branch_id SERIAL PRIMARY KEY,
	branch_name VARCHAR(100) NOT NULL,
	manager_id INTEGER REFERENCES employee(employee_id) ON DELETE CASCADE  ON UPDATE CASCADE,
  	manager_start_date DATE NOT NULL
);

CREATE TABLE client(
    client_id SERIAL PRIMARY KEY,
	client_name VARCHAR(100) NOT NULL,
	branch_id INTEGER REFERENCES branch(branch_id) ON DELETE CASCADE  ON UPDATE CASCADE
);
CREATE TABLE works_with(
    employee_id INTEGER REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
	client_id INTEGER REFERENCES client(client_id)  ON DELETE CASCADE ON UPDATE CASCADE,
	total_sales NUMERIC(10, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY(employee_id, client_id)
	
);

CREATE TABLE branch_supplier(
    branch_id INTEGER REFERENCES branch(branch_id) ON DELETE CASCADE ON UPDATE CASCADE,
	supply_name VARCHAR(120) NOT NULL,
	supply_type VARCHAR(120) NOT NULL,
	PRIMARY KEY(branch_id, supply_name)
);
 -- fk supervisor

 ALTER TABLE employee
    ADD CONSTRAINT fk_emp_supervisor_id FOREIGN KEY (supervisor_id) REFERENCES employee (employee_id) on delete SET NULL;
-- add fk branch to employee table
ALTER TABLE employee
    ADD CONSTRAINT fk_branch FOREIGN KEY (branch_id) REFERENCES branch (branch_id) on update cascade on delete cascade;

-- drop table employee;

-- uppercase sex on insert
CREATE OR REPLACE FUNCTION fn_uppercase_gender_on_insert() RETURNS 
trigger AS $fn_uppercase_gender_on_insert$
    BEGIN        
        NEW.sex = UPPER(NEW.sex);
        RETURN NEW;
    END;
$fn_uppercase_gender_on_insert$ LANGUAGE plpgsql;

CREATE TRIGGER tr_uppercase_gender_on_insert BEFORE INSERT OR UPDATE ON employee
    FOR EACH ROW EXECUTE 	
	PROCEDURE fn_uppercase_gender_on_insert();

INSERT INTO public.employee(
	 first_name, last_name, birth_date, sex, salary, supervisor_id, branch_id)
	VALUES ( 't', 'S', '1999-02-02', 'm', 20000, null, null);

-- self join 

SELECT
  e.first_name || ' ' || e.last_name employee,
  m.first_name || ' ' || m.last_name manager
FROM
  employee e
  left JOIN employee m ON m.employee_id = e.supervisor_id
ORDER BY
  manager;

  -- CREATE UNIQUE INDEX branch_name_unique_idx on branch (LOWER(branch_name));
