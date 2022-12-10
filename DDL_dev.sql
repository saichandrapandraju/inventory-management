-- Database/Schema creation --

drop database if exists inventory_management;
create database inventory_management;
use inventory_management;

-- Table creation --

drop table if exists supplier;

create table supplier (
	id int primary key auto_increment,
    name varchar(128) not null unique,
    phone varchar(15) default null unique,
    address varchar(300) default null
);

-- insert into supplier(name, phone,address) values("cloudtail","8976898767","75 park street");

drop table if exists supplier_products;

create table supplier_products (
	sid int not null,
    product_name varchar(300) not null,
    price float not null,
    constraint supplier_products_pk primary key (sid, product_name),
	constraint supplier_products_fk_supplier foreign key (sid) references supplier (id) on update cascade on delete restrict
);




drop table if exists employee;

create table employee (
	id int primary key auto_increment,
    first_name varchar(128) not null,
    last_name varchar(128) not null,
    full_name varchar(256) as (concat_ws(' ',first_name, last_name) ),
    address varchar(300) not null,
    emp_type enum("Manager","Worker") default 'Worker',
    phone varchar(15) default null unique,
    ssn varchar(15) not null unique

);


drop table if exists loginDetails;
create table loginDetails(
email_address varchar(500) primary key,
pass varchar(500)
);

alter table loginDetails drop foreign key login_fk_employee;
alter table loginDetails add constraint login_fk_employee foreign key (email_address) references employee (email_address) on update cascade on delete cascade;

drop table if exists brand;

create table brand (
	name varchar(64) not null unique
);

 -- insert into brand(name) values("SONY");

drop table if exists category;

create table category (
	id int primary key auto_increment,
    name varchar(64) not null unique,
    description varchar(128) default null
);

-- insert into category(name,description) values ("Electronics","All the electronic gadgets");

drop table if exists purchase_order;

create table purchase_order (
	id int primary key auto_increment,
    order_date date not null
);

drop table if exists product;


create table product (
	id int primary key auto_increment,
    name varchar(300) not null,
    price float not null,
    description varchar(500) default null,
    quantity int not null default 0,
    manufacture_date date not null,
    expiry_date date default null,
    location varchar(64) not null ,
    brand varchar(64) not null,
    category int not null,
    supplier int not null,
	constraint product_fk_brand foreign key (brand) references brand (name) on update cascade on delete restrict,
    constraint product_fk_category foreign key (category) references category (id) on update cascade on delete restrict,
    constraint product_fk_supplier foreign key (supplier) references supplier (id) on update cascade on delete restrict
);

 -- insert into product(name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier) values("television",100,3,"2016-08-08","2030-09-08","korea","SONY",1,1);

drop table if exists order_details;

create table order_details (
	emp_id int not null,
    sup_id int not null,
    purchase_id int not null,
    product_id int not null,
    quantity int not null,
    price float not null,
    status enum("Pending","Settled", "Cancelled") default 'Pending',
    constraint order_details_pk primary key (emp_id, sup_id, purchase_id),
    constraint order_details_fk_employee foreign key (emp_id) references employee (id) on update cascade on delete restrict,
    constraint order_details_fk_supplier foreign key (sup_id) references supplier (id) on update cascade on delete restrict,
    constraint order_details_fk_purchase foreign key (purchase_id) references purchase_order (id) on update cascade on delete restrict,
    constraint order_details_fk_product foreign key (product_id) references product (id) on update cascade on delete restrict
);

drop table if exists sale;

create table sale (
	id int primary key auto_increment,
    sale_date date not null
);

drop table if exists product_sale;

create table product_sale (
	sale_id int not null,
    product_id int not null,
    quantity int not null,
    constraint product_sale_pk primary key (sale_id, product_id),
    constraint product_sale_fk_sale foreign key (sale_id) references sale (id) on update cascade on delete restrict,
    constraint product_sale_fk_product foreign key (product_id) references product (id) on update cascade on delete restrict
);



select * from sale;

drop table if exists login_details;

create table login_details (
	emp_id int primary key,
    username varchar(500) not null unique,
    passcode varchar(500) not null unique,
    constraint login_details_fk_employee foreign key (emp_id) references employee (id) on update cascade on delete restrict
);

-- Brand procedures --
drop procedure if exists create_brand;

delimiter $$

create procedure create_brand(name_in varchar(64))
begin
	if not exists (select * from brand where LOWER(name)=LOWER(name_in)) then
		insert into brand(name) values(name_in);
        select "Brand added succesfully" response;
	else
		select "Brand already exists" response;
	end if;
end $$
delimiter ;
-- call create_brand("Google");

drop procedure if exists all_brands;

delimiter $$
create procedure all_brands()
begin
	select * from brand;
end $$
delimiter ;
-- call all_brands();

drop procedure if exists get_brand;

delimiter $$
create procedure get_brand(name_in varchar(64))
begin
	select * from brand where lower(name)=lower(name_in);
end $$
delimiter ;
-- call get_brand("Apple");

drop procedure if exists rename_brand;

delimiter $$
create procedure rename_brand(old_name varchar(64), new_name varchar(64))
begin
	if exists (select * from brand where name=old_name) then
		update brand set name=new_name where name=old_name;
        select "renamed brand successfully" response;
	else
		select "Requested brand doesn't exist to rename." response;
	end if;
end $$
delimiter ;
-- call rename_brand("Apple", "Appy");
-- call rename_brand("Appy", "Apple");
-- 

drop procedure if exists delete_brand;

delimiter $$

create procedure delete_brand(name_in varchar(64))
begin
	if exists (select * from brand where name=name_in) then
		delete from brand where name=name_in;
        select "Deleted brand successfully" response;
	else
		select "Requested brand doesn't exist to delete." response;
	end if;
end$$
delimiter ;
-- call delete_brand("Google");




-- Category procedures --

drop procedure if exists create_category;

delimiter $$
create procedure create_category(name_in varchar(64), description_in varchar(128) )
begin
	if not exists (select * from category where lower(name)=lower(name_in)) then
		insert into category(name, description) values(name_in, description_in);
        select "Category created successfully" as response;
	else
		select "Category already exists" as response;
	end if;
end $$
delimiter ;
-- call create_category("Mobile", "smartphones");

drop procedure if exists all_categories;
delimiter $$
create procedure all_categories()
begin
	select * from category order by id;
end $$
delimiter ;
-- call all_categories();


drop procedure if exists get_category_by_name;
delimiter $$
create procedure get_category_by_name(name_in varchar(64))
begin
	select * from category where lower(name)=lower(name_in);
end $$
delimiter ;
-- call get_category_by_name("mobile");

drop procedure if exists get_category_by_id;
delimiter $$
create procedure get_category_by_id(id_in int)
begin
	select * from category where id=id_in;
end $$
delimiter ;
-- call get_category_by_id(1);

drop procedure if exists update_category;
delimiter $$
create procedure update_category(id_in int, new_name varchar(64), new_description varchar(64))
begin
	if exists (select * from category where id=id_in) then
		update category set name=new_name, description=new_description where id=id_in;
		select "Category updated successfully" as response;
	else
		select "Category doesn't exists to update" as response;
	end if;
end $$
delimiter ;

-- call update_category(1, "Phone", "Mobile phone");
-- call update_category(1, "Mobile", "Smartphones");


drop procedure if exists delete_category;
delimiter $$
create procedure delete_category(id_in int)
begin
	if exists (select * from category where id=id_in) then
		delete from category where id=id_in;
        select "Deleted category successfully" response;
	else
		select "Requested category doesn't exist to delete." response;
	end if;
end $$
delimiter ;
-- call delete_category(1);



-- Employee procedures --

drop procedure if exists create_employee;
delimiter $$
create procedure create_employee(first_name_in varchar(128), last_name_in varchar(128), address_in varchar(300), emp_type_in enum("Manager", "Worker"), phone_in varchar(15), ssn_in varchar(15), email_in varchar(500))
begin
	if not exists (select * from employee where lower(email_address)=lower(email_in)) then 
		insert into employee(first_name, last_name, address, emp_type, phone, ssn, email_address) values(first_name_in, last_name_in, address_in, emp_type_in, phone_in, ssn_in, email_in);
        select "Employee added successfully" response;
	else 
		select "Employee already exists" response;
	end if;
end $$
delimiter ;
-- call create_employee("Sai Chandra", "Pandraju", "Saint Alphonsus Street", "Worker", "+19876543210", "1234567890");

drop procedure if exists update_employee;
delimiter $$
create procedure update_employee(id_in int, new_address varchar(300), new_emp_type enum("Manager", "Worker"), new_phone varchar(15) )
begin
	if exists (select * from employee where id=id_in) then
		update employee set address=new_address, emp_type=new_emp_type, phone=new_phone where id=id_in;
        select "Employee details updated successfully" response;
	else
		select "Employee doesn't exist to update" response;
	end if;
end $$
delimiter ;
-- call update_employee(1, "Vikram Villa", "Worker", "+16578943211");


drop procedure if exists all_employees;
delimiter $$
create procedure all_employees()
begin
	select * from employee order by id;
end $$
delimiter ;
-- call all_employees();



drop procedure if exists get_employee_by_email;
delimiter $$
create procedure get_employee_by_email(email_in varchar(500))
begin
	select * from employee where email_address=email_in;
end $$
delimiter ;

call get_employee_by_email("sai@mail.com");


drop procedure if exists delete_employee;
delimiter $$
create procedure delete_employee(id_in int)
begin
	if exists (select * from employee where id=id_in) then
		delete from employee where id=id_in;
        select "Employee deleted successfully" response;
	else
		select "Employee doesn't exist to delete" response;
	end if;
end $$
delimiter ;
-- call delete_employee(1);

drop table if exists userDetails;
create table userDetails(
email_address varchar(500) primary key,
pass varchar(500)
);


-- Product procedures --

