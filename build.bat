@echo off
setlocal
set TOMCAT=C:\apache-tomcat-10.1

if not exist "%TOMCAT%\lib\servlet-api.jar" (
  echo Could not find Tomcat at %TOMCAT%
  echo Edit TOMCAT in build.bat.
  exit /b 1
)

if not exist "WebContent\WEB-INF\lib" mkdir "WebContent\WEB-INF\lib"
rmdir /s /q build\classes 2>nul
mkdir build\classes

echo Compiling Java source...
javac -cp "%TOMCAT%\lib\servlet-api.jar;WebContent\WEB-INF\lib\*" -d build\classes src\com\foundit\model\Item.java src\com\foundit\util\DBConnection.java src\com\foundit\util\HtmlUtil.java src\com\foundit\util\PasswordUtil.java src\com\foundit\filter\AuthFilter.java src\com\foundit\servlet\*.java

if errorlevel 1 (
  echo.
  echo Build FAILED.
  exit /b 1
)

echo.
echo Build successful.
endlocal
