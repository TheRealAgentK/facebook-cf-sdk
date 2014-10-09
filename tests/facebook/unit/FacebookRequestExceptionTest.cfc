component name="FacebookRequestExceptionTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        facebookRequestException = CreateObject("component","facebook.facebookRequestException");
        facebookHelper = CreateObject("component","facebook.FacebookHelper");
    }

    function afterTests() {
    }

    // TESTS
    public function testAuthorizationExceptions() {

        var params = {"error"={"code"="100","message"="errmsg","error_subcode"="0","type"="exception"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(100, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 102;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(102, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 190;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(190, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 0;
            params["error"]["type"] = "OAuthException";
            params["error"]["error_subcode"] = 458;

            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(0, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(458,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 458");
            $assert.isEqual("OAuthException",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["error_subcode"] = 460;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(0, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(460,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 460");
            $assert.isEqual("OAuthException",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["error_subcode"] = 463;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(0, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(463,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 463");
            $assert.isEqual("OAuthException",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["error_subcode"] = 467;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(0, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(467,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 467");
            $assert.isEqual("OAuthException",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["error_subcode"] = 0;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(0, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("OAuthException",DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg",DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testServerExceptions()
    {

        var params = {"error" = {"code" = "1", "message" = "errmsg", "error_subcode" = "0", "type" = "exception"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 500);
        }
        catch (any e)
        {
            $assert.isEqual(1, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookServerException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 2;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(2, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookServerException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testThrottleExceptions()
    {

        var params = {"error" = {"code" = "4", "message" = "errmsg", "error_subcode" = "0", "type" = "exception"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(4, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookThrottleException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 17;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(17, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookThrottleException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 341;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(341, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookThrottleException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testUserIssueExceptions()
    {

        var params = {"error" = {"code" = "230", "message" = "errmsg", "error_subcode" = "459", "type" = "exception"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(230, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(459, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["error_subcode"] = 464;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(230, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(464, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testPermissionExceptions()
    {

        var params = {"error" = {"code" = "10", "message" = "errmsg", "error_subcode" = "0", "type" = "exception"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(10, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookPermissionException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 200;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(200, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookPermissionException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 250;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(250, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookPermissionException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }

        try {
            params["error"]["code"] = 299;
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(299, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookPermissionException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testClientExceptions()
    {

        var params = {"error" = {"code" = "506", "message" = "errmsg", "error_subcode" = "0", "type" = "exception"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 401);
        }
        catch (any e)
        {
            $assert.isEqual(506, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookClientException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("exception", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("errmsg", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testOtherException()
    {

        var params = {"error" = {"code" = "42", "message" = "ship love", "error_subcode" = "0", "type" = "feature"}};
        var sdkException = "";

        try {
            sdkException = new facebook.FacebookRequestException(SerializeJSON(params), params, 200);
        }
        catch (any e)
        {
            $assert.isEqual(42, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookOtherException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0, DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
            $assert.isEqual("feature", DeserializeJSON(e.extendedInfo).type, "type wrong");
            $assert.isEqual("ship love", DeserializeJSON(e.extendedInfo).message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testValidateThrowsException()
    {
        // Enter real AppId and AppSecret here
        CreateObject("facebook.FacebookSession").setDefaultApplication('---','---');

        var bogusSession = new facebook.FacebookSession("invalid-token");

        try {
            bogusSession.validate();
        }
        catch (any e)
        {
            $assert.isEqual(601, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookSDKException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual("",e.extendedInfo, "Extended Info should be empty");
            $assert.isTrue(!isJSON(e.extendedInfo), "Extended Info is JSON");
        }
    }

    public function testValidateThrowsRealException()
    {
        expectedException("facebook.FacebookSDKException");
        // Enter real AppId and AppSecret here
        CreateObject("facebook.FacebookSession").setDefaultApplication('---','---');

        var bogusSession = new facebook.FacebookSession("invalid-token");
        bogusSession.validate();
    }

    public function testInvalidCredentialsException()
    {
        var bogusSession = new facebook.FacebookSession("invalid-token");

        try {
            bogusSession.validate("BOGUS","SOME_MORE_BOGUS");
        }
        catch (any e)
        {
            $assert.isEqual(190, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual("Invalid OAuth access token signature.",e.message, "Message wrong");
            $assert.isTrue(isJSON(e.extendedInfo), "Extended Info is not JSON");
        }
    }

    public function testInvalidCredentialsRealException()
    {
        expectedException("facebook.FacebookAuthorizationException");

        var bogusSession = new facebook.FacebookSession("invalid-token");
        bogusSession.validate("BOGUS","SOME_MORE_BOGUS");
    }

}