drop procedure if exists create_product;
delimiter $$
create procedure create_product(name_in varchar(300), price_in float, description_in varchar(500), quantity_in int, manufacture_date_in date, expiry_date_in date, location_in varchar(64), brand_in varchar(64), category_in varchar(64), supplier_in varchar(128) )
begin
	declare cat_id int default null;
    declare sup_id int default null;
    select id into cat_id from category where name=category_in;
    select id into sup_id from supplier where name=supplier_in;
	if not exists (select * from product where lower(name)=lower(name_in) and lower(brand)=lower(brand_in) and supplier=sup_id ) then 
		insert into product(name, price, description, quantity, manufacture_date, expiry_date, location, brand, category, supplier) values(name_in, price_in, description_in, quantity_in, manufacture_date_in, expiry_date_in, location_in, brand_in, cat_id, sup_id);
        select "Product added successfully" response;
	else 
		select "Product already exists" response;
	end if;
end $$
delimiter ;


drop procedure if exists update_product;
delimiter $$
create procedure update_product(id_in int, new_name varchar(300), new_price float, new_description varchar(500), new_quantity int, new_manufacture_date date, new_expiry_date date, new_location varchar(64), new_brand varchar(64), new_category varchar(64), new_supplier varchar(128) )
begin
	declare cat_id int default null;
    declare sup_id int default null;
    select id into cat_id from category where name=new_category;
    select id into sup_id from supplier where name=new_supplier;
	if exists (select * from product where id=id_in) then
		update product set name=new_name, price=new_price, description=new_description, quantity=new_quantity , manufacture_date=new_manufacture_date , expiry_date=new_expiry_date , location=new_location , brand=new_brand, category=cat_id , supplier=sup_id where id=id_in;
        select "Product details updated successfully" response;
	else
		select "Product doesn't exist to update" response;
	end if;
end $$
delimiter ;



drop procedure if exists all_products;
delimiter $$
create procedure all_products()
begin
	select p.id, p.name, p.price, p.description, p.quantity, p.manufacture_date manufacture, p.expiry_date expiry, p.location, p.brand, c.name category, s.name supplier from product p join category c on p.category=c.id join supplier s on p.supplier=s.id order by p.id;
end $$
delimiter ;
call all_products();


drop procedure if exists get_product_by_id;
delimiter $$
create procedure get_product_by_id(id_in int)
begin
	select * from product where id=id_in;
end $$
delimiter ;

-- call get_product_by_id(1);


drop procedure if exists delete_product;
delimiter $$
create procedure delete_product(id_in int)
begin
	if exists (select * from product where id=id_in) then
		delete from product where id=id_in;
        select "Product deleted successfully" response;
	else
		select "Product doesn't exist to delete" response;
	end if;
end $$
delimiter ;

-- login procedueres --

drop procedure if exists create_user;
delimiter $$
create procedure create_user(in first varchar(500),in last varchar(500),in address varchar(500),in ph varchar(15),in ssn varchar(15), in em varchar(300), in  passcode varchar(15))
begin
	declare temp1 varchar(500);
    declare temp2 varchar(500);
	select email_address into temp1 from loginDetails where email_address=em;
    select email_address into temp2 from employee where email_address=em;
    
	if temp1<=>null and  temp2<=>null then
		
		insert into employee(first_name,last_name,address,emp_type,phone,ssn,email_address) values(first,last,address,'Manager',ph,ssn,em);
        insert into loginDetails(email_address,pass) values(em,passcode);
        if exists(select email_address from loginDetails) then
			select 1 response;
		else
			select 0 response;
		end if;
	else
		select 0 response;
	end if;
end $$
delimiter ;

-- call create_user("asasa", "asasas","asasas","asasas","Asasas","test@mail.com","test");

drop procedure if exists check_user;
delimiter $$
create procedure check_user(in email varchar(500),in pw varchar(255))

begin
	declare t varchar(500) default null;
	select pass into t   from loginDetails where email_address=email ;
    if (select pass from loginDetails where email_address=email) <=> pw then
		select "yes" response;
	else 
		select "no" response;
	end if;
    
end $$
delimiter ;



drop trigger if exists product_sale_sold;
delimiter $$ 
create trigger product_sale_sold  
after insert  on product_sale
for each row 
begin 
	declare tq int;
    declare tid int;
    declare cur_q int;
   --  declare tq int;
    select product_id into tid from  product_sale where sale_id=new.sale_id;
    select quantity into tq from  product_sale where sale_id=new.sale_id;
    select quantity into cur_q from product where id=tid;
    
    
    -- select product.quantity into temp from product  join product_sale where product.id=new.product_sale.product_id;
--     
	-- UPDATE product SET quantity = quantity - tq WHERE id = tid;
     if cur_q-tq>0 then -- check this condition once
		update product set quantity=quantity - tq where id= tid;
     else
		update product set quantity=0 where id=tid;
	 end if;
end $$
delimiter ;


drop procedure if exists supplier_past_orders;
delimiter $$
create procedure supplier_past_orders(id_in int)
begin
	select p.id, p.order_date, o.emp_id, pr.name product, o.quantity, o.price price_$, o.status from purchase_order p join order_details o on p.id=o.purchase_id join product pr on o.product_id=pr.id where o.sup_id=id_in and o.status="Settled" or o.status="Cancelled";

end $$
delimiter ;
call supplier_past_orders(1);

drop procedure if exists supplier_orders_active;
delimiter $$
create procedure supplier_orders_active(id_in int)
begin
	select p.id, p.order_date, o.emp_id, pr.name product, o.quantity, o.price price_$ from purchase_order p join order_details o on p.id=o.purchase_id join product pr on o.product_id=pr.id where o.sup_id=id_in and o.status="Pending";

end $$
delimiter ;
-- call supplier_orders_active(1);


drop procedure if exists all_supplier_products;
delimiter $$
create procedure all_supplier_products(id_in int)
begin
	select id, name, price, brand from product where supplier=id_in order by id;
end $$
delimiter ;
-- call all_supplier_products(1);

drop procedure if exists order_new_product;
delimiter $$
create procedure order_new_product(emp_id_in int,sup_id_in int,p_id_in int, qty_in int)
begin
	declare cur_price float default null;
    declare cur_id int default null;
	insert into purchase_order(order_date) values(current_date());
    select id into cur_id from purchase_order order by id desc limit 1;
	select price into cur_price from product where id=p_id_in;
    insert into order_details(emp_id, sup_id, purchase_id, product_id, quantity, price) values(emp_id_in, sup_id_in, cur_id, p_id_in, qty_in, cur_price*qty_in);
    
    select "Order placed successfully" response;
end $$
delimiter ;
-- call order_new_product(1, 1, 2, 4 );

drop procedure if exists settle_order;
delimiter $$
create procedure settle_order(purchase_id_in int)
begin
	update order_details set status="Settled" where purchase_id=purchase_id_in;
    select "Order settled successfully" response;
end $$
delimiter ;
-- call settle_order(1);

drop procedure if exists cancel_order;
delimiter $$
create procedure cancel_order(purchase_id_in int)
begin
	update order_details set status="Cancelled" where purchase_id=purchase_id_in;
    select "Order cancelled successfully" response;
end $$
delimiter ;
-- call cancel_order(1);

drop trigger if exists after_settle;
DELIMITER $$
CREATE TRIGGER after_settle 
AFTER UPDATE ON order_details
FOR EACH ROW
BEGIN
   IF NEW.status="Settled" THEN
      update product set quantity=quantity+old.quantity where id=old.product_id;
   END IF;
END;$$
DELIMITER ;


drop procedure if exists high_sale_products;
delimiter $$
create procedure high_sale_products()
begin
	select p.name, SUM(ps.quantity) sales from product_sale ps join product p on p.id=ps.product_id group by ps.product_id order by sales desc limit 5;
end $$
delimiter ;
-- call high_sale_products();

drop procedure if exists low_sale_products;
delimiter $$
create procedure low_sale_products()
begin
	select p.name, SUM(ps.quantity) sales from product_sale ps join product p on p.id=ps.product_id group by ps.product_id order by sales limit 5;
end $$
delimiter ;
-- call low_sale_products();

drop procedure if exists low_stock_products;
delimiter $$
create procedure low_stock_products()
begin
	select name, quantity from product where quantity<100 order by quantity desc;
end $$
delimiter ;
-- call low_stock_products();

drop procedure if exists high_sale_product_trend;
delimiter $$
create procedure high_sale_product_trend()
begin
	select sale_date,quantity from product_sale ps join sale s on ps.sale_id=s.id where ps.product_id=(select p.id id from product_sale ps join product p on p.id=ps.product_id group by ps.product_id order by SUM(ps.quantity) desc limit 1);

end $$
delimiter ;
call high_sale_product_trend();


-- INSERTING DATA IN TO THE SALES TABLES HERE
-- suppliers
select * from supplier;
insert into supplier(id,name, phone,address) values(1,"cloudtail","8976898767","75 park street,Boston,MA");
insert into supplier(id,name, phone,address) values(2,"Zappos",   "9087998688","25 East road street,Boston,MA");
insert into supplier(id,name, phone,address) values(3,"Spreetail","8976897589","55 heath street,Houston,TX");
insert into supplier(id,name, phone,address) values(4,"Fintie",   "5790878949","92 Locust Street,San Francisco,CA");
insert into supplier(id,name, phone,address) values(5,"AlinUS",   "3459494949","84 Spruce Street,Woodstock,MD");

-- categories
insert into category(id,name,description) values (1,"Electronics","All the electronic gadgets");
insert into category(id,name,description) values(2,"beauty","All the beauty, hair and skin products");
insert into category(id,name,description) values(3,"pet supplies", "All the items related to the pet care");
insert into category(id,name,description) values(4,"furniture", "All the items related to the furniture");
insert into category(id,name,description) values(5,"outdoors", "All the items related to the outdoor activity like swiming, hiking,etc.");

