<?xml version="1.0" encoding="iso-8859-1" ?>
<!DOCTYPE xsl:stylesheet PUBLIC "-//FreeBSD//DTD FreeBSD XSLT 1.0 DTD//EN"
				"http://www.FreeBSD.org/XML/share/xml/xslt10-freebsd.dtd" [
<!ENTITY title "FreeBSD Quarterly Status Report">
]>

<!-- $FreeBSD$ -->

<!-- Standard header material -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:import href="http://www.FreeBSD.org/XML/lang/share/xml/libcommon.xsl"/>
  <xsl:import href="http://www.FreeBSD.org/XML/share/xml/xhtml.xsl"/>

  <xsl:variable name="title">&title;</xsl:variable>

  <xsl:template name="process.sidewrap">
    &nav.about;
  </xsl:template>

  <xsl:template name="process.contentwrap">
	<!-- Process all the <sections>, in order -->
	<xsl:apply-templates select="report/section"/>

	<hr/>

	<!-- Generate a table of contents, sorted -->
	<xsl:for-each select="report/category">
	  <h3><xsl:value-of select="description"/></h3>
	  <xsl:variable name="cat-short" select="name"/>
	  <ul>
	    <xsl:for-each select="//project[@cat=$cat-short and @summary]">
  	      <xsl:sort select="translate(title, $lowercase, $uppercase)"/>
	      <li><a><xsl:attribute name="href">#<xsl:value-of
	      select="translate(title, ' ',
	      '-')"/></xsl:attribute><xsl:value-of select="title"/></a>
	      </li>
	    </xsl:for-each>

	    <xsl:for-each select="//project[@cat=$cat-short and not(@summary)]">
  	      <xsl:sort select="translate(title, $lowercase, $uppercase)"/>
	      <li><a><xsl:attribute name="href">#<xsl:value-of
	      select="translate(title, ' ',
	      '-')"/></xsl:attribute><xsl:value-of select="title"/></a>
	      </li>
	    </xsl:for-each>
	  </ul>
	</xsl:for-each>
	<ul>
	  <xsl:for-each select="//project[not(@cat)]">
  	    <xsl:sort select="translate(title, $lowercase, $uppercase)"/>
	    <li><a><xsl:attribute name="href">#<xsl:value-of
	    select="translate(title, ' ',
	    '-')"/></xsl:attribute><xsl:value-of select="title"/></a>
	    </li>
	  </xsl:for-each>
	</ul>

	<hr/>

	<!-- Process each project, sorted -->
	<xsl:apply-templates select="report/project">
	  <xsl:sort select="translate(title, $lowercase, $uppercase)"/>
	</xsl:apply-templates>

	<!-- Standard footer -->
	<a href="../news.html">News Home</a> | <a href="status.html">Status Home</a>
  </xsl:template>

  <!-- Everything that follows are templates for the rest of the content -->

  <!-- A section creates a header, and copies in all the <p> elements from
       itself -->
  <xsl:template match="section">
    <h1><xsl:value-of select="title"/></h1>

    <xsl:apply-templates select="p" mode="copy.html"/>
  </xsl:template>

  <!-- A project creates a header, and then process the three components of
       a project report (links, contact details, project body) in turn -->
  <xsl:template match="project">
    <h2><a>
	<xsl:attribute name="name"><xsl:value-of
	  select="translate(title, ' ', '-')"/></xsl:attribute><xsl:value-of
	  select="title"/></a></h2>

    <xsl:apply-templates select="links"/>

    <xsl:apply-templates select="contact"/>

    <xsl:apply-templates select="body"/>

    <xsl:apply-templates select="help"/>

    <hr/>
  </xsl:template>

  <!-- Create a paragraph to hold the contact information.  Iterate over
       each <person> element, copying their data in.  All but the last
       person has a terminating <br> in the output. -->
  <xsl:template match="contact">
    <p>
      <xsl:for-each select="person">
	Contact: <xsl:value-of select="name"/> &lt;<a>
	  <xsl:attribute name="href">mailto:<xsl:value-of select="email"/></xsl:attribute><xsl:value-of select="email"/></a>&gt;
	<xsl:if test="position() != last()"><br/></xsl:if>
      </xsl:for-each>
    </p>
  </xsl:template>

  <!-- Create a paragraph to hold the link information.  Iterate over each
       <url> element, copying their data in.  All but the last link has a
       terminating <br> in the output. -->
  <xsl:template match="links">
    <p>
      <xsl:for-each select="url">
	URL:
	  <a href="{@href}" title="{.}">     <!-- Copy in the href attribute -->
	    <xsl:value-of select="@href"/>
	  </a>
	<xsl:if test="position() != last()"><br/></xsl:if>
      </xsl:for-each>
    </p>
  </xsl:template>

  <!-- Body is a doddle.  Since it contains HTML we just copy in all the
       child elements. -->
  <xsl:template match="body">
    <xsl:apply-templates select="child::node()" mode="copy.html"/>
  </xsl:template>

  <xsl:template match="help">
    <h3>Open tasks:</h3>
    <ol>
      <xsl:for-each select="task">
	<li><xsl:apply-templates select="child::node()" mode="copy.html"/></li>
      </xsl:for-each>
    </ol>
  </xsl:template>
</xsl:stylesheet>
