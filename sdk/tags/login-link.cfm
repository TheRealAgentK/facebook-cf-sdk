<cfif thisTag.executionMode is "end"><cfsetting enablecfoutputonly="false">
<cfsilent>
	<cfparam name="attributes.class" default="facebook user login link" />
	<cfparam name="attributes.permissions" default="" />
	<cfparam name="attributes.returnUrl" default="#cgi.HTTP_REFERER#" />
	<cfparam name="attributes.cancelUrl" default="#attributes.returnUrl#" />
	<cfset facebookPath = replaceNoCase(expandPath("/facebook" ), expandPath("/"), "/") />
	<cfif cgi.CONTEXT_PATH is not "/">
		<cfset facebookPath = cgi.CONTEXT_PATH & facebookPath />
	</cfif>
</cfsilent>
<cfoutput>
	<script type="text/javascript">
		function login() {
        	FB.login(function(response) {
				<cfif trim(thisTag.generatedContent) is "">
					if (response.authResponse) {
						// user is logged
						window.location.href = "#attributes.returnUrl#";
				  	} else {
				   		// user cancelled login
						window.location.href = "#attributes.cancelUrl#";
				  	}
				<cfelse>
					#thisTag.generatedContent#
				</cfif>
			}, {scope:"#attributes.permissions#"});
		}
	</script>

	<a id="facebookUserLoginLink" class="#attributes.class#" href="##" onclick="login();"><img src="#facebookPath#/sdk/assets/images/facebook-login.gif" height="21" width="169" /></a>
	<cfset thisTag.generatedContent = "" />
</cfoutput>
</cfif>