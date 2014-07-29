# Welcome to the Facebook CFML SDK
As of 29/07/2014 this project has been transfered from the stewardship of Benoit (@benorama on Twitter) into my ownership (@AgentK on Twitter) and is active again. Working with me on this is Ross (@fingersdancing On Twitter) and this work is kindly supported by one of our clients. Other 3rd-party contributions and suggestions are very welcome.

Benoit's team has completely migrated from ColdFusion to Grails in 2013 and provides now support for [Facebook SDK Grails Plugin](https://github.com/agorapulse/grails-facebook-sdk).

Please find the existing README content for Version 3.1.1 below - this will be looked at and updated soon.

Kai (29/07/2014)

Facebook ColdFusion SDK - V3.1.1
================================

# Introduction

The [Facebook Platform](http://developers.facebook.com/) is a set of APIs that make your application more social. Read more about [integrating Facebook with your web site](http://developers.facebook.com/docs/guides/web) on the Facebook developer site. 

This project contains the open source **Facebook ColdFusion SDK** that allows you to integrate the [Facebook Platform](http://developers.facebook.com/) on your website powered by a [ColdFusion application server](http://www.adobe.com/products/coldfusion).

**Facebook ColdFusion SDK** provides 3 components :

* **FacebookApp.cfc** - A library to build [apps on Facebook.com](http://developers.facebook.com/docs/guides/canvas/) and [websites with the Facebook Platform](http://developers.facebook.com/docs/guides/web) (the library is a complete port to ColdFusion of the [Facebook PHP SDK V3.1.1](http://github.com/facebook/php-sdk)).
* **FacebookGraphAPI.cfc** - A client wrapper to call Facebook Graph API (the wrapper is inspired from the latest official .NET and Python SDKs graph clients).
* **FacebookRestAPI.cfc** - A client wrapper to call the old Facebook Rest API.

# Getting started

1. You must first [Download](http://github.com/affinitiz/facebook-cf-sdk/downloads) the latest version of the SDK.
2. [Install the SDK](http://github.com/affinitiz/facebook-cf-sdk/wiki/Installation) on your ColdFusion server.
3. [Use the components](http://github.com/affinitiz/facebook-cf-sdk/wiki/Usage) in your application.

To see the SDK in action, check the [examples](http://github.com/affinitiz/facebook-cf-sdk/wiki/Examples).

# Migration from SDK V2

As explained in [Facebook Platform Roadmap](http://developers.facebook.com/roadmap/), by October 1, 2011:

* all Website and Canvas apps must exclusively support [OAuth 2.0 (draft 20)](http://tools.ietf.org/html/draft-ietf-oauth-v2-20)
* all Canvas Apps must use the *signed_request* parameter
* an **SSL Certificate** is required for all Canvas and Page Tab apps (not in Sandbox mode)
* old, previous versions of our SDKs will **stop working**, including the old JavaScript SDK, old iOS SDK

**Previous Facebook ColdFusion SDK (V2.*) will stop working so you MUST upgrade to V3 by October 1, 2011.**

Check SDK documentation to see [How to migrate from SDK V2 to SDK V3](https://github.com/affinitiz/facebook-cf-sdk/wiki/Migration)

# Documentation

To view the latest SDK documentation, please use the project [Wiki](http://github.com/affinitiz/facebook-cf-sdk/wiki) section on GitHub.

# Downloads

To download the latest version of the SDK, please use the project [Downloads](http://github.com/affinitiz/facebook-cf-sdk/downloads) section on GitHub.

# Bugs

To report any bug, please use the project [Issues](http://github.com/affinitiz/facebook-cf-sdk/issues) section on GitHub.

# Beta status

This is a **beta release**.
In order to guide the development of the library, we have open-sourced the library. 
The underlying APIs are generally stable, however we may make changes to the library in response to developer feedback.

# Feedback

The **Facebook ColdFusion SDK** is not an official Facebook SDK such as [Javascript](http://developers.facebook.com/docs/reference/javascript/), [PHP](http://github.com/facebook/php-sdk), [Python](http://github.com/facebook/python-sdk/), [iOS](http://github.com/facebook/facebook-ios-sdk/) and [Android SDKs](http://github.com/facebook/facebook-android-sdk).

It is developped by [Affinitiz](http://poweredby.affinitiz.com), a french social media web agency.

The Facebook ColdFusion SDK is licensed under the [Apache Licence, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

*Credits: logo based on ColdFusion Wallpaper - Revolution by [Angry Fly](http://angry-fly.com/).*
