#!/bin/bash

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

# exit if any of the processes fail
set -eo pipefail

if [ $# -lt 1 ] ; then
	PRG=`basename $0`
	echo "Usage: $PRG -s:dtbook.xml PARAMS"
	echo "       one dtbook xml source file expected."
	exit 1
fi

DIR=`dirname $0`
SRCFILE=$1
shift

$DIR/saxon.sh \
    -xsl:$DIR/xsl/handle-downgrading.xsl $SRCFILE "$@"| \
$DIR/saxon.sh \
    -xsl:$DIR/xsl/handle-prodnote.xsl -s:- "$@" | \
$DIR/saxon.sh \
    -xsl:$DIR/xsl/dtbook2sbsform.xsl -s:- "$@" | \
$DIR/linebreak.sh
