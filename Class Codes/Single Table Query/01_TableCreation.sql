CREATE DATABASE IF NOT EXISTS class_codes;
USE class_codes;

CREATE TABLE Product (
	PName VARCHAR(30) NOT NULL,
    Price DECIMAL(10,2),
    Category VARCHAR(30),
    Manufacturer VARCHAR(30)
);

INSERT INTO Product VALUES
('Gizmo', 19.99, 'Gadgets', 'GizmoWorks'),
('Powergizmo', 29.99, 'Gadgets', 'GizmoWorks'),
('SingleTouch', 149.99, 'Photography', 'Canon'),
('MultiTouch', 203.99, 'Household', 'Hitachi');

CREATE TABLE PRODUCT2 (
    Maker CHAR(1),
    Type_ VARCHAR(20)
);

INSERT INTO PRODUCT2 (Maker, Type_) VALUES
('A', 'pc'),
('A', 'pc'),
('A', 'pc'),
('A', 'laptop'),
('A', 'laptop'),
('A', 'laptop'),
('B', 'pc'),
('B', 'pc'),
('B', 'pc'),
('B', 'laptop'),
('C', 'pc');

CREATE TABLE CDCollection (
    artist VARCHAR(50),
    album VARCHAR(100),
    tracks INT,
    company VARCHAR(50),
    year INT
);


INSERT INTO CDCollection (artist, album, tracks, company, year)
VALUES
('U2', 'The Unforgettable', 10, 'Island', 1984),
('U2', 'Rattle and Hum', 17, 'Island', 1988),
('U2', 'Achtung Boys', 12, 'Island', 1991),
('Underworld', 'Second Toughest', 8, 'Junior', 1996);


