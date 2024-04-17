--start table taxi_Rum.currency
create table taxi_Rum.currency (
                        id                  int not null, -- currency_id
                        name                varchar2(50) not null,
                        abbrevation         varchar2(8) not null,
                        time_create         timestamp not null,
                        primary key(id)
                    );
comment on column taxi_Rum.currency.id is 'currency_id';
-- end table taxi_Rum.currency

--start table taxi_Rum.rate
create table taxi_Rum.rate (
                        id                  int not null, -- rate_id
                        currency1_id        int not null,
                        currency2_id        int not null,
                        rate                decimal not null,
                        time_create         timestamp not null,
                        primary key(id),
                        foreign key(currency1_id) references taxi_Rum.currency,
                        foreign key(currency2_id) references taxi_Rum.currency
                    );
comment on column taxi_Rum.rate.id is 'rate_id';
-- end table taxi_Rum.rate

--start table taxi_Rum.currency2country
create table taxi_Rum.currency2country (
                        currency_id         int not null, 
                        country_id          int not null,
                        time_create         timestamp not null,
                        foreign key(currency_id) references taxi_Rum.currency,
                        foreign key(country_id) references taxi_Rum.country
                    );
-- end table taxi_Rum.currency2country

--start table taxi_Rum.payment
create table taxi_Rum.payment (
                        id                  int not null, -- payment_id
                        amount_to_paid      decimal not null,
                        currency_id         int not null,
                        type                in not null,
                        time_create         timestamp not null,
                        primary key(id),
                        foreign key(currency_id) references taxi_Rum.currency,
                        foreign key(type) references taxi_Rum.payment_type
                    );
comment on column taxi_Rum.payment.id is 'payment_id';
-- end table taxi_Rum.payment

--start table taxi_Rum.payment_type
create table taxi_Rum.payment_type (
                        id                  int not null, -- payment_type_id
                        type_name           varchar2(8),
                        time_create         timestamp not null,
                        primary key(id)
                    );
comment on column taxi_Rum.payment.id is 'payment_type_id';

insert into taxi_Rum.payment_type (id, type_name) values
    (1, 'card'),
    (2, 'cash');
-- end table taxi_Rum.payment_type

--start table taxi_Rum.order
create table taxi_Rum.order (
                        id                      int not null, -- order_id
                        passenger_id            int not null,
                        driver_id               int,
                        time_create             timestamp not null,
                        time_end                timestamp,
                        status                  int not null,
                        payment_id              int not null,
                        end_trip_address        int,
                        average_driver_speed    decimal,
                        primary key(id),
                        foreign key(passenger_id) references taxi_Rum.passenger,
                        foreign key(driver_id) references taxi_Rum.driver, 
                        foreign key(payment_id) references taxi_Rum.payment,
                        foreign key(end_trip_address) references taxi_Rum.address,
                        foreign key(type) references taxi_Rum.payment_type
                    );
comment on column taxi_Rum.order.id is 'order_id';
-- end table taxi_Rum.order

--start table taxi_Rum.order_status
create table taxi_Rum.order_status (
                        id                  int not null, -- order_id
                        status_name         varchar2(32),
                        time_create         timestamp not null,
                        primary key(id)
                    );
comment on column taxi_Rum.order_status.id is 'order_status_id';

insert into taxi_Rum.order_status (id, status_name) values
    (1, 'search_driver'),
    (2, 'wait_driver'),
    (3, 'wait_passenger'),
    (4, 'trip_started'),
    (5, 'wait_payment'),
    (6, 'trip_completed'),
    (7, 'canceled');
-- end table taxi_Rum.order_status

-- start table taxi_Rum.way
create table taxi_Rum.way (
                        id                  int not null, -- way_id
                        from_address_id     int not null,
                        to_address_id       int not null,
                        distance            decimal not null,
                        order_id            int not null,
                        preview_way_id      int,
                        time_create         timestamp not null,
                        primary key(id),
                        foreign key(from_address_id) references taxi_Rum.address,
                        foreign key(to_address_id) references taxi_Rum.address,
                        foreign key(order_id) references taxi_Rum.order,
                        foreign key(preview_way_id) references taxi_Rum.way
                        
                    );
comment on column taxi_Rum.way.id is 'way_id';

-- end table taxi_Rum.way

-- start table taxi_Rum.rating_passenger2driver
create table taxi_Rum.rating_passenger2driver (
                        id              int identity(1,1) not null, -- rating_passenger2driver
                        passenger_id    int not null,
                        driver_id       int not null,
                        order_id        int not null,
                        rating          decimal,
                        time_create     timestamp not null,
                        primary key(id),
                        foreign key(passenger_id) references taxi_Rum.passenger,
                        foreign key(driver_id) references taxi_Rum.driver,
                        foreign key(order_id) references taxi_Rum.order                       
                    );
comment on column taxi_Rum.rating_passenger2driver.id is 'rating_passenger2driver_id';

-- end table taxi_Rum.rating_passenger2driver

-- start table taxi_Rum.rating_driver2passenge
create table taxi_Rum.rating_driver2passenger (
                        id              int identity(1,1) not null, -- rating_driver2passenge
                        passenger_id    int not null,
                        driver_id       int not null,
                        order_id        int not null,
                        rating          decimal,
                        time_create     timestamp not null,
                        primary key(id),
                        foreign key(passenger_id) references taxi_Rum.passenger,
                        foreign key(driver_id) references taxi_Rum.driver,
                        foreign key(order_id) references taxi_Rum.order                       
                    );
comment on column taxi_Rum.rating_driver2passenge.id is 'rating_driver2passenge_id';

-- end table taxi_Rum.rating_passenger2driver

-- start table taxi_Rum.refueling
create table taxi_Rum.refueling (
                        id              int identity(1,1) not null, -- refueling
                        driver_id       int not null,
                        car_id          int not null,
                        payment_id      int not null,
                        address_id      int not null,
                        amount_of_gas   decimal not null,
                        time_create     timestamp not null,
                        primary key(id),
                        foreign key(driver_id) references taxi_Rum.driver,
                        foreign key(car_id) references taxi_Rum.car,
                        foreign key(payment_id) references taxi_Rum.payment,
                        foreign key(address_id) references taxi_Rum.address
                    );
comment on column taxi_Rum.refueling.id is 'refueling_id';

-- end table taxi_Rum.rating_passenger2driver
