@echo off
setlocal enabledelayedexpansion

echo Directory File Count
for /d %%D in (*) do (
    set /a count=0
    for %%F in ("%%D\*") do set /a count+=1
    echo %%D !count!
)

endlocal
pause