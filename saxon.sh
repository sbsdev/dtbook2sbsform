#!/bin/sh

# Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print Disabled
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

# Set classpath
DIR=`dirname $0`
CP=$DIR/lib/saxon9he.jar:$DIR/lib/louis-1.0.jar:$DIR/lib/jna.jar:$DIR/lib/liblouissaxonx.jar

java -cp $CP org.liblouis.LouisTransform "$@"
