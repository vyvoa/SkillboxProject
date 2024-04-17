create user taxi_Rum
    IDENTIFIED by taxi_Rum1
    default tablespace sysaux
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED on sysaux
    account unlock;    
    
grant create session to taxi_Rum;

--drop user taxi_Rum cascade;