-- brands
insert into brand(name) values("SONY"); -- electronics category
insert into brand(name) values("LG"); -- electronic category
insert into brand(name) values("Lakme"); -- beauty category
insert into brand(name) values("Nivia"); -- beauty category
insert into brand(name) values("Chewy"); -- pet supplies
insert into brand(name) values("Drools"); -- pet supplies
insert into brand(name) values("Bantia"); -- furniture
insert into brand(name) values("Ikea"); -- furniture
insert into brand(name) values("Patagonia"); -- outdoors
insert into brand(name) values("Columbia"); -- outdoors

-- products
select * from product;
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(1,"CatFoodCan",2,1000,"2018-11-11","2024-06-06","Mexico","Chewy",3,3,"Great Cat food");
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(2,"phone",500,2000,"2016-08-08","2030-09-08","USA","LG",1,1,"Touchscreen latest version with latest features");
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(3,"perfume",40,2500,"2014-08-08","2023-06-05","India","Lakme",2,2,"Lipstick");
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(4,"moisturizer",20,3000,"2016-06-08","2023-06-05","USA","Nivia",2,2,"Deeply moisturizes skin");


insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(5,"television",2000,1000,"2016-08-08","2030-09-08","Korea","SONY",1,1,"OLED television with 4k quality");
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(6,"DogFoodCan",4,1500,"2017-11-06","2022-06-06","Canada","Drools",3,3,"Great Dog food");

insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(7,"Sofa",300,1800,"2017-11-06","2040-06-06","India","Bantia",4,4,"Leather covered cushioning");
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(8,"Dining Table",200,1200,"2015-11-06","2043-06-06","Sweden","Ikea",4,4,"Original Teak Wood");

insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(9,"Swimsuit",30,600,"2015-11-06","2027-07-06","Thailand","Patagonia",5,5,"High quality Nylon");
insert into product(id,name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier,description) values(10,"Fleece Jacket",50,800,"2018-11-06","2025-07-06","Bangladesh","Columbia",5,5,"High quality Sherpa");

select * from product;


-- 


-- 1
-- nsert into supplier(name, phone,address) values("cloudtail","8976898767","75 park street");

-- insert into brand(name) values("SONY");
-- insert into product(name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier) values("television",100,30,"2016-08-08","2030-09-08","korea","SONY",1,1);
-- -- 2
-- insert into supplier(name, phone,address) values("cloudtail","8976898767","75 park street");
-- insert into category(name,description) values ("beauty","All the beauty and hair products");
-- insert into brand(name) values("Lakme");
-- insert into product(name,price,quantity,manufacture_date,expiry_date,location,brand,category,supplier) values("lipstick",100,30,"2012-11-11","2023-06-06","China","Lakme",2,1);

-- 3

-- 3

-- select * from product_sale;

-- insert into sale(sale_date) values('2021-05-01');
-- insert into sale(sale_date) values('2021-05-02');
-- insert into sale(sale_date) values('2021-05-03');
-- insert into sale(sale_date) values('2021-05-04');
-- insert into sale(sale_date) values('2021-05-05');
-- insert into sale(sale_date) values('2021-05-06');
-- insert into sale(sale_date) values('2021-05-07');
-- insert into sale(sale_date) values('2021-05-08');
-- insert into sale(sale_date) values('2021-05-09');
-- insert into sale(sale_date) values('2021-05-10');
-- insert into sale(sale_date) values('2021-05-11');
-- insert into sale(sale_date) values('2021-05-12');
-- insert into sale(sale_date) values('2021-05-13');
-- insert into sale(sale_date) values('2021-05-14');
-- insert into sale(sale_date) values('2021-05-15');
-- insert into sale(sale_date) values('2021-05-16');
-- insert into sale(sale_date) values('2021-05-17');
-- insert into sale(sale_date) values('2021-05-18');
-- insert into sale(sale_date) values('2021-05-19');
-- insert into sale(sale_date) values('2021-05-20');
-- insert into sale(sale_date) values('2021-05-21');
-- insert into sale(sale_date) values('2021-05-22');
-- insert into sale(sale_date) values('2021-05-23');
-- insert into sale(sale_date) values('2021-05-24');
-- insert into sale(sale_date) values('2021-05-25');
-- insert into sale(sale_date) values('2021-05-26');
-- insert into sale(sale_date) values('2021-05-27');
-- insert into sale(sale_date) values('2021-05-28');
-- insert into sale(sale_date) values('2021-05-29');
-- insert into sale(sale_date) values('2021-05-30');
-- insert into sale(sale_date) values('2021-05-31');

-- insert into sale(id,sale_date) values(1,'2021-05-01');
-- insert into sale(id,sale_date) values(2,'2021-05-02');
-- insert into sale(id,sale_date) values(3,'2021-05-03');
-- insert into sale(id,sale_date) values(4,'2021-05-04');
-- insert into sale(id,sale_date) values(5,'2021-05-05');
-- insert into sale(id,sale_date) values(6,'2021-05-06');
-- insert into sale(id,sale_date) values(7,'2021-05-07');
-- insert into sale(id,sale_date) values(8,'2021-05-08');
-- insert into sale(id,sale_date) values(9,'2021-05-09');
-- insert into sale(id,sale_date) values(10,'2021-05-10');
-- insert into sale(id,sale_date) values(11,'2021-05-11');
-- insert into sale(id,sale_date) values(12,'2021-05-12');
-- insert into sale(id,sale_date) values(13,'2021-05-13');
-- insert into sale(id,sale_date) values(14,'2021-05-14');
-- insert into sale(id,sale_date) values(15,'2021-05-15');
-- insert into sale(id,sale_date) values(16,'2021-05-16');
-- insert into sale(id,sale_date) values(17,'2021-05-17');
-- insert into sale(id,sale_date) values(18,'2021-05-18');
-- insert into sale(id,sale_date) values(19,'2021-05-19');
-- insert into sale(id,sale_date) values(20,'2021-05-20');
-- insert into sale(id,sale_date) values(21,'2021-05-21');
-- insert into sale(id,sale_date) values(22,'2021-05-22');
-- insert into sale(id,sale_date) values(23,'2021-05-23');
-- insert into sale(id,sale_date) values(24,'2021-05-24');
-- insert into sale(id,sale_date) values(25,'2021-05-25');
-- insert into sale(id,sale_date) values(26,'2021-05-26');
-- insert into sale(id,sale_date) values(27,'2021-05-27');
-- insert into sale(id,sale_date) values(28,'2021-05-28');
-- insert into sale(id,sale_date) values(29,'2021-05-29');
-- insert into sale(id,sale_date) values(30,'2021-05-30');
-- insert into sale(id,sale_date) values(31,'2021-05-31');

-- insert into sale(id,sale_date) values(32,'2021-05-01');
-- insert into sale(id,sale_date) values(33,'2021-05-02');
-- insert into sale(id,sale_date) values(34,'2021-05-03');
-- insert into sale(id,sale_date) values(35,'2021-05-04');
-- insert into sale(id,sale_date) values(36,'2021-05-05');
-- insert into sale(id,sale_date) values(37,'2021-05-06');
-- insert into sale(id,sale_date) values(38,'2021-05-07');
-- insert into sale(id,sale_date) values(39,'2021-05-08');
-- insert into sale(id,sale_date) values(40,'2021-05-09');
-- insert into sale(id,sale_date) values(41,'2021-05-10');
-- insert into sale(id,sale_date) values(42,'2021-05-11');
-- insert into sale(id,sale_date) values(43,'2021-05-12');
-- insert into sale(id,sale_date) values(44,'2021-05-13');
-- insert into sale(id,sale_date) values(45,'2021-05-14');
-- insert into sale(id,sale_date) values(46,'2021-05-15');
-- insert into sale(id,sale_date) values(47,'2021-05-16');
-- insert into sale(id,sale_date) values(48,'2021-05-17');
-- insert into sale(id,sale_date) values(49,'2021-05-18');
-- insert into sale(id,sale_date) values(50,'2021-05-19');
-- insert into sale(id,sale_date) values(51,'2021-05-20');
-- insert into sale(id,sale_date) values(52,'2021-05-21');
-- insert into sale(id,sale_date) values(53,'2021-05-22');
-- insert into sale(id,sale_date) values(54,'2021-05-23');
-- insert into sale(id,sale_date) values(55,'2021-05-24');
-- insert into sale(id,sale_date) values(56,'2021-05-25');
-- insert into sale(id,sale_date) values(57,'2021-05-26');
-- insert into sale(id,sale_date) values(58,'2021-05-27');
-- insert into sale(id,sale_date) values(59,'2021-05-28');
-- insert into sale(id,sale_date) values(60,'2021-05-29');
-- insert into sale(id,sale_date) values(61,'2021-05-30');
-- insert into sale(id,sale_date) values(62,'2021-05-31');

-- insert into sale(id,sale_date) values(63,'2021-05-01');
-- insert into sale(id,sale_date) values(64,'2021-05-02');
-- insert into sale(id,sale_date) values(65,'2021-05-03');
-- insert into sale(id,sale_date) values(66,'2021-05-04');
-- insert into sale(id,sale_date) values(67,'2021-05-05');
-- insert into sale(id,sale_date) values(68,'2021-05-06');
-- insert into sale(id,sale_date) values(69,'2021-05-07');
-- insert into sale(id,sale_date) values(70,'2021-05-08');
-- insert into sale(id,sale_date) values(71,'2021-05-09');
-- insert into sale(id,sale_date) values(72,'2021-05-10');
-- insert into sale(id,sale_date) values(73,'2021-05-11');
-- insert into sale(id,sale_date) values(74,'2021-05-12');
-- insert into sale(id,sale_date) values(75,'2021-05-13');
-- insert into sale(id,sale_date) values(76,'2021-05-14');
-- insert into sale(id,sale_date) values(77,'2021-05-15');
-- insert into sale(id,sale_date) values(78,'2021-05-16');
-- insert into sale(id,sale_date) values(79,'2021-05-17');
-- insert into sale(id,sale_date) values(80,'2021-05-18');
-- insert into sale(id,sale_date) values(81,'2021-05-19');
-- insert into sale(id,sale_date) values(82,'2021-05-20');
-- insert into sale(id,sale_date) values(83,'2021-05-21');
-- insert into sale(id,sale_date) values(84,'2021-05-22');
-- insert into sale(id,sale_date) values(85,'2021-05-23');
-- insert into sale(id,sale_date) values(86,'2021-05-24');
-- insert into sale(id,sale_date) values(87,'2021-05-25');
-- insert into sale(id,sale_date) values(88,'2021-05-26');
-- insert into sale(id,sale_date) values(89,'2021-05-27');
-- insert into sale(id,sale_date) values(90,'2021-05-28');
-- insert into sale(id,sale_date) values(91,'2021-05-29');
-- insert into sale(id,sale_date) values(92,'2021-05-30');
-- insert into sale(id,sale_date) values(93,'2021-05-31');

