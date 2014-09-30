<cfscript>
    fbSession = CreateObject("facebook.FacebookSession")
    fbSession.setDefaultApplication('YOUR_APP_ID','YOUR_APP_SECRET');

    // Use one of the helper classes to get a FacebookSession object.
    //   FacebookRedirectLoginHelper
    //   FacebookCanvasLoginHelper
    //   FacebookJavaScriptLoginHelper
    // or create a FacebookSession with a valid access token:
    actualSession = new FacebookSession('access-token-here');

    // Get the GraphUser object for the current user:
    try {
        meRequest = new FacebookRequest(actualSession, "GET", "/me")
        meResponse = meRequest.execute();
        me = meResponse.getGraphObject(GraphUser.className());
        WriteDump(me);
    } catch (FacebookRequestException e) {
        // The Graph API returned an error
    } catch (any e) {
        // Some other error occurred
    }
</cfscript>
