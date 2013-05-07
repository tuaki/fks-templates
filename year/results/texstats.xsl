<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
	Params:
		series: 1..6
	-->
    <xsl:param name="series"/>
	<xsl:output method="text" indent="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />

	<xsl:template match="/">
		<!-- this allows nesting stats element arbitrarily -->
		<xsl:apply-templates select="//stats"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="stats">
		<xsl:apply-templates select="task[@series=$series]"></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="task">
		<xsl:value-of select="$series"/>
		<xsl:text>;</xsl:text>
		<xsl:call-template name="label2num">
			<xsl:with-param name="label" select="@label"/>
		</xsl:call-template>
		<xsl:text>;</xsl:text>
		<xsl:value-of select="points"/>	
		<xsl:text>;</xsl:text>
		<xsl:value-of select="format-number(average, '#0,00', 'european')"/>	
		<xsl:text>;</xsl:text>
		<xsl:value-of select="solvers"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- map from label to number -->
	<xsl:template name="label2num">
		<xsl:param name="label"/>
		<xsl:choose>
			<xsl:when test="$label = 'P'">6</xsl:when>
			<xsl:when test="$label = 'E'">7</xsl:when>
			<xsl:when test="$label = 'S'">8</xsl:when>
			<xsl:otherwise><xsl:value-of select="$label"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

