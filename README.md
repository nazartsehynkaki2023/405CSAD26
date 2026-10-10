# Лабораторна робота №1

## Тема

Автоматизація кросплатформенного проєкту Hello World за допомогою Copilot, CMake та GitHub Actions.

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

Linux/macOS поки не перевірені.

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

Linux/macOS поки не перевірені.

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

Linux/macOS поки не перевірені.
