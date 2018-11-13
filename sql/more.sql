-- 3+ nested queries
-- 1+ cursors triggers procedures

create or replace trigger login_before_insert
	before insert on login
for each row
begin
	select nvl(max(id) + 1, 1) into :new.id from login;
end;

/

create or replace trigger genres_before_insert
	before insert on genres
for each row
begin
	select nvl(max(id) + 1, 1) into :new.id from genres;
end;

/

create or replace trigger books_before_insert
	before insert on books
for each row
begin
	select nvl(max(id) + 1, 1) into :new.id from books;
	:new.keywords := :new.keywords || ' ' || :new.author || ' ' || :new.name; 
end;

/

create or replace trigger orders_before_insert
	before insert on orders
for each row
begin
	select nvl(max(id) + 1, 1) into :new.id from orders;
end;

/

create or replace trigger internal_before_insert
	before insert on internallogs
for each row
begin
	select nvl(max(id) + 1, 1) into :new.id from internallogs;
end;

/

create or replace trigger external_before_insert
	before insert on externallogs
for each row
begin
	select nvl(max(id) + 1, 1) into :new.id from externallogs;
end;

/

-- 
-- functions and procedures for access
-- 

create or replace function check_customer
	(email_x in varchar, password_x in varchar, internal_action in int)
return int is
	status int := 0;
begin
	select nvl(id, -1) into status from login where email = email_x and password = password_x and admin = 0;
	if internal_action = 1 then
		if status > 0 then
			insert into externallogs(email, action) values(email_x, 'CUST_LOGIN_SUCCESS');
		else
			insert into externallogs(email, action) values(email_x, 'CUST_LOGIN_FAILURE');
		end if;
	end if;
	return status;
exception
	when others then return 0;
end;

/

create or replace function check_admin
	(email_x in varchar, password_x in varchar)
return int is
	status int := 0;
begin
	select nvl(id, -1) into status from login where email = email_x and password = password_x and admin = 1;
	if status > 0 then
		insert into externallogs(email, action) values(email_x, 'ADM_LOGIN_SUCCESS');
	else
		insert into externallogs(email, action) values(email_x, 'ADM_LOGIN_FAILURE');
	end if;
	return status;
exception
	when others then return 0;
end;

/

create or replace procedure register_customer
	(name_x in varchar, email_x in varchar, password_x in varchar)
as
begin
	insert into login(email, password, name) values(email_x, password_x, name_x);
	insert into externallogs(email, action) values(email_x, 'REGISTER');
end;

/

create or replace procedure logout_user
	(id_x in int)
as
	email_x varchar(50) := null;
begin
	select email into email_x from login where id = id_x;
	if email_x is not null then
		insert into externallogs(email, action) values(email_x, 'LOGOUT_SUCCESS');
	else
		insert into externallogs(email, action) values(email_x, 'LOGOUT_FAILURE');
	end if;
end;

/

-- 
-- procedures to change personal details
-- 

create or replace procedure change_password
	(id_x in int, password_x in varchar)
as
begin
	update login set password = password_x where id = id_x;
	insert into internallogs(login, action, details) values(id_x, 'CHANGE_PASSWORD', '--');
end;

/

create or replace procedure change_address
	(id_x in int, address_x in varchar)
as
begin
	update login set address = address_x where id = id_x;
	insert into internallogs(login, action, details) values(id_x, 'CHANGE_ADDRESS', '--');
end;

/

-- 
-- functions and procedures for mutating the cart
-- 

create or replace function book_qty_valid
	(book_id_x in int, qty_x in int)
return int is
	status int := 0;
	stock_x int := 0;
begin
	select stock into stock_x from books where id = book_id_x;
	if stock_x >= qty_x then
		status := 1;
	end if;
	return status;
end;

/

create or replace procedure update_cart_qty
	(cust_id_x in int, book_id_x in int, qty_x in int)
as
	curr_qty int := 0;
	qty_ok int := book_qty_valid(book_id_x, qty_x);
begin
	select nvl((select qty from cart where cust_id = cust_id_x and book_id = book_id_x), 0) into curr_qty from dual;
	if curr_qty = 0 then
		insert into cart(cust_id, book_id) values(cust_id_x, book_id_x);
		insert into internallogs(login, action, details) values(cust_id_x, 'ADD_TO_CART', book_id_x);
	else
		if qty_x = 0 then
			delete from cart where cust_id = cust_id_x and book_id = book_id_x;
			insert into internallogs(login, action, details) values(cust_id_x, 'RMV_FROM_CART', book_id_x);
		else
			if qty_ok = 1 then
				update cart set qty = qty_x where book_id = book_id_x and cust_id = cust_id_x;
			end if;
		end if;
	end if;
end;

/

create or replace function make_order
	(cust_id_x in int)
return int
is
	status int := 0;
	count_x int := 0;
	bill_x int := 0;
	order_x int;
	cost_x int;
	curr_stock int;
