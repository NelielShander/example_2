# Example 2

[![Build Status](https://github.com/NelielShander/example_2/actions/workflows/ci.yml/badge.svg)](https://github.com/NelielShander/example_2/actions/workflows/ci.yml)

Для запуска требуется версия Ruby не ниже 3.0

После клонирования репозитория выполнить `bundle install`

## Задача

Алгоритм нахождения комбинаций следующий:

* Определяем число ручек сейфа, текущую комбинацию, необходимую комбинацию и запрещенные комбинации
* для каждой из ручек сейфа определяем кратчайший путь к нужному положению
* Поочередно с конца поворачиваем каждую ручку по заданному пути
* если комбинация совпадает с запрещенными, то поворачиваем следующую ручку
* проверяем нахождение текущей и необходимой комбинации в запрещенных и выводим ошибку
* если следующую ручку не крутануть выводим ошибку
* записываем последовательность получившихся комбинаций

Для запуска программы необходимо:
* Выполнить в командной строке
```console
bin/console
Picker.call
```

Для запуска тестов выполнить в командной строке
```console
bundle exec rake
```
Описание задачи в корне каталога.