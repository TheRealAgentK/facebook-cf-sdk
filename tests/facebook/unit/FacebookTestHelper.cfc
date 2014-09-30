/**
* FacebookTestHelper
*/
component name="FacebookTestHelper" accessors="false" {

    // ---- properties ----

    variables.testSession = "";
    variables.testUserId = "";
    variables.testUserAccessToken = "";
    variables.testUserPermissions = ["read_stream","user_photos"];

    variables.testCredentials = CreateObject("FacebookTestCredentials");

    public function initialize() {

        if (!Len(testCredentials.appId) || !Len(testCredentials.appSecret)) {
            throw(type="FacebookSDKException",message="You must fill out FacebookTestCredentials.php");
        }



    }



}
   <!---
            FacebookSession::setDefaultApplication(
              FacebookTestCredentials::$appId, FacebookTestCredentials::$appSecret
            );
            if (!static::$testSession instanceof FacebookSession) {
              static::$testSession = static::createTestSession();
            }
--->