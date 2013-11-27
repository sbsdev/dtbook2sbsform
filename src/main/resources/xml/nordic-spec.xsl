<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="dtb">

  <!-- Handle extensions that are defined in the Nordic spec i.e. the
       "Requirements for Text and Image Quality and Markup with DTBook
       XML, Version: 2011-2" -->

  <!-- ========== -->
  <!-- Excercises -->
  <!-- ========== -->

  <!-- Excercise answers and boxes -->
  <xsl:template match="dtb:span[@class=('answer','box')]">
    <xsl:text>---</xsl:text>
  </xsl:template>

  <xsl:template match="dtb:span[@class='answer_1']">
    <xsl:text>-</xsl:text>
  </xsl:template>

</xsl:stylesheet>
