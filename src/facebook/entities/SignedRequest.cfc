/**
* SignedRequest - models a signed request
*/
component name="SignedRequest" accessors="false" {

    // ---- properties ----

    /**
	* The raw signed request content
	*/
    variables.rawSignedRequest = "";
    /**
	* Payload struct (parsed request data)
	*/
    variables.payload = "";

    /**
    * Instantiate a new SignedRequest entity
    *
    * @rawSignedRequest.hint raw signed request
    * @state.hint random string to prevent CSRF
    * @appSecret.hint
    */
    public void function init(required string rawSignedRequest, required string state, required string appSecret) {

        variables.rawSignedRequest = arguments.rawSignedRequest;
        variables.payload = parse(variables.rawSignedRequest,arguments.state,arguments.appSecret);
    }

    /**
	* Returns the raw signed request data.
	*
	* @return The raw signed request content
	*/
    public string function getRawSignedRequest() {
        return variables.rawSignedRequest;
    }

    /**
	* Returns the parsed signed request data.
	*
	* @return The parsed signed request content
	*/
    public struct function getPayload() {
        return variables.payload;
    }

    /**
	* Returns a property from the signed request data if available.
	*
	* @key.hint Key to get from the signed request
	* @def.hint default value to return
	*
	* @return a value of the signed request
	*/
    public any function get(required string key, any def = "") {
        if (StructKeyExists(variables.payload,arguments.key)) {
            return variables.payload[key];
        }
        return arguments.def;
    }

    /**
	* Returns user_id from signed request data if available.
	*
	* @return user_id
	*/
    public string function getUserId() {
        return get("user_id");
    }

    /**
	* Checks for OAuth data in the payload.
	*
	* @return true or false
	*/
    public boolean function hasOAuthData() {
        if (StructKeyExists(variables.payload,"oauth_token") || StructKeyExists(variables.payload,"code")) {
            return true;
        }
        return false;
    }

    /**
	* Creates a signed request from an data set
	*
	* @payload.hint payload struct
	* @appSecret.hint
	*
	* @return signed request string
	*/
	// NOTE: This used to be a static PHP function, check payload vs. variables.payload
    public string function make(required struct payload, string appSecret = "") {
        var facebookHelper = CreateObject("component","FacebookHelper");
        var encodedPayload = "";
        var hashedSig = "";
        var encodedSig = "";

        variables.payload["algorithm"] = "HMAC-SHA256";
        variables.payload["issued_at"] = facebookHelper.epochTime();
        encodedPayload = facebookHelper.base64UrlEncode(serializeJSON(variables.payload));

        hashedSig = hashSignature(encodedPayload, arguments.appSecret);
        encodedSig = facebookHelper.base64UrlEncode(hashedSig);

        return encodedSig & "." & encodedPayload;

    }


    /**
    * Validates and decodes a signed request and returns the payload as a struct.
    *
    * @signedRequest.hint The signed request
    * @state.hint CSRF state
    * @appSecret.hint
    *
    * @return structure with the payload
    */
    // NOTE: This used to be a static PHP function use of instnace variables
    public struct function parse(required string signedRequest, string state = "", string appSecret = "") {
        var encodedSig = ListGetAt(arguments.signedRequest,1,".");
        var enocdedPayload = ListGetAt(arguments.signedRequest,2,".");

        // Signature validation
        var sig = decodeSignature(encodedSig);
        var hashedSig = hashSignature(encodedPayload, arguments.appSecret);
        validateSignature(hashedSig,sig);

        // Payload validation
        var data = decodePayload(encodedPayload);
        validateAlgorithm(data);

        if (Len(state)) {
            // TODO implement validateCSRF(data,state);
            // validateCSRF(data,arguments.state);
        }

        return data;
    }

    /**
    * Hashes the signature used in a signed request.
    *
    * @encodedData.hint encoded data
    * @appSecret.hint App secret
    *
    * @return string with hashed signature or FacebookSDKException
    */
    public string function hashSignature(required string encodedData, string appSecret = "") {
        var facebookHelper = CreateObject("component","FacebookHelper");
        var facebookSession = CreateObject("component","FacebookSession");

        var hashedSig = facebookHelper.hashHmacSHA256(arguments.encodedData, facebookSession.getTargetAppSecret(arguments.appSecret));

        if (Len(hashedSig)) {
            return hashedSig;
        }

        throw(type="FacebookSDKException",message="Unable to hash signature from encoded payload data (602)");
    }

    /**
    * Decodes the raw signature from a signed request.
    *
    * @encodedSig.hint encoded signature
    *
    * @return string with decoded signature or FacebookSDKException
    */
    public string function decodeSignature(required string encodedSig) {
        var facebookHelper = CreateObject("component","FacebookHelper");

        var sig = facebookHelper.base64UrlDecode(arguments.encodedSig);

        if (Len(sig)) {
            return sig;
        }

        throw(type="FacebookSDKException",message="Signed request has malformed encoded signature data (607)");
    }

    /**
    * Decodes the raw payload from a signed request.
    *
    * @$encodedPayload.hint encoded payload
    *
    * @return string with decoded payload or FacebookSDKException
    */
    public any function decodePayload(required string $encodedPayload) {
        var facebookHelper = CreateObject("component","FacebookHelper");

        var payload = facebookHelper.base64UrlDecode(arguments.$encodedPayload);

        if (Len(payload)) {
            payload = deserializeJSON(payload);
        }

        if (isStruct(payload) or isArray(payload)) {
            return payload;
        }

        throw(type="FacebookSDKException",message="Signed request has malformed encoded payload data (607)");
    }

    /**
    * Validates the algorithm used in a signed request.
    *
    * @$data.hint payload struct
    *
    * @return nothing or throws FacebookSDKException
    */
    public void function validateAlgorithm(required struct data) {
        if (StructKeyExists(arguments.data,"algorithm") && arguments.data["algorithm"] == "HMAC-SHA256") {
            return;
        }

        throw(type="FacebookSDKException",message="Signed request is using the wrong algorithm (605)");
    }

    /**
    * Validates the signature used in a signed request.
    *
    *
    */
    // TODO Not implemented yet
    public void function validateSignature(required string hashedSig, required string sig) {

        return;

    }

    /**
    * Validates a signed request against CSRF.
    *
    * @data.hint data struct
    * @state.hint CSRF token string
    *
    * @return nothing or throws FacebookSDKException
    */
    public void function validateCsrf(required struct data, required string state) {
        if (StructKeyExists(arguments.data,"state") && arguments.data["state"] == arguments.state) {
            return;
        }

        throw(type="FacebookSDKException",message="Signed request did not pass CSRF validation (604)");
    }

}
