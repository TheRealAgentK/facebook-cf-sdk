/**
* AccessToken - models an access token
*/
component name="AccessToken" accessors="false" {

    // ---- properties ----

    /**
	* The raw access token.
	*/
    variables.rawAccessToken = "";
    /**
	* A unique ID to identify a client.
	*/
    variables.machineId = "";
    /**
	* timestamp when token expires.
	*/
    variables.expiresAt = "";

    /**
    * Create a new access token entity.
    *
    * @accessToken.hint access token
    * @expiresAt.hint expiry date timestamp
    * @machineId.hint unique machine id to identify client
    */
    public void function init(required string accessToken, numeric expiresAt = 0, required string machineId = "") {

        variables.rawAccessToken = arguments.accessToken;
        if (arguments.expiresAt) {
            setExpiresAtFromTimeStamp(arguments.expiresAt);
        }
        variables.machineId = arguments.machineId;
    }

    /**
	* Setter for expiresAt.
	*
	* @timestamp.hint epoch timestamp
	*/
    public void function setExpiresAtFromTimeStamp(required numeric timestamp) {
        variables.expiresAt = arguments.timestamp;
    }

    /**
	* Getter for expiresAt.
	*
	* @return timestamp
	*/
    public string function getExpiresAt() {

        return variables.expiresAt;
    }

    /**
	* Getter for machineId.
	*
	* @return machine Id
	*/
    public string function getMachineId() {

        return variables.machineId;
    }

    /**
	* Determines whether or not this is a long-lived token.
	*
	* @return True if token is longer lasting than 2 hrs
	*/
    public boolean function isLongLived() {

        var facebookHelper = CreateObject("component","facebook.FacebookHelper");

        if (Len(variables.expiresAt)) {
            if (variables.expiresAt > facebookHelper.epochTime() + 60 * 60 * 2) {
                return true;
            } else {
                return false;
            }
        }

        return false;
    }

    /**
    * Checks the validity of the access token.
    *
    * @appID.hint Application ID to use
    * @appSecret.hint App secret value to use
    * @machineId.hint machine Id
    *
    * @return true if access token is valid
    */
    public boolean function isValid(string appID = "", string appSecret = "", string machineId = "") {

        var accessTokenInfo = getInfo(arguments.appId, arguments.appSecret);
        var mid = "";
        if (Len(arguments.machineId)) {
            mid = arguments.machineId;
        } else {
            mid = variables.machineId;
        }

        return validateAccessToken(accessTokenInfo, arguments.appId, mid);
    }

    /**
    * Ensures the provided GraphSessionInfo object is valid, throwing an exception if not.  Ensures the appId matches, that the machineId matches if it's being used, that the token is valid and has not expired.
    *
    * @tokenInfo.hint GraphSessionInfo token info
    * @appId.hint Application ID to use
    * @machineId.hint machine Id
    *
    * @return boolean
    */
    // TODO: This was a static function in PHP, investigate
    public boolean function validateAccessToken(required facebook.GraphSessionInfo tokenInfo, string appId = "", required string machineId = "") {

        var facebookHelper = CreateObject("component","facebook.FacebookHelper");
        var facebookSession = CreateObject("component","facebook.FacebookSession");
        var targetAppId = facebookSession.getTargetAppId(arguments.appId);
        var appIdIsValid = (arguments.tokenInfo.getAppId() == targetAppId);
        var machineIdIsValid = (arguments.tokenInfo.getProperty("machine_id") == arguments.machineId);
        var accessTokenIsValid = arguments.tokenInfo.isValid();
        var accessTokenIsStillAlive = "";

        // Not all access tokens return an expiration. E.g. an app access token.
        if (Len(arguments.tokenInfo.getExpiresAt())) {
            accessTokenIsStillAlive = (arguments.tokenInfo.getExpiresAt() >= facebookHelper.epochTime());
        } else {
            accessTokenIsStillAlive = true;
        }

        return appIdIsValid && machineIdIsValid && accessTokenIsValid && accessTokenIsStillAlive;
    }

    /**
    * Get a valid access token from a code.
    *
    * @code.hint code
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    * @machineId.hint machine Id
    *
    * @return AccessToken
    */
    // TODO: This was a static function in PHP, investigate -- also: does this really return an AccessToken?
    public AccessToken function getAccessTokenFromCode(required string code, string appID = "", string appSecret = "", string machineId = "") {

        var params = {"code":arguments.code,"redirect_uri":""};

        if (Len(arguments.machineId)) {
            params["machine_id"] = arguments.machineId;
        }

        return requestAccessToken(params, arguments.appId, arguments.appSecret);
    }

    /**
    * Get a valid code from an access token.
    *
    * @accessToken.hint AccessToken object ???
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    *
    * @return string with code
    */
    // TODO: This was a static function in PHP, investigate -- also: does this really return an AccessToken?
    public string function getCodeFromAccessToken(required facebook.entities.AccessToken accessToken, string appID = "", string appSecret = "") {

        var rawAccessToken = arguments.accessToken._toString();

        var params = {"access_token":rawAccessToken,"redirect_uri":""};

        return requestCode(params, arguments.appId, arguments.appSecret);
    }

    /**
    * Exchanges a short lived access token with a long lived access token.
    *
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    *
    * @return AccessToken
    */
    public facebook.entities.AccessToken function extend(string appId = "", string appSecret = "") {

        var params = {"grant_type":"fb_exchange_token","fb_exchange_token":variables.rawAccessToken};

        return requestAccessToken(params, arguments.appId, arguments.appSecret);
    }

    /**
    * Request an access token based on a set of params.
    *
    * @params.hint data to be passed
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    *
    * @return AccessToken
    */
    // TODO: This was a static function in PHP, investigate -- also: does this really return an AccessToken?
    public facebook.entities.AccessToken function requestAccessToken(required struct params, string appId = "", string appSecret = "") {

        var facebookHelper = CreateObject("component","facebook.FacebookHelper");
        var response = request("/oauth/access_token", arguments.params, arguments.appId, arguments.appSecret);
        var data = response.getResponse();
        var expiresAt = "";

        /**
        * @TODO fix this malarkey - getResponse() should always return an object
        * @see https://github.com/facebook/facebook-php-sdk-v4/issues/36
        */

        if (isStruct(data)) {
            if (StructKeyExist(data,"access_token")) {
                if (StructKeyExists(data,"expires")) {
                    expiresAt = facebookHelper.epochTime() + data["expires"];
                } else {
                    expiresAt = 0;
                }
                return new AccessToken(data["access_token"],expiresAt);
            }
            /** elseif($data instanceof \stdClass) {
                  if (isset($data->access_token)) {
                    $expiresAt = isset($data->expires_in) ? time() + $data->expires_in : 0;
                    $machineId = isset($data->machine_id) ? (string) $data->machine_id : null;
                    return new static((string) $data->access_token, $expiresAt, $machineId);
                  }
                }*/
        }

        throw(type="FacebookRequestException",message="Request Exception in AccessToken.requestAccessToken (401)");

    }

    /**
    * Request a code from a long lived access token.
    *
    * @params.hint data to be passed
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    *
    * @return string
    */
    // TODO: This was a static function in PHP, investigate
    public string function requestCode(required struct params, string appId = "", string appSecret = "") {

        var response = request("/oauth/client_code", arguments.params, arguments.appId, arguments.appSecret);
        var data = response.getResponse();

        if (isStruct(data)) {
            if (StructKeyExist(data,"code")) {
                return data["code"];
            }
        }

        throw(type="FacebookRequestException",message="Request Exception in AccessToken.requestCode (401)");
    }


    /**
    * Send a request to Graph with an app access token.
    *
    * @endpoint.hint Endpoint
    * @parameters.hint data to be passed
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    *
    * @return \Facebook\FacebookResponse
    *
    * @throws FacebookRequestException
    */
    // TODO: This was a static function in PHP, investigate -- also: does this really return an AccessToken?
    public facebook.FacebookResponse function request(required string endpoint, required struct parameters, string appId = "", string appSecret = "") {

        var facebookSession = CreateObject("component","facebook.FacebookSession");
        var params = arguments.parameters;
        var targetAppId = facebookSession.getTargetAppId(arguments.appId);
        var targetAppSecret = facebookSession.getTargetAppSecret(arguments.appSecret);
        var request = "";

        if (!StructKeyExists(params,"client_id")) {
            params["client_id"] = targetAppId;
        }
        if (!StructKeyExists(params,"client_secret")) {
            params["client_secret"] = targetAppSecret;
        }

        // The response for this endpoint is not JSON, so it must be handled differently, not as a GraphObject.
        request = new facebook.FacebookRequest(facebookSession.newAppSession(targetAppId,targetAppSecret),"GET",arguments.endpoint,params);

        return request.execute();
    }

    /**
    * Get more info about an access token.
    *
    * @appID.hint Application ID to use
    * @appSecret.hint Application secret
    *
    * @return GraphSessionInfo
    */
    public facebook.GraphSessionInfo function getInfo(string appId = "", string appSecret = "") {

        var params = {"input_token":variables.rawAccessToken};
        var fbRequest = new facebook.FacebookRequest(CreateObject("component","facebook.FacebookSession").newAppSession(arguments.appId,arguments.appSecret),"GET","/debug_token",params);
        var response = fbRequest.execute();
        var graphSession = response.getGraphObject("GraphSessionInfo");

        // Update the data on this token
        if (Len(graphSession.getExpiresAt())) {
            variables.expiresAt = graphSession.getExpiresAt();
        }

        return graphSession;
    }

    /**
    * Returns the access token as a string.
    *
    * @return access token as string
    */
    public string function _toString()
    {
        return variables.rawAccessToken;
    }



}

