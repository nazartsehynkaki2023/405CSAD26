# Журнал роботи з AI

## Завершення етапу 2

- У `README.md` виправлено ПІБ на `Цегинька Назар Олегович`.
- У розділі Windows уточнено, що команди потребують доступного CMake.
- Зафіксовано фактичний шлях до CMake: `D:\VS\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`.
- Системний `PATH` не змінювався.
- CMake-конфігурація та попередній запуск залишилися без змін: configure, build і запуск завершилися з кодом `0`, вивід — `Hello World!`.
- Результати `build/` не додаються до commit згідно з `.gitignore`.

## Етап 3: Google Test

- Після попереднього обірваного запиту перевірено стан репозиторію: нових файлів або змін після нього не було.
- Поточною залишалася гілка `feature/develop/3-tests`; наявний `CMakeLists.txt` збережено та розширено.
- Створено `math_operations.h` із include guard і декларацією `int add(int a, int b)`.
- Створено `math_operations.cpp` з реалізацією додавання.
- Створено `tests/unit_tests.cpp` з тестами додавання додатних чисел, нуля та від’ємних чисел.
- CMake оновлено: додано бібліотеку `math_operations`, executable `unit_tests`, Google Test через FetchContent із релізом `v1.14.0`, налаштування `gtest_force_shared_crt`, `enable_testing()` і `gtest_discover_tests`.
- README доповнено описом тестів, командами CTest і вимогою інтернету для першого завантаження Google Test; Linux/macOS залишено неперевіреними.
- Перший запуск перевірки зупинився на команді `ctest`, оскільки `ctest` не був доступний у PATH; успіх на цьому етапі не записувався.

Фактичні результати завершеної перевірки:

- Використано CMake: `D:\VS\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`.
- Після першої невдалої спроби виклику `ctest` знайдено штатний `ctest.exe` поруч із CMake; системний `PATH` не змінювався.
- Configure для `Visual Studio 17 2022` та `x64`: код `0`.
- Release build: код `0`.
- `ctest -N -C Release`: знайдено 3 тести, код `0`:
  - `MathOperations.BasicAddition`
  - `MathOperations.AdditionWithZero`
  - `MathOperations.AdditionWithNegativeNumbers`
- `ctest -C Release --output-on-failure`: 3 з 3 тестів пройшли, код `0`.
- Запуск `build\cmake\Release\hello.exe`: вивід `Hello World!`, код `0`.
- Додано `DOWNLOAD_EXTRACT_TIMESTAMP TRUE` до FetchContent для усунення попередження CMake.

## Виправлення етапу 3

- Мінімальну версію CMake у `CMakeLists.txt` змінено з `3.20` на `3.24`.
- `DOWNLOAD_EXTRACT_TIMESTAMP TRUE` змінено на `DOWNLOAD_EXTRACT_TIMESTAMP FALSE`.
- README доповнено вимогою CMake `3.24` або новішого.
- Історичні записи про попередню версію CMake не переписувалися.

Фактичні результати повторної перевірки:

- Configure у `build/cmake` з генератором `Visual Studio 17 2022` для `x64`: код `0`.
- Release build: код `0`.
- `ctest -N -C Release`: знайдено 3 тести, код `0`.
- `ctest -C Release --output-on-failure`: 3 з 3 тестів пройшли, код `0`.
- Нових тестів або залежностей не додавалося.

## Завершення етапу 3

- Перевірено гілку `feature/develop/3-tests`, вимоги CMake 3.24 і `DOWNLOAD_EXTRACT_TIMESTAMP FALSE`.
- Повторний `ctest -N -C Release` знайшов 3 тести та завершився з кодом `0`.
- Повторний `ctest -C Release --output-on-failure` підтвердив: 3 з 3 тестів пройшли, 0 помилок, код завершення `0`.
- У commit будуть додані лише файли етапу 3 та документація; результати `build/` ігноруються Git.

## Початок роботи

Роботу розпочато в папці `lab1-cpp`. Поточний вміст папки перевірено до внесення змін; папка була порожньою, а локальний Git-репозиторій був відсутній.

## Реально виконані дії

- Ініціалізовано локальний Git-репозиторій з початковою гілкою `master`.
- Створено `README.md` і виконано початковий commit у `master`.
- Створено гілки `develop` та `feature/develop/1-project`; поточною залишено `feature/develop/1-project`.
- Створено `.gitignore` для результатів складання, локальних файлів Visual Studio та кешів.
- Створено мінімальний `main.cpp`, що виводить `Hello World!` і завершується успішно.
- Створено цей журнал і файл `docs/copilot-prompts.txt` із текстом запиту.

На цьому початковий етап завершено. CMake, тести, CI-скрипти, workflow, remote та push не створювалися і не виконувалися; залежності не встановлювалися.

## Перевірка мінімальної C++ програми

- Перевірено папку проєкту, гілку `feature/develop/1-project` та наявний вміст `main.cpp`; наявні зміни збережено.
- Через `C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe` знайдено Visual Studio Community 2022 у `D:\VS` з компонентом MSVC x64.
- Штатне x64 Developer-середовище активовано лише в дочірньому процесі через `D:\VS\Common7\Tools\VsDevCmd.bat`; системний `PATH` не змінювався.
- Створено `build\`. Команда складання:

  `call "D:\VS\Common7\Tools\VsDevCmd.bat" -arch=x64 -host_arch=x64 >nul && cl /nologo /EHsc /std:c++17 /c main.cpp /Fo:build\main.obj /Fd:build\main.pdb && link /OUT:build\hello.exe /PDB:build\hello.pdb build\main.obj && build\hello.exe`

- `main.cpp` успішно скомпільовано в `build\hello.exe`; проміжні файли розміщено в `build\`.
- Вивід програми: `Hello World!`
- Код завершення процесу складання та запуску: `0`.
- Перевірено, що `build\` і його вміст ігноруються Git: вони не з'являються у `git status`.
- CMake і тести не створювалися, інструменти не встановлювалися, commit/push/merge та remote не виконувалися.

## Етап 2: CMake

- Перевірено гілку `feature/develop/2-cmake`, `main.cpp`, `README.md` та `.gitignore`.
- Створено кореневий `CMakeLists.txt` з мінімальною версією CMake 3.20, стандартом C++17, вимкненими розширеннями компілятора та target `hello`.
- Для перевірки використано CMake зі встановленої Visual Studio: `D:\VS\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`.
- Для перевірки використано окремий каталог `build\cmake`; попередні результати ручної компіляції не змішувалися з ним.
- README доповнено командами CMake для Windows і Linux/macOS; Linux/macOS позначено як неперевірені.

Фактичний результат локальної перевірки Windows:

- CMake знайдено за шляхом `D:\VS\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`.
- Конфігурація з генератором `Visual Studio 17 2022` та архітектурою `x64` завершилася з кодом `0`.
- Складання конфігурації `Release` завершилося з кодом `0`.
- Запущено `build\cmake\Release\hello.exe`.
- Вивід: `Hello World!`
- Код завершення програми: `0`.
- Linux/macOS не перевірялися.

## Етап 7: підготовка перевірки репозиторію

- Перевірено чистоту робочого дерева на `develop`; локальна `develop` і
  `origin/develop` мали однаковий commit `d104afb02800bb9ff78378753a063a8d50cc4f5f`.
- Створено гілку `feature/develop/7-repo-check`.
- Підтверджено перейменування GitHub-репозиторію з
  `lab1-ai-agent` на `405CSAD26`; локальний `origin` уже вказував на
  `https://github.com/nazartsehynkaki2023/405CSAD26.git`.
- Отримано оригінальний `checker.py` із
  `andrii-s-spitzer-lpnu-ua/csad-task1` без змін, commit
  `a72224655d271d5ca17a0736a59aa1d01bc92177`.
