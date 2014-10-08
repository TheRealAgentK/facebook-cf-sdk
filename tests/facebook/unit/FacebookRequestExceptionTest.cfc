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
        //expectedException("facebook.FacebookAuthorizationException");

        var params = {"error"={"code"="100","message"="errmsg","error_subcode"="0","type"="exception"}};

        try {
            var sdkException = new facebook.FacebookRequestException(SerializeJSON(params),params,401);
        }
        catch (any e)
        {
            $assert.isEqual(100, e.ErrorCode, "Error Code wrong");
            $assert.isEqual("facebook.FacebookAuthorizationException", e.type, "Wrong Exception Type thrown");
            $assert.isEqual(0,DeserializeJSON(e.extendedInfo).error_subcode, "Error Subcode not 0");
        }



  /**
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(100, $exception->getCode());
    $this->assertEquals(0, $exception->getSubErrorCode());
    $this->assertEquals('exception', $exception->getErrorType());
    $this->assertEquals('errmsg', $exception->getMessage());
    $this->assertEquals($json, $exception->getRawResponse());
    $this->assertEquals(401, $exception->getHttpStatusCode());

    $params['error']['code'] = 102;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(102, $exception->getCode());

    $params['error']['code'] = 190;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(190, $exception->getCode());

    $params['error']['type'] = 'OAuthException';
    $params['error']['code'] = 0;
    $params['error']['error_subcode'] = 458;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(458, $exception->getSubErrorCode());

    $params['error']['error_subcode'] = 460;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(460, $exception->getSubErrorCode());

    $params['error']['error_subcode'] = 463;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(463, $exception->getSubErrorCode());

    $params['error']['error_subcode'] = 467;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(467, $exception->getSubErrorCode());

    $params['error']['error_subcode'] = 0;
    $json = json_encode($params);
    $exception = FacebookRequestException::create($json, $params, 401);
    $this->assertTrue($exception instanceof FacebookAuthorizationException);
    $this->assertEquals(0, $exception->getSubErrorCode());    */
  }


}
