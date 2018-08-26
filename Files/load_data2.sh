#/bin/sh


psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS industry"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS employee"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS library"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS library_card"




echo "Загружаем industry.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS industry (
    ind_id bigint PRIMARY KEY,
    industry varchar(355)
  );'

psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy industry FROM '/data/industry.csv' DELIMITER ',' CSV HEADER"


echo "Загружаем employee.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS employee (
    name_id bigint PRIMARY KEY,
    age bigint,
    workclass_id bigint,
    FOREIGN KEY (workclass_id) REFERENCES industry(ind_id),
    education varchar(355),
    occupation varchar(355),
    gender varchar(355),
    hours_per_week bigint
  );'

psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy employee FROM '/data/employee.csv' DELIMITER ',' CSV HEADER"


echo "Загружаем library.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS library (
    book_id bigint PRIMARY KEY,
    genre varchar(355)
  );'

psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy library FROM '/data/library.csv' DELIMITER ',' CSV HEADER"

echo "Загружаем library_card.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE IF NOT EXISTS library_card (
    nameid bigint,
    FOREIGN KEY (nameid) REFERENCES employee (name_id),
    book_genre_id bigint,
    FOREIGN KEY (book_genre_id) REFERENCES library(book_id),
    reading_time_days bigint
  );'

psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "\\copy library_card FROM '/data/library_card.csv' DELIMITER ',' CSV HEADER"