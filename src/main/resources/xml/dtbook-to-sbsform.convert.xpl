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
    <p:option name="output-dir" required="true"/>
    <p:output port="fileset.out">
        <p:pipe step="fileset" port="result"/>
    </p:output>
    <p:output port="in-memory.out" sequence="true">
        <p:pipe step="sbsform" port="result"/>
    </p:output>
    
    <p:import href="utils/normalize-uri.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/fileset-utils/xproc/fileset-library.xpl"/>
    
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
                    <!-- TODO: getTable: disable hyphenation for certain elements -->
                    <!--
                    -->
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
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
