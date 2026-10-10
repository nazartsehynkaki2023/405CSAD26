# Лабораторна робота №1

## Тема

Автоматизація кросплатформенного проєкту Hello World за допомогою Copilot, CMake та GitHub Actions.

Репозиторій опубліковано як
`https://github.com/nazartsehynkaki2023/405CSAD26`.

## Виконав

- ПІБ: Цегинька Назар Олегович
- Група: КІ-405
- Варіант: 26

## Запланований стек

- C++
- CMake
- Google Test
- CTest
- GitHub Actions

## Збірка через CMake

Проєкт потребує CMake версії 3.24 або новішої.

### Windows (Visual Studio 17 2022, x64)

Наведені команди потребують доступного CMake. У локальному середовищі використано:
`D:\VS\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`.
Системний `PATH` не змінюється.

```powershell
cmake -S . -B build/cmake -G "Visual Studio 17 2022" -A x64
cmake --build build/cmake --config Release
build/cmake/Release/hello.exe
```

### Linux/macOS

```bash
cmake -S . -B build/cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build/cmake --config Release
./build/cmake/hello
```

Команди складання перевірено у GitHub Actions на Ubuntu та macOS.

## Перевірка репозиторію за етапом 7

`checker.py` — оригінальний скрипт перевірки з репозиторію
`andrii-s-spitzer-lpnu-ua/csad-task1`, отриманий без змін із commit
`a72224655d271d5ca17a0736a59aa1d01bc92177`. Він читає CSV-файли з `input/`,
перевіряє доступність репозиторіїв GitHub через `requests` і записує результати
до відповідних файлів у `output/`, додаючи колонку `Status`.

У цьому проєкті підготовлено `input/groups_405.csv` з форматом:

`Git Name,405`

`nazartsehynkaki2023,405CSAD26`

Це окремий один рядок на основі наданих студентом даних, а не офіційний повний
експорт Google-таблиці. Фактичний результат перевірки збережено у
`output/groups_405.csv` із доданою колонкою `Status`.

Workflow `.github/workflows/check.yml` зберігає запуск при зміні `input/**` і
через `workflow_dispatch`, встановлює `requests`, запускає `checker.py` та
зберігає змінений `output/` у тій самій гілці. Порожній commit не створюється.
Порівняно з оригіналом використано `actions/checkout@v4` замість `@v3` і
`actions/setup-python@v5` замість `@v4` як актуальні версії actions. Також
використано локальну конфігурацію Git замість `--global`, явний
`python -m pip` і перевірку staged diff перед commit. Push виконується
звичайним способом без force.

У run [38061041960](https://github.com/nazartsehynkaki2023/405CSAD26/actions/runs/38061041960)
перевірка завершилася успішно; для
`nazartsehynkaki2023/405CSAD26` отримано статус `OK`.

## GitHub Actions

Workflow `.github/workflows/ci_build.yml` виконує один job `cross_build` на матриці
`ubuntu-latest`, `windows-latest` і `macos-latest`. Для Linux/macOS запускається
`ci.sh` через `bash`, а для Windows — `ci.bat` через `cmd`. Workflow не дублює
кроки configure, build або CTest, оскільки вони вже реалізовані в цих скриптах.

Запуск відбувається автоматично для `push` і `pull_request` до гілок, назви яких
містять `develop` або `master`, зокрема для `feature/develop/...`. Також доступний
ручний запуск через `workflow_dispatch`. Матриця має `fail-fast: false`, тому
результати різних платформ переглядаються незалежно.

Після успішної перевірки workflow публікує результат складання як артефакт:
`hello-ubuntu-latest.tar.gz`, `hello-macos-latest.tar.gz` або
`hello-windows-latest.zip`. Архіви містять лише executable `hello`, а не весь
каталог `build/` чи залежності Google Test. Для Linux/macOS формат `tar.gz`
зберігає право виконання.

Логи переглядаються на сторінці запуску workflow у вкладці відповідного job і
кроку. Артефакти завантажуються там само в секції Artifacts після успішного
завершення job. Пункт Deploy у межах цієї лабораторної реалізовано як
публікацію результатів складання, без розгортання застосунку.

Фактичний run
[38058770191](https://github.com/nazartsehynkaki2023/405CSAD26/actions/runs/38058770191)
успішно виконав складання і 3/3 тести на Ubuntu, Windows та macOS. Користувач
завантажив Windows-артефакт, запустив його, отримав `Hello World!` і код
завершення `0`. Цей результат підтверджує виконання у GitHub Actions; окрема
локальна перевірка Linux/macOS не заявляється.

## Автоматизована локальна перевірка

Скрипти запускаються без параметрів і визначають корінь проєкту від власного розташування,
тому їх можна викликати з будь-якої поточної директорії. Вони використовують окремий каталог
`build/ci`, не видаляють результати складання та завершуються з ненульовим кодом у разі помилки
або відсутності тестів.

### Windows

Потрібні CMake, CTest і компілятор C++. `ci.bat` спочатку шукає `cmake.exe` та `ctest.exe`
у `PATH`. Якщо вони недоступні, скрипт знаходить Visual Studio через `vswhere`, підключає
штатне x64 Developer-середовище та використовує bundled CMake і CTest. Конкретний шлях
встановлення Visual Studio або версія генератора не зафіксовані.

Запуск:

`ci.bat`

Або з іншої поточної директорії:

`F:\шлях\до\lab1-cpp\ci.bat`

### Linux/macOS

Потрібні `cmake`, `ctest` і доступний C++ компілятор у `PATH`.

Запуск:

`./ci.sh`

Перед першим запуском у Linux/macOS потрібно надати скрипту executable bit:

`chmod +x ci.sh`

Скрипт `ci.sh` у цьому середовищі локально не запускався; Linux/macOS
підтверджено фактичним виконанням GitHub Actions.

## Тести

Тести реалізовано з використанням Google Test. Під час першої конфігурації CMake
потрібне підключення до інтернету для завантаження Google Test.

### Windows (Visual Studio 17 2022, x64)

```powershell
cmake -S . -B build/cmake -G "Visual Studio 17 2022" -A x64
cmake --build build/cmake --config Release
ctest --test-dir build/cmake -N -C Release
ctest --test-dir build/cmake -C Release --output-on-failure
```

### Linux/macOS

```bash
cmake -S . -B build/cmake -DCMAKE_BUILD_TYPE=Release
cmake --build build/cmake --config Release
ctest --test-dir build/cmake -N -C Release
ctest --test-dir build/cmake -C Release --output-on-failure
```

Тести на Linux/macOS підтверджено run
[38058770191](https://github.com/nazartsehynkaki2023/405CSAD26/actions/runs/38058770191):
на кожній платформі пройшли 3/3 тести.
