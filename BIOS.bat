@echo off
:: BatchGotAdmin
:: Check for administrative privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% NEQ 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c ""%~f0""", "", "runas", 1 > "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

:: Create a timestamped log file
set "logfile=%TEMP%\RebootToUEFI_%DATE:~-4%%DATE:~4,2%%DATE:~7,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log"
set logfile=%logfile: =0%

:: Check if the system supports UEFI firmware boot
echo [INFO] Checking if system supports UEFI firmware boot... >> "%logfile%"
bcdedit | find /I "path" | find /I "\EFI\" >nul
if %errorlevel% NEQ 0 (
    echo [ERROR] System does not appear to be UEFI-based. Cannot reboot into firmware. >> "%logfile%"
    echo ERROR: System is not UEFI-based. Exiting...
    timeout /t 5 /nobreak >nul
    exit /b 1
)

:: Confirm action
echo [INFO] Rebooting into UEFI firmware settings now... >> "%logfile%"
shutdown /r /fw /t 0 >> "%logfile%" 2>&1

exit /b 0