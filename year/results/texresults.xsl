<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--
	type values in:
                - cumulative (not implemented)
                - brojure (default)
		- detail
	category: any valid category
	series: 1..6
	-->
        <!--
        Raw data in brojure node contain sums for all specified series, however,
        one should be showed. Filtering is done with columns label and it relies
        on the fact only these series sum columns has two-charactes long label.
        -->
	<xsl:param name="type" select="'brojure'"/>
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
                        <xsl:when test="$type = 'brojure'">
				<xsl:apply-templates select="brojure[@listed-series=$series]"></xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="detail">
		<xsl:apply-templates select="category[@id=$category]"></xsl:apply-templates>
	</xsl:template>
        
        <xsl:template match="brojure">
		<xsl:apply-templates select="category[@id=$category]">
                    <xsl:with-param name="listed-series" select="@listed-series"/>
                </xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="category">
            <xsl:param name="listed-series"/>
		<xsl:text>&amp; Student Pilný &amp; MFF UK</xsl:text>
                <xsl:if test="$listed-series">
                    <xsl:apply-templates select="column-definitions/column-definition[not(string-length(@label) = 2) or (substring(@label, 2) = $listed-series)]" mode="limit"></xsl:apply-templates><!-- beware this XPath expression isn't more-than-nine-tasks proof -->
                </xsl:if>
		<xsl:if test="not($listed-series)">
                    <xsl:apply-templates select="column-definitions/column-definition" mode="limit"></xsl:apply-templates>
                </xsl:if>
		<xsl:text>\\
\midrule
</xsl:text>
	<xsl:apply-templates select="data/contestant">
                    <xsl:with-param name="listed-series" select="$listed-series"/>
                </xsl:apply-templates>
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
            <xsl:param name="listed-series"/>
            <xsl:variable name="myposition" select="position()"/>
            <xsl:if test="not(string-length(../../../column-definitions/column-definition[$myposition]/@label) = 2) or (substring(../../../column-definitions/column-definition[$myposition]/@label, 2) = $listed-series)"><!-- beware this XPath expression isn't more-than-nine-tasks proof -->
		<xsl:text> &amp; </xsl:text>
		<xsl:call-template name="nullable"><xsl:with-param name="value" select="text()"/></xsl:call-template>
            </xsl:if>
	</xsl:template>
	
	<xsl:template match="contestant">
        <xsl:param name="listed-series"/>
		<xsl:if test="column[last()]/text()">
			<xsl:if test="rank/@to"><xsl:value-of select="rank/@from"/>.--<xsl:value-of select="rank/@to"/>.</xsl:if>
			<xsl:if test="not(rank/@to)"><xsl:value-of select="rank/@from"/>.</xsl:if>
			<xsl:text> &amp; </xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text> &amp;</xsl:text>
			<xsl:value-of select="@school"/>
			<xsl:apply-templates select="column" mode="contestant">
				<xsl:with-param name="listed-series" select="$listed-series"/>
			</xsl:apply-templates>               
			
			<xsl:text>\\
</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="nullable">
		<xsl:param name="value"/>
		<xsl:if test="not($value)">--</xsl:if>
		<xsl:if test="$value"><xsl:value-of select="$value"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>

