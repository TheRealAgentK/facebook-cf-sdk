<!---
  * Copyright 2010 Affinitiz, Inc.
  * Title: Facebook Coldfusion SDK home
  * Author: Benoit Hediard (hediard@affinitiz.com)
  *
  * Licensed under the Apache License, Version 2.0 (the "License"); you may
  * not use this file except in compliance with the License. You may obtain
  * a copy of the License at
  * 
  *  http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
  * License for the specific language governing permissions and limitations
  * under the License.
  *
--->
<html xmlns:og="http://opengraphprotocol.org/schema/">
	<head>
		<title>Facebook ColdFusion SDK</title>
		<meta name="title" content="Facebook ColdFusion SDK" />
		<meta name="description" content="Open source Facebook ColdFusion SDK that allows you to integrate the Facebook Platform on a website powered by a ColdFusion application server." />
		<meta name="keywords" content="facebook, coldFusion, sdk, open source, graph api, open graph protocol, affinitiz" />
		<meta property="og:title" content="Facebook ColdFusion SDK"/>
	    <meta property="og:type" content="website"/>
	    <meta property="og:url" content="http://affinitiz.com/facebook-cf-sdk/"/>
	    <meta property="og:image" content="http://affinitiz.com/facebook-cf-sdk/images/coldfusion-sdk-320x320.png"/>
		<meta property="og:site_name" content="affinitiz"/>
	    <meta property="fb:admins" content="594317994"/>
	    <meta property="fb:app_id" content="149805085052762"/>
	    <link rel="stylesheet" type="text/css" href="examples/website/website.css" />
	</head>
	<body>
		<div class="menu">
			<div class="content">
				<a href="##" class="l">Accueil</a>
				<a href="examples/website" class="l">Example</a>
				<div class="logo">
					<img src="images/coldfusion-sdk-50x50.png" height="50" width="50" style="float:right" />
					<span>Facebook ColdFusion SDK</span>
				</div>
				<div class="clear"></div>
			</div>
		</div>
		<div class="header">
			<div class="content">
				<h1>Facebook ColdFusion SDK - V3.1.1</h1>
			</div>
		</div>
		<div class="body washbody example">
			<div class="content">
				<iframe class="right" style="height:590px" src="http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fapps%2Fapplication.php%3Fid%3D149805085052762&amp;width=292&amp;connections=10&amp;stream=true&amp;header=true&amp;height=587" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:292px; height:587px;" allowTransparency="true"></iframe>
				<div style="min-height:560px;">
					<h2>Introduction</h2>
					<p>
						<img src="images/facebook-platform-logo.jpg" class="left" height="100" width="100" />
						The <a href="http://developers.facebook.com/">Facebook Platform</a> is a set of APIs that make your application more social. Read more about <a href="http://developers.facebook.com/docs/guides/web">integrating Facebook with your web site</a> on the Facebook developer site.<br />
						<br />
						This project contains the open source <b>Facebook ColdFusion SDK</b> that allows you to integrate the <a href="http://developers.facebook.com/">Facebook Platform</a> on a website powered by a <a href="http://www.adobe.com/products/coldfusion/">ColdFusion application server</a>.
					</p>
					<p>
						<b>Facebook ColdFusion SDK</b> provides 3 components :
						<ul>
							<li><b>FacebookApp.cfc</b> - A library to build apps on Facebook.com and social websites with Facebook Connect (the library is a complete port to ColdFusion of Facebook PHP SDK V3.1.1).</li>
							<li><b>FacebookGraphAPI.cfc</b> - A client wrapper to call Facebook Graph API (the wrapper is inspired from the latest official .NET and Python SDKs graph clients).</li>
							<li><b>FacebookRestAPI.cfc</b> - A client wrapper to call the old Facebook Rest API.</li>
						</ul>
					</p>
				</div>
				<hr />
				<h2>Migration</h2>
				<p>
					As explained in <a href="http://developers.facebook.com/roadmap/">Facebook Platform Roadmap</a>, by <b>October 1, 2011</b>:
					<ul>
						<li>all Website and Canvas apps must exclusively support <a href="http://tools.ietf.org/html/draft-ietf-oauth-v2-20" target="_blank">OAuth 2.0 (draft 20)</a></li>
						<li>all Canvas Apps must use the <code>signed_request</code> parameter</li>
						<li>an <b>SSL Certificate</b> is required for all Canvas and Page Tab apps (not in Sandbox mode)</li>
						<li>old, previous versions of our SDKs will <b>stop working</b>, including the old JavaScript SDK, old iOS SDK</li>
					</ul>
				</p>
				<p>
					<span style="color:red;font-weight:bold;">Previous Facebook ColdFusion SDK (V2.*) will stop working so you MUST upgrade to V3 by October 1, 2011.</span><br />
				</p>
				<p>
					Check SDK documentation to see <a href="http://github.com/affinitiz/facebook-cf-sdk/wiki/migration">How to migrate from SDK V2 to SDK V3</a>
				</p>
				<hr />
				<h2>Documentation</h2>
				<p>
					To view the latest SDK documentation, please use the project <a href="http://github.com/affinitiz/facebook-cf-sdk/wiki">Wiki</a> section on <b>GitHub</b></a>.
				</p>
				<hr />
				<h2>Downloads</h2>
				<p>
					To download the latest version of the SDK, please use the project <a href="http://github.com/affinitiz/facebook-cf-sdk/downloads">Downloads</a> section on <b>GitHub</b>.
				</p>
				<hr />
				<h2>Bugs</h2>
				<p>
					To report any bug, please use the project <a href="http://github.com/affinitiz/facebook-cf-sdk/issues">Issues</a> section on <b>GitHub</b>.
				</p>
				<hr />
				<h2>Beta status</h2>
				<p>
					This is a <b>beta release</b>.
					In order to guide the development of the library, we have open-sourced the library. 
					The underlying APIs are generally stable, however we may make changes to the library in response to developer feedback.
				</p>
				<hr />
				<h2>Disclaimer</h2>
				<p>
					The <b>Facebook ColdFusion SDK</b> is not an official Facebook SDK such as Javascript, PHP, Python, iOS and Android SDKs.<br />
					It is developped by <a href="http://poweredby.affinitiz.com">Affinitiz</a>, a french social media web agency.<br />
				</p>
				<p>
					The <b>Facebook ColdFusion SDK</b> is licensed under the <a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache Licence, Version 2.0</a>.
				</p>
				<p>
					<i>Credits: logo based on ColdFusion Wallpaper - Revolution by <a href="http://angry-fly.com">Angry Fly</a>.</i>
				</p>
			</div>
		</div>
		<div class="footer">
			<div class="content">
				<a href="http://github.com/affinitiz/facebook-cf-sdk">Facebook ColdFusion SDK</a> - Open source project by <a href="http://poweredby.affinitiz.com">Affinitiz</a> - 
				<a href="http://www.apache.org/licenses/LICENSE-2.0">Licensed under the Apache License, Version 2.0</a><br />
			</div>
		</div>
	</body>
</html>