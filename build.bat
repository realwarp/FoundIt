@echo off
setlocal

set "TOMCAT=C:\Program Files (x86)\Apache Software Foundation\Tomcat 10.1"
set "CONNECTOR=WebContent\WEB-INF\lib\mysql-connector-j-*.jar"

if not exist "%TOMCAT%\lib\servlet-api.jar" goto :tomcat_missing
dir /b "%CONNECTOR%" >nul 2>&1
if errorlevel 1 goto :connector_missing

if not exist "WebContent\WEB-INF\classes" mkdir "WebContent\WEB-INF\classes"
for /r "WebContent\WEB-INF\classes" %%F in (*.class) do del /q "%%F" >nul 2>&1

echo Compiling FoundIt...

javac -cp "%TOMCAT%\lib\servlet-api.jar;WebContent\WEB-INF\lib\*" ^
  -d "WebContent\WEB-INF\classes" ^
  src\com\foundit\filter\StaffAuthFilter.java ^
  src\com\foundit\model\Item.java ^
  src\com\foundit\util\DBConnection.java ^
  src\com\foundit\servlet\*.java

if errorlevel 1 goto :build_failed

echo.
echo BUILD SUCCESSFUL.
echo Classes were created in WebContent\WEB-INF\classes
goto :done

:tomcat_missing
echo Tomcat not found at:
echo %TOMCAT%
echo.
echo Check that servlet-api.jar exists in that Tomcat lib folder.
exit /b 1

:connector_missing
echo MySQL Connector/J not found.
echo Copy mysql-connector-j-*.jar into:
echo %CD%\WebContent\WEB-INF\lib
exit /b 1

:build_failed
echo.
echo BUILD FAILED.
exit /b 1

:done
endlocal