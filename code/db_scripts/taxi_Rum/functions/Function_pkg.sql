create or replace package taxi_Rum.pkg_functions
as 
    type sal_record is record (
                                driver_id       int,
                                salary          number
                                );
    type row_sal_rec is table of sal_record;
    function salary_get(LVmonth int, LVyear int) return row_sal_rec pipelined;
    
end pkg_functions;

create or replace package body taxi_Rum.pkg_functions
as 

    function salary_get(LVmonth int, LVyear int) return row_sal_rec pipelined
    is
    
    cursor Cdriver_id is    
    select
        distinct
        id as id
    from taxi_Rum.driver;
    
    LVclear_sal number;
    LVref_money number;
    LVpercent_of_payment number;
    
    LVreturn_row sal_record;
    
    begin
        
        for item in Cdriver_id loop
        
            select
                sum(pay.amount_to_paid)
                into
                LVclear_sal
            from
                taxi_Rum.taxi_order ord
            inner join taxi_Rum.payment pay on
                ord.payment_id = pay.id
            where
                ord.driver_id = item.id and
                to_char(TRUNC ( pay.time_create , 'MM' )) = to_char('01.'||LVyear||'.'||LVmonth);
            
            select
                sum(pay.amount_to_paid)
                into
                LVref_money
            from
                taxi_Rum.refueling ref
            inner join taxi_Rum.payment pay on
                ref.payment_id = pay.id
            where
                ref.driver_id = item.id and
                to_char(TRUNC ( pay.time_create , 'MM' )) = to_char('01.'||LVyear||'.'||LVmonth);
            
            select
                dr.percent_of_payment
                into
                LVpercent_of_payment
            from
                taxi_Rum.driver dr
            where
                 dr.id = item.id;
            
            LVreturn_row:= null;
            LVreturn_row.driver_id := item.id;
            LVreturn_row.salary := LVpercent_of_payment*(LVclear_sal - LVref_money);
            
            pipe row (LVreturn_row);
            
        end loop;
        
        return;
        
    end salary_get;
    
end pkg_functions;