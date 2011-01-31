<cfsilent>
	<cfparam name="attributes.class" default="facebook user logout link" />
	<cfparam name="attributes.returnUrl" default="" />
	<cfset facebookPath = replaceNoCase(expandPath("/facebook"), expandPath("/"), "/") />
</cfsilent>
<cfoutput>
	<script>
		function logout() {
        	FB.logout( function( response ) {
				<cfif attributes.returnUrl is "">
					window.location.reload();
				<cfelse>
					window.location.href = "#attributes.returnUrl#";
				</cfif>
			});
		}
	</script>

	<a id="facebookUserLogoutLink" class="#attributes.class#" href="##" onclick="logout();"><img src="#facebookPath#/sdk/assets/images/facebook-logout.gif" height="22" width="149" /></a>
</cfoutput>
<cfexit method="exittag" />