
# Display all avaliable recipes
[private]
help:
    @just --list --unsorted

# Build a Debian package
deb:
    ant -e -lib /usr/share/java/jdeb.jar clean dist package

# Install the latest Debian package
install:
    #!/usr/bin/env bash
    latest_deb=$(ls -t bin/*.deb | head -n1)
    sudo apt reinstall ./"$latest_deb"