- Додано `input/groups_405.csv` лише з рядком студента:
  `nazartsehynkaki2023,405CSAD26`; дані інших студентів не додавалися.
- Додано окремий `.github/workflows/check.yml` із запуском при зміні
  `input/**` і через `workflow_dispatch`, встановленням `requests`, правом
  `contents: write` та звичайним push результатів у поточну гілку. Workflow
  не створює commit, якщо `output/` не змінився.
- У workflow використано `actions/checkout@v4` замість оригінального `@v3`
  і `actions/setup-python@v5` замість оригінального `@v4`; це єдині заміни
  версій actions. Також конфігурація Git зроблена локально, а не глобально.
- README доповнено описом походження checker, формату CSV та очікуваного
  `output/groups_405.csv`. Повний Google-табличний експорт не додавався.
- `checker.py`, локальні залежності та GitHub Actions ще не запускалися;
  перевірку не записано як виконану. `output/` навмисно не створювався.

## Публікація та перевірка етапу 7

- Підтверджено попередній Actions run `38058770191`: він успішний на
  Ubuntu, Windows і macOS; на кожній платформі пройшли всі 3/3 тести.
- Зафіксовано ручний результат користувача: Windows-артефакт завантажено,
  `Hello World!` отримано, код завершення — `0`.
- Ці результати стосуються попереднього запуску; новий запуск `Check Repos`
  на цьому етапі ще не виконано.

## Інтеграція етапу 7

- Виконано `git fetch origin` і `git merge --ff-only
  origin/feature/develop/7-repo-check`; автоматичний commit `c746130
  Results Updated` підтягнуто fast-forward без reset, rebase або force.
- Локальний `output/groups_405.csv` підтверджено як:
  `Git Name,405,Status` і
  `nazartsehynkaki2023,405CSAD26,OK`.
- README оновлено для репозиторію `405CSAD26` і фактичних результатів run
  `38058770191` та run `38061041960`. Історичні записи журналу не
  переписувалися.

## Фінальний review лабораторної

- Перевірено чистоту `develop`; локальний commit і `origin/develop`
  збігалися: `2d1d4bbfaf2c2c29e4aa16bf0c0352eaf09a97d1`.
- Run `38061473086` (`Cross-platform build and test`) завершився
  успішно на Ubuntu, Windows і macOS; усі job матриці завершилися успішно.
- Run `38061473094` (`Check Repos`) завершився успішно; job `run-check`
  завершився успішно.
- `output/groups_405.csv` містить рядок
  `nazartsehynkaki2023,405CSAD26,OK`.
- Перевірено GitHub: відкритого або закритого PR із `develop` у `master`
  перед створенням фінального PR не існувало.
- Створено гілку `feature/develop/8-final-review` від `develop`.

## Завершення етапу 5

- Workflow `.github/workflows/ci_build.yml` підготовлено та переглянуто.
- Перевірено його тригери, матрицю платформ, умови запуску скриптів і шляхи
  пакування артефактів.
- Запуск workflow на GitHub ще не виконано.

## Підготовка до публікації на GitHub

- Робоче дерево перед публікацією було чистим.
- Перевірено локальні гілки та відсутність попередніх remotes.
- Через `git ls-remote` підтверджено, що вказаний віддалений репозиторій не має
  гілок або тегів.
- `origin` підключено до вказаної адреси.
- Виконано підготовку журналів на гілці `feature/develop/5-actions`.
- Push і запуск GitHub Actions на цей момент ще не виконувалися; успіх трьох ОС
  не заявляється.

## Етап 5: GitHub Actions

- На гілці `feature/develop/5-actions` створено `.github/workflows/ci_build.yml`.
- Workflow містить одну job `cross_build` із матрицею `ubuntu-latest`,
  `windows-latest` і `macos-latest`, `fail-fast: false` та
  `permissions: contents: read`.
- Додано тригери `push`, `pull_request` для гілок із `develop` або `master` у
  назві, а також `workflow_dispatch`.
