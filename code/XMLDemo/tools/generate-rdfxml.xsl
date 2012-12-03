<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:its="http://www.w3.org/2005/11/its" xmlns:datc="http://example.com/datacats" version="2.0"
	exclude-result-prefixes="datc" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	<xsl:output method="xml" indent="yes" encoding="utf-8"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="base-uri">http://example.com/exampledoc.html#</xsl:param>
	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:its="http://www.w3.org/2005/11/its">
			<xsl:apply-templates select="//output/* | //output/@*" mode="generateTriple"/>
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="* | @*" mode="generateTriple">
		<rdf:Description>
			<xsl:variable name="subject">
				<xsl:value-of select="$base-uri"/>
				<xsl:text>xpath(</xsl:text>
				<xsl:value-of select="ancestor::node/@path"/>
				<xsl:text>)</xsl:text>
			</xsl:variable>
			<xsl:attribute name="rdf:about" select="$subject"/>
			<xsl:variable name="predicateName">
			<xsl:choose>
				<xsl:when test="namespace-uri()=''"> its:<xsl:value-of select="name()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name()"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			<xsl:element name="{$predicateName}">
			<xsl:choose>
				<xsl:when test="self::attribute()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rdf:parseType">Literal</xsl:attribute>
					<xsl:copy-of select="self::*"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:element>
		</rdf:Description>
	</xsl:template>
</xsl:stylesheet>
