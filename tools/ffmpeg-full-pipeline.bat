@echo off
setlocal enabledelayedexpansion


:: Define paths
set "BASE_DIR=C:\Users\vikto\Desktop\radiowatch\9. Spectrograms\"
set "TOOLS_DIR=C:\Users\vikto\Desktop\radiowatch\.tools\ffmpeg\bin"
set "DUMPS_DIR=C:\Users\vikto\Desktop\radiowatch\3. Curated stream dumps\RADIO ENERGY\variants"


:: Delete old files
rd /S /Q "%BASE_DIR%\1.RawOgg"
mkdir "%BASE_DIR%\1.RawOgg"
rd /S /Q "%BASE_DIR%\2.PaddedOgg"
mkdir "%BASE_DIR%\2.PaddedOgg"
rd /S /Q "%BASE_DIR%\3.RawSpectrograms"
mkdir "%BASE_DIR%\3.RawSpectrograms"
rd /S /Q "%BASE_DIR%\4.CroppedSpectrograms"
mkdir "%BASE_DIR%\4.CroppedSpectrograms"


:: Copy files
xcopy "%DUMPS_DIR%" "%BASE_DIR%\1.RawOgg\" /E /I /H /C /Y


:: Change to FFmpeg directory
cd /d "%TOOLS_DIR%"


:: Pad OGG files
for /d %%D in ("%BASE_DIR%\1.RawOgg\*") do (
    if exist "%%D\" (
        :: Create the subdirectory in the target directory
        mkdir "%BASE_DIR%\2.PaddedOgg\%%~nxD"
        
        :: Loop through all .ogg files in the subdirectory
        for %%F in ("%%D\*.ogg") do (
            :: Pad the .ogg file using ffmpeg and save to the new directory
            ffmpeg -i "%%F" -af "apad" -t 600 "%BASE_DIR%\2.PaddedOgg\%%~nxD\%%~nxF"
        )
    )
)


:: Generate spectrograms
for /d %%D in ("%BASE_DIR%\2.PaddedOgg\*") do (
    if exist "%%D\" (
        :: Create the subdirectory in the target directory
        mkdir "%BASE_DIR%\3.RawSpectrograms\%%~nxD"
        
        :: Loop through all .ogg files in the subdirectory
        for %%F in ("%%D\*.ogg") do (
			ffmpeg -i "%%F" -af "aformat=channel_layouts=mono, afftfilt=mode=complex" -lavfi "showspectrumpic=s=12000x512:legend=0:scale=log" "%BASE_DIR%\3.RawSpectrograms\%%~nxD\%%~nxF.png"
        )
    )
)


:: Crop spectrograms using ImageMagick
for /d %%D in ("%BASE_DIR%\3.RawSpectrograms\*") do (
    if exist "%%D\" (
        :: Create the subdirectory in the target directory
        mkdir "%BASE_DIR%\4.CroppedSpectrograms\%%~nxD"
        
        :: Loop through all .ogg files in the subdirectory
        for %%F in ("%%D\*.png") do (
			magick "%%F" -gravity East -background black -splice 1x0 -bordercolor black -border 1x0 -trim +repage "%BASE_DIR%\4.CroppedSpectrograms\%%~nxD\%%~nxF"
        )
    )
)


echo Processing complete!
pause