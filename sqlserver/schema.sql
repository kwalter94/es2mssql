CREATE DATABASE kibana_sample_ecommerce;

CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerFirstName VARCHAR(64),
    CustomerLastName VARCHAR(64),
    CustomerGender VARCHAR(12)
);

GO;

