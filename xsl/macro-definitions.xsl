<?xml version="1.0" encoding="utf-8"?>

	<!-- Copyright (C) 2010 Swiss Library for the Blind, Visually Impaired and Print Disabled -->
	
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
	
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/" xmlns:louis="http://liblouis.org/liblouis"
  xmlns:brl="http://www.daisy.org/z3986/2009/braille/" xmlns:my="http://my-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:data="http://sbsform.ch/data"
  exclude-result-prefixes="dtb louis data my" extension-element-prefixes="my">
	
  <xsl:template name="sbsform-macro-definitions">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="vform_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'v-form'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&#10;x ======================= ANFANG SBSFORM.MAK =========================&#10;</xsl:text>
    <xsl:text>x Bei Aenderungen den ganzen Block in separate Makrodatei auslagern.&#10;&#10;</xsl:text>

    <xsl:text>xxxxxxxxxxxxxxxxxxxxxxxxxx book, body, rear xxxxxxxxxxxxxxxxxxxxxxxxxx&#10;&#10;</xsl:text>

    <xsl:text>y b BOOKb ; Anfang des Buches: Globale Einstellungen&#10;</xsl:text>
    <xsl:text>z&#10;</xsl:text>
    <xsl:text>i b=</xsl:text>
    <xsl:value-of select="$cells_per_line"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>i s=</xsl:text>
    <xsl:value-of select="$lines_per_page"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="$footer_level &gt; 0">
      <xsl:text>I ~=j&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="$show_original_page_numbers = true()">
          <xsl:text>i k=0&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>i k=-1&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>y e BOOKb&#10;</xsl:text>

    <xsl:text>y b BOOKe ; Ende des Buches, evtl. Inhaltsverzeichnis&#10;</xsl:text>
    <xsl:text>y EndBook&#10;</xsl:text>
    <xsl:if test="$toc_level &gt; 0">
      <xsl:text>y Inhaltsv&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y e BOOKe&#10;</xsl:text>

    <xsl:text>y b BODYb ; Begin Bodymatter&#10;</xsl:text>
    <xsl:text>R=X&#10;</xsl:text>
    <xsl:text>Y&#10;</xsl:text>
    <xsl:if test="$show_original_page_numbers = true()">
      <xsl:text>RX&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y e BODYb&#10;</xsl:text>
    <xsl:text>y b BODYe ; Ende Bodymatter&#10;</xsl:text>
    <xsl:text>y e BODYe&#10;</xsl:text>

    <xsl:if test="//dtb:rearmatter">
      <xsl:text>y b REARb ; Begin Rearmatter&#10;</xsl:text>
      <xsl:text>z&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 0">
        <xsl:text>H`lm1&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e REARb&#10;</xsl:text>
      <xsl:text>y b REARe ; End Rearmatter&#10;</xsl:text>
      <xsl:text>y e REARe&#10;</xsl:text>
    </xsl:if>

    
    <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxx Frontmatter Levels und Headings xxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]/dtb:h1">
	<xsl:text>y b H1_FRONT&#10;</xsl:text>
	<xsl:text>n6&#10;</xsl:text>
	<xsl:text>L&#10;</xsl:text>
	<xsl:text>i f=1 l=1&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>u&#10;</xsl:text>
	<xsl:text>i f=3 l=1&#10;</xsl:text>
	<xsl:text>y e H1_FRONT&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]//dtb:h2">
	<xsl:text>y b H2_FRONT&#10;</xsl:text>
	<xsl:text>n6&#10;</xsl:text>
	<xsl:text>L&#10;</xsl:text>
	<xsl:text>i f=1 l=1&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>u&#10;</xsl:text>
	<xsl:text>i f=3 l=1&#10;</xsl:text>
	<xsl:text>y e H2_FRONT&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="//dtb:frontmatter//dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]//dtb:h3">
	<xsl:text>y b H3_FRONT&#10;</xsl:text>
	<xsl:text>n5&#10;</xsl:text>
	<xsl:text>L&#10;</xsl:text>
	<xsl:text>i f=1 l=1&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>u,&#10;</xsl:text>
	<xsl:text>i f=3 l=1&#10;</xsl:text>
	<xsl:text>y e H3_FRONT&#10;</xsl:text>
      </xsl:if>
    </xsl:if>

    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxx Levels und Headings xxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
    <xsl:text>y b LEVEL1b&#10;</xsl:text>
    <xsl:text>p&#10;</xsl:text>
    <xsl:text>Y&#10;</xsl:text>
    <xsl:text>y e LEVEL1b&#10;</xsl:text>
    <xsl:text>y b LEVEL1e&#10;</xsl:text>
    <xsl:text>y e LEVEL1e&#10;</xsl:text>
    <xsl:text>y b H1&#10;</xsl:text>
    <xsl:text>L&#10;</xsl:text>
    <xsl:text>i f=3 l=1&#10;</xsl:text>
    <xsl:text>i A=4 R=4&#10;</xsl:text>
    <xsl:text>t&#10;</xsl:text>
    <xsl:text>Y&#10;</xsl:text>
    <xsl:text>u-&#10;</xsl:text>
    <xsl:text>i A=0 R=0&#10;</xsl:text>
    <xsl:if test="$toc_level &gt; 0">
      <xsl:text>H`B+&#10;</xsl:text>
      <xsl:text>H`i F=1 L=3&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>H`B-&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$footer_level &gt; 0">
      <xsl:text>~~&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
    </xsl:if>
    <xsl:text>lm1&#10;</xsl:text>
    <xsl:text>y e H1&#10;</xsl:text>

    <xsl:if test="//dtb:level2">
      <xsl:text>&#10;y b LEVEL2b&#10;</xsl:text>
      <xsl:text>lm2&#10;</xsl:text>
      <xsl:text>n10&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL2b&#10;</xsl:text>
      <xsl:text>y b LEVEL2e&#10;</xsl:text>
      <xsl:text>y e LEVEL2e&#10;</xsl:text>
      <xsl:text>y b H2&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>u&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 1">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=3 L=3&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 1">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H2&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level3">
      <xsl:text>
