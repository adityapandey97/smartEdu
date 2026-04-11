@echo off
cd /d C:\Users\honey\Desktop\offgrid\flutter_smartedu\android
call gradlew.bat assembleDebug --stacktrace
if errorlevel 1 (
    echo Gradle build failed with error code %errorlevel%
) else (
    echo Gradle build completed successfully
)
pause
