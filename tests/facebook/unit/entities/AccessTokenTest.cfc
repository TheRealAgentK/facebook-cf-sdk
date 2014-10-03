component name="AccessTokenTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        facebookHelper = CreateObject("component","facebook.FacebookHelper");
    }

    function afterTests() {
    }

    // TESTS
    function testAnAccessTokenCanBeReturnedAsAString() {
        var accessToken = new facebook.entities.AccessToken('foo_token');

        $assert.isEqual(accessToken._toString(),"foo_token");
    }

    function testShortLivedAccessTokensCanBeDetected() {
        var anHourAndAHalf = facebookHelper.epochTime() + 1.5 * 60;
        var accessToken = new facebook.entities.AccessToken("foo_token", anHourAndAHalf);
        var isLongLived = accessToken.isLongLived();

        $assert.isFalse(isLongLived, "Expected access token to be short lived.");
    }

    function testLongLivedAccessTokensCanBeDetected() {
        var aWeek = facebookHelper.epochTime() + 60 * 60 * 24 * 7;
        var accessToken = new facebook.entities.AccessToken("foo_token", aWeek);
        var isLongLived = accessToken.isLongLived();

        $assert.isTrue(isLongLived, "Expected access token to be long lived.");
    }


}

