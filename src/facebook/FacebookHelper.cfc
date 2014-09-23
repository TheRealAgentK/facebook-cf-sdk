component {

    public string function hashHmacSHA256(required string value, required string secretKey) {
        if (secretKey == "") {
            throw(errorcode="Invalid secretKey", message="Invalid secretKey (cannot be empty)", type=" Security");
        }
        var secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec" ).init(arguments.secretKey.getBytes(), "HmacSHA256");
        var mac = createObject("java", "javax.crypto.Mac").getInstance(secretKeySpec.getAlgorithm());
        mac.init(secretKeySpec);

        return toString(mac.doFinal(arguments.value.getBytes()), "ISO-8859-1");
	}

	public string function structToQueryString(required struct params) {
        var queryString = "";
        var delim1 = "=";
        var delim2 = "&";

        for (key in params) {
            queryString = ListAppend(queryString, URLEncodedFormat(LCase(key)) & delim1 & URLEncodedFormat(params[key]), delim2);
        }

        return queryString;
    }

    public struct function parseString(required string str) {
        var parsedString = {};
        var delim1 = "=";
        var delim2 = "&";
        var result = {};
        var params = ListToArray(arguments.str,delim2);

        for (var i=1; i <= ArrayLen(params); i=i+1) {
            if (ListLen(params[i],delim1) == 2) {
                structInsert(result, listGetAt(params[i],1,delim1), listGetAt(params[i],2,delim1));
            }
            else if (ListLen(params[i],delim1) == 1) {
                structInsert(result, listGetAt(params[i],1,delim1), "");
            }
        }

        return result;
    }




}
