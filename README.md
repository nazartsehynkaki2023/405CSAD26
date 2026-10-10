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
