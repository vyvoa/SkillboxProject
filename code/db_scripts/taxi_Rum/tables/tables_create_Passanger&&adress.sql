--start table taxi_Rum.country
create table taxi_Rum.country (
                        id              int not null, -- country_id
                        name            varchar2(255) not null,
                        time_create     timestamp not null,
                        primary key(id)
                    );
comment on column taxi_Rum.country.id is 'country_id';
-- end table taxi_Rum.country

--start table taxi_Rum.city
create table taxi_Rum.city (
                        id              int not null, -- city_id
                        name            varchar2(255) not null,
                        country_id      int not null,
                        time_create     timestamp not null,
                        primary key(id),
                        foreign key (country_id) references taxi_Rum.country
                    );
comment on column taxi_Rum.city.id is 'city_id';
-- end table taxi_Rum.city

--start table taxi_Rum.street
create table taxi_Rum.street (
                        id              int not null, -- street_id
                        name            varchar2(255) not null,
                        city_id         int not null,
                        time_create     timestamp not null,
                        primary key (id),
                        foreign key (city_id) references taxi_Rum.city
                    );
comment on column taxi_Rum.street.id is 'street_id';
-- end table taxi_Rum.street

-- start table taxi_Rum.address
create table taxi_Rum.address (
                        id              int not null, -- home_address_id
                        street_id       int not null,
                        time_create     timestamp not null,
                        primary key (id),
                        foreign key (street_id) references taxi_Rum.street
                    );
comment on column taxi_Rum.address.id is 'home_address_id';
-- end table taxi_Rum.address

--start table taxi_Rum.passenger
create table taxi_Rum.passenger (
                                    id                  int not null, -- passenger id
                                    is_anonimous        smallint not null, --boolean 1-true 0-false
                                    name                varchar2(255),
                                    age                 smallint,
                                    home_address_id     int,
                                    phone_number        varchar2(50) not null,
                                    is_male             smallint, --boolean 1-true 0-false
                                    time_create         timestamp not null,
                                    primary key (id),
                                    foreign key (home_address_id) references taxi_Rum.address
);
comment on column taxi_Rum.passenger.id is 'passenger id';
comment on column taxi_Rum.passenger.is_anonimous is 'boolean 1-true 0-false'; 
comment on column taxi_Rum.passenger.is_male is 'boolean 1-true 0-false null - undefined'; 

--drop table taxi_Rum.passenger;

-- end taxi_Rum.passenger

--start table taxi_Rum.passanger_image
create table taxi_Rum.passanger_image (
                        id              int not null, -- passanger_id
                        image           clob,
                        time_create     timestamp not null,
                        foreign key (id) references taxi_Rum.passenger
                     );
comment on column taxi_Rum.passanger_image.id is 'passanger_id';
-- end table taxi_Rum.passanger_image

--start table taxi_Rum.passanger_rating
create table taxi_Rum.passanger_rating (
                        id                  int not null, -- passanger_id
                        rating              decimal(1,1),
                        time_create         timestamp not null,
                        foreign key (id) references taxi_Rum.passengers
                    );
comment on column taxi_Rum.passanger_rating.id is 'passanger_id';
-- end table taxi_Rum.passanger_rating