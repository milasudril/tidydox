<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	exclude-result-prefixes="str">

<xsl:output indent="yes" method="xml" encoding="utf-8"/>


<xsl:strip-space elements="*" />
<xsl:preserve-space elements="codeline programlisting highlight verbatim" />

<xsl:template match="node()|@*">
<!--Default rule is identy-->
<xsl:copy>
<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:template>

<xsl:template match="doxygen">
<!--Strip "doxygen" element -->
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="compounddef">
<!--This is the main content of the paage-->
<docset>
<xsl:attribute name="type">
<xsl:value-of select="@kind" />
</xsl:attribute>
<h1 id="top"><!--Create the page title-->
<xsl:apply-templates select="templateparamlist"/>
<xsl:value-of select="@kind" /><xsl:text> </xsl:text><xsl:apply-templates select="compoundname" /></h1>
<section class="summary">
<xsl:if test="not(@kind='file' or @kind='namespace')">
<aside>
<h2>Quick info</h2>
<!--Infobox-->
<p>Include <xsl:apply-templates select="includes"/></p>
<xsl:if test="@abstract='yes'">
<p>This class is abstract</p>
</xsl:if>
<xsl:if test="basecompoundref">
<p>This class is extends</p>
<ul><xsl:apply-templates select="basecompoundref"/></ul>
</xsl:if>
<xsl:if test="derivedcompoundref">
<p>This class is extended by</p>
<ul><xsl:apply-templates select="derivedcompoundref"/></ul>
</xsl:if>
</aside>
</xsl:if>
<xsl:apply-templates select="detaileddescription"/>

<xsl:if test="sectiondef">
<p>The following table summarizes all members in this <xsl:value-of select="@kind" />.</p>
<table class="memberdecls">
<xsl:apply-templates select="sectiondef[@kind='public-func' or @kind='define' or @kind='typedef' or @kind='func' or @kind='enum']|innerclass|innernamespace" mode="brief"/>
</table>
</xsl:if>

</section>

<xsl:apply-templates select="sectiondef[@kind='public-func' or @kind='define' or @kind='func'  or @kind='enum' or @kind='typedef']" />

</docset>
</xsl:template>

<xsl:template match="compoundname">
<!--strip surrounding element-->
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="templateparamlist">
<!--template parameters-->
<span class="templatestring">
template&lt;<xsl:apply-templates/>&gt;
</span>
</xsl:template>

<xsl:template match="param"><!--First parameter--><xsl:apply-templates/></xsl:template>

<xsl:template match="param[position()> 1]"><!--Other paremters-->,<xsl:apply-templates/></xsl:template>

<xsl:template match="type"><span class="type"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="declname"><xsl:text> </xsl:text><span class="declname"><xsl:apply-templates/></span></xsl:template>

<xsl:template match="defname"><!--Ignore xsl:if test="not(. = preceeding-sibling::declname)">
 <span class="decldefname"><xsl:apply-templates/></span>
 </xsl:if--></xsl:template>

<xsl:template match="includes">
<!--Link to include file-->
<a>
<xsl:attribute name="href">
<xsl:value-of select="@refid"/>.html
</xsl:attribute>
<xsl:apply-templates />
</a>
</xsl:template>

<xsl:template match="para">
<!--Paragraphs that are correct-->
<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="para[itemizedlist|parameterlist|simplesect]">
<!--Paragraphs that contain stuff that must not be inside paragraphs-->
<xsl:apply-templates/>
</xsl:template>

<xsl:template mode="brief">
<xsl:apply-templates select="memberdef" mode="brief"/>
</xsl:template>

<xsl:template match="memberdef" mode="brief">
<!--Brief description entry-->
<tr><th class="membername">
<xsl:apply-templates select="templateparamlist"/>
<xsl:apply-templates select="type"/><xsl:text> </xsl:text>
<a><xsl:attribute name="href">#<xsl:value-of select="str:split(@id,'_')[last()]"/></xsl:attribute><xsl:apply-templates select="name"/></a>
(<xsl:apply-templates select="param"/>)</th>
<td class="memberdesc"><xsl:apply-templates select="briefdescription"/></td>
</tr>
</xsl:template>

<xsl:template match="memberdef[@kind='enum']" mode="brief">
<!--Brief description entry-->
<tr><th class="membername">
enum <a><xsl:attribute name="href">#<xsl:value-of select="str:split(@id,'_')[last()]"/>
</xsl:attribute><xsl:apply-templates select="name"/></a></th>
<td class="memberdesc"><xsl:apply-templates select="briefdescription"/></td>
</tr>
</xsl:template>

