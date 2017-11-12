<?xml version="1.0" encoding="utf-8"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<output method="text" indent="no"/>
	<strip-space elements="*"/>
	<!--
	     Filter teams from given location only (use '*' for all locations,
	     it's default).
	-->
	<param name="location" select="'*'"/>

	<template match="/">
		<!-- this allows nesting stats element arbitrarily -->
		<apply-templates select="//export"></apply-templates>
	</template>
	
	<template match="export">
		<apply-templates select="data/row[$location = '*' or $location = col[27]][not(col[4]='cancelled')]"></apply-templates>
	</template>

	<template match="row">
		<!-- team header -->
		<text>\team{</text>
		<value-of select="col[1]"/>
		<text>}{</text>
		<if test="col[4] != 'approved'">
			<text>?? </text>
		</if>
		<value-of select="col[2]"/>
		<text>}{</text>
		<value-of select="col[3]"/>
		<text>}</text>
		<text>
</text>

		<!-- guide -->
		<if test="not(col[5]='')">
			<text>\guide{</text>
			<value-of select="col[5]"/>
			<text>}{</text>
			<value-of select="col[6]"/>
		<text>}</text>
		<text>
</text>
		</if>

		<!-- members -->
		<call-template name="member">
			<with-param name="row" select="self::node()" />
			<with-param name="i" select="1" />
		</call-template>
		<call-template name="member">
			<with-param name="row" select="self::node()" />
			<with-param name="i" select="2" />
		</call-template>
		<call-template name="member">
			<with-param name="row" select="self::node()" />
			<with-param name="i" select="3" />
		</call-template>
		<call-template name="member">
			<with-param name="row" select="self::node()" />
			<with-param name="i" select="4" />
		</call-template>
		<call-template name="member">
			<with-param name="row" select="self::node()" />
			<with-param name="i" select="5" />
		</call-template>

		<!-- team footer -->
		<text>\teamend</text>
	</template>


	<!-- Function templates -->
	<template name="member">
		<param name="row"/>
		<param name="i"/>
			<text>\member{</text>
			<value-of select="$row/col[6+4*($i - 1)+1]"/>
			<text>}{</text>
			<value-of select="$row/col[6+4*($i - 1)+2]"/>
			<text>}{</text>
			<value-of select="$row/col[6+4*($i - 1)+3]"/>
			<text>}{</text>
			<value-of select="$row/col[6+4*($i - 1)+4]"/>
			<text>}</text>
		<text>
</text>
	</template>
	<template name="tex">
		
	</template>
</stylesheet>

