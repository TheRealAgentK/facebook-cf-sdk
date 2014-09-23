<cfsetting showDebugOutput="false">
<cfparam name="url.reporter" default="simple">
<cfparam name="url.directory" default="tests">
<cfparam name="url.recurse" default="true" type="boolean">
<cfparam name="url.bundles" default="">
<cfparam name="url.labels" default="">
<cfparam name="url.reportpath" default="#expandPath( "test/results" )#">
<cfscript>

// prepare for tests for bundles or directories
if( len( url.bundles ) ){
     testbox = new testbox.system.TestBox( bundles=url.bundles, labels=url.labels );
}
else{
     testbox = new testbox.system.TestBox( directory={ mapping=url.directory, recurse=url.recurse}, labels=url.labels );
}
// Run Tests using correct reporter
results = testbox.run( reporter=url.reporter );
// do stupid JUnitReport task processing, if the report is ANTJunit
if( url.reporter eq "ANTJunit" ){
     xmlReport = xmlParse( results );
     for( thisSuite in xmlReport.testsuites.XMLChildren ){
          fileWrite( url.reportpath & "/TEST-" & thisSuite.XMLAttributes.name & ".xml", toString( thisSuite ) );
     }
}
// Writeout Results
writeoutput( results );
</cfscript>