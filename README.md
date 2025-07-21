# 🔎 Detector Automático de Adware (ADB Tool)

Este script en lote para Windows permite detectar y eliminar automáticamente aplicaciones Android con comportamiento de **adware intrusivo**, utilizando comandos ADB.

Analiza el comportamiento del sistema Android en tiempo real para identificar apps que muestran anuncios emergentes o a pantalla completa sin autorización del usuario.

---
## 🚀 Características

- 🔍 **Detecta automáticamente paquetes sospechosos** desde los logs del sistema (`cmp=`).
- 🎯 **Extrae el nombre exacto del paquete** desde rutas tipo `cmp=com.ejemplo.app/...`.
- ✅ Intenta **desinstalar las apps con `--user 0`**, y si falla, **las inhabilita automáticamente**.
- 📁 **Genera un informe** completo (`informe_adware.txt`) con las acciones realizadas.
- ❌ Limpia el logcat antes de comenzar para asegurar análisis preciso.
- 🔐 Funciona **sin root** en dispositivos con depuración USB activada.

---
## 🛠️ Requisitos
- [Android SDK Platform Tools (ADB)](https://developer.android.com/tools/releases/platform-tools)
- Depuración USB activada en el dispositivo Android
- Windows 10/11

## 📦 Uso

1. Conecta tu dispositivo Android con **depuración USB** habilitada.
2. Ejecuta el archivo:
   ```bat
   detector_adware_auto.bat
3. Lo debes ejecutar en la carpeta platform-tools.
4. Espera a que analice procesos, servicios y logs.
5. El script identificará y eliminará o desactivará las apps que muestren anuncios sin consentimiento.
6. Consulta el informe generado: **informe_adware.txt**.

## 📄 Ejemplo de detección

   ```bat
[*] Actividad en primer plano: com.storymatrix.drama
[*] Paquetes detectados mostrando anuncios:
   - com.storymatrix.drama
   - games.spearmint.connectanimal
   - com.tripledot.tile.blossom
```

## ⚠️ Advertencia

* Este script no elimina malware de sistema preinstalado sin acceso root.

* Las apps que no puedan ser desinstaladas serán inhabilitadas para que no se ejecuten más.

## 📜 Licencia
MIT — Puedes usar, modificar y distribuir libremente esta herramienta con atribución.

## ✍️ Autor
Creado con ❤️ por [@Zuk4r1](https://github.com/Zuk4r1), pentester con conocimiento en hacking forense móvil y análisis de comportamiento de malware Android.

Herramienta creada para analisis contra adware persistente y aplicaciones maliciosas disfrazadas de apps legítimas.
