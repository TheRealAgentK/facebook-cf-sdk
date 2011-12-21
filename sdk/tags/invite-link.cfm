<cfsilent>
	<cfparam name="attributes.class" default="invite link" />
	<cfparam name="attributes.data" default="" />
	<cfparam name="attributes.disabled" default="false" />
	<cfparam name="attributes.excludeIds" default="" />
	<cfparam name="attributes.filters" default="all" /><!--- all, app_users or app_non_users --->
	<cfparam name="attributes.display" default="" />
	<cfparam name="attributes.label" default="Invite" />
	<cfparam name="attributes.message" default="" />
	<cfparam name="attributes.recipientMaxCount" default="0" />
	<cfparam name="attributes.style" default="" />
	<cfparam name="attributes.title" default="" />
	<cfparam name="attributes.to" default="" />
	<cfparam name="attributes.toolType" default="Invite" />
</cfsilent>
<cfoutput>
<script type="text/javascript" charset="utf-8">
var onInviteButtonClick = function () {
	<cfif not attributes.disabled>
		FB.ui({method: 'apprequests', message: '#jsStringFormat(attributes.message)#'
		<cfif attributes.data is not ''>, data: '#attributes.data#'</cfif>
		<cfif len(attributes.display)>, 'display': '#attributes.display#'</cfif>
 		<cfif attributes.excludeIds is not ''>, exclude_ids: '#attributes.excludeIds#'</cfif>
		<cfif attributes.recipientMaxCount>, max_recipients: #attributes.recipientMaxCount#</cfif>
		<cfif attributes.title is not ''>, title: '#jsStringFormat(attributes.title)#'</cfif>
		<cfif attributes.to is not ''>, to: '#attributes.to#'</cfif>}); 
	</cfif>
	return false;
}
</script>

<a class="#attributes.class#" onclick="onInviteButtonClick()"<cfif attributes.style is not ""> style="#attributes.style#"</cfif> title="#attributes.toolType#"><span>#attributes.label#</span></a>
</cfoutput>
<cfexit method="exittag" />