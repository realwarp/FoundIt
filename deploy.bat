@echo off
setlocal
set TOMCAT=C:\apache-tomcat-10.1
set APP=%TOMCAT%\webapps\FoundIt

call build.bat
if errorlevel 1 exit /b 1

if not exist "%TOMCAT%\webapps" (
  echo Could not find Tomcat webapps directory.
  exit /b 1
)

if exist "%APP%" rmdir /s /q "%APP%"
mkdir "%APP%"

echo Copying web files...
xcopy "WebContent\*" "%APP%\" /E /I /Y >nul
if not exist "%APP%\WEB-INF\classes" mkdir "%APP%\WEB-INF\classes"
xcopy "build\classes\*" "%APP%\WEB-INF\classes\" /E /I /Y >nul

echo.
echo Deployment complete.
echo Then start Tomcat with:
echo %TOMCAT%\bin\startup.bat
echo.
echo Open:
echo http://localhost:8080/FoundIt/
endlocal
