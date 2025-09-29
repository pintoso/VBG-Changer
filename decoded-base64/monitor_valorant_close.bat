@echo off
REM 1.02
setlocal DisableDelayedExpansion

set "pathFile=%~dp0path.txt"
set "riotPath="

if exist "%pathFile%" (
    for /f "usebackq delims=" %%G in ("%pathFile%") do (
        if not defined riotPath (
            set "riotPath=%%G"
        )
    )
)

if not defined riotPath (
    endlocal
    exit
)

set "menu=%riotPath%\ShooterGame\Content\Movies\Menu"
set "backup=%~dp0wallpaper.old"

:waitloop
tasklist 2>NUL | findstr /I "Valorant.exe VALORANT-Win64-Shipping.exe" >NUL
if not errorlevel 1 (
    timeout /t 1 >nul
    goto :waitloop
)

set "__MENU=%menu%"
set "__BACKUP=%backup%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $menuPath = $env:__MENU; $backupPath = $env:__BACKUP; if (Test-Path -LiteralPath $backupPath) { Get-ChildItem -LiteralPath $backupPath -Filter '*.mp4' -ErrorAction SilentlyContinue | ForEach-Object { $backupFile = $_.FullName; $menuFile = Join-Path $menuPath $_.Name; if (Test-Path -LiteralPath $menuFile) { $backupHash = (Get-FileHash -LiteralPath $backupFile -Algorithm MD5).Hash; $menuHash = (Get-FileHash -LiteralPath $menuFile -Algorithm MD5).Hash; if ($backupHash -ne $menuHash) { Copy-Item -LiteralPath $backupFile -Destination $menuFile -Force } } } } } catch { }"

endlocal
