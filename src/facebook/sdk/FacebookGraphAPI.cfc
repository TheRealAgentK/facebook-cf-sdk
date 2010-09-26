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
  * @displayname Facebook Graph API
  * @hint A client wrapper to call Facebook Graph API
  * 
  */
component {
	
	/*
	 * @description Facebook Graph API constructor
	 * @hint Requires an application or user accessToken
	 */
	public FacebookGraphAPI function init(String accessToken="") {
		variables.ACCESS_TOKEN = arguments.accessToken;
		return this;
	}
	
	/*
	 * @description Delete a graph object.
	 * @hint 
	 */
	public Boolean function deleteObject(required String id) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#", method="DELETE");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Remove a like from a post.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function deletePostLike(required String postId) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.postId#/likes", method="DELETE");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Get graph object connections.
	 * @hint 
	 *		Supported connections type for album : comments, photos
	 *		Supported connections type for event : attending, declined, feed, invited, maybe, noreply, picture
	 *		Supported connections type for group : feed, members, picture
	 *		Supported connections type for link : comments
	 *		Supported connections type for message : comments
	 *		Supported connections type for note : comments
	 *		Supported connections type for page : albums, events, feed, groups, links, notes, photos, picture, posts, statuses, tagged, videos
	 *		Supported connections type for photo : comments
	 *		Supported connections type for post : comments
	 *		Supported connections type for user : albums, activities, books, checkins, events, feed, friends, groups, interests, home, links, likes, music, movies, notes, photos, picture, posts, statuses, tagged, television, updates, videos
	 *		Supported connections type for video : comments
	 */
	public Array function getConnections(required String id, required String type, Numeric limit=-1, Numeric offset=-1, Date since, Date until) {
		var connections = arrayNew(1);
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#/#arguments.type#");
		var result = "";
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		if (arguments.limit > 0) httpService.addParam(type="url", name="limit", value="#arguments.limit#");
		if (arguments.offset > 0) httpService.addParam(type="url", name="offset", value="#arguments.offset#");
		if (structKeyExists(arguments, "since") && isDate(arguments.since)) httpService.addParam(type="url", name="since", value="#dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.since)#");
		if (structKeyExists(arguments, "until") && isDate(arguments.until)) httpService.addParam(type="url", name="until", value="#dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.until)#");
		result = makeRequest(httpService);
		if (structKeyExists(result, "data")) {
			connections = result.data;
		}
		return connections;
	}
	
	/*
	 * @description Get graph object.
	 * @hint 
	 */
	public Struct function getObject(required String id, String fields = "", Numeric metadata = 0) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.id#");
		var result = structNew();
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value="#arguments.fields#");
		if (arguments.metadata == 1) httpService.addParam(type="url", name="metadata", value="1");
		result = makeRequest(httpService);
		return result;
	}
	
	/*
	 * @description Get multiple graph objects.
	 * @hint 
	 */
	public Struct function getObjects(required String ids, String fields = "", Numeric metadata = 0) {
		var httpService = new Http(url="https://graph.facebook.com");
		var result = structNew();
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		if (listLen(arguments.fields)) httpService.addParam(type="url", name="fields", value="#arguments.fields#");
		if (arguments.metadata == 1) httpService.addParam(type="url", name="metadata", value="1");
		httpService.addParam(type="url", name="ids", value="#arguments.ids#");
		result = makeRequest(httpService);
		return result;
	}
	
	/*
	 * @description Add an album to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishAlbum(required String profileId, required String name, required String description) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/albums", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		httpService.addParam(type="formField", name="name", value="#arguments.name#");
		httpService.addParam(type="formField", name="description", value="#arguments.description#");
		result = makeRequest(httpService);
		return result['id'];
	}
	
	/*
	 * @description Add a comment to a post
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishComment(required String postId, required String message) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.postId#/comments", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		httpService.addParam(type="formField", name="message", value="#arguments.message#");
		makeRequest(httpService);
		return true;
	}
		
	/*
	 * @description Add an event to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishEvent(required String profileId, required Date startTime, required Date endTime, String name = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		httpService.addParam(type="formField", name="start_time", value="#dateformat(arguments.startTime, "yyyy-mm-dd")#T#TimeFormat(arguments.startTime, "HH:mm:ss")#");
		httpService.addParam(type="formField", name="end_time", value="#dateformat(arguments.startTime, "yyyy-mm-dd")#T#TimeFormat(arguments.startTime, "HH:mm:ss")#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Change event status
	 * @hint Available status are attending, maybe or declined.Requires the publish_stream permission.
	 */
	public Boolean function publishEventStatus(required String eventId, String status = "attending") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.eventId#/#arguments.status#", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Add a like to a post.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishLike(required String postId) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.postId#/likes", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Add a link to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishLink(required String profileId, required String link, String caption = "", String description = "", String message = "", String name = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/links", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		httpService.addParam(type="formField", name="link", value="#arguments.link#");
		if (trim(arguments.caption) != "") httpService.addParam(type="formField", name="caption", value="#arguments.caption#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Add a note to a profile's feed
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishNote(required String profileId, required String subject, required String message) {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/notes", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.subject) != "") httpService.addParam(type="formField", name="subject", value="#arguments.subject#");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Add an entry to a profile's feed.
	 * @hint Requires the publish_stream permission.
	 */
	public Boolean function publishPost(required String profileId, String caption = "", String description = "",  String link = "", String message = "", String picture = "", String name = "", String source = "") {
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/feed", method="POST");
		httpService.addParam(type="formField", name="access_token", value="#variables.ACCESS_TOKEN#");
		if (trim(arguments.caption) != "") httpService.addParam(type="formField", name="caption", value="#arguments.caption#");
		if (trim(arguments.description) != "") httpService.addParam(type="formField", name="description", value="#arguments.description#");
		if (trim(arguments.link) != "") httpService.addParam(type="formField", name="link", value="#arguments.link#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		if (trim(arguments.picture) != "") httpService.addParam(type="formField", name="picture", value="#arguments.picture#");
		if (trim(arguments.name) != "") httpService.addParam(type="formField", name="name", value="#arguments.name#");
		if (trim(arguments.source) != "") httpService.addParam(type="formField", name="source", value="#arguments.source#");
		makeRequest(httpService);
		return true;
	}
	
	/*
	 * @description Add a photo to a profile
	 * @hint Requires the publish_stream permission.
	 */
	public String function publishPhoto(required String profileId, required String sourcePath, String message = "") {
		var result = structNew();
		var httpService = new Http(url="https://graph.facebook.com/#arguments.profileId#/photos", method="POST");
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		httpService.addParam(type="file", name="source", file="#arguments.sourcePath#");
		if (trim(arguments.message) != "") httpService.addParam(type="formField", name="message", value="#arguments.message#");
		result = makeRequest(httpService);
		return result['id'];
	}
	
	/*
	 * @description Search for objects of a given type.
	 * @hint Supported search object type : post, user, page, event, group. Requires the publish_stream permission.
	 */
	public Array function search(required String text, String type = "", Numeric limit = -1, Numeric offset = -1) {
		var httpService = new Http(url="https://graph.facebook.com/search");
		var result = structNew();
		var results = arrayNew(1);
		httpService.addParam(type="url", name="access_token", value="#variables.ACCESS_TOKEN#");
		if (trim(arguments.text) != "") httpService.addParam(type="url", name="q", value="#URLEncodedFormat(trim(arguments.text))#");
		if (trim(arguments.type) != "") httpService.addParam(type="url", name="type", value="#arguments.type#");
		if (arguments.limit > 0) httpService.addParam(type="url", name="limit", value="#arguments.limit#");
		if (arguments.offset > 0) httpService.addParam(type="url", name="offset", value="#arguments.offset#");
		result = makeRequest(httpService);
		if (structKeyExists(result, "data")) {
			results = result.data;
		}
		return results;
	}
	
	// PRIVATE
	
	private Any function makeRequest(required Http httpService) {
		var response = arguments.httpService.send().getPrefix();
		var result = structNew();
		if (isJSON(response.fileContent)) {
			result = deserializeJSON(response.fileContent);
			if (isStruct(result) && structKeyExists(result, "error")) {
				throw(message="#result.error.message#", type="Facebook #result.error.type#");
			}
		} else if (response.statusCode != "200 OK") {
			throw(message="#response.statusCode#", type="Facebook HTTP");
		}
		return result;
	}

}