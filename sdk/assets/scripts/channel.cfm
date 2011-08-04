<cfsilent>
<cfparam name="url.localeCode" default="en_US" />
<cfset cacheExpire = 60 * 60 * 24 * 365 />
<cfheader name="Pragma" value="public" />
<cfheader name="Cache-Control" value="maxage=#cacheExpire#" />
<cfheader name="Expires" value="#getHttpTimeString(dateAdd('d', now(), 365))#">
</cfsilent><cfoutput><script src="//connect.facebook.net/#url.localeCode#/all.js"></script></cfoutput>