create or replace package taxi_Rum.pkg_procedures
as 

    

    procedure rent_driver_car(rent_driver_id int, rent_car_id int);
    
    procedure disrent_car(rent_car_id int, amount_of_gas number, went_distance number);
    
    --procedure car_refueling(rent_car_id int, address_refueling_id int, amount_of_payment number, currency_country_id int, payment_type_id int, amount_of_gas number);
    
    procedure rating_passanger_update(amount_of_day int);
    
    procedure rating_driver_update(amount_of_day int);

    type varray_type_massive_address_id IS VARRAY(5) of int;
    type varray_type_massive_of_distance IS VARRAY(5) of number;
    procedure order_create(passenger_id int, address_passenger_id int, massive_address_id varray_type_massive_address_id, massive_of_distance varray_type_massive_of_distance, amount_of_payment number, payment_type_id int, currency_country_id int);
    
end Pkg_procedures;

create or replace package body taxi_Rum.pkg_procedures
as 
--begin procedure rent_driver_car
    procedure rent_driver_car(rent_driver_id int, rent_car_id int) as
    begin
        insert into taxi_Rum.rent (driver_id, car_id, date_start, date_stop, gas_mileage, distance, time_create) values (rent_driver_id, rent_car_id, current_timestamp, null, null, null,  current_timestamp);
        update taxi_Rum.car set is_reserved = 1 where id = rent_car_id;
    end rent_driver_car;
--end procedure rent_driver_car

--begin procedure disrent_car
    procedure disrent_car(rent_car_id int, amount_of_gas number, went_distance number)
    as
    begin
        update taxi_Rum.car 
        set 
            is_reserved = 0, 
            mileage = mileage + went_distance 
        where id = rent_car_id;
        
        update taxi_Rum.rent set date_stop = current_timestamp where ((car_id = rent_car_id) and (date_stop is null));
        update taxi_Rum.rent set gas_mileage = amount_of_gas where ((car_id = rent_car_id) and (gas_mileage is null));
        update taxi_Rum.rent set distance = went_distance where ((car_id = rent_car_id) and (distance is null));
    end disrent_car;
--end procedure disrent_car


--begin  procedure car_refueling
    /*procedure car_refueling(rent_car_id int, address_refueling_id int, amount_of_payment number, currency_country_id int, payment_type_id int, amount_of_gas number)
    as
    
    driver_rent_id int;
    refuel_payment_id int;
    
    begin
        insert into taxi_Rum.payment (amount_to_paid, currency_id, type, time_create) values (amount_of_payment, currency_country_id, payment_type_id, current_timestamp);
        
        driver_rent_id := 1001;
        refuel_payment_id :=1;
            
        insert into taxi_Rum.refueling (driver_id, car_id, payment_id, address_id, amount_of_gas, time_create) values (driver_rent_id, rent_car_id, refuel_payment_id , address_refueling_id, rent_car_amount_of_gas, current_timestamp);
    end car_refueling;
    */
--end  procedure car_refueling

--begin   procedure rating_passanger_update
    procedure rating_passanger_update(amount_of_day int)
    as   
    
    cursor C_rating_sel
    is 
        select 
            passenger_id as pas_id,
            avg(rating) as avg_rat
        from taxi_Rum.rating_driver2passenger
        where time_create >= to_date(current_timestamp) - amount_of_day
        group by passenger_id;
    begin       
        for item in C_rating_sel loop
            update taxi_Rum.passanger_rating set rating = item.avg_rat where id = item.pas_id;
            update taxi_Rum.passanger_rating set time_create = current_timestamp where id = item.pas_id;
        end loop;
    end rating_passanger_update;
--end   procedure rating_passanger_update

--begin   procedure rating_driver_update
    procedure rating_driver_update(amount_of_day int)
    as   
    
    cursor C_rating_sel
    is 
        select 
            driver_id as dr_id,
            avg(rating) as avg_rat
        from taxi_Rum.rating_passenger2driver
        where time_create >= to_date(current_timestamp) - amount_of_day
        group by driver_id;
    begin       
        for item in C_rating_sel loop
            update taxi_Rum.passanger_rating set rating = item.avg_rat where id = item.dr_id;
            update taxi_Rum.passanger_rating set time_create = current_timestamp where id = item.dr_id;
        end loop;
    end rating_driver_update;
--end   procedure rating_driver_update

--begin   procedure order_create
    procedure order_create(passenger_id int, address_passenger_id int, massive_address_id varray_type_massive_address_id, massive_of_distance varray_type_massive_of_distance, amount_of_payment number, payment_type_id int, currency_country_id int)
    as
    
    rent_payment_id int;
    
    Vfrom_address_id int;
    Vto_address_id int;
    Vdistance number;
    
    begin
        
        insert into taxi_Rum.payment (amount_to_paid, currency_id, type, time_create) values (amount_of_payment, currency_country_id, payment_type_id, current_timestamp);
        rent_payment_id := 1;
        insert into taxi_Rum.taxi_order (passenger_id, driver_id, time_create, time_end, status_id, payment_id, end_trip_address, average_driver_speed) values (passenger_id, null, current_timestamp, null, 1, rent_payment_id , &, null);
        
        for i in 1..massive_address_id.count - 1 loop
            if massive_address_id(i) != 0 then
                Vfrom_address_id := massive_address_id(i);
                Vto_address_id := massive_address_id(i + 1);
                Vdistance := massive_of_distance(i + 1);
                insert into taxi_Rum.way (from_address_id, to_address_id, distance, order_id, preview_way_id, time_create) values (Vfrom_address_id, Vto_address_id, Vdistance, 1, null, current_timestamp);
            end if;
        end loop;
    end order_create;
--end   procedure order_create

end Pkg_procedures;


begin
    taxi_Rum.pkg_procedures.rent_driver_car(1002, 1);
end;

select * from taxi_Rum.car;
select * from taxi_Rum.rent;

