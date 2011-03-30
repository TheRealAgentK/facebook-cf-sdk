<cfimport taglib="/facebook/sdk/tags" prefix="facebook" />
<cfscript>
import facebook.sdk.FacebookApp;
import facebook.sdk.FacebookGraphAPI;

// Replace this with your appId and secret
APP_ID = "";
SECRET_KEY = "";

// Create facebookApp instance
facebookApp = new FacebookApp(appId=APP_ID, secretKey=SECRET_KEY);
// Get user session
userSession = facebookApp.getUserSession();
</cfscript>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
    <title>Facebook ColdFusion SDK Custom tags Examples</title>
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
			<h1>Facebook ColdFusion SDK Example</h1>
			External website with Facebook Platform integration
		</div>
	</div>
	<div class="body washbody example">
		<div class="content">
			<facebook:init facebookApp="#facebookApp#" />
			<cfif not structKeyExists(userSession, "uid")>
				<h2>Authentication</h2>
				<facebook:login-link /><br />
			<cfelse>
			    <h2>Authenticated</h2>
			    <facebook:logout-link />
			    <facebook:picture facebookId="#userSession.uid#" />
			    <facebook:profile-link facebookId="#userSession.uid#" /><br />
			    <hr />
			    <facebook:share-link label="Share this site" url="http://#cgi.SERVER_NAME#" /> |
			    <facebook:publish-link label="Publish to your stream" message="ColdFusion rocks!" /> |
			    <facebook:invite-link label="Invite your friend" message="You should try this app" title="ColdFusion Facebook SDK" />
			</cfif>
		</div>
	</div>
	<div class="footer">
		<div class="content">
			<a href="http://github.com/affinitiz/facebook-cf-sdk">Facebook ColdFusion SDK</a> - Open source project by <a href="http://affinitiz.com">Affinitiz</a> - 
			<a href="http://www.apache.org/licenses/LICENSE-2.0">Licensed under the Apache License, Version 2.0</a><br />
		</div>
	</div>
</body>
</html>