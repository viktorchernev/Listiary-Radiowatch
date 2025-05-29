@echo off
cd /d "C:\Users\vikto\Desktop\radiowatch\.compiler"

:: Run DescribeTranspiler.CLI
DescribeTranspiler.CLI parse-folder ^
    "C:\Users\vikto\Desktop\radiowatch\W3. Describe sources" ^
    "C:\Users\vikto\Desktop\radiowatch\W5. Website\JsonVariant\sources\payload.json" ^
    translator=json ^
    beautify=true ^
    verbosity=low ^
    logfile="C:\Users\vikto\Desktop\radiowatch\W5. Website\JsonVariant\sources\payload.txt" ^
    dsonly=false ^
    toponly=false ^
    onerror=ignore ^
    censor ^
    theme=GREEN

:: Add a manual pause to separate steps
:: echo.
:: echo Compiler finished. Press any key to continue...
:: pause >nul

:: Modify the JSON file by adding "const JSON_PAYLOAD =" at the beginning and ";" at the end
set "json_file=C:\Users\vikto\Desktop\radiowatch\W5. Website\JsonVariant\sources\payload.json"
set "temp_file=%json_file%.tmp"

:: Ensure the JSON file exists
if not exist "%json_file%" (
    echo ERROR: JSON file not found!
    pause
    exit /b 1
)

:: Write "const JSON_PAYLOAD =" to the temp file
echo const JSON_PAYLOAD = > "%temp_file%"

:: Append the contents of the original JSON file
type "%json_file%" >> "%temp_file%"

:: Append ";" to the end
echo ; >> "%temp_file%"

:: Replace the original JSON file with the modified version
move /y "%temp_file%" "%json_file%" >nul

:: Delete old payload.js if it exists
if exist "C:\Users\vikto\Desktop\radiowatch\W5. Website\JsonVariant\sources\payload.js" (
    del "C:\Users\vikto\Desktop\radiowatch\W5. Website\JsonVariant\sources\payload.js"
)

:: Rename payload.json to payload.js
ren "C:\Users\vikto\Desktop\radiowatch\W5. Website\JsonVariant\sources\payload.json" "payload.js"

:: Final message to keep window open
echo.
echo All tasks completed successfully!
echo Press any key to exit...
pause >nul
