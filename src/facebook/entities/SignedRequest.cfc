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











}