y b LEVEL3b
lm1
n6
Y
y e LEVEL3b
y b LEVEL3e
y e LEVEL3e
y b H3
lm1
i f=3 l=1
w
Y
u,
</xsl:text>
      <xsl:if test="$toc_level &gt; 2">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=5 L=3&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 2">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H3&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level4">
      <xsl:text>&#10;y b LEVEL4b&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL4b&#10;</xsl:text>
      <xsl:text>y b LEVEL4e&#10;</xsl:text>
      <xsl:text>y e LEVEL4e&#10;</xsl:text>
      <xsl:text>y b H4&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 3">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=7 L=3&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 3">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H4&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level5">
      <xsl:text>&#10;y b LEVEL5b&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL5b&#10;</xsl:text>
      <xsl:text>y b LEVEL5e&#10;</xsl:text>
      <xsl:text>y e LEVEL5e&#10;</xsl:text>
      <xsl:text>y b H5&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 4">
        <xsl:text>H`B+&#10;</xsl:text>
        <xsl:text>H`i F=9 L=3&#10;</xsl:text>
        <xsl:text>Y&#10;</xsl:text>
        <xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 4">
        <xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H5&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:level6">
      <xsl:text>&#10;y b LEVEL6b&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:text>y e LEVEL6b&#10;</xsl:text>
      <xsl:text>y b LEVEL6e&#10;</xsl:text>
      <xsl:text>y e LEVEL6e&#10;</xsl:text>
      <xsl:text>y b H6&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>Y&#10;</xsl:text>
      <xsl:if test="$toc_level &gt; 5">
	<xsl:text>H`B+&#10;</xsl:text>
	<xsl:text>H`i F=11 L=3&#10;</xsl:text>
	<xsl:text>Y&#10;</xsl:text>
	<xsl:text>H`B-&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="$footer_level &gt; 5">
	<xsl:text>Y&#10;</xsl:text>
      </xsl:if>
      <xsl:text>y e H6&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:*[@brl:class]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxx Makros mit Class Attributen xxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <!-- Elements that only have a start macro -->
      <xsl:for-each-group select="(//dtb:author|//dtb:byline|//dtb:li|//dtb:p|//dtb:h1|//dtb:h2|//dtb:h3|//dtb:h4|//dtb:h5|//dtb:h6)[@brl:class]" group-by="local-name()">
	<xsl:variable name="element-name" select="current-grouping-key()"/>
	<xsl:variable name="makro-name" select="upper-case($element-name)"/>
	<xsl:for-each select="distinct-values(//dtb:*[local-name() = $element-name]/@brl:class)">
	  <xsl:text>&#10;y b </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;</xsl:text>
	  <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
	  <xsl:text>y e </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>_</xsl:text>
	  <xsl:value-of select="."/><xsl:text>&#10;&#10;</xsl:text>
	</xsl:for-each>
      </xsl:for-each-group>
      <!-- Elements that have both a start and an end macro -->
      <xsl:for-each-group
          select="(//dtb:blockquote|
                   //dtb:epigraph|
                   //dtb:list|
                   //dtb:poem|
                   //dtb:linegroup|
                   //dtb:line|
                   //dtb:div)[@brl:class]"
          group-by="if (self::dtb:list) then concat('list@type=', @type) else local-name()">
	<xsl:variable name="element-name" select="local-name()"/>
        <xsl:variable name="makro-name">
	  <xsl:choose>
	    <xsl:when test="$element-name='blockquote'">BLQUO</xsl:when>
	    <xsl:when test="$element-name='epigraph'">EPIGR</xsl:when>
            <xsl:when test="$element-name='list' and @type='pl'">PLIST</xsl:when>
            <xsl:when test="$element-name='list' and @type='ul'">ULIST</xsl:when>
            <xsl:when test="$element-name='list' and @type='ol'">OLIST</xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="upper-case($element-name)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
        <xsl:for-each-group select="current-group()" group-by="string(@brl:class)">
          <xsl:variable name="class-name" select="current-grouping-key()"/>
          <xsl:text>&#10;y b </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>b_</xsl:text>
	  <xsl:value-of select="$class-name"/><xsl:text>&#10;</xsl:text>
	  <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
	  <xsl:text>y e </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>b_</xsl:text>
	  <xsl:value-of select="$class-name"/><xsl:text>&#10;&#10;</xsl:text>
	  <xsl:text>&#10;y b </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>e_</xsl:text>
	  <xsl:value-of select="$class-name"/><xsl:text>&#10;</xsl:text>
	  <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
	  <xsl:text>y e </xsl:text>
	  <xsl:value-of select="$makro-name"/><xsl:text>e_</xsl:text>
	  <xsl:value-of select="$class-name"/><xsl:text>&#10;&#10;</xsl:text>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:if>

    <xsl:if test="//dtb:note and $footnote_placement != 'standard'">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxx Notes xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>y b Notes&#10;</xsl:text>
      <xsl:text>X TODO: Fix this macro&#10;</xsl:text>
      <xsl:text>y e Notes&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxx Absatz, Leerzeile, Separator xxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>y b P&#10;</xsl:text>
      <xsl:text>a&#10;</xsl:text>
      <xsl:text>y e P&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'precedingemptyline')]">
      <xsl:text>y b BLANK&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e BLANK&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'precedingseparator')]">
      <xsl:text>y b SEPARATOR&#10;</xsl:text>
      <xsl:text>B+&#10;</xsl:text>
      <xsl:text>L&#10;</xsl:text>
      <xsl:text>t*?*?*?&#10;</xsl:text>
      <xsl:text>B-&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e SEPARATOR&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'noindent')]">
      <xsl:text>y b P_noi&#10;</xsl:text>
      <xsl:text>w&#10;</xsl:text>
      <xsl:text>y e P_noi&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:author[not(@brl:class)]">
      <xsl:text>y b AUTHOR&#10;</xsl:text>
      <xsl:text>r&#10;</xsl:text>
      <xsl:text>y e AUTHOR&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:byline[not(@brl:class)]">
      <xsl:text>y b BYLINE&#10;</xsl:text>
      <xsl:text>r&#10;</xsl:text>
      <xsl:text>y e BYLINE&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:blockquote[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxx Blockquote xxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
      <xsl:text>y b BLQUOb&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>i A=2&#10;</xsl:text>
      <xsl:text>y e BLQUOb&#10;</xsl:text>
      <xsl:text>y b BLQUOe&#10;</xsl:text>
      <xsl:text>i A=0&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e BLQUOe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:epigraph[not(@brl:class)]">
      <xsl:text>
xxxxxxxxxxxxxxxxxxxxxxxxxxxxx Epigraph xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
y b EPIGRb
lm1
n2
i A=4
y e EPIGRb
y b EPIGRe
i A=0
lm1
n2
y e EPIGRe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:poem[not(@brl:class)]|//dtb:line[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Poem xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;&#10;</xsl:text>
      <xsl:text>y b POEMb&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=1 l=3&#10;</xsl:text>
      <xsl:text>n4&#10;</xsl:text>
      <xsl:text>i A=2&#10;</xsl:text>
      <xsl:text>y e POEMb&#10;</xsl:text>
      <xsl:text>y b POEMe&#10;</xsl:text>
      <xsl:text>i A=0&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e POEMe&#10;&#10;</xsl:text>
      
      <xsl:text>y b LINEb&#10;</xsl:text>
      <xsl:text>a&#10;</xsl:text>
      <xsl:text>B+&#10;</xsl:text>
      <xsl:text>y e LINEb&#10;</xsl:text>
      <xsl:text>y b LINEe&#10;</xsl:text>
      <xsl:text>B-&#10;</xsl:text>
      <xsl:text>y e LINEe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:linegroup[not(@brl:class)]">
      <xsl:text>&#10;y b LINEGRb&#10;</xsl:text>
      <xsl:text>lm1&#10;</xsl:text>
      <xsl:text>i f=1 l=3&#10;</xsl:text>
      <xsl:text>n2&#10;</xsl:text>
      <xsl:text>y e LINEGRb&#10;</xsl:text>
      <xsl:text>y b LINEGRe&#10;</xsl:text>
      <xsl:text>i f=3 l=1&#10;</xsl:text>
      <xsl:text>y e LINEGRe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class)]|//dtb:li[not(@brl:class)]">
      <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Listen xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;&#10;</xsl:text>
      
      <xsl:text>y b LI&#10;</xsl:text>
      <xsl:text>a&#10;</xsl:text>
      <xsl:text>y e LI&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class) and @type='pl']|//dtb:li[not(@brl:class)]">
      <xsl:text>y b PLISTb ; 'pl' Liste&#10;</xsl:text>
      <xsl:text>?nl:nl+1&#10;</xsl:text>
      <xsl:text>?nl=1&#10;</xsl:text>
      <xsl:text>+lm1&#10;</xsl:text>
      <xsl:text>+i f=1 l=3&#10;</xsl:text>
      <xsl:text>?nl=2&#10;</xsl:text>
      <xsl:text>+i f=3 l=5&#10;</xsl:text>
      <xsl:text>?nl=3&#10;</xsl:text>
      <xsl:text>+i f=5 l=7&#10;</xsl:text>
      <xsl:text>y e PLISTb&#10;</xsl:text>
      <xsl:text>y b PLISTe&#10;</xsl:text>
      <xsl:text>?nl:nl-1&#10;</xsl:text>
      <xsl:text>?nl=2&#10;</xsl:text>
      <xsl:text>+i f=3 l=5&#10;</xsl:text>
      <xsl:text>?nl=1&#10;</xsl:text>
      <xsl:text>+i f=1 l=3&#10;</xsl:text>
      <xsl:text>?nl=0&#10;</xsl:text>
      <xsl:text>+lm1&#10;</xsl:text>
      <xsl:text>+n2&#10;</xsl:text>
      <xsl:text>+i f=3 l=1&#10;</xsl:text>
      <xsl:text>y e PLISTe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class) and @type='ul']|//dtb:li[not(@brl:class)]">
      <xsl:text>y b ULISTb ; 'ul' Liste&#10;</xsl:text>
      <xsl:text>?nl:nl+1&#10;</xsl:text>
      <xsl:text>?nl=1&#10;</xsl:text>
      <xsl:text>+lm1&#10;</xsl:text>
      <xsl:text>+i f=1 l=3&#10;</xsl:text>
      <xsl:text>?nl=2&#10;</xsl:text>
      <xsl:text>+i f=3 l=5&#10;</xsl:text>
      <xsl:text>?nl=3&#10;</xsl:text>
      <xsl:text>+i f=5 l=7&#10;</xsl:text>
      <xsl:text>y e ULISTb&#10;</xsl:text>
      <xsl:text>y b ULISTe&#10;</xsl:text>
      <xsl:text>?nl:nl-1&#10;</xsl:text>
      <xsl:text>?nl=2&#10;</xsl:text>
      <xsl:text>+i f=3 l=5&#10;</xsl:text>
      <xsl:text>?nl=1&#10;</xsl:text>
      <xsl:text>+i f=1 l=3&#10;</xsl:text>
      <xsl:text>?nl=0&#10;</xsl:text>
      <xsl:text>+lm1&#10;</xsl:text>
      <xsl:text>+n2&#10;</xsl:text>
      <xsl:text>+i f=3 l=1&#10;</xsl:text>
      <xsl:text>y e ULISTe&#10;</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class) and @type='ol']|//dtb:li[not(@brl:class)]">
      <xsl:text>y b OLISTb ; 'ol' Liste&#10;</xsl:text>
      <xsl:text>?nl:nl+1&#10;</xsl:text>
      <xsl:text>?nl=1&#10;</xsl:text>
      <xsl:text>+lm1&#10;</xsl:text>
      <xsl:text>+i f=1 l=3&#10;</xsl:text>
      <xsl:text>?nl=2&#10;</xsl:text>
      <xsl:text>+i f=3 l=5&#10;</xsl:text>
      <xsl:text>?nl=3&#10;</xsl:text>
      <xsl:text>+i f=5 l=7&#10;</xsl:text>
      <xsl:text>y e OLISTb&#10;</xsl:text>
      <xsl:text>y b OLISTe&#10;</xsl:text>
      <xsl:text>?nl:nl-1&#10;</xsl:text>
      <xsl:text>?nl=2&#10;</xsl:text>
      <xsl:text>+i f=3 l=5&#10;</xsl:text>
      <xsl:text>?nl=1&#10;</xsl:text>
      <xsl:text>+i f=1 l=3&#10;</xsl:text>
      <xsl:text>?nl=0&#10;</xsl:text>
      <xsl:text>+lm1&#10;</xsl:text>
      <xsl:text>+n2&#10;</xsl:text>
      <xsl:text>+i f=3 l=1&#10;</xsl:text>
      <xsl:text>y e OLISTe&#10;</xsl:text>
    </xsl:if>

    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxx Bandeinteilung xxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
    <xsl:text>y b BrlVol&#10;</xsl:text>
    <xsl:text>?vol:vol+1&#10;</xsl:text>
    <xsl:text>y Titlepage&#10;</xsl:text>
    <xsl:if test="$volumes &gt; 1 and $toc_level &gt; 0">
      <xsl:text>&#10;xy InhTit&#10;</xsl:text>
      <xsl:text>H`lm1&#10;</xsl:text>
      <xsl:text>H`n5&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="$volumes &lt; 13">
          <xsl:text>"H`t%B</xsl:text>
          <xsl:value-of select="louis:translate(string($braille_tables),'er')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>"H`t%B</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="louis:translate(string($braille_tables),' Band')"/>
      <xsl:text>&#10;H`lm1&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y e BrlVol&#10;</xsl:text>

    <xsl:if test="//brl:volume">
      <xsl:text>y b EndVol
