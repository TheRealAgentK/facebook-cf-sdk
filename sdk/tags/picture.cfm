<cfsilent>
	<cfparam name="attributes.class" default="facebook user picture" />
	<cfparam name="attributes.facebookId" />
	<cfparam name="attributes.type" default="square" />
	<cfswitch expression="#attributes.type#">
	<cfcase value="large">
		<cfset height = "" />
		<cfset width = 200 />
	</cfcase>
	<cfcase value="mini">
		<cfset height = 32 />
		<cfset width = 32 />
		<cfset attributes.type = "square" />
	</cfcase>
	<cfcase value="small">
		<cfset height = "" />
		<cfset width = 50 />
	</cfcase>
	<cfdefaultcase>
		<cfset height = 50 />
		<cfset width = 50 />
	</cfdefaultcase>
	</cfswitch>
</cfsilent>
<cfoutput><img src="http://graph.facebook.com/#attributes.facebookId#/picture?type=#attributes.type#" class="#attributes.class#" <cfif isNumeric(height)>height="#height#"</cfif> width="#width#"/></cfoutput>
<cfexit method="exittag" />
