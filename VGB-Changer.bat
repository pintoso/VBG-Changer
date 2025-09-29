@echo off
mode con: cols=40 lines=13
title °          BG Changer          °

setlocal DisableDelayedExpansion

REM ##############################################################################
REM #                                                                            #
REM #                      INITIAL SETUP AND VARIABLES                           #
REM #                                                                            #
REM ##############################################################################

set "version=1.02"

REM Get script directory
set "scriptDir="
for %%A in ("%~dp0.") do set "scriptDir=%%~fA"
for %%A in ("%~f0") do set "scriptPath=%%~A"

pushd "%scriptDir%"

REM Define paths
set "pathFile=%scriptDir%\.temp\path.txt"
set "hashlistFile=%scriptDir%\.temp\hashlist.txt"
set "wallpaperFolder=%scriptDir%\wallpaper"
set "oldWallpaperFolder=%scriptDir%\.temp\wallpaper.old"
set "tempFolder=%scriptDir%\.temp"
set "monitorScriptPath=%tempFolder%\monitor_valorant_close.bat"

REM Find custom wallpaper & hash
set "customWallpaper="
set "customWallpaperHash="
for %%C in ("%wallpaperFolder%\*.mp4") do (
    if not defined customWallpaper set "customWallpaper=%%~fC"
)
if defined customWallpaper (
    set "__TARGET=%customWallpaper%"
    for /f "tokens=*" %%H in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (Get-FileHash -LiteralPath $env:__TARGET -Algorithm MD5 -ErrorAction Stop).Hash } catch { Write-Output 'ERROR' }"') do set "customWallpaperHash=%%H"
)

REM Base64 encoded monitor script
set "base64=QGVjaG8gb2ZmDQpSRU0gMS4wMg0Kc2V0bG9jYWwgRGlzYWJsZURlbGF5ZWRFeHBhbnNpb24NCg0Kc2V0ICJwYXRoRmlsZT0lfmRwMHBhdGgudHh0Ig0Kc2V0ICJyaW90UGF0aD0iDQoNCmlmIGV4aXN0ICIlcGF0aEZpbGUlIiAoDQogICAgZm9yIC9mICJ1c2ViYWNrcSBkZWxpbXM9IiAlJUcgaW4gKCIlcGF0aEZpbGUlIikgZG8gKA0KICAgICAgICBpZiBub3QgZGVmaW5lZCByaW90UGF0aCAoDQogICAgICAgICAgICBzZXQgInJpb3RQYXRoPSUlRyINCiAgICAgICAgKQ0KICAgICkNCikNCg0KaWYgbm90IGRlZmluZWQgcmlvdFBhdGggKA0KICAgIGVuZGxvY2FsDQogICAgZXhpdA0KKQ0KDQpzZXQgIm1lbnU9JXJpb3RQYXRoJVxTaG9vdGVyR2FtZVxDb250ZW50XE1vdmllc1xNZW51Ig0Kc2V0ICJiYWNrdXA9JX5kcDB3YWxscGFwZXIub2xkIg0KDQo6d2FpdGxvb3ANCnRhc2tsaXN0IDI+TlVMIHwgZmluZHN0ciAvSSAiVmFsb3JhbnQuZXhlIFZBTE9SQU5ULVdpbjY0LVNoaXBwaW5nLmV4ZSIgPk5VTA0KaWYgbm90IGVycm9ybGV2ZWwgMSAoDQogICAgdGltZW91dCAvdCAxID5udWwNCiAgICBnb3RvIDp3YWl0bG9vcA0KKQ0KDQpzZXQgIl9fTUVOVT0lbWVudSUiDQpzZXQgIl9fQkFDS1VQPSViYWNrdXAlIg0KcG93ZXJzaGVsbCAtTm9Qcm9maWxlIC1FeGVjdXRpb25Qb2xpY3kgQnlwYXNzIC1Db21tYW5kICJ0cnkgeyAkbWVudVBhdGggPSAkZW52Ol9fTUVOVTsgJGJhY2t1cFBhdGggPSAkZW52Ol9fQkFDS1VQOyBpZiAoVGVzdC1QYXRoIC1MaXRlcmFsUGF0aCAkYmFja3VwUGF0aCkgeyBHZXQtQ2hpbGRJdGVtIC1MaXRlcmFsUGF0aCAkYmFja3VwUGF0aCAtRmlsdGVyICcqLm1wNCcgLUVycm9yQWN0aW9uIFNpbGVudGx5Q29udGludWUgfCBGb3JFYWNoLU9iamVjdCB7ICRiYWNrdXBGaWxlID0gJF8uRnVsbE5hbWU7ICRtZW51RmlsZSA9IEpvaW4tUGF0aCAkbWVudVBhdGggJF8uTmFtZTsgaWYgKFRlc3QtUGF0aCAtTGl0ZXJhbFBhdGggJG1lbnVGaWxlKSB7ICRiYWNrdXBIYXNoID0gKEdldC1GaWxlSGFzaCAtTGl0ZXJhbFBhdGggJGJhY2t1cEZpbGUgLUFsZ29yaXRobSBNRDUpLkhhc2g7ICRtZW51SGFzaCA9IChHZXQtRmlsZUhhc2ggLUxpdGVyYWxQYXRoICRtZW51RmlsZSAtQWxnb3JpdGhtIE1ENSkuSGFzaDsgaWYgKCRiYWNrdXBIYXNoIC1uZSAkbWVudUhhc2gpIHsgQ29weS1JdGVtIC1MaXRlcmFsUGF0aCAkYmFja3VwRmlsZSAtRGVzdGluYXRpb24gJG1lbnVGaWxlIC1Gb3JjZSB9IH0gfSB9IH0gY2F0Y2ggeyB9Ig0KDQplbmRsb2NhbA=="

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                       ADMIN CHECK                                          #
REM #                                                                            #
REM ##############################################################################

net session >nul 2>&1
if %errorlevel% neq 0 (
    setlocal EnableDelayedExpansion
    call :display_header
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
    
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath 'cmd.exe' -ArgumentList '/c pushd \"!scriptDir!\" && \"!scriptPath!\"' -Verb RunAs -ErrorAction Stop } catch { Write-Host 'Error starting as administrator...' ; Start-Sleep -Seconds 5 ; exit 1 }"
    exit /b
)

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                    VALORANT PATH DETECTION & SETUP                         #
REM #                                                                            #
REM ##############################################################################

set "valorantLivePath="

setlocal EnableDelayedExpansion

REM --- 1. Check for saved path ---
set "pathFileExists=0"
setlocal DisableDelayedExpansion
if exist "%pathFile%" (
    for /f "usebackq delims=" %%i in ("%pathFile%") do set "valorantLivePath=%%i"
    set "pathFileExists=1"
)
endlocal & set "valorantLivePath=%valorantLivePath%" & set "pathFileExists=%pathFileExists%"

if "%pathFileExists%"=="1" (
    if defined valorantLivePath (
         goto :checks
    )
)

REM --- 2. Create required folders ---
setlocal DisableDelayedExpansion
if not exist "%tempFolder%\" (
    mkdir "%tempFolder%"
    attrib +h "%tempFolder%"
)
if not exist "%oldWallpaperFolder%\" (
    mkdir "%oldWallpaperFolder%"
)
if not exist "%wallpaperFolder%\" (
    mkdir "%wallpaperFolder%"
)
endlocal

REM --- 3. Check for custom wallpaper ---
set "mp4found="
setlocal DisableDelayedExpansion
dir /b "%wallpaperFolder%\*.mp4" >nul 2>&1
if not errorlevel 1 (
  set "mp4found=1"
)
endlocal & set "mp4found=%mp4found%"

if not defined mp4found (
    call :display_header
	echo.
	echo            No .mp4 files found
	echo          in the wallpaper folder.
	echo.
    timeout /t 5 >nul
    exit
)

REM --- 4. Find path from Riot YAML file ---
set "yamlPath=!ProgramData!\Riot Games\Metadata\valorant.live\valorant.live.product_settings.yaml"
setlocal DisableDelayedExpansion
if exist "%yamlPath%" (
    for /f "tokens=1,* delims=:" %%a in ('findstr /c:"product_install_full_path:" "%yamlPath%"') do (
        set "valorantLivePath=%%b"
    )
)
endlocal & set "valorantLivePath=%valorantLivePath%"

if defined valorantLivePath (
    goto :checks
)

