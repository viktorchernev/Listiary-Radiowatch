@echo off
setlocal enabledelayedexpansion

:: Define paths
set "BASE_DIR=C:\Users\vikto\Desktop\radiowatch\9. Spectrograms"
set "TOOLS_DIR=C:\Users\vikto\Desktop\radiowatch\.tools\ffmpeg\bin"

:: Delete old files
del /Q "%BASE_DIR%\2.PaddedOgg\*"
del /Q "%BASE_DIR%\3.RawSpectrograms\*"
del /Q "%BASE_DIR%\4.CroppedSpectrograms\*"

:: Change to FFmpeg directory
cd /d "%TOOLS_DIR%"

:: Pad OGG files
for %%f in ("%BASE_DIR%\1.RawOgg\*.ogg") do (
    ffmpeg -i "%%f" -af "apad" -t 600 "%BASE_DIR%\2.PaddedOgg\%%~nxf"
)

:: Generate spectrograms
for %%f in ("%BASE_DIR%\2.PaddedOgg\*.ogg") do (
    ffmpeg -i "%%f" -af "aformat=channel_layouts=mono, afftfilt=mode=complex" -lavfi "showspectrumpic=s=12000x512:legend=0:scale=log" "%BASE_DIR%\3.RawSpectrograms\%%~nf.png"
)

:: Crop spectrograms using ImageMagick
for %%f in ("%BASE_DIR%\3.RawSpectrograms\*.png") do (
    magick "%%f" -gravity East -background black -splice 1x0 -bordercolor black -border 1x0 -trim +repage "%BASE_DIR%\4.CroppedSpectrograms\%%~nf.png"
)

echo Processing complete!
pause
