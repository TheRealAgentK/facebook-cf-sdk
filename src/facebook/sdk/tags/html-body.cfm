<cfsetting enablecfoutputonly="true">
<cfimport taglib="/facebook/sdk/tags" prefix="facebook" />
<cfparam name="attributes.facebookApp" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<body>
			<facebook:init facebookApp="#attributes.facebookApp#" />
	</cfoutput>
<cfelseif thisTag.executionMode is "end">
	<cfoutput></body></cfoutput>
</cfif>