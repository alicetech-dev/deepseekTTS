# deepseekTTS: Conversación por Voz con DeepSeek en Local y en la Nube

Este repositorio contiene dos scripts para interactuar con el modelo de lenguaje DeepSeek de forma innovadora:

1. **deepseek_tts_chat.sh (Debian Local):** Un script de bash para sistemas Debian que te permite tener una conversación interactiva con DeepSeek utilizando tu micrófono y sintetizando las respuestas a voz mediante la API de Kokoro TTS.
2. **Ollama_Ngrok_Colab.ipynb (Google Colab):** Un cuaderno de Google Colab para ejecutar Ollama (y por ende, modelos como DeepSeek) en la nube, y hacerlo accesible de forma remota a través de un túnel seguro de Ngrok.

## 1. deepseek_tts_chat.sh: Chatea con DeepSeek por Voz en Debian

Este script te permite tener una conversación hablada con el modelo DeepSeek corriendo localmente en un sistema Debian. Utiliza Ollama para la inferencia y la API gratuita de Kokoro TTS para la síntesis de voz.

### Características

- **Conversación Interactiva:** Mantiene un historial de conversación para un contexto más coherente.
- **Modelo DeepSeek:** Usa el modelo `huihui_ai/deepseek-r1-abliterated:latest` de Ollama (un modelo sin censura, ideal para roleo y NSFW, permite configurar el prompt del sistema).
- **Síntesis de Voz:** Convierte las respuestas de DeepSeek a audio usando la API de Kokoro TTS.
- **Parámetros Optimizados:** Configuración predeterminada para una respuesta rápida.
- **Fácil de Usar:** Interfaz simple de línea de comandos.
- **Sanitización de Texto:** Elimina los bloques `<think>` de las respuestas del modelo para una salida más limpia.

### Requisitos Previos

