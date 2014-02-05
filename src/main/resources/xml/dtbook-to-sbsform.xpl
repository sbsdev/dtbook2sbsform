<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
    xmlns:sbs="http://www.sbs.ch/pipeline"
    exclude-inline-prefixes="#all"
    type="sbs:dtbook-to-sbsform" name="dtbook-to-sbsform" version="1.0">
    
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <h1 px:role="name">DTBook to SBSForm</h1>
        <p px:role="desc">Transforms a DTBook (DAISY 3 XML) document into SBSForm.</p>
        <dl px:role="author">
            <dt>Name:</dt>
            <dd px:role="name">Bert Frees</dd>
            <dt>Organization:</dt>
            <dd px:role="organization" href="http://www.sbs.ch">SBS</dd>
            <dt>E-mail:</dt>
            <dd><a px:role="contact" href="mailto:bert.frees@sbs.ch">bert.frees@sbs.ch</a></dd>
        </dl>
    </p:documentation>
    
    <p:input port="source" primary="true" px:name="source" px:media-type="application/x-dtbook+xml">
        <p:documentation>
            <h2 px:role="name">source</h2>
            <p px:role="desc">Input DTBook.</p>
        </p:documentation>
    </p:input>
    
    <p:option name="output-dir" required="true" px:output="result" px:type="anyDirURI">
        <p:documentation>
            <h2 px:role="name">output-dir</h2>
            <p px:role="desc">Directory for storing result files.</p>
        </p:documentation>
    </p:option>
    
    <p:option name="contraction" required="false" px:type="integer" select="'2'"/>
    <p:option name="version" required="false" px:type="string" select="'0'"/>
    <p:option name="cells_per_line" required="false" px:type="integer" select="'28'"/>
    <p:option name="lines_per_page" required="false" px:type="integer" select="'28'"/>
    <p:option name="hyphenation" required="false" px:type="boolean" select="'false'">
        <p:documentation>
            <h2 px:role="name">hyphenation</h2>
            <p px:role="desc">Whether to perform hyphenation or not.</p>
        </p:documentation>
    </p:option>
    <p:option name="toc_level" required="false" px:type="integer" select="'0'"/>
    <p:option name="footer_level" required="false" px:type="integer" select="'0'"/>
    <p:option name="show_original_page_numbers" required="false" px:type="boolean" select="'true'"/>
    <p:option name="show_v_forms" required="false" px:type="boolean" select="'true'"/>
    <p:option name="downshift_ordinals" required="false" px:type="boolean" select="'true'"/>
    <p:option name="enable_capitalization" required="false" px:type="boolean" select="'false'"/>
    <p:option name="detailed_accented_characters" required="false" px:type="string" select="'de-accents-ch'"/>
    <p:option name="include_macros" required="false" px:type="boolean" select="'true'"/>
    <p:option name="footnote_placement" required="false" px:type="string" select="'standard'"/>
    <p:option name="use_local_dictionary" required="false" px:type="boolean" select="'false'"/>
    <p:option name="document_identifier" required="false" px:type="string" select="''"/>

    <p:import href="dtbook-to-sbsform.convert.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/fileset-utils/library.xpl"/>
    
    <!-- ========================= -->
    <!-- CONVERT DTBOOK TO SBSFORM -->
    <!-- ========================= -->
    
    <sbs:dtbook-to-sbsform.convert name="sbsform">
        <p:input port="source">
            <p:pipe step="dtbook-to-sbsform" port="source"/>
        </p:input>
        <p:with-option name="output-dir" select="$output-dir">
            <p:empty/>
        </p:with-option>

        <p:with-option name="contraction" select="$contraction"/>
        <p:with-option name="version" select="$version"/>
        <p:with-option name="cells_per_line" select="$cells_per_line"/>
        <p:with-option name="lines_per_page" select="$lines_per_page"/>
        <p:with-option name="hyphenation" select="$hyphenation"/>
        <p:with-option name="toc_level" select="$toc_level"/>
        <p:with-option name="footer_level" select="$footer_level"/>
        <p:with-option name="include_macros" select="$include_macros"/>
        <p:with-option name="show_original_page_numbers" select="$show_original_page_numbers"/>
        <p:with-option name="show_v_forms" select="$show_v_forms"/>
        <p:with-option name="downshift_ordinals" select="$downshift_ordinals"/>
        <p:with-option name="enable_capitalization" select="$enable_capitalization"/>
        <p:with-option name="detailed_accented_characters" select="$detailed_accented_characters"/>
        <p:with-option name="footnote_placement" select="$footnote_placement"/>
        <p:with-option name="use_local_dictionary" select="$use_local_dictionary"/>
        <p:with-option name="document_identifier" select="$document_identifier"/>
    </sbs:dtbook-to-sbsform.convert>
    
    <!-- ===================== -->
    <!-- STORE SBSFORM FILESET -->
    <!-- ===================== -->
    
    <px:fileset-store>
        <p:input port="fileset.in">
            <p:pipe step="sbsform" port="fileset.out"/>
        </p:input>
        <p:input port="in-memory.in">
            <p:pipe step="sbsform" port="in-memory.out"/>
        </p:input>
    </px:fileset-store>
    
</p:declare-step>
