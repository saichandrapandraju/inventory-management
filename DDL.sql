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

drop table if exists brand;

create table brand (
	name varchar(64) not null unique
);

drop table if exists category;

create table category (
	id int primary key auto_increment,
    name varchar(64) not null unique,
    description varchar(128) default null
);

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
    location varchar(64) not null unique,
    brand varchar(64) not null,
    category int not null,
    supplier int not null,
	constraint product_fk_brand foreign key (brand) references brand (name) on update cascade on delete restrict,
    constraint product_fk_category foreign key (category) references category (id) on update cascade on delete restrict,
    constraint product_fk_supplier foreign key (supplier) references supplier (id) on update cascade on delete restrict
);

drop table if exists order_details;

create table order_details (
	emp_id int not null,
    sup_id int not null,
    purchase_id int not null,
    product_id int not null,
    quantity int not null,
    price float not null,
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
	select * from category;
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
create procedure create_employee(first_name_in varchar(128), last_name_in varchar(128), address_in varchar(300), emp_type_in enum("Manager", "Worker"), phone_in varchar(15), ssn_in varchar(15))
begin
	if not exists (select * from employee where lower(ssn)=lower(ssn_in)) then 
		insert into employee(first_name, last_name, address, emp_type, phone, ssn) values(first_name_in, last_name_in, address_in, emp_type_in, phone_in, ssn_in);
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
	select * from employee;
end $$
delimiter ;
-- call all_employees();



drop procedure if exists get_employee_by_id;
delimiter $$
create procedure get_employee_by_id(id_in int)
begin
	select * from employee where id=id_in;
end $$
delimiter ;

-- call get_employee_by_id(1);


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






















