<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Rendering specific to the item display page.

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights">

    <xsl:output indent="yes"/>

    <xsl:template name="itemSummaryView-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
        mode="itemSummaryView-DIM"/>

        <xsl:copy-of select="$SFXLink" />
        <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']/mets:file">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
                    <xsl:with-param name="context" select="."/>
                    <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']"/>
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>

    </xsl:template>


    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
    	<xsl:param name="type" select="dim:field[@element='type'][1]/node()"/>
        <div class="item-summary-view-metadata">        	
        	<xsl:choose>
        		<xsl:when test="$type = 'Articolo'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Articolo"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Atti di convegno'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Report'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Report"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Catalogo'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Report"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Manuale'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Report"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Contributo a convegno'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Contributo in un libro'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Libro'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Libro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Scheda progetto'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Scheda progetto CRS4'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Tesi'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Tesi"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Working paper'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Working-paper"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Dataset'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Immagine'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Video'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Audio'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Esperimento'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Mostra'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Rivista'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Altro'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Altro"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Brevetto'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Marchio registrato'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato"/>
        		</xsl:when>
        		<xsl:when test="$type = 'Design registrato'">
        			<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato"/>
        		</xsl:when>
        		<xsl:otherwise>
        			<xsl:call-template name="itemSummaryView-DIM-fields"/>        		
        		</xsl:otherwise>        	
        	</xsl:choose>            
        </div>
    </xsl:template>

    <xsl:template name="itemSummaryView-DIM-fields">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="descendant::text() and (count(dim:field[@element='title'][not(@qualifier)]) &gt; 1)">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="dim:field[@element='title'][descendant::text()] and count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- Author(s) row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='contributor'][@qualifier='author' and descendant::text()] or dim:field[@element='creator' and descendant::text()] or dim:field[@element='contributor' and descendant::text()])">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='contributor']">
	                            <xsl:for-each select="dim:field[@element='contributor']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- identifier.uri row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='identifier' and @qualifier='uri' and descendant::text()])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- date.issued row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='date' and @qualifier='issued' and descendant::text()])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- Abstract row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <!-- Description row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='description' and not(@qualifier) and descendant::text()])">
                <div class="simple-item-view-description">
	                <h3 class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 7 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
          </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 8">
              <xsl:call-template name="itemSummaryView-DIM-fields">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>

	<!-- Articolo start -->
	<xsl:template name="itemSummaryView-DIM-fields-Articolo">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>     	  
      	  
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- description.status row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='description' and @qualifier='status'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Status:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='status'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='status']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 6 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartof row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='relation' and @qualifier='ispartof'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolo del periodico:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartof']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- identifier.issn row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='identifier' and @qualifier='issn'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">ISSN:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='issn'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='issn']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- identifier.eissn row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='identifier' and @qualifier='eissn'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">EISSN:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='eissn'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='eissn']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- publisher row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='publisher'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Editore:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='publisher'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='publisher']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartofseries row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='relation' and @qualifier='ispartofseries'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Volume/Numero del fascicolo:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartofseries'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartofseries']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- page number row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='description' and @qualifier='pagenumber'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Da pagina a pagina:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='pagenumber'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='pagenumber']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- identifier.doi row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='identifier' and @qualifier='doi'])">
                    <div class="simple-item-view-other">
	                <span class="bold">DOI:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
		                    <a>
		                        <xsl:attribute name="href">
		                            http://dx.doi.org/<xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>            
          
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject row -->
          <xsl:when test="$clause = 17  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 18 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 19 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 20 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 21 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 22 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 23 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 24 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 25">
              <xsl:call-template name="itemSummaryView-DIM-fields-Articolo">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Articolo end -->
	
	<!--  Atti di convegno start-->
	<xsl:template name="itemSummaryView-DIM-fields-Atti-di-convegno">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
      
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 5 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
           <!-- publisher row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='publisher'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Editore:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='publisher'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='publisher']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- numeropagine row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='numeropagine'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Pagine:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='numeropagine'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='numeropagine']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartof row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='relation' and @qualifier='ispartof'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolo della serie:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartof']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartofseries row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='relation' and @qualifier='ispartofseries'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Volume/Numero del fascicolo:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartofseries'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartofseries']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- identifier.isbn row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='identifier' and @qualifier='isbn'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">ISBN:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='isbn'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='isbn']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                    
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- identifier.doi row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='identifier' and @qualifier='doi'])">
                    <div class="simple-item-view-other">
	                <span class="bold">DOI:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
		                    <a>
		                        <xsl:attribute name="href">
		                            http://dx.doi.org/<xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
                   
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject row -->
          <xsl:when test="$clause = 15  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
          <!-- subject.progetti row  -->
          <xsl:when test="$clause = 16 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 17 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 18 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 19 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 20 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 21 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 22 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 23">
              <xsl:call-template name="itemSummaryView-DIM-fields-Atti-di-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Atti di convegno end -->
	
	 <!-- Report Start -->
	<xsl:template name="itemSummaryView-DIM-fields-Report">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
      	   <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
                    
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Report">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Report">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- contributor.other row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Ente Autore:</span>
	                	<span>	                		
		                    <xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    	</xsl:for-each>		                    		                                       
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Report">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>  
          
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 7 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Report">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
                             
          <!-- subject.progetti row  -->
          <xsl:when test="$clause = 11 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
       
          <!-- subject row -->
          <xsl:when test="$clause = 12  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
                
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 13 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
                                 
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Report">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 17 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 18 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 19">
              <xsl:call-template name="itemSummaryView-DIM-fields-Report">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
    <!-- Report End -->
    
    <!-- Contributo a convegno start -->
	<xsl:template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
                
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
           <!-- contributor.other row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Ente Autore:</span>
	                	<span>	                		
		                    <xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    	</xsl:for-each>		                    		                                       
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>  
          
          <!-- contributor row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 6 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
                   
          
          <!-- description.conferencetitle row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='conferencetitle'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolo dell'evento:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='conferencetitle'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='conferencetitle']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- description.conferencelocation row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='description' and @qualifier='conferencelocation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Luogo dell'evento:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='conferencelocation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='conferencelocation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- description.conferencedate row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='description' and @qualifier='conferencedate'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Data dell'evento:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='conferencedate'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='conferencedate']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
           
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject row -->
          <xsl:when test="$clause = 13  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 14 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 15 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 17 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         

          <!-- Description row -->
          <xsl:when test="$clause = 18 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 19 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 20 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 21">
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-a-convegno">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Contributo a convegno end -->
    
    <!-- Contributo in un libro start -->
	<xsl:template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
          
           <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
      		
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
           <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 6 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
           <!-- page number row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='pagenumber'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Da pagina a pagina:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='pagenumber'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='pagenumber']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartof row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='relation' and @qualifier='ispartof'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolo della pubblicazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartof']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartofseries row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='relation' and @qualifier='ispartofseries'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Volume:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartofseries'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartofseries']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
                   
                    
          <!-- publisher row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='publisher'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Editore:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='publisher'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='publisher']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartof row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='relation' and @qualifier='ispartof'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolo della serie:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartof']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.issued row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='relation' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Numero del fascicolo:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='issued'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='issued']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
         <!-- identifier.isbn row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='identifier' and @qualifier='isbn'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">ISBN:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='isbn'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='isbn']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
           <!-- identifier.doi row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='identifier' and @qualifier='doi'])">
                    <div class="simple-item-view-other">
	                <span class="bold">DOI:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
		                    <a>
		                        <xsl:attribute name="href">
		                            http://dx.doi.org/<xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
          <!-- identifier.doi row -->
          <xsl:when test="$clause = 17 and (dim:field[@element='identifier' and @qualifier='doi'])">
                    <div class="simple-item-view-other">
	                <span class="bold">DOI:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
		                    <a>
		                        <xsl:attribute name="href">
		                            http://dx.doi.org/<xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>            
          
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 18 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject row -->
          <xsl:when test="$clause = 19  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 20 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 21 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 22 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 23 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 24 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 25 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 26 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 27">
              <xsl:call-template name="itemSummaryView-DIM-fields-Contributo-in-un-libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Contributo in un libro end -->
	
	
	<!-- Libro start -->
	<xsl:template name="itemSummaryView-DIM-fields-Libro">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
      	   <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
      
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                        
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 6 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- publisher row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='publisher'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Editore:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='publisher'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='publisher']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- description.numeropagine row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='description' and @qualifier='numeropagine'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Pagine:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='numeropagine'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='numeropagine']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartof row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='relation' and @qualifier='ispartof'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolo della serie:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartof'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartof']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- relation.ispartofseries row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='relation' and @qualifier='ispartofseries'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Volume/Numero:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='relation' and @qualifier='ispartofseries'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='relation' and @qualifier='ispartofseries']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>          
          
         
          
         <!-- identifier.isbn row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='identifier' and @qualifier='isbn'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">ISBN:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='isbn'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='isbn']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- identifier.doi row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='identifier' and @qualifier='doi'])">
                    <div class="simple-item-view-other">
	                <span class="bold">DOI:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
		                    <a>
		                        <xsl:attribute name="href">
		                            http://dx.doi.org/<xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>            
          
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject row -->
          <xsl:when test="$clause = 16  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 17 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 18 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 19 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 20 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 21 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 22 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 23 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 24">
              <xsl:call-template name="itemSummaryView-DIM-fields-Libro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Libro end -->
    
    <!-- Scheda progetto start -->
	<xsl:template name="itemSummaryView-DIM-fields-Scheda-progetto">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                        <span class="bold">Soggetti Attuatori:</span>
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                		<xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Data inizio:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='date' and @qualifier='issued'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- date.datafine row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='date' and @qualifier='datafine'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Data fine:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='date' and @qualifier='datafine'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='datafine']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- description.finanziamenti row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='finanziamenti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Finanziamenti:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='description' and @qualifier='finanziamenti']">
		                    <xsl:copy-of select="substring-after(./node(),'Finanziamenti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='finanziamenti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
                    
                    
          <!-- contributor.other row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Referenti:</span>
	                	<span>	                		
		                    <xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    	</xsl:for-each>		                    		                                       
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>  
          
          
          
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
         
                   
          <!-- subject row -->
          <xsl:when test="$clause = 11  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 12 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 13 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
         

          <!-- Description row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 16 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 17 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 18">
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Scheda progetto end -->
	
	<!-- Scheda progetto CRS4 start -->
	<xsl:template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <!--  
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                        <span class="bold">Soggetti Attuatori:</span>
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                		<xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          -->
          
          <!-- Reference row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='identifier' and @qualifier='reference'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Reference:</span>
	                	<span>
	                		<xsl:value-of select="(dim:field[@element='identifier' and @qualifier='reference'])[1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='reference']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!--Call Reference row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='identifier' and @qualifier='callreference'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Call Reference:</span>
	                	<span>
	                		<xsl:value-of select="(dim:field[@element='identifier' and @qualifier='callreference'])[1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='callreference']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- Istituzioni partner row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and @qualifier='partner'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>	                    
		                    <xsl:for-each select="dim:field[@element='contributor' and @qualifier='partner']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='partner']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>
		                    
		                                        
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
                 
          
          <!-- Abstract row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Data inizio:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='date' and @qualifier='issued'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- date.datafine row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='date' and @qualifier='datafine'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Data fine:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='date' and @qualifier='datafine'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='datafine']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- Contributo row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='description' and @qualifier='contributionbudget'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Contributo:</span>
	                	<span>
	                		<xsl:value-of select="(dim:field[@element='description' and @qualifier='contributionbudget'])[1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='contributionbudget']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- Contributo CRS4 row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='description' and @qualifier='contributionbudgetCRS4'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Contributo del CRS4:</span>
	                	<span>
	                		<xsl:value-of select="(dim:field[@element='description' and @qualifier='contributionbudgetCRS4'])[1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='contributionbudgetCRS4']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
                            
          <!-- contributor.other row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Referenti:</span>
	                	<span>	                		
		                    <xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    	</xsl:for-each>		                    		                                       
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>         
          
          
           <!-- subject.program row Unità Organizzativa-->
          <xsl:when test="$clause = 12 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
         
                   
          <!-- subject row -->
          <xsl:when test="$clause = 14  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 15 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 16 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          <!-- identifier.websiteproject row -->
          <xsl:when test="$clause = 17 and (dim:field[@element='identifier' and @qualifier='websiteproject'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Sito web del progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='websiteproject']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='websiteproject']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
                 

          <!-- Description row -->
          <xsl:when test="$clause = 18 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 19 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 20 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 21">
              <xsl:call-template name="itemSummaryView-DIM-fields-Scheda-progetto-CRS4">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Scheda progetto CRS4 end -->
    
    <!-- Tesi start -->
	<xsl:template name="itemSummaryView-DIM-fields-Tesi">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
         
          
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor.advisor row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and @qualifier='advisor'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Relatore:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='contributor' and @qualifier='advisor'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='advisor']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 5 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- description.status row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='description' and @qualifier='status'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Stato:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='status'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='status']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
         
          
          <!-- identifier.citation row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='identifier' and @qualifier='citation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Citazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='citation'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='citation']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- subject row -->
          <xsl:when test="$clause = 10  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 11 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 12 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 16 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 17 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 18">
              <xsl:call-template name="itemSummaryView-DIM-fields-Tesi">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Tesi end -->
	
	<!-- Working paper start -->
	<xsl:template name="itemSummaryView-DIM-fields-Working-paper">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
      
          
          
          
          <!-- Title row -->
          <xsl:when test="$clause = 1">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 2 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          
          <!-- contributor row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                        
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 5 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- description.status row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='description' and @qualifier='status'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Stato:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='status'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='status']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                    
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- identifier.doi row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='identifier' and @qualifier='doi'])">
                    <div class="simple-item-view-other">
	                <span class="bold">DOI:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
		                    <a>
		                        <xsl:attribute name="href">
		                            http://dx.doi.org/<xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
                            
          <!-- subject row -->
          <xsl:when test="$clause = 10  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 11 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 12 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 16 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 17 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 18">
              <xsl:call-template name="itemSummaryView-DIM-fields-Working-paper">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Working paper end -->
	
	<!-- Altro start -->
	<xsl:template name="itemSummaryView-DIM-fields-Altro">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
           <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          
          <!-- Author(s) row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor'][@qualifier='author'] or dim:field[@element='creator'] )">
                    <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
	                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                        <span>
                                          <xsl:if test="@authority">
                                            <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                          </xsl:if>
	                                <xsl:copy-of select="node()"/>
                                        </span>
	                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:when test="dim:field[@element='creator']">
	                            <xsl:for-each select="dim:field[@element='creator']">
	                                <xsl:copy-of select="node()"/>
	                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
	                                    <xsl:text>; </xsl:text>
	                                </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>
	                        <xsl:otherwise>
	                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
	                        </xsl:otherwise>
	                    </xsl:choose>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
           <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 5 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
          <!-- type row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='type'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Tipologia:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='type'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- contributor row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <!-- format.medium row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='format' and @qualifier='medium'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Supporto fisico:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='format' and @qualifier='medium'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='format' and @qualifier='medium']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
         
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
                             
          <!-- subject row -->
          <xsl:when test="$clause = 11  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 12 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 13 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 17 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 18 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 19">
              <xsl:call-template name="itemSummaryView-DIM-fields-Altro">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
    </xsl:template>
	<!-- Altro end -->
	
	<!-- Brevetto start -->
	<xsl:template name="itemSummaryView-DIM-fields-Brevetto">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
           <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>        
          
          
          
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          <!-- contributor.inventorperson row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and @qualifier='inventorperson'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Inventore:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='inventorperson']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='inventorperson']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                   
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
           <!-- contributor.inventororganisation row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and @qualifier='inventororganisation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Inventore:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='inventororganisation']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='inventororganisation']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                       
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- contributor.author row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='contributor' and @qualifier='author'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolare:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='author']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                       
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- contributor.other row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolare:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each> 	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
         
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 8 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
          <!-- contributor row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
         
                    
          <!-- date.issued row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Data di pubblicazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='date' and @qualifier='issued'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- identifier.patentnumber row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='identifier' and @qualifier='patentnumber'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Numero di pubblicazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='patentnumber'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='patentnumber']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
                   
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 13 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
                             
          <!-- subject row -->
          <xsl:when test="$clause = 14  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 15 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 16 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>                             
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 17 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- Description row -->
          <xsl:when test="$clause = 18 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 19 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 20 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 21">
              <xsl:call-template name="itemSummaryView-DIM-fields-Brevetto">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
          
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
       
        
    </xsl:template>
	<!-- Brevetto end -->
	
	<!-- Marchio registrato start -->
	<xsl:template name="itemSummaryView-DIM-fields-Marchio-registrato">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
           <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>        
      
          
      
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
           <!-- contributor.author row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and @qualifier='author'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolare:</span>
	                	<span>
	                		
		                    <xsl:for-each select="dim:field[@element='contributor' and @qualifier='author']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                      
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- contributor.other row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolare-Organizzazione:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>  	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 6 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
          <!-- contributor row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>    	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 8 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
                   
                    
           <!-- identifier.other row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='identifier' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Numero di pubblicazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='other'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='other']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
                  
                 
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
                 
                          
          <!-- subject row -->
          <xsl:when test="$clause = 11  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 12 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 13 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 14 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 15 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 17 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 18 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 19">
              <xsl:call-template name="itemSummaryView-DIM-fields-Marchio-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
        
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
        
    </xsl:template>
	<!-- Marchio registrato end -->
	
	<!-- Design registrato start -->
	<xsl:template name="itemSummaryView-DIM-fields-Design-registrato">
      <xsl:param name="clause" select="'1'"/>
      <xsl:param name="phase" select="'even'"/>
      <xsl:variable name="otherPhase">
            <xsl:choose>
              <xsl:when test="$phase = 'even'">
                <xsl:text>odd</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>even</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>

      <xsl:choose>
           <!-- Type row -->
          <xsl:when test="$clause = 1 and (dim:field[@element='type'])">
                   <div class="simple-item-view-authors">
	                    <xsl:choose>
	                        <xsl:when test="dim:field[@element='type']">
	                            <xsl:for-each select="dim:field[@element='type']">
                                        <span>
                                          <xsl:copy-of select="node()"/>
                                        </span>
	                                      <xsl:if test="count(following-sibling::dim:field[@element='type']) != 0">
	                                        <xsl:text>; </xsl:text>
	                                      </xsl:if>
	                            </xsl:for-each>
	                        </xsl:when>	                        
	                    </xsl:choose>
	               </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>        
      
          
          
          <!-- Title row -->
          <xsl:when test="$clause = 2">

              <xsl:choose>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 1">
                      <!-- display first title as h1 -->
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                      <div class="simple-item-view-other">
                          <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span>
                          <span>
                              <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                                  <xsl:value-of select="./node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
                                      <xsl:text>; </xsl:text>
                                      <br/>
                                  </xsl:if>
                              </xsl:for-each>
                          </span>
                      </div>
                  </xsl:when>
                  <xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) = 1">
                      <h1>
                          <xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()"/>
                      </h1>
                  </xsl:when>
                  <xsl:otherwise>
                      <h1>
                          <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                      </h1>
                  </xsl:otherwise>
              </xsl:choose>
            <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
              <xsl:with-param name="clause" select="($clause + 1)"/>
              <xsl:with-param name="phase" select="$otherPhase"/>
            </xsl:call-template>
          </xsl:when>

          <!-- title.alternative row -->
          <xsl:when test="$clause = 3 and (dim:field[@element='title' and @qualifier='alternative'])">
                    <div class="simple-item-view-other">
	                <span>
	                  <h1>
	                	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='title' and @qualifier='alternative']) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                  </h1>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>   
          
          <!-- contributor.inventorperson row -->
          <xsl:when test="$clause = 4 and (dim:field[@element='contributor' and @qualifier='inventorperson'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Autore:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='inventorperson']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='inventorperson']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                      
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- contributor.inventororganisation row -->
          <xsl:when test="$clause = 5 and (dim:field[@element='contributor' and @qualifier='inventororganisation'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Autore-Organizzazione:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='inventororganisation']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='inventororganisation']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                     
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          <!-- contributor.author row -->
          <xsl:when test="$clause = 6 and (dim:field[@element='contributor' and @qualifier='author'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolare:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='author']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='author']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>  	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- contributor.other row -->
          <xsl:when test="$clause = 7 and (dim:field[@element='contributor' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Titolare-Organizzazione:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and @qualifier='other']">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor' and @qualifier='other']) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                      
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
         
          <!-- subject.program row  Unità organizzativa-->
          <xsl:when test="$clause = 8 and (dim:field[@element='subject' and @qualifier='program'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Unità organizzativa:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='program']">
		                    <xsl:copy-of select="substring-after(./node(),'Program::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='program']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when> 
          
          <!-- contributor row -->
          <xsl:when test="$clause = 9 and (dim:field[@element='contributor' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Istituzioni partner:</span>
	                	<span>
	                		<xsl:for-each select="dim:field[@element='contributor' and not(@qualifier)]">
		                    	<xsl:copy-of select="./node()"/>
		                      		<xsl:if test="count(following-sibling::dim:field[@element='contributor'and not(@qualifier)]) != 0">
		                      			<xsl:text>; </xsl:text>
		                    			<br/>
		                    		</xsl:if>
	                    	</xsl:for-each>                        
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
           <!-- Abstract row -->
          <xsl:when test="$clause = 10 and (dim:field[@element='description' and @qualifier='abstract' and descendant::text()])">
                    <div class="simple-item-view-description">
	                <h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
	                	<div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <xsl:choose>
                            <xsl:when test="node()">
                                <xsl:copy-of select="node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--  <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                        -->
                            <div class="spacer">&#160;</div>
	                   <!--  </xsl:if> 
	                   -->
	              	</xsl:for-each>
	              	<xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                          <div class="spacer">&#160;</div>                          
	                </xsl:if>
	                </div>
	                </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
                    
           <!-- identifier.other row -->
          <xsl:when test="$clause = 11 and (dim:field[@element='identifier' and @qualifier='other'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Numero di pubblicazione:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='identifier' and @qualifier='other'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='other']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
         
          
          <!-- identifier.uri row -->
          <xsl:when test="$clause = 12 and (dim:field[@element='identifier' and @qualifier='uri'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
		                    <a>
		                        <xsl:attribute name="href">
		                            <xsl:copy-of select="./node()"/>
		                        </xsl:attribute>
		                        <xsl:copy-of select="./node()"/>
		                    </a>
		                    <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
		                    	<br/>
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
              
                   
          <!-- subject row -->
          <xsl:when test="$clause = 13  and (dim:field[@element='subject' and not(@qualifier)])">
                    <div class="simple-item-view-other">
	                <span class="bold">Keywords:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and not(@qualifier)]">
		                    <xsl:copy-of select="./node()"/>
		                      <xsl:if test="count(following-sibling::dim:field[@element='subject' and not(@qualifier)]) != 0">
		                      	<xsl:text>; </xsl:text>
		                    	
		                    </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>    
          
         <!-- subject.progetti row  -->
          <xsl:when test="$clause = 14 and (dim:field[@element='subject' and @qualifier='progetti'])">
                    <div class="simple-item-view-other">
	                <span class="bold">Progetto:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='progetti']">
		                    <xsl:copy-of select="substring-after(./node(),'Progetti::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='progetti']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
         
         
          <!-- subject.een-cordis row  -->
          <xsl:when test="$clause = 15 and (dim:field[@element='subject' and @qualifier='een-cordis'])">
                    <div class="simple-item-view-other">
	                <span class="bold">EEN-CORDIS:</span>
	                <span>
	                	<xsl:for-each select="dim:field[@element='subject' and @qualifier='een-cordis']">
		                    <xsl:copy-of select="substring-after(./node(),'EEN CORDIS::')"/>
		                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='een-cordis']) != 0">
		                        	<xsl:text>; </xsl:text>
		                    		<br/>
		                        </xsl:if>
	                    </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>  
          
          
                           
          
          <!-- description.sponsorship row -->
          <xsl:when test="$clause = 16 and (dim:field[@element='description' and @qualifier='sponsorship'])">
                    <div class="simple-item-view-other">
	                	<span class="bold">Sponsors:</span>
	                	<span>
	                		<xsl:value-of select="dim:field[@element='description' and @qualifier='sponsorship'][1]/node()"/>
	                		<xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='sponsorship']) != 0">
		                    	<br/>
		                    </xsl:if>	                    
	                	</span>
	            	</div>
              		<xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                		<xsl:with-param name="clause" select="($clause + 1)"/>
                		<xsl:with-param name="phase" select="$otherPhase"/>
              		</xsl:call-template>
          </xsl:when>
          
          
          <!-- date.issued row -->
          <xsl:when test="$clause = 17 and (dim:field[@element='date' and @qualifier='issued'])">
                    <div class="simple-item-view-other">
	                <span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span>
	                <span>
		                <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
		                	<xsl:copy-of select="substring(./node(),1,10)"/>
		                	 <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
	                    	<br/>
	                    </xsl:if>
		                </xsl:for-each>
	                </span>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

         

          <!-- Description row -->
          <xsl:when test="$clause = 18 and (dim:field[@element='description' and not(@qualifier)])">
                <div class="simple-item-view-description">
	                <h3 class="bold">Informazioni aggiuntive:</h3>
	                <div>
	                <xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1 and not(count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1)">
                        <div class="spacer">&#160;</div>
	                </xsl:if>
	                <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
		                <xsl:copy-of select="./node()"/>
		                <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <div class="spacer">&#160;</div>
	                    </xsl:if>
	               	</xsl:for-each>
	               	<xsl:if test="count(dim:field[@element='description' and not(@qualifier)]) &gt; 1">
                           <div class="spacer">&#160;</div>
	                </xsl:if>
	                </div>
	            </div>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>

          <xsl:when test="$clause = 19 and $ds_item_view_toggle_url != ''">
              <p class="ds-paragraph item-view-toggle item-view-toggle-bottom">
                  <a>
                      <xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url"/></xsl:attribute>
                      <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
                  </a>
              </p>
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$otherPhase"/>
              </xsl:call-template>
          </xsl:when>
          
          <xsl:when test="$clause = 20 and (dim:field[@element='date'][@qualifier='embargoend'])">
  				<div class="simple-item-view-other">
    				<h4>
      					<xsl:value-of select="dim:field[@element='embargo'][@qualifier='description'][1]/node()"/>
     					<br />
      					<!--  <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-embargoMsg</i18n:text> -->
      					Questo item è sotto embargo fino al: 
      					<xsl:copy-of select="substring(dim:field[@element='date'][@qualifier='embargoend'][1]/node(),1,10)"/>
    				</h4>
  				</div>  		
		  </xsl:when>

          <!-- recurse without changing phase if we didn't output anything -->
          <xsl:otherwise>
            <!-- IMPORTANT: This test should be updated if clauses are added! -->
            <xsl:if test="$clause &lt; 21">
              <xsl:call-template name="itemSummaryView-DIM-fields-Design-registrato">
                <xsl:with-param name="clause" select="($clause + 1)"/>
                <xsl:with-param name="phase" select="$phase"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>

         <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->        
           
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
        
        
    </xsl:template>
	<!-- Design registrato end -->
	
    
    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <table class="ds-includeSet-table detailtable">
		    <xsl:apply-templates mode="itemDetailView-DIM"/>
		</table>
        <span class="Z3988">
            <xsl:attribute name="title">
                 <xsl:call-template name="renderCOinS"/>
            </xsl:attribute>
            &#xFEFF; <!-- non-breaking space to force separating the end tag -->
        </span>
        <xsl:copy-of select="$SFXLink" />
    </xsl:template>

    <xsl:template match="dim:field" mode="itemDetailView-DIM">
            <tr>
                <xsl:attribute name="class">
                    <xsl:text>ds-table-row </xsl:text>
                    <xsl:if test="(position() div 2 mod 2 = 0)">even </xsl:if>
                    <xsl:if test="(position() div 2 mod 2 = 1)">odd </xsl:if>
                </xsl:attribute>
                <td class="label-cell">
                    <xsl:value-of select="./@mdschema"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="./@element"/>
                    <xsl:if test="./@qualifier">
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="./@qualifier"/>
                    </xsl:if>
                </td>
            <td>
              <xsl:copy-of select="./node()"/>
              <xsl:if test="./@authority and ./@confidence">
                <xsl:call-template name="authorityConfidenceIcon">
                  <xsl:with-param name="confidence" select="./@confidence"/>
                </xsl:call-template>
              </xsl:if>
            </td>
                <td><xsl:value-of select="./@language"/></td>
            </tr>
    </xsl:template>

    <!-- don't render the item-view-toggle automatically in the summary view, only when it gets called -->
    <xsl:template match="dri:p[contains(@rend , 'item-view-toggle') and
        (preceding-sibling::dri:referenceSet[@type = 'summaryView'] or following-sibling::dri:referenceSet[@type = 'summaryView'])]">
    </xsl:template>

    <!-- don't render the head on the item view page -->
    <xsl:template match="dri:div[@n='item-view']/dri:head" priority="5">
    </xsl:template>

        <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>

        <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
        <div class="file-list">
            <xsl:choose>
                <!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Otherwise, iterate over and display all of them -->
                <xsl:otherwise>
                    <xsl:apply-templates select="mets:file">
                     	<!--Do not sort any more bitstream order can be changed-->
                        <!--<xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />-->
                        <!--<xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>-->
                        <xsl:with-param name="context" select="$context"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <div class="file-wrapper clearfix">
            <div class="thumbnail-wrapper" style="width: {$thumbnail.maxwidth}px;">
                <a class="image-link">
                    <xsl:attribute name="href">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">
                            <img alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                    mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:otherwise>
                            <img alt="Icon" src="{concat($theme-path, '/images/mime.png')}" style="height: {$thumbnail.maxheight}px;"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:href,'isAllowed=n')">
                        <img>
                            <xsl:attribute name="src">
                                <xsl:value-of select="$context-path"/>
                                <xsl:text>/static/icons/lock24.png</xsl:text>
                            </xsl:attribute>
                           <xsl:attribute name="alt">xmlui.dri2xhtml.METS-1.0.blocked</xsl:attribute>
                           <xsl:attribute name="attr" namespace="http://apache.org/cocoon/i18n/2.1">alt</xsl:attribute>
                        </img>
                     </xsl:if>
                </a>
            </div>
            <div class="file-metadata" style="height: {$thumbnail.maxheight}px;">
                <div>
                    <span class="bold">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>:</xsl:text>
                    </span>
                    <span>
                        <xsl:attribute name="title"><xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/></xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 17, 5)"/>
                    </span>
                </div>
                <!-- File size always comes in bytes and thus needs conversion -->
                <div>
                    <span class="bold">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>:</xsl:text>
                    </span>
                    <span>
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>
                </div>
                <!-- Lookup File Type description in local messages.xml based on MIME Type.
         In the original DSpace, this would get resolved to an application via
         the Bitstream Registry, but we are constrained by the capabilities of METS
         and can't really pass that info through. -->
                <div>
                    <span class="bold">
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </span>
                    <span>
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </span>
                </div>
                <!---->
                <!-- Display the contents of 'Description' only if bitstream contains a description -->
                <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                    <div>
                        <span class="bold">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>:</xsl:text>
                        </span>
                        <span>
                            <xsl:attribute name="title"><xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/></xsl:attribute>
                            <!--<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>-->
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 17, 5)"/>
                        </span>
                    </div>
                </xsl:if>
            </div>
            <div class="file-link" style="height: {$thumbnail.maxheight}px;">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="view-open">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
            </xsl:attribute>
            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
        </a>
    </xsl:template>

    <xsl:template name="display-rights">
        <xsl:variable name="file_id" select="jstring:replaceAll(jstring:replaceAll(string(@ADMID), '_METSRIGHTS', ''), 'rightsMD_', '')"/>
        <xsl:variable name="rights_declaration" select="../../../mets:amdSec/mets:rightsMD[@ID = concat('rightsMD_', $file_id, '_METSRIGHTS')]/mets:mdWrap/mets:xmlData/rights:RightsDeclarationMD"/>
        <xsl:variable name="rights_context" select="$rights_declaration/rights:Context"/>
        <xsl:variable name="users">
              <xsl:choose>
                  <xsl:when test="not ($rights_context)">
                     <xsl:text>administrators only</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="$rights_declaration/*">
                      <xsl:value-of select="rights:UserName"/>
                      <xsl:choose>
                          <xsl:when test="rights:UserName/@USERTYPE = 'GROUP'">
                             <xsl:text> (group)</xsl:text>
                          </xsl:when>
                          <xsl:when test="rights:UserName/@USERTYPE = 'INDIVIDUAL'">
                             <xsl:text> (individual)</xsl:text>
                          </xsl:when>
                      </xsl:choose>
                      <xsl:if test="position() != last()">, </xsl:if> <!-- TODO fix ending comma -->
                    </xsl:for-each>
                  </xsl:otherwise>
              </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="(not ($rights_context/@CONTEXTCLASS = 'GENERAL PUBLIC') and ($rights_context/rights:Permissions/@DISPLAY = 'true')) or not ($rights_context)">
                <a href="{mets:FLocat[@LOCTYPE='URL']/@xlink:href}">
                    <img width="64" height="64" src="{concat($theme-path,'/images/Crystal_Clear_action_lock3_64px.png')}" title="Read access available for {$users}"/>
                    <!-- icon source: http://commons.wikimedia.org/wiki/File:Crystal_Clear_action_lock3.png -->
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="view-open"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
