USE class_codes;

CREATE TABLE Company (
	CNAME VARCHAR(30),
    COUNTRY VARCHAR (15),
    STROCKPRICE INT
);

INSERT INTO COMPANY VALUES
('Gizmoworks', 'USA', 25),
('Canon', 'Japan', '65'),
('Hitachi', 'Japan', 15);


CREATE TABLE Company2 (
    cname VARCHAR(50) PRIMARY KEY,
    address VARCHAR(100)
);

CREATE TABLE Person (
    pname VARCHAR(50) PRIMARY KEY,
    address VARCHAR(100),
    worksfor VARCHAR(50),
    CONSTRAINT fk_worksfor FOREIGN KEY (worksfor) REFERENCES Company2(cname)
);

INSERT INTO Company2 (cname, address) VALUES
('TechCorp', '123 Silicon Valley, CA'),
('DataGlobal', '456 Wall Street, NY'),
('InnovateLLM', '789 AI Avenue, MA');

-- (Note: 'worksfor' values must match a 'cname' from the Company table)
INSERT INTO Person (pname, address, worksfor) VALUES
('Alice Smith', '101 Maple St, CA', 'TechCorp'),
('Bob Jones', '456 Wall Street, NY', 'DataGlobal'),
('Charlie Brown', '303 Pine St, MA', 'InnovateLLM'),
('Diana Prince', '123 Silicon Valley, CA', 'TechCorp');