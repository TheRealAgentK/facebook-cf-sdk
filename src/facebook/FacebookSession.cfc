/**
* FacebookSession - Models a session/connection to the FB API
*/
component name="facebook.FacebookSession" accessors="false" {

    // ---- private ----

    /**
	* The AccessToken entity for this connection
	*/
	variables.accessToken = "";

    /**
	* The SignedRequest entity for this connection
	*/
	variables.signedRequest = "";

    /**
    * When creating a Session from an access_token, use:
    *   var thesession = new FacebookSession(accessToken);
    * This will validate the token and provide a Session object ready for use.
    * It will throw a SessionException in case of error.
    *
    * @param AccessToken|string $accessToken
    * @param SignedRequest $signedRequest The SignedRequest entity
    */
    public void function init(required any accessToken, SignedRequest signedRequest) {

        // TODO: This is the original PHP code --- look into
        // $this->accessToken = $accessToken instanceof AccessToken ? $accessToken : new AccessToken($accessToken);
        if (isInstanceOf(arguments.accessToken,"facebook.entities.AccessToken")) {
            variables.accessToken = arguments.accessToken;
        } else {
            variables.accessToken = new facebook.entities.AccessToken(arguments.accessToken);
        }
        if (StructKeyExists(arguments,"signedRequest")) {
            variables.signedRequest = arguments.signedRequest;
        }
    }

    private any function getStaticMember(required string fieldname, boolean createIfNotExists = false, any value) {
        var metadata = getComponentMetadata("facebook.FacebookSession");
        var fullFieldname = "_" & arguments.fieldname;

        if (StructKeyExists(metadata,fullFieldname)) {
            lock name ="facebook.FacebookSession.metadata#fullFieldname#" timeout="10" type="readonly" {
                return metadata[fullFieldname];
            }
        } else if (!(StructKeyExists(metadata,fullFieldname)) && arguments.createIfNotExists && StructKeyExists(arguments,"value") && Len(arguments.value)) {
            lock name="facebook.FacebookSession.metadata#fullFieldname#" timeout="10" {
                metadata[fullFieldname] = arguments.value;
                return metadata[fullFieldname];
            }
        }

        throw(type="FacebookSessionStaticReadException",message="Static field #arguments.fieldname# doesn't exist");
    }

    private void function setStaticMember(required string fieldname, required any value, boolean overwrite = true) {
        var metadata = getComponentMetadata("facebook.FacebookSession");
        var fullFieldname = "_" & arguments.fieldname;

        try {
            if (!StructKeyExists(metadata,fullFieldname) || (StructKeyExists(metadata,fullFieldname) && arguments.overwrite)) {
                lock name="facebook.FacebookSession.metadata#fullFieldname#" timeout="10" {
                    metadata[fullFieldname] = arguments.value;
                }
            }
        }
        catch (any e) {
            throw(type="FacebookSessionStaticWriteException",message="Static field #fullFieldname# can't be overwritten/created");
        }
    }

    public void function dumpStaticScope() {
        var metadata = getComponentMetadata("facebook.FacebookSession");
        var prefix = "_";
        var result = {};

        for (var key in metadata) {
            if (Left(key,1) == prefix) {
                lock name="facebook.FacebookSession.metadata#key#" timeout="10" type="readonly" {
                    result[key] = metadata[key];
                }
            }
        }
        WriteDump(result);
    }

    /**
    * Returns the access token (a string)
    *
    * @return string
    */
    public string function getToken() {
        return variables.accessToken._toString();
    }

    /**
    * Returns the AccessToken (an entity)
    *
    * @return string
    */
    public AccessToken function getAccessToken() {
        return variables.accessToken;
    }

    /**
    * Returns the SignedRequest (an entity)
    *
    * @return string
    */
    public string function getSignedRequest() {
        return variables.signedRequest;
    }

    /**
    * Returns the signed request payload
    *
    * @return string
    */

    // TODO: Original PHP
    // return $this->signedRequest ? $this->signedRequest->getPayload() : null;
    public string function getSignedRequestData() {
        return variables.signedRequest.getPayload;
    }

    /**
    * Returns a property from the signed request data if available.
    *
    * @return string
    */
    public string function getSignedRequestProperty(required string key) {
        return variables.signedRequest;
    }

    /**
    * getTargetAppSecret - Will return either the provided app secret or the default, throwing if neither are populated.
    *
    * @appSecret.hint provided app secret to be returned
    *
    * @return app secret or FacebookSDKException is neither provided nor default set.
    */
    public string function getTargetAppSecret(string appSecret = "") {
        var target = "";

        if (Len(arguments.appSecret)) {
            target = arguments.appSecret;
        }
        else if (Len(getStaticMember("defaultAppSecret"))) {
            target = getStaticMember("defaultAppSecret");
        }

        if (Len(target)) {
            return target;
        }

        throw(type="FacebookSDKException",message="You must provide or set a default application secret (701)");
    }

    /**
    * getTargetAppId - Will return either the provided app Id or the default, throwing if neither are populated.
    *
    * @$appId.hint provided app id to be returned
    *
    * @return app id or FacebookSDKException is neither provided nor default set.
    */
    public string function getTargetAppId(string appId = "") {
        var target = "";

        if (Len(arguments.appId)) {
            target = arguments.appId;
        }
        else if (Len(getStaticMember("defaultAppId"))) {
            target = getStaticMember("defaultAppId");
        }

        if (Len(target)) {
            return target;
        }

        throw(type="FacebookSDKException",message="You must provide or set a default application id (700)");
    }

    /**
    * setDefaultApplication - Will set the static default appId and appSecret to be used for API requests.
    *
    * To be used as a static function
    *
    * @appId.hint Application ID to use by default
    * @appSecret.hint App secret value to use by default
    */
    public function setDefaultApplication(appId, appSecret) {
        setStaticMember("defaultAppId", arguments.appId);
        setStaticMember("defaultAppSecret", arguments.appSecret);
    }

    /**
    * Get whether or not appsecret_proof should be sent with requests.
    *
    * To be used as a static function
    *
    * @return boolean response
    */
    public boolean function useAppSecretProof()
    {
        return getStaticMember("useAppSecretProof",true,true);
    }
}

