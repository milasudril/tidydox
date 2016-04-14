<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" method="xml" encoding="utf-8"/>

<xsl:strip-space elements="*" />
<xsl:preserve-space elements="codeline programlisting highlight" />
<xsl:param name="kind" />
<xsl:param name="title" />

<xsl:template match="node()|@*">
<!--Default rule is identy-->
<xsl:copy>
<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:template>

<xsl:template match="doxygenindex">
<docset type="index">
<h1 id="top"><xsl:value-of select="$title" /></h1>
<table class="memberdecls">
<xsl:apply-templates select="compound[@kind=$kind]"/>
</table>
</docset>
</xsl:template>

<xsl:template match="compound">
<tr><th class="membername">
<a>
<xsl:attribute name="href">
<xsl:value-of select="@refid"/>.html</xsl:attribute>
<xsl:apply-templates select="name"/></a></th>
<td><xsl:apply-templates select="document(concat(@refid,'.xml'))/doxygen/compounddef[1]/briefdescription" /></td>
</tr>
</xsl:template>

</xsl:stylesheet>
