<?xml version="1.0" encoding="utf-8"?>

    <!-- Copyright (C) 2013 Swiss Library for the Blind, Visually Impaired and Print Disabled -->

    <!-- This file is part of dtbook2sbsform. -->

    <!-- dtbook2sbsform is free software: you can redistribute it -->
    <!-- and/or modify it under the terms of the GNU Lesser General Public -->
    <!-- License as published by the Free Software Foundation, either -->
    <!-- version 3 of the License, or (at your option) any later version. -->

    <!-- This program is distributed in the hope that it will be useful, -->
    <!-- but WITHOUT ANY WARRANTY; without even the implied warranty of -->
    <!-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU -->
    <!-- Lesser General Public License for more details. -->

    <!-- You should have received a copy of the GNU Lesser General Public -->
    <!-- License along with this program. If not, see -->
    <!-- <http://www.gnu.org/licenses/>. -->

<xsl:stylesheet version="2.0"
    xmlns="http://www.daisy.org/z3986/2005/dtbook/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
    xmlns:brl="http://www.daisy.org/z3986/2009/braille/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs brl">

    <xsl:param name="announcement" as="xs:string" select="'&lt;='"/>
    <xsl:param name="deannouncement" as="xs:string" select="'&lt;='"/>

    <xsl:output method="xml" encoding="utf-8" indent="no"/>

    <xsl:template match="text()[normalize-space(.)!='' and ancestor::dtb:prodnote]">
      <xsl:if test="not(preceding::text()[normalize-space(.)!=''][1][ancestor::dtb:prodnote])">
	<brl:literal><xsl:value-of select="$announcement"/></brl:literal>
      </xsl:if>
      <xsl:sequence select="."/>
      <xsl:if test="not(following::text()[normalize-space(.)!=''][1][ancestor::dtb:prodnote])">
	<brl:literal><xsl:value-of select="$deannouncement"/></brl:literal>
      </xsl:if>
    </xsl:template>

    <xsl:template match="dtb:prodnote">
      <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*">
      <xsl:copy>
	<xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|comment()|processing-instruction()">
      <xsl:sequence select="."/>
    </xsl:template>

</xsl:stylesheet>
