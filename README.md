# Geeny_Racing_App

This is a racing application for the Geeny booth at Codemash.
It is maded with Processing 3.3.6 (JAVA based)

# Requirements

* Install Processing 3.3 from https://processing.org/download/
* Open Processing and install the ControlP5 library (i.e Sketch, Library, Add
  Library, Search for ControlP5)
* The libraries in the library folder must be copied to the libraries folder of
  Processing (../libraries).
* Open the root of this repository.
* Install other dependencies `sudo apt install wmctrl xbindkeys mplayer`

# Running

1. Generate an executable out of the Processing project.
2. Run `bash switcher.sh`
3. C-a switches to the animations
4. C-g switches to the game

# Troubleshooting:

In Ubuntu, you might need to install libstreamer 0.10.
In Ubuntu 17.10 the specific version of the library doesn't exist so the following
workaround might be necessary:

```
wget http://fr.archive.ubuntu.com/ubuntu/pool/main/g/gst-plugins-base0.10/libgstreamer-plugins-base0.10-0_0.10.36-1_amd64.deb
wget http://fr.archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10/libgstreamer0.10-0_0.10.36-1.5ubuntu1_amd64.deb
sudo dpkg -i libgstreamer*.deb
```
# Setup.

Setup the arduino code from
https://github.com/StefanHermannBerlin/Codemash_Racing_Arduino
and make sure the port on line 111 corresponds to the right port.

Controls
----------------------
- Use Enter and Backspace to navigate
- Use the Keys 1 and 2 to simulate round tracking sensors
- Use mouse Y to simulate throttle, mouse X to simulate heart rates
