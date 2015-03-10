<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Change the encoding here if you need it, i.e. UTF-8 -->
	<xsl:output method="html" encoding="iso-8859-1" indent="yes"/>
	<!-- ************************************ Parameters ************************************ -->
	<!-- deploy-treeview, boolean - true if you want to deploy the tree-view at the first print -->
	<xsl:param name="param-deploy-treeview" select="'false'"/>
	<!-- is the client Netscape / Mozilla or Internet Explorer. Thanks to Bill, 90% of sheeps use Internet Explorer so it will the default value-->
	<xsl:param name="param-is-netscape" select="'false'"/>
	<!-- hozizontale distance in pixels between a folder and its leaves -->
	<xsl:param name="param-shift-width" select="15"/>
	<!-- image source directory-->
	<xsl:param name="param-img-directory" select="''"/>
	<!-- ************************************ Variables ************************************ -->
	<xsl:variable name="var-simple-quote">'</xsl:variable>
	<xsl:variable name="var-slash-quote">\'</xsl:variable>

	<!--
	**
	**  Model "treeview"
	** 
	**  This model transforms an XML treeview into an html treeview
	**  
	-->
	<xsl:template match="toc">
	  <xsl:param name="tocdepth"/>
	  <link rel="stylesheet" href="treeview.css" type="text/css"/>
		<!-- Warning, if you use-->
		<script src="treeview.js" language="javascript" type="text/javascript"/>
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
			   <td width="{$param-shift-width}"/>
			   <xsl:if test="$tocdepth>1">
					<td width="{$param-shift-width}"/>
				</xsl:if>
				<td>
				    <a>
						<xsl:if test="@code">
							<xsl:attribute name="onclick">toggle2(this, '<xsl:value-of select="@code"/>')</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(@code)">
							<xsl:attribute name="onclick">toggle(this)</xsl:attribute>
						</xsl:if>
					   <xsl:if test="@expanded">
							<xsl:if test="@expanded='true'">
								<img src="{$param-img-directory}minus.gif"/>
								<img src="{$param-img-directory}container_obj.gif"/>
							</xsl:if>
							<!-- plus (+) otherwise-->
							<xsl:if test="@expanded='false'">
								<img src="{$param-img-directory}plus.gif"/>
								<img src="{$param-img-directory}container_obj.gif"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not(@expanded)">
							<xsl:if test="$param-deploy-treeview = 'true'">
								<img src="{$param-img-directory}minus.gif"/>
								<img src="{$param-img-directory}container_obj.gif"/>
							</xsl:if>
							<xsl:if test="$param-deploy-treeview = 'false' or not(@expanded)">
								<img src="{$param-img-directory}plus.gif"/>
								<img src="{$param-img-directory}container_obj.gif"/>
							</xsl:if>
						</xsl:if>
						<xsl:value-of select="@label" />
					</a>
					<!-- Shall we expand all the leaves of the treeview ? no by default-->
					<div>
						<xsl:if test="@expanded">
							<xsl:if test="@expanded='true'">
								<xsl:attribute name="style">display:block;</xsl:attribute>
							</xsl:if>
							<!-- plus (+) otherwise-->
							<xsl:if test="@expanded='false'">
								<xsl:attribute name="style">display:none;</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not(@expanded)">
							<xsl:if test="$param-deploy-treeview = 'true'">
								<xsl:attribute name="style">display:block;</xsl:attribute>
							</xsl:if>
							<xsl:if test="$param-deploy-treeview = 'false'">
								<xsl:attribute name="style">display:none;</xsl:attribute>
							</xsl:if>
						</xsl:if>
										
						<xsl:apply-templates select="topic">
							<xsl:with-param name="depth" select="$tocdepth+1"/>
						</xsl:apply-templates>
					</div>
				</td>
			</tr>			
		</table>
	</xsl:template>
	<!--
**
**  Model "topic"
** 
**  This model transforms a topic element. Prints a plus (+) or minus (-)  image, the folder image and a title
**  
-->
	<xsl:template match="topic">
		<xsl:param name="depth"/>
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<!-- If first level of depth, do not shift of $param-shift-width-->
				<xsl:if test="$depth>1">
					<td width="{$param-shift-width}"/>
				</xsl:if>
				<td width="{$param-shift-width}"/>
				<xsl:if test="not(*)">
					<td width="{$param-shift-width}"/>
				</xsl:if>	
				<td>
					<a>
						<xsl:if test="@code">
							<xsl:attribute name="onclick">toggle2(this, '<xsl:value-of select="@code"/>')</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(@code)">
							<xsl:attribute name="onclick">toggle(this)</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(*)"> <!-- no child-->
							<!-- If the treeview is unfold, the image minus (-) is displayed-->
							<img src="{$param-img-directory}topic.gif"/>
						</xsl:if>
						<xsl:if test="(*)"><!-- has child-->
							<!-- If the treeview is unfold, the image minus (-) is displayed-->
							<xsl:if test="@expanded">
								<xsl:if test="@expanded='true'">
									<img src="{$param-img-directory}minus.gif"/>
									<img src="{$param-img-directory}container_obj.gif"/>
								</xsl:if>
								<!-- plus (+) otherwise-->
								<xsl:if test="@expanded='false'">
									<img src="{$param-img-directory}plus.gif"/>
									<img src="{$param-img-directory}container_obj.gif"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="not(@expanded)">
								<xsl:if test="$param-deploy-treeview = 'true'">
									<img src="{$param-img-directory}minus.gif"/>
									<img src="{$param-img-directory}container_obj.gif"/>
								</xsl:if>
								<xsl:if test="$param-deploy-treeview = 'false' or not(@expanded)">
									<img src="{$param-img-directory}plus.gif"/>
									<img src="{$param-img-directory}container_obj.gif"/>
								</xsl:if>
							</xsl:if>
						</xsl:if>
						<xsl:if test="@href!=''">
							<a target="ContentFrame"><xsl:attribute name="href">../<xsl:value-of select="@href"/></xsl:attribute><xsl:value-of select="@label" /></a>
						</xsl:if>
						<xsl:if test="not(@href!='')">
							<a target="ContentFrame"><xsl:value-of select="@label" /></a>
						</xsl:if>	
					</a>
					<!-- Shall we expand all the leaves of the treeview ? no by default-->
					<div>
						<xsl:if test="@expanded">
							<xsl:if test="@expanded='true'">
								<xsl:attribute name="style">display:block;</xsl:attribute>
							</xsl:if>
							<!-- plus (+) otherwise-->
							<xsl:if test="@expanded='false'">
								<xsl:attribute name="style">display:none;</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not(@expanded)">
							<xsl:if test="$param-deploy-treeview = 'true'">
								<xsl:attribute name="style">display:block;</xsl:attribute>
							</xsl:if>
							<xsl:if test="$param-deploy-treeview = 'false'">
								<xsl:attribute name="style">display:none;</xsl:attribute>
							</xsl:if>
						</xsl:if>
										
						<!-- Thanks to the magic of reccursive calls, all the descendants of the present topic are gonna be built -->
						<xsl:apply-templates select="topic">
							<xsl:with-param name="depth" select="$depth+1"/>
						</xsl:apply-templates>
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>