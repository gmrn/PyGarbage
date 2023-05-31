# СИМУЛЯТОР SQL

[karpov.courses](https://lab.karpov.courses/learning/152/)

[Redash](https://redash.public.karpov.courses/)

#
#
#

## 4 Фильтрация данных

- [PostgreSQL WHERE](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-where/)
- [Collation Support](https://www.postgresql.org/docs/current/collation.html)
- [PostgreSQL LIKE](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-like/)
- [PostgreSQL IN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-in/)
- [PostgreSQL BETWEEN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-between/)
- [PostgreSQL IS NULL](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-is-null/)



**summary**

- Фильтрация данных и логические выражения в `WHERE`
- Шаблоны для текстовых значений с помощью оператора `LIKE`
- Операторы `IN`  и  `BETWEEN`
- `NULL` значения и `IS NULL`
- Даты, время и диапазоны значений
- Использование `CASE`

```sql
SELECT     -- перечисление полей результирующей таблицы
FROM       -- указание источника данных
WHERE      -- фильтрация данных
ORDER BY   -- сортировка результирующей таблицы
LIMIT      -- ограничение количества выводимых записей
```



[Practice](sql_queries/simulator_sql/4_filter.sql)

### LIMIT

```sql
-- task 2
SELECT user_id
FROM   users
WHERE  sex = 'female'
ORDER BY user_id limit 1000
```

### SPLIT_PART

```sql
-- task 5
SELECT product_id,
       name
FROM   products
WHERE  length(name) = 5
    or split_part(name, ' ', 1) = 'чай'
GROUP BY product_id
```

### LIKE

```sql
SELECT 'karpov.courses' LIKE 'karpov%'
-- true

SELECT 'karpov.courses' LIKE 'karpov_'
-- false

SELECT 'karpov.courses' LIKE '%karpov%'
-- true

SELECT 'karpov.courses' LIKE '_karpov%'
-- false

SELECT 'karpov.courses' LIKE '%.%'
-- true

SELECT 'karpov.courses' LIKE '_._'
-- false

SELECT 'karpov.courses' LIKE 'Karpov%'
-- false
```

```sql
-- task 6
SELECT product_id,
       name
FROM   products
WHERE  lower(name) like '%чай%'
ORDER BY product_id
```

```sql
-- task 7
SELECT product_id,
       name
FROM   products
WHERE  lower(name) like 'с%'
   and name not like '% %'
ORDER BY product_id
```

### BETWEEN, IN, desc

```sql
-- task 9
SELECT *
FROM   user_actions
WHERE  user_id in (170, 200, 230)
   and time between '2022.08.24'
   and '2022.09.05'
ORDER BY order_id desc
```

### DATE_PART

```sql
-- task 13
SELECT order_id
FROM   user_actions
WHERE  action = 'create_order'
   and date_part('month', time) = 8
   and date_part('year', time) = 2022
ORDER BY order_id
```

```sql
-- task 14
SELECT courier_id
FROM   couriers
WHERE  date_part('year', birth_date) between 1990
   and 1995
ORDER BY courier_id
```

```sql
-- task 15
SELECT *
FROM   user_actions
WHERE  action = 'cancel_order'
   and date_part('year', time) = 2022
   and date_part('month', time) = 8
   and date_part('dow', time) = 3
   and date_part('hour', time) between 12
   and 15
ORDER BY order_id desc
```

### CASE, WHEN, THEN, END

```sql
-- task 16
SELECT product_id,
       name,
       price,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price/120*20, 2) end as tax,
       case when name in ('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') then round(price - price/110*10,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         2)
            else round(price - price/120*20, 2) end as price_before_tax
FROM   products
ORDER BY price_before_tax desc, product_id
```





## 5 Агрегация данных

- [PostgreSQL SELECT DISTINCT](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-select-distinct/)
- [PostgreSQL Aggregate Functions](https://www.postgresqltutorial.com/postgresql-aggregate-functions/)
- [Aggregate Functions](https://www.postgresql.org/docs/9.5/functions-aggregate.html)
- [Array Functions and Operators](https://www.postgresql.org/docs/8.4/functions-array.html)



**summary**

- Поиск уникальных записей - ключевое слово `DISTINCT`

- Агрегирующие функции

- `COUNT(*)` и `COUNT(column)`.

- Фильтрация и агрегация в одном запросе

- Функция `array_length`

- Разница дат - функция `AGE`

- Агрегатные выражения с фильтрацией

  

[Practice](sql_queries/simulator_sql/5_aggregate.sql)

### DISTINCT

```sql
-- task 2
SELECT DISTINCT courier_id,
                order_id
FROM   courier_actions
ORDER BY courier_id, order_id
```

```sql
-- task 4
SELECT count(*) dates,
       count(birth_date) dates_not_null
FROM   users

```

### COUNT(*), COUNT(column1, column2...)

```sql
-- task 5
SELECT count(*) users,
       count(distinct user_id) unique_users
FROM   user_actions
```

### array_length

```sql
SELECT array_length(ARRAY[1,2,3], 1)
-- 3


--  _______
-- | 1 | 2 |
-- | 3 | 4 |
-- | 5 | 6 |
-- ‾‾‾‾‾‾‾

SELECT array_length(ARRAY[[1,2], [3,4], [5,6]], 1)
-- 3

SELECT array_length(ARRAY[[1,2], [3,4], [5,6]], 2)
-- 2
```

```sql
-- task 9
SELECT count(product_ids) orders
FROM   orders
WHERE  array_length(product_ids, 1) = 9
```

### AGE, current_date

```sql
SELECT AGE('2022-12-12', '2021-11-10')
-- 397 days, 0:00:00

SELECT current_date

SELECT AGE(current_date, '2021-11-10') 
SELECT AGE('2021-11-10') -- same before


SELECT AGE(current_date, '2021-11-10')::VARCHAR
-- 1 year 1 mon 2 days
```

```sql
-- task 13
select age(max(birth_date), min(birth_date))::VARCHAR age_diff
from users
where sex='male'
```

***

```sql
-- task 11
SELECT sum(case when name = 'сухарики' then price * 3
                when name = 'чипсы' then price * 2
                when name = 'энергетический напиток' then price
                else 0 end) as order_price
FROM   products
```

```sql
-- task 14
SELECT round(avg(array_length(product_ids, 1)), 2) avg_order_size
FROM   orders
WHERE  date_part('dow', creation_time) in (6, 0)
```

### FILTER

```sql
-- task 16
select count(DISTINCT user_id) - count(DISTINCT user_id) filter(where action = 'cancel_order') users_count

from user_actions
```

```sql
-- task 17
SELECT count(*) orders,
       count(*) filter(WHERE array_length(product_ids, 1) >= 5) large_orders,
       round(count(*) filter(WHERE array_length(product_ids, 1) >= 5) / count(*)::decimal,
             2)large_orders_share
FROM   orders
```





## 6 Группировка данных

- [PostgreSQL DATE_TRUNC Function](https://www.postgresqltutorial.com/postgresql-date-functions/postgresql-date_trunc/)



**summary**

- Работа с оператором `GROUP BY`

- Агрегирующие функции с сгруппированным данными
- Фильтрация результата группировки с помощью оператора `HAVING`
- Округление дат - `DATE_TRUNC`
- Агрегатные выражения поверх группировки
- Решение задачи с группировкой и `CASE`

```sql
SELECT     -- перечисление полей результирующей таблицы
FROM       -- указание источника данных
WHERE      -- фильтрация данных
GROUP BY   -- группировка данных
HAVING     -- фильтрация данных после группировки
ORDER BY   -- сортировка результирующей таблицы
LIMIT      -- ограничение количества выводимых записей
```



[Practice](sql_queries/simulator_sql/6_groups.sql)

### GROUP BY

При использовании группировки колонки, указанные в `SELECT`, должны находиться и в `GROUP BY`, если они не используются в агрегационных функциях. Это обязательное условие, и если оно не будет выполнено, то база данных вернёт ошибку

```sql
SELECT column_1, column_2, SUM(column_3)
FROM table
GROUP BY 1, 2
```

```sql
-- task 4
SELECT date_part('year', age((birth_date))) age,
       sex,
       count(1) users_count
FROM   users
WHERE  birth_date is not null
GROUP BY age, sex
ORDER BY age, sex
```

### DATE_TRUNC

```sql
SELECT DATE_TRUNC('month', TIMESTAMP '2022-01-12 08:55:30')
-- 01/01/22 00:00

SELECT DATE_TRUNC('day', TIMESTAMP '2022-01-12 08:55:30')
-- 12/01/22 00:00	

SELECT DATE_TRUNC('hour', TIMESTAMP '2022-01-12 08:55:30')
-- 12/01/22 08:00	
```

```sql
-- task 5
SELECT date_trunc('month', time) as month,
       action,
       count(order_id) orders_count
FROM   user_actions
GROUP BY month, action
```

### HAVING

```sql
-- task 7
SELECT array_length(product_ids, 1) order_size,
       count(order_id) orders_count
FROM   orders
GROUP BY order_size having count(order_id) > 5000
ORDER BY order_size
```

```sql
-- task 10
SELECT user_id
FROM   user_actions
WHERE  action = 'create_order'
GROUP BY user_id having max(time) < '2022-09-08'
ORDER BY user_id
```

### GROUP BY + filter, CASE

```sql
-- task 11
SELECT user_id,
       round(count(distinct order_id) filter(WHERE action = 'cancel_order')::decimal / count(distinct order_id)::decimal,
             2) cancel_rate
FROM   user_actions
GROUP BY user_id
ORDER BY user_id
```

```sql
-- task 12
SELECT case when date_part('year', age(birth_date)) between 19 and
                 24 then '19-24'
            when date_part('year', age(birth_date)) between 25 and
                 29 then '25-29'
            when date_part('year', age(birth_date)) between 30 and
                 35 then '30-35'
            when date_part('year', age(birth_date)) between 36 and
                 41 then '36-41' end as group_age,
       count(user_id) as users_count
FROM   users
WHERE  birth_date is not null
GROUP BY group_age
ORDER BY group_age	
```





## 7 Подзапросы

- [A Comprehensive Look at PostgreSQL Interval Data Type](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-interval/)
- [PostgreSQL NOW Function](https://www.postgresqltutorial.com/postgresql-date-functions/postgresql-now/)



**summary**

- Порядок выполнения операторов в запросах в движке
- Подзапросы в блоках `SELECT`, `FROM`, `WHERE `и `HAVING`
- Табличные выражения с оператором `WITH`
- Функция `NOW`, арифметические операции с интервалами
- Функция `unnest` для развертки списков со значениями в расширенные таблицы

```sql
SELECT     -- перечисление полей результирующей таблицы
FROM       -- указание источника данных
WHERE      -- фильтрация данных
GROUP BY   -- группировка данных
HAVING     -- фильтрация данных после группировки
ORDER BY   -- сортировка результирующей таблицы
LIMIT      -- ограничение количества выводимых записей


-- real execution order of instructions of code
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT
```



[Practice](sql_queries/simulator_sql/7_subqueries.sql)

### WITH

```sql
-- task 2
with tt as (SELECT user_id,
                   count(order_id) orders_count
            FROM   user_actions
            WHERE  action = 'create_order'
            GROUP BY user_id)
SELECT round(avg(orders_count), 2) orders_avg
FROM tt
```

### WHERE column = MAX()...

```sql
SELECT column
FROM table
WHERE column = (SELECT MAX(column) FROM table) 
```

### INTERVAL, NOW

```sql
SELECT NOW() - INTERVAL '1 year 2 months 1 week'
-- 10/10/21 19:32
```

```sql
-- task 5
SELECT count(distinct user_id) users_count
FROM   user_actions
WHERE  action = 'create_order'
   and time > (SELECT max(time)
            FROM   user_actions) - interval '1 week'
```

### IN + subquery

Подзапрос, возвращающий несколько значений, может использоваться в блоке `WHERE` совместно с оператором `IN`. При этом в табличном выражении должен быть всего один столбец, иначе база данных вернёт ошибку.

```sql
-- task 7
SELECT order_id
FROM   user_actions
WHERE  order_id not in (SELECT DISTINCT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order')
ORDER BY order_id limit 1000
```

### CASE + subquery

```sql
-- task 11
with avgp as(SELECT round(avg(price), 2)
             FROM   products)
SELECT product_id,
       name,
       price,
       case when price - (SELECT *
                   FROM   avgp) >= 50 then price*0.85 when (SELECT *
                                         FROM   avgp) - price >= 50 then price*0.9 else price end as new_price
FROM   products
ORDER BY price desc, product_id
```

### unnest

```sql
SELECT 'row', unnest(ARRAY['one','two','three'])
-- row    one
-- row    two
-- row    three
```

```sql
-- task 12
SELECT creation_time,
       order_id,
       product_ids,
       unnest(product_ids) product_id
FROM   orders limit 100
```

### COALESCE

```sql
-- task 15
with _ as(SELECT user_id,
                 date_part('year', age((SELECT max(time)
                                 FROM   user_actions), birth_date)) as ages
          FROM   users)
SELECT user_id,
       coalesce(ages, (SELECT round(avg(ages))
                FROM   _)) as age
FROM   _
ORDER BY user_id
```





## 8 JOIN

- [Декартово произведение](https://ru.wikipedia.org/wiki/%D0%9F%D1%80%D1%8F%D0%BC%D0%BE%D0%B5_%D0%BF%D1%80%D0%BE%D0%B8%D0%B7%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D0%B5)
- [Диаграмма Венна](https://ru.wikipedia.org/wiki/%D0%94%D0%B8%D0%B0%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B0_%D0%92%D0%B5%D0%BD%D0%BD%D0%B0)
- [PostgreSQL INNER JOIN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-inner-join/)
- [PostgreSQL LEFT JOIN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-left-join/)
- [PostgreSQL FULL OUTER JOIN](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-full-outer-join/)
- [PostgreSQL Cross Join By Example](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-cross-join/)
- l
- l



**summary**

- Типы объединений таблиц: `INNER JOIN`, `LEFT JOIN`, `FULL JOIN` и `CROSS JOIN`
- Операции `UNION`, `EXCEPT` и `INTERSECT`
- Объединие значений в строках в списки - операция `array_agg`
- Особенность объединения `SELF JOIN`

```sql
SELECT     -- перечисление полей результирующей таблицы
FROM       -- указание источника данных
JOIN       -- объединение источника с другой таблицей
WHERE      -- фильтрация данных
GROUP BY   -- группировка данных
HAVING     -- фильтрация данных после группировки
ORDER BY   -- сортировка результирующей таблицы
LIMIT      -- ограничение количества выводимых записей
```



[Practice](sql_queries/simulator_sql/8_kind_join.sql)

### Основные типы объединений JOIN

1. `INNER JOIN`
2. `LEFT/RIGHT JOIN`
3. `FULL JOIN`
4. `CROSS JOIN`

```sql
SELECT table_1.column_1, table_2.column_2
FROM table_1 
     JOIN table_2
     ON table_1.id = table_2.id
...
```

Если имя поля, по которому происходит объединение, совпадает в обеих таблицах (как в примерах выше), то можно использовать сокращенную запись c оператором `USING`:

```sql
SELECT a.column_1, b.column_2
FROM table_1 a 
     JOIN table_2 b
     USING (id)
...
```

### Основной принцип работы

Процесс объединения можно представить в виде следующей последовательности операций:

1. Сначала каждая строка первой таблицы сопоставляется с каждой строкой второй таблицы. т.е. происходит [декартово произведение](https://ru.wikipedia.org/wiki/Прямое_произведение) двух множеств, результатом которого является новое множество, состоящее из всевозможных пар исходных строк. Например, если в одной таблице было 50 записей, а в другой 10, то в результате декартова произведения получится 500 записей. На игрушечном примере это можно представить следующим образом:

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257150/cross.png)

------

2. Затем для каждой объединённой строки, состоящей из строк двух исходных таблиц, проверяется условие соединения, указанное после оператора `ON`.
3. После этого в соответствии с выбранным типом объединения формируется результирующая таблица. 

### INNER JOIN

Результат объединения `INNER JOIN` формируется следующим образом:

- Сначала каждая строка первой таблицы сопоставляется с каждой строкой второй таблицы (происходит декартово произведение)
- Затем для каждой объединённой строки проверяется условие соединения, указанное после оператора `ON`
- После этого все объединённые строки, для которых условие оказалось истинным, добавляются в результирующую таблицу

------

В результате объединения `INNER JOIN` из двух таблиц отбрасываются все строки, которые не прошли проверку на соответствие указанному условию.

```sql
SELECT A.id as id,
       A.city as city,
       B.country as country
FROM table_A as A
     JOIN table_B as B
     ON A.id = B.id
```

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257151/innerjoin1.png)

------

Схема `INNER JOIN`: 

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257151/innerjoin2.png)

```sql
-- task 1
SELECT u.user_id user_id_left,
       u_.user_id user_id_right,
       u.*
FROM   users u join user_actions u_ using(user_id)
ORDER BY 1
```

### LEFT JOIN, RIGHT JOIN

Результат объединения `LEFT JOIN` формируется следующим образом:

- Сначала каждая строка левой таблицы сопоставляется с каждой строкой правой таблицы (происходит декартово произведение)
- Затем для каждой объединённой строки проверяется условие соединения, указанное после оператора `ON`
- После этого все объединённые строки, для которых условие оказалось истинным, добавляются в результирующую таблицу
- Далее в результат добавляются те записи из левой таблицы (внимание: только из левой), для которых условие оказалось ложным и которые не вошли в соединение на предыдущем шаге. При этом для таких записей соответствующие поля из правой таблицы заполняются значениями `NULL`

------

```sql
SELECT A.id as id,
       A.city as city,
       B.country as country
FROM table_A as A
     LEFT JOIN table_B as B
     ON A.id = B.id
```

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257152/leftjoin1.png)

------

Диаграмма Венна для `LEFT JOIN`:

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257152/leftjoin2.png)



```sql
SELECT B.id as id,
       A.city as city,
       B.country as country
FROM table_A as A
     RIGHT JOIN table_B as B
     ON A.id = B.id
```

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257152/rightjoin1.png)

------

Диаграмма Венна для `RIGHT JOIN`:

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/257152/rightjoin2.png)

```sql
SELECT NOW() - INTERVAL '1 year 2 months 1 week'
-- 10/10/21 19:32
```

### FULL JOIN

```sql
SELECT A.id as id,
       A.city as city,
       B.country as country
FROM table_A as A
     FULL JOIN table_B as B
     ON A.id = B.id
```

------

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/260434/fullouterjoin1.png)

------

Диаграмма Венна для `FULL JOIN`:

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/260434/fullouterjoin2.png)



### UNION, EXCEPT, INTERSECT

Операции с множествами:

1. `UNION`
2. `EXCEPT`
3. `INTERSECT`

Они позволяют комбинировать результаты нескольких запросов друг с другом и получать один общий результат. В операциях с множествами не происходит совмещения столбцов из двух таблиц — база данных просто отбирает строки из таблиц, удовлетворяющие типу операции, и добавляет их в общий результат.

```sql
SELECT column_1, column_2
FROM table_1
UNION
SELECT column_1, column_2
FROM table_2
```

Операция `UNION` объединяет записи из двух запросов в один общий результат (объединение множеств).

Операция `EXCEPT` возвращает все записи, которые есть в первом запросе, но отсутствуют во втором (разница множеств).

Операция `INTERSECT` возвращает все записи, которые есть и в первом, и во втором запросе (пересечение множеств).

При этом по умолчанию эти операции исключают из результата строки-дубликаты. Чтобы дубликаты не исключались из результата, необходимо после имени операции указать ключевое слово `ALL`.

```sql
SELECT column_1, column_2
FROM table_1
UNION ALL
SELECT column_1, column_2
FROM table_2
```

Диаграммы Венна для операций:

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/260437/set_operators.jpg)

------

Для работы этих операций необходимо, чтобы выполнялись следующие условия:

1. В каждом запросе в `SELECT` должно быть одинаковое количество столбцов (допускается несколько)
2. Типы данных в столбцах должны быть совместимы

### CROSS JOIN

`CROSS JOIN` — обычное декартово произведение двух таблиц без условия соединения.

```sql
SELECT
    A.city as city,
    B.country as country
FROM table_A as A
     CROSS JOIN table_B as B
```

------

![img](https://storage.yandexcloud.net/klms-public/production/learning-content/152/1762/17929/53217/260453/cross.png)

#

```sql
-- task 11
SELECT user_id,
       round(avg(array_length(product_ids, 1)), 2) avg_order_size
FROM   (SELECT user_id,
               order_id
        FROM   user_actions except
SELECT user_id,
               order_id
        FROM   user_actions
        WHERE  action = 'cancel_order') _ join orders using (order_id)
GROUP BY user_id
ORDER BY user_id limit 1000
```