-- insert into sale(id,sale_date) values(94,'2021-05-01');
-- insert into sale(id,sale_date) values(95,'2021-05-02');
-- insert into sale(id,sale_date) values(96,'2021-05-03');
-- insert into sale(id,sale_date) values(97,'2021-05-04');
-- insert into sale(id,sale_date) values(98,'2021-05-05');
-- insert into sale(id,sale_date) values(99,'2021-05-06');
-- insert into sale(id,sale_date) values(100,'2021-05-07');
-- insert into sale(id,sale_date) values(101,'2021-05-08');
-- insert into sale(id,sale_date) values(102,'2021-05-09');
-- insert into sale(id,sale_date) values(103,'2021-05-10');
-- insert into sale(id,sale_date) values(104,'2021-05-11');
-- insert into sale(id,sale_date) values(105,'2021-05-12');
-- insert into sale(id,sale_date) values(106,'2021-05-13');
-- insert into sale(id,sale_date) values(107,'2021-05-14');
-- insert into sale(id,sale_date) values(108,'2021-05-15');
-- insert into sale(id,sale_date) values(109,'2021-05-16');
-- insert into sale(id,sale_date) values(110,'2021-05-17');
-- insert into sale(id,sale_date) values(111,'2021-05-18');
-- insert into sale(id,sale_date) values(112,'2021-05-19');
-- insert into sale(id,sale_date) values(113,'2021-05-20');
-- insert into sale(id,sale_date) values(114,'2021-05-21');
-- insert into sale(id,sale_date) values(115,'2021-05-22');
-- insert into sale(id,sale_date) values(116,'2021-05-23');
-- insert into sale(id,sale_date) values(117,'2021-05-24');
-- insert into sale(id,sale_date) values(118,'2021-05-25');
-- insert into sale(id,sale_date) values(119,'2021-05-26');
-- insert into sale(id,sale_date) values(120,'2021-05-27');
-- insert into sale(id,sale_date) values(121,'2021-05-28');
-- insert into sale(id,sale_date) values(122,'2021-05-29');
-- insert into sale(id,sale_date) values(123,'2021-05-30');
-- insert into sale(id,sale_date) values(124,'2021-05-31');

-- insert into sale(id,sale_date) values(125,'2021-05-01');
-- insert into sale(id,sale_date) values(126,'2021-05-02');
-- insert into sale(id,sale_date) values(127,'2021-05-03');
-- insert into sale(id,sale_date) values(128,'2021-05-04');
-- insert into sale(id,sale_date) values(129,'2021-05-05');
-- insert into sale(id,sale_date) values(130,'2021-05-06');
-- insert into sale(id,sale_date) values(131,'2021-05-07');
-- insert into sale(id,sale_date) values(132,'2021-05-08');
-- insert into sale(id,sale_date) values(133,'2021-05-09');
-- insert into sale(id,sale_date) values(134,'2021-05-10');
-- insert into sale(id,sale_date) values(135,'2021-05-11');
-- insert into sale(id,sale_date) values(136,'2021-05-12');
-- insert into sale(id,sale_date) values(137,'2021-05-13');
-- insert into sale(id,sale_date) values(138,'2021-05-14');
-- insert into sale(id,sale_date) values(139,'2021-05-15');
-- insert into sale(id,sale_date) values(140,'2021-05-16');
-- insert into sale(id,sale_date) values(141,'2021-05-17');
-- insert into sale(id,sale_date) values(142,'2021-05-18');
-- insert into sale(id,sale_date) values(143,'2021-05-19');
-- insert into sale(id,sale_date) values(144,'2021-05-20');
-- insert into sale(id,sale_date) values(145,'2021-05-21');
-- insert into sale(id,sale_date) values(146,'2021-05-22');
-- insert into sale(id,sale_date) values(147,'2021-05-23');
-- insert into sale(id,sale_date) values(148,'2021-05-24');
-- insert into sale(id,sale_date) values(149,'2021-05-25');
-- insert into sale(id,sale_date) values(150,'2021-05-26');
-- insert into sale(id,sale_date) values(151,'2021-05-27');
-- insert into sale(id,sale_date) values(152,'2021-05-28');
-- insert into sale(id,sale_date) values(153,'2021-05-29');
-- insert into sale(id,sale_date) values(154,'2021-05-30');
-- insert into sale(id,sale_date) values(155,'2021-05-31');



