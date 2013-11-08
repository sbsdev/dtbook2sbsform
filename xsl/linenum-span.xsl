<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:louis="http://liblouis.org/liblouis"
		xmlns:my="http://my-functions"
		exclude-result-prefixes="dtb my">

  <!-- span@class='linenum' is a prorietary extension to dtbook if you
       will that should enable the markup of books where the whole
       book contains of numbered lines (inside paragraphs mostly).
       This is very tedious to markup with linegroup as they are still
       basically paragraphs. So the span@class='linenum' is modeled
       somewhat after the pagenum element. It is placed where there is
       a linenumber. -->

  <xsl:template match="dtb:span[@class='linenum']">
    <xsl:variable name="braille_tables">
      <xsl:call-template name="getTable">
        <xsl:with-param name="context" select="'linenum'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="preceding-sibling::dtb:* or
		  preceding-sibling::text()[not(normalize-space(string())='')]">
      <xsl:text>&#10;y P_LN_noi&#10; </xsl:text>
    </xsl:if>
    <!-- make it "right justified" (assuming we only have two digits max) -->
    <xsl:if test="string-length(.) = 1">b</xsl:if>
    <xsl:value-of select="louis:translate($braille_tables, string())" />
    <xsl:text>| </xsl:text>
  </xsl:template>

 <xsl:template match="dtb:p[child::dtb:span[@class='linenum']]">
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="contains(@class, 'precedingseparator')">
      <xsl:text>y SEPARATOR&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="contains(@class, 'precedingemptyline')">
      <xsl:text>y BLANK&#10;</xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="contains(@class, 'noindent')">
        <xsl:text>y P_LN_noi&#10; </xsl:text>
      </xsl:when>
      <xsl:when test="my:has-brl-class(.)">
        <xsl:text>xxx FIXME: P with brl:class and span linenum not supported&#10;</xsl:text>
        <xsl:text>y P_LN&#10; </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>y P_LN&#10; </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!-- first child is not a dtb:span@class='linenum' -->
    <xsl:if test="dtb:span[@class='linenum'][1][preceding-sibling::dtb:* or preceding-sibling::text()[not(normalize-space(string())='')]]">
      <xsl:text>| </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