REM --- 5. Manual path input ---
:ask_for_path
set "valorantLivePath="
set /p "valorantLivePath=Enter the VALORANT folder path: "
goto :checks

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                         PATH VALIDATION                                    #
REM #                                                                            #
REM ##############################################################################

:checks
if defined valorantLivePath (
    setlocal EnableDelayedExpansion
    
    REM Cleanup path string
    for /f "tokens=* delims= " %%a in ("!valorantLivePath!") do set "valorantLivePath=%%a"
     set "valorantLivePath=!valorantLivePath:"=!"
    set "valorantLivePath=!valorantLivePath:/=\!"
    if "!valorantLivePath:~-1!"=="\" set "valorantLivePath=!valorantLivePath:~0,-1!"

    for /f "delims=" %%i in ("!valorantLivePath!") do endlocal & set "valorantLivePath=%%i"
)

if not defined valorantLivePath (
    call :display_header
	echo.
	echo           The VALORANT folder path
	echo              was not provided.
	echo.
    goto :ask_for_path
)

setlocal DisableDelayedExpansion
if not exist "%valorantLivePath%" (
    endlocal
    call :display_header
	echo.
	echo               Invalid Path.
    echo.
	echo.
	goto :ask_for_path
)
endlocal

REM Validate game folders
set "pathCorrect=0"
setlocal DisableDelayedExpansion
if exist "%valorantLivePath%\ShooterGame\Content" ( set "pathCorrect=1" )
if exist "%valorantLivePath%\live\ShooterGame\Content" ( set "pathCorrect=2" & set "valorantLivePath=%valorantLivePath%\live" )
if exist "%valorantLivePath%\VALORANT\live\ShooterGame\Content" ( set "pathCorrect=3" & set "valorantLivePath=%valorantLivePath%\VALORANT\live" )
endlocal & set "pathCorrect=%pathCorrect%" & set "valorantLivePath=%valorantLivePath%"

if %pathCorrect% gtr 0 (
    goto :path_validated
)

REM Path is incorrect
call :display_header
echo.
echo           Invalid VALORANT Path.
echo      Folder does not contain the game.
echo.
goto :ask_for_path


:path_validated
REM Save validated path
set "__VALORANT=!valorantLivePath!"
setlocal DisableDelayedExpansion
set "__PATHFILE=%pathFile%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-Content -LiteralPath $env:__PATHFILE -Value $env:__VALORANT -Encoding Default -NoNewline"
endlocal

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                            MAIN LOGIC                                      #
REM #                                                                            #
REM ##############################################################################

REM --- Find Riot Client ---
set "launcherExePath="
set "JSONPATH=!ProgramData!\Riot Games\RiotClientInstalls.json"
setlocal DisableDelayedExpansion
if exist "%JSONPATH%" (
    for /f "usebackq delims=" %%R in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $j=Get-Content -Raw -LiteralPath '%JSONPATH%' -Encoding UTF8 | ConvertFrom-Json; $p=$j.rc_live; if(-not $p){$p=$j.rc_default}; if(-not $p){$p=$j.associated_client.Values|Select-Object -First 1}; if($p){$p.Trim()} else {''} } catch { '' }"`) do set "launcherExePath=%%R"
)
endlocal & set "launcherExePath=%launcherExePath%"

set "gameMenuPath=!valorantLivePath!\ShooterGame\Content\Movies\Menu"

REM --- Update hashlist ---
setlocal DisableDelayedExpansion
if not exist "%hashlistFile%" (
    if defined customWallpaperHash (
        set "__HASH=%customWallpaperHash%"
         set "__HASHFILE=%hashlistFile%"
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-Content -LiteralPath $env:__HASHFILE -Value $env:__HASH -Encoding ASCII"
    )
) else (
    if defined customWallpaperHash (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "$content = Get-Content -LiteralPath '%hashlistFile%' -ErrorAction SilentlyContinue; if ($content -contains '%customWallpaperHash%') { exit 0 } else { exit 1 }" >nul
        if errorlevel 1 (
            set "__HASH=%customWallpaperHash%"
            set "__HASHFILE=%hashlistFile%"
            powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Content -LiteralPath $env:__HASHFILE -Value $env:__HASH -Encoding ASCII"
        )
    )
)
endlocal

REM --- Sync backups ---
call :display_header
echo.
echo                 Backup...
echo.
call :syncBackups

timeout /t 2 >nul

REM --- Start VALORANT ---
set "opened=false"
if defined launcherExePath (
    setlocal DisableDelayedExpansion
    if exist "%launcherExePath%" (
        start "" "%launcherExePath%" --launch-product=valorant --launch-patchline=live
    ) else (
        endlocal & set "launcherExePath="
    )
    if defined launcherExePath endlocal
)

REM --- Cleanup and wait valorant ---
call :cleanup_orphan_backups
goto :prestart

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                            SUBROUTINES                                     #
REM #                                                                            #
REM ##############################################################################

:syncBackups
setlocal
REM List files to process
for /f "delims=" %%F in ('dir /b /a-d "%gameMenuPath%\*Homescreen*.mp4" 2^>nul') do (
    REM Process each file
    call :processBackupFile "%%F"
)
endlocal
goto :eof

:processBackupFile
setlocal DisableDelayedExpansion
set "fileName=%~1"
set "fullFilePath=%gameMenuPath%\%fileName%"
set "backupFilePath=%oldWallpaperFolder%\%fileName%"
set "gameFileHash="
set "isCustom=0"

REM Calculate game file hash
set "__TARGET=%fullFilePath%"
for /f "tokens=*" %%H in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (Get-FileHash -LiteralPath $env:__TARGET -Algorithm MD5 -ErrorAction Stop).Hash } catch { Write-Output 'ERROR' }"') do set "gameFileHash=%%H"

REM Check if hash is custom
if exist "%hashlistFile%" (
  if defined gameFileHash (
    if not "%gameFileHash%"=="ERROR" (
      powershell -NoProfile -ExecutionPolicy Bypass -Command "$content = Get-Content -LiteralPath '%hashlistFile%' -ErrorAction SilentlyContinue; if ($content -contains '%gameFileHash%') { exit 0 } else { exit 1 }" >nul
      if not errorlevel 1 set "isCustom=1"
    )
  )
)

