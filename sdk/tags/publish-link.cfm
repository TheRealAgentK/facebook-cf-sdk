<cfsilent>
	<cfparam name="attributes.caption" default="" />
	<cfparam name="attributes.class" default="post publish link" />
	<cfparam name="attributes.description" default="" />
	<cfparam name="attributes.disabled" default="false" />
	<cfparam name="attributes.label" default="Publish" />
	<cfparam name="attributes.link" default="" />
	<cfparam name="attributes.toolType" default="Publish" />
	<cfparam name="attributes.message" default="" />
	<cfparam name="attributes.name" default="" />
	<cfparam name="attributes.picture" default="" />
	<cfparam name="attributes.source" default="" />
	<cfparam name="attributes.style" default="" />
	<cfset attributes.description = replace(attributes.description, "'", "\'", "all") />
	<cfset attributes.label = replace(attributes.label, "'", "\'", "all") />
	<cfset attributes.name = replace(attributes.name, "'", "\'", "all") />
</cfsilent>
<cfoutput><a class="#attributes.class#" onclick="<cfif not attributes.disabled>FB.ui({'caption':'#attributes.caption#', 'description':'#attributes.description#', 'link':'#attributes.link#', 'method':'feed','message':'#attributes.message#', 'name':'#attributes.name#', 'picture':'#attributes.picture#', 'source':'#attributes.source#'}); </cfif>return false;"<cfif attributes.style is not ""> style="#attributes.style#"</cfif> title="#attributes.toolType#"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />