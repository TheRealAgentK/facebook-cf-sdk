<cfsilent>
	<cfparam name="attributes.class" default="facebook user display link" />
	<cfparam name="attributes.facebookId" />
	<cfparam name="attributes.label" default="Facebook profile" />
	<cfparam name="attributes.style" default="" />
	<cfparam name="attributes.target" default="" />
	<cfparam name="attributes.toolType" default="#attributes.label#" />
	<cfset profileUrl = "http://www.facebook.com/profile.php?id=" & attributes.facebookId />
</cfsilent>
<cfoutput><a class="#attributes.class#" href="#profileUrl#"<cfif attributes.style is not ""> style="#attributes.style#"</cfif><cfif attributes.target is not ""> target="#attributes.target#"</cfif>  title="#attributes.toolType#" target="_blank"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />
