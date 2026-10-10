@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "BUILD_DIR=%ROOT%\build\ci"
set "CMAKE_EXE="
set "CTEST_EXE="
set "VSDEVCMD="
set "VSINSTALL="

where cmake.exe >nul 2>&1
if not errorlevel 1 for /f "delims=" %%I in ('where cmake.exe') do if not defined CMAKE_EXE set "CMAKE_EXE=%%I"
where ctest.exe >nul 2>&1
if not errorlevel 1 for /f "delims=" %%I in ('where ctest.exe') do if not defined CTEST_EXE set "CTEST_EXE=%%I"

if not defined CMAKE_EXE goto FIND_VS_TOOLS
if not defined CTEST_EXE goto FIND_VS_TOOLS
goto TOOLS_READY

:FIND_VS_TOOLS
(
    set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
    if exist "!VSWHERE!" (
        for /f "usebackq delims=" %%I in (`"!VSWHERE!" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do if not defined VSINSTALL set "VSINSTALL=%%I"
        if defined VSINSTALL (
            set "VSDEVCMD=!VSINSTALL!\Common7\Tools\VsDevCmd.bat"
            set "CMAKE_EXE=!VSINSTALL!\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
            set "CTEST_EXE=!VSINSTALL!\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\ctest.exe"
        )
    )
)
if not defined CMAKE_EXE if defined VSINSTALL set "CMAKE_EXE=!VSINSTALL!\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
if not defined CTEST_EXE if defined VSINSTALL set "CTEST_EXE=!VSINSTALL!\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\ctest.exe"

:TOOLS_READY
if not defined CMAKE_EXE (
    echo Error: cmake.exe was not found in PATH or Visual Studio.
    exit /b 1
)
if not defined CTEST_EXE (
    echo Error: ctest.exe was not found in PATH or Visual Studio.
    exit /b 1
)
if not exist "%CMAKE_EXE%" (
    echo Error: cmake.exe does not exist: %CMAKE_EXE%
    exit /b 1
)
if not exist "%CTEST_EXE%" (
    echo Error: ctest.exe does not exist: %CTEST_EXE%
    exit /b 1
)

if defined VSDEVCMD (
    call "%VSDEVCMD%" -arch=x64 -host_arch=x64
    set "VSDEVCMD_CODE=!errorlevel!"
    if not "!VSDEVCMD_CODE!"=="0" exit /b !VSDEVCMD_CODE!
)

"%CMAKE_EXE%" --version
if errorlevel 1 exit /b %errorlevel%
"%CTEST_EXE%" --version
if errorlevel 1 exit /b %errorlevel%

"%CMAKE_EXE%" -S "%ROOT%" -B "%BUILD_DIR%"
if errorlevel 1 exit /b %errorlevel%
"%CMAKE_EXE%" --build "%BUILD_DIR%" --config Release
if errorlevel 1 exit /b %errorlevel%

set "TEST_COUNT="
pushd "%BUILD_DIR%"
"%CTEST_EXE%" -N -C Release > ctest-list.txt 2>&1
if errorlevel 1 (
    type ctest-list.txt
    popd
    exit /b 1
)
type ctest-list.txt
for /f "tokens=3" %%I in ('findstr /C:"Total Tests:" ctest-list.txt') do set "TEST_COUNT=%%I"
popd
if not defined TEST_COUNT (
    echo Error: no tests were discovered.
    exit /b 1
)
set /a TEST_COUNT_NUMBER=TEST_COUNT
if !TEST_COUNT_NUMBER! LEQ 0 (
    echo Error: no tests were discovered.
    exit /b 1
)

"%CTEST_EXE%" --test-dir "%BUILD_DIR%" -C Release --output-on-failure
if errorlevel 1 exit /b %errorlevel%

set "HELLO_EXE=%BUILD_DIR%\Release\hello.exe"
if not exist "%HELLO_EXE%" set "HELLO_EXE=%BUILD_DIR%\hello.exe"
if not exist "%HELLO_EXE%" (
    echo Error: hello.exe was not found.
    exit /b 1
)

"%HELLO_EXE%"
if errorlevel 1 exit /b %errorlevel%

exit /b 0
