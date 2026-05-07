<?xml version="1.0" encoding="UTF-8"?>
<!--
  Convert a UTFX test file (test_xsl/*_test.xml) to XSpec format (src/test/xspec/*.xspec).

  Run with Saxon from the project root:
    java -jar lib/saxon9he.jar -xsl:tools/utfx2xspec.xsl -s:test_xsl/foo_test.xml \
         -o:src/test/xspec/foo_test.xspec -dtd:off

  The stylesheet path in the UTFX source (relative to project root, e.g. xsl/dtbook2sbsform.xsl)
  is rewritten to be relative to src/test/xspec/ (i.e. ../../../xsl/dtbook2sbsform.xsl).
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:utfx="http://utfx.org/test-definition"
  xmlns:x="http://www.jenitennison.com/xslt/xspec"
  exclude-result-prefixes="utfx">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="utfx:tests">
    <x:description>
      <!-- Carry over namespace bindings (dtb:, brl:, etc.) for use in context elements -->
      <xsl:for-each select="namespace::*[name() != 'utfx' and name() != 'xml']">
        <xsl:namespace name="{name()}" select="."/>
      </xsl:for-each>
      <xsl:attribute name="stylesheet">
        <xsl:value-of select="concat('../../../', utfx:stylesheet/@src)"/>
      </xsl:attribute>
      <xsl:apply-templates select="utfx:test"/>
    </x:description>
  </xsl:template>

  <xsl:template match="utfx:test">
    <x:scenario label="{normalize-space(utfx:name)}">
      <xsl:apply-templates select="utfx:stylesheet-params/utfx:with-param"/>
      <xsl:apply-templates select="utfx:assert-equal/utfx:source"/>
      <xsl:apply-templates select="utfx:assert-equal/utfx:expected"/>
    </x:scenario>
  </xsl:template>

  <xsl:template match="utfx:with-param">
    <x:param name="{@name}" select="{@select}"/>
  </xsl:template>

  <xsl:template match="utfx:source">
    <x:context>
      <xsl:copy-of select="node()"/>
    </x:context>
  </xsl:template>

  <xsl:template match="utfx:expected">
    <x:expect label="result">
      <xsl:copy-of select="node()"/>
    </x:expect>
  </xsl:template>

</xsl:stylesheet>
