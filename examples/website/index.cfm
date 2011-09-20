<!---
  * Copyright 2010 Affinitiz, Inc.
  * Title: External website with Facebook Platform integration
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

if (APP_ID is "" or SECRET_KEY is "") {
	// App not configured
	facebookGraphAPI = new FacebookGraphAPI();
} else {
	// Create facebookApp instance
	facebookApp = new FacebookApp(appId=APP_ID, secretKey=SECRET_KEY);
	
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
		} finally {
			facebookGraphAPI = new FacebookGraphAPI();
		}
	} else {
		facebookGraphAPI = new FacebookGraphAPI();
	}
	
	// Login or logout url will be needed depending on current user state.
	if (userId) {
		logoutUrl = facebookApp.getLogoutUrl();
	} else {
		parameters = {scope=SCOPE};
		loginUrl = facebookApp.getLoginUrl(parameters);
	}
}
		
// This call will always work since we are fetching public data.
naitik = facebookGraphAPI.getObject(id='naitik');
</cfscript>
	
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
    <title>Facebook ColdFusion SDK Examples</title>
	<link rel="stylesheet" type="text/css" href="website.css" />
</head>
<body>
	<div class="menu">
		<div class="content">
			<a href="../../." class="l">Accueil</a>
			<a href="##" class="l">Example</a>
			<div class="logo">
				<img src="../../images/coldfusion-sdk-50x50.png" height="50" width="50" style="float:right" />
				<span>Facebook ColdFusion SDK</span>
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="header">
		<div class="content">
			<h1>Facebook ColdFusion SDK - Examples</h1>
			Website with Facebook Platform integration
		</div>
	</div>
	<div class="body washbody example">
		<cfoutput>
		<div class="content">
			<cfif APP_ID is "" or SECRET_KEY is "">
				<div style="color:red">
					<h4>Incorrect Facebook Application configuration</h4>
					Your application is not yet configured, you must create an application on <a href="https://developers.facebook.com/apps">Facebook Developers</a>, in order to get your own app ID and a secret key.<br /> 
					Replace <i>appId</i> and <i>secretKey</i> in <i>examples/website/index.cfm</i>.<br />
					For more info, see SDK <a href="http://github.com/affinitiz/facebook-cf-sdk/wiki/Usage">Usage</a> documentation.<br />
				</div>
				<br />
			<cfelse>
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
				          status  : true, // check login status
				          xfbml   : true // parse XFBML
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
			
					function login() {
			        	FB.login(function(response) {
			        		if (response.authResponse) {
						    	// User successfully authenticated in
						    	// Page reload will be done by 'auth.login' event handler
						  	} else {
						   		// User cancelled login
						  	}
						}, {scope:'#SCOPE#'});
					}
					
					function logout() {
						FB.getLoginStatus(function(response) {
							if (response.authResponse) {
						    	FB.logout(function(response) {
								  // User is now authenticated out
								  // Page reload will be done by 'auth.logout' event handler
								});
						  	} else {
						   		window.location.reload();
						  	}
						});
					}
			    </script>
				
				<h2>Authentication</h2>
				<cfif userId>
				    <div>
				      Log out via Facebook JavaScript SDK: <a href="javascript:logout()">Logout</a>
				    </div>
				    <br />
					<div>
				      Log out Facebook.com server side redirect:
				      <a href="#logoutUrl#">
					  	<img src="http://static.ak.fbcdn.net/rsrc.php/z2Y31/hash/cxrz4k7j.gif">
					  </a>
				    </div>
			    <cfelse>
				    <div>
				      Log in via Facebook JavaScript SDK: <a href="javascript:login()">Login</a><br />
				      (<i>with Facebook ColdFusion SDK handling authorization code from cookie on reload</i>)
				    </div>
				    <br />
					<div>
				      Log in Facebook JavaScript SDK &amp; XFBML: <fb:login-button scope="#SCOPE#"></fb:login-button><br />
				       (<i>with Facebook ColdFusion SDK handling authorization code from cookie on reload</i>)
				    </div>
				    <br />
				    <div>
				      Log in via Facebook.com server side redirect:
				      <a href="#loginUrl#">
				        <img src="http://static.ak.fbcdn.net/rsrc.php/zB6N8/hash/4li2k73z.gif">
				      </a><br />
				      (<i>with Facebook ColdFusion SDK handling authorization code from url on return</i>)
				    </div>
			    </cfif>
			    <hr />
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
			    	<strong><em>You are not Connected.</em></strong>
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