#!/bin/bash

# Diretórios de entrada, saída e arquivo antigo
input_dir="./"
output_dir="./Remux_Videos"
old_videos_dir="./Old_Videos"

# Verifica se o diretório de entrada existe
if [ ! -d "$input_dir" ]; then
    echo "Diretório de entrada não encontrado: $input_dir"
    exit 1
fi

# Cria o diretório de saída e o diretório de arquivos antigos, se não existirem
mkdir -p "$output_dir"
mkdir -p "$old_videos_dir"

# Verifica se há arquivos MKV no diretório de entrada
shopt -s nullglob
mkv_files=("$input_dir"/*.mkv)
shopt -u nullglob

if [ ${#mkv_files[@]} -eq 0 ]; then
    echo "Nenhum arquivo MKV encontrado no diretório: $input_dir"
    exit 1
fi

# Pergunta ao usuário qual conversão deseja
echo "Qual conversão você deseja realizar?"
echo "1: MP4 (AV1 + PCM)"
echo "2: MOV (DNxHR HQ + ALAC)"
read -p "Digite o número da conversão desejada (1 ou 2): " conversion_choice

# Loop através dos arquivos MKV no diretório
for input_file in "${mkv_files[@]}"; do
    filename=$(basename "$input_file" .mkv)

    if [ "$conversion_choice" == "1" ]; then
        # Conversão para MP4 (AV1) com áudio PCM
        output_file="$output_dir/${filename}.mp4"
        ffmpeg -i "$input_file" -c:v libaom-av1 -b:v 0 -cpu-used 4 -threads 8 -c:a pcm_s16le "$output_file"
    elif [ "$conversion_choice" == "2" ]; then
        # Conversão para MOV (DNxHR HQ) com áudio ALAC
        output_file="$output_dir/${filename}.mov"
        ffmpeg -i "$input_file" -c:v dnxhd -profile:v dnxhr_hq -c:a alac "$output_file"
    else
        echo "Escolha inválida. Por favor, execute o script novamente e escolha 1 ou 2."
        exit 1
    fi

    if [ $? -eq 0 ]; then
        echo "Convertido: $input_file -> $output_file"
        mv "$input_file" "$old_videos_dir/"
        echo "Movido: $input_file -> $old_videos_dir/"
    else
        echo "Falha na conversão: $input_file"
    fi
done

echo "Conversão completa."
