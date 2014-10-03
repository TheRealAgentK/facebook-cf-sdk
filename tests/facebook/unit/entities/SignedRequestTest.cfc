component name="SignedRequestTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        signedRequest = CreateObject("component","facebook.entities.SignedRequest");
        facebookHelper = CreateObject("component","facebook.FacebookHelper");

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
        expectedException("FacebookSDKException");
        var result = signedRequest.decodeSignature("foo!");
    }

    function testAValidEncodedPayloadCanBeDecoded() {
        var result = signedRequest.decodePayload('WyJwYXlsb2FkIl0=');

        $assert.isEqual(result,["payload"]);
    }

    function testAnImproperlyEncodedPayloadWillThrowAnException() {
        expectedException("FacebookSDKException");
        var result = signedRequest.decodePayload("foo!");
    }

    function testSignedRequestDataMustContainTheHmacSha256Algorithm() {
        signedRequest.validateAlgorithm(payloadData);
    }

    function testNonApprovedAlgorithmsWillThrowAnException() {
        expectedException("FacebookSDKException");
        var signedRequestData = Duplicate(payloadData);
        signedRequestData["algorithm"] = "FOO-ALGORITHM";

        signedRequest.validateAlgorithm(signedRequestData);
    }

    function testASignatureHashCanBeGeneratedFromBase64EncodedData() {
        var hashedSig = signedRequest.hashSignature("WyJwYXlsb2FkIl0=", appSecret);
        var expectedSig = charsetEncode("bFofyO2sERX73y8uvuX26SLodv0mZ+Zk18d8b3zhD+s=","ISO-8859-1");

        $assert.isEqual(hashedSig,expectedSig);
    }

    function testTwoBinaryStringsCanBeComparedForSignatureValidation() {
        var hashedSig = charsetEncode("bFofyO2sERX73y8uvuX26SLodv0mZ+Zk18d8b3zhD+s=","ISO-8859-1");
        signedRequest.validateSignature(hashedSig,hashedSig);

        // This is supposed to fail, not implemented yet.
        $assert.fail("Not implemented yet");
    }

    function testNonSameBinaryStringsWillThrowAnExceptionForSignatureValidation() {
        //expectedException("FacebookSDKException");
        var hashedSig1 = charsetEncode("bFofyO2sERX73y8uvuX26SLodv0mZ+Zk18d8b3zhD+s=","ISO-8859-1");
        var hashedSig2 = charsetEncode("GJy4HzkRtCeZA0cJjdZJtGfovcdxgl/AERI20S4MY7c=","ISO-8859-1");

        signedRequest.validateSignature(hashedSig1,hashedSig2);

        // This is supposed to fail, not implemented yet.
        $assert.fail("Not implemented yet");
    }

    function testASignedRequestWillPassCsrfValidation() {
        signedRequest.validateCsrf(payloadData, "foo_state");
    }

    function testASignedRequestWithIncorrectCsrfDataWillThrowAnException() {
        expectedException("FacebookSDKException");
        signedRequest.validateCsrf(payloadData, "invalid_foo_state");
    }

    function testARawSignedRequestCanBeValidatedAndDecoded() {
        var result = signedRequest.parse(rawSignedRequest, "foo_state", appSecret);

        $assert.isEqual(payloadData,result);
    }

    function testARawSignedRequestCanBeInjectedIntoTheConstructorToInstantiateANewEntity() {
        var signedRequestLocal = new facebook.entities.SignedRequest(rawSignedRequest, "foo_state", appSecret);
        var rawSignedRequestLocal = signedRequestLocal.getRawSignedRequest();
        var payloadDataLocal = signedRequestLocal.getPayload();
        var userIdLocal = signedRequestLocal.getUserId();
        var hasOAuthDataLocal = signedRequestLocal.hasOAuthData();

        $assert.instanceOf(signedRequestLocal,"facebook.entities.SignedRequest","Not the right type");
        $assert.isEqual(rawSignedRequest,rawSignedRequestLocal,"Wrong rawSignedRequest");
        $assert.isEqual(payloadData,payloadDataLocal,"Wrong payloadData");
        $assert.isEqual(123,userIdLocal,"Wrong userId");
        $assert.isTrue(hasOAuthDataLocal,"hasOauthData has an issue");

    }

}

