# libswift

A tool to interact with Swift toolchains

## Installation

1. [Install Theos](https://github.com/theos/theos/wiki/Installation)
2. Clone this repository somewhere on your computer

## Adding versions

Ensure that you have the version of Xcode associated with your toolchain, and then run the following

    make [XCODE=/path/to/Xcode.app (default: /Applications/Xcode.app)]

### Packaging as a .deb

    make package [VERSION=<swift version>] [FINALPACKAGE=1]

### Installing

    make install THEOS_DEVICE_IP=<ip>
