@echo off
title 🔎 Detector Letal de Adware - Android ADB Tool v2.0
color 0B

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║           🔥 ADB Adware Terminator v2.0                  ║
echo ║                 🐉Autor: @Zuk4r1                         ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

:: =======================
:: Listado masivo de firmas
:: =======================
set "FIRMAS=ad popup interstitial banner applovin ironsource facebook unity admob mopub chartboost vungle tapjoy startapp doubleclick revmob leadbolt adcolony millennialmedia inloco smaato pubnative supersonic flurry adjust airpush moplus"
set "CRITICAS=com.android.systemui com.android.phone com.android.settings com.google.android.gms com.google.android.gsf"
set "HISTORIAL=historial_adware.txt"

echo [*] Reiniciando logs y ADB...
adb logcat -c
adb start-server >nul
adb devices

:loop
echo.
echo [*] Obteniendo app actualmente en pantalla...
for /f "tokens=3 delims= " %%a in ('adb shell dumpsys window windows ^| findstr mCurrentFocus') do set paquete=%%a
echo [→] Actividad en primer plano: %paquete%
echo Actividad en primer plano: %paquete% > informe_adware.txt

echo.
echo [*] Detectando apps recién instaladas (últimas 24h)...
adb shell pm list packages -f | findstr -i ".apk" > all_packages_paths.txt
for /f "tokens=2 delims=:" %%a in (all_packages_paths.txt) do (
    adb shell "ls -l /data/app/%%a" 2>nul | findstr /i "$(date +%%Y-%%m-%%d)"
)

echo.
echo [*] Analizando procesos con firmas sospechosas...
adb shell ps -A | findstr /i "%FIRMAS%" > tmp_procs.txt
type tmp_procs.txt >> informe_adware.txt

echo.
echo [*] Escaneando servicios activos sospechosos...
adb shell dumpsys activity services | findstr /i "%FIRMAS%" > tmp_services.txt
type tmp_services.txt >> informe_adware.txt

echo.
echo [*] Revisando permisos peligrosos...
adb shell pm list packages > all_packages.txt
(for /f "tokens=2 delims=:" %%p in (all_packages.txt) do (
    adb shell dumpsys package %%p | findstr /i "INTERNET SYSTEM_ALERT_WINDOW BIND_ACCESSIBILITY_SERVICE" > nul
    if not errorlevel 1 echo %%p >> permisos_peligrosos.txt
)) >nul
type permisos_peligrosos.txt >> informe_adware.txt

echo.
echo [*] Escaneando conexiones en segundo plano...
adb shell netstat -an | findstr ":80 :443" > tmp_net.txt
type tmp_net.txt >> informe_adware.txt

echo.
echo [*] Leyendo logs (espera unos segundos)...
adb logcat -d | findstr /i "%FIRMAS%" > tmp_log.txt

findstr /r /c:"cmp=.*" tmp_log.txt > tmp_cmp.txt
(for /f "tokens=2 delims==" %%a in ('findstr /r /c:"cmp=" tmp_cmp.txt') do (
    for /f "tokens=1 delims=/" %%b in ("%%a") do echo %%b
)) | sort | uniq > paquetes_sospechosos.txt

type paquetes_sospechosos.txt | tee -a informe_adware.txt

for /f %%x in (paquetes_sospechosos.txt) do (
    echo.
    echo [*] Procesando %%x...
    echo %CRITICAS% | findstr /i "%%x" >nul
    if not errorlevel 1 (
        echo    ↳ Paquete crítico, saltando...
    ) else (
        findstr /i "%%x" %HISTORIAL% >nul
        if %errorlevel%==0 (
            echo    ↳ %%x ya estaba en el historial, bloqueando reinstalación...
            adb shell pm uninstall --user 0 %%x > nul
        ) else (
            echo    ↳ Forzando cierre...
            adb shell am force-stop %%x
            echo    ↳ Borrando datos...
            adb shell pm clear %%x
            echo    ↳ Intentando desinstalar...
            adb shell pm uninstall --user 0 %%x > nul
            if errorlevel 1 (
                echo    ↳ Fallo en desinstalación, intentando inhabilitar...
                adb shell pm disable-user --user 0 %%x > nul
                echo %%x >> %HISTORIAL%
                echo    ↳ %%x fue inhabilitada y añadida al historial.
            ) else (
                echo %%x >> %HISTORIAL%
                echo    ↳ %%x fue desinstalada y añadida al historial.
            )
        )
    )
)

echo.
echo [✓] Limpieza de archivos temporales...
del tmp_*.txt >nul 2>&1
del paquetes_sospechosos.txt >nul 2>&1
del tmp_cmp.txt >nul 2>&1
del permisos_peligrosos.txt >nul 2>&1
del all_packages.txt >nul 2>&1
del all_packages_paths.txt >nul 2>&1
del tmp_net.txt >nul 2>&1

echo.
echo [✓] Informe guardado en: informe_adware.txt
echo [✓] Historial de adware guardado en: %HISTORIAL%

echo.
echo [*] Generando tabla de hallazgos en resul.txt...
(
    echo ╔════════════════════════════════════════════════════════════════════════════════════╗
    echo ║                  RESULTADOS DEL ESCANEO - ARCHIVOS SOSPECHOSOS                     ║
    echo ╠══════════════════════════╦══════════════════════════╦══════════════════════════════╣
    echo ║ Nombre de Paquete        ║ Hash SHA256              ║ Firma Digital                ║
    echo ╠══════════════════════════╬══════════════════════════╬══════════════════════════════╣
    for /f %%X in (paquetes_sospechosos.txt) do (
        set "PKG=%%X"
        call :hash_and_sign "%%X"
    )
    echo ╚══════════════════════════╩══════════════════════════╩══════════════════════════════╝
) > resul.txt

echo.
echo [!] Archivos sospechosos encontrados:
type resul.txt
echo.
echo [!] Revise la lista y use:
echo adb shell pm uninstall --user 0 nombre.paquete
echo para eliminar manualmente cualquier archivo sospechoso.

pause
goto :eof

:hash_and_sign
setlocal
set "PKGNAME=%~1"
for /f "tokens=2 delims=:" %%P in ('adb shell pm path %PKGNAME% 2^>nul') do set "APKPATH=%%P"
if not defined APKPATH (
    echo %PKGNAME% ║ No disponible ║ No disponible
    endlocal & goto :eof
)
for /f "delims=" %%H in ('adb shell "sha256sum %APKPATH%" 2^>nul') do set "HASH=%%H"
for /f "delims=" %%F in ('adb shell "apksigner verify --print-certs %APKPATH%" 2^>nul ^| findstr /i "Signer"') do set "SIGN=%%F"
if not defined HASH set "HASH=No disponible"
if not defined SIGN set "SIGN=No disponible"
echo %PKGNAME% ║ %HASH% ║ %SIGN%
endlocal
goto :eof
