# SVXBRIDGE (from SP2ONG)

```bash
cd /opt
git clone https://github.com/spotnik-ham/opt_svxbridge.git svxbridge
```

Update

```bash
cd /opt/svxbridge
git pull
```

## Installation and configuration SVXBRIDGE on Debian 9 STRETCH

The svxbridge.py is based on USRPAudio.py and was rewritten by SP2ONG to show the possibility
of how to create a DMR <> Analog SVXLink gate using the USRP protocol.

### Configure locales

```bash
dpkg-reconfigure locales
```

Set correctly your locales.

### Install Midnight Commander (useful tool)

```bash
apt install mc
```

### Install necessary packages

```bash
apt-get install build-essential git cmake libsigc++-2.0-dev libasound2-dev libpopt-dev libgcrypt11-dev tk-dev libgsm1-dev libspeex-dev libcurl4-openssl-dev libjsoncpp-dev groff curl
```

### Install DVSwitch packages

#### Install necessary packages for DVSwitch

```bash
apt-get install git python-pip python3-pip python-dev python3-dev libffi-dev libssl-dev
```

Please don't use 44.xxx IP addresses for network access to download DVSwitch packages.
Because dvswitch.org uses IP address 44.103.34.4 which is not available via Amprnet, only via Internet.

```bash
cd /opt/src
wget http://dvswitch.org/install-dvswitch-repo
chmod +x install-dvswitch-repo
./install-dvswitch-repo
apt-get update
apt-get install analog-bridge
apt-get install md380-emu
apt-get install mmdvm-bridge
```

Next configure Analog_Bridge.ini and MMDVM_Bridge.ini.
Run DVSwitch packages:

```bash
systemctl start md380-emu
systemctl start analog_bridge
systemctl start mmdvm_bridge
```

We use md380-emu AMBE software emulator vocoder with Analog_Bridge to convert audio from analog to DMR and opposite.

I recommend checking the operation of MB / AB / md380 using the DVSwitch Mobile Android application.

### Add ALSA loop to load modules in /etc/modules

add line

```txt
snd_aloop
```

and create file /etc/modprobe.d/alsa.conf which will force snd_aloop to use index 0 for the number cards

```txt
options snd-aloop index=0
```

### Install pyserial and pyaudio for svxbridge.py

```bash
pip install pyserial thread
apt-get install python3-pyaudio python3-thread
```

Copy /opt/svxbridge/utils/asound.conf to /etc/asound.conf.
The file contains the necessary configuration to make the ALSA loop sound card work.

Run /opt/svxbridge/utils/index-audio.py to find the index number for plug_Loopback_1_2 and put this number in the txAudioStream() function input_index_device=.
And find the number for the rxAudioStream() function output_index_device= for Loopback,0 at the start of svxbridge.py.

```txt
(0, u'Loopback: PCM (hw:0,0)', 32L)
(1, u'Loopback: PCM (hw:0,1)', 32L)
(2, u'sysdefault', 128L)
(3, u'front', 0L)
(4, u'surround21', 32L)
(5, u'surround40', 0L)
(6, u'surround41', 0L)
(7, u'surround50', 0L)
(8, u'surround51', 0L)
(9, u'surround71', 0L)
(10, u'plug_Loopback_1_1', 128L)
(11, u'plug_Loopback_1_2', 0L)
(12, u'default', 128L)
```

Next copy files from /opt/svxbridge/utils/svxlink.num and restart.num to /etc/spotnik.

Enable and start svxlink
```bash
/etc/spotnik/restart.num
```

Tune audio levels in /opt/Analog_Bridge/Analog_Bridge.ini

The audio from DMR to SVXlink

```txt
usrpAudio = AUDIO_USE_AGC
usrpGain = -16
```

Try adjusting from -10 to -20.

Instead of the above you can use the following

```txt
usrpAudio = AUDIO_UNITY
usrpGain = 3.8
```

Try adjusting from 2.0 to 4.0.

The audio from SVXLink to DMR

```txt
tlvAudio = AUDIO_UNITY
tlvGain = 0.3
```

Try to adjust from 0.1 to 1.0, but before this you must set the correct audio level from svxlink (mic gain in alsamixer). I recommend using the Echolink PC version application and connect to svxlink via Echolink, then observe the audio level meter in the Echolink application and adjust mic gain in alsamixer so the audio meter occasionally appears in yellow.

After changes you must restart Analog_Bridge:

```bash
systemctl restart analog_bridge
```

Known issue: audio delay about 2 to 3 seconds between analog / DMR / C4FM.
svxbridge doesn't start as expected if someone speaks on analog or DMR / C4FM.

```txt
copy /utils/C4FM to /usr/share/svxlink/sounds/fr_FR/
copy /utils/Logic.tcl to /usr/share/svxlink/events.d/local/
```

Waldek SP2ONG 2020
Jean-Philippe F5NLG 23/04/2020 for spotnik distrib.
