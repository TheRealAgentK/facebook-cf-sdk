<!---
Generate CFC documentation with ColdDoc 
Require /ColdDoc on the webroot (available at http://colddoc.riaforge.com)
 --->
<cfscript>
colddoc = createObject("component", "colddoc.ColdDoc").init();

strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init(expandPath("."), "Facebook ColdFusion SDK");
colddoc.setStrategy(strategy);
	
colddoc.generate(expandPath("/facebook/sdk"), "facebook.sdk");
</cfscript>

<h1>Done!</h1>

<a href=".">Documentation</a>