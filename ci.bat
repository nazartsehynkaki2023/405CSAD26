@echo off
setlocal

set "ROOT=%~dp0"
set "PYTHON=%ROOT%.venv\Scripts\python.exe"

if not exist "%PYTHON%" (
    py -3.13 -m venv "%ROOT%.venv"
    if errorlevel 1 exit /b 1
) else (
    "%PYTHON%" -c "import sys; raise SystemExit(0 if sys.version_info[:2] == (3, 13) else 1)"
    if errorlevel 1 (
        echo ERROR: existing .venv is not usable with Python 3.13.
        exit /b 1
    )
)

if not exist "%ROOT%tests" (
    echo ERROR: tests directory is missing.
    exit /b 1
)

"%PYTHON%" -m pip install -r "%ROOT%requirements-dev.txt"
if errorlevel 1 exit /b %errorlevel%

"%PYTHON%" -m pytest "%ROOT%tests"
if errorlevel 1 exit /b %errorlevel%

"%PYTHON%" "%ROOT%src\hello.py"
if errorlevel 1 exit /b %errorlevel%

exit /b 0
