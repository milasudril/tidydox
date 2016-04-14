<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" method="text" omit-xml-declaration="yes" encoding="utf-8"/>
<xsl:strip-space elements="*"/>

<xsl:template match="item">
<xsl:value-of select="@source"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="docparams">
<xsl:apply-templates select="resources"/>
</xsl:template>
</xsl:stylesheet>
