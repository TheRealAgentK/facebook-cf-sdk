component name="FacebookSessionTest" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        facebookSession = CreateObject("component","FacebookSession");
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


}

