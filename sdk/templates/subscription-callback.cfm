<cfscript>
// This an example of callback scrip for Facebook Real Time Updates
// The Graph API supports real-time updates to enable your application using Facebook to subscribe to changes in data from Facebook. 
// See Facebook documentation for more info http://developers.facebook.com/docs/reference/api/realtime/

VERIFY_TOKEN = ""; // You app subscription verification token (defined when you have created the app subscription)
SECRET_KEY = ""; // Your app secret key (only required if you want to validate payload SHA1 signature)

if (cgi.REQUEST_METHOD == "GET"
	&& structKeyExists(url, "hub.mode") && url["hub.mode"] == "subscribe" 
	&& structKeyExists(url, "hub.verify_token") && url["hub.verify_token"] == VERIFY_TOKEN) {
	// GET, subscription verification, return challenge value
	writeOutput(url["hub.challenge"]);	
} else if (cgi.REQUEST_METHOD == "POST") {
	// POST, change notification
	data = getHttpRequestData();
	if (SECRET_KEY != "") {
		// Validate payload signature
		expectedSignatureHex = listLast(data.headers["X-Hub-Signature"], "=");
		expectedSignature = toString(binaryDecode(expectedSignatureHex, "Hex"));
		signature = hashHmacSHA1(toString(data.content, "ISO-8859-1"), SECRET_KEY);
		if (signature != expectedSignature) {
			throw(errorcode="Invalid signature", message="X-Hub-Signature and payload signature do not match", type="Facebook Real Time Updates");
		}
	}
	jsonChange = toString(data.content);
	if (!isJson(jsonChange)) {
		throw(errorcode="Invalid Json content", message="Content is not valid JSON", type="Facebook Real Time Updates");
	} else {
		change = deserializeJson(jsonChange);
		// DO WHAT YOU WANT WITH CHANGES
		writeLog(file="subscription-callback", text="Object: #change['object']#");
		for (entry in change["entry"]) {
			changeDate = dateAdd("s", entry['time'], dateConvert("utc2Local", "January 1 1970 00:00"));
			writeLog(file="subscription-callback", text="Entry id=#entry['id']#, changed_fields=#arrayToList(entry['changed_fields'])#, time=#entry['time']# (#changeDate#)");
		}
	}
}

// hashHmac function
function hashHmacSHA1(required String value, required String secretKey) {
	if (secretKey == "") {
		throw(errorcode="Invalid secretKey", message="Invalid secretKey (cannot be empty)", type="FacebookApp Security");
	}
	var secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec").init(arguments.secretKey.getBytes(), "HmacSHA1");
	var mac = createObject("java", "javax.crypto.Mac").getInstance(secretKeySpec.getAlgorithm());
	mac.init(secretKeySpec);
	return toString(mac.doFinal(arguments.value.getBytes()));
}
</cfscript>