#!/bin/bash

export PATH=$PATH:/usr/local/bin

# install dependencies
git clone git@github.com:TheHolyGrail/Maynard.git ../Maynard
git clone git@github.com:TheHolyGrail/Excalibur.git ../Excalibur

# build
xctool -project THGSupervisor.xcodeproj -scheme "THGSupervisor" -sdk iphonesimulator build test || exit $!
