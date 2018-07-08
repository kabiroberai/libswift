# libswift

A tool to interact with Swift toolchains

## Installation

1. [Install Theos](https://github.com/theos/theos/wiki/Installation)
2. Clone this repository somewhere on your computer

## Adding versions

Download a .pkg toolchain from [here](https://swift.org/download/), and run the following command:

    make </path/to/toolchain.pkg>

### Packaging as a .deb

    make package

### Installing

    make install THEOS_DEVICE_IP=<ip>

## Template

This repository also comes with a template which you can use as a starting point to build a Swift app. To install it, run the following command:

    curl https://github.com/kabiroberai/theos-templates/raw/application_swift/iphone_application_swift.nic.tar -Lo $THEOS/templates/ios/theos/application_swift.nic.tar
