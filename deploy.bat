@echo off
setlocal

set "TOMCAT=C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1"
set "APP=%TOMCAT%\webapps\FoundIt"
set "UPLOAD_BACKUP=%TOMCAT%\webapps\FoundItUploads"

call build.bat
if errorlevel 1 exit /b 1

if not exist "%TOMCAT%\webapps" goto :tomcat_missing
if not exist "%UPLOAD_BACKUP%" mkdir "%UPLOAD_BACKUP%"
if exist "%APP%\uploads\*" xcopy "%APP%\uploads\*" "%UPLOAD_BACKUP%\" /E /I /Y >nul

if exist "%APP%" rmdir /s /q "%APP%"
mkdir "%APP%"

xcopy "WebContent\*" "%APP%\" /E /I /Y >nul
for %%F in (WebContent\WEB-INF\lib\mysql-connector-j-*.jar) do copy /Y "%%F" "%APP%\WEB-INF\lib\" >nul
if exist "%UPLOAD_BACKUP%\*" xcopy "%UPLOAD_BACKUP%\*" "%APP%\uploads\" /E /I /Y >nul

dir /b "%APP%\WEB-INF\lib\mysql-connector-j-*.jar" >nul 2>&1
if errorlevel 1 goto :deploy_failed
if not exist "%APP%\WEB-INF\web.xml" goto :deploy_failed
if not exist "%APP%\WEB-INF\classes\com\foundit\servlet\StaffLoginServlet.class" goto :deploy_failed
if not exist "%APP%\WEB-INF\views\guest-items.jsp" goto :deploy_failed

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
exit /b 0

:tomcat_missing
echo Tomcat webapps directory not found at:
echo %TOMCAT%\webapps
exit /b 1

:deploy_failed
echo Deployment failed because one or more required runtime files are missing.
echo Check the deployed application at:
echo %APP%
exit /b 1
