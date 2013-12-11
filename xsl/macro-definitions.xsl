<?xml version="1.0" encoding="utf-8"?>

	<!-- Copyright (C) 2010-2013 Swiss Library for the Blind, Visually Impaired and Print Disabled -->
	
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
	
  <xsl:function name="my:padded-comment" as="text()">
    <xsl:param name="comment"/>
    <xsl:variable name="padding-chars"
		  select="'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'"/>
    <xsl:value-of select="my:padded-comment($comment, $padding-chars)"/>
  </xsl:function>

  <xsl:function name="my:padded-comment" as="text()">
    <xsl:param name="comment"/>
    <xsl:param name="padding-chars"/>
    <xsl:variable name="max-width" select="78"/>
    <xsl:variable name="padding" select="($max-width - string-length($comment) - 3) div 2"/>
    <xsl:value-of select="concat('&#10;x', substring(concat(substring($padding-chars,1,$padding),' ',$comment,' ',$padding-chars),1,$max-width),'&#10;&#10;')"/>
  </xsl:function>

  <xsl:template name="sbsform-macro-definitions">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="vform_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'v-form'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:sequence select="my:padded-comment('ANFANG SBSFORM.MAK', '================================================================================')"/>
    <xsl:text>x Bei Aenderungen den ganzen Block in separate Makrodatei auslagern.&#10;</xsl:text>

    <xsl:sequence select="my:padded-comment('book, body, rear')"/>

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
      <xsl:sequence select="my:padded-comment('Frontmatter Levels und Headings')"/>
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

    <xsl:sequence select="my:padded-comment('Levels und Headings')"/>
    <xsl:text>y b LEVEL1b
p
Y
y e LEVEL1b
y b LEVEL1e
y e LEVEL1e
y b H1
L
i f=3 l=1
i A=4 R=4
t
Y
u-
i A=0 R=0
</xsl:text>
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
      <xsl:text>
y b LEVEL2b
lm2
n10
Y
y e LEVEL2b
y b LEVEL2e
y e LEVEL2e
y b H2
lm1
i f=3 l=1
w
Y
u
</xsl:text>
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
      <xsl:text>
y b LEVEL4b
lm1
n4
Y
y e LEVEL4b
y b LEVEL4e
y e LEVEL4e
y b H4
lm1
i f=3 l=1
w
Y
</xsl:text>
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
      <xsl:text>
y b LEVEL5b
lm1
n4
Y
y e LEVEL5b
y b LEVEL5e
y e LEVEL5e
y b H5
lm1
i f=3 l=1
w
Y
</xsl:text>
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
      <xsl:text>
y b LEVEL6b
lm1
n4
Y
y e LEVEL6b
y b LEVEL6e
y e LEVEL6e
y b H6
lm1
i f=3 l=1
w
Y
</xsl:text>
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
      <xsl:sequence select="my:padded-comment('Makros mit Class Attributen')"/>
      <!-- Elements that only have a start macro -->
      <xsl:for-each-group
	  select="(//dtb:author|
		  //dtb:byline|
		  //dtb:li|
		  //dtb:p|
		  //dtb:img|
		  //dtb:caption|
                  //dtb:hd|
                  //dtb:bridgehead|
		  //dtb:h1|
		  //dtb:h2|
		  //dtb:h3|
		  //dtb:h4|
		  //dtb:h5|
		  //dtb:h6)[@brl:class]"
	  group-by="local-name()">
	<xsl:variable name="element-name" select="current-grouping-key()"/>
        <xsl:variable name="makro-name">
	  <xsl:choose>
	    <xsl:when test="$element-name='bridgehead'">BRIDGE</xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="upper-case($element-name)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>
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
                   //dtb:table|
                   //dtb:tbody|
                   //dtb:thead|
                   //dtb:tfoot|
                   //dtb:tr|
                   //dtb:td|
                   //dtb:th|
                   //dtb:list|
                   //dtb:dl|
                   //dtb:dt|
                   //dtb:dd|
                   //dtb:poem|
                   //dtb:sidebar|
                   //dtb:linegroup|
                   //dtb:line|
                   //dtb:imggroup|
                   //dtb:div)[@brl:class]"
          group-by="if (self::dtb:list) then concat('list@type=', @type) else local-name()">
	<xsl:variable name="element-name" select="local-name()"/>
        <xsl:variable name="makro-name">
	  <xsl:choose>
	    <xsl:when test="$element-name='blockquote'">BLQUO</xsl:when>
	    <xsl:when test="$element-name='epigraph'">EPIGR</xsl:when>
	    <xsl:when test="$element-name='imggroup'">IMGGR</xsl:when>
	    <xsl:when test="$element-name='linegroup'">LINEGR</xsl:when>
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
      <xsl:sequence select="my:padded-comment('Notes')"/>
      <xsl:text>
