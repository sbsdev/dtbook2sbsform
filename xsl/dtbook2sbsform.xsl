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
  xmlns:math="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="dtb louis data my" extension-element-prefixes="my">
	
  <xsl:import href="functions.xsl"/>
  <xsl:include href="braille-translation.xsl"/>
  
  <xsl:include href="macro-definitions.xsl"/>
  <xsl:include href="table-utils.xsl"/>
  <xsl:include href="linenum-span.xsl"/>
  <xsl:include href="nordic-spec.xsl"/>

  <xsl:output method="text" encoding="utf-8" indent="no"/>
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space
    elements="dtb:p dtb:byline dtb:author dtb:li dtb:lic dtb:doctitle dtb:docauthor dtb:span dtb:em dtb:strong brl:emph dtb:line dtb:h1 dtb:h2 dtb:h3 dtb:h4 dtb:h5 dtb:h6"/>

  <xsl:param name="contraction">2</xsl:param>
  <xsl:param name="version">0</xsl:param>
  <xsl:param name="cells_per_line">28</xsl:param>
  <xsl:param name="lines_per_page">28</xsl:param>
  <xsl:param name="hyphenation" select="false()"/>
  <xsl:param name="toc_level">0</xsl:param>
  <xsl:param name="footer_level">0</xsl:param>
  <xsl:param name="show_original_page_numbers" select="true()"/>
  <xsl:param name="show_v_forms" select="true()"/>
  <xsl:param name="downshift_ordinals" select="true()"/>
  <xsl:param name="enable_capitalization" select="false()"/>
  <xsl:param name="detailed_accented_characters">de-accents-ch</xsl:param>
  <xsl:param name="include_macros" select="true()"/>
  <xsl:param name="footnote_placement">standard</xsl:param>
  <xsl:param name="use_local_dictionary" select="false()"/>
  <xsl:param name="document_identifier"></xsl:param>
  
  <xsl:variable name="volumes">
    <xsl:value-of select="count(//brl:volume[@brl:grade=$contraction]) + 1"/>
  </xsl:variable>

  <xsl:variable name="book_type">
    <xsl:choose>
      <xsl:when test="//dtb:meta[@name='prod:series']/@content='PPP'">rucksack</xsl:when>
      <xsl:when test="//dtb:meta[@name='prod:series']/@content='SJW'">sjw</xsl:when>
      <xsl:otherwise>standard</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template name="rest-of-frontmatter">
    <xsl:text>&#10;y BOOKb&#10;</xsl:text>
    <xsl:if test="//(dtb:note|dtb:annotation) and $footnote_placement = 'standard'">
      <xsl:call-template name="insert_footnotes"/>
    </xsl:if>
    <xsl:text>y BrlVol&#10;</xsl:text>
    <xsl:if test="//dtb:frontmatter/dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]">
      <xsl:sequence select="my:padded-comment('Klappentext etc.')"/>
      <xsl:text>O&#10;</xsl:text>
      <xsl:apply-templates
	  select="//dtb:frontmatter/dtb:level1[not(@class) or (@class!='titlepage' and @class!='toc')]"/>
      <xsl:text>O&#10;</xsl:text>
    </xsl:if>
    <xsl:sequence select="my:padded-comment('Buchinhalt')"/>
  </xsl:template>

  <!-- ====== -->
  <!-- MACROS -->
  <!-- ====== -->
  
  <xsl:template name="block_macro">
    <xsl:param name="macro" as="xs:string"/>
    <xsl:param name="indent" as="xs:string" select="''"/>
    <xsl:param name="newline_after" as="xs:boolean" select="true()"/>
    <xsl:param name="enable_class" as="xs:boolean" select="true()"/>
    <xsl:param name="body">
      <xsl:apply-templates mode="#current"/>
    </xsl:param>
    <xsl:value-of select="concat('&#10;y ', $macro, 'b')"/>
    <xsl:value-of select="if ($enable_class and my:has-brl-class(.)) then concat('_', my:get-brl-class(.)) else ''"/>
    <xsl:value-of select="concat('&#10;', $indent)"/>
    <xsl:sequence select="$body"/>
    <xsl:value-of select="concat('&#10;y ', $macro, 'e')"/>
    <xsl:value-of select="if ($enable_class and my:has-brl-class(.)) then concat('_', my:get-brl-class(.)) else ''"/>
    <xsl:value-of select="if ($newline_after) then '&#10;' else ''"/>
  </xsl:template>

  <xsl:template name="inline_macro">
    <xsl:param name="macro" as="xs:string"/>
    <xsl:param name="indent" as="xs:string" select="' '"/>
    <xsl:param name="body">
      <xsl:apply-templates mode="#current"/>
    </xsl:param>
    <xsl:value-of select="concat('&#10;y ', $macro)"/>
    <xsl:value-of select="if (my:has-brl-class(.)) then concat('_', my:get-brl-class(.)) else ''"/>
    <xsl:value-of select="concat('&#10;', $indent)"/>
    <xsl:sequence select="$body"/>
  </xsl:template>

  <xsl:template match="dtb:dtbook">
     <xsl:text>x </xsl:text>
    <xsl:value-of select="//dtb:docauthor"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="//dtb:doctitle"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x Daisy Producer Version: </xsl:text>
    <xsl:value-of select="$version"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x SBS Braille Tables Version: </xsl:text>
    <!-- Use a special table to query the version of the SBS-specific (German) tables -->
    <xsl:value-of select="louis:translate('sbs-version.utb', '{{sbs-braille-tables-version}}')"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>x contraction:</xsl:text><xsl:value-of select="$contraction"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x cells_per_line:</xsl:text><xsl:value-of select="$cells_per_line"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x lines_per_page:</xsl:text><xsl:value-of select="$lines_per_page"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x hyphenation:</xsl:text><xsl:value-of select="$hyphenation"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x toc_level:</xsl:text><xsl:value-of select="$toc_level"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x show_original_page_numbers:</xsl:text><xsl:value-of select="$show_original_page_numbers"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x show_v_forms:</xsl:text><xsl:value-of select="$show_v_forms"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x downshift_ordinals:</xsl:text><xsl:value-of select="$downshift_ordinals"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x enable_capitalization:</xsl:text><xsl:value-of select="$enable_capitalization"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x detailed_accented_characters:</xsl:text><xsl:value-of select="$detailed_accented_characters"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x include_macros:</xsl:text><xsl:value-of select="$include_macros"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x footnote_placement:</xsl:text><xsl:value-of select="$footnote_placement"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x use_local_dictionary:</xsl:text><xsl:value-of select="$use_local_dictionary"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x document_identifier:</xsl:text><xsl:value-of select="$document_identifier"/><xsl:text>&#10;</xsl:text>
    <xsl:text>x ---------------------------------------------------------------------------&#10;</xsl:text>
   <xsl:choose>
      <xsl:when test="$include_macros = true()">
        <xsl:call-template name="sbsform-macro-definitions"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;U dtbook.mak&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="rest-of-frontmatter"/>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ignore all meta data -->
  <xsl:template match="dtb:head|dtb:meta|dtb:link"/>

  <xsl:template match="dtb:book">
    <xsl:apply-templates/>
    <xsl:text>&#10;y BOOKe&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:frontmatter"> </xsl:template>

  <xsl:template match="dtb:bodymatter">
    <xsl:if test="$footer_level = 0 and $show_original_page_numbers = false()">
      <xsl:text>I S=j&#10;</xsl:text> 
      <xsl:text>i S=</xsl:text>
      <xsl:value-of select="$cells_per_line - 8"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:text>&#10;y BODYb&#10;</xsl:text>
    <xsl:text>i j=</xsl:text>
    <!-- value of first pagenum within body -->
    <xsl:value-of select="descendant::dtb:pagenum[1]/text()"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <!-- Apply end notes of last volume -->
    <xsl:if test="$footnote_placement = 'end_vol'">
      <xsl:call-template name="handle_notes">
	<xsl:with-param name="noterefs" select="//(dtb:noteref|dtb:annoref)[not(following::brl:volume[@brl:grade = $contraction])]"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:text>&#10;&#10;y BODYe&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:doctitle">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:docauthor">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="handle_notes">
    <xsl:param name="noterefs" as="element()*"/>
    <xsl:variable name="notes" select="for $noteref in $noterefs return //(dtb:note|dtb:annotation)[@id=translate($noteref/@idref,'#','')]"/>
    <xsl:if test="exists($notes)">
      <xsl:text>&#10;y Notes&#10;</xsl:text>
      <xsl:for-each select="$notes">
	<xsl:apply-templates/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="handle_level_endnotes">
    <xsl:variable name="level">
      <xsl:choose>
        <xsl:when test="local-name() = 'level1'">1</xsl:when>
        <xsl:when test="local-name() = 'level2'">2</xsl:when>
        <xsl:when test="local-name() = 'level3'">3</xsl:when>
        <xsl:when test="local-name() = 'level4'">4</xsl:when>
        <xsl:otherwise>NoMatch</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$footnote_placement = concat('level', $level)">
      <xsl:call-template name="handle_notes">
	<xsl:with-param name="noterefs" select="current()//(dtb:noteref|dtb:annoref)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Frontmatter handling -->
  <xsl:template match="dtb:frontmatter//dtb:level1">
    <xsl:text>&#10;z&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:frontmatter//dtb:level2|dtb:frontmatter//dtb:level3">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:frontmatter//dtb:h1|dtb:frontmatter//dtb:h2|dtb:frontmatter//dtb:h3">
    <xsl:variable name="level" select="number(substring(local-name(), 2))"/>
    <xsl:value-of select="concat('&#10;y H',$level,'_FRONT&#10; ')"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="level_macro">
    <xsl:param name="macro" as="xs:string"/>
    <xsl:value-of select="concat('&#10;y ', $macro, 'b&#10;')"/>
    <!-- add a comment if the first child is not a pagenum -->
    <xsl:value-of select="if (not(name(child::*[1])='pagenum')) then '.xNOPAGENUM&#10;' else ''"/>
    <xsl:call-template name="insert-markers-for-linenum-span-groups"/>
    <xsl:call-template name="handle_level_endnotes"/>
    <xsl:value-of select="concat('&#10;y ', $macro, 'e&#10;')"/>
  </xsl:template>

  <xsl:template match="dtb:level1|dtb:level2|dtb:level3|dtb:level4|dtb:level5|dtb:level6">
    <xsl:call-template name="level_macro">
      <xsl:with-param name="macro" select="upper-case(local-name())"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:p" mode="titlepage">
    <xsl:text>&#10;a&#10; </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:note/dtb:p|dtb:annotation/dtb:p">
    <xsl:text>&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="position()=1">
        <xsl:choose>
          <xsl:when test="$footnote_placement = 'standard'">
            <xsl:text>p </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>a </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#10; </xsl:text>
        <!-- Place the foot note number in the first para of the foot note -->
        <xsl:variable name="idref" select="concat('#',../@id)"/>
        <xsl:variable name="corresponding_noteref" select="//(dtb:noteref|dtb:annoref)[@idref=$idref][1]"/>
        <xsl:variable name="note_number" select="count($corresponding_noteref/(preceding::dtb:noteref|preceding::dtb:annoref))+1"/>
        <xsl:variable name="prefix" select="if ($footnote_placement = 'standard') then '*' else ''"/>
        <xsl:value-of select="concat(louis:translate(my:get-tables(.,local-name()), concat($prefix, $note_number)), ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>w </xsl:text>
	<xsl:text>&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:p">
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="contains(@class, 'precedingseparator')">
      <xsl:text>y SEPARATOR&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="contains(@class, 'precedingemptyline')">
      <xsl:text>y BLANK&#10;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="contains(@class, 'noindent')">
        <xsl:text>y P_noi&#10; </xsl:text>
      </xsl:when>
      <xsl:when test="my:has-brl-class(.)">
        <xsl:text>y P_</xsl:text><xsl:value-of select="my:get-brl-class(.)"/><xsl:text>&#10; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>y P&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ===== -->
  <!-- LISTS -->
  <!-- ===== -->

  <xsl:template match="dtb:list[@type='pl']">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'PLIST'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:list[@type='ul']">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'ULIST'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:list[@type='ol']">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'OLIST'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:li">
    <xsl:text>&#10;y LI</xsl:text>
    <xsl:if test="my:has-brl-class(.)"><xsl:text>_</xsl:text><xsl:value-of select="my:get-brl-class(.)"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:variable name="list" select="ancestor::dtb:list[1]"/>
    <xsl:if test="$list/@type='ol'">
      <xsl:variable name="enum" select="if ($list/@enum) then string($list/@enum) else '1'"/>
      <xsl:variable name="number" select="(if ($list/@start) then number($list/@start) else 1) + count(preceding-sibling::dtb:li)"/>
      <xsl:variable name="formatted-number">
        <xsl:choose>
          <xsl:when test="lower-case(string($enum))='a'">
            <xsl:element name="abbr" namespace="http://www.daisy.org/z3986/2005/dtbook/">
              <xsl:attribute name="lang" select="string(ancestor::*[@lang][1]/@lang)"/>
              <xsl:number value="$number" format="{string($enum)}"/>
            </xsl:element>
            <xsl:text>.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="num" namespace="http://www.daisy.org/z3986/2009/braille/">
              <xsl:attribute name="role" select="if (lower-case(string($enum))='i') then 'roman' else 'ordinal'"/>
              <xsl:attribute name="lang" select="string(ancestor::*[@lang][1]/@lang)"/>
              <xsl:number value="$number" format="{concat(string($enum), '.')}"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="$formatted-number" />
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="$list/@type='ul'">
      <xsl:value-of select="if (count(ancestor::dtb:list) mod 2 = 1) then '''- ' else '!- '"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:lic">
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- ================ -->
  <!-- DEFINITION LISTS -->
  <!-- ================ -->

  <xsl:template match="dtb:dl">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'DL'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:dt">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'DT'"/>
      <xsl:with-param name="indent" select="' '"/>
      <xsl:with-param name="newline_after" select="false()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:dd">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'DD'"/>
      <xsl:with-param name="indent" select="' '"/>
      <xsl:with-param name="newline_after" select="false()"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ====== -->
  <!-- TABLES -->
  <!-- ====== -->

  <xsl:template match="dtb:table">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="upper-case(local-name())"/>
      <xsl:with-param name="body">
        <xsl:apply-templates select="dtb:caption"/>
        
        <xsl:variable name="pre-translated-table" >
          <xsl:apply-templates select="." mode="pre-translate-table"/>
        </xsl:variable>
        
        <!-- Linerarized version -->
        
        <xsl:text>&#10;xxx Linearisierte Version xxx</xsl:text>
        
        <xsl:variable name="normalized-table">
          <xsl:apply-templates mode="normalize-table" select="$pre-translated-table">
            <xsl:with-param name="clone_cells" select="true()" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:apply-templates select="$normalized-table" mode="linearized-table"/>
        
        <!-- 2D version -->
        
        <xsl:variable name="normalized-table">
          <xsl:apply-templates mode="normalize-table" select="$pre-translated-table">
            <xsl:with-param name="clone_cells" select="false()" tunnel="yes"/>
          </xsl:apply-templates>
        </xsl:variable>
        
        <xsl:variable name="flattened-table">
          <xsl:apply-templates mode="flatten-table" select="$normalized-table"/>
        </xsl:variable>
        
        <xsl:text>&#10;xxx D-Zeilen-Version xxx</xsl:text>
        
        <xsl:apply-templates select="$flattened-table" mode="as-plain-table"/>
        
        <xsl:text>&#10;&#10;xxx D-Zeilen-Version (gedreht) xxx</xsl:text>
        
        <xsl:variable name="transposed-table">
          <xsl:apply-templates select="$flattened-table" mode="transpose-table"/>
        </xsl:variable>
        <xsl:apply-templates select="$transposed-table" mode="as-plain-table"/>
        
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="dtb:table" mode="flatten-table">
    <xsl:copy>
      <xsl:sequence select="(dtb:thead/dtb:tr, dtb:tr, dtb:tbody/dtb:tr, dtb:tfoot/dtb:tr)"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dtb:table" mode="normalize-table">
    <xsl:variable name="dtb:tr" as="element()*">
      <xsl:call-template name="dtb:insert-covered-table-cells">
        <xsl:with-param name="table_cells" select="dtb:tr/(dtb:td|dtb:th)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="(dtb:thead, $dtb:tr, dtb:tbody, dtb:tfoot)"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dtb:thead|dtb:tbody|dtb:tfoot" mode="normalize-table">
    <xsl:variable name="dtb:tr" as="element()*">
      <xsl:call-template name="dtb:insert-covered-table-cells">
        <xsl:with-param name="table_cells" select="dtb:tr/(dtb:td|dtb:th)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="$dtb:tr"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dtb:tr" mode="normalize-table">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="dtb:table|dtb:tbody|dtb:thead|dtb:tfoot|dtb:tr" mode="pre-translate-table">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dtb:td|dtb:th" mode="pre-translate-table">
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="dtb:table" mode="linearized-table">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="dtb:thead|dtb:tbody|dtb:tfoot|dtb:tr" mode="linearized-table">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="upper-case(local-name())"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="dtb:td|dtb:th" mode="linearized-table">
    <xsl:variable name="macro-name" select="upper-case(local-name())"/>
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="$macro-name"/>
      <xsl:with-param name="indent" select="' '"/>
      <xsl:with-param name="newline_after" select="false()"/>
      <xsl:with-param name="body">
        <xsl:if test="position() &gt; 1">
          <xsl:text>:: </xsl:text>
        </xsl:if>
        <xsl:sequence select="text()"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="dtb:table" mode="as-plain-table">
    <xsl:text>&#10;>skip&#10;</xsl:text>
    <xsl:variable name="root" select="."/>
    <xsl:variable name="column-sizes" as="xs:integer*">
      <xsl:for-each select="1 to max(for $row in dtb:tr return count($row/(dtb:td|dtb:th)))">
      	<xsl:variable name="column-position" select="."/>
      	<xsl:sequence select="max(for $t in $root/dtb:tr/(dtb:td|dtb:th)[position()=$column-position] return string-length(string($t)))"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="padding-space" 
		  select="'                                                                                '"/>
    <xsl:variable name="padding-dots" 
		  select="' ...............................................................................'"/>
    <xsl:variable name="underline-chars" 
		  select="'::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::'"/>
    <xsl:variable name="inter-column-spacing" select="'  '"/>
    <xsl:for-each select="dtb:tr">
      <xsl:variable name="heading-row" select="not(dtb:td)"/>
      <xsl:text>D</xsl:text>
      <xsl:for-each select="dtb:th|dtb:td">
	<xsl:variable name="column-position" select="position()"/>
	<!-- This padding only works to a max size of 80, but since
	     that is the usualy way more than the normal page width we
	     are probably not that concerned with it, i.e. if we have
	     to padd that much we are not really interested in the
	     table displayed as a plain table anyway. See also
	     http://www.dpawson.co.uk/xsl/sect2/padding.html#d8227e19
	     -->
	<xsl:variable name="actual-padding" 
		      select="if (not($heading-row) and (($column-sizes[$column-position] - string-length(.)) > 2)) then $padding-dots else $padding-space"/>
	<xsl:value-of
	    select="substring(concat(.,$actual-padding),1,$column-sizes[$column-position])"/>
	<xsl:if test="position()!=last()" >
	  <xsl:value-of select="$inter-column-spacing"/>
	</xsl:if>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
      <!-- Underline the th's -->
      <!-- Only underline if all cells are th's -->
      <xsl:if test="not(dtb:td)">
	<xsl:text>D</xsl:text>
      	<xsl:for-each select="dtb:td|dtb:th">
      	  <xsl:variable name="column-position" select="position()"/>
      	  <xsl:variable name="column-position" select="position()"/>
      	  <xsl:variable name="underline" 
			select="substring($underline-chars,1,string-length(.))"/>
      	  <xsl:value-of
      	      select="substring(
		        concat($underline, $padding-space),1,$column-sizes[$column-position])"/>
      	  <xsl:if test="position()!=last()" >
	    <xsl:value-of select="$inter-column-spacing"/>
      	  </xsl:if>
      	</xsl:for-each>
	<xsl:text>&#10;</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>:skip</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:table" mode="transpose-table">
    <xsl:variable name="root" select="."/>
    <xsl:copy>
      <xsl:for-each select="1 to max(for $row in dtb:tr return count($row/(dtb:td|dtb:th)))">
	<xsl:variable name="column-pos" select="."/>
	<dtb:tr>
	  <!-- see http://stackoverflow.com/questions/4410084/transpose-swap-x-y-axes-in-html-table -->
	  <xsl:for-each select="$root/dtb:tr">
	    <xsl:choose>
	      <xsl:when test="(dtb:td|dtb:th)[$column-pos]">
		<xsl:copy-of select="(dtb:td|dtb:th)[$column-pos]"/>
	      </xsl:when>
	      <xsl:otherwise>
		<dtb:td/> <!-- just add an empty cell -->
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
	</dtb:tr>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!-- This matcher is never invoked. It's basically just for testing purposes -->
  <xsl:template match="dtb:td|dtb:th">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Handle pagenums after volume boundaries -->
  <xsl:template match="dtb:pagenum[preceding-sibling::*[position()=1 and local-name()='volume' and @brl:grade = $contraction]]"/>

  <!-- Handle levelN/pagenums after volume boundaries -->
  <xsl:template match="dtb:pagenum[position()=1 and parent::*[substring(local-name(),0,6)='level' and preceding-sibling::*[position()=1 and local-name()='volume' and @brl:grade = $contraction]]]"/>

  <xsl:template match="dtb:pagenum" mode="no-space-after">
    <xsl:call-template name="dtb:pagenum">
      <xsl:with-param name="trailing-space" select="'&#10;'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:pagenum">
    <xsl:call-template name="dtb:pagenum">
      <xsl:with-param name="trailing-space" select="'&#10; '"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="dtb:pagenum">
    <xsl:param name="trailing-space"/>
    <xsl:text>&#10;j </xsl:text>
    <xsl:value-of select="text()"/>
    <!-- Add a newline unless the following node is another pagenum
         (ignore intermediate empty text nodes and comment nodes -->
    <xsl:variable name="following-nodes"
      select="following-sibling::* | following-sibling::text()[normalize-space(.)]"/>
    <!-- FIXME: this doesn't properly handle comment nodes -->
    <xsl:if test="not($following-nodes[position() = 1 and local-name() = 'pagenum'])">
      <!-- add a space for the following inline elements -->
      <xsl:value-of select="$trailing-space"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dtb:h1|dtb:h2|dtb:h3|dtb:h4|dtb:h5|dtb:h6">
    <xsl:variable name="level" select="number(substring(local-name(), 2))"/>
    <xsl:text>&#10;y H</xsl:text>
    <xsl:value-of select="$level"/>
    <xsl:if test="my:has-brl-class(.)"><xsl:text>_</xsl:text><xsl:value-of select="my:get-brl-class(.)"/></xsl:if>
    <xsl:text>&#10; </xsl:text>
    <xsl:variable name="header">
      <xsl:apply-templates
	  select="*[local-name() != 'toc-line' and local-name() != 'running-line']|text()"/>
    </xsl:variable>
    <!-- Remove hypenation marks ('t','k', 'p' and 'w') -->
    <xsl:value-of select="replace(string($header), '[tkpw]', '')"/>
    <xsl:if test="$toc_level &gt;= $level">
      <xsl:text>&#10;H</xsl:text>
      <xsl:variable name="toc-line">
        <xsl:choose>
          <xsl:when test="brl:toc-line">
            <xsl:apply-templates select="brl:toc-line"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates
              select="*[local-name() != 'toc-line' and local-name() != 'running-line']|text()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:value-of select="normalize-space(string($toc-line))"/>
    </xsl:if>
    <xsl:if test="$footer_level &gt;= $level">
      <xsl:text>&#10;~</xsl:text>
      <xsl:variable name="running-line">
        <xsl:choose>
          <xsl:when test="brl:running-line[not(@brl:grade) or @brl:grade = $contraction]">
            <xsl:apply-templates
              select="brl:running-line[not(@brl:grade)]|brl:running-line[@brl:grade = $contraction]"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates
              select="*[local-name() != 'toc-line' and local-name() != 'running-line']|text()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$show_original_page_numbers = false() and $footer_level &gt; 0">
        <xsl:text>:::s</xsl:text>
      </xsl:if>
      <!-- Replace spaces by 's' and remove hypenation marks ('t','k', 'p' and 'w') -->
      <xsl:value-of select="translate(normalize-space(string($running-line)),' tkpw','s')"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- ====== -->
  <!-- IMAGES -->
  <!-- ====== -->
  
  <xsl:template match="dtb:imggroup">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'IMGGR'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="dtb:img">
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'IMG'"/>
      <xsl:with-param name="indent" select="' '"/>
      <xsl:with-param name="body">
	<xsl:value-of select="louis:translate(my:get-tables(.,local-name()), string(@alt))"/>
	<xsl:text>&#10;</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="dtb:caption">
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'CAPTION'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- =========== -->
  <!-- BLOCKQUOTES -->
  <!-- =========== -->

  <xsl:template match="dtb:blockquote">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'BLQUO'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:epigraph">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'EPIGR'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:poem">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'POEM'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:poem[descendant::dtb:linenum]">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'POEM_LN'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="insert_footnotes">
    <xsl:sequence select="my:padded-comment('Fussnoten')"/>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
	<xsl:text>"N %Y.nfk&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>"N %Y.nfv&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>O&#10;</xsl:text>
    <xsl:text>I L=n&#10;</xsl:text>
    <xsl:text>i f=1 l=3 w=5&#10;</xsl:text>
    <xsl:for-each select="//(dtb:note|dtb:annotation)">
      <xsl:apply-templates/>
    </xsl:for-each>
    <xsl:text>&#10;O&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
    <xsl:text>"N %Y.fk&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>"N %Y.fv&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>I *=j L=j&#10;</xsl:text>
    <xsl:text>i f=3 l=1&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="$contraction = 2">
	<xsl:text>"* %Y.nfk&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>"* %Y.nfv&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dtb:note|dtb:annotation">
    <!-- Ignore notes and annotations. They are handled via the
	 references that point to them, i.e. noterefs and annorefs. -->
  </xsl:template>

  <xsl:template match="dtb:noteref|dtb:annoref">
    <xsl:if test="self::dtb:annoref">
      <!-- we want the content of an annoref -->
      <xsl:apply-templates/>
    </xsl:if>
    <xsl:variable name="note_number" select="count(preceding::dtb:noteref|preceding::dtb:annoref)+1"/>
    <xsl:value-of select="louis:translate(my:get-tables(.,local-name()), concat('*',string($note_number)))"/>
    <xsl:text>&#10;* &#10; </xsl:text>
  </xsl:template>

  <!-- If a noteref is followed by punctuation, the punctuation needs
       to come after the note_number and before the &#10;* &#10; -->
  <xsl:template match="dtb:noteref[my:starts-with-punctuation(string(my:following-textnode-within-block(.)))]|dtb:annoref[my:starts-with-punctuation(string(my:following-textnode-within-block(.)))]">
    <xsl:variable name="braille_tables" select="my:get-tables(.,local-name())"/>
    <xsl:if test="self::dtb:annoref">
      <!-- we want the content of an annoref -->
      <xsl:apply-templates/>
    </xsl:if>
    <xsl:variable name="note_number" select="count(preceding::dtb:noteref|preceding::dtb:annoref)+1"/>
    <xsl:value-of select="louis:translate($braille_tables, concat('*',string($note_number)))"/>
    <xsl:value-of select="louis:translate($braille_tables, concat('&#x250B;', substring-before(string(my:following-textnode-within-block(.)), ' ')))"/>
    <xsl:text>&#10;* &#10; </xsl:text>
  </xsl:template>
  
  <!-- Remove the punctuation in a text node if it follows a noteref/annoref, since the punctuation was handled by the noteref/annoref matcher -->
  <xsl:template match="text()[my:starts-with-punctuation(.) and my:preceding-textnode-within-block(.)[ancestor::dtb:noteref|ancestor::dtb:annoref]]" priority="100">
    <xsl:value-of select="louis:translate(my:get-tables(.,local-name()), substring-after(string(),' '))"/>
  </xsl:template>

  <xsl:template match="dtb:author">
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'AUTHOR'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:byline">
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'BYLINE'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ====== -->
  <!-- LINES  -->
  <!-- ====== -->

  <xsl:template match="dtb:linenum">
    <!-- make it "right justified" (assuming we only have two digits max) -->
    <xsl:if test="string-length(.) = 1">b</xsl:if>
    <xsl:value-of select="louis:translate(my:get-tables(.,'linenum'), string())" />
    <xsl:text>| </xsl:text>
  </xsl:template>

  <xsl:template match="dtb:linegroup">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'LINEGR'"/>
      <xsl:with-param name="indent" select="' '"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:linegroup[descendant::dtb:linenum or ancestor::dtb:poem//dtb:linenum]">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'LINEGR_LN'"/>
      <xsl:with-param name="indent" select="' '"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:line">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'LINE'"/>
      <xsl:with-param name="indent" select="' '"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template
      match="dtb:line[(following-sibling::dtb:line/dtb:linenum or
  	     preceding-sibling::dtb:line/dtb:linenum) and not(.//dtb:linenum)]">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'LINE'"/>
      <xsl:with-param name="indent" select="' | '"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:line[ancestor::dtb:poem//dtb:linenum and not(.//dtb:linenum)]" 
		priority="10">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'LINE'"/>
      <xsl:with-param name="indent" select="' | '"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:br">
    <xsl:text>u</xsl:text>
  </xsl:template>

  <!-- ======== -->
  <!-- SIDEBARS -->
  <!-- ======== -->

  <xsl:template match="dtb:sidebar">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'SIDEBAR'"/>
      <xsl:with-param name="indent" select="''"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="dtb:hd">
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'HD'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ========== -->
  <!-- REARMATTER -->
  <!-- ========== -->

  <xsl:template match="dtb:rearmatter">
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'REAR'"/>
      <xsl:with-param name="enable_class" select="false()"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ================ -->
  <!-- Ignored Elements -->
  <!-- ================ -->

  <xsl:template match="dtb:w|dtb:sent|dtb:q|dtb:kbd|dtb:bdo|dtb:title">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dtb:colgroup|dtb:col">
    <!-- ignore completely -->
  </xsl:template>

  <!-- ===== -->
  <!-- TITLE -->
  <!-- ===== -->

  <xsl:template match="dtb:poem//dtb:title">
    <xsl:value-of select="my:insert-element-changed-comment(name())"/>
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'HD'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ==================== -->
  <!-- COVERTITLE, DATELINE -->
  <!-- ==================== -->

  <!-- We treat covertitles and dateline the same as a p -->
  <xsl:template match="dtb:covertitle|dtb:dateline">
    <xsl:value-of select="my:insert-element-changed-comment(name())"/>
    <xsl:text>y P&#10; </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ========== -->
  <!-- BRIDGEHEAD -->
  <!-- ========== -->

  <xsl:template match="dtb:bridgehead">
    <xsl:call-template name="inline_macro">
      <xsl:with-param name="macro" select="'BRIDGE'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ======= -->
  <!-- ADDRESS -->
  <!-- ======= -->

  <xsl:template match="dtb:address">
    <xsl:value-of select="my:insert-element-changed-comment(name())"/>
    <xsl:call-template name="block_macro">
      <xsl:with-param name="macro" select="'LINEGR'"/>
      <xsl:with-param name="indent" select="' '"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ======= -->
  <!-- ACRONYM -->
  <!-- ======= -->

  <xsl:template match="dtb:acronym">
    <xsl:value-of select="my:insert-element-changed-comment(name())"/>
    <xsl:text> </xsl:text>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ========== -->
  <!-- SAMP, CITE -->
  <!-- ========== -->

  <xsl:template match="dtb:samp|dtb:cite">
    <xsl:if test="my:is-block-element(.)">    
      <xsl:value-of select="my:insert-element-changed-comment(name())"/>
      <xsl:text>y P&#10; </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ========================= -->
  <!-- STRONG, EM, BRL:EMPH, DFN -->
  <!-- ========================= -->

  <xsl:template match="dtb:strong|dtb:em|brl:emph|dtb:dfn">
    <xsl:if test="self::dtb:dfn">
      <!-- We treat dfn the same as a em but add a comment about the original markup-->
      <xsl:value-of select="my:insert-element-changed-comment(name())"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="." mode="translation"/>
  </xsl:template>
  
  <!-- ======= -->
  <!-- Links   -->
  <!-- ======= -->

  <xsl:template match="dtb:a">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ======= -->
  <!-- Div     -->
  <!-- ======= -->

  <xsl:template match="dtb:div">
    <xsl:value-of select="concat('&#10;y DIVb_', my:get-brl-class(.), '&#10;')"/>
    <xsl:apply-templates/>
    <xsl:value-of select="concat('&#10;y DIVe_', my:get-brl-class(.), '&#10;')"/>
  </xsl:template>
  
  <xsl:template match="dtb:span">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- ======= -->
  <!-- Volumes -->
  <!-- ======= -->

  <xsl:template match="brl:volume">
    <xsl:if test="@brl:grade = $contraction">
      <!-- Apply end notes -->
      <xsl:if test="$footnote_placement = 'end_vol'">
	<xsl:variable name="V" select="current()"/>
	<xsl:call-template name="handle_notes">
	  <xsl:with-param name="noterefs" select="$V/(preceding::dtb:noteref|preceding::dtb:annoref)[following::brl:volume[@brl:grade = $contraction][1] is $V]"/>
	</xsl:call-template>
      </xsl:if>
      <xsl:text>&#10;y EndVol&#10;</xsl:text>
      <!-- Handle volumes that have a pagenum immediately following -->
      <xsl:if test="following-sibling::*[position()=1 and local-name()='pagenum']">
	<xsl:text>p&#10;</xsl:text>
	<xsl:apply-templates select="following::dtb:pagenum[1]" mode="no-space-after"/>
      </xsl:if>
      <!-- Handle volumes that have a levelN/pagenum immediately following -->
      <xsl:variable name="following-level" select="following-sibling::*[position()=1 and substring(local-name(),0,6)='level']"/>
      <xsl:if test="exists($following-level) and $following-level/*[position()=1 and local-name()='pagenum']">
	<xsl:text>p&#10;</xsl:text>
	<xsl:apply-templates select="following::dtb:pagenum[1]" mode="no-space-after"/>
      </xsl:if>
      <xsl:text>y BrlVol&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dtb:*">
    <xsl:message> *****<xsl:value-of select="name(..)"/>/{<xsl:value-of select="namespace-uri()"
        />}<xsl:value-of select="name()"/>****** </xsl:message>
  </xsl:template>

</xsl:stylesheet>
