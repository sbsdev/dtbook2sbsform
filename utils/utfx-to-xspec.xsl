<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:utfx="http://utfx.org/test-definition"
                xmlns:x="http://www.jenitennison.com/xslt/xspec"
                xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
                xmlns:brl="http://www.daisy.org/z3986/2009/braille/"
                exclude-result-prefixes="xs xsl">
	
	<xsl:param name="project_home" as="xs:string"/>
	<xsl:param name="test_name" as="xs:string"/>
	
	<xsl:template match="/">
		<xsl:message>
			<xsl:sequence select="concat('Generating test ', $test_name, '.xspec')"/>
		</xsl:message>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<xsl:template match="/utfx:tests">
		<xsl:variable name="stylesheet_params" as="xs:string*"
		              select="distinct-values(/utfx:tests/utfx:test/utfx:stylesheet-params/utfx:with-param/@name)"/>
		<xsl:for-each-group select="utfx:test"
		                    group-by="string-join(
		                                for $name in $stylesheet_params return
		                                  if (utfx:stylesheet-params/utfx:with-param[@name=$name])
		                                    then concat($name, '=', utfx:stylesheet-params/utfx:with-param[@name=$name]/@select)
		                                    else (),
		                                ', ')">
			<xsl:result-document method="xml" encoding="utf-8" indent="no"
			                     href="{if (last() &gt; 1)
			                              then resolve-uri(concat('src/test/xspec/', $test_name, '_', position(), '.xspec'), $project_home)
			                              else resolve-uri(concat('src/test/xspec/', $test_name, '.xspec'), $project_home)}">
				<xsl:text>&#xA;</xsl:text>
				<x:description stylesheet="{resolve-uri(concat('src/main/resources/xml/',
				                            replace(/utfx:tests/utfx:stylesheet/@src, '^xsl/', '')), $project_home)}">
					<xsl:text>&#xA;&#xA;    </xsl:text>
					<xsl:comment>&#xA;      This XSpec test was automatically generated from a UTF-X test&#xA;    </xsl:comment>
					<xsl:text>&#xA;&#xA;</xsl:text>
					<xsl:for-each select="tokenize(current-grouping-key(), ',\s')">
						<xsl:text>    </xsl:text>
						<x:param name="{substring-before(., '=')}" select="{substring-after(., '=')}"/>
						<xsl:text>&#xA;</xsl:text>
					</xsl:for-each>
					<xsl:text>&#xA;</xsl:text>
					<xsl:apply-templates select="current-group()"/>
				</x:description>
			</xsl:result-document>
		</xsl:for-each-group>
	</xsl:template>
	
	<xsl:template match="utfx:test">
		<xsl:text>    </xsl:text>
		<x:scenario label="{utfx:name}">
			<xsl:text>&#xA;</xsl:text>
			<xsl:apply-templates select="utfx:assert-equal"/>
			<!--<xsl:apply-templates select="utfx:call-template|utfx:assert-equal"/>-->
			<xsl:text>    </xsl:text>
		</x:scenario>
		<xsl:text>&#xA;&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="utfx:call-template">
		<xsl:text>      </xsl:text>
		<x:call template="{string(@name)}"/>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="utfx:assert-equal">
		<xsl:apply-templates select="utfx:source|utfx:expected"/>
	</xsl:template>
	
	<xsl:template match="utfx:source">
		<xsl:text>      </xsl:text>
		<x:context>
			<xsl:text>&#xA;        </xsl:text>
			<xsl:sequence select="*"/>
			<xsl:text>&#xA;      </xsl:text>
		</x:context>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="utfx:expected">
		<xsl:text>      </xsl:text>
		<x:expect label="braille">
			<xsl:sequence select="node()"/>
		</x:expect>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>
