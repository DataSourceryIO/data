<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html"/>

  <xsl:template match="/">
    <h1>Rate Table</h1>
    <xsl:apply-templates select="Table"/>
  </xsl:template>

  <xsl:template match="Table">
    <table border='1'>
    <xsl:apply-templates select="Row"/>
    </table>
  </xsl:template>

  <xsl:template match="Row">
    <tr>
    <xsl:apply-templates select="Cell"/>
    </tr>
  </xsl:template>

  <xsl:template match="Cell[Label][not(preceding-sibling::Cell[Label])]">
    <th>
    <xsl:value-of select="Label"/>
    </th>
  </xsl:template>

  <xsl:template match="Cell[Label][preceding-sibling::Cell[Label]]">
    <xsl:variable name="currentLabel" select="Label/text()"/>
    <xsl:if test="not(preceding-sibling::Cell[1]/Label/text() = $currentLabel)">
      <th>
      <xsl:attribute name="colspan">
        <xsl:variable name="counter">
          <xsl:apply-templates select="following-sibling::Cell[1]" mode="count">
            <xsl:with-param name="currentLabel" select = "$currentLabel" />
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:value-of select="1+string-length($counter)"/>
      </xsl:attribute>
      <div><xsl:value-of select="Label"/></div>
      </th>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Cell[Label]" mode="count">
    <xsl:param name="currentLabel"/>
    <xsl:if test="Label/text() = $currentLabel">
      <xsl:text>.</xsl:text>
      <xsl:apply-templates select="following-sibling::Cell[1]" mode="count">
        <xsl:with-param name="currentLabel" select = "$currentLabel" />
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Cell[Value]">
    <td align='right'>
    <xsl:value-of select="Value"/>
    </td>
  </xsl:template>

</xsl:stylesheet>