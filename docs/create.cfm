<cfparam name="url.version" default="0">
<cfparam name="url.path" 	default="#expandPath( "./APIDocs" )#">

<cfscript>
    docName = "APIDocs";
    base = expandPath( "/facebook/src/facebook" );

    colddoc = new ColdDoc();

    strategy = new colddoc.strategy.api.HTMLAPIStrategy(url.path,"Facebook CFML SDK v#url.version#");
    colddoc.setStrategy(strategy);

    colddoc.generate(inputSource=base,outputDir=url.path,inputMapping="");
</cfscript>

<cfoutput>
<h1>Done!</h1>
<a href="#docName#/index.html">Go to Docs!</a>
</cfoutput>

