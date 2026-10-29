USE class_codes;

CREATE TABLE Product3 (
    Maker VARCHAR(10),
    Model INT PRIMARY KEY,
    Type VARCHAR(20)
);

INSERT INTO Product3 (Maker, Model, Type) VALUES
('A', 1001, 'pc'),
('A', 1002, 'pc'),
('A', 1003, 'pc'),
('A', 2004, 'laptop'),
('A', 2005, 'laptop'),
('A', 2006, 'laptop'),
('B', 1004, 'pc'),
('B', 1005, 'pc'),
('B', 1006, 'pc'),
('B', 2007, 'laptop'),
('C', 1007, 'pc');

CREATE TABLE PC (
    MODEL INT PRIMARY KEY,
    SPEED DECIMAL(3,2),
    RAM INT,
    HD INT,
    PRICE INT
);

INSERT INTO PC (MODEL, SPEED, RAM, HD, PRICE)
VALUES
(1001, 2.66, 1024, 250, 2114),
(1002, 2.10, 512, 250, 995),
(1003, 1.42, 512, 80, 478),
(1004, 2.80, 1024, 250, 649),
(1005, 3.20, 512, 250, 630);


CREATE TABLE Laptop (
    MODEL INT PRIMARY KEY,
    SPEED DECIMAL(3,2),
    RAM INT,
    HD INT,
    SCREEN DECIMAL(3,1),
    PRICE INT
);

INSERT INTO Laptop (MODEL, SPEED, RAM, HD, SCREEN, PRICE)
VALUES
(2001, 2.00, 2048, 240, 20.1, 3673),
(2002, 1.73, 1024, 80, 17.0, 949),
(2003, 1.80, 512, 60, 15.4, 549),
(2004, 2.00, 512, 60, 13.3, 1150);