<!---
  * Copyright 2010 Affinitiz, Inc.
  * Title: FBML canvas app on Facebook.com
  * Author: Benoit Hediard (hediard@affinitiz.com)
  *
  * Licensed under the Apache License, Version 2.0 (the "License"); you may
  * not use this file except in compliance with the License. You may obtain
  * a copy of the License at
  * 
  *  http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
  * License for the specific language governing permissions and limitations
  * under the License.
  *
--->
<cfscript>
import facebook.sdk.FacebookApp;
import facebook.sdk.FacebookGraphAPI;

// Replace this with your appId and secret
APP_ID = "";
APP_URL = "http://apps.facebook.com/cf-sdk-fbml/";
SECRET_KEY = "";

// Create facebookApp instance
facebookApp = new FacebookApp(appId=APP_ID, secretKey=SECRET_KEY);

// We may or may not have this data based on a URL or COOKIE based session.
//
// If we get a session here, it means we found a correctly signed session using
// the Application Secret only Facebook and the Application know. We dont know
// if it is still valid until we make an API call using the session. A session
// can become invalid if it has already expired (should not be getting the
// session back in this case) or if the user authenticated out of Facebook.
userSession = facebookApp.getUserSession();

authenticated = false;
if (structKeyExists(userSession, "uid")) {
	try {
		facebookGraphAPI = new FacebookGraphAPI(userSession.access_token);
		userObject = facebookGraphAPI.getObject(id=userSession.uid);
		userFriends = facebookGraphAPI.getConnections(id='#userSession.uid#', type='friends', limit=10);
		authenticated = true;
	} catch (any exception) {
		// Ignore exception (OAuthInvalidTokenException), usually an invalid session
	} finally {
		facebookGraphAPI = new FacebookGraphAPI();
	}
} else {
	facebookGraphAPI = new FacebookGraphAPI();
}

if (!authenticated) {
	parameters = structNew();
	parameters["req_perms"] = "publish_stream";
	loginUrl = facebookApp.getLoginUrl(parameters);
};

// This call will always work since we are fetching public data.
naitik = facebookGraphAPI.getObject(id='naitik');
</cfscript>

<style>
<cfinclude template="fbml.css">
</style>
<div class="header">
	<div class="content">
		<h1>Facebook ColdFusion SDK Example</h1>
		FBML canvas app on Facebook.com
	</div>
</div>
<div class="body example">
	<cfoutput>	
	<div class="content">
		<script>
	    	<cfif not authenticated>
				function login() {
		        	Facebook.showPermissionDialog('publish_stream', function(data) {
						if (data != null) {
							document.setLocation('#APP_URL#');
						}
					});
				}
			</cfif>
	    </script>
		
		<cfif not authenticated>
			<h2>Authentication</h2>
			<cfif facebookApp.getAppId() is "" or facebookApp.getSecretKey() is "">
				<div style="color:red">
					<h4 style="color:red">Incorrect Facebook Application configuration</h4>
					Your application is not yet configured, you must create an application on <a href="http://www.facebook.com/developers/">Facebook Developers</a>, in order to get your own app ID and a secret key.<br /> 
					Replace <i>appId</i> and <i>secretKey</i> in <i>examples/iframe/index.cfm</i>.<br />
					For more info, see SDK <a href="http://github.com/affinitiz/facebook-cf-sdk/wiki/Usage">Usage</a> documentation.<br />
				</div>
				<br />
			<cfelse>
				<div>
			      Using JavaScript: <a href="##" onclick="login()">Install app</a>
			    </div>
			</cfif>
	    	<hr />
		</cfif>
		<h2>Your data</h2>
	    <cfif authenticated>
	    	<h3>User session</h3>
			<cfdump var="#userSession#" format="text">
			<br />
			<h3>Your profile pic + name</h3>
		    <img src="https://graph.facebook.com/#userSession.uid#/picture">
		   	#userObject.name#<br />
			<br />
			<h3>Your friends</h3>
			<cfloop array="#userFriends#" index="friend">
				<img src="https://graph.facebook.com/#friend.id#/picture">
			</cfloop><br />
			<br />
			<h3>Your info</h3>
		   	<cfdump var="#userObject#" format="text">
	    <cfelse>
	    	<strong><em>You have not installed this app.</em></strong>
	    </cfif>
		<hr />
	  	<h2>Naitik data</h2>
	    <h3>Profile pic + name</h3>
		<img src="https://graph.facebook.com/naitik/picture">
	    #naitik.name#
	</div>
	</cfoutput>
</div>
<div class="footer">
	<div class="content">
		<a href="http://github.com/affinitiz/facebook-cf-sdk">Facebook ColdFusion SDK</a> - Open source project by <a href="http://affinitiz.com">Affinitiz</a> - 
		<a href="http://www.apache.org/licenses/LICENSE-2.0">Licensed under the Apache License, Version 2.0</a><br />
	</div>
</div>