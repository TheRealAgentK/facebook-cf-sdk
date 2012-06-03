<cfsilent>
<cfparam name="attributes.contact" default="#structNew()#" type="Struct" />
<cfparam name="attributes.description" />
<cfparam name="attributes.imageUrl" default="" />
<cfparam name="attributes.location" default="#structNew()#" type="Struct" />
<cfparam name="attributes.siteName" default="#cgi.SERVER_NAME#" />
<cfparam name="attributes.title" />
<cfparam name="attributes.type" default="" />
<cfparam name="attributes.url" default="" />
<cfparam name="attributes.videoUrl" default="" />
<cfparam name="attributes.videoType" default="application/x-shockwave-flash" />
</cfsilent>
<cfoutput>
<!--- Basic metadata --->
<meta property="og:title" content="#attributes.title#"/>
<meta property="og:description" content="#attributes.description#"/>
<cfif attributes.type is not ""><meta property="og:type" content="#attributes.type#"/>
</cfif>
<cfif attributes.imageUrl is not "">
    <meta property="og:image" content="#attributes.imageUrl#"/>
</cfif>
<cfif attributes.videoUrl is not "">
    <meta property="og:video" content="#attributes.videoUrl#"/>
    <meta property="og:video:type" content="#attributes.videoType#"/>
</cfif>
<cfif attributes.url is not ""><meta property="og:url" content="#attributes.url#"/>
</cfif>
<meta property="og:site_name" content="#attributes.siteName#"/>

<!--- Location metadata --->
<cfif structCount(attributes.location)>
	<cfif structKeyExists(attributes.location, "latitude")><meta property="og:latitude" content="#attributes.location.latitude#" />
	</cfif>
	<cfif structKeyExists(attributes.location, "longitude")><meta property="og:longitude" content="#attributes.location.longitude#" />
	</cfif>
	<cfif structKeyExists(attributes.location, "streetAddress")><meta property="og:street-address" content="#attributes.location.streetAddress#" />
	</cfif>
	<cfif structKeyExists(attributes.location, "locality")><meta property="og:locality" content="#attributes.location.locality#" />
	</cfif>
	<cfif structKeyExists(attributes.location, "region")><meta property="og:region" content="#attributes.location.region#" />
	</cfif>
	<cfif structKeyExists(attributes.location, "postalCode")><meta property="og:postal-code" content="#attributes.location.postalCode#" />
	</cfif>
	<cfif structKeyExists(attributes.location, "countryName")><meta property="og:country-name" content="#attributes.location.countryName#" />
	</cfif>
</cfif>
<!--- Contact metadata --->
<cfif structCount(attributes.contact)>	
	<cfif structKeyExists(attributes.contact, "email")><meta property="og:email" content="#attributes.contact.email#" />
	</cfif>
	<cfif structKeyExists(attributes.contact, "phone")><meta property="og:phone_number" content="#attributes.contact.phone#" />
	</cfif>
	<cfif structKeyExists(attributes.contact, "fax")><meta property="og:fax_number" content="#attributes.contact.fax#" />
	</cfif>
</cfif>
</cfoutput>
<cfexit method="exittag" />
