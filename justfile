
# Display all avaliable recipes
[private]
help:
    @just --list --unsorted

# Build a Debian package
deb:
    mvn package

# Install the latest Debian package
install:
    #!/usr/bin/env bash
    latest_deb=$(ls -t target/*.deb | head -n1)
    sudo apt reinstall ./"$latest_deb"
