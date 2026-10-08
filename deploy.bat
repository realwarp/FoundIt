@echo off
setlocal

set "TOMCAT=C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1"
set "CATALINA_HOME=%TOMCAT%"
set "CATALINA_BASE=%TOMCAT%"
set "APP=%TOMCAT%\webapps\FoundIt"
set "UPLOAD_BACKUP=%TOMCAT%\webapps\FoundItUploads"
set "URL=http://localhost:8080/FoundIt/"

if defined JAVA_HOME goto :java_ready
for /f "delims=" %%J in ('where java 2^>nul') do if not defined JAVA_EXE set "JAVA_EXE=%%J"
if not defined JAVA_EXE goto :java_missing
for %%J in ("%JAVA_EXE%") do set "JAVA_HOME=%%~dpJ.."

:java_ready

call build.bat
if errorlevel 1 exit /b 1

if not exist "%TOMCAT%\webapps" goto :tomcat_missing
if not exist "%TOMCAT%\bin\startup.bat" goto :tomcat_missing
if not exist "%JAVA_HOME%\bin\java.exe" goto :java_missing
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
netstat -ano | findstr /r /c:":8080 .*LISTENING" >nul
if not errorlevel 1 goto :check_existing_server

echo Starting Tomcat...
call "%TOMCAT%\bin\startup.bat"
if errorlevel 1 goto :startup_failed

echo Waiting for FoundIt to become available...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$deadline = (Get-Date).AddSeconds(20); while ((Get-Date) -lt $deadline) { try { Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -TimeoutSec 1 | Out-Null; exit 0 } catch { Start-Sleep -Milliseconds 500 } }; exit 1"
if errorlevel 1 goto :startup_failed

:check_existing_server
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -TimeoutSec 1 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 goto :port_conflict

:server_ready
echo.
echo FoundIt is starting at:
echo %URL%
start "" "%URL%"

endlocal
exit /b 0

:tomcat_missing
echo Tomcat webapps directory not found at:
echo %TOMCAT%\webapps
exit /b 1

:java_missing
echo Java was not found on PATH and JAVA_HOME is not set.
echo Install JDK 21 or set JAVA_HOME to your JDK installation.
exit /b 1

:startup_failed
echo FoundIt could not be reached at %URL%.
echo Check the Tomcat logs under:
echo %TOMCAT%\logs
exit /b 1

:port_conflict
echo Port 8080 is already in use by another application.
echo Stop that application or change Tomcat's port before running deploy.bat again.
exit /b 1

:deploy_failed
echo Deployment failed because one or more required runtime files are missing.
echo Check the deployed application at:
echo %APP%
exit /b 1
