# 🔎 Detector Automático de Adware (ADB Tool) — Versión Avanzada

Herramienta en Batch para Windows que detecta, analiza y elimina automáticamente aplicaciones Android con adware persistente, usando comandos ADB.

Ahora con un rango de detección mucho más amplio, agresivo y profundo, capaz de identificar procesos y apps maliciosas que intenten ocultarse, así como registrar su hash y firma digital antes de eliminarlas o deshabilitarlas.

---
## 🚀 Mejoras y Características Avanzadas

* 🔍 Análisis total del sistema: examina logs, procesos activos, servicios, paquetes instalados y permisos peligrosos.

* 🎯 Detección de apps ocultas: rastrea incluso aquellas que no aparecen en la lista estándar de aplicaciones.

* 🧠 Motor heurístico ampliado: identifica comportamientos de adware aunque el nombre del paquete sea aleatorio o disfrazado.

* 📜 Registro forense: guarda en informe_adware.txt información completa:

Nombre del paquete

Ruta de instalación

Firma digital

Hash SHA-256 del APK

Resultado de desinstalación o inhabilitación

* ⚔️ Eliminación agresiva:

Desinstalación con --user 0

Si falla: inhabilitación forzosa

Si la app intenta reinstalarse, vuelve a detectarla y eliminarla

* 🛡 Protección contra evasión: analiza continuamente para evitar que procesos maliciosos reaparezcan.

* 📁 Informe con evidencia técnica: útil para reportes forenses o auditorías de seguridad.

* 🔐 Funciona sin root (depuración USB activada).

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
[*] Escaneando procesos...
[+] Detección: com.storymatrix.drama — Adware detectado
    Ruta: /data/app/com.storymatrix.drama-1/base.apk
    SHA256: 3A8B9F4E2E91D54B11F2AE9D3C21...
    Firma digital: CN=Example Ltd, O=Example Org
    Acción: Eliminado con éxito

[+] Detección: com.tripledot.tile.blossom — Adware detectado
    Ruta: /data/app/com.tripledot.tile.blossom-1/base.apk
    SHA256: 92C1D4F3A9E8F7D21A3C...
    Firma digital: CN=Unknown
    Acción: Inhabilitado (no desinstalable sin root)
```

## ⚠️ Advertencia

* Este script no elimina malware de sistema preinstalado sin acceso root.

* Las apps que no puedan ser desinstaladas serán inhabilitadas para que no se ejecuten más.

* El uso de esta herramienta debe ser responsable y con autorización sobre el dispositivo analizado.

## 📜 Licencia
[MIT](https://github.com/Zuk4r1/detector-adware-adb/blob/main/LICENSE) — Puedes usar, modificar y distribuir libremente esta herramienta con atribución.

## ✍️ Autor
Creado con ❤️ por [@Zuk4r1](https://github.com/Zuk4r1), pentester con conocimiento en hacking forense móvil y análisis de comportamiento de malware Android.

Herramienta creada para analisis contra adware persistente y aplicaciones maliciosas disfrazadas de apps legítimas.
