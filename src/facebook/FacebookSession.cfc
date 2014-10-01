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
        if (StructKeyExists(variables,"signedRequest")) {
            variables.signedRequest = arguments.signedRequest;
        }
    }

    private any function getStaticMember(required string fieldname) {
        var metadata = getComponentMetadata("facebook.FacebookSession");
        var fullFieldname = "_" & arguments.fieldname;

        if (StructKeyExists(metadata,fullFieldname)) {
            lock name="facebook.FacebookSession.metadata#fullFieldname#" timeout="10" type="readonly" {
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
}




   <!---
  /**
   * Returns a property from the signed request data if available.
   *
   * @param string $key
   *
   * @return null|mixed
   */
  public function getSignedRequestProperty($key)
  {
    return $this->signedRequest ? $this->signedRequest->get($key) : null;
  }

  /**
   * Returns user_id from signed request data if available.
   *
   * @return null|string
   */
  public function getUserId()
  {
    return $this->signedRequest ? $this->signedRequest->getUserId() : null;
  }

  // @TODO Remove getSessionInfo() in 4.1: can be accessed from AccessToken directly
  /**
   * getSessionInfo - Makes a request to /debug_token with the appropriate
   *   arguments to get debug information about the sessions token.
   *
   * @param string|null $appId
   * @param string|null $appSecret
   *
   * @return GraphSessionInfo
   */
  public function getSessionInfo($appId = null, $appSecret = null)
  {
    return $this->accessToken->getInfo($appId, $appSecret);
  }

  // @TODO Remove getLongLivedSession() in 4.1: can be accessed from AccessToken directly
  /**
   * getLongLivedSession - Returns a new Facebook session resulting from
   *   extending a short-lived access token.  If this session is not
   *   short-lived, returns $this.
   *
   * @param string|null $appId
   * @param string|null $appSecret
   *
   * @return FacebookSession
   */
  public function getLongLivedSession($appId = null, $appSecret = null)
  {
    $longLivedAccessToken = $this->accessToken->extend($appId, $appSecret);
    return new static($longLivedAccessToken, $this->signedRequest);
  }

  // @TODO Remove getExchangeToken() in 4.1: can be accessed from AccessToken directly
  /**
   * getExchangeToken - Returns an exchange token string which can be sent
   *   back to clients and exchanged for a device-linked access token.
   *
   * @param string|null $appId
   * @param string|null $appSecret
   *
   * @return string
   */
  public function getExchangeToken($appId = null, $appSecret = null)
  {
    return AccessToken::getCodeFromAccessToken($this->accessToken, $appId, $appSecret);
  }

  // @TODO Remove validate() in 4.1: can be accessed from AccessToken directly
  /**
   * validate - Ensures the current session is valid, throwing an exception if
   *   not.  Fetches token info from Facebook.
   *
   * @param string|null $appId Application ID to use
   * @param string|null $appSecret App secret value to use
   * @param string|null $machineId
   *
   * @return boolean
   *
   * @throws FacebookSDKException
   */
  public function validate($appId = null, $appSecret = null, $machineId = null)
  {
    if ($this->accessToken->isValid($appId, $appSecret, $machineId)) {
      return true;
    }

    // @TODO For v4.1 this should not throw an exception, but just return false.
    throw new FacebookSDKException(
      'Session has expired, or is not valid for this app.', 601
    );
  }

  // @TODO Remove validateSessionInfo() in 4.1: can be accessed from AccessToken directly
  /**
   * validateTokenInfo - Ensures the provided GraphSessionInfo object is valid,
   *   throwing an exception if not.  Ensures the appId matches,
   *   that the token is valid and has not expired.
   *
   * @param GraphSessionInfo $tokenInfo
   * @param string|null $appId Application ID to use
   * @param string|null $machineId
   *
   * @return boolean
   *
   * @throws FacebookSDKException
   */
  public static function validateSessionInfo(GraphSessionInfo $tokenInfo,
                                           $appId = null,
                                           $machineId = null)
  {
    if (AccessToken::validateAccessToken($tokenInfo, $appId, $machineId)) {
      return true;
    }

    // @TODO For v4.1 this should not throw an exception, but just return false.
    throw new FacebookSDKException(
      'Session has expired, or is not valid for this app.', 601
    );
  }

  /**
   * newSessionFromSignedRequest - Returns a FacebookSession for a
   *   given signed request.
   *
   * @param SignedRequest $signedRequest
   *
   * @return FacebookSession
   */
  public static function newSessionFromSignedRequest(SignedRequest $signedRequest)
  {
    if ($signedRequest->get('code')
      && !$signedRequest->get('oauth_token')) {
      return self::newSessionAfterValidation($signedRequest);
    }
    $accessToken = $signedRequest->get('oauth_token');
    $expiresAt = $signedRequest->get('expires', 0);
    $accessToken = new AccessToken($accessToken, $expiresAt);
    return new static($accessToken, $signedRequest);
  }

  /**
   * newSessionAfterValidation - Returns a FacebookSession for a
   *   validated & parsed signed request.
   *
   * @param SignedRequest $signedRequest
   *
   * @return FacebookSession
   */
  protected static function newSessionAfterValidation(SignedRequest $signedRequest)
  {
    $code = $signedRequest->get('code');
    $accessToken = AccessToken::getAccessTokenFromCode($code);
    return new static($accessToken, $signedRequest);
  }

  /**
   * newAppSession - Returns a FacebookSession configured with a token for the
   *   application which can be used for publishing and requesting app-level
   *   information.
   *
   * @param string|null $appId Application ID to use
   * @param string|null $appSecret App secret value to use
   *
   * @return FacebookSession
   */
  public static function newAppSession($appId = null, $appSecret = null)
  {
    $targetAppId = static::_getTargetAppId($appId);
    $targetAppSecret = static::_getTargetAppSecret($appSecret);
    return new FacebookSession(
      $targetAppId . '|' . $targetAppSecret
    );
  }




  /**
   * Enable or disable sending the appsecret_proof with requests.
   *
   * @param bool $on
   */
  public static function enableAppSecretProof($on = true)
  {
    static::$useAppSecretProof = ($on ? true : false);
  }

  /**
   * Get whether or not appsecret_proof should be sent with requests.
   *
   * @return bool
   */
  public static function useAppSecretProof()
  {
    return static::$useAppSecretProof;
  }

}


   */



/*
getter for:


  protected static $useAppSecretProof = true;



getToken function
        */      --->