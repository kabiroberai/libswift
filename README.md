# libswift

## Installation

1. [Install Theos](https://github.com/theos/theos/wiki/Installation)
2. Clone this repository somewhere on your computer

## Adding versions

Download a .pkg toolchain from [here](https://swift.org/download/), and run the following command:

    make </path/to/toolchain.pkg>

## Packaging the deb

    make package [V=<version>]

If you don't set V, the latest major version will be used (eg. 3).

## Installing the deb

    make install THEOS_DEVICE_IP=<ip>
