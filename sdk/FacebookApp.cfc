/**
  * Copyright 2010 Affinitiz, Inc.
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
  * @displayname Facebook App
  * @hint A library to build iFrame/FBML apps for Facebook.com and social websites with Facebook Connect
  * 
  */
component accessors="true" {
	
	/**
     * @description Facebook App URL
	 * @hint Ex.: http://apps.facebook.com/your-app
     */
	property String appUrl;
	/**
     * @description Facebook App Id
	 * @hint
	 */
	property String appId;
	/**
     * @description Facebook App required permissions
	 * @hint Ex.: 
     */
	property String permissions;
	/**
     * @description Facebook application secret key
	 * @hint 
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
	public FacebookApp function init(required String appId, required String secretKey, String appUrl = "", String permissions = "", String siteUrl = "") {
		setAppUrl(arguments.appUrl);
		setAppId(arguments.appId);
		setPermissions(arguments.permissions);
		setSecretKey(arguments.secretKey);
		setSiteUrl(arguments.siteUrl);
		variables.accessTokenHttpService = new Http(url="https://graph.facebook.com/oauth/access_token?type=client_cred&client_id=#variables.appId#&client_secret=#variables.secretKey#");
		return this;
	}
	
	/*
	 * @description Delete session cookie. 
   	 * @hint Only useful to external website (with Facebook Connect)
	 */
	public void function deleteSessionCookie() {
		structDelete(cookie, getSessionCookieName());
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
			writeOutput("<h4>URL</h4>");
			writeDump(var=parameters, format="text");
			for (key in parameters) {
				if (key == "signed_request") {
					parameters = parseSignedRequestParameters(url.signed_request);
					writeOutput("<br />");
					writeDump(var=parameters, format="text");
				}
			}
		}
		if (structCount(form)) {
			writeOutput("<hr />");
			writeOutput("<h4>FORM</h4>");
			writeDump(var=parameters, format="text");
			for (key in form) {
				if (key == "signed_request") {
					parameters = parseSignedRequestParameters(form.signed_request);
					writeOutput("<br />");
					writeDump(var=parameters, format="text");
				}
			}
		}
		var cookieName = getSessionCookieName();
		if (structKeyExists(cookie, cookieName)) {
			writeOutput("<hr />");
			writeOutput("<h4>COOKIE</h4>");
			parameters = parseQueryStringParameters(cookie[cookieName]);
			writeDump(var=parameters, format="text");
		}
	}
	
	/*
	 * @description Extend an existing signed request with user session info (expires, oauth_token and user_id)
	 * @hint 
	 */
	public String function extendSignedRequest(required String signedRequest, required Struct userSession) {
		writeLog(text="FacebookApp.extendSignedRequest signedRequest=" & arguments.signedRequest, file="debug");
		var parameters = parseSignedRequestParameters(arguments.signedRequest);
		var extendedSignedRequest = createSignedRequestFromSession(arguments.userSession, parameters);
		writeLog(text="FacebookApp.extendSignedRequest extendedSignedRequest=" & extendedSignedRequest, file="debug");
		return extendedSignedRequest;
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
		var response = variables.accessTokenHttpService.send().getPrefix();
		if (listLen(response.fileContent, "=") == 2) {
			return listLast(response.fileContent, "=");
		} else {
			return "";
		}
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
	 * @description Get page data with id, liked and admin (true or false)
	 * @hint 
	 */
	public Struct function getPage() {
		var page = {};
		var signedRequest = getSignedRequest();
		if (signedRequest != "") {
			var parameters = parseSignedRequestParameters(signedRequest);
			if (structKeyExists(parameters, "page")) {
				page = parameters.page;
			}
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
	 * @hint 
	 */
	public String function getSignedRequest() {
		var signedRequest = "";
		if (structKeyExists(url, "signed_request")) {
			signedRequest = url.signed_request;
		} else if (structKeyExists(form, "signed_request")) {
			signedRequest = form.signed_request;
		} else {
			signedRequest = createSignedRequestFromSession(getUserSession());	
		}
		return signedRequest;
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
	public Struct function getUserSession(String signedRequest = "") {
		var userSession = structNew();
		arguments.signedRequest = trim(arguments.signedRequest);
		if (arguments.signedRequest == "") {
			// Try loading session from url.signed_request or form.signed_request
			if (structKeyExists(url, "signed_request")) {
				arguments.signedRequest = trim(url.signed_request);
			} else if (structKeyExists(form, "signed_request")) {
				arguments.signedRequest = trim(form.signed_request);
			}
		}
		if (arguments.signedRequest != "") {
			var parameters = parseSignedRequestParameters(arguments.signedRequest);
			if (structCount(parameters)) {
				userSession = createSessionFromSignedRequestParameters(parameters);
			}
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
	 * @description Check if session cookie exists. 
   	 * @hint
	 */
	public Boolean function hasSessionCookie() {
		return structKeyExists(cookie, getSessionCookieName());
	}
	
	/*
	 * @description Check if Facebook App is initialized correctly. 
   	 * @hint 
	 */
	public Boolean function isEnabled() {
		return (getAppId() != "" && getSecretKey() != "");
	}
	
	/*
	 * @description Check if the application is accessed from a Facebook canvas app
	 * @hint 
	 */
	public Boolean function isInFacebook() {
		return (structKeyExists(url, "signed_request") or structKeyExists(form, "signed_request"));
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
			pageAdmin = page.liked;
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
			pageLiked = page.liked;
		}
		return pageLiked;	
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
	
	public Boolean function setSessionCookie(required Struct userSession) {
		if (structKeyExists(userSession, "expires")) {
			var expirationDate = dateAdd("s", userSession["expires"] + getTimeZoneInfo().UTCTotalOffset , "01/01/1970");
			// Set cookie (use PageContext method in order to keep lower case name and add expires date)
			getPageContext().getResponse().setHeader("Set-Cookie", getSessionCookieName() & "=" & serializeQueryString(arguments.userSession, false) & ";Expires=#dateFormat(expirationDate, 'ddd, dd-mmm-yyyy')# #timeFormat(expirationDate, 'HH:mm:ss')# GMT;Path=/;HttpOnly");
		}
		return true;
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
		return toString(toBinary(base64Value), "ISO-8859-1");
	}
	
	private String function base64UrlEncode(required String value) {
		var base64Value = toBase64(arguments.value, "ISO-8859-1");
		var base64UrlValue = replace(replaceList(base64Value, "+,/", "-,_"), "=", "", "ALL");
		return base64UrlValue;
	}
	
	private Struct function createSessionFromSignedRequestParameters(required Struct parameters) {
		var userSession = {};
		if (structKeyExists(arguments.parameters, "oauth_token")) {
			userSession["uid"] = arguments.parameters["user_id"];
			userSession["access_token"] = arguments.parameters["oauth_token"];
			userSession["expires"] = arguments.parameters["expires"];
			userSession["sig"] = generateParametersSignature(userSession, getSecretKey());
		}
		return userSession;
	}
	
	private String function createSignedRequest(required String jsonParameters) {
		var encodedParameters = base64UrlEncode(arguments.jsonParameters);
		var signature = hashHmacSHA256(encodedParameters, getSecretKey());
		var encodedSignature = base64UrlEncode(signature);
		var signedRequest = encodedSignature & "." & encodedParameters;
		return signedRequest;
	}

	private String function createSignedRequestFromSession(required Struct userSession, Struct parameters = structNew()) {
		var signedRequest = "";
		if (structKeyExists(arguments.userSession, "access_token")) {
			var sessionParameters = {expires=arguments.userSession["expires"], oauth_token=URLDecode(arguments.userSession["access_token"]),user_id=arguments.userSession["uid"]};
			structAppend(arguments.parameters, sessionParameters, true);
		}
		if (structCount(arguments.parameters)) {
			var jsonParameters = serializeJsonSignedRequest(arguments.parameters);
			signedRequest = createSignedRequest(jsonParameters);
		}
		return signedRequest;
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
		return "fbs_" & getAppId();
	}
	
	private String function getUrl(String path = "", Struct parameters = structNew()) {
		var key = "";
		var resultUrl = "https://www.facebook.com/" & arguments.path;
		if (structCount(arguments.parameters)) {
			resultUrl = resultUrl & "?" & serializeQueryString(arguments.parameters);
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
		return toString(mac.doFinal(value.getBytes()), "ISO-8859-1");
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
		var expectedSignature = hashHmacSHA256(encodedParameters, getSecretKey());
		var parameters = structNew();
		var signature = base64UrlDecode(encodedSignature);
		if (signature != expectedSignature) {
			throw(errorcode="Invalid signature", message="Invalid signed request", type="Facebook Application Security");
		} else {
			parameters = deserializeJSON(base64UrlDecode(encodedParameters));
		}
		return parameters;
	}
	
	private String function serializeQueryString(required Struct parameters, Boolean urlEncoded = true) {
		var queryString = "";
		for (var key in arguments.parameters) {
			if (queryString != "") {
				queryString = queryString  & "&";
			}
			if (arguments.urlEncoded) {
				queryString = queryString & key & "=" & urlEncodedFormat(arguments.parameters[key]);
			} else {
				queryString = queryString & key & "=" & arguments.parameters[key];
			}
		}
		return queryString;
	}
	
	private String function serializeJsonSignedRequest(required Struct parameters) {
		var jsonParameters = '{"algorithm":"HMAC-SHA256"';
		if (structKeyExists(arguments.parameters, "expires")) {
			jsonParameters = jsonParameters & ',"expires":' & arguments.parameters["expires"];
		}
		if (structKeyExists(arguments.parameters, "issued_at")) {
			jsonParameters = jsonParameters & ',"issued_at":' & arguments.parameters["issued_at"];
		}
		if (structKeyExists(arguments.parameters, "oauth_token")) {
			jsonParameters = jsonParameters & ',"oauth_token":"' & arguments.parameters["oauth_token"] & '"';
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