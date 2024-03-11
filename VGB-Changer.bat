@echo off

mode con: cols=40 lines=13
title °          BG Changer          °

REM Check if it is running as admin
>nul 2>&1 net session || (
    cls
	echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo   °°±±²  Starting as admin....   ²±±°°
	echo.
	echo.
	echo.
    echo             DC:   @PINTOSO
	echo.             X:  @_PINTOSO
	echo.
    powershell -Command "& { try { Start-Process '%0' -Verb RunAs -ErrorAction Stop } catch { Write-Host 'Error executing as administrator...' ; Start-Sleep -Seconds 5 ; exit 1 } }"
    exit /b
)

setlocal enabledelayedexpansion
set "riotPath="
set "driveLetters=C D E F G H I J K L M N O P Q R S T U V W X Y Z"

set "opened=false"

set "pathFile=%~dp0\.temp\path.txt"

if exist "%pathFile%" (
    set /p "riotPath=" < "%pathFile%"
)

REM if ".temp" folder does not exist, create
if not exist "%~dp0\.temp\" (
    mkdir "%~dp0\.temp\"
    attrib +h "%~dp0\.temp"
)

REM if ".temp\wallpaper.old" folder does not exist, create
if not exist "%~dp0\.temp\wallpaper.old\" (
    mkdir "%~dp0\.temp\wallpaper.old\"
    attrib +h "%~dp0\.temp\wallpaper.old"
)

REM if "wallpaper" folder does not exist, create
if not exist "%~dp0\wallpaper\" (
    mkdir "%~dp0\wallpaper\"
)

REM if are .mp4 files in "wallpaper" folder
dir /b "%~dp0\wallpaper\*.mp4" >nul 2>&1
if errorlevel 1 (
    cls
	echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo.
    echo            No .mp4 files found
	echo          in the wallpaper folder.
	echo.
    timeout /t 5 >nul
    exit
)

for %%D in (%driveLetters%) do (
    if exist "%%D:\Riot Games\" (
        set "riotPath=%%D:\Riot Games"
        goto :found_folder
    )
)

:ask_for_path
set /p "riotPath=Enter the Riot Games folder path: "

:checks
if not defined riotPath (
    cls
	echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo.
    echo         The Riot Games folder path
	echo             was not provided.
	echo.
    goto :ask_for_path
)

if not exist "%riotPath%" (
    cls
    echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo               Invalid Path
    echo.
	echo.
	echo.
    goto :ask_for_path
)

if not "%riotPath:~-10%"=="Riot Games" (
    cls
    echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo               Invalid Path
    echo         The folder name must end
	echo            with "Riot Games".
	echo.
    goto :ask_for_path
)

if not exist "%riotPath%\VALORANT" (
    cls
    echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo               Invalid Path
    echo        The path should be for the
	echo       Valorant installation folder.
	echo.
    goto :ask_for_path
)

:found_folder
echo %riotPath% > "%pathFile%"
set "checka=false"
set "maxFile="
set "maxNumber=0"

if exist "%riotPath%\VALORANT\live\ShooterGame\Content\Movies\Menu\*Homescreen.mp4" (
    for %%F in ("%riotPath%\VALORANT\live\ShooterGame\Content\Movies\Menu\*Homescreen.mp4") do (
        REM Get the number of the current file
        for /f "tokens=2 delims=_" %%A in ("%%~nF") do (
            REM Compare with the highest number found
            if %%A gtr !maxNumber! (
                REM Set the most updated wallpaper
                set "maxFile=%%~F"
                set "maxFileName=%%~nxF"
                set "maxNumber=%%A"
            )
        )
    )

    REM Copy the most updated file to wallpaper.old
    copy /y "!maxFile!" "%~dp0\.temp\wallpaper.old\"
	cls
	echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo                 Backing up
    echo           the original wallpaper
	echo     !maxFileName!
	echo.
) else (
    echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo          °°±±² BG CHANGER ²±±°°
	echo.
	echo.
	echo                 Backing up
    echo           the original wallpaper
	echo               FILE NOT FOUND
	echo.
)

