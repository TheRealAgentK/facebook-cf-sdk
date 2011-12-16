<!---
  * Copyright 2011 Affinitiz, Inc.
  * Title: App on Facebook.com
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
SECRET_KEY = "";
SCOPE = "publish_stream";

userId = 0;

if (APP_ID is "" or SECRET_KEY is "") {
	// App not configured
} else {
	// Create facebookApp instance
	facebookApp = new FacebookApp(appId=APP_ID, secretKey=SECRET_KEY);
	
	// We may or may not have this data based on a URL or COOKIE based session.
	//
	// See if there is a user from a cookie or session
	userId = facebookApp.getUserId();
	if (userId) {
		userAccessToken = facebookApp.getUserAccessToken();
		try {
			facebookGraphAPI = new FacebookGraphAPI(accessToken=userAccessToken, appId=APP_ID);
			userObject = facebookGraphAPI.getObject(id=userId);
			userFriends = facebookGraphAPI.getConnections(id=userId, type='friends', limit=10);
			authenticated = true;
		} catch (any exception) {
			// Usually an invalid session (OAuthInvalidTokenException), for example if the user logged out from facebook.com
			userId = 0;
			facebookGraphAPI = new FacebookGraphAPI();
		}
	} else {
		facebookGraphAPI = new FacebookGraphAPI();
	}
	
	if (userId eq 0) {
		parameters = {scope=SCOPE};
		loginUrl = facebookApp.getLoginUrl(parameters);
	};
	
	// This call will always work since we are fetching public data.
	naitik = facebookGraphAPI.getObject(id='naitik');
}
</cfscript>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
    <title>Facebook ColdFusion SDK - Examples</title>
	<style>
		<cfinclude template="app.css">
	</style>
</head>
<body style="overflow:hidden">
		<div class="header">
			<div class="content">
				<h1>Facebook ColdFusion SDK - Example</h1>
				App on Facebook.com
			</div>
		</div>
		<div class="body example">
			<cfoutput>	
			<div class="content">
				<!--
			      We use the Facebook JavaScript SDK to provide a richer user experience. For more info,
			      look here: http://github.com/facebook/connect-js
			    -->
			    <div id="fb-root"></div>
			    <script>
			     	window.fbAsyncInit = function() {
				        FB.init({
				          appId   : '#facebookApp.getAppId()#',
				          cookie  : true, // enable cookies to allow the server to access the session
				          oauth	  : true, // OAuth 2.0
				          status  : false, // check login status
				          xfbml   : true // parse XFBML
				        });
						
						FB.Canvas.setSize({height:1800});
					};
			
				    (function() {
				        var e = document.createElement('script');
				        e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
				        e.async = true;
				        document.getElementById('fb-root').appendChild(e);
				    }());
				
					<cfif userId eq 0>
						function addLoginListener() {
							// whenever the user install the app or login, we refresh the page
							FB.Event.subscribe('auth.login', function(response) {
						        window.location.reload();
						    });
						}
					
						function login() {
				        	FB.login(function(response) {
								if (response.authResponse) {
							    	// user successfully authenticated in
									window.location.reload();
							  	} else {
							   		// user cancelled login
							  	}
							}, {scope:'#SCOPE#'});
						}
					</cfif>
			    </script>
				
				<cfif APP_ID is "" or SECRET_KEY is "">
					<div style="color:red">
						<h4>Incorrect Facebook Application configuration</h4>
						Your application is not yet configured, you must create an application on <a href="https://developers.facebook.com/apps">Facebook Developers</a>, in order to get your own app ID and a secret key.<br /> 
						Replace <i>appId</i> and <i>secretKey</i> in <i>examples/app/index.cfm</i>.<br />
						For more info, see SDK <a href="http://github.com/affinitiz/facebook-cf-sdk/wiki/Usage">Usage</a> documentation.<br />
					</div>
					<br />
				<cfelse>
					<cfif userId eq 0>
						<h2>Authentication</h2>
						<div>
					      Log in via Facebook JavaScript SDK: <a href="javascript:login()">Login/Install</a>
					    </div>
						<div>
					      Log in Facebook JavaScript SDK &amp; XFBML: <fb:login-button scope="#SCOPE#" onclick="addLoginListener()"></fb:login-button>
					    </div>
						<hr />
					</cfif>
					<h2>Your data</h2>
				    <cfif userId>
				    	<h3>Your profile pic + name</h3>
					    <img src="https://graph.facebook.com/#userId#/picture">
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
				    	<strong><em>You have not yet installed this app.</em></strong>
				    </cfif>
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
	</body>
</html>