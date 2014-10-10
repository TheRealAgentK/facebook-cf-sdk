/**
* FacebookRedirectLoginHelper - Utility CFC for server-side redirects
*/
component name="FacebookRedirectLoginHelper" accessors="false" {

    // ---- properties ----

    /**
    * The application id
    */
    variables.appId = "";

    /**
    * The application secret
    */
    variables.appSecret = "";

    /**
    * The redirect URL for the application
    */
    variables.redirectUrl = "";

    /**
    * Prefix to use for session variables
    */
    variables.sessionPrefix = "FBRLH_";

    /**
    * State token for CSRF validation
    */
    variables.state = "";

    /**
    * Toggle for PHP session status check
    */
    // TODO: Needed for CFML????
    variables.checkForSessionStatus = true;

    /**
    * Constructs a RedirectLoginHelper for a given appId and redirectUrl.
    *
    * @redirectUrl.hint The URL Facebook should redirect users to after login
    * @appId.hint The application id
    * @appSecret.hint The application secret
    */
    public void function init(required string redirectUrl, string appId = "", string appSecret = "") {

        variables.appId = CreateObject("component","facebook.FacebookSession").getTargetAppId(arguments.appId);
        variables.appSecret = CreateObject("component","facebook.FacebookSession").getTargetAppSecret(arguments.appSecret);
        variables.redirectUrl = arguments.redirectUrl;
    }

    /**
    * Stores CSRF state and returns a URL to which the user should be sent to in order to continue the login process with Facebook. The provided redirectUrl should invoke the handleRedirect method.
    *
    * @scope.hint List of permissions to request during login
    * @version.hint Optional Graph API version if not default (v2.1)
    *
    * @return Login URL
    */
    public string function getLoginUrl(required array scope, string version = "") {

        var apiVersion = arguments.version;

        if (!Len(apiVersion)) {
            apiVersion = CreateObject("component","facebook.FacebookRequest").GRAPH_API_VERSION;
        }

        variables.state = hash(createUUID());
        storeState(variables.state);

        var params = {"client_id"=variables.appId,"redirect_uri"=variables.redirectUrl,"state"=variables.state,"sdk"="cfml-sdk-" & CreateObject('component','facebook.FacebookRequest').VERSION,"scope"=ArrayToList(arguments.scope)};

        return "https://www.facebook.com/" & apiVersion & "/dialog/oauth?" & CreateObject("component","facebook.FacebookHelper").structToQueryString(params);
    }

    /**
    * Stores a state string in session storage for CSRF protection. Developers should subclass and override this method if they want to store this state in a different location.
    *
    * @param string $state
    *
    * @throws FacebookSDKException
    */
    public void function storeState(required string state) {
        // TODO check if checkforsessionstatus is on and if CFML server has sessionhandling ???
        // throw new FacebookSDKException('Session not active, could not store state.', 720
        session[variables.sessionPrefix & "state"] = arguments.state;
    }
}