<xsl:template match="memberdef[@kind='typedef']" mode="brief">
<!--Brief description entry-->
<tr><th class="membername">typedef <xsl:apply-templates select="type"/><xsl:text> </xsl:text>
<a><xsl:attribute name="href">#<xsl:value-of select="str:split(@id,'_')[last()]"/>
</xsl:attribute><xsl:apply-templates select="name"/></a></th>
<td class="memberdesc"><xsl:apply-templates select="briefdescription"/></td>
</tr>
</xsl:template>

<xsl:template match="name">
<xsl:apply-templates />
</xsl:template>

<xsl:template match="briefdescription">
<!--Brief description. There should not be more than one paragraph here-->
<xsl:apply-templates select="para[1]/node()"/>
</xsl:template>

<xsl:template match="ref[@kindref='member']">
<a><xsl:attribute name="href">
<xsl:for-each select="str:split(@refid,'_')[position() &lt; last()]">
<xsl:if test="position()>1">_</xsl:if><xsl:value-of select="."/>
</xsl:for-each>.html#<xsl:value-of select="str:split(@refid,'_')[last()]"/>
</xsl:attribute>
<xsl:apply-templates/></a></xsl:template>

<xsl:template match="ref">
<a><xsl:attribute name="href">
<xsl:value-of select="@refid"/>.html</xsl:attribute>
<xsl:apply-templates/></a></xsl:template>

<xsl:template match="emphasis">
<em><xsl:apply-templates/></em><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="detaileddescription">
<!--Detailed description-->
<xsl:apply-templates select="para" />
</xsl:template>

<xsl:template match="parameterlist">
<h3>Parameters</h3>
<table class="fieldtable">
<xsl:apply-templates select="parameteritem"/>
</table>
</xsl:template>

<xsl:template match="memberdef">
<!--Full member description-->
<section>
<h2 class="memproto">
<xsl:attribute name="id"><xsl:value-of select="str:split(@id,'_')[last()]"/></xsl:attribute>
<xsl:apply-templates select="templateparamlist"/>
<xsl:apply-templates select="type"/><xsl:text> </xsl:text>
<xsl:apply-templates select="name"/>
(<xsl:apply-templates select="param"/>)</h2>

<xsl:if test="@static='yes' or @const='yes' or @explicit='yes' or @inline='yes' or @virt='virtual' or @virt='pure-virtual'">
<!--Add optional infobox-->
<aside>
<h3>Quick info</h3>

<xsl:if test="@static='yes' or @const='yes' or @explicit='yes' or @inline='yes' or @virt='virtual' or @virt='pure-virtual'">
<p>This member is</p>
<ul>
<xsl:if test="@static='yes'"><li>Static</li></xsl:if>
<xsl:if test="@const='yes'"><li>Const</li></xsl:if>
<xsl:if test="@explicit='yes'"><li>Explicit</li></xsl:if>
<xsl:if test="@inline='yes'"><li>Inline</li></xsl:if>
<xsl:if test="@virt='virtual'"><li>Virtual</li></xsl:if>
<xsl:if test="@virt='pure-virtual'"><li>Pure virtual</li></xsl:if>
</ul>
</xsl:if>
</aside>
</xsl:if>

<xsl:apply-templates select="detaileddescription" />
</section>
</xsl:template>

<xsl:template match="memberdef[@kind='enum']">
<!--Full member description for enum-->
<section>
<h2 class="memproto">
<xsl:attribute name="id"><xsl:value-of select="str:split(@id,'_')[last()]"/></xsl:attribute>
<xsl:apply-templates select="templateparamlist"/>
<xsl:apply-templates select="type"/><xsl:text> </xsl:text>
<xsl:apply-templates select="name"/></h2>

<xsl:if test="@static='yes' or @const='yes' or @explicit='yes' or @inline='yes' or @virt='virtual' or @virt='pure-virtual'">
<!--Add optional infobox-->
<aside>
<h3>Quick info</h3>

<xsl:if test="@static='yes' or @const='yes' or @explicit='yes' or @inline='yes' or @virt='virtual' or @virt='pure-virtual'">
<p>This member is</p>
<ul>
<xsl:if test="@static='yes'"><li>Static</li></xsl:if>
<xsl:if test="@const='yes'"><li>Const</li></xsl:if>
<xsl:if test="@explicit='yes'"><li>Explicit</li></xsl:if>
<xsl:if test="@inline='yes'"><li>Inline</li></xsl:if>
<xsl:if test="@virt='virtual'"><li>Virtual</li></xsl:if>
<xsl:if test="@virt='pure-virtual'"><li>Pure virtual</li></xsl:if>
</ul>
</xsl:if>
</aside>
</xsl:if>

