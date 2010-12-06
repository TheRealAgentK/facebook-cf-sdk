<cfsilent>
<cfparam name="attributes.facebookApp" />
<cfset userSession = attributes.facebookApp.getUserSession() />
</cfsilent>
<cfoutput>
	<div id="fb-root"></div>
	<script type="text/javascript">
	 	window.fbAsyncInit = function() {
	        FB.init({
	          appId   : '#attributes.facebookApp.getAppId()#',
	          <cfif structKeyExists(userSession, "uid") and userSession.uid is not "">session : #serializeJson(userSession)#,</cfif> // don't refetch the session when Server already has it
	          status  : false, // check login status
	          cookie  : true, // enable cookies to allow the server to access the session
	          xfbml   : <cfif attributes.facebookApp.isXfbmlEnabled()>true<cfelse>false</cfif> // parse XFBML
	        });
		
			// whenever the user logs in or logs out, we refresh the page
			FB.Event.subscribe('auth.login', function(response) {
		        window.location.reload();
		    });
			FB.Event.subscribe('auth.logout', function(response) {
		        window.location.reload();
		    });
		};
	
	    (function() {
	        var e = document.createElement('script');
	        e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
	        e.async = true;
	        document.getElementById('fb-root').appendChild(e);
	    }());
	</script>
</cfoutput>
<cfexit method="exittag" />