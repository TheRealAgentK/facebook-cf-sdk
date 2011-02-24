<cfsilent>
	<cfparam name="attributes.class" default="post share link" />
	<cfparam name="attributes.label" default="Share" />
	<cfparam name="attributes.style" default="" />
	<cfparam name="attributes.toolType" default="Share" />
	<cfparam name="attributes.url" />
</cfsilent>
<cfoutput><a class="#attributes.class#" href="#attributes.url#" onclick="FB.ui({'method':'stream.share','u':'#attributes.url#'}); return false;"<cfif attributes.style is not ""> style="#attributes.style#"</cfif> title="#attributes.toolType#"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />