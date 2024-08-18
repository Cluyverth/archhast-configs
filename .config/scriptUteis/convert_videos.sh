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

# Loop através dos arquivos MKV no diretório
for input_file in "${mkv_files[@]}"; do
    filename=$(basename "$input_file" .mkv)
    output_file="$output_dir/${filename}.mov"

    # Executa o FFmpeg para converter o vídeo
    ffmpeg -i "$input_file" -c:v dnxhd -profile:v dnxhr_hq -c:a alac "$output_file"

    if [ $? -eq 0 ]; then
        echo "Convertido: $input_file -> $output_file"
        # Move o arquivo MKV original para o diretório Old_Videos
        mv "$input_file" "$old_videos_dir/"
        echo "Movido: $input_file -> $old_videos_dir/"
    else
        echo "Falha na conversão: $input_file"
    fi
done

echo "Conversão completa."