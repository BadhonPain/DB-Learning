USE class_codes;

CREATE TABLE PCForJoin (
    model INT PRIMARY KEY,
    maker VARCHAR(10)
);

INSERT INTO PCForJoin (model, maker) VALUES
(1001, 'A'),
(1002, 'B'),
(1003, 'C');


CREATE TABLE LaptopForJoin (
    model INT PRIMARY KEY,
    maker VARCHAR(10)
);

INSERT INTO LaptopForJoin (model, maker) VALUES
(2001, 'A'),
(2002, 'B'),
(2003, 'D');