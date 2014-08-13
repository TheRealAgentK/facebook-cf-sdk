/**
  * Copyright 2011 Affinitiz, Inc.
  * Copyright 2014 Ventego Creative Ltd
  *
  * Initial Author: Benoit Hediard (hediard@affinitiz.com)
  * Author: Kai Koenig (kai@ventego-creative.co.nz)
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
  * @displayname Facebook Graph API
  * @hint A client wrapper to call Facebook Graph API
  * 
  */
component accessors="true" {
	
	/**
     * @description Facebook App Id
	 * @hint
	 */
	property String appId;
	/**
     * @description Facebook API version to be used
	 * @hint defaults to v2.1 (12/08/2014)
	 */
	property String apiVersion;
	
	variables.PERSISTENT_KEYS = "access_token,code,expiration_time,state,user_id";
	variables.REQUEST_KEYS = variables.PERSISTENT_KEYS & ",signed_request";
	
	/*
	 * @description Facebook Graph API constructor
	 * @hint Requires an application or user accessToken
	 */
	public Any function init(String appId = "", String apiVersion = "v2.1") {
		setAppId(arguments.appId);
		setApiVersion(arguments.apiVersion);
		return this;
	}
	
	/*
	 * @description Invalidate current user (persistent data and cookie)
	 * @hint 
	 */
	public void function invalidateUser() {
		deleteRequestData("access_token");
		deleteRequestData("user_id");
		if (hasSignedRequestCookie()) {
			deleteSignedRequestCookie();
		}
		if (isPersistentDataEnabled()) {
			deleteAllPersistentData();
		}
	}
	
	// PRIVATE
	
	private Any function callAPIService(required Http httpService) {
		var response = arguments.httpService.send().getPrefix();
		var result = {};
		if (response.fileContent != 'null' && isJSON(response.fileContent)) {
			result = deserializeJSON(response.fileContent);
			if (isStruct(result) && (structKeyExists(result, "error") || structKeyExists(result, "error_code"))) {
				var exception = new FacebookAPIException(result);
				if (getAppId() != "" && listFindNoCase("OAuthException,invalid_token", exception.getType())) {
					// if API request is executed in the context of an app
					if (findNoCase("validating access token", exception.getMessage()) || findNoCase("Invalid OAuth access token", exception.getMessage())) {
						// Access token is not valid, invalidate current user id and token
						invalidateUser();	
					} else if (findNoCase("validating verification code", exception.getMessage()) || findNoCase("Code was invalid or expired", exception.getMessage())) {
						// Code is not valid, invalid current user
						invalidateUser();						
					}
				}
				throw(errorCode="#exception.getErrorCode()#", message="#exception.getType()# - #exception.getMessage()#", type="#exception.getType()#");
			}
		} else if (isSimpleValue(response.fileContent) && (response.statusCode == "200 OK" || response.statusCode == "200")) {
			result = parseQueryString(response.fileContent);
		} else {
			throw(message="#response.statusCode#", type="FacebookHTTP");
		}
		return result;
	}
	
	private String function getKeyVariableName(required String key) {
		return "fb_" & getAppId() & "_" & arguments.key;
	}
	
	/**
	* Utility functions
	*/
	
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
	
	private String function hashHmacSHA256(required String value, required String secretKey) {
		if (secretKey == "") {
			throw(errorcode="Invalid secretKey", message="Invalid secretKey (cannot be empty)", type="FacebookApp Security");
		}
		var secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec" ).init(arguments.secretKey.getBytes(), "HmacSHA256");
		var mac = createObject("java", "javax.crypto.Mac").getInstance(secretKeySpec.getAlgorithm());
		mac.init(secretKeySpec);
		return toString(mac.doFinal(arguments.value.getBytes()), "ISO-8859-1");
	}
	
	private Struct function parseQueryString(required String queryString) {
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
	
	private String function serializeQueryString(required Struct parameters, Boolean urlEncoded = true) {
		var queryString = "";
		for (var key in arguments.parameters) {
			if (queryString != "") {
				queryString = queryString  & "&";
			}
			if (arguments.urlEncoded) {
				queryString = queryString & LCase(key) & "=" & urlEncodedFormat(arguments.parameters[key]);
			} else {
				queryString = queryString & LCase(key) & "=" & arguments.parameters[key];
			}
		}
		return queryString;
	}
	
	/**
	* Signed request cookie (set by Facebook Javascript SDK)
	*/

	private Boolean function hasSignedRequestCookie() {
		return structKeyExists(cookie, getSignedRequestCookieName());
	}
	
	private String function getSignedRequestCookieName() {
		return "fbsr_" & getAppId();
	}
	
	private void function deleteSignedRequestCookie() {
		structDelete(cookie, getSignedRequestCookieName());
	}
	
	/**
	* Uses ColdFusion request scope to cache data during the duration of the request.
	*/
	private Boolean function deleteRequestData(required String key) {
		if (!listFindNoCase(variables.REQUEST_KEYS, arguments.key)) {
			throw(errorCode="Invalid key", message="Unsupported key passed to deleteRequestData");
		}
		return structDelete(request, getKeyVariableName(arguments.key), true);
	}
	
	private Any function getRequestData(required String key, any value = "") {
		if (!listFindNoCase(variables.REQUEST_KEYS, arguments.key)) {
			throw(errorCode="Invalid key", message="Unsupported key passed to getRequestData");
		}
		var requestKey = getKeyVariableName(arguments.key);
		if (structKeyExists(request, requestKey)) {
			return request[requestKey];
		} else {
			return arguments.value;
		}
	}

	private Boolean function hasRequestData(required String key) {
		return structKeyExists(request, getKeyVariableName(arguments.key));
	}
		
	private void function setRequestData(required String key, required Any value) {
		if (!listFindNoCase(variables.REQUEST_KEYS, arguments.key)) {
			throw(errorCode="Invalid key", message="Unsupported key passed to setRequestData");
		}
		request[getKeyVariableName(arguments.key)] = arguments.value;
	}

	
	/**
	* Uses ColdFusion sessions to provide a primitive persistent store, but another subclass of FacebookApp --one that you implement-- might use a database, memcache, or an in-memory cache.
	*/
	private Boolean function deletePersistentData(required String key) {
		if (!listFindNoCase(variables.PERSISTENT_KEYS, arguments.key)) {
			throw(errorCode="Invalid key", message="Unsupported key passed to deletePersistentData");
		}
		return structDelete(session, getKeyVariableName(arguments.key), true);
	}

	private void function deleteAllPersistentData() {
		for (var key in listToArray(variables.PERSISTENT_KEYS)) {
			deletePersistentData(key);
		}
	}
	
	private Any function getPersistentData(required String key, Any value = "") {
		if (!listFindNoCase(variables.PERSISTENT_KEYS, arguments.key)) {
			throw(errorCode="Invalid key", message="Unsupported key passed to getPersistentData");
		}
		var persistentKey = getKeyVariableName(arguments.key);
		if (structKeyExists(session, persistentKey)) {
			return session[persistentKey];
		} else {
			return arguments.value;
		}
	}
	
	private Boolean function hasSessionData(required String key) {
		return structKeyExists(session, getKeyVariableName(arguments.key));
	}
	
	public Boolean function isPersistentDataEnabled() {
		if (ListFirst(server.coldfusion.productversion,",") GTE 10) {
			return getApplicationMetaData().sessionManagement; // CF10 compatible
		} else {
			return application.getApplicationSettings().sessionManagement;
		}
	}
		
	private void function setPersistentData(required String key, required Any value) {
		if (!listFindNoCase(variables.PERSISTENT_KEYS, arguments.key)) {
			throw(errorCode="Invalid key", message="Unsupported key passed to setPersistentData");
		}
		session[getKeyVariableName(arguments.key)] = arguments.value;
	}

}