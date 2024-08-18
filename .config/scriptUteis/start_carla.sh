#!/bin/bash

# Script para criar os dispositivos virtuais
pactl load-module module-null-sink sink_name=VirtualSink sink_properties=device.description="Virtual_Sink"
pactl load-module module-remap-source master=VirtualSink.monitor source_name=DigitalMic source_properties=device.description="Digital_Mic"
pactl load-module module-null-sink sink_name=DigitalBox sink_properties=device.description="Digital_Box"

# Script para iniciar o Carla com a configuração do Patchbay
pw-jack carla ~/.config/carlaConfig/patchbay_file.carxp &