n3
L
tCCCCCCCCCCCC
t
 </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'Ende des')"/>
      <xsl:choose>
        <xsl:when test="$volumes &gt; 12">
          <xsl:text>&#10;" %B&#10; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$contraction = 2">
              <xsl:text>&#10;" %BC&#10; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#10;" %BEN&#10; </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="louis:translate(string($braille_tables),'Bandes')"/>
      <xsl:text>
y e EndVol
</xsl:text>
    </xsl:if>

    <xsl:text>&#10;xxxxxxxxxxxxxxxxxxxxxxxxxxxx Hilfsmakros xxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#10;</xsl:text>
    <xsl:if test="$toc_level &gt; 0">
      <xsl:text>y b Inhaltsv
E
P1
~~
I ~=j
i k=0
L
t~
 </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'Inhaltsverzeichnis')"/>
      <xsl:text>
u-
lm1
y e Inhaltsv
</xsl:text>
    </xsl:if>

    <xsl:text>y b EndBook
lm1
n3
L
tCCCCCCCCCCCC
t
 </xsl:text>
    <xsl:value-of select="louis:translate(string($braille_tables),'Ende des Buches')"/>
    <xsl:text>
t======
y e EndBook
</xsl:text>

    <xsl:if test="$volumes &gt; 1 and $toc_level &gt; 0">
      <xsl:text>
