component name="SignedRequestTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        signedRequest = CreateObject("component","SignedRequest");

        appSecret = "foo_app_secret";
        rawSignedRequest = "U0_O1MqqNKUt32633zAkdd2Ce-jGVgRgJeRauyx_zC8=.eyJvYXV0aF90b2tlbiI6ImZvb190b2tlbiIsImFsZ29yaXRobSI6IkhNQUMtU0hBMjU2IiwiaXNzdWVkX2F0IjozMjEsImNvZGUiOiJmb29fY29kZSIsInN0YXRlIjoiZm9vX3N0YXRlIiwidXNlcl9pZCI6MTIzLCJmb28iOiJiYXIifQ==";
        payloadData = {"oauth_token":"foo_token","algorithm":"HMAC-SHA256","issued_at":"321","code":"foo_code","state":"foo_state","user_id":"123","foo":"bar"};
    }

    function afterTests() {
    }

    // TESTS

    function testAValidEncodedSignatureCanBeDecoded() {
        var result = signedRequest.decodeSignature("c2ln");

        $assert.isEqual(result,"sig");
    }

    function testAnImproperlyEncodedSignatureWillThrowAnException() {
        expectedException("FacebookSDKException")
        var result = signedRequest.decodeSignature("foo!");

  }


}
