# Welcome to the Facebook CFML SDK
As of 29/07/2014 this project has been transferred from the stewardship of [Benoit](http://www.twitter.com/benorama) into [my ownership](http://www.twitter.com/AgentK) and is active again. Working with me on this is [Ross](http://www.twitter.com/fingersdacing) and this work is kindly supported by one of our clients. Other 3rd-party contributions and suggestions are very welcome.

Benoit's team has completely migrated from CFML to Grails in 2013 and provides now support for [Facebook SDK Grails Plugin](https://github.com/agorapulse/grails-facebook-sdk).

Please find the updated README content for Version 3.1.1a below - this will be looked at further and updated soon.

Kai (05/08/2014)


Facebook CFML SDK - V3.2.0alpha2 (05/09/2014)
============================================

# Release notes for V3.2.0alpha2 (05/09/2014)

* Fixing an issue in which API versioning was incorrectly handled in internalised instances of the FacebookGraphAPI
* Support for API versioning in the Facebook authentication dialog
* New function getObjectsBatchedAdvanced in FacebookGraphAPI to improve the handling of API batch requests.

# Release notes for V3.2.0alpha (12/08/2014)

* Initial basic support for API versioning in the CFCs
* There are two more working and correct examples of how to use the FB CFML SDK with a CFML-only login flow as well as a JS-Login-to-CFML flow (both using v2.0 API): /examples/website/serversideflow_v2_0.cfm and /examples/websites/j2serversideflow_v2_0.cfm
* Bugfix (c05a736170ca5533e1d0b62be96810bc405c52f2): Reverted an accidental deletion of the token expiry threshold variable
* Note: Facebook has deprecated the REST API in their version 2.1 API. There is no further work going into the FacebookRestAPI.cfc going forward from now on. You can probably continue to use it with version 1.0 and 2.0 apps for the time being, but you're kind of on your own.
* Note: Facebook has deprecated FQL in their version 2.1 API. There is no further work going into any FQL-related functionality of this SDK going forward from now on. You can probably continue to use it with version 1.0 and 2.0 apps for the time being, but you're kind of on your own.
* Note: As we're using only a handful of functions in FacebookGraphAPI.cfc ourselves and the framework doesn't have test cases, API version support IS considered to be experimental. In particular FacebookGraphAPI.cfc might contain shortcut functions that are not supported in v2.0 or v2.1 anymore. Please use at your own risk and report any issues, we're really keen to fix them.

# Release notes for V3.1.2 (12/08/2014)

* Some minor documentation fixes (links etc)
* There are two working and correct examples of how to use the FB CFML SDK with a CFML-only login flow as well as a JS-Login-to-CFML flow: /examples/website/serversideflow.cfm and /examples/websites/j2serversideflow.cfm
* Bugfix (879a1a5897378ca5edf21f96ba3ed1c220690613): Fixes an issue with the CSRF stake token to be regenerated wrongly
* Improvement (83f67df61f34c0d772d9fe7d299807afacf8a79d): getUserAccessToken is now aligned with the latest version of the FB PHP SDK version 3 branch --- this involves not taking care of a token exchange automatically anymore (NOTE: might be breaking your app/site)
* Improvement (83f67df61f34c0d772d9fe7d299807afacf8a79d): exchangeAccessToken sets the extended access token and its expiry time in the persistent scope automatically now so that it can be used as a stand-alone function from your app/site

# Release notes for V3.1.1a (05/08/2014)

* Some minor documentation fixes (links etc)
* Bugfix (dc3231fed7c5b6f869d10fdf3759a6c88c62b08a): Preventing Adobe ColdFusion's broken serialisation to JSON from breaking return values from FB in certain instances

# General Introduction

The [Facebook Platform](http://developers.facebook.com/) is a set of APIs that make your application more social. Read more about [integrating Facebook with your web site](http://developers.facebook.com/docs/guides/web) on the Facebook developer site. 

This project contains the open source **Facebook CFML SDK** that allows you to integrate the [Facebook Platform](http://developers.facebook.com/) on your website powered by a CFML-based application server, [Adobe ColdFusion](http://www.adobe.com/products/coldfusion) or [Railo](http://www.getrailo.org/index.cfm/download).

**Facebook CFML SDK** provides 3 components :

* **FacebookApp.cfc** - A library to build [apps on Facebook.com](http://developers.facebook.com/docs/guides/canvas/) and [websites with the Facebook Platform](http://developers.facebook.com/docs/guides/web) (the library is a complete port to CFML of the [Facebook PHP SDK V3.1.1](http://github.com/facebook/php-sdk)).
* **FacebookGraphAPI.cfc** - A client wrapper to call Facebook Graph API (the wrapper is inspired from the latest official .NET and Python SDKs graph clients).
* **FacebookRestAPI.cfc** - A client wrapper to call the old Facebook Rest API.

# Getting started

1. You must first download the latest version of the SDK. Please download the code base as a zip file, clone the repository or download a [specific tag](https://github.com/TheRealAgentK/facebook-cf-sdk/tags).
2. [Install the SDK](http://github.com/TheRealAgentK/facebook-cf-sdk/wiki/Installation) on your CFML server.
3. [Use the components](http://github.com/TheRealAgentK/facebook-cf-sdk/wiki/Usage) in your application.

To see the SDK in action, check the [examples](http://github.com/TheRealAgentK/facebook-cf-sdk/wiki/Examples).

# Migration from SDK V2

Previous Facebook ColdFusion SDK (V2.*) will stop working so you MUST upgrade to V3 by October 1, 2011.**

Check SDK documentation to see [How to migrate from SDK V2 to SDK V3](https://github.com/TheRealAgentK/facebook-cf-sdk/wiki/Migration)

# Documentation

To view the latest SDK documentation, please use the project [Wiki](http://github.com/TheRealAgentK/facebook-cf-sdk/wiki) section on GitHub.

# Downloads

Github has deprecated the Download section, to download the latest version of the SDK, please use the project's "Download ZIP" button, clone the repository to your local machine or grab a [specific tag](https://github.com/TheRealAgentK/facebook-cf-sdk/tags).

# Bugs

To report any bug, please use the project [Issues](http://github.com/TheRealAgentK/facebook-cf-sdk/issues) section on GitHub.

# Feedback

The **Facebook CFML SDK** is not an official Facebook SDK.

It is being developed by [Kai Koenig](http://www.twitter.com/AgentK) and [Ross Phillips](http://www.twitter.com/fingersdacing).

Previous versions (V3.1.1 up to mid-2013) were developed by Affinitiz, a french social media web agency.

The Facebook CFML SDK is licensed under the [Apache Licence, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

*Credits: logo based on ColdFusion Wallpaper - Revolution by [Angry Fly](http://angry-fly.com/).*
