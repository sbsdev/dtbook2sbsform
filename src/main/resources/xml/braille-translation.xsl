<?xml version="1.0" encoding="utf-8"?>

<!-- Copyright (C) 2015 Swiss Library for the Blind, Visually Impaired and Print Disabled -->

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

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
    xmlns:louis="http://liblouis.org/liblouis"
    xmlns:brl="http://www.daisy.org/z3986/2009/braille/"
    xmlns:my="http://my-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="dtb louis my" extension-element-prefixes="my">

  <!-- ======= -->
  <!-- SUB/SUP -->
  <!-- ======= -->

  <!-- bei brl:select wird kein Zeichen gesetzt -->
  <xsl:template match="dtb:sup[descendant::brl:select]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Ziffern bekommen das Exponentzeichen und werden tiefgestellt -->
  <xsl:template match="dtb:sup[matches(., '^[-]*\d+$')]">
      <xsl:variable name="braille_tables">
        <xsl:call-template name="getTable">
          <xsl:with-param name="context" select="'index'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of
	  select="my:louis-translate(string($braille_tables),concat('&#x257E;',string()))" />
  </xsl:template>

  <!-- alles andere bekommt das Zeichen für den oberen Index -->
  <xsl:template match="dtb:sup">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of
	select="my:louis-translate(string($braille_tables),'&#x2580;')" />
    <xsl:apply-templates/>
  </xsl:template>

  <!-- bei brl:select wird kein Zeichen gesetzt -->
  <xsl:template match="dtb:sub[descendant::brl:select]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Ziffern bekommen das Zeichen für den unteren Index und werden tiefgestellt -->
  <xsl:template match="dtb:sub[matches(., '^[-]*\d+$')]">
      <xsl:variable name="braille_tables">
        <xsl:call-template name="getTable">
          <xsl:with-param name="context" select="'index'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of
	  select="my:louis-translate(string($braille_tables),concat('&#x2581;',string()))" />
  </xsl:template>

  <!-- alles andere bekommt das Zeichen für den unteren Index -->
  <xsl:template match="dtb:sub">
      <xsl:variable name="braille_tables">
        <xsl:call-template name="getTable"/>
      </xsl:variable>
      <xsl:value-of
	  select="my:louis-translate(string($braille_tables),'&#x2581;')" />
      <xsl:apply-templates/>
  </xsl:template>

  <!-- ==== -->
  <!-- CODE -->
  <!-- ==== -->

  <xsl:template match="dtb:code[matches(.,'\s')]">
    <!-- Multi-word code -->
    <xsl:value-of select="my:louis-translate('sbs.dis,sbs-special.cti,sbs-code.cti', concat('&#x2588;',string(),'&#x2589;'))"/>
  </xsl:template>

  <xsl:template match="dtb:code">
    <xsl:value-of select="my:louis-translate('sbs.dis,sbs-special.cti,sbs-code.cti', concat('&#x257C;',string()))"/>
  </xsl:template>

  <!-- ================ -->
  <!-- Computer Braille -->
  <!-- ================ -->

  <xsl:template match="brl:computer">
    <xsl:value-of select="my:louis-translate(string($computer_braille_tables), '&#x257C;')"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="brl:computer/text()">
    <xsl:value-of select="my:louis-translate(string($computer_braille_tables), string())"/>
  </xsl:template>

  <!-- ======= -->
  <!-- Abbrevs -->
  <!-- ======= -->

  <!-- don't call handle_abbr from a for-each! As it will redefine the context and getTable will fail when calling local-name() -->
  <xsl:template name="handle_abbr">
    <xsl:param name="context" select="local-name()"/>
    <xsl:param name="content" select="."/>
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="$context"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="temp">
      <xsl:choose>
        <xsl:when test="my:containsDot($content)">
          <!-- drop all whitespace -->
          <xsl:for-each select="tokenize(string($content), '\s+')">
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="outerTokens" select="my:tokenizeForAbbr(normalize-space($content))"/>
          <xsl:for-each select="$outerTokens">
            <xsl:choose>
              <xsl:when test="not(my:isLetter(substring(.,1,1)))">
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="innerTokens" select="my:tokenizeByCase(.)"/>
                <xsl:for-each select="$innerTokens">
                  <xsl:variable name="i" select="position()"/>
                  <xsl:choose>
                    <xsl:when test="my:isUpper(substring(.,1,1))">
                      <xsl:choose>
                        <xsl:when test="string-length(.) &gt; 1"><xsl:value-of select="$GROSS_FUER_BUCHSTABENFOLGE"/></xsl:when>
                        <xsl:otherwise>
                          <!-- string-length(.) == 1 -->
                          <xsl:choose>
                            <xsl:when test="position()=last()"><xsl:value-of select="$GROSS_FUER_BUCHSTABENFOLGE"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$GROSS_FUER_EINZELBUCHSTABE"/></xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- lowercase letters -->
                      <xsl:if test="position()=1 or (string-length($innerTokens[$i - 1]) &gt; 1 and my:isUpper(substring($innerTokens[$i - 1],1,1)))"><xsl:value-of select="$KLEINBUCHSTABE"/></xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <!-- If the last letter was a capital and the following letter is small, insert a KLEINBUCHSTABE -->
      <xsl:if test="matches(string($content), '.*\p{Lu}$') and
                    $content/following-sibling::node()[1][self::text()] and
                    matches(string($content/following-sibling::node()[1]), '^\p{Ll}.*')">
        <xsl:value-of select="$KLEINBUCHSTABE"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string($temp))"/>
  </xsl:template>
  
  <xsl:template match="dtb:abbr">
    <xsl:call-template name="handle_abbr"/>
  </xsl:template>

  <!-- ================= -->
  <!-- Contraction hints -->
  <!-- ================= -->

  <xsl:template match="brl:num[@role='ordinal']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'num_ordinal'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$downshift_ordinals = true()">
        <xsl:value-of select="my:louis-translate(string($braille_tables), string(translate(.,'.','')))"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:num[@role='roman']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'num_roman'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="my:isUpper(substring(.,1,1))">
        <!-- we assume that if the first char is uppercase the rest is also uppercase -->
        <xsl:value-of select="my:louis-translate(string($braille_tables),concat('&#x2566;',string()))"
        />
      </xsl:when>
      <xsl:otherwise>
        <!-- presumably the roman number is in lower case -->
        <xsl:value-of select="my:louis-translate(string($braille_tables),concat('&#x2569;',string()))"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:num[@role='phone']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <!-- Replace ' ' and '/' with '.' -->
    <xsl:variable name="clean_number">
      <xsl:for-each select="tokenize(string(.), '(\s|/)+')">
        <xsl:value-of select="."/>
        <xsl:if test="not(position() = last())">.</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables),string($clean_number))"/>
  </xsl:template>

  <xsl:template match="brl:num[@role='fraction']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="downshift_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'denominator'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="numerator" select="(tokenize(string(.), '(\s|/)+'))[position()=1]"/>
    <xsl:variable name="denominator" select="(tokenize(string(.), '(\s|/)+'))[position()=2]"/>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string($numerator))"/>
    <xsl:value-of select="my:louis-translate(string($downshift_braille_tables), string($denominator))"
    />
  </xsl:template>

  <xsl:template match="brl:num[@role='mixed']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="downshift_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'denominator'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="number" select="(tokenize(string(.), '(\s|/)+'))[position()=1]"/>
    <xsl:variable name="numerator" select="(tokenize(string(.), '(\s|/)+'))[position()=2]"/>
    <xsl:variable name="denominator" select="(tokenize(string(.), '(\s|/)+'))[position()=3]"/>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string($number))"/>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string($numerator))"/>
    <xsl:value-of select="my:louis-translate(string($downshift_braille_tables), string($denominator))"
    />
  </xsl:template>

  <xsl:template match="brl:num[@role='measure']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>

    <!-- For all number-unit combinations, e.g. 1 kg, 10 km, etc. drop the space -->
    <xsl:variable name="tokens" select="tokenize(normalize-space(string(.)), '\s+')"/>
    <xsl:variable name="number" select="$tokens[1]"/>
    <xsl:variable name="measure" select="$tokens[position()=last()]"/>

    <xsl:value-of select="my:louis-translate(string($braille_tables), string($number))"/>
    <xsl:call-template name="handle_abbr">
      <xsl:with-param name="context" select="'abbr'"/>
      <xsl:with-param name="content" as="text()">
        <xsl:value-of select="$measure"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="brl:num[@role='isbn']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="abbr_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'abbr'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lastChar" select="substring(.,string-length(.),1)"/>
    <xsl:variable name="secondToLastChar" select="substring(.,string-length(.)-1,1)"/>
    <xsl:choose>
      <!-- If the isbn number ends in a capital letter then keep the
           dash, mark the letter with &#x2566; and translate the
           letter with abbr -->
      <xsl:when
        test="$secondToLastChar='-' and string(number($lastChar))='NaN' and my:isUpper($lastChar)">
        <xsl:variable name="clean_number">
          <xsl:for-each select="tokenize(substring(.,1,string-length(.)-2), '(\s|-)+')">
            <xsl:value-of select="string(.)"/>
            <xsl:if test="not(position() = last())">.</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="my:louis-translate(string($braille_tables),string($clean_number))"/>
        <xsl:value-of select="my:louis-translate(string($braille_tables),$secondToLastChar)"/>
        <xsl:value-of
          select="my:louis-translate(string($abbr_braille_tables),concat('&#x2566;',$lastChar))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="clean_number">
          <xsl:for-each select="tokenize(string(.), '(\s|-)+')">
            <xsl:value-of select="string(.)"/>
            <xsl:if test="not(position() = last())">.</xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="my:louis-translate(string($braille_tables),string($clean_number))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:name">
    <xsl:variable name="braille_tables">
      <xsl:choose>
        <xsl:when test="matches(., '\p{Ll}&#x00AD;?\p{Lu}')">
          <xsl:call-template name="getTable">
            <xsl:with-param name="context" select="'name_capitalized'"/>
          </xsl:call-template> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="getTable"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string())"/>
  </xsl:template>
  
  <xsl:template match="brl:place">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables),string())"/>
  </xsl:template>

  <xsl:template match="brl:v-form">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$show_v_forms = true()">
        <xsl:value-of select="my:louis-translate(string($braille_tables), concat(upper-case(substring(string(),1,1)),lower-case(substring(string(),2))))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="brl:separator">
    <!-- ignore -->
  </xsl:template>

  <xsl:template match="brl:homograph">
    <!-- Join all text elements with a special marker and send the
         whole string to liblouis -->
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="text">
      <xsl:for-each select="text()">
        <!-- simply ignore the separator elements -->
        <xsl:value-of select="string(.)"/>
        <xsl:if test="not(position() = last())">&#x250A;</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string($text))"/>
  </xsl:template>

  <xsl:template match="brl:date">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="day_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'date_day'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="month_braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'date_month'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:for-each select="tokenize(string(@value), '-')">
      <!-- reverse the order, so we have day, month, year -->
      <xsl:sort select="position()" order="descending" data-type="number"/>
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:value-of
            select="my:louis-translate(string($day_braille_tables), format-number(. cast as xs:integer,'#'))"
          />
        </xsl:when>
        <xsl:when test="position() = 2">
          <xsl:value-of
            select="my:louis-translate(string($month_braille_tables), format-number(. cast as xs:integer,'#'))"
          />
        </xsl:when>
        <xsl:otherwise>
	  <xsl:if test="matches(string(.), '\d+')">
	    <xsl:value-of
		select="my:louis-translate(string($braille_tables), format-number(. cast as xs:integer,'#'))"/>
	  </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="brl:time">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:variable name="time">
      <xsl:for-each select="tokenize(string(@value), ':')">
	<xsl:choose>
	  <!-- Drop the leading zero for the hours and append a dot -->
	  <xsl:when test="not(position() = last())">
	    <xsl:value-of select="format-number(. cast as xs:integer,'#')"/>
	    <xsl:text>.</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string($time))"/>
  </xsl:template>

  <!-- ================= -->
  <!-- Content selection -->
  <!-- ================= -->
  
  <xsl:template match="brl:select">
    <xsl:apply-templates select="brl:when-braille"/>
    <!-- Ignore the brl:otherwise element -->
  </xsl:template>

  <xsl:template match="brl:when-braille">
    <xsl:apply-templates />
    <!-- Ignore the brl:otherwise element -->
  </xsl:template>

  <xsl:template match="brl:literal">
    <xsl:if test="not(exists(@brl:grade)) or (exists(@brl:grade) and @brl:grade  = $contraction)">
      <xsl:value-of select="."/>
    </xsl:if>
  </xsl:template>

  <!-- ======================================= -->
  <!-- Text nodes are translated with liblouis -->
  <!-- ======================================= -->

  <!-- ========================================== -->
  <!-- Comma after ordinals, fraction and sub/sup -->
  <!-- ========================================== -->
  <xsl:template
    match="text()[(preceding::* intersect my:preceding-textnode-within-block(.)/(ancestor::brl:num[@role=('ordinal','fraction','mixed')]|ancestor::dtb:sub|ancestor::dtb:sup)) and matches(string(), '^,')]" priority="100">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat('&#x256C;',string()))"/>
  </xsl:template>

  <!-- ============================================= -->
  <!-- Punctuation after a number and after ordinals -->
  <!-- ============================================= -->
  <xsl:template
    match="text()[my:starts-with-punctuation(string()) and not(preceding::* intersect my:preceding-textnode-within-block(.)/ancestor::*[@brl:render=('quote','singlequote')])
    and (my:ends-with-number(string(my:preceding-textnode-within-block(.))) or (preceding::* intersect my:preceding-textnode-within-block(.)/(ancestor::brl:num[@role='ordinal']|ancestor::brl:date)))]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat('&#x250B;',string()))"/>
  </xsl:template>

  <!-- ========================================== -->
  <!-- Apostrophe after v-form or after homograph -->
  <!-- ========================================== -->
  <xsl:template
    match="text()[(preceding::* intersect my:preceding-textnode-within-block(.)/(ancestor::brl:v-form|ancestor::brl:homograph)) and matches(string(), '^''')]" priority="100">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat('&#x250A;',string()))"/>
  </xsl:template>

  <!-- ================================================= -->
  <!-- Single word mixed emphasis, mixed emphasis before-->
  <!-- ================================================= -->
  <xsl:template
    match="text()[my:starts-with-word(string()) and my:ends-with-word(string(my:preceding-textnode-within-block(.)[ancestor::dtb:em]))]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat('&#x250A;',string()))"/>
  </xsl:template>

  <!-- ================================================ -->
  <!-- Single word mixed emphasis, mixed emphasis after -->
  <!-- ================================================ -->
  <xsl:template
    match="text()[my:ends-with-word(string()) and my:starts-with-word(string(my:following-textnode-within-block(.)[ancestor::dtb:em]))]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat(string(),'&#x250A;'))"/>
  </xsl:template>
  
  <!-- ====================== -->
  <!-- Single word mixed abbr -->
  <!-- ====================== -->
  <xsl:template
    match="text()[my:starts-with-word(string()) and not(my:starts-with-number(string())) and my:ends-with-word(string(my:preceding-textnode-within-block(.)[ancestor::dtb:abbr]))]">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat('&#x250A;',string()))"/>
  </xsl:template>

  <!-- ============================================================================= -->
  <!-- 'ich' inside text node followed by chars that could be interpreted as numbers -->
  <!-- ============================================================================= -->
  <xsl:template
    match="text()[(matches(string(), '^ich$', 'i') or matches(string(), '\Wich$', 'i')) and matches(string(following::text()[1]), '^[,;:?!)&#x00bb;&#x00ab;]')]" priority="100">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), concat(string(),'&#x250A;'))"/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable"/>
    </xsl:variable>
    <xsl:value-of select="my:louis-translate(string($braille_tables), string())"/>
  </xsl:template>

</xsl:stylesheet>