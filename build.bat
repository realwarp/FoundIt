@echo off
setlocal

set TOMCAT=C:\apache-tomcat-10.1

if not exist "%TOMCAT%\lib\servlet-api.jar" (
    echo Tomcat not found at %TOMCAT%
    echo Edit the TOMCAT path in build.bat.
    exit /b 1
)

if not exist "WebContent\WEB-INF\classes" mkdir "WebContent\WEB-INF\classes"

rmdir /s /q "WebContent\WEB-INF\classes" 2>nul
mkdir "WebContent\WEB-INF\classes"

echo Compiling FoundIt...

javac -cp "%TOMCAT%\lib\servlet-api.jar;WebContent\WEB-INF\lib\*" ^
      -d "WebContent\WEB-INF\classes" ^
      src\com\foundit\model\Item.java ^
      src\com\foundit\util\DBConnection.java ^
      src\com\foundit\servlet\*.java

if errorlevel 1 (
    echo.
    echo BUILD FAILED.
    exit /b 1
)

echo.
echo BUILD SUCCESSFUL.
echo Classes were created in WebContent\WEB-INF\classes
endlocal