y b InhTit                   ; Hilfsmakro zum Inhaltsverzeichnis der Einzelbaende
H`z
H`P1
I ~=j
i k=0
H`L
H`t~~</xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'Inhaltsverzeichnis')"/>
      <xsl:text>
H`u-
H`lm1
y e InhTit
</xsl:text>
    </xsl:if>

    <xsl:if test="$volumes &gt; 12">
      <!-- FIXME: numbers should be translated with liblouis -->
      <xsl:text>
y b Ziff   ; Hilfsmakro zum Uebersetzen der (tiefgestellten) Ziffern
?z=0
+R=Z)
?z=1
+R=Z,
?z=2
+R=Z;
?z=3
+R=Z:
?z=4
+R=Z/
?z=5
+R=Z?
?z=6
+R=Z+
?z=7
+R=Z=
?z=8
+R=Z(
?z=9
+R=Z*
"R=B%B%Z
y e Ziff
</xsl:text>
    </xsl:if>

    <xsl:if test="$volumes &gt; 1">
      <xsl:text>y b Volumes&#10;t&#10; </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables),'In ')"/>
      <xsl:choose>
        <xsl:when test="$volumes &lt; 13">
          <xsl:variable name="number">
            <xsl:choose>
              <xsl:when test="$volumes = '2'">zwei</xsl:when>
              <xsl:when test="$volumes = '3'">drei</xsl:when>
              <xsl:when test="$volumes = '4'">vier</xsl:when>
              <xsl:when test="$volumes = '5'">fünf</xsl:when>
              <xsl:when test="$volumes = '6'">sechs</xsl:when>
              <xsl:when test="$volumes = '7'">sieben</xsl:when>
              <xsl:when test="$volumes = '8'">acht</xsl:when>
              <xsl:when test="$volumes = '9'">neun</xsl:when>
              <xsl:when test="$volumes = '10'">zehn</xsl:when>
              <xsl:when test="$volumes = '11'">elf</xsl:when>
              <xsl:when test="$volumes = '12'">zwölf</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:value-of select="louis:translate(string($braille_tables),string($number))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="louis:translate(string($braille_tables),string($volumes))"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="louis:translate(string($braille_tables),' Braillebänden')"/>
      <xsl:text>&#10;t&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="$volumes &lt; 13">
          <!-- bis zu zwölf Bänden in Worten -->
          <xsl:text>?vol=1&#10;+R=B</xsl:text>
          <xsl:value-of select="louis:translate(string($braille_tables),'erst')"/>
          <xsl:text>&#10;?vol=2&#10;+R=B</xsl:text>
          <xsl:value-of select="louis:translate(string($braille_tables),'zweit')"/>
          <xsl:if test="$volumes &gt; 2">
            <xsl:text>&#10;?vol=3&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables),'dritt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 3">
            <xsl:text>&#10;?vol=4&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables),'viert')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 4">
            <xsl:text>&#10;?vol=5&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'fünft')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 5">
            <xsl:text>&#10;?vol=6&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'sechst')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 6">
            <xsl:text>&#10;?vol=7&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'siebt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 7">
            <xsl:text>&#10;?vol=8&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'acht')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 8">
            <xsl:text>&#10;?vol=9&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'neunt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 9">
            <xsl:text>&#10;?vol=10&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'zehnt')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 10">
            <xsl:text>&#10;?vol=11&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'elft')"/>
          </xsl:if>
          <xsl:if test="$volumes &gt; 11">
            <xsl:text>&#10;?vol=12&#10;+R=B</xsl:text>
            <xsl:value-of select="louis:translate(string($braille_tables), 'zwölft')"/>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$contraction = 2">
              <xsl:text>&#10;" %B7&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#10;" %BER&#10;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>
xxx Zahl einfuegen (herabgesetzt) - Maximal 99
R=B#
?z:vol/10
?z>0
+y Ziff
?z:vol%10
y Ziff
"t%B
</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
      <xsl:value-of select="louis:translate(string($braille_tables), 'Band')"/>
      <xsl:text>&#10;y e Volumes&#10;  </xsl:text>
    </xsl:if>
    <xsl:text>
xxxxxxxxxxxxxxxxxxxxxxxxxxxx Titelblatt xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
y b Titlepage
O
bb
L5
t
 </xsl:text>
    <xsl:apply-templates select="//dtb:docauthor"/>
    <xsl:text>
l2
t
 </xsl:text>
    <xsl:apply-templates select="//dtb:doctitle"/>
    <xsl:text>&#10;u-&#10;</xsl:text>
    <xsl:if test="$book_type = 'sjw'">
      <xsl:text>l2&#10;t&#10; </xsl:text>
      <xsl:call-template name="handle_abbr">
        <xsl:with-param name="context" select="'abbr'"/>
        <xsl:with-param name="content" select="'SJW'"/>
      </xsl:call-template>
      <xsl:text>-</xsl:text>
      <xsl:value-of
        select="louis:translate(string($braille_tables), 'Heft Nr.')"/>
      <xsl:value-of
        select="louis:translate(string($braille_tables), string(//dtb:meta[@name='prod:seriesNumber']/@content))"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$volumes &gt; 1">
      <!-- Leerzeilencheck hierhin verschoben, Leerzeile aus "y b Volumes" entfernt! -->
      <xsl:variable name="leer">
        <xsl:choose>
          <xsl:when test="$book_type = 'rucksack'">5</xsl:when>
          <xsl:when test="$book_type = 'sjw'">4</xsl:when>
          <xsl:otherwise>6</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:text>&#10;l</xsl:text>
      <xsl:choose>
        <xsl:when test="$contraction = 2">
          <xsl:value-of select="$leer"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$leer -1"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;y Volumes&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="$book_type = 'rucksack'">
      <xsl:choose>
        <xsl:when test="$contraction = 2">
          <xsl:text>lv23&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>lv22&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>t&#10; </xsl:text>
      <xsl:value-of
        select="louis:translate(string($braille_tables), 'Rucksackbuch Nr.')"/>
      <xsl:value-of
        select="louis:translate(string($braille_tables), string(//dtb:meta[@name='prod:seriesNumber']/@content))"/>
      <xsl:text>&#10;t&#10; </xsl:text>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
        <xsl:text>lv25&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>lv24&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>t&#10; </xsl:text>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" select="'SBS'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Schweizerische Bibliothek')"/>
    <xsl:text>&#10;t&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'für Blinde, Seh- und ')"/>
    <xsl:if test="not($contraction = 2)">
      <xsl:text>&#10;t&#10; </xsl:text>
    </xsl:if>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Lesebehinderte')"/>
    <xsl:text>
p
L
i f=1 l=1
 </xsl:text>

    <xsl:choose>
      <xsl:when test="$book_type = 'sjw'">
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('Braille­aus­ga­be mit freund­licher Ge­neh­mi­gung des '))"/>
        <xsl:call-template name="handle_abbr">
          <xsl:with-param name="context" select="'abbr'"/>
          <xsl:with-param name="content" select="'SJW'"/>
        </xsl:call-template>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation(' Schwei­ze­ri­schen Ju­gend­schrif­ten­werks, Zürich.'))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation(' Wir dan­ken dem '))"/>
        <xsl:call-template name="handle_abbr">
          <xsl:with-param name="context" select="'abbr'"/>
          <xsl:with-param name="content" select="'SJW'"/>
        </xsl:call-template>
        <xsl:text>-</xsl:text>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('&#x250A;Ver­lag für die Be­reit­stel­lung der Da­ten.'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('Dieses Braille­buch ist die aus­schließ­lich '))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('für die Nut­zung durch Seh- und Le­se­be­hin­der­te Men­schen '))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('be­stimm­te zu­gäng­li­che Ver­sion eines ur­he­ber­recht­lich '))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('ge­schütz­ten Werks. '))"/>
        <xsl:value-of
          select="louis:translate(string($vform_braille_tables), 'Sie ')"/>
        <xsl:value-of select="louis:translate(string($braille_tables), my:filter-hyphenation('kön­nen '))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('es im Rah­men des Ur­he­ber­rechts per­sön­lich nut­zen, '))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('dür­fen es aber nicht wei­ter ver­brei­ten oder öf­fent­lich '))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation('zu­gäng­lich ma­chen.'))"/>
	<xsl:if test="//dtb:meta[lower-case(@name)='prod:source']/@content = 'electronicData'">
	  <xsl:text>&#10;l&#10; </xsl:text>
	  <xsl:value-of select="louis:translate(string($braille_tables), my:filter-hyphenation('Wir dan­ken dem Ver­lag für die freund­liche Be­reit­stel­lung der elek­troni­schen Text­da­ten. '))"/>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$book_type = 'rucksack'">
      <xsl:choose>
        <xsl:when test="$contraction = 2">
          <xsl:text>&#10;lv19&#10; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#10;lv18&#10; </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;a&#10; </xsl:text>
      <xsl:value-of
        select="louis:translate(string($braille_tables), 'Rucksackbuch Nr.')"/>
      <xsl:value-of
        select="louis:translate(string($braille_tables), string(//dtb:meta[@name='prod:seriesNumber']/@content))"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
        <xsl:text>&#10;lv21&#10; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;lv20&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Verlag, Satz und Druck')"/>
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" select="'SBS'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Schweizerische Bibliothek')"/>
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'für Blinde, Seh- und ')"/>
    <xsl:if test="not($contraction = 2)">
      <xsl:text>&#10;a&#10; </xsl:text>
    </xsl:if>
    <xsl:value-of
      select="louis:translate(string($braille_tables), 'Lesebehinderte, Zürich')"/>
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:variable name="boilerplate">
      <dtb:a xml:lang="de">www.sbs.ch</dtb:a>
    </xsl:variable>
    <xsl:apply-templates select="$boilerplate"/>
    <xsl:text>&#10;l&#10; </xsl:text>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" select="'SBS'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of
      select="louis:translate(string($braille_tables), string(substring-before(//dtb:meta[@name='dc:Date']/@content,'-')))"/>
    <xsl:text>&#10;p&#10;xxx Titelblatt der Originalausgabe (Gestaltung der Vorlage nachempfinden)</xsl:text>
    <xsl:text>&#10;L5&#10; </xsl:text>
    <xsl:apply-templates select="//dtb:docauthor"/>
    <xsl:text>&#10;l2&#10; </xsl:text>
    <xsl:apply-templates select="//dtb:doctitle"/>
    <xsl:text>&#10;u-&#10;l&#10; </xsl:text>
    <xsl:apply-templates
      select="//dtb:frontmatter/dtb:level1[@class='titlepage']" mode="titlepage"/>
    <xsl:text>&#10;b&#10;</xsl:text>
    <xsl:text>O&#10;</xsl:text>
    <xsl:text>y e Titlepage&#10;</xsl:text>
    <xsl:text>xxx ====================== ENDE SBSFORM.MAK ====================== xxx&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>