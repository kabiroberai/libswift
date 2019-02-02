# libswift

A tool to interact with Swift toolchains

## Installation

1. [Install Theos](https://github.com/theos/theos/wiki/Installation)
2. Clone this repository somewhere on your computer

## Adding versions

Download a .pkg toolchain from [here](https://swift.org/download/), and run the following command:

    make </path/to/toolchain.pkg>

### Packaging as a .deb

    make package [VERSION=<swift version>] [FINALPACKAGE=1]

### Installing

    make install THEOS_DEVICE_IP=<ip>