- Використано `actions/checkout@v4`.
- Linux/macOS запускають `bash ./ci.sh`, Windows запускає `ci.bat` через `cmd`;
  configure, build і CTest не дублюються у workflow.
- Додано перевірку фактичного розташування executable після складання.
  Windows пакує `hello.exe` у ZIP, Linux/macOS пакують `hello` у `tar.gz` зі
  збереженням права виконання.
- Артефакти публікуються через `actions/upload-artifact@v7` з унікальними
  назвами ОС та `if-no-files-found: error`; каталог `build/` і залежності Google
  Test не завантажуються.
- README доповнено описом платформ, тригерів, перегляду логів, артефактів і
  того, що Deploy реалізовано як публікацію результатів складання.
- Workflow ще не запускався на GitHub; успіх трьох ОС не заявляється.

## Завершення етапу 4

- Користувач вручну перевірив `ci.bat` у cmd.
- `ci.bat` виконав складання успішно.
- Усі 3 тести пройшли.
- Програма вивела `Hello World!`.
- `echo %ERRORLEVEL%` показав `0`.

## Виправлення CI-скриптів

- У `ci.sh` до CMake configure додано `-DCMAKE_BUILD_TYPE=Release`; `--config Release` для multi-config генераторів збережено.
- У `ci.bat` виправлено перевірку результату `VsDevCmd.bat`: код після `call` зчитується через `!errorlevel!` у змінну та перевіряється всередині блоку.
- Інші блокові перевірки помилок переглянуто; аналогічних випадків із `%errorlevel%` не залишилося.
- Повторний локальний запуск `ci.bat` завершився з кодом `0`.
- Configure і Release build у `build\ci` успішні.
- Знайдено всі 3 тести; усі 3 пройшли з кодом CTest `0`.
- `hello.exe` вивів `Hello World!`, код завершення `0`.
- Під час попереднього запуску помилок не виникло; попередні помилки Unicode-підрахунку тестів і їх виправлення збережено в журналі вище.
- `ci.sh` збережено у форматі LF з Git mode `100755`; Linux/macOS не перевірялися.

## Завершення першого етапу

Підтверджений результат попереднього запуску мінімальної програми:

- Вивід: `Hello World!`
- Код завершення: `0`

## Етап 4: CI-скрипти

- Перевірено гілку `feature/develop/4-ci-scripts`, Git status, `CMakeLists.txt` і `README.md`; наявні зміни збережено.
- Створено `ci.sh` для Linux/macOS і `ci.bat` для Windows.
- Обидва скрипти визначають корінь проєкту від власного розташування, використовують `build/ci`, не видаляють результати складання та зупиняються з ненульовим кодом при помилці або відсутності тестів.
- Windows-скрипт шукає CMake/CTest у `PATH`, а за відсутності — знаходить Visual Studio через `vswhere`, підключає x64 Developer-середовище та bundled CMake/CTest без обов’язкового шляху `D:\VS` і без фіксації конкретного генератора.
- README доповнено інструкціями запуску та вимогами до інструментів.

Фактичні результати перевірки:

- `ci.bat` із кореня проєкту завершився з кодом `0`.
- Configure і Release build виконано в `build\ci`; використано Visual Studio Developer environment, bundled CMake 3.31.6 і CTest 3.31.6.
- Знайдено 3 тести; усі 3 пройшли, CTest завершився з кодом `0`.
- `hello.exe` вивів `Hello World!`.
- Повторний запуск `ci.bat` з `%TEMP%` через повний шлях до скрипту також завершився з кодом `0`; корінь і `build\ci` визначено незалежно від поточної директорії.
- Перші два запуски виявили та виправили Unicode-сумісність підрахунку тестів у batch-скрипті; успішний результат записано лише після виправлення.
- Для `ci.sh` нормалізовано LF; Git index містить режим `100755`.
- Linux/macOS не перевірялися.