REM Renames the wallpapers
for %%N in ("%~dp0\wallpaper\*.mp4") do (
    if not exist "%~dp0\wallpaper\!maxFileName!" (
        ren "%%N" "!maxFileName!"
        cls
        echo.
        echo.
        echo.
        echo.
        echo.
        echo.
        echo          °°±±² BG CHANGER ²±±°°
        echo.
        echo.
        echo                  Renaming
        echo     %%N
        echo                    To
        echo     !maxFileName!
    ) else (
        cls
        echo.
        echo.
        echo.
        echo.
        echo.
        echo.
        echo          °°±±² BG CHANGER ²±±°°
        echo.
        echo.
        echo            Wallpaper renamed.
        echo.
        echo.
        echo.
    )
)

REM Deletes old backups from wallpaper.old
if defined maxFileName (
    FOR %%a IN ("%~dp0\.temp\wallpaper.old\*") DO IF /i NOT "%%~nxa"=="!maxFileName!" DEL "%%a"
)

REM Start Valorant
start "" "%riotPath%\Riot Client\RiotClientServices.exe" --launch-product=valorant --launch-patchline=live


REM Espera por ate 20 segundos pelo Valorant.exe
:prestart
for /l %%i in (20,-1,1) do (
	timeout /t 1 >nul
	tasklist /fi "imagename eq Valorant.exe" 2>NUL | find /i /n "Valorant.exe" >NUL
	if "%ERRORLEVEL%"=="0" ( 
		set "opened=true"
		goto :check_folder
	) else (
		cls
		echo.
		echo.
		echo.
		echo.
		echo.
		echo.
		echo          °°±±² BG CHANGER ²±±°°
	    echo.
		echo           Aguardando VALORANT.
		echo.
		echo                 { %%i }
		echo.
		echo.
	)
)
exit

REM Checa se os arquivos estao livres
:check_folder
if %opened% == "true" (
    for /l %%i in (5,-1,1) do (
        set "check_folder=%riotPath%\VALORANT\live\ShooterGame\Content\Movies\Menu\"
        robocopy "%check_folder%" "%check_folder%" /L

        if %errorlevel% equ 1 (
            cls
            echo.
            echo.
            echo.
            echo.
            echo.
            echo.
            echo          °°±±² BG CHANGER ²±±°°
            echo.
            echo           Aguardando VALORANT.
            echo.
            echo                 { %%i }
            echo.
            echo.
        ) else (
            timeout /t 1 >nul
            goto :start
        )
    ) 
	exit
)

:start
tasklist /fi "imagename eq Valorant.exe" 2>NUL | find /i /n "Valorant.exe" >NUL
if "%ERRORLEVEL%"=="0" goto :copy_files
goto :start

REM Apply wallpaper
:copy_files
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo          °°±±² BG CHANGER ²±±°°
echo.
echo.
echo                 Copying!
echo.
echo.
echo.
timeout /t 3 >nul
copy /y "%~dp0\wallpaper\%maxFileName%" "%riotPath%\VALORANT\live\ShooterGame\Content\Movies\Menu"
goto :check_process

