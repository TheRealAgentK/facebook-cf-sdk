component name="AccessTokenTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        facebookHelper = CreateObject("component","FacebookHelper");
    }

    function afterTests() {
    }

    // TESTS
    function testAnAccessTokenCanBeReturnedAsAString() {
        var accessToken = new AccessToken('foo_token');

        $assert.isEqual(accessToken._toString(),"foo_token");
    }

    function testShortLivedAccessTokensCanBeDetected() {
        var anHourAndAHalf = facebookHelper.epochTime() + 1.5 * 60;
        var accessToken = new AccessToken("foo_token", anHourAndAHalf);
        var isLongLived = accessToken.isLongLived();

        $assert.isFalse(isLongLived, "Expected access token to be short lived.");
    }

    function testLongLivedAccessTokensCanBeDetected() {
        var aWeek = facebookHelper.epochTime() + 60 * 60 * 24 * 7;
        var accessToken = new AccessToken("foo_token", aWeek);
        var isLongLived = accessToken.isLongLived();

        $assert.isTrue(isLongLived, "Expected access token to be long lived.");
    }


}


<!---  function testInfoAboutAnAccessTokenCanBeObtainedFromGraph() {

    $testUserAccessToken = FacebookTestHelper::$testUserAccessToken;

    $accessToken = new AccessToken($testUserAccessToken);
    $accessTokenInfo = $accessToken->getInfo();

    $testAppId = FacebookTestCredentials::$appId;
    $this->assertEquals($testAppId, $accessTokenInfo->getAppId());

    $testUserId = FacebookTestHelper::$testUserId;
    $this->assertEquals($testUserId, $accessTokenInfo->getId());

    $expectedScopes = FacebookTestHelper::$testUserPermissions;
    $actualScopes = $accessTokenInfo->getPropertyAsArray('scopes');
    foreach ($expectedScopes as $scope) {
      $this->assertTrue(in_array($scope, $actualScopes),
        'Expected the following permission to be present: '.$scope);

    }

--->
