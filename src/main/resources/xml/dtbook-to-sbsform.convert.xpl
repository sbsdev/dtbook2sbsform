<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:pxi="http://www.daisy.org/ns/pipeline/xproc/internal"
    xmlns:d="http://www.daisy.org/ns/pipeline/data"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:sbs="http://www.sbs.ch/pipeline"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-inline-prefixes="px pxi d sbs"
    type="sbs:dtbook-to-sbsform.convert" name="main" version="1.0">
    
    <p:input port="source" primary="true"/>
    <p:output port="fileset.out">
        <p:pipe step="fileset" port="result"/>
    </p:output>
    <p:output port="in-memory.out" sequence="true">
        <p:pipe step="sbsform" port="result"/>
    </p:output>
    
    <p:option name="output-dir" required="true"/>

    <p:option name="contraction" required="true"/>
    <p:option name="version" required="true"/>
    <p:option name="cells_per_line" required="true"/>
    <p:option name="lines_per_page" required="true"/>
    <p:option name="hyphenation" required="true"/>
    <p:option name="toc_level" required="true"/>
    <p:option name="footer_level" required="true"/>
    <p:option name="include_macros" required="true"/>
    <p:option name="show_original_page_numbers" required="true"/>
    <p:option name="show_v_forms" required="true"/>
    <p:option name="downshift_ordinals" required="true"/>
    <p:option name="enable_capitalization" required="true"/>
    <p:option name="detailed_accented_characters" required="true"/>
    <p:option name="footnote_placement" required="true"/>
    <p:option name="use_local_dictionary" required="true"/>
    <p:option name="document_identifier" required="true"/>
            
    <p:import href="utils/normalize-uri.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/fileset-utils/library.xpl"/>
    
    <pxi:normalize-uri>
        <p:with-option name="href" select="$output-dir"/>
    </pxi:normalize-uri>
    
    <px:fileset-create>
        <p:with-option name="base" select="string(c:result)"/>
    </px:fileset-create>
    
    <px:fileset-add-entry media-type="text/x-sbsform-g2" name="fileset">
        <p:with-option name="href" select="replace(base-uri(/*),'^.*/([^/]*)\.[^/\.]*$','$1.sbsform')">
            <p:pipe step="main" port="source"/>
        </p:with-option>
    </px:fileset-add-entry>
    <p:sink/>
    
    <p:identity>
        <p:input port="source">
            <p:pipe step="main" port="source"/>
        </p:input>
    </p:identity>
    
    <!-- ========= -->
    <!-- HYPHENATE -->
    <!-- ========= -->
    
    <p:choose>
        <p:when test="$hyphenation='true'">
            <p:xslt>
                <p:input port="stylesheet">
                    <p:document href="hyphenate.xsl"/>
                </p:input>
                <p:input port="parameters">
                    <p:empty/>
                </p:input>
            </p:xslt>
        </p:when>
        <p:otherwise>
            <p:identity/>
        </p:otherwise>
    </p:choose>
    
    <!-- ================== -->
    <!-- HANDLE DOWNGRADING -->
    <!-- ================== -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:document href="handle-downgrading.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    <!-- =============== -->
    <!-- HANDLE PRODNOTE -->
    <!-- =============== -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:document href="handle-prodnote.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    <!-- ========= -->
    <!-- TRANSLATE -->
    <!-- ========= -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet version="2.0">
                    <xsl:import href="dtbook2sbsform.xsl"/>
                    <xsl:template match="/">
                        <xsl:element name="c:data">
                            <xsl:attribute name="content-type" select="'text/x-sbsform-g2'"/>
                            <xsl:apply-imports/>
                        </xsl:element>
                    </xsl:template>
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:with-param name="_contraction" select="$contraction"/>
        <p:with-param name="_version" select="$version"/>
        <p:with-param name="_cells_per_line" select="$cells_per_line"/>
        <p:with-param name="_lines_per_page" select="$lines_per_page"/>
        <p:with-param name="_hyphenation" select="$hyphenation"/>
        <p:with-param name="_toc_level" select="$toc_level"/>
        <p:with-param name="_footer_level" select="$footer_level"/>
        <p:with-param name="_include_macros" select="$include_macros"/>
        <p:with-param name="_show_original_page_numbers" select="$show_original_page_numbers"/>
        <p:with-param name="_show_v_forms" select="$show_v_forms"/>
        <p:with-param name="_downshift_ordinals" select="$downshift_ordinals"/>
        <p:with-param name="_enable_capitalization" select="$enable_capitalization"/>
        <p:with-param name="_detailed_accented_characters" select="$detailed_accented_characters"/>
        <p:with-param name="_footnote_placement" select="$footnote_placement"/>
        <p:with-param name="_use_local_dictionary" select="$use_local_dictionary"/>
        <p:with-param name="_document_identifier" select="$document_identifier"/>
        <p:with-param name="TABLE_BASE_URI" select="file:/usr/local/share/liblouis/tables/"/>
    </p:xslt>
    
    <!-- ========== -->
    <!-- WRAP LINES -->
    <!-- ========== -->
    
    <p:xslt>
        <p:input port="stylesheet">
            <p:document href="linewrapper.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    
    <!-- ============== -->
    <!-- ADD MEDIA-TYPE -->
    <!-- ============== -->
    
    <p:add-attribute match="/*" attribute-name="xml:base" name="sbsform">
        <p:with-option name="attribute-value"
                       select="//d:file[@media-type='text/x-sbsform-g2']/resolve-uri(@href, base-uri(.))">
            <p:pipe step="fileset" port="result"/>
        </p:with-option>
    </p:add-attribute>
    
</p:declare-step>
