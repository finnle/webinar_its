<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:datc="http://example.com/datacats"
                version="2.0">
   <xsl:output method="xml" indent="yes" encoding="utf-8"/>
   <xsl:strip-space elements="*"/>
   <xsl:template match="*|@*" mode="get-full-path">
      <xsl:apply-templates select="parent::*" mode="get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:if test="count(. | ../@*) = count(../@*)">@</xsl:if>
      <xsl:value-of select="name()"/>
      <xsl:if test="self::element() and parent::element()">
         <xsl:text>[</xsl:text>
         <xsl:number/>
         <xsl:text>]</xsl:text>
      </xsl:if>
   </xsl:template>
   <xsl:template name="writeOutput">
      <xsl:param name="outputType">no-value</xsl:param>
      <xsl:param name="outputValue" as="node()*">
         <output>no-value</output>
      </xsl:param>
      <xsl:element name="node">
         <xsl:attribute name="path">
            <xsl:apply-templates mode="get-full-path" select="."/>
         </xsl:attribute>
         <xsl:attribute name="outputType">
            <xsl:value-of select="$outputType"/>
         </xsl:attribute>
         <xsl:copy-of select="$outputValue"/>
      </xsl:element>
   </xsl:template>
   <xsl:template match="/">
      <nodeList>
         <xsl:element name="nodeList">
            <xsl:attribute name="datacat">
               <xsl:text>languageinformation</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates mode="languageinformation">
               <xsl:with-param name="existingDataCatValue">no-value</xsl:with-param>
            </xsl:apply-templates>
         </xsl:element>
      </nodeList>
   </xsl:template>
   <xsl:template match="*" mode="languageinformation" priority="-1000">
      <xsl:param name="existingDataCatValue" as="node()*">no-value</xsl:param>
      <xsl:if test="not($existingDataCatValue='default-value') and     not($existingDataCatValue='no-value')">
         <xsl:call-template name="writeOutput">
            <xsl:with-param name="outputType">inherited</xsl:with-param>
            <xsl:with-param name="outputValue" as="node()*">
               <xsl:copy-of select="$existingDataCatValue"/>
            </xsl:with-param>
         </xsl:call-template>
         <xsl:apply-templates mode="languageinformation" select="@* | element()">
            <xsl:with-param name="existingDataCatValue"
                            as="node()*"
                            select="$existingDataCatValue"/>
         </xsl:apply-templates>
      </xsl:if>
      <xsl:if test="$existingDataCatValue='no-value'">
         <xsl:call-template name="writeOutput">
            <xsl:with-param name="outputType">no-value</xsl:with-param>
            <xsl:with-param name="outputValue" as="node()*">
               <output/>
            </xsl:with-param>
         </xsl:call-template>
         <xsl:apply-templates mode="languageinformation" select="@* | element()">
            <xsl:with-param name="existingDataCatValue" as="node()*">no-value</xsl:with-param>
         </xsl:apply-templates>
      </xsl:if>
   </xsl:template>
   <xsl:template match="@*" mode="languageinformation" priority="-1000">
      <xsl:param name="existingDataCatValue" as="node()*">no-value</xsl:param>
      <xsl:if test="not($existingDataCatValue='default-value') and not($existingDataCatValue='no-value')">
         <xsl:call-template name="writeOutput">
            <xsl:with-param name="outputType">inherited</xsl:with-param>
            <xsl:with-param name="outputValue" as="node()*">
               <xsl:copy-of select="$existingDataCatValue"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:if test="$existingDataCatValue='default-value'">
         <xsl:call-template name="writeOutput">
            <xsl:with-param name="outputType">default-value</xsl:with-param>
            <xsl:with-param name="outputValue" as="node()*">
               <output/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:if test="$existingDataCatValue='no-value'">
         <xsl:call-template name="writeOutput">
            <xsl:with-param name="outputType">no-value</xsl:with-param>
            <xsl:with-param name="outputValue" as="node()*">
               <output/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="languageinformationlangPointer"
                 match="element() | @*"
                 priority="1">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" mode="languageinformationlangPointer"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template mode="languageinformation" match="/text" priority="1">
      <xsl:call-template name="writeOutput">
         <xsl:with-param name="outputType">new-value-global</xsl:with-param>
         <xsl:with-param name="outputValue" as="node()*">
            <output>
               <langPointer>
                  <xsl:apply-templates select="@language" mode="languageinformationlangPointer"/>
               </langPointer>
            </output>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates mode="languageinformation" select="@* | element()">
         <xsl:with-param name="existingDataCatValue" as="node()*">
            <output>
               <langPointer>
                  <xsl:apply-templates select="@language" mode="languageinformationlangPointer"/>
               </langPointer>
            </output>
         </xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template mode="languageinformationlangPointer"
                 match="element() | @*"
                 priority="2">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" mode="languageinformationlangPointer"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template xmlns:xlink="http://www.w3.org/1999/xlink"
                 mode="languageinformation"
                 match="//content/item/text"
                 priority="2">
      <xsl:call-template name="writeOutput">
         <xsl:with-param name="outputType">new-value-global</xsl:with-param>
         <xsl:with-param name="outputValue" as="node()*">
            <output>
               <langPointer>
                  <xsl:apply-templates select="../lang" mode="languageinformationlangPointer"/>
               </langPointer>
            </output>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates mode="languageinformation" select="@* | element()">
         <xsl:with-param name="existingDataCatValue" as="node()*">
            <output>
               <langPointer>
                  <xsl:apply-templates select="../lang" mode="languageinformationlangPointer"/>
               </langPointer>
            </output>
         </xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>
</xsl:stylesheet>
