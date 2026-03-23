@echo off
setlocal enabledelayedexpansion

set "ORIGEN=F:\SD_VIDEO"
set "DESTINO=D:\Filmadora videos"

echo === VERIFICANDO Y REANUDANDO ===
pause

for /r "%ORIGEN%" %%F in (*.mod *.MOD) do (

    set "RUTA=%%F"
    set "REL=!RUTA:%ORIGEN%=!"
    set "DEST=%DESTINO%!REL!"

    for %%A in ("!DEST!") do set "CARPETA=%%~dpA"

    if not exist "!CARPETA!" mkdir "!CARPETA!"

    set "SALIDA=!CARPETA!%%~nF.mp4"

    set "REPROCESAR=0"

    if exist "!SALIDA!" (

        echo Verificando: %%~nxF

        ffmpeg -v error -i "!SALIDA!" -f null - >nul 2>&1

        if errorlevel 1 (
            echo [CORRUPTO] Eliminando...
            del "!SALIDA!"
            set "REPROCESAR=1"
        ) else (
            echo [OK] Archivo válido → %%~nxF
        )

    ) else (
        set "REPROCESAR=1"
    )

    if "!REPROCESAR!"=="1" (
        echo [PROCESANDO] %%~nxF

        ffmpeg -i "%%F" -c:v libx264 -crf 23 -preset fast -c:a aac "!SALIDA!"
    )
)

echo === PROCESO COMPLETADO ===
pause
