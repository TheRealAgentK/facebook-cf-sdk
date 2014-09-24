/**
* FacebookSession - Models a session/connection to the FB API
*/
component name="FacebookSession" accessors="false" {

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
    *   var $session = new FacebookSession($accessToken);
    * This will validate the token and provide a Session object ready for use.
    * It will throw a SessionException in case of error.
    *
    * @param AccessToken|string $accessToken
    * @param SignedRequest $signedRequest The SignedRequest entity
    */
    public void function init(required AccessToken accessToken, SignedRequest signedRequest = "") {
        // CFC Metadata
        var metadata = getComponentMetadata("FacebookSession");

        /**
        * Default AppId
        */
        if (!StructKeyExists(metadata,"defaultAppId")) {
            lock name="FacebookSession.metadata.defaultAppId" timeout="10" {
                metadata["defaultAppId"] = "";
            }
        }

        /**
        * Default AppSecret
        */
        if (!StructKeyExists(metadata,"defaultAppSecret")) {
            lock name="FacebookSession.metadata.defaultAppSecret" timeout="10" {
                metadata["defaultAppSecret"] = "";
            }
        }

        /**
        * Flag if we use the AppSecret proof
        */
        if (!StructKeyExists(metadata,"useAppSecretProof")) {
            lock name="FacebookSession.metadata.useAppSecretProof" timeout="10" {
                metadata["useAppSecretProof"] = "";
            }
        }

        // TODO: This is the original PHP code --- look into
        // $this->accessToken = $accessToken instanceof AccessToken ? $accessToken : new AccessToken($accessToken);
        variables.accessToken = arguments.accessToken;
        variables.signedRequest = arguments.signedRequest;
    }

    /**
    * Returns the access token (a string)
    *
    * @return string
    */
    public string function getToken() {
        return variables.accessToken.accessToken;
    }

    /**
    * Returns the AccessToken (an entity)
    *
    * @return string
    */
    public string function getAccessToken() {
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


}


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
   * setDefaultApplication - Will set the static default appId and appSecret
   *   to be used for API requests.
   *
   * @param string $appId Application ID to use by default
   * @param string $appSecret App secret value to use by default
   */
  public static function setDefaultApplication($appId, $appSecret)
  {
    self::$defaultAppId = $appId;
    self::$defaultAppSecret = $appSecret;
  }

  /**
   * _getTargetAppId - Will return either the provided app Id or the default,
   *   throwing if neither are populated.
   *
   * @param string $appId
   *
   * @return string
   *
   * @throws FacebookSDKException
   */
  public static function _getTargetAppId($appId = null) {
    $target = ($appId ?: self::$defaultAppId);
    if (!$target) {
      throw new FacebookSDKException(
        'You must provide or set a default application id.', 700
      );
    }
    return $target;
  }

  /**
   * _getTargetAppSecret - Will return either the provided app secret or the
   *   default, throwing if neither are populated.
   *
   * @param string $appSecret
   *
   * @return string
   *
   * @throws FacebookSDKException
   */
  public static function _getTargetAppSecret($appSecret = null) {
    $target = ($appSecret ?: self::$defaultAppSecret);
    if (!$target) {
      throw new FacebookSDKException(
        'You must provide or set a default application secret.', 701
      );
    }
    return $target;
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
        */