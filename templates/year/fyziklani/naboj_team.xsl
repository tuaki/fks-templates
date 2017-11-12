<?xml version="1.0" encoding="utf-8"?>
<stylesheet xmlns="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<output method="text" indent="no"/>
	<strip-space elements="*"/>

	<template match="/">
		<!-- this allows nesting stats element arbitrarily -->
		<apply-templates select="//export"></apply-templates>
	</template>
	
	<template match="export">
		<apply-templates select="data/row[not(col[4]='cancelled')]"></apply-templates>
	</template>

	<template match="row">
		<!-- team header -->
		<value-of select="col[1]"/>
		<text>;</text>
		<value-of select="col[3]"/>
		<text>;</text>
		<value-of select="col[2]"/>
		<text>;</text>
		<value-of select="col[4]"/>
		<text>;</text>
		<text>
</text>
	</template>
	<template name="csv">
		
	</template>
</stylesheet>