insert into sale(id,sale_date) values(1,'2021-05-01');
insert into sale(id,sale_date) values(2,'2021-05-02');
insert into sale(id,sale_date) values(3,'2021-05-03');
insert into sale(id,sale_date) values(4,'2021-05-04');
insert into sale(id,sale_date) values(5,'2021-05-05');
insert into sale(id,sale_date) values(6,'2021-05-06');
insert into sale(id,sale_date) values(7,'2021-05-07');
insert into sale(id,sale_date) values(8,'2021-05-08');
insert into sale(id,sale_date) values(9,'2021-05-09');
insert into sale(id,sale_date) values(10,'2021-05-10');
insert into sale(id,sale_date) values(11,'2021-05-11');
insert into sale(id,sale_date) values(12,'2021-05-12');
insert into sale(id,sale_date) values(13,'2021-05-13');
insert into sale(id,sale_date) values(14,'2021-05-14');
insert into sale(id,sale_date) values(15,'2021-05-15');
insert into sale(id,sale_date) values(16,'2021-05-16');
insert into sale(id,sale_date) values(17,'2021-05-17');
insert into sale(id,sale_date) values(18,'2021-05-18');
insert into sale(id,sale_date) values(19,'2021-05-19');
insert into sale(id,sale_date) values(20,'2021-05-20');
insert into sale(id,sale_date) values(21,'2021-05-21');
insert into sale(id,sale_date) values(22,'2021-05-22');
insert into sale(id,sale_date) values(23,'2021-05-23');
insert into sale(id,sale_date) values(24,'2021-05-24');
insert into sale(id,sale_date) values(25,'2021-05-25');
insert into sale(id,sale_date) values(26,'2021-05-26');
insert into sale(id,sale_date) values(27,'2021-05-27');
insert into sale(id,sale_date) values(28,'2021-05-28');
insert into sale(id,sale_date) values(29,'2021-05-29');
insert into sale(id,sale_date) values(30,'2021-05-30');
insert into sale(id,sale_date) values(31,'2021-05-31');
insert into sale(id,sale_date) values(32,'2021-05-01');
insert into sale(id,sale_date) values(33,'2021-05-02');
insert into sale(id,sale_date) values(34,'2021-05-03');
insert into sale(id,sale_date) values(35,'2021-05-04');
insert into sale(id,sale_date) values(36,'2021-05-05');
insert into sale(id,sale_date) values(37,'2021-05-06');
insert into sale(id,sale_date) values(38,'2021-05-07');
insert into sale(id,sale_date) values(39,'2021-05-08');
insert into sale(id,sale_date) values(40,'2021-05-09');
insert into sale(id,sale_date) values(41,'2021-05-10');
insert into sale(id,sale_date) values(42,'2021-05-11');
insert into sale(id,sale_date) values(43,'2021-05-12');
insert into sale(id,sale_date) values(44,'2021-05-13');
insert into sale(id,sale_date) values(45,'2021-05-14');
insert into sale(id,sale_date) values(46,'2021-05-15');
insert into sale(id,sale_date) values(47,'2021-05-16');
insert into sale(id,sale_date) values(48,'2021-05-17');
insert into sale(id,sale_date) values(49,'2021-05-18');
insert into sale(id,sale_date) values(50,'2021-05-19');
insert into sale(id,sale_date) values(51,'2021-05-20');
insert into sale(id,sale_date) values(52,'2021-05-21');
insert into sale(id,sale_date) values(53,'2021-05-22');
insert into sale(id,sale_date) values(54,'2021-05-23');
insert into sale(id,sale_date) values(55,'2021-05-24');
insert into sale(id,sale_date) values(56,'2021-05-25');
insert into sale(id,sale_date) values(57,'2021-05-26');
insert into sale(id,sale_date) values(58,'2021-05-27');
insert into sale(id,sale_date) values(59,'2021-05-28');
insert into sale(id,sale_date) values(60,'2021-05-29');
insert into sale(id,sale_date) values(61,'2021-05-30');
insert into sale(id,sale_date) values(62,'2021-05-31');
insert into sale(id,sale_date) values(63,'2021-05-01');
insert into sale(id,sale_date) values(64,'2021-05-02');
insert into sale(id,sale_date) values(65,'2021-05-03');
insert into sale(id,sale_date) values(66,'2021-05-04');
insert into sale(id,sale_date) values(67,'2021-05-05');
insert into sale(id,sale_date) values(68,'2021-05-06');
insert into sale(id,sale_date) values(69,'2021-05-07');
insert into sale(id,sale_date) values(70,'2021-05-08');
insert into sale(id,sale_date) values(71,'2021-05-09');
insert into sale(id,sale_date) values(72,'2021-05-10');
insert into sale(id,sale_date) values(73,'2021-05-11');
insert into sale(id,sale_date) values(74,'2021-05-12');
insert into sale(id,sale_date) values(75,'2021-05-13');
insert into sale(id,sale_date) values(76,'2021-05-14');
insert into sale(id,sale_date) values(77,'2021-05-15');
insert into sale(id,sale_date) values(78,'2021-05-16');
insert into sale(id,sale_date) values(79,'2021-05-17');
insert into sale(id,sale_date) values(80,'2021-05-18');
insert into sale(id,sale_date) values(81,'2021-05-19');
insert into sale(id,sale_date) values(82,'2021-05-20');
insert into sale(id,sale_date) values(83,'2021-05-21');
insert into sale(id,sale_date) values(84,'2021-05-22');
insert into sale(id,sale_date) values(85,'2021-05-23');
insert into sale(id,sale_date) values(86,'2021-05-24');
insert into sale(id,sale_date) values(87,'2021-05-25');
insert into sale(id,sale_date) values(88,'2021-05-26');
insert into sale(id,sale_date) values(89,'2021-05-27');
insert into sale(id,sale_date) values(90,'2021-05-28');
insert into sale(id,sale_date) values(91,'2021-05-29');
insert into sale(id,sale_date) values(92,'2021-05-30');
insert into sale(id,sale_date) values(93,'2021-05-31');
insert into sale(id,sale_date) values(94,'2021-05-01');
insert into sale(id,sale_date) values(95,'2021-05-02');
insert into sale(id,sale_date) values(96,'2021-05-03');
insert into sale(id,sale_date) values(97,'2021-05-04');
insert into sale(id,sale_date) values(98,'2021-05-05');
insert into sale(id,sale_date) values(99,'2021-05-06');
insert into sale(id,sale_date) values(100,'2021-05-07');
insert into sale(id,sale_date) values(101,'2021-05-08');
insert into sale(id,sale_date) values(102,'2021-05-09');
insert into sale(id,sale_date) values(103,'2021-05-10');
insert into sale(id,sale_date) values(104,'2021-05-11');
insert into sale(id,sale_date) values(105,'2021-05-12');
insert into sale(id,sale_date) values(106,'2021-05-13');
insert into sale(id,sale_date) values(107,'2021-05-14');
insert into sale(id,sale_date) values(108,'2021-05-15');
insert into sale(id,sale_date) values(109,'2021-05-16');
insert into sale(id,sale_date) values(110,'2021-05-17');
insert into sale(id,sale_date) values(111,'2021-05-18');
insert into sale(id,sale_date) values(112,'2021-05-19');
insert into sale(id,sale_date) values(113,'2021-05-20');
insert into sale(id,sale_date) values(114,'2021-05-21');
insert into sale(id,sale_date) values(115,'2021-05-22');
insert into sale(id,sale_date) values(116,'2021-05-23');
insert into sale(id,sale_date) values(117,'2021-05-24');
insert into sale(id,sale_date) values(118,'2021-05-25');
insert into sale(id,sale_date) values(119,'2021-05-26');
insert into sale(id,sale_date) values(120,'2021-05-27');
insert into sale(id,sale_date) values(121,'2021-05-28');
insert into sale(id,sale_date) values(122,'2021-05-29');
insert into sale(id,sale_date) values(123,'2021-05-30');
insert into sale(id,sale_date) values(124,'2021-05-31');
insert into sale(id,sale_date) values(125,'2021-05-01');
insert into sale(id,sale_date) values(126,'2021-05-02');
insert into sale(id,sale_date) values(127,'2021-05-03');
insert into sale(id,sale_date) values(128,'2021-05-04');
insert into sale(id,sale_date) values(129,'2021-05-05');
insert into sale(id,sale_date) values(130,'2021-05-06');
insert into sale(id,sale_date) values(131,'2021-05-07');
insert into sale(id,sale_date) values(132,'2021-05-08');
insert into sale(id,sale_date) values(133,'2021-05-09');
insert into sale(id,sale_date) values(134,'2021-05-10');
insert into sale(id,sale_date) values(135,'2021-05-11');
insert into sale(id,sale_date) values(136,'2021-05-12');
insert into sale(id,sale_date) values(137,'2021-05-13');
insert into sale(id,sale_date) values(138,'2021-05-14');
insert into sale(id,sale_date) values(139,'2021-05-15');
insert into sale(id,sale_date) values(140,'2021-05-16');
insert into sale(id,sale_date) values(141,'2021-05-17');
insert into sale(id,sale_date) values(142,'2021-05-18');
insert into sale(id,sale_date) values(143,'2021-05-19');
insert into sale(id,sale_date) values(144,'2021-05-20');
insert into sale(id,sale_date) values(145,'2021-05-21');
insert into sale(id,sale_date) values(146,'2021-05-22');
insert into sale(id,sale_date) values(147,'2021-05-23');
insert into sale(id,sale_date) values(148,'2021-05-24');
insert into sale(id,sale_date) values(149,'2021-05-25');
insert into sale(id,sale_date) values(150,'2021-05-26');
insert into sale(id,sale_date) values(151,'2021-05-27');
insert into sale(id,sale_date) values(152,'2021-05-28');
insert into sale(id,sale_date) values(153,'2021-05-29');
insert into sale(id,sale_date) values(154,'2021-05-30');
insert into sale(id,sale_date) values(155,'2021-05-31');
insert into sale(id,sale_date) values(156,'2021-05-01');
insert into sale(id,sale_date) values(157,'2021-05-02');
insert into sale(id,sale_date) values(158,'2021-05-03');
insert into sale(id,sale_date) values(159,'2021-05-04');
insert into sale(id,sale_date) values(160,'2021-05-05');
insert into sale(id,sale_date) values(161,'2021-05-06');
insert into sale(id,sale_date) values(162,'2021-05-07');
insert into sale(id,sale_date) values(163,'2021-05-08');
insert into sale(id,sale_date) values(164,'2021-05-09');
insert into sale(id,sale_date) values(165,'2021-05-10');
insert into sale(id,sale_date) values(166,'2021-05-11');
insert into sale(id,sale_date) values(167,'2021-05-12');
insert into sale(id,sale_date) values(168,'2021-05-13');
insert into sale(id,sale_date) values(169,'2021-05-14');
insert into sale(id,sale_date) values(170,'2021-05-15');
insert into sale(id,sale_date) values(171,'2021-05-16');
insert into sale(id,sale_date) values(172,'2021-05-17');
insert into sale(id,sale_date) values(173,'2021-05-18');
insert into sale(id,sale_date) values(174,'2021-05-19');
insert into sale(id,sale_date) values(175,'2021-05-20');
insert into sale(id,sale_date) values(176,'2021-05-21');
insert into sale(id,sale_date) values(177,'2021-05-22');
insert into sale(id,sale_date) values(178,'2021-05-23');
insert into sale(id,sale_date) values(179,'2021-05-24');
insert into sale(id,sale_date) values(180,'2021-05-25');
insert into sale(id,sale_date) values(181,'2021-05-26');
insert into sale(id,sale_date) values(182,'2021-05-27');
insert into sale(id,sale_date) values(183,'2021-05-28');
insert into sale(id,sale_date) values(184,'2021-05-29');
insert into sale(id,sale_date) values(185,'2021-05-30');
insert into sale(id,sale_date) values(186,'2021-05-31');
insert into sale(id,sale_date) values(187,'2021-05-01');
insert into sale(id,sale_date) values(188,'2021-05-02');
insert into sale(id,sale_date) values(189,'2021-05-03');
insert into sale(id,sale_date) values(190,'2021-05-04');
insert into sale(id,sale_date) values(191,'2021-05-05');
insert into sale(id,sale_date) values(192,'2021-05-06');
insert into sale(id,sale_date) values(193,'2021-05-07');
insert into sale(id,sale_date) values(194,'2021-05-08');
insert into sale(id,sale_date) values(195,'2021-05-09');
insert into sale(id,sale_date) values(196,'2021-05-10');
insert into sale(id,sale_date) values(197,'2021-05-11');
insert into sale(id,sale_date) values(198,'2021-05-12');
insert into sale(id,sale_date) values(199,'2021-05-13');
insert into sale(id,sale_date) values(200,'2021-05-14');
insert into sale(id,sale_date) values(201,'2021-05-15');
insert into sale(id,sale_date) values(202,'2021-05-16');
insert into sale(id,sale_date) values(203,'2021-05-17');
insert into sale(id,sale_date) values(204,'2021-05-18');
insert into sale(id,sale_date) values(205,'2021-05-19');
insert into sale(id,sale_date) values(206,'2021-05-20');
insert into sale(id,sale_date) values(207,'2021-05-21');
insert into sale(id,sale_date) values(208,'2021-05-22');
insert into sale(id,sale_date) values(209,'2021-05-23');
insert into sale(id,sale_date) values(210,'2021-05-24');
insert into sale(id,sale_date) values(211,'2021-05-25');
insert into sale(id,sale_date) values(212,'2021-05-26');
insert into sale(id,sale_date) values(213,'2021-05-27');
insert into sale(id,sale_date) values(214,'2021-05-28');
insert into sale(id,sale_date) values(215,'2021-05-29');
insert into sale(id,sale_date) values(216,'2021-05-30');
insert into sale(id,sale_date) values(217,'2021-05-31');
insert into sale(id,sale_date) values(218,'2021-05-01');
insert into sale(id,sale_date) values(219,'2021-05-02');
insert into sale(id,sale_date) values(220,'2021-05-03');
insert into sale(id,sale_date) values(221,'2021-05-04');
insert into sale(id,sale_date) values(222,'2021-05-05');
insert into sale(id,sale_date) values(223,'2021-05-06');
insert into sale(id,sale_date) values(224,'2021-05-07');
insert into sale(id,sale_date) values(225,'2021-05-08');
insert into sale(id,sale_date) values(226,'2021-05-09');
insert into sale(id,sale_date) values(227,'2021-05-10');
insert into sale(id,sale_date) values(228,'2021-05-11');
insert into sale(id,sale_date) values(229,'2021-05-12');
insert into sale(id,sale_date) values(230,'2021-05-13');
insert into sale(id,sale_date) values(231,'2021-05-14');
insert into sale(id,sale_date) values(232,'2021-05-15');
insert into sale(id,sale_date) values(233,'2021-05-16');
insert into sale(id,sale_date) values(234,'2021-05-17');
insert into sale(id,sale_date) values(235,'2021-05-18');
insert into sale(id,sale_date) values(236,'2021-05-19');
insert into sale(id,sale_date) values(237,'2021-05-20');
insert into sale(id,sale_date) values(238,'2021-05-21');
insert into sale(id,sale_date) values(239,'2021-05-22');
insert into sale(id,sale_date) values(240,'2021-05-23');
insert into sale(id,sale_date) values(241,'2021-05-24');
insert into sale(id,sale_date) values(242,'2021-05-25');
insert into sale(id,sale_date) values(243,'2021-05-26');
insert into sale(id,sale_date) values(244,'2021-05-27');
insert into sale(id,sale_date) values(245,'2021-05-28');
insert into sale(id,sale_date) values(246,'2021-05-29');
insert into sale(id,sale_date) values(247,'2021-05-30');
insert into sale(id,sale_date) values(248,'2021-05-31');
insert into sale(id,sale_date) values(249,'2021-05-01');
insert into sale(id,sale_date) values(250,'2021-05-02');
insert into sale(id,sale_date) values(251,'2021-05-03');
insert into sale(id,sale_date) values(252,'2021-05-04');
insert into sale(id,sale_date) values(253,'2021-05-05');
insert into sale(id,sale_date) values(254,'2021-05-06');
insert into sale(id,sale_date) values(255,'2021-05-07');
insert into sale(id,sale_date) values(256,'2021-05-08');
insert into sale(id,sale_date) values(257,'2021-05-09');
insert into sale(id,sale_date) values(258,'2021-05-10');
insert into sale(id,sale_date) values(259,'2021-05-11');
insert into sale(id,sale_date) values(260,'2021-05-12');
insert into sale(id,sale_date) values(261,'2021-05-13');
insert into sale(id,sale_date) values(262,'2021-05-14');
insert into sale(id,sale_date) values(263,'2021-05-15');
insert into sale(id,sale_date) values(264,'2021-05-16');
insert into sale(id,sale_date) values(265,'2021-05-17');
insert into sale(id,sale_date) values(266,'2021-05-18');
insert into sale(id,sale_date) values(267,'2021-05-19');
insert into sale(id,sale_date) values(268,'2021-05-20');
insert into sale(id,sale_date) values(269,'2021-05-21');
insert into sale(id,sale_date) values(270,'2021-05-22');
insert into sale(id,sale_date) values(271,'2021-05-23');
insert into sale(id,sale_date) values(272,'2021-05-24');
insert into sale(id,sale_date) values(273,'2021-05-25');
insert into sale(id,sale_date) values(274,'2021-05-26');
insert into sale(id,sale_date) values(275,'2021-05-27');
insert into sale(id,sale_date) values(276,'2021-05-28');
insert into sale(id,sale_date) values(277,'2021-05-29');
insert into sale(id,sale_date) values(278,'2021-05-30');
insert into sale(id,sale_date) values(279,'2021-05-31');
insert into sale(id,sale_date) values(280,'2021-05-01');
insert into sale(id,sale_date) values(281,'2021-05-02');
insert into sale(id,sale_date) values(282,'2021-05-03');
insert into sale(id,sale_date) values(283,'2021-05-04');
insert into sale(id,sale_date) values(284,'2021-05-05');
insert into sale(id,sale_date) values(285,'2021-05-06');
insert into sale(id,sale_date) values(286,'2021-05-07');
insert into sale(id,sale_date) values(287,'2021-05-08');
insert into sale(id,sale_date) values(288,'2021-05-09');
insert into sale(id,sale_date) values(289,'2021-05-10');
insert into sale(id,sale_date) values(290,'2021-05-11');
insert into sale(id,sale_date) values(291,'2021-05-12');
insert into sale(id,sale_date) values(292,'2021-05-13');
insert into sale(id,sale_date) values(293,'2021-05-14');
insert into sale(id,sale_date) values(294,'2021-05-15');
insert into sale(id,sale_date) values(295,'2021-05-16');
insert into sale(id,sale_date) values(296,'2021-05-17');
insert into sale(id,sale_date) values(297,'2021-05-18');
insert into sale(id,sale_date) values(298,'2021-05-19');
insert into sale(id,sale_date) values(299,'2021-05-20');
insert into sale(id,sale_date) values(300,'2021-05-21');
insert into sale(id,sale_date) values(301,'2021-05-22');
insert into sale(id,sale_date) values(302,'2021-05-23');
insert into sale(id,sale_date) values(303,'2021-05-24');
insert into sale(id,sale_date) values(304,'2021-05-25');
insert into sale(id,sale_date) values(305,'2021-05-26');
insert into sale(id,sale_date) values(306,'2021-05-27');
insert into sale(id,sale_date) values(307,'2021-05-28');
insert into sale(id,sale_date) values(308,'2021-05-29');
insert into sale(id,sale_date) values(309,'2021-05-30');
insert into sale(id,sale_date) values(310,'2021-05-31');

