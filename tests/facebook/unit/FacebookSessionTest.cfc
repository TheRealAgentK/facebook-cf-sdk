component name="FacebookSessionTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        facebookSession = CreateObject("component","facebook.FacebookSession");
    }

    function afterTests() {
    }

    // TESTS
    function testCreateNewFacebookSessionAndSetStaticDefaultsAndChangeThem() {
        CreateObject("facebook.FacebookSession").setDefaultApplication('FOO_APP_ID','FOO_APP_SECRET');

        $assert.isEqual("FOO_APP_ID",facebookSession.getTargetAppId(),"Static App ID seems to be wrong");
        $assert.isEqual("FOO_APP_SECRET",facebookSession.getTargetAppSecret(),"Static App Secret seems to be wrong");

        CreateObject("facebook.FacebookSession").setDefaultApplication('SOME_OTHER_APP_ID','FOOBAR_APP_SECRET');

        $assert.isEqual("SOME_OTHER_APP_ID",facebookSession.getTargetAppId(),"Static App ID seems to be wrong");
        $assert.isEqual("FOOBAR_APP_SECRET",facebookSession.getTargetAppSecret(),"Static App Secret seems to be wrong");
    }

    function testConstructor() {
        var fbS1 = new facebook.FacebookSession("54785487543875843");

        $assert.instanceOf(fbS1.getAccessToken(),"AccessToken","Access Token not the right type");
        $assert.instanceOf(fbS1.getAccessToken(),"facebook.entities.AccessToken","Access Token not the right type");
        $assert.instanceOf(fbS1.getAccessToken(),"facebook.entities.AccessToken","Access Token not the right type");

    }

    function testAccessTokenProperlySetInConstructor() {
        var fbS1 = new facebook.FacebookSession("547854875438758455454");

        $assert.isEqual("547854875438758455454",fbS1.getAccessToken()._toString(),"Access Token value not properly set in AccessToken inside FB Session");

    }

    function testAccessTokenProperlySetInConstructorViaGetToken() {
        var fbS1 = new facebook.FacebookSession("547854875438758455454");

        $assert.isEqual("547854875438758455454",fbS1.getToken(),"Access Token value not properly set in AccessToken inside FB Session");

    }

}

