<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
	type values in:
	    - cumulative (not implemented)
		- detail (default)
	category: any valid category
	series: 1..6
	-->
	<xsl:param name="type" select="'detail'"/>
	<xsl:param name="category"/>
	<xsl:param name="series"/>
	<xsl:output method="text" indent="no"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/">
		<!-- this allows nesting results element arbitrarily -->
		<xsl:apply-templates select="//results"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="results">
		<xsl:choose>
			<xsl:when test="$type = 'detail'">
				<xsl:apply-templates select="detail[@series=$series]"></xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="detail">
		<xsl:apply-templates select="category[@id=$category]"></xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="category">
		<xsl:text>&amp; Student Pilný &amp; MFF UK</xsl:text>
		<xsl:apply-templates select="column-definitions/column-definition" mode="limit"></xsl:apply-templates>
		<xsl:text>\\
\midrule
</xsl:text>
		<xsl:apply-templates select="data/contestant"></xsl:apply-templates>
	</xsl:template>
    	<!-- unused -->
	<xsl:template match="column-definition" mode="header">
		<th>
		<xsl:choose>
			<xsl:when test="@label = 'percent'">%</xsl:when>
			<xsl:when test="@label = 'sum'">&#8721;</xsl:when>						
			<xsl:otherwise><xsl:value-of select="@label"/></xsl:otherwise>
		</xsl:choose>
		</th>
	</xsl:template>
	
	<xsl:template match="column-definition" mode="limit">
		<xsl:text> &amp; </xsl:text>
		<xsl:call-template name="nullable"><xsl:with-param name="value" select="@limit"/></xsl:call-template>		
	</xsl:template>
	
	<xsl:template match="column" mode="contestant">
		<xsl:text> &amp; </xsl:text>
		<xsl:call-template name="nullable"><xsl:with-param name="value" select="text()"/></xsl:call-template>
	</xsl:template>
	
	<xsl:template match="contestant">
		<xsl:if test="rank/@to"><xsl:value-of select="rank/@from"/>.--<xsl:value-of select="rank/@to"/>.</xsl:if>
		<xsl:if test="not(rank/@to)"><xsl:value-of select="rank/@from"/>.</xsl:if>
		<xsl:text> &amp; </xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text> &amp;</xsl:text>
		<xsl:value-of select="@school"/>
		<xsl:apply-templates select="column" mode="contestant"></xsl:apply-templates>
		<xsl:text>\\
</xsl:text>
	</xsl:template>
	
	<xsl:template name="nullable">
		<xsl:param name="value"/>
		<xsl:if test="not($value)">--</xsl:if>
		<xsl:if test="$value"><xsl:value-of select="$value"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>

