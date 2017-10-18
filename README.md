# libswift

A tool to interact with Swift toolchains

## Installation

1. [Install Theos](https://github.com/theos/theos/wiki/Installation)
2. Clone this repository somewhere on your computer

## Adding versions

Download a .pkg toolchain from [here](https://swift.org/download/), and run the following command:

    make </path/to/toolchain.pkg>

## Debs

### Packaging

    make package [V=<version>]

If you don't set `V`, the latest major version will be used (eg. 4).

### Installing

    make install THEOS_DEVICE_IP=<ip>

## TBDs

### Generating

    make tbd

This command will generate tbd files for all unpacked libswift versions, and store them in `tbds/<version>`.

### Installing

If Theos does not already contain the required Swift tbd files, you may run the following command to add them:

    cp -r tbds/VERSION $THEOS/vendor/lib/libswift/

Replace `VERSION` with the Swift version of which you wish to copy the tbd files.

## Template

This repository also comes with a template which you can use as a starting point to build a Swift app. To install it, run the following command:

    curl https://github.com/kabiroberai/theos-templates/raw/application_swift/iphone_application_swift.nic.tar -Lo $THEOS/templates/ios/theos/application_swift.nic.tar
