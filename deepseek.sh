#!/bin/bash

# Configuración
MODEL="huihui_ai/deepseek-r1-abliterated:latest" 
MAX_CONTEXT=6
SYSTEM_PROMPT="""

You are a helpful AI assistant. You are here to help me with my tasks and answer my questions. I appreciate your help.

"""


TTS_API_URL="https://api.kokorotts.com/v1/audio/speech"
VOICE="af_sky+af_bella"

# Parámetros optimizados para velocidad
OLLAMA_PARAMS='{
    "num_ctx": 2048, 
    "num_predict": -1,
    "temperature": 0.7,
    "repeat_penalty": 1.1,
    "top_k": 40,
    "top_p": 0.9
}'

# Verificar dependencias
command -v jq >/dev/null || { echo "Instala jq: sudo apt install jq"; exit 1; }
command -v mpg123 >/dev/null || { echo "Instala mpg123: sudo apt install mpg123"; exit 1; }

# Inicializar historial como array JSON válido
MESSAGES_JSON=$(jq -n --arg sp "$SYSTEM_PROMPT" '[{"role":"system","content":$sp}]')

# Función para sanitizar texto y eliminar <think> blocks
sanitize() {
    echo "$1" | jq -Rs 'sub("\n$";"")' | sed -e 's/^"//; s/"$//' | \
    sed -e '/<think>/,/<\/think>/d'  # Elimina bloques completos de think
}

# Bucle de conversación robusto
while true; do
    read -p "User 😎  : " QUESTION
    [[ "$QUESTION" == "salir" ]] && break

    # 1. Sanitizar y añadir pregunta al historial
    SANITIZED_QUESTION=$(sanitize "$QUESTION")
    MESSAGES_JSON=$(jq -c \
        '. += [{"role":"user","content":$content}]' \
        --arg content "$SANITIZED_QUESTION" <<< "$MESSAGES_JSON") || {
            echo "Error: Historial de mensajes inválido (1)"
            exit 1
        }

    # 2. Generar solicitud API con parámetros optimizados
    REQUEST_JSON=$(jq -n \
        --arg model "$MODEL" \
        --argjson messages "$MESSAGES_JSON" \
        --argjson params "$OLLAMA_PARAMS" \
        '{model:$model, messages:$messages, options:$params, stream:false}') || {
            echo "Error: JSON de solicitud inválido"
            exit 1
        }

# 3. Obtener respuesta del modelo
    API_ENDPOINT="https://tu-direccion-ngrok-free.app/api/chat"
    #echo "Enviando solicitud al endpoint: $API_ENDPOINT"
    RESPONSE=$(curl -s -L \
        --connect-timeout 30 \
        --max-time 60 \
        -H "Content-Type: application/json" \
        -d "$REQUEST_JSON" \
        "$API_ENDPOINT") || {
            echo "Error: Fallo al conectar con Ollama (Endpoint: $API_ENDPOINT)"
            echo "Verifica:"
            echo "1. Que el servidor Ollama está corriendo"
            echo "2. Que OLLAMA_HOST está configurado correctamente"
            echo "3. Tu conexión a internet"
            continue
        }


       # 4. Procesar respuesta y eliminar <think>
    RAW_ANSWER=$(echo "$RESPONSE" | jq -r '.message.content // empty')
    ANSWER=$(echo "$RAW_ANSWER" | sed -e '/<think>/,/<\/think>/d' | sed '/^$/d')

    if [[ -z "$ANSWER" ]]; then
        echo "Error: Respuesta vacía o inválida"
        echo "Respuesta cruda: $RAW_ANSWER"
        continue
    fi

    # 5. Actualizar y limitar historial
    SANITIZED_ANSWER=$(sanitize "$ANSWER")
    MESSAGES_JSON=$(jq -c \
        '. += [{"role":"assistant","content":$content}]' \
        --arg content "$SANITIZED_ANSWER" <<< "$MESSAGES_JSON") || {
            echo "Error: Historial de mensajes inválido (2)"
            exit 1
        }

    MESSAGES_JSON=$(jq -c \
        "[.[0]] + (.[1:] | .[-(($MAX_CONTEXT * 2) - 1):])" \
        <<< "$MESSAGES_JSON") || {
            echo "Error: Limpieza de contexto fallida"
            exit 1
        }

    # 6. Mostrar respuesta
    echo -e "\nDeep Seek ❤️ : $ANSWER"

    # 7. Generar y reproducir audio (sin cambios)
    OUTPUT_FILE="/tmp/tts_$(date +%s).mp3"
    curl -s -X POST "$TTS_API_URL" \
        -H "Content-Type: application/json" \
        -d "$(jq -n \
            --arg text "$ANSWER" \
            --arg voice "$VOICE" \
            '{model:"kokoro", input:$text, voice:$voice, response_format:"mp3"}')" \
        --output "$OUTPUT_FILE"

    if file "$OUTPUT_FILE" | grep -q "MPEG"; then
        mpg123 -q "$OUTPUT_FILE" 2>/dev/null
    else
        echo "Error: Audio inválido generado"
        echo "Debug: $(cat "$OUTPUT_FILE")"
    fi
    rm -f "$OUTPUT_FILE"
done
