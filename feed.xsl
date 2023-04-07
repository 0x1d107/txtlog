<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:atom="http://www.w3.org/2005/Atom">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/rss/channel">
        <html>
            <head>
                <title>
                    <xsl:value-of select="title" />
                </title>
                <link rel="stylesheet" href="feed.css"/>
                <link rel="alternate" href="/" type="application/rss+xml" title="RSS"/>
            </head>
            <body>
                <h1><a href="{link}"><xsl:value-of select="title" /></a></h1>

                <ul id="feed">
                    <xsl:apply-templates select="item" />
                </ul>
                <xsl:apply-templates select="atom:link[@rel='next']" />
            </body>
        </html>
    </xsl:template>
    <xsl:template match="item">
        <li>
            <div class="source"><b>[<xsl:value-of select="pubDate"/>]</b></div> 
            <h2>
                <xsl:choose>
                    <xsl:when test="link">
                        <a href="{link}"><xsl:value-of select="title"/></a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="title" />
                    </xsl:otherwise>
                </xsl:choose>
            </h2>
            <p >
                <xsl:value-of select="description"/>
            </p>
        </li>
    </xsl:template>

</xsl:stylesheet>