y b Notes
X TODO: Fix this macro
y e Notes
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Absatz, Leerzeile, Separator')"/>
      <xsl:text>
y b P
a
y e P
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'precedingemptyline')]">
      <xsl:text>
y b BLANK
lm1
n2
y e BLANK
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'precedingseparator')]">
      <xsl:text>
y b SEPARATOR
B+
L
t*?*?*?
B-
lm1
n2
y e SEPARATOR
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:p[not(@brl:class) and contains(@class, 'noindent')]">
      <xsl:text>
y b P_noi
w
y e P_noi
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:author[not(@brl:class)]">
      <xsl:text>
y b AUTHOR
r
y e AUTHOR
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:byline[not(@brl:class)]">
      <xsl:text>
y b BYLINE
r
y e BYLINE
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:blockquote[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Blockquote')"/>
      <xsl:text>
y b BLQUOb
lm1
n2
i A=2
y e BLQUOb
y b BLQUOe
i A=0
lm1
n2
y e BLQUOe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:epigraph[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Epigraph')"/>
      <xsl:text>
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

    <xsl:if test="//dtb:poem[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Poem')"/>
      <xsl:text>
y b POEMb
lm1
i f=1 l=3 w=1 W=1
n4
i A=2
y e POEMb
y b POEMe
i A=0
i f=3 l=1 w=1 W=1
lm1
n2
y e POEMe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:linegroup[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Linegroup')"/>
      <xsl:text>
y b LINEGRb
lm1
i f=1 l=3 w=1 W=1
n2
y e LINEGRb
y b LINEGRe
i f=3 l=1 w=1 W=1
y e LINEGRe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:line[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Line')"/>
      <xsl:text>
y b LINEb
a
B+
y e LINEb
y b LINEe
B-
y e LINEe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:poem[not(@brl:class)]//dtb:linenum">
      <xsl:sequence select="my:padded-comment('Poem mit Linenum')"/>
      <xsl:text>
y b POEM_LNb
lm1
I T=j
i f=1 l=7 T=5 w=5 W=5
n4
y e POEM_LNb
y b POEM_LNe
I T=n
i f=3 l=1 w=1 W=1
lm1
n2
y e POEM_LNe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:linegroup[not(@brl:class)]//dtb:linenum">
      <xsl:sequence select="my:padded-comment('Linegroup mit Linenum')"/>
      <xsl:text>
y b LINEGR_LNb
lm1
I T=j
i f=1 l=7 T=5 w=5 W=5
n2
y e LINEGR_LNb
y b LINEGR_LNe
I T=n
i f=3 l=1 w=1 W=1
y e LINEGR_LNe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:span[@class='linenum']">
      <xsl:sequence select="my:padded-comment('span@class=linenum')"/>
      <xsl:text>
y b SECT_LNb
I T=j
i w=1 W=5
y e SECT_LNb

y b SECT_LNe
I T=n
i w=1 W=1
y e SECT_LNe

y b P_LN
i T=7
w
y e P_LN

y b P_LN_noi
i T=5
w
y e P_LN_noi
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:imggroup[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Imggroup')"/>
      <xsl:text>
y b IMGGRb
lm1
i f=1 l=3
n2
y e IMGGRb
y b IMGGRe
i f=3 l=1
lm1
y e IMGGRe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:img[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Images')"/>
      <xsl:text>
y b IMG
R=C
y e IMG
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:caption[not(@brl:class)]">
      <xsl:text>
y b CAPTION
a
y e CAPTION
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:sidebar[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Sidebars')"/>
      <xsl:text>
y b SIDEBARb
lm1
n3
DPCCCC
i A=1
y e SIDEBARb
y b SIDEBARe
i A=0
DV----
lm1
y e SIDEBARe

</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:hd[not(@brl:class)]">
      <xsl:text>
y b HD
w
y e HD

</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:bridgehead[not(@brl:class)]">
      <xsl:text>
y b BRIDGE
lm1
i f=3 l=1
n2
w
Y
y e BRIDGE

</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class)]|//dtb:li[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Listen')"/>
      <xsl:text>
y b LI
a
y e LI
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class) and @type='pl']|//dtb:li[not(@brl:class)]">
      <xsl:text>
y b PLISTb ; 'pl' Liste
?nl:nl+1
?nl=1
+lm1
+i f=1 l=3
?nl=2
+i f=3 l=5
?nl=3
+i f=5 l=7
y e PLISTb
y b PLISTe
?nl:nl-1
?nl=2
+i f=3 l=5
?nl=1
+i f=1 l=3
?nl=0
+lm1
+n2
+i f=3 l=1
y e PLISTe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class) and @type='ul']|//dtb:li[not(@brl:class)]">
      <xsl:text>
y b ULISTb ; 'ul' Liste
?nl:nl+1
?nl=1
+lm1
+i f=1 l=3
?nl=2
+i f=3 l=5
?nl=3
+i f=5 l=7
y e ULISTb
y b ULISTe
?nl:nl-1
?nl=2
+i f=3 l=5
?nl=1
+i f=1 l=3
?nl=0
+lm1
+n2
+i f=3 l=1
y e ULISTe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:list[not(@brl:class) and @type='ol']|//dtb:li[not(@brl:class)]">
      <xsl:text>
y b OLISTb ; 'ol' Liste
?nl:nl+1
?nl=1
+lm1
+i f=1 l=3
?nl=2
+i f=3 l=5
?nl=3
+i f=5 l=7
y e OLISTb
y b OLISTe
?nl:nl-1
?nl=2
+i f=3 l=5
?nl=1
+i f=1 l=3
?nl=0
+lm1
+n2
+i f=3 l=1
y e OLISTe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:dl[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Definitionslisten')"/>
      <xsl:text>
y b DLb
i f=1 l=3
lm1
n2
y e DLb
y b DLe
i f=3 l=1
lm1
n2
y e DLe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:dt[not(@brl:class)]">
      <xsl:text>
y b DTb
n2
a
y e DTb
y b DTe
y e DTe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:dd[not(@brl:class)]">
      <xsl:text>
y b DDb
y e DDb
y b DDe
y e DDe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:table[not(@brl:class)]">
      <xsl:sequence select="my:padded-comment('Tabellen')"/>
      <xsl:text>
y b TABLEb
i f=1 l=3
lm1
n2
y e TABLEb
y b TABLEe
i f=3 l=1
lm1
n2
y e TABLEe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:tbody[not(@brl:class)]">
      <xsl:text>
y b TBODYb
u:*
y e TBODYb
y b TBODYe
y e TBODYe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:thead[not(@brl:class)]">
      <xsl:text>
y b THEADb
lm1
y e THEADb
y b THEADe
y e THEADe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:tfoot[not(@brl:class)]">
      <xsl:text>
y b TFOOTb
u:*
y e TFOOTb
y b TFOOTe
y e TFOOTe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:tr[not(@brl:class)]">
      <xsl:text>
y b TRb
y e TRb
y b TRe
y e TRe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:td[not(@brl:class)]">
      <xsl:text>
y b TDb
y e TDb
y b TDe
y e TDe
</xsl:text>
    </xsl:if>

    <xsl:if test="//dtb:th[not(@brl:class)]">
      <xsl:text>
y b THb
y e THb
y b THe
y e THe
</xsl:text>
    </xsl:if>

    <xsl:sequence select="my:padded-comment('Bandeinteilung')"/>
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

    <xsl:sequence select="my:padded-comment('Hilfsmakros')"/>
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
    <xsl:sequence select="my:padded-comment('Titelblatt')"/>
    <xsl:text>
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
        <xsl:with-param name="content" as="text()">
	  <xsl:text>SJW</xsl:text>
	</xsl:with-param>
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
      <xsl:with-param name="content" as="text()">
	<xsl:text>SBS</xsl:text>
      </xsl:with-param>
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
          <xsl:with-param name="content" as="text()">
	    <xsl:text>SJW</xsl:text>
	  </xsl:with-param>
        </xsl:call-template>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation(' Schwei­ze­ri­schen Ju­gend­schrif­ten­werks, Zürich.'))"/>
        <xsl:value-of
          select="louis:translate(string($braille_tables), my:filter-hyphenation(' Wir dan­ken dem '))"/>
        <xsl:call-template name="handle_abbr">
          <xsl:with-param name="context" select="'abbr'"/>
          <xsl:with-param name="content" as="text()">
	    <xsl:text>SJW</xsl:text>
	  </xsl:with-param>
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
      <xsl:with-param name="content" as="text()">
	<xsl:text>SBS</xsl:text>
      </xsl:with-param>
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
      <dtb:a xml:lang="de"><brl:computer>www.sbs.ch</brl:computer></dtb:a>
    </xsl:variable>
    <xsl:apply-templates select="$boilerplate"/>
    <xsl:text>&#10;l&#10; </xsl:text>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" as="text()">
	<xsl:text>SBS</xsl:text>
      </xsl:with-param>
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
    <xsl:sequence select="my:padded-comment('ENDE SBSFORM.MAK', '================================================================================')"/>
  </xsl:template>

</xsl:stylesheet>
