drop table if exists users;
create table users(
	name varchar, 
	email varchar UNIQUE CONSTRAINT valid_email CHECK (email ~ '\A\S+@\S+\.\S+\Z'), 
	phone varchar CONSTRAINT valid_phone CHECK (phone ~ '\A\+\d+\Z'),
	created_at timestamp default now() not null, 
	updated_at timestamp default now() not null	
);
-- drop type if exists user_json CASCADE;
-- create type user_json as (
-- 	name varchar(255),
-- 	email varchar(255),
-- 	phone varchar(255),
-- 	registered_at TIMESTAMP
-- );

-- Get all users
-- drop function if exists all_users();
-- create function all_users(OUT data jsonb)
-- as $$
-- DECLARE
-- 	user_info user_json[];	
-- BEGIN
-- 	user_info := array_agg(s) from (select name, email, phone, created_at from users) as s;	
-- 	data := array_to_json(user_info);
-- END;
-- $$ LANGUAGE PLPGSQL;
-- select data from all_users();

-- Get a user
-- drop function if exists get_user(login VARCHAR);
-- create function get_user(login VARCHAR, OUT data jsonb)
-- as $$
-- DECLARE
-- 	user_info user_json;
-- BEGIN
-- 	select name, email, phone, created_at from users where email = login or phone = login limit 1 into user_info;
-- 	data := row_to_json(user_info);		
-- END;
-- $$ LANGUAGE PLPGSQL;
-- select data from get_user('+86139131239123');

-- Create a user
drop function if exists create_user(name VARCHAR, email varchar, phone varchar);
create function create_user(new_name VARCHAR default null, new_email varchar default null, new_phone varchar default null, OUT data jsonb)
as $$
BEGIN
	insert into users(name, email, phone) values(new_name, new_email, new_phone);
	data := get_user(new_email);			

Exception when integrity_constraint_violation then
	if sqlerrm like '%valid_phone%' then
		RAISE 'The phone format is invalid' USING CONSTRAINT = 'valid_phone';
	ELSIF sqlerrm like '%valid_email%' then
		RAISE 'The email format is invalid' USING CONSTRAINT = 'valid_email';
	END IF;
END;
$$ LANGUAGE PLPGSQL;
select data from create_user('Allyson', 'allyson@chen.com', '+86139131239123r');
