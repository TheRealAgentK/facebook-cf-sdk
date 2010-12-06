<cfsilent>
	<cfparam name="attributes.class" default="facebook user login link" />
	<cfparam name="attributes.permissions" default="" />
	<cfparam name="attributes.returnUrl" default="#cgi.HTTP_REFERER#" />
	<cfparam name="attributes.cancelUrl" default="#attributes.returnUrl#" />
	<cfset facebookPath = replaceNoCase(expandPath("/facebook" ), expandPath("/"), "/") />
</cfsilent>
<cfoutput>
	<script>
		function login() {
        	FB.login(function(response) {
				if (response.session) {
			    	// user successfully authenticated in
					window.location.href = "#attributes.returnUrl#";
			  	} else {
			   		// user cancelled login
					window.location.href = "#attributes.cancelUrl#";
			  	}
			}, {perms:"#attributes.permissions#"});
		}
	</script>

	<a id="facebookUserLoginLink" class="#attributes.class#" href="##" onclick="login();"><img src="#facebookPath#/sdk/assets/images/facebook-login.gif" height="21" width="169" /></a>
</cfoutput>
<cfexit method="exittag" />