REM Backup original wallpaper
if %isCustom% equ 0 (
    if not exist "%backupFilePath%" (
        echo(        %fileName%
        copy /y "%fullFilePath%" "%backupFilePath%" >nul
    ) else (
        set "backupFileHash="
        set "__TARGET=%backupFilePath%"
        for /f "tokens=*" %%H in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (Get-FileHash -LiteralPath $env:__TARGET -Algorithm MD5 -ErrorAction Stop).Hash } catch { Write-Output 'ERROR' }"') do set "backupFileHash=%%H"
        
        if defined gameFileHash if defined backupFileHash (
            if not "%gameFileHash%"=="ERROR" if not "%backupFileHash%"=="ERROR" (
                if "%gameFileHash%" neq "%backupFileHash%" (
                    echo(        %fileName%
                    copy /y "%fullFilePath%" "%backupFilePath%" >nul
                )
            )
         )
    )
)
endlocal
goto :eof

:cleanup_orphan_backups
REM Cleanup orphan backups
setlocal DisableDelayedExpansion
for /f "delims=" %%B in ('dir /b /a-d "%oldWallpaperFolder%\*.mp4" 2^>nul') do (
    if not exist "%gameMenuPath%\%%B" (
        del "%oldWallpaperFolder%\%%B"
    )
)
endlocal
goto :eof

:display_header
cls
echo.
echo.
echo.
echo.
echo          °°±±² BG CHANGER ²±±°°
echo.
goto :eof

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                         WAIT AND PROCESS                                   #
REM #                                                                            #
REM ##############################################################################

:prestart
REM --- Wait for VALORANT process ---
set "timer=0"
call :display_header
echo.
if defined launcherExePath (
    echo.
    echo            Waiting VALORANT...
    echo.
) else (
    echo         Riot Client not detected^^!
    echo      Please start the game manually.
    echo.
)

:wait_loop
set /a timer+=1
if %timer% EQU 20 if defined launcherExePath (
    echo.
    echo       Manual start may be required.
    echo.
)
timeout /t 1 >nul
tasklist 2>NUL | findstr /I "Valorant.exe VALORANT-Win64-Shipping.exe" >NUL
if not errorlevel 1 (
    set "opened=true"
    goto :check_folder
)
goto :wait_loop


:check_folder
REM --- Check if folder is writable ---
if "%opened%"=="true" (
    set "check_folder=!gameMenuPath!"
    
    setlocal EnableDelayedExpansion
    for /l %%i in (5,-1,1) do (
        setlocal DisableDelayedExpansion
        robocopy "%check_folder%" "%check_folder%" /L >nul
        set "err_level=%errorlevel%"
        endlocal & set "err_level=%err_level%"

         if !err_level! LSS 8 (
            timeout /t 1 >nul
            goto :copy_files
        ) else (
            call :display_header
            echo.
            echo             Waiting VALORANT.
            echo.
            echo              { %%i }
            echo.
        )
    )
    endlocal
)


:copy_files
REM --- Apply wallpaper ---
call :display_header
echo.
echo           Applying wallpaper...
echo.
setlocal DisableDelayedExpansion
set "__SRC=%customWallpaper%"

if not exist "%__SRC%" (
    echo   [ERROR] Wallpaper file not found
    endlocal
    goto :check_process
)

REM Apply wallpaper to each file
for %%F in ("%gameMenuPath%\*Homescreen*.mp4") do call :apply_one "%%~fF"

endlocal
goto :check_process


:apply_one
REM Copy file via PowerShell
setlocal DisableDelayedExpansion
set "__DST=%~1"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { Copy-Item -LiteralPath $env:__SRC -Destination $env:__DST -Force -ErrorAction Stop; exit 0 } catch { exit 1 }"

if errorlevel 1 echo     [ERROR] %~nx1
if not errorlevel 1 echo     [OK] %~nx1

endlocal
goto :eof

REM ##############################################################################

REM ##############################################################################
REM #                                                                            #
REM #                   MONITOR SCRIPT SETUP & LAUNCH                            #
REM #                                                                            #
REM ##############################################################################

:check_process
REM --- Create/update monitor script ---
setlocal DisableDelayedExpansion
set "doCreate=0"
if not exist "%monitorScriptPath%" (
    set "doCreate=1"
) else (
    set "line2="
    for /f "skip=1 tokens=*" %%G in ('findstr /n "^" "%monitorScriptPath%" 2^>nul') do (
        if not defined line2 set "line2=%%G"
    )
    if defined line2 (
      for /f "tokens=2" %%V in ("%line2%") do (
        if "%%V" neq "%version%" set "doCreate=2"
      )
    ) else (
      set "doCreate=1"
    )
)

if %doCreate% gtr 0 (
    set "__BASE64=%base64%"
    set "__OUTFILE=%monitorScriptPath%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$base64 = $env:__BASE64; $content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64)); Set-Content -LiteralPath $env:__OUTFILE -Value $content -Encoding Default -Force"
)
endlocal & set "doCreate=%doCreate%"

REM --- Display final message ---
if %doCreate%==1 (
    for /l %%i in (5,-1,1) do (
        timeout /t 1 >nul
        call :display_header
        echo.
        echo                 Finishing!
        echo.
        echo                   { %%i }
        echo.
    )
) else if %doCreate%==2 (
    for /l %%i in (5,-1,1) do (
        timeout /t 1 >nul
        call :display_header
        echo.
        echo                 Updating!
         echo.
        echo                   { %%i }
        echo.
    )
)

for /l %%i in (5,-1,1) do (
    timeout /t 1 >nul
    call :display_header
    echo.
    echo             Wallpaper Applied!
    echo.
    echo                  { %%i }
    echo.
)

REM --- Start monitor script ---
setlocal DisableDelayedExpansion
set "__SCRIPT=%monitorScriptPath%"
if exist "%__SCRIPT%" (
    call :display_header
    echo.
    echo          Starting monitor script...
    echo.
    set "__SCRIPTDIR=%scriptDir%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "try { " ^
        "  $scriptDir = $env:__SCRIPTDIR; " ^
        "  $scriptPath = Join-Path $scriptDir '.temp\monitor_valorant_close.bat'; " ^
        "  Start-Process -FilePath 'cmd.exe' -ArgumentList ('/c cd /d \"' + $scriptDir + '\.temp\" && monitor_valorant_close.bat') -Verb RunAs -WindowStyle Hidden; " ^
        "  Write-Host '                  READY!'; " ^
        "} catch { " ^
        "  Write-Host '   [ERROR] Failed: ' $_.Exception.Message; " ^
        "}"
) else (
    echo   [WARNING] Monitor script not found!
)
endlocal

timeout /t 3 >nul
exit

REM ##############################################################################