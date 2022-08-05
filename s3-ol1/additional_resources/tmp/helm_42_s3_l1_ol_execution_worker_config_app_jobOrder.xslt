<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<xsl:output version="1.0" method="xml" omit-xml-declaration="no"
		standalone="yes" indent="yes" />
	
	<xsl:template match="List_of_Dynamic_Processing_Parameters">
		<List_of_Dyn_Processing_Parameters>
			<xsl:apply-templates select="@*|node()"/>
		</List_of_Dyn_Processing_Parameters>
	</xsl:template>
	
	<xsl:template match="Dynamic_Processing_Parameter">
		<Dyn_Processing_Parameter>
			<xsl:apply-templates select="@*|node()"/>
		</Dyn_Processing_Parameter>
	</xsl:template>
	
	<!-- Copy Template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
		
</xsl:stylesheet>