/**
* GraphUser
*/
component name="GraphSessionInfo" accessors="false" extends="facebook.GraphObject" {

    /**
    * Returns the application id the token was issued for.
    */
    public string function getAppId() {
        return getProperty('app_id');
    }

    /**
    * Returns the application name the token was issued for.
    */
    public string function getApplication() {
        return getProperty('application');
    }

    /**
    * Returns the date & time that the token expires.
    */
    public string function getExpiresAt() {
        return getProperty("expires_at");
    }

    /**
    * Returns whether the token is valid.
    */
    public string function isValid() {
        return getProperty('is_valid');
    }

    /**
    * Returns the date & time the token was issued at.
    */
    public string function getIssuedAt() {
        return getProperty('issued_at');
    }

    /**
    * Returns the scope permissions associated with the token.
    */
    //TODO: Look into what this is actually doing
    public struct function getScopes() {
        return getPropertyAsArray('scopes');
    }

    /**
    * Returns the login id of the user associated with the token.
    */
    public string function getId() {
        return getProperty('user_id');
    }

}
