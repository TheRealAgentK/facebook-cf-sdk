<cfif thisTag.executionMode is "end"><cfsetting enablecfoutputonly="false">
<cfsilent>
<cfparam name="attributes.autoGrowEnabled" default="false" />
<cfparam name="attributes.cookieEnabled" default="true" />
<cfparam name="attributes.facebookApp" />
<cfparam name="attributes.localeCode" default="en_US" />
<cfparam name="attributes.channelUrl" default="" /><!--- Ex. : http://#cgi.SERVER_NAME#/facebook/sdk/assets/scripts/channel.cfm?localeCode=#attributes.localeCode# --->
<cfparam name="attributes.sizeEnabled" default="true" />
<cfparam name="attributes.statusEnabled" default="false" />
<cfparam name="attributes.xfbmlEnabled" default="true" />
<cfif getPageContext().getRequest().isSecure()>
	<cfset replaceNoCase(attributes.channelUrl, "http://", "https://") />
</cfif>
</cfsilent>
<cfoutput>
	<div id="fb-root"></div>
	<script type="text/javascript">
		window.fbAsyncInit = function() {
			FB.init({
				appId   : "#attributes.facebookApp.getAppId()#",
				<cfif attributes.channelUrl is not "">channelUrl  : "#attributes.channelUrl#",  // Custom channel URL</cfif>
				cookie  : <cfif attributes.cookieEnabled>true<cfelse>false</cfif>, // enable cookies to allow the server to access the session
				oauth	: true,
				status  : <cfif attributes.statusEnabled>true<cfelse>false</cfif>, // check login status
				xfbml   : <cfif attributes.xfbmlEnabled>true<cfelse>false</cfif> // parse XFBML
			});
			
			<cfif attributes.autoGrowEnabled>
				FB.Canvas.setAutoGrow();
			<cfelseif attributes.sizeEnabled>
				FB.Canvas.setSize();
			</cfif>
			
			#thisTag.generatedContent#
		};
	
		(function() {
			var e = document.createElement("script");
			e.src = document.location.protocol + "//connect.facebook.net/#attributes.localeCode#/all.js";
			e.async = true;
			document.getElementById("fb-root").appendChild(e);
		}());
	</script>
	<cfset thisTag.generatedContent = "" />
</cfoutput>
</cfif>