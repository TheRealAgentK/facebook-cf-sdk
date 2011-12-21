<cfsilent>
	<cfparam name="attributes.caption" default="" />
	<cfparam name="attributes.class" default="post publish link" />
	<cfparam name="attributes.description" default="" />
	<cfparam name="attributes.disabled" default="false" />
	<cfparam name="attributes.display" default="" />
	<cfparam name="attributes.label" default="Publish" />
	<cfparam name="attributes.link" default="" />
	<cfparam name="attributes.toolType" default="Publish" />
	<cfparam name="attributes.message" default="" />
	<cfparam name="attributes.name" default="" />
	<cfparam name="attributes.picture" default="" />
	<cfparam name="attributes.source" default="" />
	<cfparam name="attributes.style" default="" />
</cfsilent>
<cfoutput>
<script type="text/javascript" charset="utf-8">
 	var onShareButtonClick = function() {
 	<cfif not attributes.disabled>
 		FB.ui({'caption':'#jsStringFormat(attributes.caption)#', 
 			'description':'#jsStringFormat(attributes.description)#', 
 			<cfif len(attributes.display)>'display': '#attributes.display#',</cfif>
 			'link':'#attributes.link#', 
 			'method':'feed',
 			'message':'#jsStringFormat(attributes.message)#', 
 			'name':'#jsStringFormat(attributes.name)#', 
 			'picture':'#attributes.picture#', 
 			'source':'#attributes.source#'
 		}); 
 	</cfif>
 		return false;
 	}
</script>
 <a class="#attributes.class#" onclick="onShareButtonClick()"<cfif attributes.style is not ""> style="#attributes.style#"</cfif> title="#attributes.toolType#"><span>#attributes.label#</span></a></cfoutput>
<cfexit method="exittag" />
