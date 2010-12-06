<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8" />
<cfparam name="attributes.page" />

<cfif thisTag.executionMode is "start">
	<cfoutput><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml"xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:og="http://ogp.me/ns##">
	</cfoutput>
<cfelseif thisTag.executionMode is "end">
	<cfoutput></body>
	</html></cfoutput>
	<cfsavecontent variable="htmlHeadText">
		<cfoutput>
			<cfloop array="#attributes.page.getStyleUrls()#" index="styleUrl">
				<cfif listLen( styleUrl ) eq 2>
					<link rel="stylesheet" type="text/css" href="#listFirst( styleUrl )#" media="#listLast( styleUrl )#" />
				<cfelse>
					<link rel="stylesheet" type="text/css" href="#styleUrl#" />
				</cfif>
			</cfloop>
			<cfloop array="#attributes.page.getRssUrls()#" index="rssUrl">
				<cfif listLen( rssUrl ) eq 2>
					<link rel="alternate" type="application/rss+xml" href="#listFirst( rssUrl )#" title="#listLast( rssUrl )#"  />
				<cfelse>
					<link rel="alternate" type="application/rss+xml" href="#rssUrl#" />
				</cfif>
			</cfloop>
			<cfloop array="#attributes.page.getScriptUrls()#" index="scriptUrl">
				<script src="#scriptUrl#" type="text/javascript"></script>
			</cfloop>
		</cfoutput>
	</cfsavecontent>
	<cfhtmlhead text="#htmlHeadText#">
</cfif>