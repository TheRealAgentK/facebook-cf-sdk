component name="FacebookRequestHelper" extends="testbox.system.BaseSpec" {

    // SETUP

    function setup() {
    }

    function teardown() {
    }

    function beforeTests() {
        facebookHelper = CreateObject("component","FacebookHelper");
    }

    function afterTests() {
    }

    // TESTS structToQueryString
    function testStructToQueryStringPassingInEmptyStruct() {
        var result = facebookHelper.structToQueryString({});

        $assert.isEqual(result, "", "Empty strcut should create empty string");
    }

    function testStructToQueryStringPassingInValidStructt() {
        var testStruct = {"def":"564","abc":"bgfbdfg"};
        var result = facebookHelper.structToQueryString(testStruct);

        $assert.isEqual(2, ListLen(result,"&"), "String is not 2 elements long");
        $assert.isEqual(2, ListLen(result,"&"), "String is not 2 elements long");
    }

    // TESTS parseString
    function testParseStringRandomString() {
        var testString = "hgdfghfhghgf";
        var result = facebookHelper.parseString(testString);

        $assert.isEqual(isStruct(result), true, "Doesn't return struct");
        $assert.isEqual(1, StructCount(result), "Wrong number of keys");
        $assert.isEqual(result["hgdfghfhghgf"], "", "hgdfghfhghgf key isn't empty");
    }

    function testParseStringEmptyString() {
        var testString = "";
        var result = facebookHelper.parseString(testString);

        $assert.isEqual(isStruct(result), true, "Doesn't return struct");
        $assert.isEqual(0, StructCount(result), "Wrong number of keys");
    }

    function testParseStringValidString() {
        var testString = "abc=5454&def=6565";
        var result = facebookHelper.parseString(testString);

        $assert.isEqual(2, StructCount(result), "Wrong number of keys");
        $assert.isEqual(StructKeyExists(result,"abc"), true, "abc key doesn't exist");
        $assert.isEqual(StructKeyExists(result,"def"), true, "def key doesn't exist");
        $assert.isEqual(result["def"], "6565", "def key isn't the right value");
    }

    function testParseStringValidStringWithKeyButNoValue() {
        var testString = "abc=5454&def=6565&efg";
        var result = facebookHelper.parseString(testString);

        $assert.isEqual(3, StructCount(result), "Wrong number of keys");
        $assert.isEqual(StructKeyExists(result,"abc"), true, "abc key doesn't exist");
        $assert.isEqual(StructKeyExists(result,"def"), true, "def key doesn't exist");
        $assert.isEqual(StructKeyExists(result,"efg"), true, "efg key doesn't exist");
        $assert.isEqual(result["efg"], "", "efg key isn't empty");
    }

    function testConvertEpochTimeValid() {
        var testSeconds = 20;
        var result = facebookHelper.convertEpochTime(testSeconds);

        $assert.isEqual("{ts '1970-01-01 12:00:20'}", result, "Wrong Date");
    }

    function testConvertEpochTimeValidZero() {
        var testSeconds = 0;
        var result = facebookHelper.convertEpochTime(testSeconds);

        $assert.isEqual("{ts '1970-01-01 12:00:00'}", result, "Wrong Date");
    }

    function testConvertEpochTimeValidNegative() {
        var testSeconds = -10;
        var result = facebookHelper.convertEpochTime(testSeconds);

        $assert.isEqual("{ts '1970-01-01 11:59:50'}", result, "Wrong Date");
    }

    function testConvertEpochTimeValid1973() {
        var testSeconds = 123456789;
        var result = facebookHelper.convertEpochTime(testSeconds);

        $assert.isEqual("{ts '1973-11-30 09:33:09'}", result, "Wrong Date");
    }

    function testConvertEpochTimeValidString() {
        var testSeconds = "1234";
        var result = facebookHelper.convertEpochTime(testSeconds);

        $assert.isEqual("{ts '1970-01-01 12:20:34'}", result, "Wrong Date");
    }

    function testEpochTime1973() {
        var testTime = "{ts '1973-11-30 09:33:09'}";
        var result = facebookHelper.epochTime(testTime);

        $assert.isEqual(123456789, result, "Wrong Date");
    }

     function testEpochTimeZero() {
        var testTime = "{ts '1970-01-01 12:00:00'}";
        var result = facebookHelper.epochTime(testTime);

        $assert.isEqual(0, result, "Wrong Date");
    }

}
