deepseekTTS

# Script de Conversación con DeepSeek y Síntesis de Voz (TTS)

Este script de bash te permite mantener una conversación interactiva con el modelo de lenguaje DeepSeek, utilizando [Ollama](https://ollama.com/) para inferencia y [Kokoro TTS](https://kokorotts.com/) para síntesis de voz (Text-to-Speech).

## Características

- **Conversación Interactiva:** Mantiene un historial de conversación limitado para un contexto más coherente.
- **Modelo DeepSeek:** Utiliza el modelo `huihui_ai/deepseek-r1-abliterated:latest` de Ollama (Modelo Sin censura, apto para roleo y nsfw, configurar el system prompt).
- **Síntesis de Voz:** Convierte las respuestas del modelo a audio utilizando la API de Kokoro TTS.
- **Parámetros Optimizados:** Configuración predeterminada para velocidad de respuesta.
- **Fácil de Usar:** Interfaz de línea de comandos simple para interactuar con el modelo.
- **Sanitización de Texto:** Elimina bloques `<think>` en las respuestas del modelo para una salida más limpia.

## Requisitos Previos

Antes de ejecutar el script, asegúrate de tener instaladas las siguientes dependencias:

- **Ollama:** Debes tener [Ollama](https://ollama.com/) instalado y configurado en tu sistema. Asegúrate de que el modelo `huihui_ai/deepseek-r1-abliterated:latest` esté disponible en Ollama (puedes descargarlo con `ollama pull huihui_ai/deepseek-r1-abliterated:latest`).
- **jq:** Procesador JSON de línea de comandos.
  ```bash
  sudo apt install jq  # En sistemas Debian/Ubuntu
  # o usa tu gestor de paquetes preferido
  ```
- **mpg123:** Reproductor de audio MP3 de línea de comandos.
  ```bash
  sudo apt install mpg123 # En sistemas Debian/Ubuntu
  # o usa tu gestor de paquetes preferido
  ```
- **Acceso a la API de Kokoro TTS:** Este script utiliza la API gratuita de Kokoro TTS. No requiere clave API, pero ten en cuenta las posibles limitaciones de uso del servicio gratuito.
- **Servidor Ollama accesible:** El script asume que tienes un servidor Ollama corriendo y accesible a través de una URL. El script está configurado para usar `https://tu-direccion-ngrok-free.app/api/chat`, que es un ejemplo de una URL generada por `ngrok`. **Debes reemplazar esto con la dirección correcta de tu servidor Ollama.**

## Configuración

Antes de ejecutar el script, revisa y ajusta las siguientes variables al inicio del script:

- **`MODEL="huihui_ai/deepseek-r1-abliterated:latest"`**: Define el modelo de Ollama que se utilizará. Puedes cambiarlo a cualquier modelo que tengas disponible en Ollama.
- **`MAX_CONTEXT=6`**: Controla el tamaño del historial de conversación. `MAX_CONTEXT=6` significa que se mantendrán los 6 turnos de conversación más recientes (incluyendo el prompt del sistema). Ajusta este valor según tus necesidades de contexto y memoria.
- **`SYSTEM_PROMPT="..."`**: Define el prompt del sistema que guía el comportamiento del modelo. Puedes personalizar este prompt para cambiar el rol y las instrucciones del asistente AI.
- **`TTS_API_URL="https://api.kokorotts.com/v1/audio/speech"`**: URL de la API de Kokoro TTS. No deberías necesitar cambiar esto a menos que la API cambie.
- **`VOICE="af_sky+af_bella"`**: Voz utilizada por la API de Kokoro TTS. Consulta la documentación de Kokoro TTS para ver las voces disponibles y elige la que prefieras.
- **`OLLAMA_PARAMS='{...}'`**: Parámetros JSON que se envían a Ollama para la generación de texto. Los parámetros predeterminados están optimizados para velocidad, pero puedes ajustarlos para priorizar la calidad, creatividad, etc. Consulta la documentación de Ollama para más detalles sobre los parámetros.
- **`API_ENDPOINT="https://tu-direccion-ngrok-free.app/api/chat"`**: **Esta es la URL de tu servidor Ollama.** **Debes reemplazar `https://tu-direccion-ngrok-free.app/api/chat` con la dirección correcta donde está corriendo tu servidor Ollama y su endpoint `/api/chat`.** Si estás usando `ngrok` para exponer tu servidor localmente, esta será la URL proporcionada por `ngrok`. Si tu servidor Ollama está accesible directamente en una red, usa esa dirección.

## Cómo Ejecutar el Script

1. **Guarda el script:** Guarda el código bash en un archivo, por ejemplo, `deepseek_tts_chat.sh`.
2. **Hazlo ejecutable:** Dale permisos de ejecución al script:
   ```bash
   chmod +x deepseek_tts_chat.sh
   ```
3. **Ejecuta el script:** Ejecuta el script desde la línea de comandos:
   ```bash
   ./deepseek_tts_chat.sh
   ```
4. **Interactúa:** El script te pedirá que escribas tus preguntas con el prefijo "User 😎: ". Escribe tu pregunta y presiona Enter. El modelo DeepSeek responderá y la respuesta se sintetizará en voz.
5. **Salir:** Para salir del script, escribe `salir` cuando se te pida la pregunta.

## Notas Importantes

- **Servidor Ollama en Ejecución:** Asegúrate de que tu servidor Ollama esté corriendo y accesible en la dirección configurada en `API_ENDPOINT`. Si estás usando `ngrok`, asegúrate de que `ngrok` esté activo y apuntando a tu servidor Ollama.
- **Conexión a Internet:** El script necesita conexión a internet para comunicarse con el servidor Ollama y la API de Kokoro TTS.
- **Limitaciones de la API TTS Gratuita:** La API de Kokoro TTS es gratuita, pero puede tener limitaciones de uso. Si planeas usar este script de forma intensiva, considera consultar las opciones de pago de Kokoro TTS o explorar otras APIs de TTS.
- **Latencia:** La velocidad de respuesta dependerá de varios factores, incluyendo la velocidad de tu conexión a internet, la carga del servidor Ollama y la API de TTS, y la complejidad de las preguntas.
- **Errores:** El script incluye manejo básico de errores y mostrará mensajes en caso de problemas de conexión, respuestas vacías o errores de JSON. Revisa la salida de la consola en caso de errores.

¡Disfruta de tu asistente conversacional con DeepSeek y voz!
