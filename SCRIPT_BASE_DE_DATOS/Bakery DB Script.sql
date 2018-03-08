CREATE DATABASE bakery;

USE bakery;

/* Tablas sin foreign keys */

CREATE TABLE member (
    id bigint(20) AUTO_INCREMENT NOT NULL,
    login varchar(40) UNIQUE,
    password varchar(250),
    PRIMARY KEY (id)
);

CREATE TABLE client (
    id bigint(20) AUTO_INCREMENT NOT NULL,
    name varchar(40),
    surname varchar(60),
    tin varchar(20),
    address varchar(100),
    location varchar(100),
    postalcode varchar(5),
    province varchar(30),
    email varchar(100),
    PRIMARY KEY (id),
    UNIQUE (name, surname, tin)
);

CREATE TABLE family (
    id bigint(20) AUTO_INCREMENT NOT NULL,
    family varchar(100) UNIQUE,
    PRIMARY KEY (id)
);

/* Tablas con foreign keys */

CREATE TABLE ticket (
    id bigint(20) AUTO_INCREMENT NOT NULL,
    date datetime,
    idmember bigint(20),
    idclient bigint(20),
    PRIMARY KEY (id),
    FOREIGN KEY (idmember) REFERENCES member(id),
    FOREIGN KEY (idclient) REFERENCES client(id)
);

CREATE TABLE product (
    id bigint(20) AUTO_INCREMENT NOT NULL,
    idfamily bigint(20),
    product varchar(100),
    price decimal(10,2),
    description text,
    PRIMARY KEY (id),
    FOREIGN KEY (idfamily) REFERENCES family(id),
    UNIQUE (idfamily, product)
);

CREATE TABLE ticketdetail (
    id bigint(20) AUTO_INCREMENT NOT NULL,
    idticket bigint(20),
    idproduct bigint(20),
    quantity tinyint(4),
    price decimal(10,2),
    PRIMARY KEY (id),
    FOREIGN KEY (idticket) REFERENCES ticket(id),
    FOREIGN KEY (idproduct) REFERENCES product(id)
);
