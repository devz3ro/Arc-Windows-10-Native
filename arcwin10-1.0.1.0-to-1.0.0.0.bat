@ECHO OFF
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Requesting administrative privileges...
    PowerShell -Command "Start-Process '%~f0' -Verb RunAs"
    EXIT /B
)

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0arcwin10-1.0.1.0-to-1.0.0.0.ps1'"

ECHO Press Enter to exit ...
SET /P =
