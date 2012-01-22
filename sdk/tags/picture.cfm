<cfsilent>
	<cfparam name="attributes.facebookId" />
	<cfparam name="attributes.linkEnabled" default="false" />
	<cfparam name="attributes.protocol" default="http" />
	<cfparam name="attributes.style" default="" />
	<cfparam name="attributes.target" default="" />
	<cfparam name="attributes.toolTip" default="" />
	<cfparam name="attributes.type" default="square" />
	<cfparam name="attributes.class" default="facebook user picture #attributes.type#" />
	<cfset profileUrl = "http://www.facebook.com/profile.php?id=" & attributes.facebookId />
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
<cfoutput>
<cfif attributes.linkEnabled>
	<a class="#attributes.class#" href="#profileUrl#"<cfif attributes.style is not ""> style="#attributes.style#"</cfif><cfif attributes.target is not ""> target="#attributes.target#"</cfif>  title="#attributes.toolTip#" target="_blank"></cfif>
	<img src="#attributes.protocol#://graph.facebook.com/#attributes.facebookId#/picture?type=#attributes.type#" class="#attributes.class#" <cfif isNumeric(height)>height="#height#"</cfif> width="#width#"/>
	<cfif attributes.linkEnabled></a></cfif></cfoutput>
<cfexit method="exittag" />
