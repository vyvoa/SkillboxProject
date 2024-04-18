
create or replace view taxi_Rum.v_passenger_select_of_five_driver 
as
select 
    distinct
    pass_id,
    pas_name,
    driver_id,
    driver_name,
    rating as driver_rating
from (
        select
            distinct
            ord.passenger_id pass_id,
            pas.name as pas_name,
            dr.id as driver_id,
            dr.name as driver_name,
            dr_rat.rating as rating,
            row_number() over (partition by ord.passenger_id order by ord.passenger_id) as rn
        from taxi_Rum.driver dr
        left outer join TAXI_RUM.taxi_order ord
            on ord.driver_id != dr.id
        inner join TAXI_RUM.driver_rating dr_rat
            on dr.id = dr_rat.id
        inner join TAXI_RUM.passenger pas
            on ord.passenger_id = pas.id
        where
            dr_rat.rating > 4
        order by ord.passenger_id
    )
where rn < 6
order by pass_id;



create or replace view taxi_Rum.v_passenger_select_of_ten_most_popular_endaddress
as
select 
        distinct
        pass_name,
        street_numb
from (
    select 
            passenger.name as pass_name,
            street.name || ' ' ||address.house_number as street_numb,
            count(taxi_order.passenger_id) over (partition by taxi_order.passenger_id) as cnt_member_orders,
            row_number() over (partition by taxi_order.passenger_id, taxi_order.end_trip_address order by taxi_order.end_trip_address) as rn
    
    from TAXI_RUM.passenger passenger
    inner join TAXI_RUM.taxi_order taxi_order
        on taxi_order.passenger_id = passenger.id
    inner join taxi_Rum.address address
        on address.id = taxi_order.end_trip_address
    inner join taxi_Rum.street street
        on street.id = address.street_id
    )
where 
        cnt_member_orders > 1 and
        rn < 5
order by pass_name;

create or replace view taxi_Rum.v_avg_amount_of_payment_group_by_country
as
    select
            country.id as count_id,
            country.name as count_name,
            avg(payment.amount_to_paid) as avg_amount_to_paid
            
    from TAXI_RUM.taxi_order taxi_order
    inner join TAXI_RUM.address address
        on taxi_order.end_trip_address = address.id
    inner join TAXI_RUM.street street
        on address.street_id = street.id
    inner join TAXI_RUM.city city
        on street.city_id = city.id
    inner join TAXI_RUM.country country
        on city.country_id = country.id
    inner join TAXI_RUM.payment payment
        on payment.id = taxi_order.payment_id
    group by country.id, country.name
    order by country.id asc;


create or replace view taxi_Rum.v_amount_to_paid_by_1_km_at_rus_by_month
as
select
        city_name,
        round(sum_amount_to_paid / sum_distance, 2) as amount_to_paid_by_1_km,
        date_month as month_of_statistic
        
from (
    
    select
            country.id as count_id,
            country.name as count_name,
            city.id as city_id,
            city.name as city_name,
            sum(payment.amount_to_paid) over (partition by taxi_order.id, city.id, TRUNC ( payment.time_create , 'MM' )) as sum_amount_to_paid,
            sum(way.distance) over (partition by taxi_order.id, city.id, TRUNC ( payment.time_create , 'MM' )) as sum_distance,
            TRUNC ( payment.time_create , 'MM' ) as date_month
            
            
    from TAXI_RUM.taxi_order taxi_order
    inner join TAXI_RUM.address address
        on taxi_order.end_trip_address = address.id
    inner join TAXI_RUM.street street
        on address.street_id = street.id
    inner join TAXI_RUM.city city
        on street.city_id = city.id
    inner join TAXI_RUM.country country
        on city.country_id = country.id
    inner join TAXI_RUM.payment payment
        on payment.id = taxi_order.payment_id
    inner join TAXI_RUM.way way
        on way.order_id = taxi_order.id
    )
where count_id = 1
;

create or replace view taxi_Rum.v_gasoline_rate_in_different_city
as
select
    city_name as city_name,
    round(sum_amount_to_paid/sum_amount_of_gas, 2) as gasoline_rate
from(
    select 
            sum(refueling.amount_of_gas) over (partition by city.id) as sum_amount_of_gas,
            sum(payment.amount_to_paid/rate.rate)  over (partition by city.id) as  sum_amount_to_paid,
            city.name as city_name,
            city.id
            
    from TAXI_RUM.refueling refueling
    inner join TAXI_RUM.payment payment
            on payment.id = refueling.payment_id
    inner join TAXI_RUM.address address
            on refueling.address_id = address.id
    inner join TAXI_RUM.street street
            on address.street_id = street.id
    inner join TAXI_RUM.city city
            on street.city_id = city.id
    inner join TAXI_RUM.rate rate
            on rate.currency2_id = payment.currency_id
    where trunc(rate.time_create, 'DD') = trunc(payment.time_create, 'DD')
    )
order by city_name asc
;





