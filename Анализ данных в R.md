# Анализ данных в R

[Ссылка на курс Stepik](https://stepik.org/course/129/)



## 1 Предобработка данных

***

### 1.1 Общая информация о курсе

- [Язык программирования R](http://cran.rstudio.com/)
- [RStudio](http://www.rstudio.com/products/rstudio/download/)



Другие полезные материалы и учебники:

- [Учебник Cookbook for R](http://www.cookbook-r.com/)
- [Блог на русском с полезными советами](http://r-analytics.blogspot.ru/)





### 1.2 Переменные

#### Арифметические операции  

^  или **  - возведение в степень 

%% - остаток от деления

%/%  - целая часть от деления 

#### Логические операции

x | y - или 

x & y - и

**TRUE**  можно сокращенно обозначать **T** 

**FALSE** можно сокращенно обозначать **F**





### 1.3 Работа с data frame

- [Скрипт .R с урока](https://stepic.org/media/attachments/lesson/11481/data%20frames.R)
- [Датасет с результатами исследования рейтинга преподавателей](https://stepik.org/media/attachments/lesson/11481/evals.csv)  



#### Некоторые методы для работы с таблицами

```R
# Reads a file in table format and creates a data frame from it, with cases corresponding to lines and variables to fields in the file.
data <- read.csv(path)

# Compactly display the internal structure of an R object.
str(data)

# Produce result summaries of the results of various model fitting functions.
summary(data)

# To get or set (or view in console) the names (headers) of a table.
names(data)
```



#### Работа с определенными строками/столбцами:

```R
# View choosed variables
data$score

# View summary in the console choosed variables
summary(data$score)

# Set new column of variables
data$new_variable <- 0

# Delete some column
data$score <- NULL

# Number rows/columns in dataset
nrow(data)
ncol(data)
```



#### Subseting

```R
# Choose some subset of dataframe
data[1,1]
data[c(2,193,225), ]
data[101:200,1]
data[5,]

# Choose all rows and columns without column 3 and 4 
data[ ,-c(3, 4)]

# For complex query
subset(data, data[, 2] > 100 & am == 1)
```

```R
mydata2 <- subset(mydata, gender == 'female')
mydata3 <- subset(mydata, gender == 'male')
mydata4 <- rbind(mydata2, mydata3)

mini_mtcars <- rbind(mtcars[3,], mtcars[7,], mtcars[10,], mtcars[12,], mtcars[nrow(mtcars),])
mini_mtcars
```



При запуске R, автоматически загружаются основные библиотеки для работы, например `datasets`, где хранятся наборы данных из разных исследований.

```R
library(help = "datasets")

# Add dataset in global environment 
data(mtcars)

help(mtcars) 
```



#### Задачи

Работа с встроенным датафреймом `mtcars`. 

1. В датафрэйме `mtcars` создать новую колонку (переменную) `even_gear`, где при четном значении `gear` будут единицы, нечетном - нули.

   

   ```R
   mtcars$evengear <- (mtcarsgear+1) %% 2 
   ```

   

2. Создать вектор `mpg_4`, где хранятся значения расхода топлива `mpg` для машин с четырьмя цилиндрами `cyl`. 

   

   ```R
   mpg_4 <- mtcars$mpg[mtcars$cyl == 4]
   ```

   

3. Создать dataframe `mini_mtcars`, где хранятся третья, седьмая, десятая, двенадцатая и последняя строчка датафрейма `mtcars`.

   

   ```R
   mini_mtcars <- mtcars[c(3, 7, 10, 12, nrow(mtcars)), ]
   ```





### 1.4 Элементы синтаксиса

- [Скрипт .R с урока](https://stepik.org/media/attachments/lesson/11478/conditions.R)
- [Датасет с результатами исследования рейтинга преподавателей](https://stepik.org/media/attachments/lesson/11481/evals.csv)  



```R
# ifelse can to work with a vector
a <- c(1, -1)

ifelse(a > 0, 'positive', 'not positive')
```

```R
as.vector(AirPassengers) #transfer to vector
```

```R
# the cycle for 
for (i in 1:nrow(mydata)){
  print(mydata$score[i])
}
```



#### Задачи

Работа с встроенным датасетом ` mtcars`. 

1. Создать новую числовую переменную `new_var` в данных `mtcars`, которая содержит единицы в строчках, если в машине не меньше четырёх карбюраторов  `carb` или больше шести цилиндров `cyl`. В других строках должны стоять нули.

   

   ```R
   mtcars$new_var <- ifelse(mtcars$carb >= 4 | mtcars$cyl > 6, 1, 0)
   ```

   

2. Дан вектор `my_vector`. Если его среднее значение больше 20, в созданную переменную `result` сохранить **"My mean is great"**, иначе **"My mean is not so great"**.

   

   ```R
   result <- ifelse(mean(my_vector) > 20, 
                    "My mean is great", 
                    "My mean is not so great") 
   ```

   


3. Создать переменную `good_months` и сохранить в нее число пассажиров из `AirPassengers` только в тех месяцах, в которых это число больше, чем показатель в предыдущем месяце.  

   ***

   Встроенные в R данные `AirPassengers` - формат данных типа <span style="font-family:var(--font-family-mono)">Time-Series</span>.

   ```R
   ?AirPassengers
   str(AirPassengers)
   ```

   В R оператор создания последовательности имеет приоритет над арифметическими действиями. 

   ```R
   i <- 10
   1 : i - 1 # query to 10 by elements - 1
   
   1 : (i - 1) # а query to 9
   ```

   ***

   ```R
   good_months <- AirPassengers[-1][AirPassengers[-1] > AirPassengers[-144]]
   ```

   

4. Для `AirPassengers` рассчитать **скользящее среднее** с интервалом сглаживания равным 10. Значения средних сохранить в переменную `moving_average`.

   ***

   Инициализация вектора:

   ```R
   # create empty vector (it's not appropriate)
   moving_average <- c()
   
   # create vector by some type
   moving_average <- numeric(135)
   ```

   Вспомогательная функция для решения без цикла:

   ```R
   # return vector whose elements are the cumulative sums
   ?cumsum
   ```

   ***

   ```R
   n <- 10
   df <- AirPassengers
   
   moving_average <- (cumsum(df)[n : length(df)] - c(0, cumsum(df)[1 : (length(df))])) / n
   ```





### 1.5 Описательные статистики

- [Скрипт .R с урока](https://stepic.org/media/attachments/lesson/11479/Descriptive%20statistics.R)
- [Are the Skewness and Kurtosis Useful Statistics?](https://www.spcforexcel.com/knowledge/basic-statistics/are-skewness-and-kurtosis-useful-statistics)



```R
df  <- mtcars
```

```R
# encode numerical type to nominal variables
df$vs <- factor(df$vs, labels = c("v", "s"))
df$am <- factor(df$am, labels = c('auto', 'manual'))

head(df, 3)
#               mpg cyl disp  hp drat    wt  qsec vs     am gear carb
#Mazda RX4     21.0   6  160 110 3.90 2.620 16.46  v manual    4    4
#Mazda RX4 Wag 21.0   6  160 110 3.90 2.875 17.02  v manual    4    4
#Datsun 710    22.8   4  108  93 3.85 2.320 18.61  s manual    4    1
```

```R
median(df$mpg)
mean(df$disp)
sd(df$hp)
range(df$cyl)

mean(df$mpg[df$cyl == 6 & df$vs == "v"])
# 20.56667

sd(df$hp[df$cyl != 3 & df$am == "auto"])
# 53.9082
```



#### Агрегирование данных

```R
mean_hp_vs  <- aggregate(x = df$hp, by = list(df$vs), FUN = mean)
#   Group.1         x
# 1       v 189.72222
# 2       s  91.35714

colnames(mean_hp_vs)  <- c("VS", "Mean HP")
#   VS   Mean HP
# 1  v 189.72222
# 2  s  91.35714


# another way to write the function aggregation 
aggregate(hp ~ vs, df, mean)
#   vs        hp
# 1  v 189.72222
# 2  s  91.35714

aggregate(hp ~ vs + am, df, mean) # or
aggregate(x = df$hp, by = list (df$vs, df$am), FUN = mean)
#   vs     am        hp
# 1  v   auto 194.16667
# 2  s   auto 102.14286
# 3  v manual 180.83333
# 4  s manual  80.57143

aggregate(x = df[,-c(8,9)], by = list(df$am), FUN = median)
#   Group.1  mpg cyl  disp  hp drat   wt  qsec gear carb
# 1    auto 17.3   8 275.8 175 3.15 3.52 17.82    3    3
# 2  manual 22.8   4 120.3 109 4.08 2.32 17.02    4    2

aggregate(cbind(mpg, disp) ~ am + vs, df, sd)
```

```R
library(psych)

describe(x = df[,-c(8,9)]) # ignore nominal variables
```

```R
# describe df by group in fast mode (without some statistics)  
descr2 -> describeBy(x = df[,-c(8,9)], group = df$vs, fast = T)

#call the desired list by group
descr2$v 
descr2$s
#   vars  n   mean    sd   min    max  range    se
# mpg     1 14  24.56  5.38 17.80  33.90  16.10  1.44
# cyl     2 14   4.57  0.94  4.00   6.00   2.00  0.25
# disp    3 14 132.46 56.89 71.10 258.00 186.90 15.21
# hp      4 14  91.36 24.42 52.00 123.00  71.00  6.53
# drat    5 14   3.86  0.51  2.76   4.93   2.17  0.14
# wt      6 14   2.61  0.72  1.51   3.46   1.95  0.19
# qsec    7 14  19.33  1.35 16.90  22.90   6.00  0.36
# gear    8 14   3.86  0.53  3.00   5.00   2.00  0.14
# carb    9 14   1.79  1.05  1.00   4.00   3.00  0.28


# describe df by group and in the form of matrix(classic data frame)  
describeBy(x = df[,-c(8,9)], group = df$vs, mat = T, digits = 1)
```



#### NA значения

```R
any(is.na(df)) # check in table missing data
# [1] FALSE

df$mpg[1:10]  <- NA
mean(df$mpg)
# [1] NA

mean(df$mpg, na.rm = T) # ignore all na obs 
# [1] 19.96364

aggregate(mpg ~ am, df, mean) # default na.rm is true
#       am    mpg
# 1   auto 15.575
# 2 manual 25.230

describe(df$mpg, fast = T)
#    vars  n  mean   sd  min  max range   se
# X1    1 22 19.96 7.07 10.4 33.9  23.5 1.51
```

 

#### Задачи

Работа с встроенным датасетом ` mtcars`. 

1. Рассчитать **среднее значение** времени разгона `qsec` для автомобилей, число цилиндров `cyl` у которых не равняется 3 и показатель количества миль на галлон топлива `mpg` больше 20.

   Получившийся результат сохранить в переменную `result`.

   

   ```R
   result <- mean(mtcars$qsec[mtcars$cyl != 3 & mtcars$mpg > 20])
   ```

   

2. При помощи функции `aggregate()` рассчитать **стандартное отклонение** переменной `hp` (лошадиные силы) и `disp` (вместимости двигателя)  у машин с автоматической и ручной коробкой передач. 

   Ответ записать в переменную `descriptions_stat`.

   

   ```R
   descriptions_stat <- aggregate(cbind(hp, disp) ~ am, mtcars, sd)
   ```

   

3. В датасете `airquality` при помощи функции `aggregate()` рассчитать количество **непропущенных** наблюдений по переменной `Ozone` в 7, 8 и 9 месяце, результат сохранить в переменную `result`.

   Для определения количества наблюдений - функция `length`.

   ***

   ```R
   # subsetting by special conditions
   x <- 5
   x %in% c(3, 4, 5) 
   # [1] TRUE
   ```

   ***

   ```R
   result <- aggregate(Ozone ~ Month, airquality, subset = Month > 6, length) 
   ```

   ​	

4. Создать новый вектор `fixed_vector`, где все пропущенные значения вектора `my_vector`, данного по условию, будут заменены на его среднее значение по имеющимся наблюдениям.

   Изучить справку по функции `replace()`.

   

   ```R
   fixed_vector <- replace(my_vector, is.na(my_vector), mean(my_vector, na.rm = T))
   ```





### 1.6 Описательные статистики. Графики

### 1.7 Сохранение результатов

## 2 Статистика в R. Часть 1

## 3 Статистика в R. Часть 2

# Анализ данных в R. Часть 2

[Ссылка на курс Stepik](https://stepik.org/course/724/)

