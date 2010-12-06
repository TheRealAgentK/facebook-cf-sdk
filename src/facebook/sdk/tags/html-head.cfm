<cfsetting enablecfoutputonly="true">
<cfimport taglib="/facebook/sdk/tags" prefix="facebook" />
<cfparam name="attributes.facebookApp" />
<cfparam name="attributes.page" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
	<head>
		<title>#attributes.page.getTitle()#</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<meta http-equiv="content-language" content="#attributes.page.getLanguageCode()#" />
		<meta name="language" content="#attributes.page.getLanguageCode()#" />
		<meta name="title" content="#attributes.page.getTitle()#" />
		<meta name="description" content="#attributes.page.getDescription()#" />
		<meta name="keywords" content="#attributes.page.getKeywords()#" />
		<meta name="robots" content="#attributes.page.getRobots()#" />
		<meta property="fb:app_id" content="#attributes.facebookApp.getAppId()#" />
		<facebook:html-opengraph-metadata description="#attributes.page.getDescription()#" image="#attributes.page.getImageUrl()#" siteName="#attributes.page.getSiteName()#" title="#attributes.page.getTitle()#" type="#attributes.page.getType()#" />
		<link rel="icon" type="image/png" href="#attributes.page.getIconUrl()#" />
	</cfoutput>
<cfelseif thisTag.executionMode is "end">
	<cfoutput></head></cfoutput>
</cfif>