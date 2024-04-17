

create or replace package taxi_Rum.pkg_procedures
as 
    
    
    
end Pkg_procedures;



create or replace package body taxi_Rum.pkg_procedures
as 




end pkg_procedures;


declare
    type varray_type_massive_address_id is table of int index by PLS_INTEGER;
    type varray_type_massive_of_distance is table of number index by PLS_INTEGER;
    name1 varray_type_massive_address_id;
    name2 varray_type_massive_of_distance;
    
begin    
    
    name1(1):=1;
    name1(2):=2;
    name1(3):=3;
    
    name2(1):= 0;
    name2(2):= 45;
    name2(3):= 16;
    
    taxi_Rum.pkg_procedures.order_create(1,1, name1, name2 , 70,1,1);
end;


select * from taxi_Rum.car;
