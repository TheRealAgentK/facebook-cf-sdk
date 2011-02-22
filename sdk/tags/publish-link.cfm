<cfsilent>
	<cfparam name="attributes.caption" default="" />
	<cfparam name="attributes.class" default="post publish link" />
	<cfparam name="attributes.description" default="" />
	<cfparam name="attributes.label" default="Publish" />
	<cfparam name="attributes.link" default="" />
	<cfparam name="attributes.toolType" default="Publish" />
	<cfparam name="attributes.message" default="" />
	<cfparam name="attributes.name" default="" />
	<cfparam name="attributes.picture" default="" />
	<cfparam name="attributes.source" default="" />
</cfsilent>
<cfoutput><a class="#attributes.class#" onclick="FB.ui({'caption':'', 'description':'', 'link':'', 'method':'stream.publish','message':'#attributes.message#', 'name':'', 'picture':'', 'source':''}); return false;" title="#attributes.toolType#"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />