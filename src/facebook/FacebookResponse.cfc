/**
* FacebookResponse - Models a response from the Facebook APIs
*/
component name="FacebookResponse" accessors="false" {

    // ---- properties ----

    /**
	* The request which produced this response
	*/
    variables.fbrequest = "";
    /**
	* Struct with the decoded response from the Graph API
	*/
    variables.responseData = "";
    /**
	* Raw response from the Graph API
	*/
    variables.rawResponse = "";
    /**
	* Indicates whether sent ETag matched the one on the FB side
	*/
    variables.etagHit = "";
    /**
	* ETag received with the response. Empty in case of ETag hit.
	*/
    variables.etag = "";

    /**
    * Creates a FacebookResponse object for a given request and response.
    *
    * @request.hint FacebookRequest
    * @responseData.hint Struct with JSON Decoded response data
    * @rawResponse.hint Raw string response
    * @etagHit.hint Indicates whether sent ETag matched the one on the FB side
    * @etag.hint ETag received with the response. Empty in case of ETag hit.
    */
    public void function init(required facebook.FacebookRequest fbrequest, required struct responseData, required string rawResponse, boolean etagHit = false, string etag = "") {

        variables.fbrequest = arguments.fbrequest;
        variables.responseData = arguments.responseData;
        variables.rawResponse = arguments.rawResponse;
        variables.etagHit = arguments.etagHit;
        variables.etag = arguments.etag;
    }

    /**
    * Returns the request which produced this response.
    *
    * @return FacebookRequest
    */
    public facebook.FacebookRequest function getRequest() {
        return variables.fbrequest;
    }

    /**
    * Returns the decoded response data.
    *
    * @return struct with the JSON Decoded response data
    */
    public struct function getResponse() {
        return variables.responseData;
    }

    /**
    * Returns the raw response
    *
    * @return raw string response
    */
    public string function getRawResponse() {
        variables.rawResponse;
    }

    /**
    * Returns true if ETag matched the one sent with a request
    *
    * @return boolean value
    */
    public boolean function isETagHit(){
        variables.etagHit;
    }

    /**
    * ETag received with the response. Empty in case of ETag hit.
    *
    * @return etag
    */
    public string function getETag() {
        return variables.etag;
    }

    /**
    * Gets the result as a GraphObject.
    *
    * @return GraphObject
    */
    // TODO: In PHP you can request a specific subtype to be cast into. Not sure if that makes sense for CFML
    // public function getGraphObject($type = 'Facebook\GraphObject') {
    public any function getGraphObject(required string subtype) {
        return CreateObject("component","facebook.#arguments.subtype#").init(variables.responseData);

    }

    /**
    * Returns an array of GraphObject returned by the request.
    *
    * @return array of GraphObjects
    */
    // TODO: In PHP you can request a specific subtype to be cast into. Not sure if that makes sense for CFML
    // ...$type = 'Facebook\GraphObject') {
    public array function getGraphObjectList() {
        var out = [];
        var data = variables.responseData.data;

        for (var i=1; i<ArrayLen(data); i++) {
            ArrayAppend(out, new facebook.GraphObject(variables.data[i]));
        }

        return out;
    }

    /**
    * If this response has paginated data, returns the FacebookRequest for the next page, or empty string
    *
    * @return FacebookRequest or nothing
    */
    public any function getRequestForNextPage() {
        return handlePagination("next");
    }

    /**
    * If this response has paginated data, returns the FacebookRequest for the previous page, or empty string
    *
    * @return FacebookRequest or nothing
    */
    public any function getRequestForPreviousPage() {
        return handlePagination("previous");
    }

    /**
    * Returns the FacebookRequest for the previous or next page, or empty string
    *
    * @direction.hint "next" or "previous"
    *
    * @return FacebookRequest or nothing
    */
    private any function handlePagination(required string direction) {
        if (StructKeyExists(variables.responseData,"paging") && StructKeyExists(variables.responseData.paging,"direction")) {
            var facebookHelper = CreateObject("component","FacebookHelper");
            var qs = ListRest(variables.responseData.paging.direction);
            var params = facebookHelper.parseString(qs);

            return new facebook.FacebookRequest(variables.fbrequest.getFBSession(),variables.fbrequest.getMethod(),variables.fbrequest.getPath(),params);
        } else {
            return "";
        }
    }

}



