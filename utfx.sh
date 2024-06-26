#!/bin/sh

# Copyright (C) 2010,2017 Swiss Library for the Blind, Visually Impaired and Print Disabled
#
# This file is part of dtbook2sbsform.
#
# dtbook2sbsform is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program. If not, see
# <http://www.gnu.org/licenses/>.
#
# TODO: how to repackage saxon9he with RSA, etc. in the single jar
# TODO: LouisExtensionTransformerFactoryImpl not found when using 
#       the -jar call. See:
# http://stackoverflow.com/questions/2018257/how-to-combine-library-with-my-jar
# Quoting above:
#   Executable JARs are launched with the "-jar" argument to the java
#   executable, and both the java "-cp" flag and the CLASSPATH environment
#   variable are ignored.

if [ "$1" = "-?" ] ; then
    echo
    echo Usage: `basename $0` "[ -Dutfx.test.dir=test_xsl | -Dutfx.test.file=test_xsl/dtbook2sbsform_test.xml ]"
    echo
    exit 1
fi

LOUIS_TRANSFORM_FACTORY=-Djavax.xml.transform.TransformerFactory=org.liblouis.transformerfactory.LouisExtensionTransformerFactoryImpl

UTFX_TEST=${@:-"-Dutfx.test.dir=test_xsl"}

LIB=lib
# . required in class path, so utfx.properties is found!
UTFX=.:$LIB/utfxFat.jar
CP=$LIB/saxon9he.jar:$LIB/louis-1.0.jar:$LIB/jna.jar:$LIB/liblouissaxonx.jar:$UTFX

java $LOUIS_TRANSFORM_FACTORY $UTFX_TEST \
    -cp $CP utfx.runner.TestRunner utfx.framework.XSLTRegressionTest
