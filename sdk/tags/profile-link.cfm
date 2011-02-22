<cfsilent>
	<cfparam name="attributes.class" default="facebook user display link" />
	<cfparam name="attributes.facebookId" />
	<cfparam name="attributes.label" default="Facebook profile" />
	<cfparam name="attributes.toolType" default="#attributes.label#" />
	<cfset profileUrl = "http://www.facebook.com/profile.php?id=" & attributes.facebookId />
</cfsilent>
<cfoutput><a class="#attributes.class#" href="#profileUrl#" title="#attributes.toolType#"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />
