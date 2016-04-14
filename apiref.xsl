<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="str">

<xsl:output indent="yes" method="xml" encoding="utf-8"/>

<xsl:template match="node()|@*">
<!--Default rule is identy-->
<xsl:copy>
<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:template>

<xsl:template match="project">
<h1 id="top"><xsl:value-of select="@title"/> API reference</h1>
</xsl:template>

<xsl:template match="item">
<li><a><xsl:attribute name="href"><xsl:value-of select="@page"/></xsl:attribute><xsl:apply-templates/></a></li>
</xsl:template>

<xsl:template match="apisections">
<section>
<p>This is the API reference for the <xsl:value-of select="/docparams/project/@title"/> project.</p>
<ul>
<xsl:apply-templates/>
</ul>
</section>
</xsl:template>

<xsl:template match="docparams">
<docset type="apiref">
<xsl:apply-templates/>
</docset>
</xsl:template>

</xsl:stylesheet>
