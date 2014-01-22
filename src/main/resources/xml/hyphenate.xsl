<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:hyphen="http://hunspell.sourceforge.net/Hyphen"
	xmlns:sbs="http://www.sbs.ch/pipeline"
	xmlns:pxi="http://www.daisy.org/ns/pipeline/xproc/internal"
	exclude-result-prefixes="#all">
	
	<xsl:import href="http://www.daisy.org/pipeline/modules/braille/libhyphen-utils/library.xsl"/>
	
	<xsl:variable name="TABLE_BASE_URI" as="xs:string" select="'http://www.sbs.ch/pipeline/hyphen/'"/>
	
	<xsl:template match="/*|*[@xml:lang]" priority="1">
		<xsl:next-match>
			<xsl:with-param name="table" select="pxi:get-table(@xml:lang)" tunnel="yes"/>
		</xsl:next-match>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:param name="table" as="xs:string" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="not(name(parent::*)=('abbr','h1','h2','h3','h4','h5','h6','code','sup',
			                                     'sub','th','td','running-line','literal','num'))">
				<xsl:sequence select="hyphen:hyphenate($table, string(.))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:sequence select="."/>
	</xsl:template>
	
	<xsl:function name="pxi:get-table">
		<xsl:param name="lang" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="$lang=('en', 'de','de-CH','de_CH','de-DE','de_DE')">
				<xsl:value-of select="resolve-uri('hyph_de_DE.dic', $TABLE_BASE_URI)"/>
			</xsl:when>
			<xsl:when test="$lang=('de-1901','de_1901')">
				<xsl:value-of select="resolve-uri('hyph_de_DE_OLDSPELL.dic', $TABLE_BASE_URI)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:value-of select="concat('No hyphenation table found that matches xml:lang=&quot;', $lang, '&quot;')"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
</xsl:stylesheet>