:check_process
REM A functional alternative using PowerShell to create and write code in another .bat from a .bat
REM Base64 code of the check_valorant_close.bat (decoded: https://www.base64decode.net/decode/7NIv)
set "base64=QGVjaG8gb2ZmDQoNCnNldGxvY2FsIGVuYWJsZWRlbGF5ZWRleHBhbnNpb24NCnNldCAicmlvdFBhdGg9Ig0Kc2V0ICJkcml2ZUxldHRlcnM9QyBEIEUgRiBHIEggSSBKIEsgTCBNIE4gTyBQIFEgUiBTIFQgVSBWIFcgWCBZIFoiDQoNCnNldCAicGF0aEZpbGU9JX5kcDBccGF0aC50eHQiDQoNCmlmIGV4aXN0ICIlcGF0aEZpbGUlIiAoDQogICAgc2V0IC9wICJyaW90UGF0aD0iIDwgIiVwYXRoRmlsZSUiDQopDQoNCmZvciAlJUQgaW4gKCVkcml2ZUxldHRlcnMlKSBkbyAoDQogICAgaWYgZXhpc3QgIiUlRDpcUmlvdCBHYW1lc1wiICgNCiAgICAgICAgc2V0ICJyaW90UGF0aD0lJUQ6XFJpb3QgR2FtZXMiDQogICAgICAgIGdvdG8gOmZvdW5kX2ZvbGRlcg0KICAgICkNCikNCjpmb3VuZF9mb2xkZXINCmVjaG8gJXJpb3RQYXRoJSA+ICIlcGF0aEZpbGUlIg0KDQpzZXQgIm1heEZpbGU9Ig0Kc2V0ICJtYXhOdW1iZXI9MCINCg0KUkVNIExvb3ANCmZvciAlJUYgaW4gKCIlcmlvdFBhdGglXFZBTE9SQU5UXGxpdmVcU2hvb3RlckdhbWVcQ29udGVudFxNb3ZpZXNcTWVudVwqSG9tZXNjcmVlbi5tcDQiKSBkbyAoDQogICAgZm9yIC9mICJ0b2tlbnM9MiBkZWxpbXM9XyIgJSVBIGluICgiJSV+bkYiKSBkbyAoDQogICAgICAgIGlmICUlQSBndHIgIW1heE51bWJlciEgKA0KCQkJc2V0ICJtYXhGaWxlPSUlfkYiDQogICAgICAgICAgICBzZXQgIm1heEZpbGVOYW1lPSUlfm54RiINCiAgICAgICAgICAgIHNldCAibWF4TnVtYmVyPSUlQSINCiAgICAgICAgKQ0KICAgICkNCikNCg0KUkVNIExvb3AgVmFsb3JhbnQuZXhlDQp0aW1lb3V0IC90IDEwID5udWwNCjpjaGVja19wcm9jZXNzDQp0YXNrbGlzdCAvZmkgImltYWdlbmFtZSBlcSBWYWxvcmFudC5leGUiIDI+TlVMIHwgZmluZCAvaSAvbiAiVmFsb3JhbnQuZXhlIiA+TlVMDQppZiAiJUVSUk9STEVWRUwlIj09IjAiICgNCiAgICB0aW1lb3V0IC90IDEgPm51bA0KICAgIGdvdG8gOmNoZWNrX3Byb2Nlc3MNCikgZWxzZSAoDQogICAgY29weSAveSAiJX5kcDAuLlwudGVtcFx3YWxscGFwZXIub2xkXCVtYXhGaWxlTmFtZSUiICIlcmlvdFBhdGglXFZBTE9SQU5UXGxpdmVcU2hvb3RlckdhbWVcQ29udGVudFxNb3ZpZXNcTWVudSINCiAgICBleGl0DQopDQoNCg=="
if not exist "%~dp0\.temp\check_valorant_close.bat" (
	REM Decode base64 and put in the check_valorant_close.bat file
    echo %base64% | powershell -command "$base64 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($input)); Set-Content -Path ('%~dp0\.temp\check_valorant_close.bat') -Value $base64"
    for /l %%i in (5,-1,1) do (
		timeout /t 1 >nul
		cls
		echo.
		echo.
		echo.
		echo.
		echo.
		echo.
		echo          °°±±² BG CHANGER ²±±°°
		echo.
		echo.
		echo                 Finishing!
		echo.
		echo                   { %%i }
		echo.
	)
	goto :check_process
) else (
    set "script=%~dp0\.temp\check_valorant_close.bat"
	REM Run check_valorant_close.bat in background
	for /l %%i in (15,-1,1) do (
		timeout /t 1 >nul
		cls
		echo.
		echo.
		echo.
		echo.
		echo.
		echo.
		echo          °°±±² BG CHANGER ²±±°°
		echo.
		echo.
		echo             Wallpaper Applied!
		echo.
		echo                  { %%i }
		echo.
	)
	powershell Start-Process -Verb RunAs -WindowStyle hidden -FilePath '!script!'
)
exit