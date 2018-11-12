insert into genres(name) values('horror');
insert into genres(name) values('adventure');
insert into genres(name) values('non fiction');

insert into books(name, author, genre, details, keywords, cost, stock) values('amazing', 'author', 1, 'aaaaa adsasd', 'book good', 500, 20);
insert into books(name, author, genre, details, keywords, cost, stock) values('more amazing', 'author', 2, 'aaaaa adsasd', 'book very', 600, 2);
insert into books(name, author, genre, details, keywords, cost, stock) values('kinda amazing', 'author', 3, 'aaaaa adsasd', 'book very good', 220, 10);
insert into books(name, author, genre, details, keywords, cost, stock) values('ok cool', 'author', 2, 'aaaaa adsasd', 'book good very very', 421, 50);
insert into books(name, author, genre, details, keywords, cost, stock) values('death', 'author', 3, 'aaaaa adsasd', 'book hello', 300, 60);

insert into login(email, password, admin, name) values('admin@admin.com', 'admin1', 1, 'Pustakaalay Admin');

execute register_customer('Arvind S', 'arvind0598@gmail.com', 'password');