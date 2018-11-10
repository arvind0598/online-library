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

create or replace function check_customer
	(email_x in varchar, password_x in varchar)
return int is
	status int := 0;
begin
	select nvl(id, -1) into status from login where email = email_x and password = password_x and admin = 0;
	if status > 0 then
		insert into externallogs(email, action) values(email_x, 'CUST_LOGIN_SUCCESS');
	else
		insert into externallogs(email, action) values(email_x, 'CUST_LOGIN_FAILURE');
	end if;
	return status;
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