# libswift

A tool to interact with Swift toolchains

## Installation

1. [Install Theos](https://github.com/theos/theos/wiki/Installation)
2. Clone this repository somewhere on your computer

### Packaging

    make package [XCODE=/path/to/Xcode.app] [FINALPACKAGE=1]

The Swift stdlib will be copied from the path specified by the `XCODE` variable.

### Installing

    make install THEOS_DEVICE_IP=<ip>
