# Лабораторна робота №1

## Проєктування AI-агента для автоматизації розробки та CI/CD

**Студент:** Цегинька Назар Олегович
**Група:** КІ-405
**Варіант:** 26
**Репозиторій:** [nazartsehynkaki2023/405CSAD26](https://github.com/nazartsehynkaki2023/405CSAD26)

Ця версія лабораторної описує workspace-агента **Build Engineer** для
GitHub Copilot у VS Code. Агент оркеструє підготовку Python-проєкту,
локальних перевірок і GitHub Actions, але не виконує автоматичний push,
merge, створення PR або призначення reviewer.

## Стек

- Python 3.13
- `venv`
- `pytest`
- GitHub Actions
- GitHub Copilot custom agent, skills і prompt files

## Організація гілок

- `develop` містить агента, skills, prompt-команди та документацію.
- `feature/develop/python-project` призначена для Python-проєкту,
  який буде створений агентом під час окремого запуску `/init`.
- Після перевірки результату PR має бути спрямований
  `feature/develop/python-project` → `develop`.

Поточна гілка підготовки агента — `feature/develop/python-agent`.
PR №1 `lab1/finish` є draft і не змінюється цією роботою.

## Файли агента

- [.github/agents/build-engineer.agent.md](.github/agents/build-engineer.agent.md)
- [project-scaffold skill](.github/skills/project-scaffold/SKILL.md)
- [build-and-test skill](.github/skills/build-and-test/SKILL.md)
- [github-actions skill](.github/skills/github-actions/SKILL.md)
- [prompt-команди](.github/prompts/)

Докладна архітектура наведена в [docs/architecture.md](docs/architecture.md),
а інструкції користувача — у [docs/usage.md](docs/usage.md).

## Майбутній проєкт

Під час окремого запуску `/init` агент має створити:

```text
src/hello.py
src/math_operations.py
tests/
requirements-dev.txt
ci.bat
ci.sh
.github/workflows/python-ci.yml
```

`hello.py` має містити `main()`, яка друкує `Hello World!`, а
`math_operations.py` — функцію `add(a, b)`. Тести pytest перевірятимуть
базове додавання, додавання нуля, від'ємні числа та вивід через `capsys`.

Запуск `/init` у цьому підготовчому сеансі навмисно не виконується.