<xsl:apply-templates select="detaileddescription" />

<p>The following table summarizes all possible enum values</p>
<table class="fieldtable">
<xsl:apply-templates select="enumvalue"/>
</table>

</section>
</xsl:template>

<xsl:template match="memberdef[@kind='typedef']">
<!--Full member description-->
<section>
<h2 class="memproto">
<xsl:attribute name="id"><xsl:value-of select="str:split(@id,'_')[last()]"/></xsl:attribute>
<xsl:apply-templates select="templateparamlist"/>
<xsl:apply-templates select="type"/><xsl:text> </xsl:text>
<xsl:apply-templates select="name"/></h2>

<xsl:if test="@static='yes' or @const='yes' or @explicit='yes' or @inline='yes' or @virt='virtual' or @virt='pure-virtual'">
<!--Add optional infobox-->
<aside>
<h3>Quick info</h3>

<xsl:if test="@static='yes' or @const='yes' or @explicit='yes' or @inline='yes' or @virt='virtual' or @virt='pure-virtual'">
<p>This member is</p>
<ul>
<xsl:if test="@static='yes'"><li>Static</li></xsl:if>
<xsl:if test="@const='yes'"><li>Const</li></xsl:if>
<xsl:if test="@explicit='yes'"><li>Explicit</li></xsl:if>
<xsl:if test="@inline='yes'"><li>Inline</li></xsl:if>
<xsl:if test="@virt='virtual'"><li>Virtual</li></xsl:if>
<xsl:if test="@virt='pure-virtual'"><li>Pure virtual</li></xsl:if>
</ul>
</xsl:if>
</aside>
</xsl:if>

<xsl:apply-templates select="detaileddescription" />

</section>
</xsl:template>

<xsl:template match="simplesect">
<!--simplesect should be an infobox-->
<div>
<xsl:attribute name="class">infobox_<xsl:value-of select="@kind"/></xsl:attribute>
<xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="simplesect[@kind='return']">
<h3>Return value</h3>
<xsl:apply-templates select="para"/>
</xsl:template>

<xsl:template match="programlisting">
<pre class="code"><xsl:apply-templates /></pre>
</xsl:template>

<xsl:template match="codeline">
<xsl:apply-templates />
</xsl:template>

<xsl:template match="highlight">
<span><xsl:attribute name="class">highlight_<xsl:value-of select="@class"/></xsl:attribute>
<xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="innerclass" mode="brief">
<!--Classes within the compound-->
<tr><th class="membername">class <a><xsl:attribute name="href"><xsl:value-of select="@refid"/>.html</xsl:attribute>
<xsl:apply-templates/></a></th><td><xsl:apply-templates select="document(concat(@refid,'.xml'))/doxygen/compounddef[1]/briefdescription"/></td></tr>
</xsl:template>

<xsl:template match="innernamespace" mode="brief">
<!--Namespaces within the compound-->
<tr><th class="membername">namespace <a><xsl:attribute name="href"><xsl:value-of select="@refid"/>.html</xsl:attribute>
<xsl:apply-templates/></a></th>
<td><xsl:apply-templates select="document(concat(@refid,'.xml'))/doxygen/compounddef[1]/briefdescription"/></td></tr>
</xsl:template>

<xsl:template match="sp">
<!--Doxygen forced space-->
<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="derivedcompoundref|basecompoundref">
<li><a><xsl:attribute name="href">
<xsl:value-of select="@refid"/>.html
</xsl:attribute><xsl:apply-templates/></a></li>
</xsl:template>

<xsl:template match="enumvalue">
<tr><th class="fieldname"><xsl:apply-templates select="name" /></th>
<td class="fielddoc"><xsl:apply-templates select="detaileddescription"/></td></tr>
</xsl:template>

<xsl:template match="parameteritem">
<tr><th class="fieldname"><xsl:apply-templates select="parameternamelist" /></th>
<td class="fielddoc"><xsl:apply-templates select="parameterdescription"/></td></tr>
</xsl:template>

<xsl:template match="sectiondef">
<xsl:apply-templates />
</xsl:template>

<xsl:template match="parameternamelist">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="parametername">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="parameterdescription">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="computeroutput">
<code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="verbatim">
<pre class="verbatim">
<xsl:apply-templates />
</pre>
</xsl:template>

<xsl:template match="itemizedlist">
<ul><xsl:apply-templates/></ul>
</xsl:template>

<xsl:template match="listitem">
<li><xsl:apply-templates /></li>
</xsl:template>

</xsl:stylesheet>
