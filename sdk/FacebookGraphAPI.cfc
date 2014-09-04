/**
  * Copyright 2010 Affinitiz, Inc.
  * Copyright 2014 Ventego Creative Ltd
  *
  * Title: External website with Facebook Platform integration
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
component extends="FacebookBase" {
	
	/*
	 * @description Facebook Graph API constructor
	 * @hint Requires an application or user accessToken, appId is only used to invalidate current session if an invalid token is detected
	 */
	public Any function init(String accessToken = "", String appId = "", Numeric timeout = 10, String apiVersion = "v2.1") {
		super.init(appId=arguments.appId, apiVersion=arguments.apiVersion);
		variables.ACCESS_TOKEN = arguments.accessToken;
		variables.TIMEOUT = arguments.timeout;
		return this;
	}
	
	/*
	 * @description Install an app in a page profile tab at the end of the current list of installed tabs
	 * @hint Requires a page accessToken
	 */
	public Boolean function addPageTab(required String appId, required String pageId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/tabs", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="app_id", value=arguments.appId);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Block a user from a page.
	 * @hint Requires the manage_pages permission and page admin access token.
	 */
	public Boolean function blockUser(required String pageId, required String userId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/blocked/#arguments.userId#", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Create an open graph action on an open graph object
	 * @hint Requires a user accessToken (or an app accessToken), return an action instance id (story id). Additional action properties can be passed, such as start_time, end_time, place, tags, ref…
	 */
	public String function createAction(required String actionName, required String appNameSpace, required String objectName, required String objectUrl, Struct properties = {}, Boolean scrapeEnabled = false, required String userId) {
		var id = "";
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.userId#/#arguments.appNameSpace#:#arguments.actionName#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name=arguments.objectName, value=arguments.objectUrl);
		for (var propertyName in arguments.properties) {
			httpService.addParam(type="formField", name=propertyName, value=arguments.properties[propertyName]);
		}
		if (arguments.scrapeEnabled) {
			httpService.addParam(type="formField", name="scrape", value=true);
		}
		result = callAPIService(httpService);
		if (structKeyExists(result, "id")) {
			id = result["id"];
		}
		return id;
	}

	/*
	 * @description Create a subscription for the application
	 * @hint Requires an application accessToken
	 */
	public Any function createAppSubscription(required String appId, required String callbackUrl, required String fields, required String object, required String verifyToken = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#/subscriptions", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="callback_url", value="#arguments.callbackUrl#");
		httpService.addParam(type="formField", name="fields", value=arguments.fields);
		//httpService.addParam(type="formField", name="include_values", value="true");
		httpService.addParam(type="formField", name="object", value="#arguments.object#");
		httpService.addParam(type="formField", name="verify_token", value="#arguments.verifyToken#");
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Create a test user
	 * @hint Requires an application accessToken
	 */
	public Struct function createAppTestUser(required String appId, Boolean installed = false, String permissions = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#/accounts/test-users", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="installed", value="#arguments.installed#");
		httpService.addParam(type="url", name="permissions", value="#arguments.permissions#");
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Create a test user friend connection
	 * @hint Requires user1 accessToken
	 */
	public Boolean function createAppTestUserFriendConnection(required String userId1, required String userId2) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.userId1#/friends/#arguments.userId2#", method="POST", timeout=variables.TIMEOUT);
		var result = false;
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Remove a subscription for an application
	 * @hint 
	 */
	public Any function deleteAppSubscription(required String appId, required String object) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#/subscriptions", method="DELETE", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="object", value="#arguments.object#");
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Remove all subscription for an application
	 * @hint 
	 */
	public Any function deleteAppSubscriptions(required String appId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#/subscriptions", method="DELETE", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Remove a like from a post.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function deleteLike(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.id#/likes", method="DELETE", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Delete a graph object.
	 * @hint 
	 */
	public Boolean function deleteObject(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.id#", method="DELETE", timeout=variables.TIMEOUT);
		var result = false;
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Delete an app profile tab 
	 * @hint Requires a page accessToken
	 */
	public Boolean function deletePageTab(required String appId, required String pageId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/tabs/app_#arguments.appId#", method="DELETE", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Execute multiple FQL Query.
	 * @hint Return an array or struct of query results.
	 */
	public Struct function executeMultipleQuery(required Any queries) {
		var httpService = new Http(url="https://graph.facebook.com/fql", method="GET", timeout=variables.TIMEOUT);
		var queryResults = structNew();
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="q", value=serializeJSON(arguments.queries));
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && isArray(result.data)) {
			for (var i=1; i <= arrayLen(result.data); i++) {
				queryResults[result.data[i].name] = result.data[i].fql_result_set;
			}
		}
		return queryResults;
	}
	
	/*
	 * @description Execute a FQL Query.
	 * @hint 
	 */
	public Array function executeQuery(required String query) {
		var httpService = new Http(url="https://graph.facebook.com/fql", method="GET", timeout=variables.TIMEOUT);
		var queryResults = arrayNew(1);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="q", value=arguments.query);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			queryResults = result.data;
		}
		return queryResults;
	}
	
	/*
	 * @description List all application's subscriptions
	 * @hint Requires an application accessToken
	 */
	public Array function getAppSubscriptions(required String appId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#/subscriptions", method="GET", timeout=variables.TIMEOUT);
		var result = {};
		var subscriptions = [];
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			subscriptions = result.data;
		}
		return subscriptions;
	}
	
	/*
	 * @description Get test users
	 * @hint Requires an application accessToken
	 */
	public Array function getAppTestUsers(required String appId) {
		var users = [];
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#/accounts/test-users", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="installed", value="#arguments.installed#");
		httpService.addParam(type="url", name="permissions", value="#arguments.permissions#");
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			users = result.data;
		}
		return users;
	}
	
	/*
	 * @description Get blocked users for a page.
	 * @hint 
	 */
	public Array function getPageBlockedUsers(required String pageId) {
		var users = [];
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/blocked", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			users = result.data;
		}
		return users;
	}
	
	/*
	 * @description Get graph object connections.
	 * @hint 
	 *		Supported connections type for action instance : likes
	 *		Supported connections type for album : comments, photos
	 *		Supported connections type for event : attending, declined, feed, invited, maybe, noreply, picture
	 *		Supported connections type for group : feed, members, picture
	 *		Supported connections type for link : comments
	 *		Supported connections type for message : comments
	 *		Supported connections type for note : comments
	 *		Supported connections type for page : albums, events, feed, groups, links, notes, photos, picture, posts, statuses, tagged, videos
	 *		Supported connections type for photo : comments
	 *		Supported connections type for post : comments
	  *		Supported connections type for user : albums, activities, books, checkins, events, feed, friends, groups, interests, home, links, likes, music, movies, notes, photos, picture, posts, statuses, tagged, television, thread, updates, videos
	 *		Supported connections type for video : comments
	 */
	public Array function getConnections(required String id, required String type, Numeric limit=-1, Numeric offset=-1, String fields = "", Date since, Date until, String dateFormat = "") {
		var connections = [];
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.id#/#arguments.type#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (arguments.dateFormat == "unix") httpService.addParam(type="url", name="date_format", value="U");
		if (arguments.limit > 0) httpService.addParam(type="url", name="limit", value="#arguments.limit#");
		if (arguments.offset > 0) httpService.addParam(type="url", name="offset", value="#arguments.offset#");
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value="#arguments.fields#");
		if (structKeyExists(arguments, "since")) {
			if (isDate(arguments.since)) {
				arguments.since = dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.since);
			}
			httpService.addParam(type="url", name="since", value=arguments.since);	
		} 
		if (structKeyExists(arguments, "until")) {
			if (isDate(arguments.until)) {
				arguments.until = dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.until);
			}
			httpService.addParam(type="url", name="until", value=arguments.until);
		}
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			connections = result.data;
		}
		return connections;
	}
	
	/*
	 * @description Get the list of event invitees with RDVP status ('invited' by default, but it could be 'attending', 'maybe', 'declined' or 'noreply')
	 * @hint This returns an array of objects with name, id, and rsvp_status ('not_replied', 'unsure', 'attending', or 'declined') fields. 
	 * Requires user_events or friends_events permission for non-public events.
	 */
	public Struct function getEventUsers(required String eventId, String status = "invited", String userId = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.eventId#/#arguments.status#/#arguments.userId#", timeout=variables.TIMEOUT);
		var users = [];
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			users = result.data;
		}
		return users;
	}
	
	/*
	 * @description Get OAuth access token.
	 * @hint
	 */
	public String function getOAuthAccessToken(String clientId = "", String clientSecret = "", String code = "", String exchangeToken = "", String grantType = "", String redirectUri) {
		var accessToken = "";
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/oauth/access_token", timeout=variables.TIMEOUT);
		var queryString = "";
		if (arguments.clientId != "") httpService.addParam(type="url", name="client_id", value=arguments.clientId);
		if (arguments.clientSecret != "") httpService.addParam(type="url", name="client_secret", value=arguments.clientSecret);
		if (arguments.exchangeToken != "") {
			httpService.addParam(type="url", name="grant_type", value="fb_exchange_token");
			httpService.addParam(type="url", name="fb_exchange_token", value=arguments.exchangeToken);
		} else {
			if (arguments.code != "") httpService.addParam(type="url", name="code", value=arguments.code);
			if (arguments.grantType != "") httpService.addParam(type="url", name="grant_type", value=arguments.grantType);
			if (structKeyExists(arguments, "redirectUri")) httpService.addParam(type="url", name="redirect_uri", value=arguments.redirectUri); // RedirectUri can be empty (when JS SDK is used to connect)
		}
		var result = callAPIService(httpService);
		if (structKeyExists(result, "access_token")) {
			accessToken = result["access_token"];
		}	
		return accessToken;
	}
	
	/*
	 * @description Get OAuth access token with all data (expires parameter).
	 * @hint This function has been added to be able to get the expires parameter
	 */
	public Struct function getOAuthAccessData(String clientId = "", String clientSecret = "", String code = "", String exchangeToken = "", String grantType = "", String redirectUri) {
		var accessToken = "";
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/oauth/access_token", timeout=variables.TIMEOUT);
		var queryString = "";
		if (arguments.clientId != "") httpService.addParam(type="url", name="client_id", value=arguments.clientId);
		if (arguments.clientSecret != "") httpService.addParam(type="url", name="client_secret", value=arguments.clientSecret);
		if (arguments.exchangeToken != "") {
			httpService.addParam(type="url", name="grant_type", value="fb_exchange_token");
			httpService.addParam(type="url", name="fb_exchange_token", value=arguments.exchangeToken);
		} else {
			if (arguments.code != "") httpService.addParam(type="url", name="code", value=arguments.code);
			if (arguments.grantType != "") httpService.addParam(type="url", name="grant_type", value=arguments.grantType);
			if (structKeyExists(arguments, "redirectUri")) httpService.addParam(type="url", name="redirect_uri", value=arguments.redirectUri); // RedirectUri can be empty (when JS SDK is used to connect)
		}
		var result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Get graph object.
	 * @hint 
	 */
	public Struct function getObject(required String id, String fields = "", Numeric metadata = 0) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.id#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value=arguments.fields);
		if (arguments.metadata == 1) httpService.addParam(type="url", name="metadata", value="1");
		result = callAPIService(httpService);
		if (!isStruct(result)) result = {};
		return result;
	}

	/*
	 * @description Get multiple graph objects.
	 * @hint 
	 */
	public Struct function getObjects(required String ids, String fields = "", Numeric metadata = 0) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#", timeout=variables.TIMEOUT);
		var results = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value=arguments.fields);
		if (arguments.metadata == 1) httpService.addParam(type="url", name="metadata", value="1");
		httpService.addParam(type="url", name="ids", value=arguments.ids);
		results = callAPIService(httpService);
		if (!isStruct(results)) results = {};
		return results;
	}
	
	/*
	 * @description Get multiple graph objects in a single batched request.
	 * @hint 
	 */
	public Array function getObjectsBatched(required Array relativeUrls, Boolean headersEnabled = true) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#", method="POST", timeout=variables.TIMEOUT);
		var response = {};
		var result = {};
		var results = [];
		var batch = [];
		var query = {};
		for (var relativeUrl in arguments.relativeUrls) {
			query = {};
			query["method"] = "GET";
			if (isNumeric(relativeUrl)) {
                relativeUrl = chr(2) & relativeUrl;
			}
			query["relative_url"] = relativeUrl;
			arrayAppend(batch, query);
		}
		batch = replace(serializeJSON(batch),chr(2),"","all");
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="batch", value="#batch#");
		if (!arguments.headersEnabled) {
			httpService.addParam(type="url", name="no_header", value="true");
		}
		result = callAPIService(httpService);
		if (isArray(result)) {
			for (response in result) {
				if (isStruct(response) && structKeyExists(response, "code") && response["code"] == 200) {
					arrayAppend(results, deserializeJSON(response["body"]));
				} else {
					arrayAppend(results, {});
				}
			}
		}
		return results;
	}

	/*
    * @description Advanced multiple graph objects in a single batched request.  This allow you to describe in detail a batch request.
    * @hint There are two options available 'batchRequest' where you structural define a request and 'serializeBatchJSON' where you supply a static JSON string.
    * batchRequest is an array of item request.
    * item {
    *      method: HTTP method (DELETE|GET|POST|PUT)
    *      relative_url: the Facebook object or Facebook edge (me/feed)
    *      name: the name of the operation.  This is used whe specifying dependencies between operations in the request.
    *      body: a string.  Available only with POST and PUT operations.
    *      omit_response_on_success: whether to include the result of this operation (true|false)
    *      depends_on: specify dependencies between operations explicitly.
    *      attached_files: the file location.
    *  }
    *
    */
    public Array function getObjectsBatchedAdvanced(Array batchRequest=[], string serializeBatchJSON="", Boolean headersEnabled = true) {
        var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/", method="POST", timeout=variables.TIMEOUT);
        var response = {};
        var result = {};
        var results = [];
        var batch = [];
        var query = {};
        var fileNumber = 0;

        if (len(serializeBatchJSON)) {
            batch = serializeBatchJSON;
        } else {
            for (var item in arguments.batchRequest) {
                query = {};
                query["method"] = item["method"];
                if (isNumeric(item["relative_url"])) {
                    query["relative_url"] = chr(2) & item["relative_url"];
                } else {
                    query["relative_url"] = item["relative_url"];
                }
                // Optional params
                if (structKeyExists(item, "name")) {
                    query["name"] = item["name"];
                }
                if (structKeyExists(item, "body")) {
                    query["body"] = item["body"];
                }
                if (structKeyExists(item, "omit_response_on_success")) {
                    query["omit_response_on_success"] = item["omit_response_on_success"];
                }
                if (structKeyExists(item, "depends_on")) {
                    query["depends_on"] = item["depends_on"];
                }
                if (structKeyExists(item, "attached_files")) {
                    fileNumber++;
                    query["attached_files"] = 'file'&fileNumber;
                    httpService.addParam(type="file", name="file#fileNumber#", file="#item["attached_files"]#");
                }

                arrayAppend(batch, query);
            }
            batch = replace(serializeJSON(batch),chr(2),"","all");
        }

        httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
        httpService.addParam(type="url", name="batch", value=batch);

        if (!arguments.headersEnabled) {
            httpService.addParam(type="url", name="no_header", value="true");
        }

        result = callAPIService(httpService);
        if (isArray(result)) {
            for (response in result) {
                if (isStruct(response) && structKeyExists(response, "code") && response["code"] == 200) {
                    arrayAppend(results, deserializeJSON(response["body"]));
                } else {
                    arrayAppend(results, {});
                }
            }
        }
        return results;
    }

	/*
	 * @description Get page access token from a user access token.
	 * @hint User must have authorized manage_pages permission for the app and user must be an admin of the page
	 */
	public String function getPageAccessToken(required String pageId) {
		var accessToken = "";
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="fields", value="access_token");
		var result = callAPIService(httpService);
		if (structKeyExists(result, "access_token")) {
			accessToken = result["access_token"];
		}	
		return accessToken;
	}
	
	/*
	 * @description Get page admin users.
	 * @hint Requires a page accessToken
	 */
	public Array function getPageAdmins(required String pageId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/admins", timeout=variables.TIMEOUT);
		var result = {};
		var admins = [];
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			admins = result.data;
		}
		return admins;
	}
	
	/*
	 * @description Get page tab
	 * @hint Requires a page accessToken, an appId or the tabId, for example: events, info, notes, photos, reviews, wall)
	 */
	public Struct function getPageTab(required String pageId, String tabId = "", String appId = "") {
		if (arguments.tabId == "") {
			arguments.tabId = "app_" & arguments.appId;
		}
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/tabs/#arguments.tabId#", timeout=variables.TIMEOUT);
		var result = {};
		var tab = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			tab = result.data[1];
		}
		return tab;
	}
	
	/*
	 * @description Get page tabs.
	 * @hint Requires a page accessToken
	 */
	public Array function getPageTabs(required String pageId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/tabs", timeout=variables.TIMEOUT);
		var result = {};
		var tabs = [];
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			tabs = result.data;
		}
		return tabs;
	}
	
	/*
	 * @description Check if an app is installed in a page tab
	 * @hint Requires a page accessToken
	 */
	public Boolean function hasPageTab(required String appId, required String pageId) {
		var installed = false;
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/tabs/apps_#arguments.appId#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			installed = true;
		}
		return installed;
	}
	
	/*
	 * @description Invite users to an event
	 * @hint Requires create_event permission
	 */
	public Any function inviteUsersToEvent(required String eventId, required String userIds) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.eventId#/invited", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="url", name="users", value="#arguments.userIds#");
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Check if a user has liked a page
	 * @hint Requires a user accessToken
	 */
	public Boolean function isPageLiked(required String pageId, required String userId) {
		var liked = false;
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.userId#/likes/#arguments.pageId#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			liked = true;
		}
		return liked;
	}
	
	/*
	 * @description Check if a user is a page admin
	 * @hint Requires a page accessToken
	 */
	public Boolean function isUserAdmin(required String pageId, required String userId) {
		var admin = false;
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/admins/#arguments.userId#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			admin = true;
		}
		return admin;
	}
	
	/*
	 * @description Check if a user is blocked on a page
	 * @hint Requires a user page accessToken, requires the manage_pages permission
	 */
	public Boolean function isUserBlocked(required String pageId, required String userId) {
		var blocked = false;
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/blocked/#arguments.userId#", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		if (structKeyExists(result, "data") && arrayLen(result.data)) {
			blocked = true;
		}
		return blocked;
	}
	
	/*
	 * @description Add an album to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishAlbum(required String profileId, required String name, required String description) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/albums", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="name", value="#arguments.name#");
		httpService.addParam(type="formField", name="description", value="#arguments.description#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a comment to a post or an action instance
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishComment(required String postId, required String message) {
		var result = {};
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.postId#/comments", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="message", value="#arguments.message#");
		result = callAPIService(httpService);
		return result["id"];
	}
		
	/*
	 * @description Add an event to a profile/page
	 * @hint Requires the create_event / manage_pages permission. Privacy type can be "open", "closed" or "secret"
	 */
	public String function publishEvent(required String profileId, required String name, required Date startTime, Date endTime, String description = "", String location = "", String privacyType = "open") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/events", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="name", value="#arguments.name#");
		httpService.addParam(type="formField", name="start_time", value="#dateformat(arguments.startTime, 'yyyy-mm-dd')#T#TimeFormat(arguments.startTime, 'HH:mm:ss')#");
		if (structKeyExists(arguments, "endTime"))httpService.addParam(type="formField", name="end_time", value="#dateformat(arguments.endTime, 'yyyy-mm-dd')#T#TimeFormat(arguments.endTime, 'HH:mm:ss')#");
		if (trim(arguments.location) != "") httpService.addParam(type="formField", name="location", value="#arguments.location#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.privacyType) != "") httpService.addParam(type="formField", name="privacy_type", value="#arguments.privacyType#");
		result = callAPIService(httpService);
		return result["id"];
	}

	/*
	 * @description Change event status
	 * @hint Available status are attending, maybe or declined.
	 */
	public Boolean function publishEventStatus(required String eventId, String status = "attending") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.eventId#/#arguments.status#", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Add a like to a post.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishLike(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.id#/likes", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Add a link to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishLink(required String profileId, required String link, String caption = "", String description = "", String message = "", String name = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/links", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="link", value="#arguments.link#");
		if (trim(arguments.caption) != "") httpService.addParam(type="formField", name="caption", value="#arguments.caption#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		result = callAPIService(httpService);
		return result["id"];
	}

	/*
	 * @description Add a milestone to a page timeline
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishMilestone(required String profileId, required String title, String description = "", required Date startTime) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/milestones", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="title", value="#arguments.title#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		httpService.addParam(type="formField", name="start_time", value="#dateformat(arguments.startTime, 'yyyy-mm-dd')#T#TimeFormat(arguments.startTime, 'HH:mm:ss')#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a note to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishNote(required String profileId, required String subject, required String message) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/notes", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.subject) != "") httpService.addParam(type="formField", name="subject", value="#arguments.subject#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add an entry to a profile's feed.
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishPost(required String profileId, String actions = "", String caption = "", String description = "", String display = "", Numeric expandedHeight = 0, Numeric expandedWidth = 0,  String link = "", String message = "", String picture = "", String privacy = "", String name = "", String source = "", String targeting = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/feed", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="formField", name="access_token", value=variables.ACCESS_TOKEN);
		if (trim(arguments.actions) != "") httpService.addParam(type="formField", name="actions", value="#arguments.actions#");
		if (trim(arguments.caption) != "") httpService.addParam(type="formField", name="caption", value="#arguments.caption#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.display) != "") httpService.addParam(type="formField", name="display", value="#arguments.display#");
		if (trim(arguments.link) != "") httpService.addParam(type="formField", name="link", value="#arguments.link#");
		if (trim(arguments.expandedHeight) > 0) httpService.addParam(type="formField", name="expanded_height", value="#arguments.expandedHeight#");
		if (trim(arguments.expandedWidth) > 0) httpService.addParam(type="formField", name="expanded_width", value="#arguments.expandedWidth#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.picture) != "") httpService.addParam(type="formField", name="picture", value="#arguments.picture#");
		if (trim(arguments.privacy) != "") httpService.addParam(type="formField", name="privacy", value="#arguments.privacy#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		if (trim(arguments.source) != "") httpService.addParam(type="formField", name="source", value="#arguments.source#");
		if (trim(arguments.targeting) != "") httpService.addParam(type="formField", name="targeting", value="#arguments.targeting#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a photo to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishPhoto(required String profileId, required String sourcePath, String message = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.profileId#/photos", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="file", name="source", file="#arguments.sourcePath#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		result = callAPIService(httpService);
		return result["id"];
	}
	
	/*
	 * @description Add a video to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishVideo(required String profileId, required String sourcePath, String description = "", String title = "") {
		var httpService = new Http(url="https://graph-video.facebook.com/#getApiVersion()#/#arguments.profileId#/videos", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="file", name="source", file="#arguments.sourcePath#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.title) != "") httpService.addParam(type="formField", name="title", value="#arguments.title#");
		result = callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Ask Facebook to recrawl the URL
	 * @hint Required objectId (which can be a facebook ID or object page URL)
	 */
	public Any function scrapeObject(required String objectId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="id", value=arguments.objectId);
		httpService.addParam(type="formField", name="scrape", value="true");
		var result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Search for objects of a given type.
	 * @hint Supported search object type : post, user, page, event, group. Requires the publish_stream permission.
	 */
	public Array function search(required String text, String type = "", Numeric limit = -1, Numeric offset = -1) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/search", timeout=variables.TIMEOUT);
		var result = {};
		var results = [];
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (trim(arguments.text) != "") httpService.addParam(type="url", name="q", value="#URLEncodedFormat(trim(arguments.text))#");
		if (trim(arguments.type) != "") httpService.addParam(type="url", name="type", value="#arguments.type#");
		if (arguments.limit > 0) httpService.addParam(type="url", name="limit", value="#arguments.limit#");
		if (arguments.offset > 0) httpService.addParam(type="url", name="offset", value="#arguments.offset#");
		result = callAPIService(httpService);
		if (structKeyExists(result, "data")) {
			results = result.data;
		}
		return results;
	}
	
	/*
	 * @description Remove a blocked user.
	 * @hint Requires the manage_pages permission.
	 */
	public Boolean function unblockUser(required String pageId, required String userId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/blocked/#arguments.userId#", method="DELETE", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		callAPIService(httpService);
		return true;
	}
	
	/*
	 * @description Uninvite user from an event
	 * @hint Requires  The user must be an admin of the event for this call to succeed. Requires rsvp_event permission.
	 */
	public Any function uninviteUserFromEvent(required String eventId, required String userId) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.eventId#/#arguments.userId#", method="DELETE", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Update action instance properties
	 * @hint Requires a user accessToken (or a page accessToken)
	 */
	public Boolean function updateAction(required String actionInstanceId, Struct properties = {}) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.actionInstanceId#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		for (var propertyName in arguments.properties) {
			httpService.addParam(type="formField", name=propertyName, value=arguments.properties[propertyName]);
		}
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Update application properties
	 * @hint Requires an app accessToken
	 */
	public Boolean function updateAppProperties(required String appId, Struct properties = {}) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.appId#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		for (var propertyName in arguments.properties) {
			httpService.addParam(type="formField", name=propertyName, value=arguments.properties[propertyName]);
		}
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Update an event.
	 * @hint Requires the create_event / manage_pages permission. Privacy type can be "open", "closed" or "secret"
	 */
	public String function updateEvent(required String eventId, String name = "", Date startTime, Date endTime, String description = "", String location = "", String privacyType = "open") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.eventId#", method="POST", timeout=variables.TIMEOUT);
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (Len(trim(arguments.name)))httpService.addParam(type="formField", name="name", value="#arguments.name#");
		if (structKeyExists(arguments, "startTime"))httpService.addParam(type="formField", name="start_time", value="#dateformat(arguments.startTime, 'yyyy-mm-dd')#T#TimeFormat(arguments.startTime, 'HH:mm:ss')#");
		if (structKeyExists(arguments, "endTime"))httpService.addParam(type="formField", name="end_time", value="#dateformat(arguments.endTime, "yyyy-mm-dd")#T#TimeFormat(arguments.endTime, 'HH:mm:ss')#");
		if (trim(arguments.location) != "") httpService.addParam(type="formField", name="location", value="#arguments.location#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.privacyType) != "") httpService.addParam(type="formField", name="privacy_type", value="#arguments.privacyType#");
		result = callAPIService(httpService);
		return result;
	}

	/*
	 * @description Update page attributes.
	 * @hint 
	 */
	public Boolean function updatePageAttributes(required String pageId, String about = "", String description = "", String phone = "", String info = "", String website = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (arguments.about != "") httpService.addParam(type="formField", name="about", value=arguments.about);
		if (arguments.description != "") httpService.addParam(type="formField", name="description", value=arguments.description);
		if (arguments.phone != "") httpService.addParam(type="formField", name="phone", value=arguments.phone);
		if (arguments.info != "") httpService.addParam(type="formField", name="general_info", value=arguments.info);
		if (arguments.website != "") httpService.addParam(type="formField", name="website", value=arguments.website);
		result = callAPIService(httpService);
		return result;
	}

	/*
	 * @description Update page cover.
	 * @hint 
	 */
	public Boolean function updatePageCover(required String pageId, required String coverId, Boolean feedStoryDisabled = true, Numeric yOffset = 50) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="cover", value=arguments.coverId);
		httpService.addParam(type="formField", name="no_feed_story", value=arguments.feedStoryEnabled);
		httpService.addParam(type="formField", name="offset_y", value=arguments.yOffset);
		result = callAPIService(httpService);
		return result;
	}

	/*
	 * @description Install an app in a page profile tab at the end of the current list of installed tabs
	 * @hint Requires a page accessToken
	 */
	public Boolean function updatePageTab(required String appId, required String pageId, Numeric position = 0, String customName = "", String customImagePath = "", String customImageUrl = "") {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.pageId#/tabs/app_#arguments.appId#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		if (arguments.position > 0) httpService.addParam(type="formField", name="position", value=arguments.position);
		if (arguments.customName != "") httpService.addParam(type="formField", name="custom_name", value=arguments.customName);
		if (arguments.customImagePath != "") httpService.addParam(type="file", name="custom_image", file="#arguments.customImagePath#");
		if (arguments.customImageUrl != "") httpService.addParam(type="formField", name="custom_image_url", value=arguments.customImageUrl);
		result = callAPIService(httpService);
		return result;
	}
	
	/*
	 * @description Update post visibility (show/hide in timeline)
	 * @hint Requires a page accessToken
	 */
	public Boolean function updatePostVisibility(required String postId, Boolean hidden = false) {
		var httpService = new Http(url="https://graph.facebook.com/#getApiVersion()#/#arguments.postId#", method="POST", timeout=variables.TIMEOUT);
		var result = {};
		httpService.addParam(type="url", name="access_token", value=variables.ACCESS_TOKEN);
		httpService.addParam(type="formField", name="is_hidden", value=arguments.hidden);
		result = callAPIService(httpService);
		return result;
	}

}