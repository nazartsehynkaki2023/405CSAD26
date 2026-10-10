# Журнал роботи з AI

## Завершення етапу 2

- У `README.md` виправлено ПІБ на `Цегинька Назар Олегович`.
- У розділі Windows уточнено, що команди потребують доступного CMake.
- Зафіксовано фактичний шлях до CMake: `D:\VS\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe`.
- Системний `PATH` не змінювався.
- CMake-конфігурація та попередній запуск залишилися без змін: configure, build і запуск завершилися з кодом `0`, вивід — `Hello World!`.
- Результати `build/` не додаються до commit згідно з `.gitignore`.

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

## Завершення першого етапу

Підтверджений результат попереднього запуску мінімальної програми:

- Вивід: `Hello World!`
- Код завершення: `0`
