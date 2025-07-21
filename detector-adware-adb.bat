@echo off
title 🔎 Detector Automático de Adware - Android ADB Tool
color 0B

echo [*] Reiniciando logs y ADB...
adb logcat -c
adb start-server >nul
adb devices

echo.
echo [*] Obteniendo app actualmente en pantalla...
for /f "tokens=3 delims= " %%a in ('adb shell dumpsys window windows ^| findstr mCurrentFocus') do set paquete=%%a
echo [→] Actividad en primer plano: %paquete%
echo Actividad en primer plano: %paquete% > informe_adware.txt

echo.
echo [*] Analizando procesos con posibles SDKs publicitarios...
adb shell ps | findstr /i "ad popup interstitial applovin ironsource facebook unity" > tmp_procs.txt
type tmp_procs.txt >> informe_adware.txt
type tmp_procs.txt
echo.

echo [*] Escaneando servicios activos sospechosos...
adb shell dumpsys activity services | findstr -i "ad popup interstitial banner" > tmp_services.txt
type tmp_services.txt >> informe_adware.txt
type tmp_services.txt
echo.

echo [*] Leyendo logs (espera unos segundos)...
adb logcat -d | findstr -i "AdShow InterstitialAd fullscreen popup applovin iron" > tmp_log.txt

echo [*] Analizando paquetes detectados en el log...
findstr /r /c:"cmp=.*" tmp_log.txt > tmp_cmp.txt

:: Extraer nombres de paquete únicos
(for /f "tokens=2 delims==" %%a in ('findstr /r /c:"cmp=" tmp_cmp.txt') do (
    for /f "tokens=1 delims=/" %%b in ("%%a") do echo %%b
)) | sort | uniq > paquetes_sospechosos.txt

echo.
echo [!] Paquetes detectados ejecutando anuncios:
type paquetes_sospechosos.txt | tee -a informe_adware.txt
echo.

for /f %%x in (paquetes_sospechosos.txt) do (
    echo [*] Intentando eliminar %%x...
    adb shell pm uninstall --user 0 %%x > nul
    if errorlevel 1 (
        echo    ↳ Fallo. Intentando inhabilitar %%x...
        adb shell pm disable-user --user 0 %%x > nul
        echo    ↳ %%x fue inhabilitada. >> informe_adware.txt
    ) else (
        echo    ↳ %%x fue desinstalada correctamente. >> informe_adware.txt
    )
)

echo.
echo [✓] Limpieza de archivos temporales...
del tmp_*.txt >nul 2>&1
del paquetes_sospechosos.txt >nul 2>&1
del tmp_cmp.txt >nul 2>&1

echo.
echo [✓] Informe guardado en: informe_adware.txt

pause
