USE class_codes;

CREATE TABLE Purchase (
    Product VARCHAR(50),
    Day DATE,
    Price DECIMAL(5, 2),
    Quantity INT
);

INSERT INTO Purchase (Product, Day, Price, Quantity) VALUES
('Bagel', '2005-10-21', 1.00, 20),
('Banana', '2005-10-03', 0.50, 10),
('Banana', '2005-10-10', 1.00, 10),
('Bagel', '2005-10-25', 1.50, 20);