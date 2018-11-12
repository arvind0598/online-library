insert into genres(name) values('horror');
insert into genres(name) values('adventure');
insert into genres(name) values('non fiction');

insert into books(name, author, genre, details, cost, stock) values('amazing', 'author', 1, 'aaaaa adsasd', 500, 20);
insert into books(name, author, genre, details, cost, stock) values('more amazing', 'author', 2, 'aaaaa adsasd', 600, 2);
insert into books(name, author, genre, details, cost, stock) values('kinda amazing', 'author', 3, 'aaaaa adsasd', 220, 10);
insert into books(name, author, genre, details, cost, stock) values('ok cool', 'author', 2, 'aaaaa adsasd', 421, 50);
insert into books(name, author, genre, details, cost, stock) values('death', 'author', 3, 'aaaaa adsasd', 300, 60);

insert into login(email, password, admin, name) values('admin@admin.com', 'admin1', 1, 'Pustakaalay Admin');

execute register_customer('Arvind S', 'arvind0598@gmail.com', 'password');