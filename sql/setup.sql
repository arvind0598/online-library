drop table login cascade constraints;
drop table genres cascade constraints;
drop table books cascade constraints;
drop table cart cascade constraints;
drop table orders cascade constraints;
drop table orderitems cascade constraints;
drop table internallogs cascade constraints;
drop table externallogs cascade constraints;

-- 8+ tables

create table login(
	id int primary key,
	email varchar(50) not null unique,
	password varchar(50) not null,
	admin int default 0 not null,
	name varchar(30) not null,
	address varchar(100),
	registered_time timestamp default current_timestamp not null
);

create table genres(
	id int primary key,
	name varchar(30) unique not null
);

create table books(
	id int primary key,
	genre int references genres(id) on delete cascade not null,
	name varchar(50) not null,
	author varchar(50) not null,
	details varchar(200) not null,
	cost int not null,
	keywords varchar(200) not null,
	stock int default 1 not null,
	owner int default null references login(id) on delete cascade,
	age int default 0 not null,
	display int default 1 not null,
	constraint c_books_pos check(cost > 0 and stock >= 0 and age >= 0)
);

create table cart(
	cust_id int references login(id) on delete cascade,
	book_id int references books(id) on delete cascade,
	qty int default 1 not null,
	active int default 1 not null,
	constraint c_cart primary key(cust_id, book_id),
	constraint c_cart_pos check(qty >= 0)
);

create table orders(
	id int primary key,
	cust_id int references login(id) on delete cascade,
	bill int not null,
	status int default 0 not null,
	init_time timestamp default current_timestamp not null
);

create table orderitems(
	order_id int references orders(id) on delete cascade,
	book_id int references books(id) on delete cascade,
	qty int default 1 not null,
	constraint c_orderitems primary key(order_id, book_id),
	constraint c_orders_pos check(qty >= 0)
);

create table internallogs(
	id int primary key,
	login int references login(id) on delete cascade not null,
	action varchar(30) not null,
	details varchar(50) not null,
	time_performed timestamp default current_timestamp not null
);

create table externallogs(
	id int primary key,
	email varchar(50) not null,
	action varchar(30) not null,
	time_performed timestamp default current_timestamp not null
);