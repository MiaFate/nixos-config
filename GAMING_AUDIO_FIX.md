# 🎮 Guía de Fix de Audio para Juegos (Focusrite Scarlett)

Si un juego se congela al iniciar o no tiene sonido, es probable que se deba a que tu **Focusrite Scarlett** tiene 18 canales y los motores de los juegos (como Unreal Engine) no saben cómo manejarlos.

## La Solución Permanente

Ya configuramos un **Sink Estéreo Virtual** en NixOS. Para usarlo en cualquier juego de Steam que te dé problemas, usá estos parámetros de lanzamiento:

### Parámetros de Lanzamiento (Steam)
```bash
PULSE_SINK=Stereo-Sink %command%
```

### ¿Cuándo usarlo?
*   Si el juego se queda "tildado" al abrir (congelamiento de imagen).
*   Si el juego se cierra solo sin dar error.
*   Si escuchas ruidos extraños o no hay audio.

---

## Cómo funciona (Detrás de escena)
En tu `configuration.nix`, creamos un módulo de PipeWire que toma el audio estéreo (2 canales) y lo "puentea" a tu Scarlett de forma automática. 

**Nombre del dispositivo:** `Stereo Fix (Scarlett)`
**Target:** `alsa_output.usb...multichannel-output`

---

## Debugging
Si por alguna razón no escuchas nada:
1.  Abrí `pavucontrol`.
2.  En la pestaña **Playback**, buscá el stream del juego.
3.  Asegurate de que el dispositivo de salida sea **Stereo-Fix**.
4.  Buscá el stream llamado **Loopback from Stereo-Sink** y asegurate de que esté ruteado a tu **Scarlett Multichannel**.

---
*Nota: Este fix es necesario porque muchos juegos antiguos o mal optimizados asumen que una placa de sonido solo tiene 2 o 5.1 canales.*
