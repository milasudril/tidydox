<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" method="html" encoding="utf-8"/>

<xsl:template match="node()|@*">
<!--Default rule is identy-->
<xsl:copy>
<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:template>

<xsl:template match="g">
	<xsl:apply-templates/><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="author">
<address><xsl:apply-templates/> <xsl:value-of select="@surname"/><xsl:text> </xsl:text><xsl:value-of select="@year"/></address>
</xsl:template>

<xsl:template match="item[@type='stylesheet']">
<link rel="stylesheet" type="text/css">
<xsl:attribute name="href"><xsl:value-of select="@source"/></xsl:attribute>
</link>
</xsl:template>


<xsl:template match="docset">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html>
<head>
<meta charset="utf-8" />
<title><xsl:value-of select="concat(document($docparams)/docparams/project/@title,': ',h1)"/></title>
<xsl:apply-templates select="document($docparams)/docparams/resources/item[@type='stylesheet']"/>
</head>
<body>
<header>
<div class="logo"><xsl:value-of select="document($docparams)/docparams/project/@title"/></div>
<nav>
<ul>
<xsl:if test="not(@type='mainpage')">
	<li><a href="index.html"><xsl:value-of select="document($docparams)/docparams/project/@title"/></a></li>
</xsl:if>
<xsl:if test="not(@type='mainpage' or @type='apiref')">
	<li><a href="apiref.html">API reference</a></li>
</xsl:if>
<xsl:if test="not(@type='index' or @type='mainpage' or @type='apiref')">
<li>
<xsl:choose>
<xsl:when test="@type='class'">
<a href="classes.html">Classes</a>
</xsl:when>
<xsl:when test="@type='struct'">
<a href="structs.html">Structs</a>
</xsl:when>
<xsl:when test="@type='namespace'">
<a href="namespaces.html">Namespaces</a>
</xsl:when>
<xsl:when test="@type='file'">
<a href="files.html">Files</a>
</xsl:when>
</xsl:choose>
</li>
</xsl:if>
</ul>
</nav>
</header>
<main>
<xsl:apply-templates />
</main>
<footer>
<xsl:apply-templates select="document($docparams)/docparams/project/author"/>
</footer>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