select * from sale;

insert  into product_sale(sale_id,product_id,quantity) values (1,1,3);
insert  into product_sale(sale_id,product_id,quantity) values (2,1,4);
insert  into product_sale(sale_id,product_id,quantity) values (3,1,11);
insert  into product_sale(sale_id,product_id,quantity) values (4,5,14);
insert  into product_sale(sale_id,product_id,quantity) values (5,1,13);
insert  into product_sale(sale_id,product_id,quantity) values (6,1,13);
insert  into product_sale(sale_id,product_id,quantity) values (7,1,16);
insert  into product_sale(sale_id,product_id,quantity) values (8,1,10);
insert  into product_sale(sale_id,product_id,quantity) values (9,1,18);
insert  into product_sale(sale_id,product_id,quantity) values (10,1,13);
insert  into product_sale(sale_id,product_id,quantity) values (11,1,14);
insert  into product_sale(sale_id,product_id,quantity) values (12,1,17);
insert  into product_sale(sale_id,product_id,quantity) values (13,1,22);
insert  into product_sale(sale_id,product_id,quantity) values (14,1,22);
insert  into product_sale(sale_id,product_id,quantity) values (15,1,19);
insert  into product_sale(sale_id,product_id,quantity) values (16,1,26);
insert  into product_sale(sale_id,product_id,quantity) values (17,1,26);
insert  into product_sale(sale_id,product_id,quantity) values (18,1,24);
insert  into product_sale(sale_id,product_id,quantity) values (19,1,20);
insert  into product_sale(sale_id,product_id,quantity) values (20,1,22);
insert  into product_sale(sale_id,product_id,quantity) values (21,1,26);
insert  into product_sale(sale_id,product_id,quantity) values (22,1,28);
insert  into product_sale(sale_id,product_id,quantity) values (23,1,23);
insert  into product_sale(sale_id,product_id,quantity) values (24,1,33);
insert  into product_sale(sale_id,product_id,quantity) values (25,1,26);
insert  into product_sale(sale_id,product_id,quantity) values (26,1,27);
insert  into product_sale(sale_id,product_id,quantity) values (27,1,31);
insert  into product_sale(sale_id,product_id,quantity) values (28,1,33);
insert  into product_sale(sale_id,product_id,quantity) values (29,1,36);
insert  into product_sale(sale_id,product_id,quantity) values (30,1,33);
insert  into product_sale(sale_id,product_id,quantity) values (31,1,35);

insert  into product_sale(sale_id,product_id,quantity) values (32,2,7);
insert  into product_sale(sale_id,product_id,quantity) values (33,2,5);
insert  into product_sale(sale_id,product_id,quantity) values (34,2,9);
insert  into product_sale(sale_id,product_id,quantity) values (35,2,4);
insert  into product_sale(sale_id,product_id,quantity) values (36,2,20);
insert  into product_sale(sale_id,product_id,quantity) values (37,2,8);
insert  into product_sale(sale_id,product_id,quantity) values (38,2,17);
insert  into product_sale(sale_id,product_id,quantity) values (39,2,9);
insert  into product_sale(sale_id,product_id,quantity) values (40,2,17);
insert  into product_sale(sale_id,product_id,quantity) values (41,2,4);
insert  into product_sale(sale_id,product_id,quantity) values (42,2,11);
insert  into product_sale(sale_id,product_id,quantity) values (43,2,11);
insert  into product_sale(sale_id,product_id,quantity) values (44,2,15);
insert  into product_sale(sale_id,product_id,quantity) values (45,2,2);
insert  into product_sale(sale_id,product_id,quantity) values (46,2,14);
insert  into product_sale(sale_id,product_id,quantity) values (47,2,12);
insert  into product_sale(sale_id,product_id,quantity) values (48,2,13);
insert  into product_sale(sale_id,product_id,quantity) values (49,2,8);
insert  into product_sale(sale_id,product_id,quantity) values (50,2,1);
insert  into product_sale(sale_id,product_id,quantity) values (51,2,10);
insert  into product_sale(sale_id,product_id,quantity) values (52,2,13);
insert  into product_sale(sale_id,product_id,quantity) values (53,2,3);
insert  into product_sale(sale_id,product_id,quantity) values (54,2,14);
insert  into product_sale(sale_id,product_id,quantity) values (55,2,20);
insert  into product_sale(sale_id,product_id,quantity) values (56,2,9);
insert  into product_sale(sale_id,product_id,quantity) values (57,2,6);
insert  into product_sale(sale_id,product_id,quantity) values (58,2,17);
insert  into product_sale(sale_id,product_id,quantity) values (59,2,6);
insert  into product_sale(sale_id,product_id,quantity) values (60,2,12);
insert  into product_sale(sale_id,product_id,quantity) values (61,2,18);
insert  into product_sale(sale_id,product_id,quantity) values (62,2,18);


