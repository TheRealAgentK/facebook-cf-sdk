/**
* GraphUser
*/
component name="GraphUser" accessors="false" extends="facebook.GraphObject" {

    /**
    * Returns the ID for the user as a string if present.
    */
    public string function getId() {
        return getProperty('id');
    }

    /**
    * Returns the name for the user as a string if present.
    */
    public string function getName() {
        return getProperty('name');
    }

    /**
    * Returns the first name for the user as a string if present.
    */
    public string function getFirstName() {
        return getProperty('first_name');
    }

    /**
    * Returns the middle name for the user as a string if present.
    */
    public string function getMiddleName() {
        return getProperty('middle_name');
    }

    /**
    * Returns the last name for the user as a string if present.
    */
    public string function getLastName() {
        return getProperty('last_name');
    }

    /**
    * Returns the Facebook URL for the user as a string if available.
    */
    public string function getLink() {
        return getProperty('link');
    }

    /**
    * Returns the users birthday, if available (Timestamp)
    */
    public string function getBirthday() {
        return getProperty('birthday');
    }

    /**
    * Returns the current location of the user as a GraphLocation if available.
    */
    public void function getLocation() {
        //return getProperty('location', GraphLocation::className());
    }

}
