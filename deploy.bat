@echo off
setlocal

set TOMCAT=C:\apache-tomcat-10.1
set APP=%TOMCAT%\webapps\FoundIt

call build.bat
if errorlevel 1 exit /b 1

if exist "%APP%" rmdir /s /q "%APP%"
mkdir "%APP%"

xcopy "WebContent\*" "%APP%\" /E /I /Y >nul

echo.
echo FoundIt deployed to:
echo %APP%
echo.
echo Start Tomcat:
echo %TOMCAT%\bin\startup.bat
echo.
echo Open:
echo http://localhost:8080/FoundIt/

endlocal