begin
	select count(*) into count_x from cart where cust_id = cust_id_x;
	if count_x > 0 then
		insert into orders(cust_id, bill) values(cust_id_x, 0);
		select max(id) into order_x from orders;

		for i in (select book_id, qty from cart where cust_id = cust_id_x and active = 1) loop
			insert into orderitems values(order_x, i.book_id, i.qty);
			delete from cart where cust_id = cust_id_x and book_id = i.book_id;

			select stock, cost into curr_stock, cost_x from books where id = i.book_id;
			bill_x := bill_x + (cost_x * i.qty);
			curr_stock := curr_stock - i.qty;
			if curr_stock = 0 then
				update cart set active = 0 where book_id = i.book_id;
			end if;

		end loop;

		update orders set bill = bill_x where id = order_x;
		insert into internallogs(login, action, details) values(cust_id_x, 'CHECKOUT', order_x);
		status := 1;
	end if;
	return status;
exception
	when others then return 0;
end;

/

-- 
-- admin functions and procedures
-- 

create or replace function add_genre
	(gen_x in varchar, adm_x in int)
return int is
begin
	insert into genres(name) values(gen_x);
	insert into internallogs(login, action, details) values(adm_x, 'ADD_GENRE', gen_x);
	return 1;
exception
	when others then return 0;
end;

/

create or replace function remove_genre
	(gen_id_x in int, adm_x in int)
return int 
is
	gen_x varchar(30);
begin
	select name into gen_x from genres where id = gen_id_x;
	delete from genres where id = gen_id_x;
	insert into internallogs(login, action, details) values(adm_x, 'RMV_GENRE', gen_x);
	return 1;
exception
	when others then return 0;
end;

/

create or replace function update_stock
	(book_id_x in int, stock_x in int, adm_x in int)
return int 
is
	book_x varchar(50);
begin
	select name into book_x from books where id = book_id_x;
	update books set stock = stock_x where id = book_id_x;

	for i in (select cust_id, qty from cart where book_id = book_id_x) loop
		if i.qty > stock_x then
			update cart set active = 1 where cust_id = i.cust_id and book_id = book_id_x;
		else
			update cart set active = 0 where cust_id = i.cust_id and book_id = book_id_x;
		end if;
	end loop;

	insert into internallogs(login, action, details) values(adm_x, 'UPDATE_STOCK', book_x);
	return 1;
exception
	when others then return 0;
end;

/

create or replace function add_firsthand_book
	(name_x in varchar, author_x in varchar, genre_id_x in int, details_x in varchar, keywords_x in varchar, cost_x in int, stock_x in int, adm_x in int)
return int
is
	book_x varchar(50);
begin
	insert into books(name, author, genre, details, keywords, cost, stock) values(name_x, author_x, genre_id_x, details_x, keywords_x, cost_x, stock_x);
	select name into book_x from books where id = (select max(id) from books);
	insert into internallogs(login, action, details) values(adm_x, 'ADD_FIRSTHAND', book_x);
	return 1;
exception
	when others then return 0;
end;

/

create or replace function add_secondhand_book
	(name_x in varchar, author_x in varchar, genre_id_x in int, details_x in varchar, keywords_x in varchar, age_x in int, cust_x in int)
return int
is
	book_x varchar(50);
begin
	insert into books(name, author, genre, details, keywords, cost, owner, age, display) values(name_x, author_x, genre_id_x, details_x, keywords_x, 1, cust_x, age_x, 0);
	select name into book_x from books where id = (select max(id) from books);
	insert into internallogs(login, action, details) values(cust_x, 'ADD_SECONDHAND', book_x);
	return 1;
exception
	when others then return 0;
end;

/

create or replace function remove_book
	(book_id_x in int, adm_x in int)
return int 
is
	book_x varchar(30);
begin
	select name into book_x from books where id = book_id_x;
	delete from books where id = book_id_x;
	insert into internallogs(login, action, details) values(adm_x, 'RMV_BOOK', book_x);
	return 1;
exception
	when others then return 0;
end;

/

create or replace procedure approve_secondhand_book
	(book_id_x in int, cost_x in int, adm_x in int)
is
begin
	update books set display = 1, cost = cost_x where id = book_id_x;
	insert into internallogs(login, action, details) values(adm_x, 'APPROVE_BOOK', book_id_x);
end;

/

create or replace procedure modify_del_status
	(order_id_x in int, del_x in int, adm_x in int)
is
	del_status varchar(20);
begin
	update orders set status = del_x where id = order_id_x;
	if del_x = 1 then
		del_status := 'DISPATCHED ' || order_id_x;
	elsif del_x = 2 then
		del_status := 'DELIVERED ' || order_id_x;
	else
		del_status := 'RECIEVED ' || order_id_x;
	end if;

	insert into internallogs(login, action, details) values(adm_x, 'CHANGE_DEL_STATUS', del_status);
end;

/