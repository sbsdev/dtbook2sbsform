<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all">
	
	<!--
	    Normalization of the dtbook2sbsform output.
	    
	    * Fill lines to a maximum of 80 characters
	    * Break lines on word boundaries
	    * Hang-indent wrapped lines with a blank
	    * Preserve newlines
	    * Collapse all other whitespace into a single blank
	    * Drop trailing whitespace
	-->
	
	<xsl:param name="FILL_COLUMN" as="xs:integer" select="80"/>
	
	<xsl:template match="/*">
		<xsl:copy>
			<xsl:sequence select="@*"/>
			<xsl:call-template name="wrap-lines"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="wrap-lines">
		<xsl:param name="text" as="xs:string" select="string(.)"/>
		<xsl:for-each select="tokenize($text, '\n')">
			<xsl:choose>
				<xsl:when test="starts-with(., ' ')">
					<xsl:call-template name="wrap-line">
						<xsl:with-param name="chunks" select="tokenize(normalize-space(.), ' ')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="'&#xA;'"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="wrap-line">
		<xsl:param name="chunks" as="xs:string*"/>
		<xsl:param name="col" as="xs:integer" select="0"/>
		<xsl:if test="exists($chunks)">
			<xsl:variable name="chunk" as="xs:string" select="$chunks[1]"/>
			<xsl:variable name="rest" as="xs:string*" select="$chunks[position() &gt; 1]"/>
			<xsl:variable name="chunk_len" as="xs:integer" select="string-length($chunk)"/>
			<xsl:choose>
				<xsl:when test="$col &gt; 0 and $col + $chunk_len &gt;= $FILL_COLUMN">
					<xsl:value-of select="concat('&#xA; ', $chunk)"/>
					<xsl:call-template name="wrap-line">
						<xsl:with-param name="chunks" select="$rest"/>
						<xsl:with-param name="col" select="1 + $chunk_len"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(' ', $chunk)"/>
					<xsl:call-template name="wrap-line">
						<xsl:with-param name="chunks" select="$rest"/>
						<xsl:with-param name="col" select="$col + 1 + $chunk_len"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
