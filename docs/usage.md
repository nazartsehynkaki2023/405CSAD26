# Використання Build Engineer

## Вибір агента у VS Code

1. Відкрийте репозиторій у VS Code.
2. Відкрийте Chat і виберіть **Build Engineer** у списку custom agents.
3. Переконайтеся, що відкрито правильну робочу область і що агент бачить
   `.github/agents`, `.github/skills` та `.github/prompts`.

## Запуск `/init` і `/check`

У чаті Build Engineer запустіть `/init`. Агент спочатку перевірить передумови,
потім послідовно виконає підготовку Git, створення проєкту, build/test,
GitHub Actions і фінальну перевірку. У цьому підготовчому commit запуск
`/init` не виконується.

Після створення проєкту використовуйте `/check`. Команда перевіряє структуру,
frontmatter, зв'язки, workflow, запускає локальний `ci.bat` або `ci.sh`,
тести й Hello World, а також виконує `git diff --check`.

## Ручний запуск готового проєкту

Windows:

```text
ci.bat
```

Linux/macOS:

```bash
bash ./ci.sh
```

Скрипти не потребують ручної активації venv, створюють або повторно
використовують `.venv` у корені, встановлюють залежності лише туди,
запускають pytest і Hello World та повертають ненульовий код при помилці.

## Гілки та PR

Гілка `develop` міститиме агента, skills, prompt-команди й документацію.
Гілка `feature/develop/python-project` міститиме Python-проєкт, створений
агентом. Після локального `/check` результат має бути оформлений PR
`feature/develop/python-project` → `develop`. Агент самостійно не виконує
push, PR, merge або призначення reviewer.
