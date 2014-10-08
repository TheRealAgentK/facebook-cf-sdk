/**
* FacebookRequestException - Request exception handler for the Facebook SDK
*/
component name="FacebookRequestException" accessors="false" extends="facebook.FacebookSDKException" {

    // ---- properties ----

    /**
    * Status code for the response causing the exception
    */
    variables.statusCode = "";

    /**
    * Raw response
    */
    variables.rawResponse = "";

    /**
    * Decoded response
    */
    variables.responseData = "";

    /**
    * Creates a FacebookRequestException.
    *
    * @rawResponse.hint The raw response from the Graph API
    * @responseData.hint The decoded response from the Graph API
    * @statusCode.hint status code from HTTP
    */
    public void function init(required string rawResponse, required struct responseData, required string statusCode) {

        var code = "";

        variables.rawResponse = arguments.rawResponse;
        variables.responseData = arguments.responseData;
        variables.statusCode = arguments.statusCode;

        // Move error information if needed
        if (!StructKeyExists(variables.responseData.error,"code") && StructKeyExists(variables.responseData,"code")) {
            variables.responseData = {"error"=variables.responseData};
        }

        if (StructKeyExists(variables.responseData.error,"code") && Len(variables.responseData.error["code"])) {
            code = variables.responseData.error["code"];
        }

        if (StructKeyExists(variables.responseData.error,"error_subcode") && Len(variables.responseData.error["error_subcode"])) {
            switch (variables.responseData.error["error_subcode"]) {
                // Other internal authentication issues
                case "458":
                case "459":
                case "460":
                case "463":
                case "464":
                case "467":
                    throw(
                        type="facebook.FacebookAuthorizationException",
                        message=variables.responseData.error.message,
                        errorCode=variables.responseData.error.code,
                        extendedInfo=SerializeJSON(variables.responseData.error),
                        detail="#variables.responseData.error.type# (Error Subcode: #variables.responseData.error['error_subcode']#)");
                    break;
            }
        }

        switch (code) {
            // Login status or token expired, revoked, or invalid
            case 100:
            case 102:
            case 190:
                throw(
                    type="facebook.FacebookAuthorizationException",
                    message=variables.responseData.error.message,
                    errorCode=code,
                    extendedInfo=SerializeJSON(variables.responseData.error),
                    detail="#variables.responseData.error.type#");
                break;
            // Server issue, possible downtime
            case 1:
            case 2:
                throw(
                    type="facebook.FacebookServerException",
                    message=variables.responseData.error.message,
                    errorCode=code,
                    extendedInfo=SerializeJSON(variables.responseData.error),
                    detail="#variables.responseData.error.type#");
                break;
            // API Throttling
            case 4:
            case 17:
            case 341:
                throw(
                    type="facebook.FacebookThrottleException",
                    message=variables.responseData.error.message,
                    errorCode=code,
                    extendedInfo=SerializeJSON(variables.responseData.error),
                    detail="#variables.responseData.error.type#");
                break;
            // Duplicate Post
            case 506:
                throw(
                    type="facebook.FacebookClientException",
                    message=variables.responseData.error.message,
                    errorCode=code,
                    extendedInfo=SerializeJSON(variables.responseData.error),
                    detail="#variables.responseData.error.type#");
                break;
        }

        // Missing Permissions
        if (code == 10 || (code >= 200 && code <= 299)) {
            throw(
                type="facebook.FacebookPermissionException",
                message=variables.responseData.error.message,
                errorCode=code,
                extendedInfo=SerializeJSON(variables.responseData.error),
                detail="#variables.responseData.error.type#");
        }

        // OAuth authentication error
        if (StructKeyExists(variables.responseData.error,"type") && variables.responseData.error.type == "OAuthException") {
            throw(
                type="facebook.FacebookAuthorizationException",
                message=variables.responseData.error.message,
                errorCode=variables.responseData.error.code,
                extendedInfo=SerializeJSON(variables.responseData.error),
                detail="#variables.responseData.error.type#");
        }

        throw(
            type="facebook.FacebookOtherException",
            message=variables.responseData.error.message,
            errorCode=variables.responseData.error.code,
            extendedInfo=SerializeJSON(variables.responseData.error),
            detail="#variables.responseData.error.type#");

    }

    /**
    * Checks a value and returns that or a default value.
    *
    * @key.hint key
    * @default.hint potential default value
    *
    * @return vlaue or default
    */
    private any function get(required string key, any default = "") {
        if (StructKeyExists(variables.responseData.error,arguments.key)) {
            return variables.responseData.error[arguments.key];
        }
        return arguments.default;
    }

    /**
    * Returns the HTTP status code
    *
    * @return string
    */
    public string function getHttpStatusCode() {
        return variables.statusCode;
    }

    /**
    * Returns the sub-error code
    *
    * @return int
    */
    public numeric function getSubErrorCode() {
        return get("error_subcode", -1);
    }

    /**
    * Returns the error type
    *
    * @return string
    */
    public numeric function getErrorType() {
        return get("type");
    }

    /**
    * Returns the raw response used to create the exception.
    *
    * @return string
    */
    public string function getRawResponse() {
        return variables.rawResponse;
    }

    /**
    * Returns the decoded response used to create the exception.
    *
    * @return struct
    */
    public struct function getResponse() {
        return variables.responseData;
    }
}