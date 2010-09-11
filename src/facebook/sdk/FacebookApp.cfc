/**
  * Copyright 2010 Affinitiz
  * Title: FacebookApp.cfc
  * Author: Benoit Hediard (hediard@affinitiz.com)
  * Date created:	01/08/10
  * Last update date: 11/09/10
  * Version: V2.1.1 beta1
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
  * @accessors true
  * @displayname Facebook App
  * @hint A library to build iFrame/FBML apps for Facebook.com and social websites with Facebook Connect
  * 
  */
component {
	
	/**
	     * @description Facebook App URL
		 * @hint Ex.: http://apps.facebook.com/your-app
	     */
		property String appUrl;
		/**
	     * @description Facebook App Id
		 * @hint
		 * @validate string
	     */
		property String appId;
		/**
	     * @description Facebook application secret key
		 * @hint 
		 * @validate string
	     */
		property String secretKey;
		/**
	     * @description Canvas or Site URL
		 * @hint Ex.: http://youserver.com/yourapp
	     */
		property String siteUrl;

		variables.DROP_QUERY_PARAMS = "session,signed_request";
		variables.VERSION = '2.1.1';

		/*
		 * @description Facebook App constructor
		 * @hint Requires an appId and its secretKey
		 */
		public FacebookApp function init(required String appId, required String secretKey, String appUrl = "", String siteUrl = "") {
			setAppUrl(arguments.appUrl);
			setAppId(arguments.appId);
			setSecretKey(arguments.secretKey);
			setSiteUrl(arguments.siteUrl);
			//variables.accessTokenHttpService = new Http(url="https://graph.facebook.com/oauth/access_token?type=client_cred&client_id=#variables.appId#&client_secret=#variables.secretKey#");
			return this;
		}
	
	/*
	 * @description Dump parameters for debug purpose. 
   	 * @hint This will automatically dump all the parameters passed to the current page.
	 */
	public void function dumpParameters(String eventName = "") {
		var key = "";
		var key2 = "";
		var parameters = parseQueryStringParameters(cgi.QUERY_STRING);
		if (structCount(parameters)) {
			writeDump("URL");
			writeDump(parameters);
			for (key in parameters) {
				if (key == "signed_request") {
					parameters = parseSignedRequestParameters(form.signed_request);
					writeDump(parameters);
				}
			}
		}
		if (structCount(form)) {
			writeDump("FORM");
			writeDump(form);
			for (key in form) {
				if (key == "signed_request") {
					parameters = parseSignedRequestParameters(form.signed_request);
					writeDump(parameters);
				}
			}
		}
	}
	
	/*
	 * @description Get OAuth accessToken
	 * @hint Return user accessToken if user session exists, application accessToken if no user session is found
	 */
	public String function getAccessToken() {
		var accessToken = getUserAccessToken();
		if (accessToken == "") {
			accessToken = getApplicationAccessToken();
		}	
	}
	
	/*
	 * @description Get application OAuth accessToken
	 * @hint 
	 */
	public String function getApplicationAccessToken() {
		/*var response = variables.accessTokenHttpService.send().getPrefix();
		if (listLen(response.fileContent, "=") == 2) {
			return listLast(response.fileContent, "=");
		} else {
			return "";
		}*/
		return variables.appId & "|" & variables.secretKey;
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
   	 * - next: the url to go to after a successful login
   	 * - cancel_url: the url to go to after the user cancels
     * - req_perms: comma separated list of requested extended perms
     * - display: can be "page" (default, full page) or "popup"
	 */
	public String function getLoginUrl(Struct parameters = structNew()) {
		var currentUrl = getCurrentUrl();
		if (!structKeyExists(arguments.parameters, "api_key")) arguments.parameters["api_key"] = variables.appId;
		if (!structKeyExists(arguments.parameters, "cancel_url")) arguments.parameters["cancel_url"] = currentUrl;
		if (!structKeyExists(arguments.parameters, "display")) arguments.parameters["display"] = "page";
		if (!structKeyExists(arguments.parameters, "fbconnect")) arguments.parameters["fbconnect"] = 1;
		if (!structKeyExists(arguments.parameters, "next")) arguments.parameters["next"] = currentUrl;
		if (!structKeyExists(arguments.parameters, "return_session")) arguments.parameters["return_session"] = 1;
		if (!structKeyExists(arguments.parameters, "session_version")) arguments.parameters["session_version"] = 3;
		if (!structKeyExists(arguments.parameters, "v")) arguments.parameters["v"] = 1;
		return getUrl("login.php", arguments.parameters);
	}
	
	/*
	 * @description Get a Logout URL suitable for use with redirects.
	 * @hint 
	 * Available parameters:
   	 * - next: the url to go to after a successful logout
	 */
	public String function getLogoutUrl(Struct parameters = structNew()) {
		if (!structKeyExists(arguments.parameters, "api_key")) arguments.parameters["api_key"] = variables.appId;
		if (!structKeyExists(arguments.parameters, "next")) arguments.parameters["next"] = getCurrentUrl();
		if (!structKeyExists(arguments.parameters, "access_token")) arguments.parameters["access_token"] = getAccessToken();
		return getUrl("logout.php", arguments.parameters);
	}
	
	/*
	 * @description Get profile id
	 * @hint 
	 */
	public Numeric function getProfileId() {
		var parameters = structNew();
		var profileId = 0;
		if (structKeyExists(url, "signed_request")) {
			parameters = parseSignedRequestParameters(url.signed_request);
		} else if (structKeyExists(form, "signed_request")) {
			parameters = parseSignedRequestParameters(form.signed_request);
		}
		if (structKeyExists(parameters, "profile_id")) {
			profileId = parameters.profile_id;
		}
		return profileId;
	}
	
	/*
	 * @description Get user OAuth accessToken
	 * @hint 
	 */
	public String function getUserAccessToken() {
		var accessToken = "";
		var userSession = getUserSession();
		if (structKeyExists(userSession, "access_token")) {
			accessToken = userSession.access_token;
		}
		return accessToken;
	}
	
	/*
	 * @description Get user id
	 * @hint 
	 */
	public Numeric function getUserId() {
		var userId = 0;
		var userSession = getUserSession();
		if (structKeyExists(userSession, "uid")) {
			userId = userSession.uid;
		}
		return userId;
	}
	
	/*
	 * @description Get the session object. 
   	 * @hint This will automatically look for a signed session sent via the signed_request, Cookie or Query Parameters if needed.
	 */
	public Struct function getUserSession() {
		var parameters = structNew();
		var userSession = structNew();
		// Try loading session from url.signed_request or form.signed_request
		if (structKeyExists(url, "signed_request")) {
			parameters = parseSignedRequestParameters(url.signed_request);
		} else if (structKeyExists(form, "signed_request")) {
			parameters = parseSignedRequestParameters(form.signed_request);
		}
		if (structCount(parameters)) {
			userSession = createSessionFromSignedRequestParameters(parameters);
		}
		if (!structCount(userSession)) {
			// Try loading session form url.session or form.session
			if (structKeyExists(url, "session")) {
				userSession = deserializeJson(url.session);				
			} else 	if (structKeyExists(form, "session")) {
				userSession = deserializeJson(form.session);				
			}
			validateUserSession(userSession);
		}
		if (!structCount(userSession)) {
			var cookieName = getSessionCookieName();
			if (structKeyExists(cookie, cookieName)) {
				userSession = parseQueryStringParameters(cookie[cookieName]);
			}
			validateUserSession(userSession);
		}
		return userSession;
	}
	
	/*
	 * @description Check if the application is accessed from a Facebook canvas
	 * @hint 
	 */
	public Boolean function isInFacebook() {
		return (structKeyExists(url, "signed_request") or structKeyExists(form, "signed_request"));
	}
	
	/*
	 * @description Check if the application is accessed from a Facebook profile tab
	 * @hint 
	 */
	public Boolean function isInFacebookProfileTab() {
		var profileId = getProfileId();
		return (profileId > 0);
	}
	
	/*
	 * @description Log parameters for debug purpose. 
   	 * @hint This will automatically log in current application log all the parameters passed to the current page.
	 */
	public void function logParameters(String eventName = "") {
		var key = "";
		var key2 = "";
		var parameters = parseQueryStringParameters(cgi.QUERY_STRING);
		for (key in parameters) {
			writeLog(file=application.applicationName, type="Information", text="FacebookApp.logParameters() #eventName# URL key=#key# value=#parameters[key]#");
			if (key == "signed_request") {
				parameters = parseSignedRequestParameters(form.signed_request);
				for (key2 in parameters) {
					writeLog(file=application.applicationName, type="Information", text="FacebookApp.logParameters() #eventName# URL.SIGNED_REQUEST key=#key2# value=#parameters[key2]#");
				}
			}
		}
		for (key in form) {
			writeLog(file=application.applicationName, type="Information", text="FacebookApp.logParameters() #eventName# FORM key=#key# value=#form[key]#");
			if (key == "signed_request") {
				parameters = parseSignedRequestParameters(form.signed_request);
				for (key2 in parameters) {
					writeLog(file=application.applicationName, type="Information", text="FacebookApp.logParameters() #eventName# FORM.SIGNED_REQUEST key=#key2# value=#parameters[key2]#");
				}
			}
		}	
	}
	
	// PRIVATE
	
	private String function base64UrlDecode(required String base64UrlValue) {
		var base64Value = replaceList(arguments.base64UrlValue, "-,_", "+,/");
		var paddingMissingCount = 0;
		var modulo = len(base64Value) % 4;
		if (modulo != 0) {
			paddingMissingCount = 4 - modulo;
		}
		for (var i=0; i < paddingMissingCount; i++) {
			base64Value = base64Value & "=";
		}
		return toString(toBinary(base64Value));
	}
	
	private Struct function createSessionFromSignedRequestParameters(required Struct parameters) {
		var userSession = structNew();
		if (structKeyExists(arguments.parameters, "oauth_token")) {
			userSession["uid"] = arguments.parameters["user_id"];
			userSession["access_token"] = arguments.parameters["oauth_token"];
			userSession["expires"] = arguments.parameters["expires"];
			userSession["sig"] = generateParametersSignature(userSession, getSecretKey());
		}
		return userSession;
	}
	
	private String function generateParametersSignature(required Struct parameters, required String secretKey) {
		var buffer = createObject("java","java.lang.StringBuffer").init("");
		var key = "";
		var sortedKeys = listToArray(listSort(structKeyList(arguments.parameters),"textnocase", "Asc", ","));
		for (key in sortedKeys) {
			buffer.append(key & "=" & arguments.parameters[key]);
		}
		buffer.append(arguments.secretKey);
		return LCase(hash(buffer.toString()));
	}
	
	private String function getCurrentUrl() {
		var i = 0;
		var key = "";
		var keyValues = listToArray(CGI.query_string, "&");
		var currentUrl = getPageContext().getRequest().GetRequestUrl().toString();
		var value = "";
		if (arrayLen(keyValues)) {
			currentUrl = currentUrl & "?";
			for (i=1; i <= arrayLen(keyValues); i++) {
				if (listLen(keyValues[i], "=") == 2) {
					key = listFirst(keyValues[i],"=");
					value = listLast(keyValues[i],"=");
					if (!listFind(variables.DROP_QUERY_PARAMS, key)) {
						if (i > 1) {
							currentUrl = currentUrl & "&";
						}
						currentUrl = currentUrl & key & "=" & value;
					}
				}
			}
		}
		return currentUrl;
	}
	
	private String function getSessionCookieName() {
		return 'fbs_' & getAppId();
	}
	
	private String function getUrl(String path = "", Struct parameters = structNew()) {
		var key = "";
		var resultUrl = "https://www.facebook.com/" & arguments.path;
		if (structCount(arguments.parameters)) {
			resultUrl = resultUrl & "?";
			for (key in arguments.parameters) {
				if (right(resultUrl, 1) != "?") {
					resultUrl = resultUrl  & "&";
				}
				if (structKeyExists(arguments.parameters, key)) {
					resultUrl = resultUrl & key & "=" & URLEncodedFormat(arguments.parameters[key]);
				}
			}
		}
		return resultUrl;
	}
	
	private String function hashHmacSHA256(required String value, required String secretKey) {
		if (secretKey == "") {
			throw(errorcode="Invalid secretKey", message="Invalid secretKey (cannot be empty)", type="Facebook Application Security");
		}
		var secretKeySpec = createObject('java', 'javax.crypto.spec.SecretKeySpec' ).init(arguments.secretKey.getBytes(), 'HmacSHA256');
		var mac = createObject('java', "javax.crypto.Mac").getInstance("HmacSHA256");
		mac.init(secretKeySpec);
		return toString(mac.doFinal(value.getBytes()));
	}
	
	private Struct function parseQueryStringParameters(required String queryString) {
		var keyValue = "";
		var keyValues = listToArray(replace(arguments.queryString,'"', '', 'ALL'), "&");
		var parameters = structNew();
		for (keyValue in keyValues) {
			if (listLen(keyValue, "=") == 2) {
				parameters[listFirst(keyValue,"=")] = listLast(keyValue,"=");
			}
		}
		return parameters;
	}
		
	private Struct function parseSignedRequestParameters(required String signedRequest) {
	  	var encodedParameters = listLast(trim(arguments.signedRequest), ".");
		var encodedSignature = listFirst(trim(arguments.signedRequest), ".");
		var expectedSignature = hashHmacSHA256(encodedParameters, variables.secretKey);
		var parameters = structNew();
		var signature = base64UrlDecode(encodedSignature);
		if (signature != expectedSignature) {
			throw(errorcode="Invalid signature", message="Invalid signature in url parameters", type="Facebook Application Security");
		} else {
			parameters = deserializeJSON(base64UrlDecode(encodedParameters));
		}
		return parameters;
	}
		
	private Boolean function validateUserSession(required Struct userSession) {
		var valid = false;
		if (isStruct(arguments.userSession) 
			&& structKeyExists(arguments.userSession, "uid")
			&& structKeyExists(arguments.userSession, "access_token")
			&& structKeyExists(arguments.userSession, "sig")) {
			var userSessionWithoutSignature = duplicate(arguments.userSession);
			structDelete(userSessionWithoutSignature, "sig");
			var expectedSignature = generateParametersSignature(userSessionWithoutSignature, getSecretKey());
			if (arguments.userSession["sig"] == expectedSignature) {
				valid = true;
			} else {
				throw(errorcode="Invalid signature", message="Invalid session signature in url/form session parameter", type="Facebook Application Security");
			}
		}
		return valid;
	}
	
}