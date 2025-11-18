# Jabra 75 SE Setup on Ubuntu/Linux

This repository contains instructions and scripts to setup Jabra 75 SE with Ubuntu/Linux.

## Steps

1. Plug in the Jabra Link 380 USB dongle that came with the headset.

2. Identify PipeWire sink and source:

    ```bash
    pactl list short sinks
    pactl list short sources
    ```

3. Set Jabra as default:

    ```bash
    pactl set-default-sink <sink_name>
    pactl set-default-source <source_name>
    ```

4. Use the reconnect script for plug/replug issues:

    ```bash
    ./scripts/reconnect_jabra.sh
    ```
