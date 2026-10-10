# Журнал роботи з AI

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

## Завершення першого етапу

Підтверджений результат попереднього запуску мінімальної програми:

- Вивід: `Hello World!`
- Код завершення: `0`
