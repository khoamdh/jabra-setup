# Jabra 75 SE Setup on Ubuntu 24.04.2 LTS

This repository contains instructions and scripts to get the **Jabra 75 SE wireless headset** working on Ubuntu 24.04.2 LTS, including handling the proprietary USB dongle, setting it as the default audio device, and optional automation for plug/replug.

The Jabra Link 380 dongle is proprietary, so Linux cannot manage Bluetooth pairing with it. It works as a USB audio device only.

PipeWire is required for this setup; the same commands work with PulseAudio compatibility layer.


## 1. Plug in the Jabra Link 380 USB dongle

- Insert the dongle into a USB port.  
- Make sure the headset is **powered on**.  
- The dongle acts as a **USB audio device**, not a standard Bluetooth adapter.  

Check available ALSA/PipeWire cards:

```bash
pactl list cards short
```

Example output:

```arduino
49  alsa_card.usb-0b0e_Jabra_Link_380_50C275433642-00  alsa
65  alsa_card.pci-0000_00_1b.0.analog-stereo          # built-in speakers
```

## 2. (OPTIONAL) Identify PipeWire sinks and sources

Check available output (sink) and input (source) devices manually:

```bash
pactl list short sinks
pactl list short sources
```

Example output:

```bash
# Output devices (sinks)
56  alsa_output.usb-0b0e_Jabra_Link_380_50C275433642-00.analog-stereo
65  alsa_output.pci-0000_00_1b.0.analog-stereo

# Input devices (sources / microphones)
57  alsa_input.usb-0b0e_Jabra_Link_380_50C275433642-00.analog-mono
66  alsa_input.pci-0000_00_1b.0.analog-stereo
```
This is useful if you want to verify the device names or trouble shoot connection issues

## 3. (OPTIONAL) Set Jabra as default manually

If you prefer not to use reconnect_jabra.sh, you can manually set Jabra as the default:

```bash
# Set output to Jabra
pactl set-default-sink <Jabra-sink-name>

# Set input (microphone) to Jabra
pactl set-default-source <Jabra-source-name>
```

## 4. Use the reconnect script for plug/replug issues
Some USB dongles take time to register in PipeWire after being re-plugged. This script waits for the device and sets it as default automatically.

```bash
# Create the script file with the reconnect script provided
sudo nano /usr/local/bin/reconnect_jabra.sh

# Make sure the script is executable
chmod +x /usr/local/bin/reconnect_jabra.sh

# Run the script
/usr/local/bin/reconnect_jabra.sh
```

Example output:

```
Found Jabra sink: 81
Found Jabra source: 82
Jabra audio set as default sink/source successfully.
```

## 5. (OPTIONAL) Create udev rule to automatically run reconnect script upon dongle plug-in

Get Jabra's vendorID and Jabra Link 380's productID to be used in udev rule

```bash
lsusb
```

Example output:
```
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:8001 Intel Corp. Integrated Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 003: ID 058f:9540 Alcor Micro Corp. AU9540 Smartcard Reader
Bus 002 Device 006: ID 04f2:b449 Chicony Electronics Co., Ltd Integrated Camera
Bus 002 Device 007: ID 0a12:4010 Cambridge Silicon Radio, Ltd 
Bus 002 Device 008: ID 0b0e:24c8 GN Netcom Jabra Link 380
Bus 003 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
```

0b0e is vendorID and 24c8 productID

Create the udev rule file with the udev script provided
```bash
sudo nano /etc/udev/rules.d/99-jabra.rules
```

Save and exit, then reload udev rules:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

This ensures the Jabra dongle is automatically detected and set as the default audio device whenever it is plugged in.
