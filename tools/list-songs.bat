:: Lists all .ogg files in the specified directory and subdirectories
:: Formats them for JSON output

@echo off
chcp 65001
echo [ >> list-songs.json

set count=0
set "DIR_TO_SEARCH=C:\Users\vikto\Desktop\radiowatch\K2. Curated stream dumps\RADIO ENERGY\tracks"
(for /f "delims=" %%F in ('dir /b /s /a-d "%DIR_TO_SEARCH%\*.ogg"') do (
    echo     "%%~nF", >> list-songs.json
	set /a count+=1
	echo %%~nF
))

echo     "STATS: %count%" >> list-songs.json
echo ] >> list-songs.json

echo:
echo Added %count% files.
echo File list saved to list-songs.json
pause