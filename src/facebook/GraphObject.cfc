/**
* GraphObject
*/
component name="GraphObject" accessors="false" {

    /**
    * Holds the raw associative data for this object
    */
    variables.backingData = "";

    /**
    * Creates a GraphObject using the data provided.
    *
    * @raw.hint raw data structure
    */
    public any function init(required struct raw) {

        variables.backingData = arguments.raw;

        if (StructKeyExists(variables.backingData,"data") && structCount(variables.backingData) == 1) {
            variables.backingData = variables.backingData["data"];
        }

        return this;
    }

    /**
    * Return struct of the given graph object.
    *
    * @return backing data as struct
    */
    public function getBackingData() {
        return variables.backingData;
    }


    /**
    * getProperty - Gets the value of the named property for this graph object, cast to the appropriate subclass type if provided.
    *
    * @name.hint The property to retrieve
    * @subtype.hint The subclass of GraphObject, optionally
    *
    * @return subtype of GraphObject
    */
    public any function getProperty(required string name, string subtype = "GraphObject") {
        if (StructKeyExists(variables.backingData,arguments.name)) {
            var value = variables.backingData[arguments.name];
            if (!isObject(value)) {
                return value;
            } else {
                return CreateObject("component","facebook.#arguments.subtype#").init(value);
            }
        } else {
            return "";
        }
    }



}
