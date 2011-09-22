<cfsilent>
	<cfparam name="attributes.class" default="invite link" />
	<cfparam name="attributes.data" default="" />
	<cfparam name="attributes.disabled" default="false" />
	<cfparam name="attributes.excludeIds" default="" />
	<cfparam name="attributes.filters" default="all" /><!--- all, app_users or app_non_users --->
	<cfparam name="attributes.label" default="Invite" />
	<cfparam name="attributes.message" default="" />
	<cfparam name="attributes.recipientMaxCount" default="0" />
	<cfparam name="attributes.style" default="" />
	<cfparam name="attributes.title" default="" />
	<cfparam name="attributes.to" default="" />
	<cfparam name="attributes.toolType" default="Invite" />
	<cfset attributes.message = replace(attributes.message, "'", "\'", "all") />
	<cfset attributes.title = replace(attributes.title, "'", "\'", "all") />
</cfsilent>
<cfoutput><a class="#attributes.class#" onclick="<cfif not attributes.disabled>FB.ui({method: 'apprequests', message: '#attributes.message#'<cfif attributes.data is not ''>, data: '#attributes.data#'</cfif><cfif attributes.excludeIds is not ''>, exclude_ids: '#attributes.excludeIds#'</cfif><cfif attributes.recipientMaxCount>, max_recipients: #attributes.recipientMaxCount#</cfif><cfif attributes.title is not ''>, title: '#attributes.title#'</cfif><cfif attributes.to is not ''>, to: '#attributes.to#'</cfif>}); </cfif>return false;"<cfif attributes.style is not ""> style="#attributes.style#"</cfif> title="#attributes.toolType#"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />