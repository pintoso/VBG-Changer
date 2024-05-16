@echo off

mode con: cols=40 lines=13
title °          BG Changer          °

REM Verifica se esta executando como admin
>nul 2>&1 net session || (
    cls
	echo.
	echo.
    echo.
	echo.
	echo.
	echo.
    echo   °°±±² Executando como admin... ²±±°°
	echo.
	echo. 
	echo.
    echo             DC:   @PINTOSO
	echo.             X:  @_PINTOSO
	echo.
    powershell -Command "& { try { Start-Process '%0' -Verb RunAs -ErrorAction Stop } catch { Write-Host 'Erro ao executar como administrador...' ; Start-Sleep -Seconds 5 ; exit 1 } }"
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

REM Verifica se a pasta ".temp" existe e a cria se nao existir
if not exist "%~dp0\.temp\" (
    mkdir "%~dp0\.temp\"
    attrib +h "%~dp0\.temp"
)

REM Verifica se a pasta ".temp\wallpaper.old" existe e a cria se nao existir
if not exist "%~dp0\.temp\wallpaper.old\" (
    mkdir "%~dp0\.temp\wallpaper.old\"
    attrib +h "%~dp0\.temp\wallpaper.old"
)

REM Verifica se a pasta "wallpaper" existe e a cria se nao existir
if not exist "%~dp0\wallpaper\" (
    mkdir "%~dp0\wallpaper\"
)

REM Checa se existem arquivos .mp4 na pasta "wallpaper"
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
    echo      Nenhum arquivo .mp4 encontrado
	echo            na pasta wallpaper.
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
set /p "riotPath=Digite o caminho para a pasta da Riot Games: "

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
    echo      O caminho da pasta Riot Games
	echo            nao foi fornecido.
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
	echo            Caminho Invalido
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
	echo            Caminho Invalido
    echo      O nome da pasta deve terminar
	echo            com "Riot Games".
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
	echo            Caminho Invalido
    echo      O caminho deve ser para pasta
	echo        de instalacao do Valorant.
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
        set "fileName=%%~nxF"
        set "prefix=!fileName:~0,4!"
		REM Checa o prefixo "VCT_" e extrai o terceiro número
        if "!prefix!"=="VCT_" (
            for /f "tokens=3 delims=_" %%A in ("%%~nF") do (
                set "currentNumber=%%A"
            )
        ) else (
            REM Se não for um homescreen "VCT_", extrai o segundo número
            for /f "tokens=2 delims=_" %%A in ("%%~nF") do (
                set "currentNumber=%%A"
            )
        )

        REM Compara os números e usa o wallpaper mais atualizado
        if !currentNumber! gtr !maxNumber! (
            set "maxFile=%%~F"
            set "maxFileName=%%~nxF"
            set "maxNumber=!currentNumber!"
        )
    )

    REM Copia o arquivo mais recente para wallpaper.old
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
	echo            Fazendo backup
    echo         Do wallpaper original
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
	echo              Fazendo Backup
    echo           do wallpaper original
	echo           ARQUIVO NAO ENCONTRADO
	echo.
)

REM Renomeia os wallpapers
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
        echo                 Renomeando
        echo     %%N
        echo                   Para
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
        echo           Wallpaper renomeado.
        echo.
        echo.
        echo.
    )
)

REM Exclui backups antigos do wallpaper.old
if defined maxFileName (
    FOR %%a IN ("%~dp0\.temp\wallpaper.old\*") DO IF /i NOT "%%~nxa"=="!maxFileName!" DEL "%%a"
)

REM Inicia o Valorant
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

REM Aplica o wallpaper
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
echo                Copiando!
echo.
echo.
echo.
timeout /t 3 >nul
copy /y "%~dp0\wallpaper\%maxFileName%" "%riotPath%\VALORANT\live\ShooterGame\Content\Movies\Menu"
goto :check_process

