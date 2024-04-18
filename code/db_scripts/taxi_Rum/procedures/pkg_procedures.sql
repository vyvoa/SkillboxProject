
create or replace package taxi_Rum.pkg_types 
as
    type varray_type_massive_address_id is table of int index by PLS_INTEGER;
    type varray_type_massive_of_distance is table of number index by PLS_INTEGER;
end pkg_types;

create or replace package taxi_Rum.pkg_procedures
as 

    

    procedure rent_driver_car(rent_driver_id int, rent_car_id int);
    
    procedure disrent_car(rent_car_id int, amount_of_gas number, went_distance number);
    
    procedure car_refueling(rent_car_id int, address_refueling_id int, amount_of_payment number, currency_country_id int, payment_type_id int, rent_car_amount_of_gas number);
    
    procedure order_create(Vpassenger_id int, address_passenger_id int, massive_address_id taxi_Rum.pkg_types.varray_type_massive_address_id, massive_of_distance taxi_Rum.pkg_types.varray_type_massive_of_distance, amount_of_payment number, payment_type_id int, currency_country_id int);
    
    procedure rating_passanger_update(amount_of_day int);
    
    procedure rating_driver_update(amount_of_day int);
    
end Pkg_procedures;



create or replace package body taxi_Rum.pkg_procedures
as 
--begin procedure rent_driver_car
    procedure rent_driver_car(rent_driver_id int, rent_car_id int) as
    begin
        insert into taxi_Rum.rent (driver_id, car_id, date_stop, gas_mileage, distance) values (rent_driver_id, rent_car_id,  null, null, null);
        update taxi_Rum.car set is_reserved = 1 where id = rent_car_id;
    end rent_driver_car;
--end procedure rent_driver_car

--begin procedure disrent_car
    procedure disrent_car(rent_car_id int, amount_of_gas number, went_distance number)
    as
    begin
        update taxi_Rum.car set is_reserved = 0 where id = rent_car_id;
        update taxi_Rum.car set mileage = mileage + went_distance where id = rent_car_id;
        update taxi_Rum.rent set date_stop = current_timestamp where id = rent_car_id and date_stop = null;
        update taxi_Rum.rent set gas_mileage = amount_of_gas where id = rent_car_id and gas_mileage = null;
        update taxi_Rum.rent set distance = went_distance where id = rent_car_id and distance = null;
    end disrent_car;
--end procedure disrent_car




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
    procedure order_create(Vpassenger_id int, address_passenger_id int, massive_address_id taxi_Rum.pkg_types.varray_type_massive_address_id, massive_of_distance taxi_Rum.pkg_types.varray_type_massive_of_distance, amount_of_payment number, payment_type_id int, currency_country_id int)
    as
    
    Vrent_payment_id int;
    Vend_trip_address int := (massive_address_id(massive_address_id.last));
    Vfrom_address_id int;
    Vto_address_id int;
    Vdistance number;
    LVpreview_way_id int;
    Vorder_id int;
    
    begin
        insert into taxi_Rum.payment (amount_to_paid, currency_id, type) values (amount_of_payment, currency_country_id, payment_type_id) returning id into Vrent_payment_id;               
        insert into taxi_Rum.taxi_order (passenger_id, driver_id, time_end, status_id, payment_id, end_trip_address, average_driver_speed) values (Vpassenger_id, null, null, 1, Vrent_payment_id, Vend_trip_address, null) returning id into Vorder_id;
        
        
        for i in massive_address_id.first..massive_address_id.last - 1 loop
            if massive_address_id(i) != 0 then
                Vfrom_address_id := massive_address_id(i);
                Vto_address_id := massive_address_id(i + 1);
                Vdistance := massive_of_distance(i + 1);
                if i = 1 then
                    insert into taxi_Rum.way (from_address_id, to_address_id, distance, order_id, preview_way_id) values (Vfrom_address_id, Vto_address_id, Vdistance, Vorder_id, null) returning id into LVpreview_way_id;
                else
                    insert into taxi_Rum.way (from_address_id, to_address_id, distance, order_id, preview_way_id) values (Vfrom_address_id, Vto_address_id, Vdistance, Vorder_id, LVpreview_way_id) returning id into LVpreview_way_id;
                end if;
            end if;
        end loop;        

    end order_create;
--end   procedure order_create

--begin  procedure car_refueling
    procedure car_refueling(rent_car_id int, address_refueling_id int, amount_of_payment number, currency_country_id int, payment_type_id int, rent_car_amount_of_gas number)
    as
    
    driver_rent_id int;
    refuel_payment_id int;
    
    begin
        insert into taxi_Rum.payment (amount_to_paid, currency_id, type) values (amount_of_payment, currency_country_id, payment_type_id) returning id into refuel_payment_id;
        
        for item in (select 
            driver_id as dr_id
        from taxi_Rum.rent
        where 
            car_id = rent_car_id and
            date_stop is null and
            gas_mileage is null and
            distance is null) loop
            driver_rent_id := item.dr_id;
            end loop;            
        insert into taxi_Rum.refueling (driver_id, car_id, payment_id, address_id, amount_of_gas) values (driver_rent_id, rent_car_id, refuel_payment_id , address_refueling_id, rent_car_amount_of_gas);
    end car_refueling;
    
--end  procedure car_refueling

end Pkg_procedures;



