/**
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
  * @displayname Facebook Graph API
  * @hint A client wrapper to call Facebook Graph API
  * 
  */
component accessors="true" {

	/**
     * @description Error code.
     */
	property Numeric errorCode;
	/**
     * @description Error description.
     */
	property String message;
	/**
     * @description Result object returned by the API server.
     */
	property Struct result;
	/**
     * @description Type for the error. This will default to 'Exception' when a type is not available.
     */
	property String type;
	
	/*
	 * @description Facebook API Exception constructor
	 * @hint Requires the result object returned by the API server
	 */
	public Any function init(required Struct result) {
		// Error code
		if (structKeyExists(arguments.result, "error_code")) {
			setErrorCode(arguments.result["error_code"]);
		} else if (structKeyExists(arguments.result, "error") && isStruct(result["error"]) && structKeyExists(arguments.result["error"], "code")) {
			setErrorCode(arguments.result["error"]["code"]);
		} else {
			setErrorCode(0);
		}
		
		// Message
		if (structKeyExists(arguments.result, "error_description")) {
			// OAuth 2.0 Draft 10 style
			setMessage(arguments.result["error_description"]);
		} else if (structKeyExists(arguments.result, "error") && isStruct(result["error"]) && structKeyExists(arguments.result["error"], "message")) {
			// OAuth 2.0 Draft 00 style
			setMessage(arguments.result["error"]["message"] & " [code=" & getErrorCode() & "]");
		} else if (structKeyExists(arguments.result, "error_msg")) {
			// Rest server style
			setMessage(arguments.result["error_msg"]);
		} else {
			setMessage("Unknown Error. Check getResult()");
		}
		
		setResult(arguments.result);
		
		// Type
		setType("Exception");
		if (structKeyExists(arguments.result, "error")) {
			var error = arguments.result["error"];
			if (isSimpleValue(error)) {
				// OAuth 2.0 Draft 10 style
				setType(error);
			} else if (isStruct(error)) {
				// OAuth 2.0 Draft 00 style
				if (structKeyExists(error, "type")) {
					setType(error["type"]);
				}
			}
		}
		return this;
	}
	

}