insert  into product_sale(sale_id,product_id,quantity) values (63,3,5);
insert  into product_sale(sale_id,product_id,quantity) values (64,3,8);
insert  into product_sale(sale_id,product_id,quantity) values (65,3,7);
insert  into product_sale(sale_id,product_id,quantity) values (66,3,20);
insert  into product_sale(sale_id,product_id,quantity) values (67,3,9);
insert  into product_sale(sale_id,product_id,quantity) values (68,3,19);
insert  into product_sale(sale_id,product_id,quantity) values (69,3,13);
insert  into product_sale(sale_id,product_id,quantity) values (70,3,5);
insert  into product_sale(sale_id,product_id,quantity) values (71,3,16);
insert  into product_sale(sale_id,product_id,quantity) values (72,3,2);
insert  into product_sale(sale_id,product_id,quantity) values (73,3,11);
insert  into product_sale(sale_id,product_id,quantity) values (74,3,11);
insert  into product_sale(sale_id,product_id,quantity) values (75,3,6);
insert  into product_sale(sale_id,product_id,quantity) values (76,3,2);
insert  into product_sale(sale_id,product_id,quantity) values (77,3,2);
insert  into product_sale(sale_id,product_id,quantity) values (78,3,10);
insert  into product_sale(sale_id,product_id,quantity) values (79,3,1);
insert  into product_sale(sale_id,product_id,quantity) values (80,3,11);
insert  into product_sale(sale_id,product_id,quantity) values (81,3,12);
insert  into product_sale(sale_id,product_id,quantity) values (82,3,16);
insert  into product_sale(sale_id,product_id,quantity) values (83,3,12);
insert  into product_sale(sale_id,product_id,quantity) values (84,3,14);
insert  into product_sale(sale_id,product_id,quantity) values (85,3,14);
insert  into product_sale(sale_id,product_id,quantity) values (86,3,2);
insert  into product_sale(sale_id,product_id,quantity) values (87,3,15);
insert  into product_sale(sale_id,product_id,quantity) values (88,3,13);
insert  into product_sale(sale_id,product_id,quantity) values (89,3,2);
insert  into product_sale(sale_id,product_id,quantity) values (90,3,4);
insert  into product_sale(sale_id,product_id,quantity) values (91,3,16);
insert  into product_sale(sale_id,product_id,quantity) values (92,3,5);
insert  into product_sale(sale_id,product_id,quantity) values (93,3,19);


