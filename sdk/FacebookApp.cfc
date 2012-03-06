﻿/**
  * Copyright 2011 Affinitiz, Inc.
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
  * @displayname Base Facebook App
  * @hint A library to build apps on Facebook.com and social websites with Facebook Connect
  * 
  */
component accessors="true" extends="FacebookBase" {
	
	/**
     * @description Facebook App Id
	 * @hint
	 */
	property String appId;
	/**
     * @description Facebook application secret key
	 * @hint 
	 */
	property String secretKey;
	
	variables.DROP_QUERY_PARAMS = "code,logged_out,state,signed_request";
	variables.VERSION = "3.1.1";
	
	/*
	 * @description Facebook App constructor
	 * @hint Requires an appId and its secretKey
	 */
	public Any function init(required String appId, required String secretKey) {
		if (!isPersistentDataEnabled()) {
			throw(message="Persistent scope is not available (by default session scope, so you must enable session management for this app)", type="UnvailablePersistentScope");
		}
		super.init(arguments.appId);
		setAppId(arguments.appId);
		setSecretKey(arguments.secretKey);
		return this;
	}
	
	/*
	 * @description Add parameters to an existing signed request
	 * @hint Useful for example to add user info to an existing signed request with page info
	 */
	public String function addParametersToSignedRequest(required Struct parameters, required String signedRequest) {
		var newParameters = parseSignedRequest(arguments.signedRequest);
		structAppend(newParameters, arguments.parameters, true);
		return createSignedRequest(newParameters);
	}
	
	/*
	 * @description Dump signed request for debug purpose. 
   	 * @hint This will automatically dump all the parameters passed to the current page.
	 */
	public void function dumpSignedRequest() {
		var key = "";
		var parameters = parseQueryString(cgi.QUERY_STRING);
		var signedRequest = {};
		if (structCount(parameters)) {
			writeOutput("<h4>URL</h4>");
			writeDump(var=parameters, format="text");
			for (key in parameters) {
				if (key == "signed_request") {
					signedRequest = parseSignedRequest(url.signed_request);
					writeOutput("<br />");
					writeDump(var=signedRequest, format="text");
				}
			}
		}
		if (structCount(form)) {
			writeOutput("<hr />");
			writeOutput("<h4>FORM</h4>");
			writeDump(var=form, format="text");
			for (key in form) {
				if (key == "signed_request") {
					signedRequest = parseSignedRequest(form.signed_request);
					writeOutput("<br />");
					writeDump(var=signedRequest, format="text");
				}
			}
		}
		var cookieName = getSignedRequestCookieName();
		if (structKeyExists(cookie, cookieName)) {
			writeOutput("<hr />");
			writeOutput("<h4>COOKIE</h4>");
			signedRequest = parseSignedRequest(cookie[cookieName]);
			writeDump(var=signedRequest, format="text");
		}
	}
	
	/*
	 * @description Get OAuth accessToken
	 * @hint Determines the access token that should be used for API calls. The first time this is called, accessToken is set equal to either a valid user access token, or it's set to the application access token if a valid user access token wasn't available. Subsequent calls return whatever the first call returned.
	 */
	public String function getAccessToken() {
		if (!hasRequestData("access_token")) {
			var accessToken = getUserAccessToken();
			if (accessToken == "") {
				// No user access token, establish access token to be the application access token, in case we navigate to the /oauth/access_token endpoint, where SOME access token is required.
				accessToken = getApplicationAccessToken();
			}
			setRequestData("access_token", accessToken);
		}
		return getRequestData("access_token");
	}
	
	/*
	 * @description Get application OAuth accessToken
	 * @hint 
	 */
	public String function getApplicationAccessToken(Boolean apiEnabled = false) {
		var accessToken = "";
		if (arguments.apiEnabled) {
			var facebookGraphAPI = new FacebookGraphAPI();
			accessToken = facebookGraphAPI.getOAuthAccessToken(clientId=getAppId(), clientSecret=getSecretKey(), grantType="client_credentials");
		} else {
			accessToken = getAppId() & '|' & getSecretKey();
		}
		return accessToken;
	}
	
	/*
	 * @description Get page OAuth accessToken
	 * @hint Requires the manage_pages permission and a userAccessToken
	 */
	public String function getPageAccessToken(required String pageId) {
		var accessToken = "";
		var httpService = new Http(url="https://graph.facebook.com/#arguments.pageId#/");
		var result = {};
		var userAccessToken = getUserAccessToken();
		
		httpService.addParam(type="url", name="fields", value="access_token");
		httpService.addParam(type="url", name="access_token", value=userAccessToken);
		
		result = callAPIService(httpService);
		
		if (structKeyExists(result, "access_token")) {
			accessToken = result.access_token;
		}
		
		return accessToken;
	}
	
	/*
	 * @description Get app data passed through URL when app is installed on a page (app_data parameter)
	 * @hint Return value of app_data
	 */
	public String function getAppData() {
		var appData = "";
		var signedRequest = getSignedRequest();
		if (structKeyExists(signedRequest, "app_data")) {
			appData = signedRequest["app_data"];
		}
		return appData;
	}
	
	/*
	 * @description Get a login status URL to fetch the status from facebook.
	 * @hint 
	 * Available parameters:
     * - ok_session: the URL to go to if a session is found
     * - no_session: the URL to go to if the user is not connected
     * - no_user: the URL to go to if the user is not signed into facebook
   	 */
	public String function getLoginStatusUrl(Struct parameters = structNew()) {
		var currentUrl = getCurrentUrl();
		if (!structKeyExists(arguments.parameters, "api_key")) arguments.parameters["api_key"] = variables.appId;
		if (!structKeyExists(arguments.parameters, "no_session")) arguments.parameters["no_session"] = currentUrl;
		if (!structKeyExists(arguments.parameters, "no_user")) arguments.parameters["no_user"] = currentUrl;
		if (!structKeyExists(arguments.parameters, "ok_session")) arguments.parameters["ok_session"] = currentUrl;
		if (!structKeyExists(arguments.parameters, "session_version")) arguments.parameters["session_version"] =3;
		return getUrl("extern/login_status.php", arguments.parameters);
	}
	
	/*
	 * @description Get a Login URL for use with redirects.
	 * @hint By default, full page redirect is assumed. If you are using the generated URL with a window.open() call in JavaScript, you can pass in display=popup as part of the parameters.
	 * Available parameters:
   	 * - redirect_uri: the url to go to after a successful login
   	 * - scope: comma separated list of requested extended perms
	 */
	public String function getLoginUrl(Struct parameters = structNew()) {
		establishCSRFStateToken();
		if (!structKeyExists(arguments.parameters, "client_id")) arguments.parameters["client_id"] = variables.appId;
		if (!structKeyExists(arguments.parameters, "redirect_uri")) arguments.parameters["redirect_uri"] = getCurrentUrl();
		if (!structKeyExists(arguments.parameters, "state")) arguments.parameters["state"] = getCSRFStateToken();
		return getUrl("dialog/oauth", arguments.parameters);
	}
	
	/*
	 * @description Get a Logout URL suitable for use with redirects.
	 * @hint 
	 * Available parameters:
   	 * - next: the url to go to after a successful logout
	 */
	public String function getLogoutUrl(Struct parameters = structNew()) {
		if (!structKeyExists(arguments.parameters, "next")) arguments.parameters["next"] = getCurrentUrl("logged_out=1");
		if (!structKeyExists(arguments.parameters, "access_token")) arguments.parameters["access_token"] = getAccessToken();
		return getUrl("logout.php", arguments.parameters);
	}
	
	/*
	 * @description Get page data with id, liked and admin (true or false)
	 * @hint 
	 */
	public Struct function getPage() {
		var page = {};
		var signedRequest = getSignedRequest();
		if (structKeyExists(signedRequest, "page")) {
			page = signedRequest["page"];
		}
		return page;
	}
	
	/*
	 * @description Get page id
	 * @hint 
	 */
	public Numeric function getPageId() {
		var pageId = 0;
		var page = getPage();
		if (structKeyExists(page, "id")) {
			pageId = page.id;
		}
		return pageId;
	}

	/*
	 * @description Get signed request
	 * @hint Retrieve the signed request, either from a url/form parameter or, if not present, from a cookie
	 */
	public Struct function getSignedRequest() {
		if (!hasRequestData("signed_request")) {
			var signedRequestCookieName = getSignedRequestCookieName();
			if (structKeyExists(url, "signed_request")) {
				// apps.facebook.com (navigation inside iframe page)
				setRequestData("signed_request", parseSignedRequest(url.signed_request));
			} else if (structKeyExists(form, "signed_request")) {
				// apps.facebook.com (default iframe page)
				setRequestData("signed_request", parseSignedRequest(form.signed_request));
			} else if (structKeyExists(cookie, signedRequestCookieName)) {
				// Cookie created by Facebook Connect Javascript SDK
				setRequestData("signed_request", parseSignedRequest(cookie[signedRequestCookieName]));
			} else {
				setRequestData("signed_request", {});
			}
		}
		return getRequestData("signed_request");
	}
	
	/*
	 * @description Get user OAuth accessToken
	 * @hint Determines and returns the user access token, first using the signed request if present, and then falling back on the authorization code if present.  The intent is to return a valid user access token, or "" if one is determined to not be available.
	 */
	public String function getUserAccessToken() {
		var accessToken = "";
		// First, consider a signed request if it's supplied. if there is a signed request, then it alone determines the access token.
		var signedRequest = getSignedRequest();
		if (structCount(signedRequest)) {
			if (structKeyExists(signedRequest, "oauth_token")) {
				// apps.facebook.com hands the access_token in the signed_request
				accessToken = signedRequest["oauth_token"];
				setPersistentData("access_token", accessToken);
			} else if (structKeyExists(signedRequest, "code")) {
				// Facebook Javascript SDK puts an authorization code in signed request
				if (signedRequest["code"] == getPersistentData("code")) {
					accessToken = getPersistentData("access_token");
				} else {
					accessToken = getAccessTokenFromCode(signedRequest["code"], "");
					if (accessToken != "") {
						setPersistentData("code", signedRequest["code"]);
						setPersistentData("access_token", accessToken);
					}
				}
			}
			
			if (accessToken == "") {
				// Signed request states there's no access token, so anything stored should be invalidated.
				invalidateUser();
			}
		} else {
			// Falling back on the authorization code if present
			var code = getAuthorizationCode();
			if (code != "" && code != getPersistentData("code")) {
				accessToken = getAccessTokenFromCode(code);
				if (accessToken != "") {
					setPersistentData("code", code);
					setPersistentData("access_token", accessToken);
				}
			
				if (accessToken == "") {
					// Code was bogus, so everything based on it should be invalidated.
					invalidateUser();
				}
			} else {
				// Falling back on persistent store, knowing nothing explicit (signed request, authorization code, etc.) was present to shadow it (or we saw a code in URL/FORM scope, but it's the same as what's in the persistent store)
				accessToken = getPersistentData("access_token");
				if (accessToken == "") {
					// Invalid session, so everything based on it should be invalidated.
					invalidateUser();
				}
			}
		}
		return accessToken;
	}
	
	/*
	 * @description Get the UID of the connected user, or 0 if the Facebook user is not connected.	 
	 * @hint Determines the connected user by first examining any signed requests, then considering an authorization code, and then falling back to any persistent store storing the user.
	 */
	public Numeric function getUserId() {
		if (!hasRequestData("user_id")) {
			var userId = 0;
			if (structKeyExists(url, "logged_out")) {
				invalidateUser();
			} else {
				// If a signed request is supplied, then it solely determines who the user is.
				var signedRequest = getSignedRequest();
				if (structCount(signedRequest)) {
					if (structKeyExists(signedRequest, "user_id")) {
						userId = signedRequest["user_id"];
						setPersistentData("user_id", userId);
					} else {
						// If the signed request didn't present a user id, then invalidate all entries in any persistent store.
						invalidateUser();
					}
				} else {
					userId = getPersistentData("user_id", 0);
					// Use access_token to fetch user id if we have a user access_token, or if the cached access token has changed.
					var accessToken = getAccessToken();
					if (accessToken != "" && accessToken != getApplicationAccessToken() && !(userId > 0 && accessToken == getPersistentData("access_token"))) {
						var graphAPI = new FacebookGraphAPI(accessToken);
						var userInfo = graphAPI.getObject(id="me", fields="id");
						if (structKeyExists(userInfo, "id") && userInfo["id"] > 0) {
							userId = userInfo["id"];
							setPersistentData("user_id", userId);
						} else {
							invalidateUser();
						}
					}
				}
			}
			setRequestData("user_id", userId);
		}
		return getRequestData("user_id");
	}
	
	/*
	 * @description Check if Facebook App is initialized correctly. 
   	 * @hint 
	 */
	public Boolean function isEnabled() {
		return (getAppId() != 0 && getSecretKey() != "");
	}
	
	/*
	 * @description Check if the application is accessed from a Facebook canvas app
	 * @hint 
	 */
	public Boolean function isInFacebook() {
		return (structKeyExists(url, "signed_request") || structKeyExists(form, "signed_request"));
	}
	
	/*
	 * @description Check if the application is accessed from a Facebook page tab
	 * @hint 
	 */
	public Boolean function isInFacebookPageTab() {
		var pageId = getPageId();
		return (pageId > 0);
	}
	
	/*
	 * @description Check if the current user is an admin of the current page (only available if the app is accessed through a Facebook page tab)
	 * @hint 
	 */
	public Boolean function isPageAdmin() {
		var pageAdmin = false;
		var page = getPage();
		if (structKeyExists(page, "admin")) {
			pageAdmin = page["admin"];
		}
		return pageAdmin;	
	}
	
	/*
	 * @description Check if the current page is liked by current user (only available if the app is accessed through a Facebook page tab)
	 * @hint 
	 */
	public Boolean function isPageLiked() {
		var pageLiked = false;
		var page = getPage();
		if (structKeyExists(page, "liked")) {
			pageLiked = page["liked"];
		}
		return pageLiked;	
	}
	
	/*
	 * @description Log signed request for debug purpose. 
   	 * @hint This will automatically log in current application log all the parameters passed to the current page.
	 */
	public void function logSignedRequest(String eventName = "") {
		var key = "";
		var key2 = "";
		var parameters = parseQueryString(cgi.QUERY_STRING);
		var signedRequest = {};
		for (key in parameters) {
			writeLog(file=application.applicationName, type="Information", text="FacebookApp.logSignedRequest() #eventName# URL key=#key# value=#parameters[key]#");
			if (key == "signed_request") {
				signedRequest = parseSignedRequest(form.signed_request);
				for (key2 in signedRequest) {
					writeLog(file=application.applicationName, type="Information", text="FacebookApp.logSignedRequest() #eventName# URL.SIGNED_REQUEST key=#key2# value=#signedRequest[key2]#");
				}
			}
		}
		for (key in form) {
			writeLog(file=application.applicationName, type="Information", text="FacebookApp.logSignedRequest() #eventName# FORM key=#key# value=#form[key]#");
			if (key == "signed_request") {
				signedRequest = parseSignedRequest(form.signed_request);
				for (key2 in signedRequest) {
					writeLog(file=application.applicationName, type="Information", text="FacebookApp.logSignedRequest() #eventName# FORM.SIGNED_REQUEST key=#key2# value=#signedRequest[key2]#");
				}
			}
		}	
	}
	
	// PRIVATE
	
	private String function createSignedRequest(required Struct parameters) {
		var jsonParameters = serializeJsonSignedRequest(arguments.parameters);
		var encodedParameters = base64UrlEncode(jsonParameters);
		var signature = hashHmacSHA256(encodedParameters, getSecretKey());
		var encodedSignature = base64UrlEncode(signature);
		var signedRequest = encodedSignature & "." & encodedParameters;
		return signedRequest;
	}
	
	private void function establishCSRFStateToken() {
		if (getCSRFStateToken() == "") {
 			var stateToken = hash(createUUID());
			setRequestData("state", stateToken);
  			setPersistentData("state", stateToken);
		}
	}
	
	private String function getAccessTokenFromCode(required String code, String redirectUri) {
		var accessToken = "";
		if (arguments.code != "") {
			if (!structKeyExists(arguments, "redirectUri")) {
				arguments.redirectUri = getCurrentUrl();
			}
			var graphAPI = new FacebookGraphAPI(appId=getAppId());
			accessToken = graphAPI.getOAuthAccessToken(clientId=getAppId(), clientSecret=getSecretKey(), code=arguments.code, redirectUri=arguments.redirectUri);
		}
		return accessToken;
	}
	
	private String function getAuthorizationCode() {
		var code = "";
		if (structKeyExists(url, "code") && structKeyExists(url, "state")) {
			var stateToken = getCSRFStateToken();
			if (stateToken != "" && stateToken == url["state"]) {
				// CSRF state token has done its job, so delete it
				deleteRequestData("state");
				deletePersistentData("state");
				code = url["code"];
			} else {
				// Ignore (CSRF state token does not match one provided)
			}
		}
		return code;
	}
	
	private String function getCSRFStateToken() {
		if (!hasRequestData("state")) {
			setRequestData("state", getPersistentData("state"));
		}
		return getRequestData("state");
	}
	
	private String function getCurrentUrl(String queryString = "") {
		var i = 0;
		var key = "";
		var keyValues = listToArray(CGI.query_string, "&");
		var currentUrl = getPageContext().getRequest().getRequestUrl().toString();
		var value = "";
		if (arrayLen(keyValues)) {
			for (i=1; i <= arrayLen(keyValues); i++) {
				if (listLen(keyValues[i], "=") == 2) {
					key = listFirst(keyValues[i],"=");
					value = listLast(keyValues[i],"=");
					if (!listFind(variables.DROP_QUERY_PARAMS, key)) {
						arguments.queryString = listAppend(arguments.queryString, key & "=" & value, "&");
					}
				}
			}
		}
		if (arguments.queryString != "") {
			currentUrl = currentUrl & "?" & arguments.queryString;
		}
		var httpRequestData = getHttpRequestData();
		if (structKeyExists(httpRequestData.headers, "X-Forwarded-Proto")) {
			// Detect forwarded protocol (for example from EC2 Load Balancer)
			var javaUrl = createObject( "java", "java.net.URL").init(currentUrl);
			var currentProtocol = javaUrl.getProtocol();
			var forwardedProtocol = httpRequestData.headers["X-Forwarded-Proto"];
			replaceNoCase(currentUrl, currentProtocol, forwardedProtocol);
		}
		return currentUrl;
	}
	
	private String function getUrl(String path = "", Struct parameters = structNew()) {
		var key = "";
		var resultUrl = "https://www.facebook.com/" & arguments.path;
		if (structCount(arguments.parameters)) {
			resultUrl = resultUrl & "?" & serializeQueryString(arguments.parameters);
		}
		return resultUrl;
	}

	private Struct function parseSignedRequest(required String signedRequest) {
		var encodedParameters = listLast(trim(arguments.signedRequest), ".");
		var encodedSignature = listFirst(trim(arguments.signedRequest), ".");
		var parameters = deserializeJSON(base64UrlDecode(encodedParameters));
		if (structKeyExists(parameters, "algorithm") && UCase(parameters["algorithm"]) != "HMAC-SHA256") {
			throw(errorcode="Invalid algorithm", message="Unknown algorithm. Expected HMAC-SHA256", type="FacebookApp Security");
		}

		var expectedSignature = hashHmacSHA256(encodedParameters, getSecretKey());
		var signature = base64UrlDecode(encodedSignature);
		if (signature != expectedSignature) {
			throw(errorcode="Invalid signature", message="Invalid signed request", type="FacebookApp Security");
		}
		return parameters;
	}
	
	private String function serializeJsonSignedRequest(required Struct parameters) {
		var jsonParameters = '{"algorithm":"HMAC-SHA256"';
		if (structKeyExists(arguments.parameters, "expires")) {
			jsonParameters = jsonParameters & ',"expires":' & arguments.parameters["expires"];
		}
		if (structKeyExists(arguments.parameters, "code")) {
			jsonParameters = jsonParameters & ',"code":"' & arguments.parameters["code"]& '"';
		}
		if (structKeyExists(arguments.parameters, "issued_at")) {
			jsonParameters = jsonParameters & ',"issued_at":' & arguments.parameters["issued_at"];
		}
		if (structKeyExists(arguments.parameters, "oauth_token")) {
			jsonParameters = jsonParameters & ',"oauth_token":"' & arguments.parameters["oauth_token"] & '"';
		}
		if (structKeyExists(arguments.parameters, "page")) {
			jsonParameters = jsonParameters & ',"page":{';
			var commaRequired = false;
			if (structKeyExists(arguments.parameters["page"], "id")) {
				jsonParameters = jsonParameters & '"id":"' & arguments.parameters["page"]["id"] & '"';
				commaRequired = true;
			}
			if (structKeyExists(arguments.parameters["page"], "admin") && arguments.parameters["page"]["admin"]) {
				if (commaRequired) {
					jsonParameters = jsonParameters & ',';
				} else {
					commaRequired = true;
				}
				jsonParameters = jsonParameters & '"admin":true';
				commaRequired = true;
			}
			if (structKeyExists(arguments.parameters["page"], "liked") && arguments.parameters["page"]["liked"]) {
				if (commaRequired) {
					jsonParameters = jsonParameters & ',';
				}
				jsonParameters = jsonParameters & '"liked":true';
			}
			jsonParameters = jsonParameters & '}';
		}
		if (structKeyExists(arguments.parameters, "user")) {
			jsonParameters = jsonParameters & ',"user":{';
			var commaRequired = false;
			if (structKeyExists(arguments.parameters["user"], "country")) {
				jsonParameters = jsonParameters & '"country":"' & arguments.parameters["user"]["country"] & '"';
				commaRequired = true;
			}
			if (structKeyExists(arguments.parameters["user"], "locale")) {
				if (commaRequired) {
					jsonParameters = jsonParameters & ',';
				} else {
					commaRequired = true;
				}
				jsonParameters = jsonParameters & '"locale":"' & arguments.parameters["user"]["locale"] & '"';
			}
			if (structKeyExists(arguments.parameters["user"], "age") && structKeyExists(arguments.parameters["user"]["age"], "min")) {
				if (commaRequired) {
					jsonParameters = jsonParameters & ',';
				}
				jsonParameters = jsonParameters & '"age":{"min":' & arguments.parameters["user"]["age"]["min"] & '}';
			}
			jsonParameters = jsonParameters & '}';
		}
		if (structKeyExists(arguments.parameters, "user_id")) {
			jsonParameters = jsonParameters & ',"user_id":"' & arguments.parameters["user_id"] & '"';
		}
		jsonParameters = jsonParameters & '}';
		return jsonParameters;
	}
		
}	