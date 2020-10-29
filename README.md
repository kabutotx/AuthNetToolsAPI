# ColdFusion Authorize.net API CFC

This is a ColdFusion CFC used to connect to the Authorize.net XML API. It is updated from AuthNetTools 1.2 by Bud Schneehagen to support the new Authorize.net API, instead of AIM, and some new functions. It closely follows the Python examples.

Thanks to Bud Schneehagen for the donation of his existing CIM/ARB code!

## API's Supported:
 * Payment Transactions API
 * Customer Profiles (CIM)
 * Recurring Billing (ARB)
 * Accept Suite

## Requirements
* ACF 10+
* Lucee 4.5 (must install api or apitest.authorize.net SSL Certificates)
* Lucee 5+

To authenticate with the Authorize.Net API, use your account's API Login ID and Transaction Key. If you don't have these credentials, obtain them from the Merchant Interface. For production accounts, the Merchant Interface is located at (https://account.authorize.net/), and for sandbox accounts, at (https://sandbox.authorize.net).

## Initialization

This is a straight forward CFC. You can initialize it using your preferred method. Here are a few examples. The named arguments are listed for clarity but you can also pass the values in by themselves.
NOTE: You may also pass in your APi Login ID and Transaction Key as an argument instead of the init below.

**CreateObject()**

	variables.apiLoginId = 'YourIdHere';
	variables.transactionKey = 'YourKeyHere';
	variables.AuthNetTools = CreateObject('component', 'AuthNetToolsAPI').init(developmentServer=false, name=variables.apiLoginI, [transactionKey=variables.transactionKey);

**New Keyword**

	variables.apiLoginId = 'YourIdHere';
	variables.transactionKey = 'YourKeyHere';
	variables.AuthNetTools = New AuthNetToolsAPI(developmentServer=false, name=variables.apiLoginId, transactionKey=variables.transactionKey);

## Sample Usage

Here's an example in cfscript. See examples directory

	<cfscript>
	apiLoginId = "";
	transactionKey = "";
	
	// Authorize Credit Card
	authArgs = structNew();
	// Optional name and transactionKey here instead of New/CreateObject init
	// authArgs.merchantAuthentication.name=authName;
	// authArgs.merchantAuthentication.transactionKey=authKey;
	authArgs.transactionRequest.payment.creditCard.cardNumber = "4111111111111111";
	authArgs.transactionRequest.payment.creditCard.expirationDate = "2022-12";
	authArgs.transactionrequest.transactionType = "authCaptureTransaction"; // "authOnlyTransaction" for Authorize only
	authArgs.transactionrequest.amount = "11.52";
	authArgs.transactionrequest.billTo.address= "14 Main Street";
	authArgs.transactionrequest.billTo.zip= "44628";
	authArgs.transactionrequest.order.invoiceNumber = "10101";
	
	AuthNetTools =  new AuthNetToolsAPI(1, apiLoginId, transactionKey);
	AuthResp = AuthNetTools.authPaymentXML(authArgs);
	writeDump(var=AuthResp);
	</cfscript>

## Main Response variables

* response_code: 1 = success, 2 = error/declined, 3 = API call failure
* error: blank if success. API error text if response_code >= 2
* errorcode: "0" if success. API error code if response >= 2
* XMLREQUEST: xmlParse() of API request.
* XMLRESPONSE: xmlParse() of API Reponse.

## Files Included

**AuthNetToolsAPI.cfc**

Main code.

**examples/AuthTest.cfm**

Example Charge a Credit Card file that follow Python examples. This file has them preconfigured and ready to go. Plug in your Authorize.net ID and key to run it.

**examples/AuthTestSimple.cfm**

More compact example to authorize, charge, void, etc. Cut and paste the section you want to test to your own file.

**examples/cimtest.cfm**

Customer Profile (CIM) examples. Cut and paste the section you want to test to your own file.

**examples/arbtest.cfm**

Recurring Billing (ARB) examples. Cut and paste the section you want to test to your own file.

**examples/AcceptHosted.cfm**

Accept Hosted Payment examples. Plug in your Authorize.net ID and key to run it.


## License

    Copyright © Robert Davis

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