insert  into product_sale(sale_id,product_id,quantity) values (94,4,16);
insert  into product_sale(sale_id,product_id,quantity) values (95,4,9);
insert  into product_sale(sale_id,product_id,quantity) values (96,4,11);
insert  into product_sale(sale_id,product_id,quantity) values (97,4,17);
insert  into product_sale(sale_id,product_id,quantity) values (98,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (99,4,3);
insert  into product_sale(sale_id,product_id,quantity) values (100,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (101,4,14);
insert  into product_sale(sale_id,product_id,quantity) values (102,4,9);
insert  into product_sale(sale_id,product_id,quantity) values (103,4,15);
insert  into product_sale(sale_id,product_id,quantity) values (104,4,18);
insert  into product_sale(sale_id,product_id,quantity) values (105,4,13);
insert  into product_sale(sale_id,product_id,quantity) values (106,4,11);
insert  into product_sale(sale_id,product_id,quantity) values (107,4,14);
insert  into product_sale(sale_id,product_id,quantity) values (108,4,5);
insert  into product_sale(sale_id,product_id,quantity) values (109,4,13);
insert  into product_sale(sale_id,product_id,quantity) values (110,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (111,4,19);
insert  into product_sale(sale_id,product_id,quantity) values (112,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (113,4,10);
insert  into product_sale(sale_id,product_id,quantity) values (114,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (115,4,18);
insert  into product_sale(sale_id,product_id,quantity) values (116,4,10);
insert  into product_sale(sale_id,product_id,quantity) values (117,4,15);
insert  into product_sale(sale_id,product_id,quantity) values (118,4,15);
insert  into product_sale(sale_id,product_id,quantity) values (119,4,10);
insert  into product_sale(sale_id,product_id,quantity) values (120,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (121,4,4);
insert  into product_sale(sale_id,product_id,quantity) values (122,4,7);
insert  into product_sale(sale_id,product_id,quantity) values (123,4,3);
insert  into product_sale(sale_id,product_id,quantity) values (124,4,12);

insert  into product_sale(sale_id,product_id,quantity) values (125,5,20);
insert  into product_sale(sale_id,product_id,quantity) values (126,5,9);
insert  into product_sale(sale_id,product_id,quantity) values (127,5,9);
insert  into product_sale(sale_id,product_id,quantity) values (128,5,18);
insert  into product_sale(sale_id,product_id,quantity) values (129,5,13);
insert  into product_sale(sale_id,product_id,quantity) values (130,5,14);
insert  into product_sale(sale_id,product_id,quantity) values (131,5,5);
insert  into product_sale(sale_id,product_id,quantity) values (132,5,9);
insert  into product_sale(sale_id,product_id,quantity) values (133,5,14);
insert  into product_sale(sale_id,product_id,quantity) values (134,5,1);
insert  into product_sale(sale_id,product_id,quantity) values (135,5,18);
insert  into product_sale(sale_id,product_id,quantity) values (136,5,12);
insert  into product_sale(sale_id,product_id,quantity) values (137,5,20);
insert  into product_sale(sale_id,product_id,quantity) values (138,5,13);
insert  into product_sale(sale_id,product_id,quantity) values (139,5,19);
insert  into product_sale(sale_id,product_id,quantity) values (140,5,15);
insert  into product_sale(sale_id,product_id,quantity) values (141,5,12);
insert  into product_sale(sale_id,product_id,quantity) values (142,5,19);
insert  into product_sale(sale_id,product_id,quantity) values (143,5,9);
insert  into product_sale(sale_id,product_id,quantity) values (144,5,2);
insert  into product_sale(sale_id,product_id,quantity) values (145,5,20);
insert  into product_sale(sale_id,product_id,quantity) values (146,5,10);
insert  into product_sale(sale_id,product_id,quantity) values (147,5,10);
insert  into product_sale(sale_id,product_id,quantity) values (148,5,12);
insert  into product_sale(sale_id,product_id,quantity) values (149,5,4);
insert  into product_sale(sale_id,product_id,quantity) values (150,5,18);
insert  into product_sale(sale_id,product_id,quantity) values (151,5,18);
insert  into product_sale(sale_id,product_id,quantity) values (152,5,12);
insert  into product_sale(sale_id,product_id,quantity) values (153,5,8);
insert  into product_sale(sale_id,product_id,quantity) values (154,5,6);
insert  into product_sale(sale_id,product_id,quantity) values (155,5,2);

insert  into product_sale(sale_id,product_id,quantity) values (156,6,16);
insert  into product_sale(sale_id,product_id,quantity) values (157,6,14);
insert  into product_sale(sale_id,product_id,quantity) values (158,6,12);
insert  into product_sale(sale_id,product_id,quantity) values (159,6,8);
insert  into product_sale(sale_id,product_id,quantity) values (160,6,3);
insert  into product_sale(sale_id,product_id,quantity) values (161,6,15);
insert  into product_sale(sale_id,product_id,quantity) values (162,6,3);
insert  into product_sale(sale_id,product_id,quantity) values (163,6,13);
insert  into product_sale(sale_id,product_id,quantity) values (164,6,17);
insert  into product_sale(sale_id,product_id,quantity) values (165,6,13);
insert  into product_sale(sale_id,product_id,quantity) values (166,6,20);
insert  into product_sale(sale_id,product_id,quantity) values (167,6,10);
insert  into product_sale(sale_id,product_id,quantity) values (168,6,2);
insert  into product_sale(sale_id,product_id,quantity) values (169,6,15);
insert  into product_sale(sale_id,product_id,quantity) values (170,6,18);
insert  into product_sale(sale_id,product_id,quantity) values (171,6,5);
insert  into product_sale(sale_id,product_id,quantity) values (172,6,7);
insert  into product_sale(sale_id,product_id,quantity) values (173,6,12);
insert  into product_sale(sale_id,product_id,quantity) values (174,6,7);
insert  into product_sale(sale_id,product_id,quantity) values (175,6,5);
insert  into product_sale(sale_id,product_id,quantity) values (176,6,19);
insert  into product_sale(sale_id,product_id,quantity) values (177,6,13);
insert  into product_sale(sale_id,product_id,quantity) values (178,6,1);
insert  into product_sale(sale_id,product_id,quantity) values (179,6,13);
insert  into product_sale(sale_id,product_id,quantity) values (180,6,11);
insert  into product_sale(sale_id,product_id,quantity) values (181,6,7);
insert  into product_sale(sale_id,product_id,quantity) values (182,6,7);
insert  into product_sale(sale_id,product_id,quantity) values (183,6,19);
insert  into product_sale(sale_id,product_id,quantity) values (184,6,20);
insert  into product_sale(sale_id,product_id,quantity) values (185,6,4);
insert  into product_sale(sale_id,product_id,quantity) values (186,6,19);

insert  into product_sale(sale_id,product_id,quantity) values (187,7,13);
insert  into product_sale(sale_id,product_id,quantity) values (188,7,12);
insert  into product_sale(sale_id,product_id,quantity) values (189,7,20);
insert  into product_sale(sale_id,product_id,quantity) values (190,7,6);
insert  into product_sale(sale_id,product_id,quantity) values (191,7,1);
insert  into product_sale(sale_id,product_id,quantity) values (192,7,19);
insert  into product_sale(sale_id,product_id,quantity) values (193,7,15);
insert  into product_sale(sale_id,product_id,quantity) values (194,7,15);
insert  into product_sale(sale_id,product_id,quantity) values (195,7,15);
insert  into product_sale(sale_id,product_id,quantity) values (196,7,6);
insert  into product_sale(sale_id,product_id,quantity) values (197,7,19);
insert  into product_sale(sale_id,product_id,quantity) values (198,7,7);
insert  into product_sale(sale_id,product_id,quantity) values (199,7,8);
insert  into product_sale(sale_id,product_id,quantity) values (200,7,8);
insert  into product_sale(sale_id,product_id,quantity) values (201,7,20);
insert  into product_sale(sale_id,product_id,quantity) values (202,7,14);
insert  into product_sale(sale_id,product_id,quantity) values (203,7,5);
insert  into product_sale(sale_id,product_id,quantity) values (204,7,19);
insert  into product_sale(sale_id,product_id,quantity) values (205,7,7);
insert  into product_sale(sale_id,product_id,quantity) values (206,7,11);
insert  into product_sale(sale_id,product_id,quantity) values (207,7,16);
insert  into product_sale(sale_id,product_id,quantity) values (208,7,20);
insert  into product_sale(sale_id,product_id,quantity) values (209,7,13);
insert  into product_sale(sale_id,product_id,quantity) values (210,7,9);
insert  into product_sale(sale_id,product_id,quantity) values (211,7,14);
insert  into product_sale(sale_id,product_id,quantity) values (212,7,12);
insert  into product_sale(sale_id,product_id,quantity) values (213,7,14);
insert  into product_sale(sale_id,product_id,quantity) values (214,7,15);
insert  into product_sale(sale_id,product_id,quantity) values (215,7,9);
insert  into product_sale(sale_id,product_id,quantity) values (216,7,14);
insert  into product_sale(sale_id,product_id,quantity) values (217,7,18);

insert  into product_sale(sale_id,product_id,quantity) values (218,8,16);
insert  into product_sale(sale_id,product_id,quantity) values (219,8,12);
insert  into product_sale(sale_id,product_id,quantity) values (220,8,18);
insert  into product_sale(sale_id,product_id,quantity) values (221,8,16);
insert  into product_sale(sale_id,product_id,quantity) values (222,8,15);
insert  into product_sale(sale_id,product_id,quantity) values (223,8,17);
insert  into product_sale(sale_id,product_id,quantity) values (224,8,18);
insert  into product_sale(sale_id,product_id,quantity) values (225,8,6);
insert  into product_sale(sale_id,product_id,quantity) values (226,8,3);
insert  into product_sale(sale_id,product_id,quantity) values (227,8,20);
insert  into product_sale(sale_id,product_id,quantity) values (228,8,7);
insert  into product_sale(sale_id,product_id,quantity) values (229,8,15);
insert  into product_sale(sale_id,product_id,quantity) values (230,8,20);
insert  into product_sale(sale_id,product_id,quantity) values (231,8,9);
insert  into product_sale(sale_id,product_id,quantity) values (232,8,1);
insert  into product_sale(sale_id,product_id,quantity) values (233,8,5);
insert  into product_sale(sale_id,product_id,quantity) values (234,8,15);
insert  into product_sale(sale_id,product_id,quantity) values (235,8,3);
insert  into product_sale(sale_id,product_id,quantity) values (236,8,6);
insert  into product_sale(sale_id,product_id,quantity) values (237,8,6);
insert  into product_sale(sale_id,product_id,quantity) values (238,8,14);
insert  into product_sale(sale_id,product_id,quantity) values (239,8,2);
insert  into product_sale(sale_id,product_id,quantity) values (240,8,19);
insert  into product_sale(sale_id,product_id,quantity) values (241,8,11);
insert  into product_sale(sale_id,product_id,quantity) values (242,8,7);
insert  into product_sale(sale_id,product_id,quantity) values (243,8,5);
insert  into product_sale(sale_id,product_id,quantity) values (244,8,1);
insert  into product_sale(sale_id,product_id,quantity) values (245,8,9);
insert  into product_sale(sale_id,product_id,quantity) values (246,8,2);
insert  into product_sale(sale_id,product_id,quantity) values (247,8,16);
insert  into product_sale(sale_id,product_id,quantity) values (248,8,3);

insert  into product_sale(sale_id,product_id,quantity) values (249,9,14);
insert  into product_sale(sale_id,product_id,quantity) values (250,9,16);
insert  into product_sale(sale_id,product_id,quantity) values (251,9,5);
insert  into product_sale(sale_id,product_id,quantity) values (252,9,1);
insert  into product_sale(sale_id,product_id,quantity) values (253,9,16);
insert  into product_sale(sale_id,product_id,quantity) values (254,9,3);
insert  into product_sale(sale_id,product_id,quantity) values (255,9,14);
insert  into product_sale(sale_id,product_id,quantity) values (256,9,12);
insert  into product_sale(sale_id,product_id,quantity) values (257,9,20);
insert  into product_sale(sale_id,product_id,quantity) values (258,9,11);
insert  into product_sale(sale_id,product_id,quantity) values (259,9,15);
insert  into product_sale(sale_id,product_id,quantity) values (260,9,18);
insert  into product_sale(sale_id,product_id,quantity) values (261,9,8);
insert  into product_sale(sale_id,product_id,quantity) values (262,9,6);
insert  into product_sale(sale_id,product_id,quantity) values (263,9,16);
insert  into product_sale(sale_id,product_id,quantity) values (264,9,15);
insert  into product_sale(sale_id,product_id,quantity) values (265,9,14);
insert  into product_sale(sale_id,product_id,quantity) values (266,9,5);
insert  into product_sale(sale_id,product_id,quantity) values (267,9,8);
insert  into product_sale(sale_id,product_id,quantity) values (268,9,13);
insert  into product_sale(sale_id,product_id,quantity) values (269,9,17);
insert  into product_sale(sale_id,product_id,quantity) values (270,9,4);
insert  into product_sale(sale_id,product_id,quantity) values (271,9,9);
insert  into product_sale(sale_id,product_id,quantity) values (272,9,3);
insert  into product_sale(sale_id,product_id,quantity) values (273,9,5);
insert  into product_sale(sale_id,product_id,quantity) values (274,9,18);
insert  into product_sale(sale_id,product_id,quantity) values (275,9,9);
insert  into product_sale(sale_id,product_id,quantity) values (276,9,15);
insert  into product_sale(sale_id,product_id,quantity) values (277,9,16);
insert  into product_sale(sale_id,product_id,quantity) values (278,9,11);
insert  into product_sale(sale_id,product_id,quantity) values (279,9,8);

insert  into product_sale(sale_id,product_id,quantity) values (280,10,3);
insert  into product_sale(sale_id,product_id,quantity) values (281,10,8);
insert  into product_sale(sale_id,product_id,quantity) values (282,10,17);
insert  into product_sale(sale_id,product_id,quantity) values (283,10,6);
insert  into product_sale(sale_id,product_id,quantity) values (284,10,1);
insert  into product_sale(sale_id,product_id,quantity) values (285,10,4);
insert  into product_sale(sale_id,product_id,quantity) values (286,10,4);
insert  into product_sale(sale_id,product_id,quantity) values (287,10,13);
insert  into product_sale(sale_id,product_id,quantity) values (288,10,8);
insert  into product_sale(sale_id,product_id,quantity) values (289,10,5);
insert  into product_sale(sale_id,product_id,quantity) values (290,10,1);
insert  into product_sale(sale_id,product_id,quantity) values (291,10,17);
insert  into product_sale(sale_id,product_id,quantity) values (292,10,6);
insert  into product_sale(sale_id,product_id,quantity) values (293,10,15);
insert  into product_sale(sale_id,product_id,quantity) values (294,10,19);
insert  into product_sale(sale_id,product_id,quantity) values (295,10,3);
insert  into product_sale(sale_id,product_id,quantity) values (296,10,5);
insert  into product_sale(sale_id,product_id,quantity) values (297,10,16);
insert  into product_sale(sale_id,product_id,quantity) values (298,10,6);
insert  into product_sale(sale_id,product_id,quantity) values (299,10,7);
insert  into product_sale(sale_id,product_id,quantity) values (300,10,7);
insert  into product_sale(sale_id,product_id,quantity) values (301,10,5);
insert  into product_sale(sale_id,product_id,quantity) values (302,10,18);
insert  into product_sale(sale_id,product_id,quantity) values (303,10,8);
insert  into product_sale(sale_id,product_id,quantity) values (304,10,2);
insert  into product_sale(sale_id,product_id,quantity) values (305,10,12);
insert  into product_sale(sale_id,product_id,quantity) values (306,10,3);
insert  into product_sale(sale_id,product_id,quantity) values (307,10,7);
insert  into product_sale(sale_id,product_id,quantity) values (308,10,17);
insert  into product_sale(sale_id,product_id,quantity) values (309,10,2);
insert  into product_sale(sale_id,product_id,quantity) values (310,10,4);

select * from sale;
select * from product;
select * from product_sale;



insert into purchase_order(order_date) values('2021-05-10');
insert into order_details(emp_id,sup_id,purchase_id,product_id,quantity,price) values(1,3,1,1,500,50000);

insert into purchase_order(order_date) values('2021-02-10');
insert into order_details(emp_id,sup_id,purchase_id,product_id,quantity,price) values(1,3,2,1,300,30000);


insert into purchase_order(order_date) values('2021-05-03');
insert into order_details(emp_id,sup_id,purchase_id,product_id,quantity,price) values(1,1,3,2,50,5000);

insert into purchase_order(order_date) values('2021-09-10');
insert into order_details(emp_id,sup_id,purchase_id,product_id,quantity,price) values(1,1,4,2,700,35000);








