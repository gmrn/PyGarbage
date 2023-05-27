# СИМУЛЯТОР SQL

[karpov.courses](https://lab.karpov.courses/learning/152/)

[Redash](https://redash.public.karpov.courses/)





## 4 Фильтрация данных

- Научились фильтровать данные и применять логические выражения в блоке `WHERE`.
- Выяснили, что фильтрацию можно делать сразу по расчётным полям с применением функций к колонкам.
- Разобрались, как задавать шаблоны для текстовых значений с помощью оператора `LIKE`.
- Познакомились с операторами `IN` и `BETWEEN`.
- Узнали ещё больше о `NULL` значениях и научились отфильтровывать их с помощью `IS NULL`.
- Поработали с датами и временем и научились задавать диапазоны значений.
- Совместили новые знания с информацией из прошлого урока и решили большую задачу на `CASE`.

```sql
SELECT     -- перечисление полей результирующей таблицы
FROM       -- указание источника данных
WHERE      -- фильтрация данных
ORDER BY   -- сортировка результирующей таблицы
LIMIT      -- ограничение количества выводимых записей
```



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

Результат:
true

SELECT 'karpov.courses' LIKE 'karpov_'

Результат:
false

SELECT 'karpov.courses' LIKE '%karpov%'

Результат:
true

SELECT 'karpov.courses' LIKE '_karpov%'

Результат:
false

SELECT 'karpov.courses' LIKE '%.%'

Результат:
true

SELECT 'karpov.courses' LIKE '_._'

Результат:
false

SELECT 'karpov.courses' LIKE 'Karpov%'

Результат:
false
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



### CASE, WHEN, THEN

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