:check_process
REM Uma forma funcional alternativa usando powershell de criar e escrever codigo em outro .bat apartir de um .bat
REM Base64 do codigo do check_valorant_close.bat (decodificado: https://www.base64decode.net/decode/8yDy)
set "base64=QGVjaG8gb2ZmDQpSRU0gMS4wMQ0Kc2V0bG9jYWwgZW5hYmxlZGVsYXllZGV4cGFuc2lvbg0Kc2V0ICJyaW90UGF0aD0iDQpzZXQgImRyaXZlTGV0dGVycz1DIEQgRSBGIEcgSCBJIEogSyBMIE0gTiBPIFAgUSBSIFMgVCBVIFYgVyBYIFkgWiINCg0Kc2V0ICJwYXRoRmlsZT0lfmRwMFxwYXRoLnR4dCINCg0KaWYgZXhpc3QgIiVwYXRoRmlsZSUiICgNCiAgICBzZXQgL3AgInJpb3RQYXRoPSIgPCAiJXBhdGhGaWxlJSINCikNCg0KZm9yICUlRCBpbiAoJWRyaXZlTGV0dGVycyUpIGRvICgNCiAgICBpZiBleGlzdCAiJSVEOlxSaW90IEdhbWVzXCIgKA0KICAgICAgICBzZXQgInJpb3RQYXRoPSUlRDpcUmlvdCBHYW1lcyINCiAgICAgICAgZ290byA6Zm91bmRfZm9sZGVyDQogICAgKQ0KKQ0KOmZvdW5kX2ZvbGRlcg0KZWNobyAlcmlvdFBhdGglID4gIiVwYXRoRmlsZSUiDQoNCnNldCAibWF4RmlsZT0iDQpzZXQgIm1heE51bWJlcj0wIg0KDQpSRU0gTG9vcA0KZm9yICUlRiBpbiAoIiVyaW90UGF0aCVcVkFMT1JBTlRcbGl2ZVxTaG9vdGVyR2FtZVxDb250ZW50XE1vdmllc1xNZW51XCpIb21lc2NyZWVuLm1wNCIpIGRvICgNCiAgICBzZXQgImZpbGVOYW1lPSUlfm54RiINCiAgICBzZXQgInByZWZpeD0hZmlsZU5hbWU6fjAsNCEiDQogICAgDQogICAgaWYgIiFwcmVmaXghIj09IlZDVF8iICgNCiAgICAgICAgZm9yIC9mICJ0b2tlbnM9MyBkZWxpbXM9XyIgJSVBIGluICgiJSV+bkYiKSBkbyAoDQogICAgICAgICAgICBzZXQgImN1cnJlbnROdW1iZXI9JSVBIg0KICAgICAgICApDQogICAgKSBlbHNlICgNCiAgICAgICAgZm9yIC9mICJ0b2tlbnM9MiBkZWxpbXM9XyIgJSVBIGluICgiJSV+bkYiKSBkbyAoDQogICAgICAgICAgICBzZXQgImN1cnJlbnROdW1iZXI9JSVBIg0KICAgICAgICApDQogICAgKQ0KICAgIGlmICFjdXJyZW50TnVtYmVyISBndHIgIW1heE51bWJlciEgKA0KICAgICAgICBzZXQgIm1heEZpbGU9JSV+RiINCiAgICAgICAgc2V0ICJtYXhGaWxlTmFtZT0lJX5ueEYiDQogICAgICAgIHNldCAibWF4TnVtYmVyPSFjdXJyZW50TnVtYmVyISINCiAgICApDQopDQoNCg0KUkVNIExvb3AgVmFsb3JhbnQuZXhlDQp0aW1lb3V0IC90IDEwID5udWwNCjpjaGVja19wcm9jZXNzDQp0YXNrbGlzdCAvZmkgImltYWdlbmFtZSBlcSBWYWxvcmFudC5leGUiIDI+TlVMIHwgZmluZCAvaSAvbiAiVmFsb3JhbnQuZXhlIiA+TlVMDQppZiAiJUVSUk9STEVWRUwlIj09IjAiICgNCiAgICB0aW1lb3V0IC90IDEgPm51bA0KICAgIGdvdG8gOmNoZWNrX3Byb2Nlc3MNCikgZWxzZSAoDQogICAgY29weSAveSAiJX5kcDAuLlwudGVtcFx3YWxscGFwZXIub2xkXCVtYXhGaWxlTmFtZSUiICIlcmlvdFBhdGglXFZBTE9SQU5UXGxpdmVcU2hvb3RlckdhbWVcQ29udGVudFxNb3ZpZXNcTWVudSINCiAgICBleGl0DQopDQoNCg=="

REM Versão do check_valorant_close.bat 
set "version=1.01"

if not exist "%~dp0\.temp\check_valorant_close.bat" (
    REM Decodifica o base64 como check_valorant_close.bat
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
        echo                Terminando!
        echo.
        echo                   { %%i }
        echo.
    )
    goto :check_process
) else (
    REM Check the check_valorant_close.bat version
    for /f "tokens=1* delims=:" %%G in ('findstr /n "^" "%~dp0\.temp\check_valorant_close.bat"') do (
        if %%G equ 2 (
            set "line=%%H"
            set "line=!line:REM =!"
            if "!line!" neq "%version%" (
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
                    echo                Atualizando!
                    echo.
                    echo                   { %%i }
                    echo.
                )
                goto :check_process
            )
        )
    )
    set "script=%~dp0\.temp\check_valorant_close.bat"
    REM Abre check_valorant_close.bat de fundo
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
        echo            Wallpaper Aplicado!
        echo.
        echo                  { %%i }
        echo.
    )
    powershell Start-Process -Verb RunAs -WindowStyle hidden -FilePath '!script!'
)
exit
