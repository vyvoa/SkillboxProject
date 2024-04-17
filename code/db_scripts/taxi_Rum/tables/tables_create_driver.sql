--start table taxi_Rum.driver
create table taxi_Rum.driver (
                        id                  int not null, -- driver_id
                        name                varchar2(255) not null,
                        age                 smallint,
                        phone_number        varchar2(50) not null,
                        percent_of_payment  decimal not null,
                        registration_date   date not null,
                        time_create         timestamp not null,
                        primary key(id)
                    );
comment on column taxi_Rum.driver.id is 'driver_id';
-- end table taxi_Rum.driver

--start table taxi_Rum.driver_image
create table taxi_Rum.driver_image (
                        id              int not null, -- driver_id
                        image           clob,
                        time_create     timestamp not null,
                        foreign key(id) references taxi_Rum.driver
                    );
comment on column taxi_Rum.driver_image.id is 'driver_id';
-- end table taxi_Rum.driver_image

--start table taxi_Rum.driver_rating
create table taxi_Rum.driver_rating (
                        id              int not null, -- driver_id
                        rating          decimal,
                        time_create     timestamp not null,
                        foreign key(id) references taxi_Rum.driver
                    );
comment on column taxi_Rum.driver_rating.id is 'driver_id';
-- end table taxi_Rum.driver_rating

--start table taxi_Rum.parking
create table taxi_Rum.parking (
                        id              int not null, -- parking_id
                        number1         int not null UNIQUE,
                        address_id      int not null,
                        time_create     timestamp not null,
                        primary key (id),
                        foreign key(address_id ) references taxi_Rum.address
                    );
comment on column taxi_Rum.parking.id is 'parking_id';
-- end table taxi_Rum.parking

--start table taxi_Rum.car_color
create table taxi_Rum.car_color (
                        id              int not null, -- color_id
                        color           varchar2(20) not null,
                        primary key (id)
                    );
comment on column taxi_Rum.car_color.id is 'color_id';

insert into  taxi_Rum.car_color (id , color) 
values
     (1, 'White'),
     (2, 'Black'),
     (3, 'Grey'),
     (4, 'Red'),
     (5, 'Blue'),
     (6, 'Yellow'),
     (7, 'Green');

-- end table taxi_Rum.car_color



--start table taxi_Rum.car
create table taxi_Rum.car (
                        id              int not null, -- parking_id
                        brand           varchar2(50),
                        model           varchar2(50),
                        color           int not null,
                        is_reserved     smallint not null, --boolean 1-true 0-false
                        state_number    varchar2(50) not null unique,
                        parking_id      int not null,
                        mileage         number not null,
                        time_create     timestamp not null,
                        primary key (id),
                        foreign key(color) references taxi_Rum.car_color,
                        foreign key(parking_id) references taxi_Rum.parking
                    );
comment on column taxi_Rum.car.id is 'car_id';
comment on column taxi_Rum.car.is_reserved is 'boolean 1-true 0-false'; 
-- end table taxi_Rum.car

--start table taxi_Rum.rent
create table taxi_Rum.rent (
                        id              int not null, -- rent_id
                        driver_id       int not null,
                        car_id          int not null,
                        date_start      date not null,
                        date_stop       date not null,                        
                        gas_mileage     decimal,
                        distance        number,
                        time_create     timestamp not null,
                        primary key (id),
                        foreign key(driver_id) references taxi_Rum.driver,
                        foreign key(car_id) references taxi_Rum.car
                    );
comment on column taxi_Rum.rent.id is 'rent_id';
comment on column taxi_Rum.rent.is_reserved is 'boolean 1-true 0-false'; 
-- end table taxi_Rum.rent