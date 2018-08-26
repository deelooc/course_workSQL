SELECT ('ФИО: Kleimenov Ivan');

-- 1. Вывести количество жанров книг
SELECT * FROM library;

-- 2. Вывести средний возраст сотрудников

SELECT AVG(age) as avg_age FROM employee;

-- 3. Вывести средний возраст сотрудников у которых образование Мастер

SELECT AVG(age) FROM employee WHERE  education LIKE '%Masters';

-- 4. Вывести количество сотрудников которые старше 30 лет

SELECT COUNT(name_id) as count_name FROM employee WHERE age > 30;

-- 5. Вывести минимальный возраст сотрудника

SELECT MAX(age) FROM employee;

-- 6. Вывести максимальный возраст сотрудника

SELECT Min(age) FROM employee;

-- 7. Вывести три самых популярных жанра литературы (genre) среди выборки из 251 читателя (разного возраста, пола, образование, сферы деятельности)

WITH tmp_tab as (SELECT * FROM library JOIN library_card ON library.book_id=library_card.book_genre_id) SELECT genre, COUNT(book_genre_id) as top_genre FROM tmp_tab GROUP BY genre ORDER BY top_genre DESC LIMIT 3;


-- 8. Создать новую таблицу books_after_50 в которую сохранить все книги (book_genre_id), возраст, пол читателя (age, gender) и время чтения людей старше 50 лет

WITH tmp_tab as (SELECT * FROM library_card JOIN employee ON library_card.nameid=employee.name_id) SELECT book_genre_id, age, gender, reading_time_days, education INTO books_after_50 FROM tmp_tab WHERE age > 50;

-- 9. Вывести топ-3 жанра которые читают женщины старше 50 лет

WITH tmp_tab as (SELECT * FROM library JOIN books_after_50 ON library.book_id=books_after_50.book_genre_id) SELECT DISTINCT genre FROM tmp_tab WHERE age>50 and gender LIKE '%Female' LIMIT 3;


-- 10. Вывести средний значения продолжительности чтения книг в зависимости от жанра

WITH tmp_tab as (SELECT * FROM library JOIN library_card ON library.book_id=library_card.book_genre_id) SELECT genre, AVG(reading_time_days) as read_term FROM tmp_tab GROUP BY genre ORDER BY read_term DESC;


-- 11. Вывести данные сколько в среднем в неделю работают женщины с образование Бакалавр

SELECT AVG(hours_per_week) AS avg_hours FROM employee WHERE education LIKE '%Bachelors' AND gender LIKE '%Male';

-- 12.  Сделать новую таблицу new_emp_data в которой отразить отрасли (industry), уровень образования (education) возраст и время работы в неделю (hours_per_week)

WITH tmp_tab as (SELECT * FROM industry JOIN employee ON industry.ind_id=employee.workclass_id) SELECT industry, name_id, age, education, gender, occupation, hours_per_week INTO new_emp_data FROM tmp_tab;

-- 13. Из таблицы new_emp_data  выбрать данные в какой отрасли сотрудники работают больше чем 40 часов в неделю

SELECT industry, AVG(hours_per_week) as avg_hours FROM new_emp_data GROUP BY industry HAVING AVG(hours_per_week) > 40 ORDER BY avg_hours DESC;

-- 14. В какой отрасли и с каким образованием сотрудники работаю меньше всего часов в неделю

SELECT industry, education, hours_per_week FROM (SELECT industry, education, hours_per_week FROM new_emp_data WHERE hours_per_week < 40) as strange_stat ORDER BY hours_per_week  LIMIT 5;

-- 15. В какой отрасли в среднем дольше всего читают книги

WITH tmp_tab as (SELECT * FROM new_emp_data JOIN library_card ON library_card.nameid= new_emp_data.name_id) SELECT industry, AVG(reading_time_days) as avg_read_time FROM tmp_tab GROUP BY industry ORDER BY avg_read_time DESC limit 5;


-- 16. В какой отрасли в среднем дольше всего читают книги и сколько среднем часов работают сотрудник данной отрасли

WITH tmp_tab as (SELECT * FROM new_emp_data JOIN library_card ON library_card.nameid= new_emp_data.name_id) SELECT industry, AVG(reading_time_days) as avg_read_time, AVG(hours_per_week
) as avg_work_time FROM tmp_tab GROUP BY industry ORDER BY avg_read_time DESC;

-- 17. Сравнить возраст каждого сотрудника в отдельной отрасли со среднем возрастом в этой отрасли

SELECT industry, age, AVG(age) OVER (PARTITION BY industry) FROM new_emp_data LIMIT 15;

-- 18. Выбрать данные по среднем количество отработанных часов в неделю работников разных специальностей с разным уровнем образования в энергетической отрасли

SELECT industry, education, age, AVG(hours_per_week) OVER (PARTITION BY education ORDER BY industry) FROM new_emp_data WHERE industry LIKE '%Energy' ORDER BY education DESC LIMIT 10;

-- На основе данных моей БД создать как минимум два представления (View) на основании логики и специфики данных


--  Создаем представление: три самых популярных жанра литературы (genre) среди выборки из 251 читателя (разного возраста, пола, образование, сферы деятельности)

CREATE VIEW top3_book_genre AS WITH tmp_tab as (SELECT * FROM library JOIN library_card ON library.book_id=library_card.book_genre_id) SELECT genre, COUNT(book_genre_id) as top_genre FROM tmp_tab GROUP BY genre ORDER BY top_genre DESC LIMIT 3;

-- Создаем представление: средние значения продолжительности чтения книг в зависимости от жанра

CREATE VIEW readingTERM_book_genre AS WITH tmp_tab as (SELECT * FROM library JOIN library_card ON library.book_id=library_card.book_genre_id) SELECT genre, AVG(reading_time_days) as read_term FROM tmp_tab GROUP BY genre ORDER BY read_term DESC;

-- Создаем представление: в какой отрасли в среднем дольше всего читают книги

CREATE VIEW  industry_reading_time AS WITH tmp_tab as (SELECT * FROM new_emp_data JOIN library_card ON library_card.nameid= new_emp_data.name_id) SELECT industry, AVG(reading_time_days) as avg_read_time FROM tmp_tab GROUP BY industry ORDER BY avg_read_time DESC;