- **Ollama:** [Ollama](https://ollama.com/) instalado y configurado. Descarga el modelo DeepSeek: `ollama pull huihui_ai/deepseek-r1-abliterated:latest`.
- **jq:** `sudo apt install jq`
- **mpg123:** `sudo apt install mpg123`
- **Acceso a la API de Kokoro TTS:** El script usa la API gratuita (no se necesita clave API, pero ten en cuenta las limitaciones de uso).
- **Servidor Ollama Accesible:** El script necesita la URL de tu servidor Ollama. Si lo ejecutas localmente, puedes usar `http://localhost:11434/api/chat`. Si usas un servicio como Ngrok para exponerlo externamente, debes reemplazar la URL de ejemplo (`https://tu-direccion-ngrok-free.app/api/chat`) con la URL correcta.

### Configuración

Antes de ejecutar, revisa y ajusta estas variables en el script:

- **`MODEL`**: El modelo de Ollama a usar (por defecto: `huihui_ai/deepseek-r1-abliterated:latest`).
- **`MAX_CONTEXT`**: Tamaño del historial de conversación (por defecto: 6 turnos).
- **`SYSTEM_PROMPT`**: El prompt del sistema que guía el comportamiento del modelo (personalízalo a tu gusto).
- **`TTS_API_URL`**: URL de la API de Kokoro TTS (no deberías necesitar cambiarla).
- **`VOICE`**: Voz de Kokoro TTS (consulta la documentación para las opciones disponibles).
- **`OLLAMA_PARAMS`**: Parámetros de generación de texto para Ollama (los predeterminados están optimizados para velocidad).
- **`API_ENDPOINT`**: **La URL de tu servidor Ollama.** Cambia `https://tu-direccion-ngrok-free.app/api/chat` por la dirección correcta (e.g., `http://localhost:11434/api/chat` para local).

### Cómo Ejecutar

1. **Guarda el script:** Guarda el código como `deepseek_tts_chat.sh`.
2. **Hazlo ejecutable:** `chmod +x deepseek_tts_chat.sh`
3. **Ejecuta el script:** `./deepseek_tts_chat.sh`
4. **Interactúa:** Escribe tus preguntas después de "User 😎: ".
5. **Salir:** Escribe `salir` para terminar.

### Notas Importantes

- **Servidor Ollama:** Asegúrate de que esté en ejecución y accesible en la dirección configurada.
- **Conexión a Internet:** Necesaria para comunicarse con Ollama (si no es local) y la API de TTS.
- **Limitaciones de la API TTS:** La API gratuita de Kokoro TTS puede tener restricciones de uso.
- **Latencia:** La velocidad depende de tu conexión, la carga del servidor y la complejidad de la pregunta.

## 2. Ollama_Ngrok_Colab.ipynb: Ejecuta Ollama (y DeepSeek) en Google Colab con Acceso Remoto

Este cuaderno te permite instalar y ejecutar Ollama en Google Colab y hacerlo accesible desde cualquier lugar a través de un túnel seguro de Ngrok. Esto facilita el uso de modelos como DeepSeek desde fuera del entorno de Colab.

### Prerrequisitos

- **Cuenta de Ngrok y Token de Autenticación:** Regístrate en [Ngrok](https://ngrok.com/) y obtén tu token desde el panel de control.
- **Token de Ngrok en Google Colab Secrets:**
  1. En Colab, ve a "Secretos" (icono de llave en la barra lateral izquierda).
  2. Haz clic en "+ Secreto".
  3. Nombre: `NGROK_AUT_TOKEN`
  4. Valor: Pega tu token de Ngrok.
  5. Guarda.

### Instrucciones de Uso

1. **Abre el cuaderno en Google Colab.**
2. **Ejecuta las celdas en orden:** Cada celda está comentada para explicar su función.
   - **Instalación de Ollama.**
   - **Obtención del Token de Ngrok** (desde los secretos de Colab).
   - **Instalación de Paquetes:** `aiohttp` y `pyngrok`.
   - **Configuración de `LD_LIBRARY_PATH`** (para compatibilidad con drivers de NVIDIA).
   - **Función `run`** (para ejecutar comandos asíncronamente).
   - **Autenticación de Ngrok.**
   - **Ejecución de Ollama y Ngrok Concurrentemente:**
     - `ollama serve`: Inicia el servidor Ollama.
     - `ngrok http ...`: Crea el túnel seguro.
       - **URL Estática (Recomendado):** Usa la línea con `--domain` y reemplaza `reemplazacontudomainde.ngrok-free.app` por tu subdominio deseado (e.g., `mi-ollama.ngrok-free.app`). Los dominios gratuitos terminan en `.ngrok-free.app`.
       - **URL Aleatoria (Alternativa):** Si prefieres una URL aleatoria cada vez, usa la línea comentada sin `--domain`.
3. **Espera a que las celdas terminen.** La última celda imprimirá la URL de Ngrok (e.g., `url=https://tu-dominio.ngrok-free.app`).
4. **Accede a la API de Ollama:** Usa la URL de Ngrok para enviar peticiones a la API desde cualquier lugar. Ejemplo en Python:

```python
from ollama import Client

base_url = 'https://tu-dominio.ngrok-free.app'  # Reemplaza con tu URL
client = Client(host=base_url)

response = client.chat(model='llama2', messages=[{'role': 'user', 'content': '¿Capital de Francia?'}])
print(response['message']['content'])
```

### Consideraciones Importantes

- **Para Ejecutar en tu linux local:** export OLLAMA_HOST=<paste_url_here>.
- **URL de Ngrok:** Con dominio estático, la URL es la misma mientras tu cuenta esté activa. Sin dominio estático, cambia en cada ejecución.
- **Tiempo de Ejecución de Colab:** Colab tiene límites de tiempo. Si se cierra, debes volver a ejecutar las celdas.
- **Seguridad:** Estás exponiendo la API de Ollama a internet. Tenlo en cuenta si manejas datos sensibles.
- **Costos de Ngrok:** El plan gratuito es suficiente para pruebas. Para mayor ancho de banda o funciones avanzadas, revisa los planes de pago.
- **Modelos de Ollama:** Después de ejecutar el cuaderno, descarga los modelos que quieras usar (e.g., `!ollama pull llama2` en una nueva celda).

## ¡Disfruta experimentando con DeepSeek de forma local y remota!
