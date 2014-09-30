<cfsetting showDebugOutput="false">

<cfparam name="url.reporter" 		default="simple">
<cfparam name="url.directory" 		default="tests">
<cfparam name="url.recurse" 		default="true" type="boolean">
<cfparam name="url.bundles" 		default="">
<cfparam name="url.labels" 			default="">
<cfparam name="url.reportpath" 		default="#expandPath( "/railo-4.2.1.000/facebook/tests/reports" )#">

<!--- Include the TestBox HTML Runner --->
<cfinclude template="/testbox/system/runners/HTMLRunner.cfm" >