/*
File: AuthNetToolsAPI.cfc

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
*/

/*
AuthNetToolsAPI.cfc 0.98.6 from AuthNetTools 1.2
Author: Robert Davis; kabutotx@gmail.com (Payment API)
Author: Bud Schneehagen (CIM/ARB code)
*/

component displayName="AuthNetToolsAPI" hint="Authorize.net credit card processing" {

public AuthNetToolsAPI function init(
	boolean developmentServer="false",
	string name="",
	string transactionKey="") {

	variables.defaultXmlFormat = "true"; /* If you are already encoding your input arguments with xmlformat, set this to false. This can be set at each method also. */
	if ( arguments.developmentServer ) {
		 /* Sandbox API server. use with a developers account only. use with testrequest false for best results */
		variables.url_API = "https://apitest.authorize.net/xml/v1/request.api";
		variables.name = arguments.name; /* may be passed in as an argument to the init method, or entered manually here, or passed in as an argument with each individual method to overwrite what is entered here. */
		variables.transactionKey = arguments.transactionKey; /* may be passed in as an argument to the init method, or entered manually here, or passed in as an argument with each individual method to overwrite what is entered here. */
		variables.ADC_Delim_Character = "|"; /* must match Direct Response setting in authorize.net settings. May be passed in as an argument if necessary but there MUST be a delimiter. */
		variables.Encapsulate_Character = '"'; /* must match Direct Response setting in authorize.net settings. May be passed in as an argument if necessary but there MUST be an encapsulation character. */
		variables.parseValidationResult = false; /* These is no way to set the delimiter and encapsulation on validation requests when creating profiles. So an error will be thrown if the values above differ from the default values. If you need to parse the direct response strings when validating, set this to true and be sure the settings are the same in the authorize.net console. */
		variables.environment = "Development";
	} else {
		 /* Production API server. use with testrequest true during testing and false to go live */
		variables.url_API = "https://api.authorize.net/xml/v1/request.api";
		//Akami: variables.url_API = "https://api2.authorize.net/xml/v1/request.api";
		variables.name = arguments.name; /* may be passed in as an argument to the init method, or entered manually here, or passed in as an argument with each individual method to overwrite what is entered here. */
		variables.transactionKey = arguments.transactionKey; /* may be passed in as an argument to the init method, or entered manually here, or passed in as an argument with each individual method to overwrite what is entered here. */
		variables.ADC_Delim_Character = "|"; /* must match Direct Response setting in authorize.net settings. May be passed in as an argument if necessary but there MUST be a delimiter. */
		variables.Encapsulate_Character = '"'; /* must match Direct Response setting in authorize.net settings. May be passed in as an argument if necessary but there MUST be an encapsulation character. */
		variables.parseValidationResult = false; /* These is no way to set the delimiter and encapsulation on validation requests when creating profiles. So an error will be thrown if the values above differ from the default values. If you need to parse the direct response strings when validating, set this to true and be sure the settings are the same in the authorize.net console. */
		variables.environment = "Production";
	}
	return ( this );
} // end function init()

public struct function authPaymentXML(struct authArgs, boolean useXmlFormat=variables.defaultXmlFormat) {
	savecontent variable="myXML" {
	writeOutput("<?xml version=""1.0"" encoding=""UTF-8""?>");
	writeOutput("<createTransactionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">");
	// merchantAuthentication
	writeOutput("<merchantAuthentication>");
	if (isDefined("authArgs.merchantAuthentication.name")) {
		writeOutput("<name>#authArgs.merchantAuthentication.name#</name>");
	} else {
		writeOutput("<name>#variables.name#</name>");
	}
	if (isDefined("authArgs.merchantAuthentication.transactionKey")) {
		writeOutput("<transactionKey>#authArgs.merchantAuthentication.transactionKey#</transactionKey>");
	} else {
		writeOutput("<transactionKey>#variables.transactionKey#</transactionKey>");
	}
	writeOutput("</merchantAuthentication>");
	// refId
	if (isDefined("authArgs.refId")) {
		writeOutput("<refId>#authArgs.refId#</refId>");
	}
	// transactionRequest
	if (isDefined("authArgs.transactionRequest")) {
		writeOutput("<transactionRequest>");
		// transactionType
		if (isDefined("authArgs.transactionrequest.transactionType")) {
			writeOutput("<transactionType>#authArgs.transactionrequest.transactionType#</transactionType>");
		}
		// Amount
		if (isDefined("authArgs.transactionrequest.amount")) {
			writeOutput("<amount>#authArgs.transactionrequest.amount#</amount>");
		}
		// Payment
		if (isDefined("authArgs.transactionrequest.payment")) {
			writeOutput("<payment>");
			// Payment - Credit Card
			if (isDefined("authArgs.transactionrequest.payment.creditCard")) {
				writeOutput("<creditCard>");
				if (isDefined("authArgs.transactionrequest.payment.creditCard.cardNumber")) {
					writeOutput("<cardNumber>#authArgs.transactionrequest.payment.creditCard.cardNumber#</cardNumber>");
				}
				if (isDefined("authArgs.transactionrequest.payment.creditCard.expirationDate")) {
					writeOutput("<expirationDate>#authArgs.transactionrequest.payment.creditCard.expirationDate#</expirationDate>");
				}
				if (isDefined("authArgs.transactionrequest.payment.creditCard.cardCode")) {
					writeOutput("<cardCode>#authArgs.transactionrequest.payment.creditCard.cardCode#</cardCode>");
				}
				// Tokenized
				if (isDefined("authArgs.transactionrequest.payment.creditCard.isPaymentToken")) {
					writeOutput("<isPaymentToken>#authArgs.transactionrequest.payment.creditCard.isPaymentToken#</isPaymentToken>");
				}
				if (isDefined("authArgs.transactionrequest.payment.creditCard.cryptogram")) {
					writeOutput("<cryptogram>#authArgs.transactionrequest.payment.creditCard.cryptogram#</cryptogram>");
				}
				// Chase
				if (isDefined("authArgs.transactionrequest.payment.creditCard.tokenRequestorName")) {
					writeOutput("<tokenRequestorName>#authArgs.transactionrequest.payment.creditCard.tokenRequestorName#</tokenRequestorName>");
				}
				if (isDefined("authArgs.transactionrequest.payment.creditCard.tokenRequestorId")) {
					writeOutput("<tokenRequestorId>#authArgs.transactionrequest.payment.creditCard.tokenRequestorId#</tokenRequestorId>");
				}
				if (isDefined("authArgs.transactionrequest.payment.creditCard.tokenRequestorEci")) {
					writeOutput("<tokenRequestorEci>#authArgs.transactionrequest.payment.creditCard.tokenRequestorEci#</tokenRequestorEci>");
				}
				writeOutput("</creditCard>");
			}
			// Payment - PayPal Express
			if (isDefined("authArgs.transactionrequest.payment.payPal")) {
				writeOutput("<payPal>");
				if (isDefined("authArgs.transactionrequest.payment.payPal.payerID")) {
					writeOutput("<payerID>#authArgs.transactionrequest.payment.payPal.payerID#</payerID>");
				}
				if (isDefined("authArgs.transactionrequest.payment.payPal.successUrl")) {
					writeOutput("<successUrl>#authArgs.transactionrequest.payment.payPal.successUrl#</successUrl>");
				}
				if (isDefined("authArgs.transactionrequest.payment.payPal.cancelUrl")) {
					writeOutput("<cancelUrl>#authArgs.transactionrequest.payment.payPal.cancelUrl#</cancelUrl>");
				}
				if (isDefined("authArgs.transactionrequest.payment.payPal.paypalLc")) {
					writeOutput("<paypalLc>#authArgs.transactionrequest.payment.payPal.paypalLc#</paypalLc>");
				}
				if (isDefined("authArgs.transactionrequest.payment.payPal.paypalHdrImg")) {
					writeOutput("<paypalHdrImg>#myXMLFormat(authArgs.transactionrequest.payment.payPal.paypalHdrImg, arguments.useXmlFormat)#</paypalHdrImg>");
				}
				if (isDefined("authArgs.transactionrequest.payment.payPal.paypalPayflowcolor")) {
					writeOutput("<paypalPayflowcolor>#authArgs.transactionrequest.payment.payPal.paypalPayflowcolor#</paypalPayflowcolor>");
				}
				writeOutput("</payPal>");
			}
			// Payment - Bank Account
			if (isDefined("authArgs.transactionrequest.payment.bankAccount")) {
				writeOutput("<bankAccount>");
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.accountType")) {
					writeOutput("<accountType>#authArgs.transactionrequest.payment.bankAccount.accountType#</accountType>");
				}
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.routingNumber")) {
					writeOutput("<routingNumber>#authArgs.transactionrequest.payment.bankAccount.routingNumber#</routingNumber>");
				}
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.accountNumber")) {
					writeOutput("<accountNumber>#authArgs.transactionrequest.payment.bankAccount.accountNumber#</accountNumber>");
				}
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.nameOnAccount")) {
					writeOutput("<nameOnAccount>#myXMLFormat(authArgs.transactionrequest.payment.bankAccount.nameOnAccount, arguments.useXmlFormat)#</nameOnAccount>");
				}
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.echeckType")) {
					writeOutput("<echeckType>#authArgs.transactionrequest.payment.bankAccount.echeckType#</echeckType>");
				}
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.bankName")) {
					writeOutput("<bankName>#myXMLFormat(authArgs.transactionrequest.payment.bankAccount.bankName, arguments.useXmlFormat)#</bankName>");
				}
				if (isDefined("authArgs.transactionrequest.payment.bankAccount.checkNumber")) {
					writeOutput("<checkNumber>#authArgs.transactionrequest.payment.bankAccount.checkNumber#</checkNumber>");
				}
				writeOutput("</bankAccount>");
			}
			// Payment - Accept Nonce/Visa Checkout
			if (isDefined("authArgs.transactionrequest.payment.opaqueData")) {
				writeOutput("<opaqueData>");
				if (isDefined("authArgs.transactionrequest.payment.opaqueData.dataDescriptor")) {
					writeOutput("<dataDescriptor>#authArgs.transactionrequest.payment.opaqueData.dataDescriptor#</dataDescriptor>");
				}
				if (isDefined("authArgs.transactionrequest.payment.opaqueData.dataValue")) {
					writeOutput("<dataValue>#authArgs.transactionrequest.payment.opaqueData.dataValue#</dataValue>");
				}
				if (isDefined("authArgs.transactionrequest.payment.opaqueData.dataKey")) {
					writeOutput("<dataKey>#authArgs.transactionrequest.payment.opaqueData.dataKey#</dataKey>");
				}
				writeOutput("</opaqueData>");
			}
			writeOutput("</payment>");
		}
		// Profile
		if (isDefined("authArgs.transactionrequest.profile")) {
			writeOutput("<profile>");
				if (isDefined("authArgs.transactionrequest.profile.createProfile")) {
					writeOutput("<createProfile>#authArgs.transactionrequest.profile.createProfile#</createProfile>");
				}
				if (isDefined("authArgs.transactionrequest.profile.customerProfileId")) {
					writeOutput("<customerProfileId>#authArgs.transactionrequest.profile.customerProfileId#</customerProfileId>");
				}
				if (isDefined("authArgs.transactionrequest.profile.paymentProfile")) {
					writeOutput("<paymentProfile>");
					if (isDefined("authArgs.transactionrequest.profile.paymentProfile.paymentProfileId")) {
						writeOutput("<paymentProfileId>#authArgs.transactionrequest.profile.paymentProfile.paymentProfileId#</paymentProfileId>");
					}
					if (isDefined("authArgs.transactionrequest.profile.paymentProfile.cardCode")) {
						writeOutput("<cardCode>#authArgs.transactionrequest.profile.paymentProfile.cardCode#</cardCode>");
					}
					writeOutput("</paymentProfile>");
				}
				if (isDefined("authArgs.transactionrequest.profile.shippingProfileId")) {
					writeOutput("<shippingProfileId>#authArgs.transactionrequest.profile.shippingProfileId#</shippingProfileId>");
				}
			writeOutput("</profile>");
		}
		// Authorization Code
		if (isDefined("authArgs.transactionrequest.authCode")) {
			writeOutput("<authCode>#authArgs.transactionrequest.authCode#</authCode>");
		}
		// Solution ID
		if (isDefined("authArgs.transactionrequest.solution")) {
			writeOutput("solution>");
				if (isDefined("authArgs.transactionrequest.solution.id")) {
					writeOutput("<id>#authArgs.transactionrequest.solution.id#</id>");
				}
				if (isDefined("authArgs.transactionrequest.solution.name")) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.solution.name, arguments.useXmlFormat)#</name>");
				}
			writeOutput("</solution>");
		}
		// POS Terminal Number
		if (isDefined("authArgs.transactionrequest.terminalNumber")) {
			writeOutput("<terminalNumber>#authArgs.transactionrequest.terminalNumber#</terminalNumber>");
		}
		// Reference Transaction ID
		if (isDefined("authArgs.transactionrequest.refTransId")) {
			writeOutput("<refTransId>#authArgs.transactionrequest.refTransId#</refTransId>");
		}
		// Order
		if (isDefined("authArgs.transactionrequest.order")) {
			writeOutput("<order>");
				if (isDefined("authArgs.transactionrequest.order.invoiceNumber")) {
					writeOutput("<invoiceNumber>#myXMLFormat(authArgs.transactionrequest.order.invoiceNumber, arguments.useXmlFormat)#</invoiceNumber>");
				}
				if (isDefined("authArgs.transactionrequest.order.description")) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.order.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</order>");
		}
		// Visa Transaction ID
		if (isDefined("authArgs.transactionrequest.callId")) {
			writeOutput("<callId>#authArgs.transactionrequest.callId#</callId>");
		}
		// Line Item(s)
		if (isDefined("authArgs.transactionrequest.lineItems")) {
			writeOutput("<lineItems>");
				for (i = 1; i <= arrayLen(authArgs.transactionrequest.lineItems.lineItem); i++) {
					writeOutput("<lineItem>");
					if (isDefined("authArgs.transactionrequest.lineItems.lineItem[i].itemId")) {
						writeOutput("<itemId>#myXMLFormat(authArgs.transactionrequest.lineItems.lineItem[i].itemId, arguments.useXmlFormat)#</itemId>");
					}
					if (isDefined("authArgs.transactionrequest.lineItems.lineItem[i].name")) {
						writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.lineItems.lineItem[i].name, arguments.useXmlFormat)#</name>");
					}
					if (isDefined("authArgs.transactionrequest.lineItems.lineItem[i].description")) {
						writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.lineItems.lineItem[i].description, arguments.useXmlFormat)#</description>");
					}
					if (isDefined("authArgs.transactionrequest.lineItems.lineItem[i].quantity")) {
						writeOutput("<quantity>#authArgs.transactionrequest.lineItems.lineItem[i].quantity#</quantity>");
					}
					if (isDefined("authArgs.transactionrequest.lineItems.lineItem[i].unitPrice")) {
						writeOutput("<unitPrice>#authArgs.transactionrequest.lineItems.lineItem[i].unitPrice#</unitPrice>");
					}
					writeOutput("</lineItem>");
				}
			writeOutput("</lineItems>");
		}
		// Tax
		if (isDefined("authArgs.transactionrequest.tax")) {
			writeOutput("<tax>");
				if (isDefined("authArgs.transactionrequest.tax.amount")) {
					writeOutput("<amount>#authArgs.transactionrequest.tax.amount#</amount>");
				}
				if (isDefined("authArgs.transactionrequest.tax.name")) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.tax.name, arguments.useXmlFormat)#</name>");
				}
				if (isDefined("authArgs.transactionrequest.tax.description")) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.tax.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</tax>");
		}
		// Duty
		if (isDefined("authArgs.transactionrequest.duty")) {
			writeOutput("<duty>");
				if (isDefined("authArgs.transactionrequest.duty.amount")) {
					writeOutput("<amount>#authArgs.transactionrequest.duty.amount#</amount>");
				}
				if (isDefined("authArgs.transactionrequest.duty.name")) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.duty.name, arguments.useXmlFormat)#</name>");
				}
				if (isDefined("authArgs.transactionrequest.duty.description")) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.duty.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</duty>");
		}
		// Shipping Charges
		if (isDefined("authArgs.transactionrequest.shipping")) {
			writeOutput("<shipping>");
				if (isDefined("authArgs.transactionrequest.shipping.amount")) {
					writeOutput("<amount>#authArgs.transactionrequest.shipping.amount#</amount>");
				}
				if (isDefined("authArgs.transactionrequest.shipping.name")) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.shipping.name, arguments.useXmlFormat)#</name>");
				}
				if (isDefined("authArgs.transactionrequest.shipping.description")) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.shipping.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</shipping>");
		}
		// TaxExempt
		if (isDefined("authArgs.transactionrequest.taxExempt")) {
			writeOutput("<taxExempt>#authArgs.transactionrequest.taxExempt#</taxExempt>");
		}
		// PO Number
		if (isDefined("authArgs.transactionrequest.poNumber")) {
			writeOutput("<poNumber>#authArgs.transactionrequest.poNumber#</poNumber>");
		}
		// Customer
		if (isDefined("authArgs.transactionrequest.customer")) {
			writeOutput("<customer>");
				if (isDefined("authArgs.transactionrequest.customer.type")) {
					writeOutput("<type>#authArgs.transactionrequest.customer.type#</type>");
				}
				if (isDefined("authArgs.transactionrequest.customer.id")) {
					writeOutput("<id>#authArgs.transactionrequest.customer.id#</id>");
				}
				if (isDefined("authArgs.transactionrequest.customer.email")) {
					writeOutput("<email>#authArgs.transactionrequest.customer.email#</email>");
				}
			writeOutput("</customer>");
		}
		// Bill to
		if (isDefined("authArgs.transactionrequest.billTo")) {
			writeOutput("<billTo>");
				if (isDefined("authArgs.transactionrequest.billTo.firstName")) {
					writeOutput("<firstName>#myXMLFormat(authArgs.transactionrequest.billTo.firstName, arguments.useXmlFormat)#</firstName>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.lastName")) {
					writeOutput("<lastName>#myXMLFormat(authArgs.transactionrequest.billTo.lastName, arguments.useXmlFormat)#</lastName>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.company")) {
					writeOutput("<company>#myXMLFormat(authArgs.transactionrequest.billTo.company, arguments.useXmlFormat)#</company>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.address")) {
					writeOutput("<address>#myXMLFormat(authArgs.transactionrequest.billTo.address, arguments.useXmlFormat)#</address>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.city")) {
					writeOutput("<city>#myXMLFormat(authArgs.transactionrequest.billTo.city, arguments.useXmlFormat)#</city>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.state")) {
					writeOutput("<state>#authArgs.transactionrequest.billTo.state#</state>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.zip")) {
					writeOutput("<zip>#myXMLFormat(authArgs.transactionrequest.billTo.zip, arguments.useXmlFormat)#</zip>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.country")) {
					writeOutput("<country>#myXMLFormat(authArgs.transactionrequest.billTo.country, arguments.useXmlFormat)#</country>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.phoneNumber")) {
					writeOutput("<phoneNumber>#rereplace(authArgs.transactionrequest.billTo.phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>");
				}
				if (isDefined("authArgs.transactionrequest.billTo.faxNumber")) {
					writeOutput("<faxNumber>#rereplace(authArgs.transactionrequest.billTo.faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>");
				}
			writeOutput("</billTo>");
		}
		// Ship to
		if (isDefined("authArgs.transactionrequest.shipTo")) {
			writeOutput("<shipTo>");
				if (isDefined("authArgs.transactionrequest.shipTo.firstName")) {
					writeOutput("<firstName>#myXMLFormat(authArgs.transactionrequest.shipTo.firstName, arguments.useXmlFormat)#</firstName>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.lastName")) {
					writeOutput("<lastName>#myXMLFormat(authArgs.transactionrequest.shipTo.lastName, arguments.useXmlFormat)#</lastName>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.company")) {
					writeOutput("<company>#myXMLFormat(authArgs.transactionrequest.shipTo.company, arguments.useXmlFormat)#</company>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.address")) {
					writeOutput("<address>#myXMLFormat(authArgs.transactionrequest.shipTo.address, arguments.useXmlFormat)#</address>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.city")) {
					writeOutput("<city>#myXMLFormat(authArgs.transactionrequest.shipTo.city, arguments.useXmlFormat)#</city>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.state")) {
					writeOutput("<state>#authArgs.transactionrequest.shipTo.state#</state>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.zip")) {
					writeOutput("<zip>#myXMLFormat(authArgs.transactionrequest.shipTo.zip, arguments.useXmlFormat)#</zip>");
				}
				if (isDefined("authArgs.transactionrequest.shipTo.country")) {
					writeOutput("<country>#myXMLFormat(authArgs.transactionrequest.shipTo.country, arguments.useXmlFormat)#</country>");
				}
			writeOutput("</shipTo>");
		}
		// Customer IP
		if (isDefined("authArgs.transactionrequest.customerIP")) {
			writeOutput("<customerIP>#authArgs.transactionrequest.customerIP#</customerIP>");
		}
		// 3D Secure
		if (isDefined("authArgs.transactionrequest.cardholderAuthentication")) {
			writeOutput("<cardholderAuthentication>");
				if (isDefined("authArgs.transactionrequest.cardholderAuthentication.authenticationIndicator")) {
					writeOutput("<authenticationIndicator>#authArgs.transactionrequest.cardholderAuthentication.authenticationIndicator#</authenticationIndicator>");
				}
				if (isDefined("authArgs.transactionrequest.cardholderAuthentication.cardholderAuthenticationValue")) {
					writeOutput("<cardholderAuthenticationValue>#authArgs.transactionrequest.cardholderAuthentication.cardholderAuthenticationValue#</cardholderAuthenticationValue>");
				}
			writeOutput("</cardholderAuthentication>");
		}
		// Retail
		if (isDefined("authArgs.transactionrequest.retail")) {
			writeOutput("<retail>");
				if (isDefined("authArgs.transactionrequest.retail.marketType")) {
					writeOutput("<marketType>#authArgs.transactionrequest.retail.marketType#</marketType>");
				}
				if (isDefined("authArgs.transactionrequest.retail.deviceType")) {
					writeOutput("<deviceType>#authArgs.transactionrequest.retail.deviceType#</deviceType>");
				}
			writeOutput("</retail>");
		}
		// Employee ID
		if (isDefined("authArgs.transactionrequest.employeeId")) {
			writeOutput("<employeeId>#authArgs.transactionrequest.employeeId#</employeeId>");
		}
		// Transaction Settings
		if (isDefined("authArgs.transactionrequest.transactionSettings")) {
			writeOutput("<transactionSettings>");
				for (i = 1; i <= arrayLen(authArgs.transactionrequest.transactionSettings.setting); i++) {
					writeOutput("<setting>");
					if (isDefined("authArgs.transactionrequest.transactionSettings.setting[i].settingName")) {
						writeOutput("<settingName>#authArgs.transactionrequest.transactionSettings.setting[i].settingName#</settingName>");
					}
					if (isDefined("authArgs.transactionrequest.transactionSettings.setting[i].settingValue")) {
						writeOutput("<settingValue>#authArgs.transactionrequest.transactionSettings.setting[i].settingValue#</settingValue>");
					}
					writeOutput("</setting>");
				}
			writeOutput("</transactionSettings>");
		}
		// User Field
		if (isDefined("authArgs.transactionrequest.userFields")) {
			writeOutput("<userFields>");
				for (i = 1; i <= arrayLen(authArgs.transactionrequest.userFields.userField); i++) {
					writeOutput("<userField>");
					if (isDefined("authArgs.transactionrequest.userFields.userField[i].name")) {
						writeOutput("<name>#authArgs.transactionrequest.userFields.userField[i].name#</name>");
					}
					if (isDefined("authArgs.transactionrequest.userFields.userField[i].value")) {
						writeOutput("<value>#authArgs.transactionrequest.userFields.userField[i].value#</value>");
					}
					writeOutput("</userField>");
				}
			writeOutput("</userFields>");
		}
		// Surcharge
		if (isDefined("authArgs.transactionrequest.surcharge")) {
			writeOutput("<surcharge>");
				if (isDefined("authArgs.transactionrequest.surcharge.amount")) {
					writeOutput("<amount>#authArgs.transactionrequest.surcharge.amount#</amount>");
				}
				if (isDefined("authArgs.transactionrequest.surcharge.description")) {
					writeOutput("<description>#authArgs.transactionrequest.surcharge.description#</description>");
				}
			writeOutput("</surcharge>");
		}
		// Tip
		if (isDefined("authArgs.transactionrequest.tip")) {
			writeOutput("<tip>#authArgs.transactionrequest.tip#</tip>");
		}
		writeOutput("</transactionRequest>");
	}
	writeOutput("</createTransactionRequest>");
	}

	// Defaults
	response.response_code = 1;
	response.error = "";
	response.errorcode = "";
	response.avs_code="";
	response.card_code_response="";
	response.cavv_response="";
	response.environment = variables.environment;

	response.XmlRequest = xmlParse(myXml);
	
	// Check if API request successfully received
	response = getAPIResponse(response);
	if ( response.errorcode lt 3 ) {
		// Successesful call
		if (isDefined('response.XmlResponse.createTransactionResponse.transactionResponse.transId')) {
			response.trans_id = response.XmlResponse.createTransactionResponse.transactionResponse.transId.XmlText;
		}
		if (isDefined('response.XmlResponse.createTransactionResponse.transactionResponse.avsResultCode')) {
			response.avs_code = response.XmlResponse.createTransactionResponse.transactionResponse.avsResultCode.XmlText;
		}
		if (isDefined('response.XmlResponse.createTransactionResponse.transactionResponse.cvvResultCode')) {
			response.card_code_response = response.XmlResponse.createTransactionResponse.transactionResponse.cvvResultCode.XmlText;
		}
		if (isDefined('response.XmlResponse.createTransactionResponse.transactionResponse.cavvResultCode')) {
			response.cavv_response = response.XmlResponse.createTransactionResponse.transactionResponse.cavvResultCode.XmlText;
		}
	}
	param name="authArgs.error_email_from" default="";
	param name="authArgs.error_email_to" default="";
	param name="authArgs.error_subject" default="AutNetTools.cfc Error";
	param name="authArgs.error_smtp" default="";
	email.error_email_from=authArgs.error_email_from;
	email.error_email_to=authArgs.error_email_from;
	email.error_subject=authArgs.error_subject;
	email.error_smtp=authArgs.error_smtp;
	if (response.error is not "" and email.error_email_to is not "") {
		temp = emailError(a=email, r=response);
	}
	return response;
} // end function authPaymentXML()

public struct function parseResult(myString, arguments) {
	var response = StructNew();
	var temp	= "";

	response.error = "";
	response.errorcode = "0";
	response.environment = variables.environment;

	response.response_code = "3";
	response.Response_Subcode = "";
	response.reason_code = "";
	response.authorization_code = "";
	response.response_text = "";
	response.avs_code = "";
	response.trans_id = "";
	/* already have this from the input <cfset response.Invoice = "" /> */
	response.Description = "";
	response.Amount = "";
	response.Method = "";
	response.TransactionType = "";
	response.CustomerID = "";
	response.CardholderFirstName = "";
	response.CardholderLastName = "";
	response.Company = "";
	response.BillingAddress = "";
	response.City = "";
	response.State = "";
	response.Zip = "";
	response.Country = "";
	response.Phone = "";
	response.Fax = "";
	response.Email = "";
	response.ShiptoFirstName = "";
	response.ShiptoLastName = "";
	response.ShiptoCompany = "";
	response.ShiptoAddress = "";
	response.ShiptoCity = "";
	response.ShiptoState = "";
	response.ShiptoZip = "";
	response.ShiptoCountry = "";
	response.TaxAmount = "";
	response.DutyAmount = "";
	response.FreightAmount = "";
	response.TaxExemptFlag = "";
	response.PONumber = "";
	response.card_code_response = "";
	response.cavv_response = "";
	response.Hash = "";
	response.AccountNumber = "";
	response.CardType = "";
	response.SplitTenderID = "";
	response.RequestedAmount = "";
	response.BalanceOnCard = "";


try {

	if (ListLen(arguments.mystring, "#arguments.ADC_Delim_Character#") GTE 38 and Replace(ListGetAt(arguments.mystring, 1, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL') is not "") {
		if (not isDefined('arguments.MD5') or arguments.MD5 is "" or (arguments.MD5 is not "" and Replace(ListGetAt(arguments.mystring, 38, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL') is hash('#arguments.MD5##arguments.name##Replace(ListGetAt(arguments.mystring, 7, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL')##rereplace(decimalFormat(rereplace(arguments.amount, "[^0-9\.-]+", "", "ALL")), "[^0-9\.-]+", "", "ALL")#'))) {
			response.response_code = Replace(ListGetAt(arguments.mystring, 1, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.reason_code = Replace(ListGetAt(arguments.mystring, 3, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.response_text = Replace(ListGetAt(arguments.mystring, 4, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.authorization_code = Replace(ListGetAt(arguments.mystring, 5, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.avs_code = Replace(ListGetAt(arguments.mystring, 6, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.trans_id = Replace(ListGetAt(arguments.mystring, 7, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.card_code_response = Replace(ListGetAt(arguments.mystring, 39, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.cavv_response = Replace(ListGetAt(arguments.mystring, 40, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');

			/* I don't use any of the ones below within this file, but they are returned if you wish to use them elsewhere. */
			response.Response_Subcode = Replace(ListGetAt(arguments.mystring,  2, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			/* already have this from the input <cfset response.Invoice = Replace(ListGetAt(arguments.mystring,  8, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL')> */
			response.Description = Replace(ListGetAt(arguments.mystring,  9, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Amount = Replace(ListGetAt(arguments.mystring, 10, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Method = Replace(ListGetAt(arguments.mystring, 11, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.TransactionType = Replace(ListGetAt(arguments.mystring, 12, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.CustomerID = Replace(ListGetAt(arguments.mystring, 13, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.CardholderFirstName = Replace(ListGetAt(arguments.mystring, 14, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.CardholderLastName = Replace(ListGetAt(arguments.mystring, 15, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Company = Replace(ListGetAt(arguments.mystring, 16, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.BillingAddress = Replace(ListGetAt(arguments.mystring, 17, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.City = Replace(ListGetAt(arguments.mystring, 18, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.State = Replace(ListGetAt(arguments.mystring, 19, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Zip = Replace(ListGetAt(arguments.mystring, 20, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Country = Replace(ListGetAt(arguments.mystring, 21, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Phone = Replace(ListGetAt(arguments.mystring, 22, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Fax = Replace(ListGetAt(arguments.mystring, 23, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Email = Replace(ListGetAt(arguments.mystring, 24, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoFirstName = Replace(ListGetAt(arguments.mystring, 25, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoLastName = Replace(ListGetAt(arguments.mystring, 26, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoCompany = Replace(ListGetAt(arguments.mystring, 27, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoAddress = Replace(ListGetAt(arguments.mystring, 28, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoCity = Replace(ListGetAt(arguments.mystring, 29, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoState = Replace(ListGetAt(arguments.mystring, 30, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoZip = Replace(ListGetAt(arguments.mystring, 31, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.ShiptoCountry = Replace(ListGetAt(arguments.mystring, 32, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.TaxAmount = Replace(ListGetAt(arguments.mystring, 33, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.DutyAmount = Replace(ListGetAt(arguments.mystring, 34, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.FreightAmount = Replace(ListGetAt(arguments.mystring, 35, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.TaxExemptFlag = Replace(ListGetAt(arguments.mystring, 36, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.PONumber = Replace(ListGetAt(arguments.mystring, 37, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.Hash = Replace(ListGetAt(arguments.mystring, 37, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.AccountNumber = Replace(ListGetAt(arguments.mystring, 51, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.CardType = Replace(ListGetAt(arguments.mystring, 52, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.SplitTenderID = Replace(ListGetAt(arguments.mystring, 53, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.RequestedAmount = Replace(ListGetAt(arguments.mystring, 54, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
			response.BalanceOnCard = Replace(ListGetAt(arguments.mystring, 55, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
		} else {
			response.response_code = "3";
			response.reason_code = "0";
			response.response_text = "Invalid Hash. Please contact merchant.";
		}
	} else {
		response.response_code = "3";
		response.reason_code = "0";
		response.authorization_code = "";
		if (ListLen(arguments.mystring, "#arguments.ADC_Delim_Character#") GTE 4 and Replace(ListGetAt(arguments.mystring, 4, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL') is not "") {
			response.response_text = Replace(ListGetAt(arguments.mystring, 4, "#arguments.ADC_Delim_Character#"),'#arguments.Encapsulate_Character#','','ALL');
		} else if (arguments.mystring contains "Connection Failure") {
			response.response_text = "No Response From Processor.<br />Please wait 1 or 2 minutes and try again.";
		} else {
			response.response_text = "Invalid Response From Processor. Please check all fields and try again.";
		}
	}
	if (response.response_code GT 1 and response.reason_code is not 252 and response.reason_code is not 253) {
		response.error = response.response_text;
		response.errorcode = response.reason_code;
	}
} // end try
catch (any e) {
	if (e.detail is "") {
		response.error = "#e.message#";
	} else {
		response.error = "#e.message# - #e.detail#";
	}
} // end catch
if (response.error is not "" and arguments.error_email_to is not "") {
	temp = emailError(a=arguments, r=response);
}
return response;
} // end function parseResult()

public struct function createCustomerProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string ADC_Delim_Character="#variables.ADC_Delim_Character#",
	string Encapsulate_Character='#variables.Encapsulate_Character#',
	string merchantCustomerId="", // 2 out of 3 must have a value
	string customerdescription="",
	string email="",
	boolean testrequest="false",
	string customerType="",
	string cardNumber="",
	string expirationDate="", // YYYY-MM
	string cardCode="",
	string firstname="", // Up to 50 characters (no symbols)
	string lastname="", // Up to 50 characters (no symbols)
	string company="", // Up to 50 characters (no symbols)
	string address="", // Up to 60 characters (no symbols)
	string city="", // Up to 40 characters (no symbols)
	string state="", // A valid two-character state code
	string zip="", // Up to 20 characters (no symbols)
	string country="", // Up to 60 characters (no symbols)
	string phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string ship_firstname="", // Up to 50 characters (no symbols)
	string ship_lastname="", // Up to 50 characters (no symbols)
	string ship_company="", // Up to 50 characters (no symbols)
	string ship_address="", // Up to 60 characters (no symbols)
	string ship_city="", // Up to 40 characters (no symbols)
	string ship_state="", // A valid two-character state code
	string ship_zip="", // Up to 20 characters (no symbols)
	string ship_country="", // Up to 60 characters (no symbols)
	string ship_phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string ship_faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string accountType="", // checking,savings,businessChecking
	string routingNumber="", // 9 digits
	string accountNumber="", // 5 to 17 digits
	string nameOnAccount="", // full name as listed on the bank account Up to 22 characters
	string echeckType="", // CCD,PPD,TEL,WEB (WEB for internet transactions)
	string bankName="", // Optional Up to 50 characters
	string dataDescriptor="",
	string dataValue="",
	boolean validate="true",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Creates a new CIM Customer Profile." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.customerProfileId = "";
	response.customerPaymentProfileId = "";
	response.customerAddressId = "";
	
	response.response_code = "3";
	response.reason_code = "";
	response.authorization_code = "";
	response.response_text = "";
	response.avs_code = "";
	response.trans_id = "";
	response.card_code_response = "";
	response.cavv_response = "";
	response.resultstring = "";

	if (arguments.echeckType is "" and arguments.accountNumber is not "") {
		switch(arguments.accountType) {
			case "businessChecking":
				arguments.echeckType = "CCD";
				break;
			default:
				arguments.echeckType = "WEB";
				break;
		}
	}

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<createCustomerProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<profile>
			<merchantCustomerId>#arguments.merchantCustomerId#</merchantCustomerId>
			<description>#myXMLFormat(left(arguments.customerdescription, 255), arguments.useXmlFormat)#</description>
			<email>#arguments.email#</email>"
		);
		if (arguments.cardNumber is not "" or arguments.accountNumber is not "" or arguments.dataValue is not "") {
			writeOutput("<paymentProfiles>");
			if (arguments.customerType is not "") {
				writeOutput("<customerType>#arguments.customerType#</customerType>");
			}
			writeOutput("<billTo>
			<firstName>#myXMLFormat(arguments.firstName, arguments.useXmlFormat)#</firstName>
			<lastName>#myXMLFormat(arguments.lastName, arguments.useXmlFormat)#</lastName>
			<company>#myXMLFormat(arguments.company, arguments.useXmlFormat)#</company>
			<address>#myXMLFormat(arguments.address, arguments.useXmlFormat)#</address>
			<city>#myXMLFormat(arguments.city, arguments.useXmlFormat)#</city>
			<state>#arguments.state#</state>
			<zip>#myXMLFormat(arguments.zip, arguments.useXmlFormat)#</zip>
			<country>#myXMLFormat(arguments.country, arguments.useXmlFormat)#</country>
			<phoneNumber>#rereplace(arguments.phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>
			<faxNumber>#rereplace(arguments.faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>
			</billTo>
			<payment>");
			if (arguments.cardNumber is not "") {
				writeOutput("<creditCard>
				<cardNumber>#rereplace(arguments.cardNumber, "[^0-9]+", "", "ALL")#</cardNumber>
				<expirationDate>#arguments.expirationDate#</expirationDate>");
				if (arguments.cardCode is not "") {
					writeOutput("<cardCode>#arguments.cardCode#</cardCode>");
				}
				writeOutput("</creditCard>");
			} else if (arguments.accountNumber is not "") {
				writeOutput("<bankAccount>
				<accountType>#arguments.accountType#</accountType>
				<routingNumber>#arguments.routingNumber#</routingNumber>
				<accountNumber>#arguments.accountNumber#</accountNumber>
				<nameOnAccount>#myXMLFormat(arguments.nameOnAccount, arguments.useXmlFormat)#</nameOnAccount>
				<echeckType>#arguments.echeckType#</echeckType>
				<bankName>#myXMLFormat(arguments.bankName, arguments.useXmlFormat)#</bankName>
				</bankAccount>");
			} else if ( arguments.dataValue is not "" ) {
				writeOutput("<opaqueData>
				<dataDescriptor>#arguments.dataDescriptor#</dataDescriptor>
				<dataValue>#arguments.dataValue#</dataValue>
				</opaqueData>");
			}
			writeOutput("</payment></paymentProfiles>");
		}	
		if (arguments.ship_address is not "") {
			writeOutput("<shipToList>
			<firstName>#myXMLFormat(arguments.ship_firstName, arguments.useXmlFormat)#</firstName>
			<lastName>#myXMLFormat(arguments.ship_lastName, arguments.useXmlFormat)#</lastName>
			<company>#myXMLFormat(arguments.ship_company, arguments.useXmlFormat)#</company>
			<address>#myXMLFormat(arguments.ship_address, arguments.useXmlFormat)#</address>
			<city>#myXMLFormat(arguments.ship_city, arguments.useXmlFormat)#</city>
			<state>#arguments.ship_state#</state>
			<zip>#myXMLFormat(arguments.ship_zip, arguments.useXmlFormat)#</zip>
			<country>#myXMLFormat(arguments.ship_country, arguments.useXmlFormat)#</country>
			<phoneNumber>#rereplace(arguments.ship_phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>
			<faxNumber>#rereplace(arguments.ship_faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>
			</shipToList>"
			);
		}
		writeOutput("</profile>");
		if (arguments.validate and arguments.cardNumber is not "") {
			writeOutput("<validationMode>");
			if (arguments.testrequest) {
				writeOutput("testMode");
			} else {
				writeOutput("liveMode");
			}
			writeOutput("</validationMode>");
		}
		writeOutput("</createCustomerProfileRequest>");
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		temp = response.XmlResponse.createCustomerProfileResponse;
		response.refId = temp.refId.XmlText;
		response.customerProfileId = temp.customerProfileId.XmlText;
		if (isDefined('temp.customerPaymentProfileIdList.numericString')) {
			response.customerPaymentProfileId = temp.customerPaymentProfileIdList.numericString.XmlText;
		}
		if (isDefined('temp.customerShippingAddressIdList.numericString')) {
			response.customerAddressId = temp.customerShippingAddressIdList.numericString.XmlText;
		}
		if (isDefined('temp.validationDirectResponseList.string')) {
			response.resultstring = temp.validationDirectResponseList.string.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}
	if (response.error is not "" and arguments.error_email_to is not "") {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end funtion createCustomerProfile()

public struct function getCustomerProfile(
	string refId="",  // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="") hint="Gets a CIM Customer Profile." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
		
	response.merchantCustomerId = "";
	response.customerdescription = "";
	response.email = "";
	response.customerProfileId = "";
	response.customerPaymentProfileIdList = "";
	response.customerAddressIdList = "";
	response.PaymentProfiles = ""; // reset as query
	response.Addresses = ""; // reset as query

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<getCustomerProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			</getCustomerProfileRequest>"
		);
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.getCustomerProfileResponse.refId.XmlText;
		temp = response.XmlResponse.getCustomerProfileResponse.profile;
		response.merchantCustomerId = temp.merchantCustomerId.XmlText;
		response.customerdescription = temp.description.XmlText;
		response.email = temp.email.XmlText;
		response.customerProfileId = temp.customerProfileId.XmlText;
		temp = xmlToQryCustomerProfile(response.XmlResponse);
		if (isQuery(temp.PaymentProfiles)) {
			response.PaymentProfiles = temp.PaymentProfiles;
			response.customerPaymentProfileIdList = valuelist(temp.PaymentProfiles.customerPaymentProfileId);
		}
		if (isQuery(temp.Addresses)) {
			response.Addresses = temp.Addresses;
			response.customerAddressIdList = valuelist(temp.Addresses.customerAddressId);
		}
	}
	if (response.error is not "" and arguments.error_email_to is not "") {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end funtion getCustomerProfile()

public struct function getCustomerProfileIds(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="") hint="Gets a list of all CIM Customer Profile IDs." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.customerProfileIdList = "";

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<getCustomerProfileIdsRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			</getCustomerProfileIdsRequest>"
		);
	};
	
	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.customerProfileIdList = "";
		response.refId = response.XmlResponse.getCustomerProfileIdsResponse.refId.XmlText;
		for (i = 1; i <= arraylen(response.XmlResponse.getCustomerProfileIdsResponse.ids.numericString); i++) {
			response.customerProfileIdList = listappend(response.customerProfileIdList, response.XmlResponse.getCustomerProfileIdsResponse.ids.numericString[i].XmlText);
		}
	}
	if (response.error is not "" and arguments.error_email_to is not "") {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function getCustomerProfileIds()

public struct function updateCustomerProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string merchantCustomerId="", // 2 out of first 3 must have a value
	string customerdescription="",
	string email="",
	string customerProfileId="",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Updates a new CIM customer profile." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";

	response.customerProfileId = arguments.customerProfileId;
	
	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
		<updateCustomerProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<profile>
			<merchantCustomerId>#arguments.merchantCustomerId#</merchantCustomerId>
			<description>#myXMLFormat(left(arguments.customerdescription, 255), arguments.useXmlFormat)#</description>
			<email>#arguments.email#</email>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			</profile>
		</updateCustomerProfileRequest>"
		);
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.updateCustomerProfileResponse.refId.XmlText;
	}
	if (response.error is not "" and arguments.error_email_to is not "") {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end funtion updateCustomerProfile()

public struct function deleteCustomerProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="") hint="Deletes a CIM customer profile." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
		
	response.customerProfileId = arguments.customerProfileId;

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<deleteCustomerProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			</deleteCustomerProfileRequest>"
			);
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.deleteCustomerProfileResponse.refId.XmlText;
	}
	if (response.error is not "" and arguments.error_email_to is not "") {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function deleteCustomerProfile()

public struct function createCustomerPaymentProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string ADC_Delim_Character=variables.ADC_Delim_Character,
	string Encapsulate_Character=variables.Encapsulate_Character,
	string customerProfileId="",
	string description="",
	string email="",
	boolean testrequest="false",
	string customerType="",
	string cardNumber="",
	string expirationDate="", // YYYY-MM
	string cardCode="",
	string firstname="", // Up to 50 characters (no symbols)
	string lastname="", // Up to 50 characters (no symbols)
	string company="", // Up to 50 characters (no symbols)
	string address="", // Up to 60 characters (no symbols)
	string city="", // Up to 40 characters (no symbols)
	string state="", // A valid two-character state code
	string zip="", // Up to 20 characters (no symbols)
	string country="", // Up to 60 characters (no symbols)
	string phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string accountType="", // checking,savings,businessChecking
	string routingNumber="", // 9 digits
	string accountNumber="", // 5 to 17 digits
	string nameOnAccount="", // full name as listed on the bank account Up to 22 characters
	string echeckType="", // Optional,CCD,PPD,TEL,WEB (we use WEB)
	string bankName="", // Optional Up to 50 characters
	boolean defaultPaymentProfile="false",
	boolean validate="true",
	string dataDescriptor="",
	string dataValue="",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Creates a new CIM Customer Payment Profile." {

	var response = StructNew();
	var temp = "";
	var result = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerPaymentProfileId = "";
	
	response.response_code = "3";
	response.reason_code = "";
	response.authorization_code = "";
	response.response_text = "";
	response.avs_code = "";
	response.trans_id = "";
	response.card_code_response = "";
	response.cavv_response = "";
	response.resultstring = "";
	
	if ( arguments.cardNumber is not "" ) {
		response.PaymentProfileType = "credit";
	} else {
		response.PaymentProfileType = "bank";
	}

	response.address = arguments.address;
	response.city = arguments.city;
	response.company = arguments.company;
	response.country = arguments.country;
	response.faxnumber = arguments.faxnumber;
	response.firstname = arguments.firstname;
	response.lastname = arguments.lastname;
	response.phonenumber = arguments.phonenumber;
	response.state = arguments.state;
	response.zip = arguments.zip;
	
	response.cardnumber = right(rereplace(arguments.cardnumber, "[^0-9]+", "", "ALL"), 4);
	response.expirationdate  = arguments.expirationDate;
	
	response.accountnumber = right(rereplace(arguments.accountnumber, "[^0-9]+", "", "ALL"), 4);
	response.routingnumber = right(rereplace(arguments.routingnumber, "[^0-9]+", "", "ALL"), 4);
	response.accounttype = arguments.accounttype;
	response.bankname = arguments.bankname;
	response.echecktype = arguments.echecktype;
	response.nameonaccount = arguments.nameonaccount;
	response.customerType = arguments.customerType;


	if ( arguments.echeckType is "" and arguments.accountNumber is not "" ) {
		switch ( arguments.accountType ) {
			case "businessChecking":
				arguments.echeckType = "CCD";
				break;
			default:
				arguments.echeckType = "WEB";
				break;
		}
	}

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<createCustomerPaymentProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<paymentProfile>"
		);
		if ( arguments.customerType is not "" ) {
			writeOutput("<customerType>#arguments.customerType#</customerType>");
		}
		writeOutput("<billTo>
			<firstName>#myXMLFormat(arguments.firstName, arguments.useXmlFormat)#</firstName>
			<lastName>#myXMLFormat(arguments.lastName, arguments.useXmlFormat)#</lastName>
			<company>#myXMLFormat(arguments.company, arguments.useXmlFormat)#</company>
			<address>#myXMLFormat(arguments.address, arguments.useXmlFormat)#</address>
			<city>#myXMLFormat(arguments.city, arguments.useXmlFormat)#</city>
			<state>#arguments.state#</state>
			<zip>#myXMLFormat(arguments.zip, arguments.useXmlFormat)#</zip>
			<country>#myXMLFormat(arguments.country, arguments.useXmlFormat)#</country>
			<phoneNumber>#rereplace(arguments.phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>
			<faxNumber>#rereplace(arguments.faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>
			</billTo>
			<payment>"
		);
		if ( arguments.cardNumber is not "" ) {
			writeOutput("<creditCard>
				<cardNumber>#rereplace(arguments.cardNumber, "[^0-9]+", "", "ALL")#</cardNumber>
				<expirationDate>#arguments.expirationDate#</expirationDate>"
			);
			if ( arguments.cardCode is not "" ) {
				writeOutput("<cardCode>#arguments.cardCode#</cardCode>");
			}
			writeOutput("</creditCard>");
		} else if ( arguments.accountNumber is not "" ) {
			writeOutput("<bankAccount>
				<accountType>#arguments.accountType#</accountType>
				<routingNumber>#arguments.routingNumber#</routingNumber>
				<accountNumber>#arguments.accountNumber#</accountNumber>
				<nameOnAccount>#myXMLFormat(arguments.nameOnAccount, arguments.useXmlFormat)#</nameOnAccount>
				<echeckType>#arguments.echeckType#</echeckType>
				<bankName>#myXMLFormat(arguments.bankName, arguments.useXmlFormat)#</bankName>
				</bankAccount>"
			);
		} else if ( arguments.dataValue is not "" ) {
			writeOutput("<opaqueData>
			<dataDescriptor>#arguments.dataDescriptor#</dataDescriptor>
			<dataValue>#arguments.dataValue#</dataValue>
			</opaqueData>");
		}
		writeOutput("</payment>");
		if ( arguments.defaultPaymentProfile ) {
			writeOutput("<defaultPaymentProfile>true</defaultPaymentProfile>");
		} else {
			writeOutput("<defaultPaymentProfile>false</defaultPaymentProfile>");
		}
		writeOutput("</paymentProfile>");
		if ( arguments.validate ) {
			writeOutput("<validationMode>");
			if ( arguments.testrequest ) {
				writeOutput("testMode");
			} else {
				writeOutput("liveMode");
			}
			writeOutput("</validationMode>");
		}
		writeOutput("</createCustomerPaymentProfileRequest>");
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.createCustomerPaymentProfileResponse.refId.XmlText;
		response.customerPaymentProfileId = response.XmlResponse.createCustomerPaymentProfileResponse.customerPaymentProfileId.XmlText;
		if ( isDefined('response.XmlResponse.createCustomerPaymentProfileResponse.validationDirectResponse') ) {
			response.resultstring = response.XmlResponse.createCustomerPaymentProfileResponse.validationDirectResponse.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function createCustomerPaymentProfile()

public struct function getCustomerPaymentProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="",
	string customerPaymentProfileId="",
	boolean unmaskExpirationDate="false",
	boolean includeIssuerInfo="false") hint="Gets a CIM Customer Payment Profile." {

	var response = StructNew();
	var temp = "";

	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerPaymentProfileId = "";
	response.paymentprofiledescription = "";
	
	response.customerType = "";
	
	response.address = "";
	response.city = "";
	response.company = "";
	response.country = "";
	response.faxnumber = "";
	response.firstname = "";
	response.lastname = "";
	response.phonenumber = "";
	response.state = "";
	response.zip = "";
	
	response.PaymentProfileType = "";
	
	response.cardnumber = "";
	response.expirationdate  = "";
	
	response.accountnumber = "";
	response.accounttype = "";
	response.bankname = "";
	response.echecktype = "";
	response.nameonaccount = "";
	response.routingnumber = "";

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<getCustomerPaymentProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<customerPaymentProfileId>#arguments.customerPaymentProfileId#</customerPaymentProfileId>
			<unmaskExpirationDate>#arguments.unmaskExpirationDate#</unmaskExpirationDate>
			<includeIssuerInfo>#arguments.includeIssuerInfo#</includeIssuerInfo>
			</getCustomerPaymentProfileRequest>"
		);
	};

	response.XmlRequest = xmlParse( myXml );

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.getCustomerPaymentProfileResponse.refId.XmlText;
		temp = response.XmlResponse.getCustomerPaymentProfileResponse.PaymentProfile;
		if ( structkeyexists(temp, "customerType") ) {
			response.customerType = temp.customerType.XmlText;
		}
		response.customerPaymentProfileId = temp.customerPaymentProfileId.XmlText;
		if ( structkeyexists(temp.billTo, "address") ) { response.address = temp.billTo.address.XmlText; }
		if ( structkeyexists(temp.billTo, "city") ) { response.city = temp.billTo.city.XmlText; }
		if ( structkeyexists(temp.billTo, "company") ) { response.company = temp.billTo.company.XmlText; }
		if ( structkeyexists(temp.billTo, "country") ) { response.country = temp.billTo.country.XmlText; }
		if ( structkeyexists(temp.billTo, "faxnumber") ) { response.faxnumber = temp.billTo.faxnumber.XmlText; }
		if ( structkeyexists(temp.billTo, "firstname") ) { response.firstname = temp.billTo.firstname.XmlText; }
		if ( structkeyexists(temp.billTo, "lastname") ) { response.lastname = temp.billTo.lastname.XmlText; }
		if ( structkeyexists(temp.billTo, "phonenumber") ) { response.phonenumber = temp.billTo.phonenumber.XmlText; }
		if ( structkeyexists(temp.billTo, "state") ) { response.state = temp.billTo.state.XmlText; }
		if ( structkeyexists(temp.billTo, "zip") ) { response.zip = temp.billTo.zip.XmlText; }
		if ( structkeyexists(temp.payment, "creditCard") ) {
			response.PaymentProfileType = "credit";
			response.paymentprofiledescription = "#temp.billTo.firstname.XmlText# #temp.billTo.lastname.XmlText# (credit card #temp.payment.creditCard.cardnumber.XmlText#)";
			response.cardnumber = temp.payment.creditCard.cardnumber.XmlText;
			response.expirationdate  = temp.payment.creditCard.expirationdate.XmlText;
		} else if ( structkeyexists(temp.payment, "bankAccount") ) {
			response.PaymentProfileType = "bank";
			response.accountnumber = temp.payment.bankAccount.accountnumber.XmlText;
			if ( structkeyexists(temp.payment.bankAccount, 'accounttype') ) {
				response.accounttype = temp.payment.bankAccount.accounttype.XmlText;
			}
			if ( structkeyexists(temp.payment.bankAccount, 'bankname') ) {
				response.bankname = temp.payment.bankAccount.bankname.XmlText;
			}
			if ( structkeyexists(temp.payment.bankAccount, 'echecktype') ) {
				response.echecktype = temp.payment.bankAccount.echecktype.XmlText;
			}
			if ( structkeyexists(temp.payment.bankAccount, 'nameonaccount') ) {
				response.nameonaccount = temp.payment.bankAccount.nameonaccount.XmlText;
			}
			response.routingnumber = temp.payment.bankAccount.routingnumber.XmlText;
			switch (response.accounttype) {
				case "checking":
					response.paymentprofiledescription = "#temp.payment.bankAccount.nameonaccount.XmlText# (checking acct. #temp.payment.bankAccount.accountnumber.XmlText#)";
					break;
				case "businessChecking":
					response.paymentprofiledescription = "#temp.payment.bankAccount.nameonaccount.XmlText# (business checking #temp.payment.bankAccount.accountnumber.XmlText#)";
					break;
				case "savings":
					response.paymentprofiledescription = "#temp.payment.bankAccount.nameonaccount.XmlText# (savings account #temp.payment.bankAccount.accountnumber.XmlText#)";				break;
				default:
					response.paymentprofiledescription = "#temp.payment.bankAccount.nameonaccount.XmlText# (bank account #temp.payment.bankAccount.accountnumber.XmlText#)";
					break;
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function getCustomerPaymentProfile()

public struct function validateCustomerPaymentProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string ADC_Delim_Character=variables.ADC_Delim_Character,
	string Encapsulate_Character=variables.Encapsulate_Character,
	string customerProfileId="",
	string customerPaymentProfileId="",
	string cardCode="",
	boolean testrequest="false") hint="Validates a one penny transaction against new CIM Customer Payment Profile." {

	var response = StructNew();
	var temp = "";
	var result = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerPaymentProfileId = arguments.customerPaymentProfileId;
	
	response.response_code = "3";
	response.reason_code = "";
	response.authorization_code = "";
	response.response_text = "";
	response.avs_code = "";
	response.trans_id = "";
	response.card_code_response = "";
	response.cavv_response = "";
	response.resultstring = "";

	savecontent variable="myXml" {
		writeOutput( "<?xml version=""1.0"" encoding=""utf-8""?>
			<validateCustomerPaymentProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<customerPaymentProfileId>#arguments.customerPaymentProfileId#</customerPaymentProfileId>");
		if (NOT len(arguments.cardcode)) {
			writeOutput( "<cardCode>#arguments.cardcode#</cardCode>");
		}
		writeOutput( "<validationMode>");
		if (arguments.testrequest) {
			writeOutput( "testMode");
		} else {
			writeOutput( "liveMode");
		}
		writeOutput( "</validationMode></validateCustomerPaymentProfileRequest>");
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.validateCustomerPaymentProfileResponse.refId.XmlText;
		if ( structkeyexists(response.XmlResponse.validateCustomerPaymentProfileResponse, "DirectResponse") ) {
			response.resultstring = response.XmlResponse.validateCustomerPaymentProfileResponse.directResponse.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function validateCustomerPaymentProfile()

public struct function updateCustomerPaymentProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string ADC_Delim_Character=variables.ADC_Delim_Character,
	string Encapsulate_Character=variables.Encapsulate_Character,
	string customerProfileId="",
	string customerPaymentProfileId="",
	string description="",
	string email="",
	boolean testrequest="FALSE",
	string customerType="",
	string cardNumber="",
	string expirationDate="", // YYYY-MM
	string cardCode="",
	string firstname="", // Up to 50 characters (no symbols)
	string lastname="", // Up to 50 characters (no symbols)
	string company="", // Up to 50 characters (no symbols)
	string address="", // Up to 60 characters (no symbols)
	string city="", // Up to 40 characters (no symbols)
	string state="", // A valid two-character state code
	string zip="", // Up to 20 characters (no symbols)
	string faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string country="", // Up to 60 characters (no symbols)
	string phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string accountType="", // checking,savings,businessChecking
	string routingNumber="", // 9 digits
	string accountNumber="", // 5 to 17 digits
	string nameOnAccount="", // full name as listed on the bank account Up to 22 characters
	string echeckType="", // Optional,CCD,PPD,TEL,WEB (we use WEB)
	string bankName="", // Optional Up to 50 characters
	boolean defaultPaymentProfile="false",
	boolean validate="true",
	string dataDescriptor="",
	string dataValue="",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Updates a CIM Customer Payment Profile." {

	var response = StructNew();
	var temp	= "";
	var result = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerPaymentProfileId = arguments.customerPaymentProfileId;
	
	response.response_code = "3";
	response.reason_code = "";
	response.authorization_code = "";
	response.response_text = "";
	response.avs_code = "";
	response.trans_id = "";
	response.card_code_response = "";
	response.cavv_response = "";
	response.resultstring = "";
	
	if ( arguments.cardNumber is not "" ) {
		response.PaymentProfileType = "credit";
	} else {
		response.PaymentProfileType = "bank";
	}

	response.address = arguments.address;
	response.city = arguments.city;
	response.company = arguments.company;
	response.country = arguments.country;
	response.faxnumber = arguments.faxnumber;
	response.firstname = arguments.firstname;
	response.lastname = arguments.lastname;
	response.phonenumber = arguments.phonenumber;
	response.state = arguments.state;
	response.zip = arguments.zip;
	
	response.cardnumber = right(rereplace(arguments.cardnumber, "[^0-9]+", "", "ALL"), 4);
	response.expirationdate  = arguments.expirationDate;
	
	response.accountnumber = right(rereplace(arguments.accountnumber, "[^0-9]+", "", "ALL"), 4);
	response.routingnumber = right(rereplace(arguments.routingnumber, "[^0-9]+", "", "ALL"), 4);
	response.accounttype = arguments.accounttype;
	response.bankname = arguments.bankname;
	response.echecktype = arguments.echecktype;
	response.nameonaccount = arguments.nameonaccount;
	response.customerType = arguments.customerType;

	if ( arguments.echeckType is "" and arguments.accountType is not "" ) {
		switch ( arguments.accountType ) {
			case "businessChecking":
				arguments.echeckType = "CCD";
				break;
			default:
				arguments.echeckType = "WEB";
				break;
		}
	}

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<updateCustomerPaymentProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<paymentProfile>");
		if ( arguments.customerType is not "" ) {
			writeOutput("<customerType>#arguments.customerType#</customerType>");
		}
		writeOutput("<billTo>
			<firstName>#myXMLFormat(arguments.firstName, arguments.useXmlFormat)#</firstName>
			<lastName>#myXMLFormat(arguments.lastName, arguments.useXmlFormat)#</lastName>
			<company>#myXMLFormat(arguments.company, arguments.useXmlFormat)#</company>
			<address>#myXMLFormat(arguments.address, arguments.useXmlFormat)#</address>
			<city>#myXMLFormat(arguments.city, arguments.useXmlFormat)#</city>
			<state>#arguments.state#</state>
			<zip>#myXMLFormat(arguments.zip, arguments.useXmlFormat)#</zip>
			<country>#myXMLFormat(arguments.country, arguments.useXmlFormat)#</country>
			<phoneNumber>#rereplace(arguments.phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>
			<faxNumber>#rereplace(arguments.faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>
			</billTo>
			<payment>");
		if ( arguments.cardNumber is not "" ) {
			writeOutput("<creditCard><cardNumber>");
			if ( len(arguments.cardNumber) is 4 ) {
				writeOutput("XXXX");
			}
			writeOutput("#rereplace(arguments.cardNumber, "[^0-9]+", "", "ALL")#</cardNumber><expirationDate>");
			if ( arguments.expirationDate is "" ) {
				writeOutput("XXXX");
			} else {
				writeOutput("#arguments.expirationDate#");
			}
			writeOutput("</expirationDate>");
			if ( arguments.cardCode is not "" ) {
				writeOutput("<cardCode>#arguments.cardCode#</cardCode>");
			}
			writeOutput("</creditCard>");
		} else if ( arguments.accountNumber is not "" ) {
			writeOutput("<bankAccount>");
			if ( arguments.accountType is not "" ) {
				writeOutput("<accountType>#arguments.accountType#</accountType>");
			}
			writeOutput("<routingNumber>");
			if ( len(arguments.routingNumber) is 4 ) {
				writeOutput("XXXX");
			}
			writeOutput("#arguments.routingNumber#</routingNumber><accountNumber>");
			if ( len(arguments.accountNumber) is 4 ) {
				writeOutput("XXXX");
			}
			writeOutput("#arguments.accountNumber#</accountNumber>");
			if ( arguments.nameOnAccount is not "" ) {
				writeOutput("<nameOnAccount>#myXMLFormat(arguments.nameOnAccount, arguments.useXmlFormat)#</nameOnAccount>");
			}
			if ( arguments.echeckType is not "" ) {
				writeOutput("<echeckType>#arguments.echeckType#</echeckType>");
			}
			if ( arguments.bankName is not "" ) {
				writeOutput("<bankName>#myXMLFormat(arguments.bankName, arguments.useXmlFormat)#</bankName>");
			}
			writeOutput("</bankAccount>");
		} else if ( arguments.dataValue is not "" ) {
			writeOutput("<opaqueData>
			<dataDescriptor>#arguments.dataDescriptor#</dataDescriptor>
			<dataValue>#arguments.dataValue#</dataValue>
			</opaqueData>");
		}
		writeOutput("</payment>");
		if ( arguments.defaultPaymentProfile ) {
			writeOutput("<defaultPaymentProfile>true</defaultPaymentProfile>");
		} else {
			writeOutput("<defaultPaymentProfile>false</defaultPaymentProfile>");
		}
		writeOutput("<customerPaymentProfileId>#arguments.customerPaymentProfileId#</customerPaymentProfileId></paymentProfile>");
		if ( arguments.validate ) {
			writeOutput("<validationMode>");
			if ( arguments.testrequest ) {
				writeOutput("testMode");
			} else {
				writeOutput("liveMode");
			}
			writeOutput("</validationMode>");
		}
		writeOutput("</updateCustomerPaymentProfileRequest>");
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.updateCustomerPaymentProfileResponse.refId.XmlText;
		if ( isDefined('response.XmlResponse.updateCustomerPaymentProfileResponse.validationDirectResponse') ) {
			response.resultstring = response.XmlResponse.updateCustomerPaymentProfileResponse.validationDirectResponse.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function updateCustomerPaymentProfile()

public struct function deleteCustomerPaymentProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="",
	string customerPaymentProfileId="") hint="Deletes a CIM Customer Payment Profile." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerPaymentProfileId = arguments.customerPaymentProfileId;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<deleteCustomerPaymentProfileRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<customerPaymentProfileId>#arguments.customerPaymentProfileId#</customerPaymentProfileId>
			</deleteCustomerPaymentProfileRequest>");
	};

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.deleteCustomerPaymentProfileResponse.refId.XmlText;
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function deleteCustomerPaymentProfile()

public struct function createCustomerShippingAddress(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="",
	string ship_firstname="", // Up to 50 characters (no symbols)
	string ship_lastname="", // Up to 50 characters (no symbols)
	string ship_company="", // Up to 50 characters (no symbols)
	string ship_address="", // Up to 60 characters (no symbols)
	string ship_city="", // Up to 40 characters (no symbols)
	string ship_state="", // A valid two-character state code
	string ship_zip="", // Up to 20 characters (no symbols)
	string ship_country="", // Up to 60 characters (no symbols)
	string ship_phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string ship_faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	boolean defaultShippingAddress="false",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Creates a new CIM Customer Shipping Address." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerAddressId = "";

	response.address = arguments.ship_address;
	response.city = arguments.ship_city;
	response.company = arguments.ship_company;
	response.country = arguments.ship_country;
	response.faxnumber = arguments.ship_faxnumber;
	response.firstname = arguments.ship_firstname;
	response.lastname = arguments.ship_lastname;
	response.phonenumber = arguments.ship_phonenumber;
	response.state = arguments.ship_state;
	response.zip = arguments.ship_zip;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<createCustomerShippingAddressRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<address>
			<firstName>#myXMLFormat(arguments.ship_firstName, arguments.useXmlFormat)#</firstName>
			<lastName>#myXMLFormat(arguments.ship_lastName, arguments.useXmlFormat)#</lastName>
			<company>#myXMLFormat(arguments.ship_company, arguments.useXmlFormat)#</company>
			<address>#myXMLFormat(arguments.ship_address, arguments.useXmlFormat)#</address>
			<city>#myXMLFormat(arguments.ship_city, arguments.useXmlFormat)#</city>
			<state>#arguments.ship_state#</state>
			<zip>#myXMLFormat(arguments.ship_zip, arguments.useXmlFormat)#</zip>
			<country>#myXMLFormat(arguments.ship_country, arguments.useXmlFormat)#</country>
			<phoneNumber>#rereplace(arguments.ship_phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>
			<faxNumber>#rereplace(arguments.ship_faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>
			</address>
			<defaultShippingAddress>#arguments.defaultShippingAddress#</defaultShippingAddress>
			</createCustomerShippingAddressRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.createCustomerShippingAddressResponse.refId.XmlText;
		response.customerAddressId = response.XmlResponse.createCustomerShippingAddressResponse.customerAddressId.XmlText;
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function createCustomerShippingAddress()

public struct function getCustomerShippingAddress(
	string refId="",
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="",
	string customerAddressId="") hint="Gets a CIM Customer Shipping Address." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = ""; // Included in response. 20 char max.
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerAddressId = "";
	response.AddressDescription = "";
	
	response.address = "";
	response.city = "";
	response.company = "";
	response.country = "";
	response.faxnumber = "";
	response.firstname = "";
	response.lastname = "";
	response.phonenumber = "";
	response.state = "";
	response.zip = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<getCustomerShippingAddressRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<customerAddressId>#arguments.customerAddressId#</customerAddressId>
			</getCustomerShippingAddressRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.getCustomerShippingAddressResponse.refId.XmlText;
		temp = response.XmlResponse.getCustomerShippingAddressResponse.Address;
		response.customerAddressId = temp.customerAddressId.XmlText;
		response.address = temp.address.XmlText;
		response.city = temp.city.XmlText;
		response.company = temp.company.XmlText;
		response.country = temp.country.XmlText;
		response.faxnumber = temp.faxnumber.XmlText;
		response.firstname = temp.firstname.XmlText;
		response.lastname = temp.lastname.XmlText;
		response.phonenumber = temp.phonenumber.XmlText;
		response.state = temp.state.XmlText;
		response.zip = temp.zip.XmlText;
		response.AddressDescription = "#response.address#, #response.firstname# #response.lastname#";
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function getCustomerShippingAddress()

public struct function updateCustomerShippingAddress(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="",
	string customerAddressId="",
	string ship_firstname="", // Up to 50 characters (no symbols)
	string ship_lastname="", // Up to 50 characters (no symbols)
	string ship_company="", // Up to 50 characters (no symbols)
	string ship_address="", // Up to 60 characters (no symbols)
	string ship_city="", // Up to 40 characters (no symbols)
	string ship_state="", // A valid two-character state code
	string ship_zip="", // Up to 20 characters (no symbols)
	string ship_country="", // Up to 60 characters (no symbols)
	string ship_phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string ship_faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	boolean defaultShippingAddress="false",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Updates a CIM Customer Shipping Address." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerAddressId = arguments.customerAddressId;

	response.address = arguments.ship_address;
	response.city = arguments.ship_city;
	response.company = arguments.ship_company;
	response.country = arguments.ship_country;
	response.faxnumber = arguments.ship_faxnumber;
	response.firstname = arguments.ship_firstname;
	response.lastname = arguments.ship_lastname;
	response.phonenumber = arguments.ship_phonenumber;
	response.state = arguments.ship_state;
	response.zip = arguments.ship_zip;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<updateCustomerShippingAddressRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<address>
			<firstName>#myXMLFormat(arguments.ship_firstName, arguments.useXmlFormat)#</firstName>
			<lastName>#myXMLFormat(arguments.ship_lastName, arguments.useXmlFormat)#</lastName>
			<company>#myXMLFormat(arguments.ship_company, arguments.useXmlFormat)#</company>
			<address>#myXMLFormat(arguments.ship_address, arguments.useXmlFormat)#</address>
			<city>#myXMLFormat(arguments.ship_city, arguments.useXmlFormat)#</city>
			<state>#arguments.ship_state#</state>
			<zip>#myXMLFormat(arguments.ship_zip, arguments.useXmlFormat)#</zip>
			<country>#myXMLFormat(arguments.ship_country, arguments.useXmlFormat)#</country>
			<phoneNumber>#rereplace(arguments.ship_phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>
			<faxNumber>#rereplace(arguments.ship_faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>
			<customerAddressId>#arguments.customerAddressId#</customerAddressId>
			</address>
			<defaultShippingAddress>#arguments.defaultShippingAddress#</defaultShippingAddress>
			</updateCustomerShippingAddressRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.updateCustomerShippingAddressResponse.refId.XmlText;
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function updateCustomerShippingAddress()

public struct function deleteCustomerShippingAddress(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string customerProfileId="",
	string customerAddressId="") hint="Deletes a CIM Customer Shipping Address." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	
	response.customerProfileId = arguments.customerProfileId;
	response.customerAddressId = arguments.customerAddressId;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<deleteCustomerShippingAddressRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<customerProfileId>#arguments.customerProfileId#</customerProfileId>
			<customerAddressId>#arguments.customerAddressId#</customerAddressId>
			</deleteCustomerShippingAddressRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.deleteCustomerShippingAddressResponse.refId.XmlText;
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function deleteCustomerShippingAddress()

public struct function getCustomerPaymentProfileList(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string searchType="cardsExpiringInMonth",
	string month="",
	string orderBy="id",
	boolean orderDescending="false",
	numeric pageLimit=10,
	numeric offset=1) hint="Get all CIM Payment Profiles matching searchType." {

	var response = StructNew();
	var temp = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<getCustomerPaymentProfileListRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<searchType>#arguments.searchType#</searchType>
			<month>#arguments.month#</month>
			<sorting>
			<orderBy>#arguments.orderBy#</orderBy>
			<orderDescending>#arguments.orderDescending#</orderDescending>
			</sorting>
			<paging>
			<limit>#arguments.pageLimit#</limit>
			<offset>#arguments.offset#</offset>
			</paging>
			</getCustomerPaymentProfileListRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.getCustomerPaymentProfileListResponse.refId.XmlText;
		response.PaymentProfiles = QueryNew("customerProfileId,email,paymentprofiledescription,customerPaymentProfileId,address,city,company,country,faxnumber,firstName,lastName,phonenumber,state,zip,PaymentProfileType,cardnumber,expirationdate,accountnumber,accounttype,bankname,echecktype,nameonaccount,routingnumber");
		if ( structkeyexists(response.XmlResponse.getCustomerPaymentProfileListResponse.paymentprofiles, "paymentProfile") ) {
			paymentprofiles = response.XmlResponse.getCustomerPaymentProfileListResponse.paymentprofiles.paymentProfile;
			for ( i = 1; i <= arraylen(paymentprofiles); i++ ) {
				temp = queryAddRow(response.PaymentProfiles);
				temp = querySetCell(response.PaymentProfiles, 'customerProfileId', paymentprofiles[i].customerProfileId.XmlText);
				temp = querySetCell(response.PaymentProfiles, 'customerPaymentProfileId', PaymentProfiles[i].customerPaymentProfileId.XmlText);
				if ( structkeyexists(PaymentProfiles[i].billTo, 'email') ) {
					temp = querySetCell(response.PaymentProfiles, 'email', PaymentProfiles[i].billTo.email.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'company') ) {
					temp = querySetCell(response.PaymentProfiles, 'company', PaymentProfiles[i].billTo.company.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'faxnumber') ) {
					temp = querySetCell(response.PaymentProfiles, 'faxnumber', PaymentProfiles[i].billTo.faxnumber.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'phonenumber') ) {
					temp = querySetCell(response.PaymentProfiles, 'phonenumber', PaymentProfiles[i].billTo.phonenumber.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'address') ) {
					temp = querySetCell(response.PaymentProfiles, 'address', PaymentProfiles[i].billTo.address.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'city') ) {
					temp = querySetCell(response.PaymentProfiles, 'city', PaymentProfiles[i].billTo.city.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'country') ) {
					temp = querySetCell(response.PaymentProfiles, 'country', PaymentProfiles[i].billTo.country.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'firstName') ) {
					temp = querySetCell(response.PaymentProfiles, 'firstName', PaymentProfiles[i].billTo.firstName.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'lastName') ) {
					temp = querySetCell(response.PaymentProfiles, 'lastName', PaymentProfiles[i].billTo.lastName.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'state') ) {
					temp = querySetCell(response.PaymentProfiles, 'state', PaymentProfiles[i].billTo.state.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].billTo, 'zip') ) {
					temp = querySetCell(response.PaymentProfiles, 'zip', PaymentProfiles[i].billTo.zip.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].payment, 'creditCard') ) {
					temp = querySetCell(response.PaymentProfiles, 'PaymentProfileType', 'credit');
					temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#PaymentProfiles[i].billTo.firstName.XmlText# #PaymentProfiles[i].billTo.lastname.XmlText# (credit card #PaymentProfiles[i].payment.creditCard.cardnumber.XmlText#)');
					temp = querySetCell(response.PaymentProfiles, 'cardnumber', PaymentProfiles[i].payment.creditCard.cardnumber.XmlText);
					temp = querySetCell(response.PaymentProfiles, 'expirationdate', PaymentProfiles[i].payment.creditCard.expirationdate.XmlText);
				} else if ( structkeyexists(PaymentProfiles[i].payment, 'bankAccount') ) {
					temp = querySetCell(response.PaymentProfiles, 'PaymentProfileType', 'bank');
					temp = querySetCell(response.PaymentProfiles, 'accountnumber', PaymentProfiles[i].payment.bankAccount.accountnumber.XmlText);
					if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'accounttype') ) {
						temp = querySetCell(response.PaymentProfiles, 'accounttype', PaymentProfiles[i].payment.bankAccount.accounttype.XmlText);
					}
					if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'bankname') ) {
						temp = querySetCell(response.PaymentProfiles, 'bankname', PaymentProfiles[i].payment.bankAccount.bankname.XmlText);
					}
					if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'echecktype') ) {
						temp = querySetCell(response.PaymentProfiles, 'echecktype', PaymentProfiles[i].payment.bankAccount.echecktype.XmlText);
					}
					if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'nameonaccount') ) {
						temp = querySetCell(response.PaymentProfiles, 'nameonaccount', PaymentProfiles[i].payment.bankAccount.nameonaccount.XmlText);
					}
					temp = querySetCell(response.PaymentProfiles, 'routingnumber', PaymentProfiles[i].payment.bankAccount.routingnumber.XmlText);
					switch ( response.PaymentProfiles.accounttype[i] ) {
						case "checking":
							temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (checking account #response.PaymentProfiles.accountnumber[i]#)');
							break;
						case "businessChecking":
							temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (business checking #response.PaymentProfiles.accountnumber[i]#)');
							break;
						case "savings":
							temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (savings account #response.PaymentProfiles.accountnumber[i]#)');
							break;
						default:
							temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (bank account #response.PaymentProfiles.accountnumber[i]#)');
							break;
					}
				}
			}
			if (isQuery(response.PaymentProfiles)) {
				response.customerPaymentProfileIdList = valuelist(response.PaymentProfiles.customerPaymentProfileId);
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
}

public struct function createCustomerProfileFromTransaction(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string transId="") hint="Create a CIM customer, payment and shipping profile from an existing transaction." {

	var response = StructNew();
	var result = "";
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<createCustomerProfileFromTransactionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<transId>#arguments.transId#</transId>
			</createCustomerProfileFromTransactionRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		temp = response.XmlResponse.createCustomerProfileFromTransactionResponse;
		response.refId = temp.refId.XmlText;
		response.customerProfileId = temp.customerProfileId.XmlText;
		for (i = 1; i <= arraylen(temp.customerPaymentProfileIdList.numericString); i++) {
			response.customerPaymentProfileIdList = listappend(response.customerPaymentProfileIdList, temp.customerPaymentProfileIdList.numericString[i].XmlText);
		}
		for (i = 1; i <= arraylen(temp.customerShippingAddressIdList.numericString); i++) {
			response.customerShippingAddressIdList = listappend(response.customerShippingAddressIdList, temp.customerShippingAddressIdList.numericString[i].XmlText);
		}
		if (isDefined('temp.validationDirectResponseList.string')) {
			response.resultstring = temp.validationDirectResponseList.string.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function createCustomerProfileFromTransaction()

// ARB
public struct function ARBCreateSubscription(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string subscriptionName="",
	any length="",
	string unit="",
	any startDate="",
	any totalOccurrences="",
	any trialOccurrences="",
	any amount="",
	any trialAmount="",
	string merchantCustomerType="", // individual or business
	string merchantCustomerId="",
	string invoice="",
	string description="",
	string email="",
	string cardNumber="",
	string expirationDate="", // YYYY-MM
	string cardCode="",
	string accountType="", // checking,savings,businessChecking
	string routingNumber="", // 9 digits
	string accountNumber="", // 5 to 17 digits
	string nameOnAccount="", // full name as listed on the bank account Up to 22 characters
	string echeckType="", // Optional,CCD,PPD,TEL,WEB (we use WEB)
	string bankName="", // Optional Up to 50 characters
	string firstname="", // Up to 50 characters (no symbols)
	string lastname="", // Up to 50 characters (no symbols)
	string company="", // Up to 50 characters (no symbols)
	string address="", // Up to 60 characters (no symbols)
	string city="", // Up to 40 characters (no symbols)
	string state="", // Up to 40 characters (no symbols). US: A valid two-character state code
	string zip="", // Up to 20 characters (no symbols)
	string country="", // Up to 60 characters (no symbols)
	string phoneNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string faxNumber="", // Up to 25 digits (no letters) Ex. (123)123-1234
	string ship_firstname="", // Up to 50 characters (no symbols)
	string ship_lastname="", // Up to 50 characters (no symbols)
	string ship_company="", // Up to 50 characters (no symbols)
	string ship_address="", // Up to 60 characters (no symbols)
	string ship_city="", // Up to 40 characters (no symbols)
	string ship_state="", // Up to 40 characters (no symbols). US: A valid two-character state code
	string ship_zip="", // Up to 20 characters (no symbols)
	string ship_country="", // Up to 60 characters (no symbols)
	string dataDescriptor="",
	string dataValue="",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Creates an Automated Recurring Billing Subscription." {

	var response = StructNew();
	var temp	= "";
	var result = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.subscriptionId = "";

	if ( arguments.echeckType is "" and arguments.accountNumber is not "" ) {
		switch ( arguments.accountType ) {
			case "businessChecking":
				arguments.echeckType = "CCD";
				break;
			default:
				arguments.echeckType = "WEB";
				break;
		}
	}

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
		<ARBCreateSubscriptionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
		<merchantAuthentication>
		<name>#arguments.name#</name>
		<transactionKey>#arguments.transactionKey#</transactionKey>
		</merchantAuthentication>
		<refId>#arguments.refId#</refId>
		<subscription>
		<name>#myXMLFormat(arguments.subscriptionname, arguments.useXmlFormat)#</name>
		<paymentSchedule>
		<interval>
		<length>#arguments.length#</length>
		<unit>#arguments.unit#</unit>
		</interval>
		<startDate>#DateFormat(arguments.startDate, "yyyy-mm-dd")#</startDate>
		<totalOccurrences>#arguments.totalOccurrences#</totalOccurrences>");
		if ( isNumeric(arguments.trialOccurrences) and arguments.trialOccurrences GT 0 ) {
			writeOutput("<trialOccurrences>#arguments.trialOccurrences#</trialOccurrences>");
		}
		writeOutput("</paymentSchedule>
		<amount>#rereplace(decimalFormat(rereplace(arguments.amount, "[^0-9\.-]+", "", "ALL")), "[^0-9\.-]+", "", "ALL")#</amount>");
		if ( isNumeric(arguments.trialOccurrences) and arguments.trialOccurrences GT 0 ) {
			writeOutput("<trialAmount>");
			if ( isNumeric(arguments.trialAmount) ) {
				writeOutput("#arguments.trialAmount#");
			} else {
				writeOutput("0.00");
			}
			writeOutput("</trialAmount>");
		}
		writeOutput("<payment>");
		if ( arguments.cardNumber is not "" ) {
			writeOutput("<creditCard><cardNumber>");
			if ( len(arguments.cardNumber) is 4 ) {
				writeOutput("XXXX#arguments.cardNumber#");
			} else {
				writeOutput("#rereplace(arguments.cardNumber, "[^0-9]+", "", "ALL")#");
			}
			writeOutput("</cardNumber><expirationDate>#arguments.expirationDate#</expirationDate>");
			if ( arguments.cardCode is not "" ) {
				writeOutput("<cardCode>#arguments.cardCode#</cardCode>");
			}
			writeOutput("</creditCard>");
		} else if ( arguments.accountNumber is not "" ) {
			writeOutput("<bankAccount>
			<accountType>#arguments.accountType#</accountType>
			<routingNumber>#arguments.routingNumber#</routingNumber>
			<accountNumber>#arguments.accountNumber#</accountNumber>
			<nameOnAccount>#myXMLFormat(arguments.nameOnAccount, arguments.useXmlFormat)#</nameOnAccount>
			<echeckType>#arguments.echeckType#</echeckType>
			<bankName>#myXMLFormat(arguments.bankName, arguments.useXmlFormat)#</bankName>
			</bankAccount>");
		} else if ( arguments.dataValue is not "" ) {
			writeOutput("<opaqueData>
			<dataDescriptor>#arguments.dataDescriptor#</dataDescriptor>
			<dataValue>#arguments.dataValue#</dataValue>
			</opaqueData>");
		}
		writeOutput("</payment>");
		if ( arguments.invoice is not "" or arguments.description is not "" ) {
			writeOutput("<order>");
			if ( arguments.invoice is not "" ) {
				writeOutput("<invoiceNumber>#arguments.invoice#</invoiceNumber>");
			}
			if ( arguments.description is not "" ) {
				writeOutput("<description>#myXMLFormat(arguments.description, arguments.useXmlFormat)#</description>");
			}
			writeOutput("</order>");
		}
		if ( arguments.merchantCustomerId is not "" or arguments.email is not "" or arguments.phoneNumber is not "" or arguments.faxNumber is not "" ) {
			writeOutput("<customer>");
			if ( arguments.merchantCustomerId is not "" ) {
				writeOutput("<id>#arguments.merchantCustomerId#</id>");
			}
			if ( arguments.email is not "" ) {
				writeOutput("<email>#arguments.email#</email>");
			}
			if ( arguments.phoneNumber is not "" ) {
				writeOutput("<phoneNumber>#rereplace(arguments.phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>");
			}
			if ( arguments.faxNumber is not "" ) {
				writeOutput("<faxNumber>#rereplace(arguments.faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>");
			}
			writeOutput("</customer>");
		}
		if ( arguments.firstName is not "" or arguments.lastName is not "" or arguments.company is not "" or arguments.address is not "" or arguments.city is not "" or arguments.state is not "" or arguments.zip is not "" or arguments.country is not "" ) {
			writeOutput("<billTo>");
			if ( arguments.firstName is not "" ) {
				writeOutput("<firstName>#myXMLFormat(arguments.firstName, arguments.useXmlFormat)#</firstName>");
			}
			if ( arguments.lastName is not "" ) {
				writeOutput("<lastName>#myXMLFormat(arguments.lastName, arguments.useXmlFormat)#</lastName>");
			}
			if ( arguments.company is not "" ) {
				writeOutput("<company>#myXMLFormat(arguments.company, arguments.useXmlFormat)#</company>");
			}
			if ( arguments.address is not "" ) {
				writeOutput("<address>#myXMLFormat(arguments.address, arguments.useXmlFormat)#</address>");
			}
			if ( arguments.city is not "" ) {
				writeOutput("<city>#myXMLFormat(arguments.city, arguments.useXmlFormat)#</city>");
			}
			if ( arguments.state is not "" ) {
				writeOutput("<state>#arguments.state#</state>");
			}
			if ( arguments.zip is not "" ) {
				writeOutput("<zip>#myXMLFormat(arguments.zip, arguments.useXmlFormat)#</zip>");
			}
			if ( arguments.country is not "" ) {
				writeOutput("<country>#myXMLFormat(arguments.country, arguments.useXmlFormat)#</country>");
			}
			writeOutput("</billTo>");
		}
		if ( arguments.ship_firstName is not "" or arguments.ship_lastName is not "" or arguments.ship_company is not "" or arguments.ship_address is not "" or arguments.ship_city is not "" or arguments.ship_state is not "" or arguments.ship_zip is not "" or arguments.ship_country is not "" ) {
			writeOutput("<shipTo>");
			if ( arguments.ship_firstName is not "" ) {
				writeOutput("<firstName>#myXMLFormat(arguments.ship_firstName, arguments.useXmlFormat)#</firstName>");
			}
			if ( arguments.ship_lastName is not "" ) {
				writeOutput("<lastName>#myXMLFormat(arguments.ship_lastName, arguments.useXmlFormat)#</lastName>");
			}
			if ( arguments.ship_company is not "" ) {
				writeOutput("<company>#myXMLFormat(arguments.ship_company, arguments.useXmlFormat)#</company>");
			}
			if ( arguments.ship_address is not "" ) {
				writeOutput("<address>#myXMLFormat(arguments.ship_address, arguments.useXmlFormat)#</address>");
			}
			if ( arguments.ship_city is not "" ) {
				writeOutput("<city>#myXMLFormat(arguments.ship_city, arguments.useXmlFormat)#</city>");
			}
			if ( arguments.ship_state is not "" ) {
				writeOutput("<state>#arguments.ship_state#</state>");
			}
			if ( arguments.ship_zip is not "" ) {
				writeOutput("<zip>#myXMLFormat(arguments.ship_zip, arguments.useXmlFormat)#</zip>");
			}
			if ( arguments.ship_country is not "" ) {
				writeOutput("<country>#myXMLFormat(arguments.ship_country, arguments.useXmlFormat)#</country>");
			}
			writeOutput("</shipTo>");
		}
		writeOutput("</subscription>
		</ARBCreateSubscriptionRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBCreateSubscriptionResponse.refId.XmlText;
		response.subscriptionId = response.XmlResponse.ARBCreateSubscriptionResponse.subscriptionId.XmlText;
		if ( isDefined('response.XmlResponse.ARBCreateSubscriptionResponse.validationDirectResponse') ) {
			response.resultstring = response.XmlResponse.ARBCreateSubscriptionResponse.validationDirectResponse.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}

	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBCreateSubscription()

public struct function ARBCreateSubscriptionFromProfile(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string subscriptionName="",
	any length="",
	string unit="",
	any startDate="",
	any totalOccurrences="",
	any trialOccurrences="",
	any amount="",
	any trialAmount="",
	string invoice="",
	string description="",
	string customerProfileId="",
	string customerPaymentProfileId="",
	string customerAddressId="",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Creates an Automated Recurring Billing Subscription from Prfile." {

	var response = StructNew();
	var temp	= "";
	var result = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.subscriptionId = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
		<ARBCreateSubscriptionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
		<merchantAuthentication>
		<name>#arguments.name#</name>
		<transactionKey>#arguments.transactionKey#</transactionKey>
		</merchantAuthentication>
		<refId>#arguments.refId#</refId>
		<subscription>
		<name>#myXMLFormat(arguments.subscriptionname, arguments.useXmlFormat)#</name>
		<paymentSchedule>
		<interval>
		<length>#arguments.length#</length>
		<unit>#arguments.unit#</unit>
		</interval>
		<startDate>#DateFormat(arguments.startDate, "yyyy-mm-dd")#</startDate>
		<totalOccurrences>#arguments.totalOccurrences#</totalOccurrences>");
		if ( isNumeric(arguments.trialOccurrences) and arguments.trialOccurrences GT 0 ) {
			writeOutput("<trialOccurrences>#arguments.trialOccurrences#</trialOccurrences>");
		}
		writeOutput("</paymentSchedule>
		<amount>#rereplace(decimalFormat(rereplace(arguments.amount, "[^0-9\.-]+", "", "ALL")), "[^0-9\.-]+", "", "ALL")#</amount>");
		if ( isNumeric(arguments.trialOccurrences) and arguments.trialOccurrences GT 0 ) {
			writeOutput("<trialAmount>");
			if ( isNumeric(arguments.trialAmount) ) {
				writeOutput("#arguments.trialAmount#");
			} else {
				writeOutput("0.00");
			}
			writeOutput("</trialAmount>");
		}
		writeOutput("<order>
		<invoiceNumber>#arguments.invoice#</invoiceNumber>
		<description>#myXMLFormat(arguments.description, arguments.useXmlFormat)#</description>
		</order>
		<profile>
		<customerProfileId>#arguments.customerProfileId#</customerProfileId>
        <customerPaymentProfileId>#arguments.customerPaymentProfileId#</customerPaymentProfileId>");
        if ( isNumeric(arguments.customerAddressId) and len(arguments.customerAddressId) ) {
			writeOutput("<customerAddressId>#arguments.customerAddressId#</customerAddressId>");
		}
		writeOutput("</profile>
		</subscription>
		</ARBCreateSubscriptionRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBCreateSubscriptionResponse.refId.XmlText;
		response.subscriptionId = response.XmlResponse.ARBCreateSubscriptionResponse.subscriptionId.XmlText;
		if ( isDefined('response.XmlResponse.ARBCreateSubscriptionResponse.validationDirectResponse') ) {
			response.resultstring = response.XmlResponse.ARBCreateSubscriptionResponse.validationDirectResponse.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}

	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBCreateSubscriptionFromProfile()

public struct function ARBGetSubscription(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string subscriptionId="",
	boolean includeTransactions="false") hint="Gets the status of an Automated Recurring Billing Subscription." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.subscriptionId = arguments.subscriptionId;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<ARBGetSubscriptionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<subscriptionId>#arguments.subscriptionId#</subscriptionId>
			<includeTransactions>#arguments.includeTransactions#</includeTransactions>
			</ARBGetSubscriptionRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBGetSubscriptionResponse.refId.XmlText;
		// Do results to query?
	}

	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBGetSubscription()

public struct function ARBGetSubscriptionStatus(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string subscriptionId="") hint="Gets the status of an Automated Recurring Billing Subscription." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.subscriptionId = arguments.subscriptionId;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<ARBGetSubscriptionStatusRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<subscriptionId>#arguments.subscriptionId#</subscriptionId>
			</ARBGetSubscriptionStatusRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBGetSubscriptionStatusResponse.refId.XmlText;
		response.status = response.XmlResponse.ARBGetSubscriptionStatusResponse.status.XmlText;
	}

	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBGetSubscriptionStatus()

public struct function ARBUpdateSubscription(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string subscriptionId="",
	string subscriptionName="",
	any length="",
	string unit="",
	any startDate="",
	any totalOccurrences="",
	any trialOccurrences="",
	any amount="",
	any trialAmount="",
	string cardNumber="",
	string expirationDate="", // YYYY-MM
	string cardCode="",
	string accountType="", // checking,savings,businessChecking
	string routingNumber="", // 9 digits
	string accountNumber="", // 5 to 17 digits
	string nameOnAccount="", // full name as listed on the bank account Up to 22 characters
	string echeckType="", // Optional,CCD,PPD,TEL,WEB (we use WEB)
	string bankName="", // Optional Up to 50 characters
	string merchantCustomerId,
	string invoice,
	string description,
	string email,
	string phoneNumber, // Up to 25 digits (no letters) Ex. (123)123-1234
	string faxNumber, // Up to 25 digits (no letters) Ex. (123)123-1234
	string firstname, // Up to 50 characters (no symbols)
	string lastname, // Up to 50 characters (no symbols)
	string company, // Up to 50 characters (no symbols)
	string address, // Up to 60 characters (no symbols)
	string city, // Up to 40 characters (no symbols)
	string state, // Up to 40 characters (no symbols). US: A valid two-character state code
	string zip, // Up to 20 characters (no symbols)
	string country, // Up to 60 characters (no symbols)
	string ship_firstname, // Up to 50 characters (no symbols)
	string ship_lastname, // Up to 50 characters (no symbols)
	string ship_company, // Up to 50 characters (no symbols)
	string ship_address, // Up to 60 characters (no symbols)
	string ship_city, // Up to 40 characters (no symbols)
	string ship_state, // Up to 40 characters (no symbols). US: A valid two-character state code
	string ship_zip, // Up to 20 characters (no symbols)
	string ship_country, // Up to 60 characters (no symbols)
	string dataDescriptor="",
	string dataValue="",
	boolean useXmlFormat=variables.defaultXmlFormat) hint="Updates an Automated Recurring Billing Subscription." {

	var response = StructNew();
	var temp	= "";
	var result = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.subscriptionId = arguments.subscriptionId;

	if ( arguments.nameOnAccount is "" and isDefined('arguments.firstname') and isDefined('arguments.lastname') ) {
		nameOnAccount = Trim('#arguments.firstname# #arguments.lastname#');
	}

	if ( arguments.echeckType is "" and arguments.accountNumber is not "" ) {
		switch ( arguments.accountType ) {
			case "businessChecking":
				arguments.echeckType = "CCD";
				break;
			default:
				arguments.echeckType = "WEB";
				break;
		}
	}

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<ARBUpdateSubscriptionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<subscriptionId>#arguments.subscriptionId#</subscriptionId>
			<subscription>");
			if ( arguments.subscriptionname is not "" ) {
				writeOutput("<name>#myXMLFormat(arguments.subscriptionname, arguments.useXmlFormat)#</name>");
			}
			writeOutput("<paymentSchedule>");
			if ( arguments.length is not "" or arguments.unit is not "" ) {
				writeOutput("<interval>");
				if ( arguments.length is not "" ) {
					writeOutput("<length>#arguments.length#</length>");
				}
				if ( arguments.unit is not "" ) {
					writeOutput("<unit>#arguments.unit#</unit>");
				}
				writeOutput("</interval>");
			}
			if ( arguments.startDate is not "" or arguments.totalOccurrences is not "" or arguments.trialOccurrences is not "" ) {
				if ( arguments.startDate is not "" ) {
					writeOutput("<startDate>#DateFormat(arguments.startDate, "yyyy-mm-dd")#</startDate>");
				}
				if ( isNumeric(arguments.totalOccurrences) ) {
					writeOutput("<totalOccurrences>#arguments.totalOccurrences#</totalOccurrences>");
				}
				if ( isNumeric(arguments.trialOccurrences) ) {
					writeOutput("<trialOccurrences>#arguments.trialOccurrences#</trialOccurrences>");
				}
			}
			writeOutput("</paymentSchedule>");
			if ( isNumeric(arguments.amount) ) {
				writeOutput("<amount>#rereplace(decimalFormat(rereplace(arguments.amount, "[^0-9\.-]+", "", "ALL")), "[^0-9\.-]+", "", "ALL")#</amount>");
			}
			if ( isNumeric(arguments.trialAmount) ) {
				writeOutput("<trialAmount>#arguments.trialAmount#</trialAmount>");
			}
			if ( arguments.cardNumber is not "" or arguments.accountNumber is not "" or arguments.dataValue is not "" ) {
				writeOutput("<payment>");
				if ( arguments.cardNumber is not "" ) {
					writeOutput("<creditCard><cardNumber>");
					if ( len(arguments.cardNumber) is 4 ) {
						writeOutput("XXXX#arguments.cardNumber#");
					} else {
						writeOutput("#rereplace(arguments.cardNumber, "[^0-9]+", "", "ALL")#");
					}
					writeOutput("</cardNumber><expirationDate>#arguments.expirationDate#</expirationDate>");
					if ( arguments.cardCode is not "" ) {
						writeOutput("<cardCode>#arguments.cardCode#</cardCode>");
					}
					writeOutput("</creditCard>");
				} else if ( arguments.accountNumber is not "" ) {
					writeOutput("<bankAccount>
					<accountType>#arguments.accountType#</accountType>
					<routingNumber>#arguments.routingNumber#</routingNumber>
					<accountNumber>#arguments.accountNumber#</accountNumber>
					<nameOnAccount>#myXMLFormat(arguments.nameOnAccount, arguments.useXmlFormat)#</nameOnAccount>
					<echeckType>#arguments.echeckType#</echeckType>
					<bankName>#myXMLFormat(arguments.bankName, arguments.useXmlFormat)#</bankName>
					</bankAccount>");
				} else if ( arguments.dataValue is not "" ) {
					writeOutput("<opaqueData>
					<dataDescriptor>#arguments.dataDescriptor#</dataDescriptor>
					<dataValue>#arguments.dataValue#</dataValue>
					</opaqueData>");
				}
				writeOutput("</payment>");
			}
			if ( arguments.invoice is not "" or arguments.description is not "" ) {
				writeOutput("<order>");
				if ( arguments.invoice is not "" ) {
					writeOutput("<invoiceNumber>#arguments.invoice#</invoiceNumber>");
				}
				if ( arguments.description is not "" ) {
					writeOutput("<description>#myXMLFormat(arguments.description, arguments.useXmlFormat)#</description>");
				}
				writeOutput("</order>");
			}
			if ( arguments.merchantCustomerId is not "" or arguments.email is not "" or arguments.phoneNumber is not "" or arguments.faxNumber is not "" ) {
				writeOutput("<customer>");
				if ( arguments.merchantCustomerId is not "" ) {
					writeOutput("<id>#arguments.merchantCustomerId#</id>");
				}
				if ( arguments.email is not "" ) {
					writeOutput("<email>#arguments.email#</email>");
				}
				if ( arguments.phoneNumber is not "" ) {
					writeOutput("<phoneNumber>#rereplace(arguments.phoneNumber, "[^0-9-()]+", "", "ALL")#</phoneNumber>");
				}
				if ( arguments.faxNumber is not "" ) {
					writeOutput("<faxNumber>#rereplace(arguments.faxNumber, "[^0-9-()]+", "", "ALL")#</faxNumber>");
				}
				writeOutput("</customer>");
			}
			if ( arguments.firstName is not "" or arguments.lastName is not "" or arguments.company is not "" or arguments.address is not "" or arguments.city is not "" or arguments.state is not "" or arguments.zip is not "" or arguments.country is not "" ) {
				writeOutput("<billTo>");
				if ( arguments.firstName is not "" ) {
					writeOutput("<firstName>#myXMLFormat(arguments.firstName, arguments.useXmlFormat)#</firstName>");
				}
				if ( arguments.lastName is not "" ) {
					writeOutput("<lastName>#myXMLFormat(arguments.lastName, arguments.useXmlFormat)#</lastName>");
				}
				if ( arguments.company is not "" ) {
					writeOutput("<company>#myXMLFormat(arguments.company, arguments.useXmlFormat)#</company>");
				}
				if ( arguments.address is not "" ) {
					writeOutput("<address>#myXMLFormat(arguments.address, arguments.useXmlFormat)#</address>");
				}
				if ( arguments.city is not "" ) {
					writeOutput("<city>#myXMLFormat(arguments.city, arguments.useXmlFormat)#</city>");
				}
				if ( arguments.state is not "" ) {
					writeOutput("<state>#arguments.state#</state>");
				}
				if ( arguments.zip is not "" ) {
					writeOutput("<zip>#myXMLFormat(arguments.zip, arguments.useXmlFormat)#</zip>");
				}
				if ( arguments.country is not "" ) {
					writeOutput("<country>#myXMLFormat(arguments.country, arguments.useXmlFormat)#</country>");
				}
				writeOutput("</billTo>");
			}
			if ( arguments.ship_firstName is not "" or arguments.ship_lastName is not "" or arguments.ship_company is not "" or arguments.ship_address is not "" or arguments.ship_city is not "" or arguments.ship_state is not "" or arguments.ship_zip is not "" or arguments.ship_country is not "" ) {
				writeOutput("<shipTo>");
				if ( arguments.ship_firstName is not "" ) {
					writeOutput("<firstName>#myXMLFormat(arguments.ship_firstName, arguments.useXmlFormat)#</firstName>");
				}
				if ( arguments.ship_lastName is not "" ) {
					writeOutput("<lastName>#myXMLFormat(arguments.ship_lastName, arguments.useXmlFormat)#</lastName>");
				}
				if ( arguments.ship_company is not "" ) {
					writeOutput("<company>#myXMLFormat(arguments.ship_company, arguments.useXmlFormat)#</company>");
				}
				if ( arguments.ship_address is not "" ) {
					writeOutput("<address>#myXMLFormat(arguments.ship_address, arguments.useXmlFormat)#</address>");
				}
				if ( arguments.ship_city is not "" ) {
					writeOutput("<city>#myXMLFormat(arguments.ship_city, arguments.useXmlFormat)#</city>");
				}
				if ( arguments.ship_state is not "" ) {
					writeOutput("<state>#arguments.ship_state#</state>");
				}
				if ( arguments.ship_zip is not "" ) {
					writeOutput("<zip>#myXMLFormat(arguments.ship_zip, arguments.useXmlFormat)#</zip>");
				}
				if ( arguments.ship_country is not "" ) {
					writeOutput("<country>#myXMLFormat(arguments.ship_country, arguments.useXmlFormat)#</country>");
				}
				writeOutput("</shipTo>");
			}
			writeOutput("</subscription>
			</ARBUpdateSubscriptionRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBUpdateSubscriptionResponse.refId.XmlText;
		if ( isDefined('response.XmlResponse.ARBUpdateSubscriptionResponse.validationDirectResponse') ) {
			response.resultstring = response.XmlResponse.ARBUpdateSubscriptionResponse.validationDirectResponse.XmlText;
			if ( variables.parseValidationResult ) {
				result = parseResult(mystring=response.resultstring,argumentcollection=arguments);
				if ( isStruct(result) ) {
					for ( i in listToArray(StructKeyList(result), ",") ) { 
						tmp = StructInsert(response, i, StructFind(result, i), true);
					}
				} else {
					throw ( message=result );
				}
			}
		}
	}

	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBUpdateSubscription()

public struct function ARBCancelSubscription(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string subscriptionId="") hint="Cancels an Automated Recurring Billing Subscription." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.subscriptionId = arguments.subscriptionId;

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<ARBCancelSubscriptionRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<subscriptionId>#arguments.subscriptionId#</subscriptionId>
			</ARBCancelSubscriptionRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBCancelSubscriptionResponse.refId.XmlText;
	}

	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBCancelSubscription()

public struct function ARBGetSubscriptionList(
	string refId="", // Included in response. 20 char max.
	string name=variables.name,
	string transactionkey=variables.transactionKey,
	string error_email_from="",
	string error_email_to="",
	string error_subject="AutNetTools.cfc Error",
	string error_smtp="",
	string searchType="subscriptionActive",
	string orderBy="id",
	boolean orderDescending="false",
	numeric pageLimit=10,
	numeric offset=1) hint="Get all ARB Subscriptions matching searchType." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<ARBGetSubscriptionListRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>
			<refId>#arguments.refId#</refId>
			<searchType>#arguments.searchType#</searchType>
			<sorting>
			<orderBy>#arguments.orderBy#</orderBy>
			<orderDescending>#arguments.orderDescending#</orderDescending>
			</sorting>
			<paging>
			<limit>#arguments.pageLimit#</limit>
			<offset>#arguments.offset#</offset>
			</paging>
			</ARBGetSubscriptionListRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		response.refId = response.XmlResponse.ARBGetSubscriptionListResponse.refId.XmlText;
		response.subscriptionDetails = QueryNew("subscriptionId,name,status,createdUTC,firstName,lastName,totalOccurrences,pastOccurrences,paymentMethod,accountnumber,invoice,amount,currencyCode,customerProfileId,customerPaymentProfileId,customerShippingProfileId");
		if ( structkeyexists(response.XmlResponse.ARBGetSubscriptionListResponse, "subscriptionDetails") ) {
			subscriptionDetails = response.XmlResponse.ARBGetSubscriptionListResponse.subscriptionDetails.subscriptionDetail;
			for ( i = 1; i <= arraylen(subscriptionDetails); i++ ) {
				temp = queryAddRow(response.subscriptionDetails);
				temp = querySetCell(response.subscriptionDetails, 'subscriptionId', subscriptionDetails[i].id.XmlText);
				temp = querySetCell(response.subscriptionDetails, 'name', subscriptionDetails[i].name.XmlText);
				temp = querySetCell(response.subscriptionDetails, 'status', subscriptionDetails[i].status.XmlText);
				temp = querySetCell(response.subscriptionDetails, 'createdUTC', subscriptionDetails[i].createTimeStampUTC.XmlText);
				if ( structkeyexists(subscriptionDetails[i], 'firstName') ) {
					temp = querySetCell(response.subscriptionDetails, 'firstName', subscriptionDetails[i].firstName.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'lastName') ) {
					temp = querySetCell(response.subscriptionDetails, 'lastName', subscriptionDetails[i].lastName.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'totalOccurrences') ) {
					temp = querySetCell(response.subscriptionDetails, 'totalOccurrences', subscriptionDetails[i].totalOccurrences.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'pastOccurrences') ) {
					temp = querySetCell(response.subscriptionDetails, 'pastOccurrences', subscriptionDetails[i].pastOccurrences.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'paymentMethod') ) {
					temp = querySetCell(response.subscriptionDetails, 'paymentMethod', subscriptionDetails[i].paymentMethod.XmlText);
					temp = querySetCell(response.subscriptionDetails, 'accountnumber', subscriptionDetails[i].accountnumber.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'invoice') ) {
					temp = querySetCell(response.subscriptionDetails, 'invoice', subscriptionDetails[i].invoice.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'amount') ) {
					temp = querySetCell(response.subscriptionDetails, 'amount', subscriptionDetails[i].amount.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'currencyCode') ) {
					temp = querySetCell(response.subscriptionDetails, 'currencyCode', subscriptionDetails[i].currencyCode.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'customerProfileId') ) {
					temp = querySetCell(response.subscriptionDetails, 'customerProfileId', subscriptionDetails[i].customerProfileId.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'customerPaymentProfileId') ) {
					temp = querySetCell(response.subscriptionDetails, 'customerPaymentProfileId', subscriptionDetails[i].customerPaymentProfileId.XmlText);
				}
				if ( structkeyexists(subscriptionDetails[i], 'customerShippingProfileId') ) {
					temp = querySetCell(response.subscriptionDetails, 'customerShippingProfileId', subscriptionDetails[i].customerShippingProfileId.XmlText);
				}
			}
		}
	}
	if ( response.error is not "" and arguments.error_email_to is not "" ) {
		temp = emailError(a=arguments, r=response);
	}
	return response;
} // end function ARBGetSubscriptionList()

public struct function getHostedProfilePage(struct authArgs, boolean useXmlFormat=variables.defaultXmlFormat) hint="Get Accept Customer Profile Page." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.token = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<getHostedProfilePageRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>");
		if ( isDefined("authArgs.refId") ) {
			writeOutput("<refId>#authArgs.refId#</refId>");
		}
		if ( isDefined("authArgs.customerProfileId") ) {
			writeOutput("<customerProfileId>#authArgs.customerProfileId#</customerProfileId>");
		}
		writeOutput("<hostedProfileSettings>");
		for ( i = 1; i <= arrayLen(authArgs.hostedProfileSettings.setting); i++ ) {
			writeOutput("<setting>
			<settingName>#authArgs.hostedProfileSettings.setting[i].settingName#</settingName>
			<settingValue>#authArgs.hostedProfileSettings.setting[i].settingValue#</settingValue>
			</setting>");
		}
		writeOutput("</hostedProfileSettings></getHostedProfilePageRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		if ( isDefined("response.XmlResponse.getHostedProfilePageResponse.refId") ) {
			response.refId = response.XmlResponse.getHostedProfilePageResponse.refId.XmlText;
		}
		response.token = response.XmlResponse.getHostedProfilePageResponse.token.XmlText;
	}

	param name="authArgs.error_email_from" default="";
	param name="authArgs.error_email_to" default="";
	param name="authArgs.error_subject" default="AutNetTools.cfc Error";
	param name="authArgs.error_smtp" default="";
	email.error_email_from=authArgs.error_email_from;
	email.error_email_to=authArgs.error_email_from;
	email.error_subject=authArgs.error_subject;
	email.error_smtp=authArgs.error_smtp;
	if ( response.error is not "" and authArgs.error_email_to is not "" ) {
		temp = emailError(a=authArgs, r=response);
	}
	return response;
} // end function getHostedProfilePage()

public struct function getHostedPaymentPage(struct authArgs, boolean useXmlFormat=variables.defaultXmlFormat) hint="Get an Accept Payment Page." {

	var response = StructNew();
	var temp	= "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.environment = variables.environment; // xml error codes
	response.XmlRequest = "";
	response.XmlResponse = "";
	response.refId = "";
	response.token = "";

	savecontent variable="myXml" {
		writeOutput("<?xml version=""1.0"" encoding=""utf-8""?>
			<getHostedPaymentPageRequest xmlns=""AnetApi/xml/v1/schema/AnetApiSchema.xsd"">
			<merchantAuthentication>
			<name>#arguments.name#</name>
			<transactionKey>#arguments.transactionKey#</transactionKey>
			</merchantAuthentication>");
		if ( isDefined("authArgs.refId") ) {
			writeOutput("<refId>#authArgs.refId#</refId>");
		}
		writeOutput("<transactionRequest>
			<transactionType>#authArgs.transactionRequest.transactionType#</transactionType>
			<amount>#authArgs.transactionRequest.amount#</amount>");
		if ( isDefined('authArgs.transactionRequest.profile.customerProfileId') ) {
			writeOutput("<profile>
			<customerProfileId>#authArgs.transactionRequest.profile.customerProfileId#</customerProfileId>
			</profile>");
		}
		if ( isDefined('authArgs.transactionRequest.order') ) {
			writeOutput("<order>");
			if ( isDefined('authArgs.transactionRequest.order.invoice') ) {
				writeOutput("<invoiceNumber>#authArgs.transactionRequest.order.invoice#</invoiceNumber>");
			}
			if ( isDefined('authArgs.transactionRequest.order.description') ) {
				writeOutput("<description>#myXMLFormat(authArgs.transactionRequest.order.description, arguments.useXmlFormat)#</description>");
			}
			writeOutput("</order>");
		}
		if ( isDefined("authArgs.transactionRequest.lineItems") ) {
			writeOutput("<lineItems>");
				for ( i = 1; i <= arrayLen(authArgs.transactionRequest.lineItems.lineItem); i++ ) {
					writeOutput("<lineItem>");
					if ( isDefined("authArgs.transactionRequest.lineItems.lineItem[i].itemId") ) {
						writeOutput("<itemId>#myXMLFormat(authArgs.transactionRequest.lineItems.lineItem[i].itemId, arguments.useXmlFormat)#</itemId>");
					}
					if ( isDefined("authArgs.transactionRequest.lineItems.lineItem[i].name") ) {
						writeOutput("<name>#myXMLFormat(authArgs.transactionRequest.lineItems.lineItem[i].name, arguments.useXmlFormat)#</name>");
					}
					if ( isDefined("authArgs.transactionRequest.lineItems.lineItem[i].description") ) {
						writeOutput("<description>#myXMLFormat(authArgs.transactionRequest.lineItems.lineItem[i].description, arguments.useXmlFormat)#</description>");
					}
					if ( isDefined("authArgs.transactionRequest.lineItems.lineItem[i].quantity") ) {
						writeOutput("<quantity>#authArgs.transactionRequest.lineItems.lineItem[i].quantity#</quantity>");
					}
					if ( isDefined("authArgs.transactionRequest.lineItems.lineItem[i].unitPrice") ) {
						writeOutput("<unitPrice>#authArgs.transactionRequest.lineItems.lineItem[i].unitPrice#</unitPrice>");
					}
					if ( isDefined("authArgs.transactionRequest.lineItems.lineItem[i].taxable") ) {
						writeOutput("<taxable>#authArgs.transactionrequest.lineItems.lineItem[i].taxable#</taxable>");
					}
					writeOutput("</lineItem>");
				}
			writeOutput("</lineItems>");
		}
		if ( isDefined("authArgs.transactionrequest.tax") ) {
			writeOutput("<tax>");
				if ( isDefined("authArgs.transactionrequest.tax.amount") ) {
					writeOutput("<amount>#authArgs.transactionrequest.tax.amount#</amount>");
				}
				if ( isDefined("authArgs.transactionrequest.tax.name") ) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.tax.name, arguments.useXmlFormat)#</name>");
				}
				if ( isDefined("authArgs.transactionrequest.tax.description") ) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.tax.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</tax>");
		}
		if ( isDefined("authArgs.transactionrequest.duty") ) {
			writeOutput("<duty>");
				if ( isDefined("authArgs.transactionrequest.duty.amount") ) {
					writeOutput("<amount>#authArgs.transactionrequest.duty.amount#</amount>");
				}
				if ( isDefined("authArgs.transactionrequest.duty.name") ) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.duty.name, arguments.useXmlFormat)#</name>");
				}
				if ( isDefined("authArgs.transactionrequest.duty.description") ) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.duty.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</duty>");
		}
		if ( isDefined("authArgs.transactionrequest.shipping") ) {
			writeOutput("<shipping>");
				if ( isDefined("authArgs.transactionrequest.shipping.amount") ) {
					writeOutput("<amount>#authArgs.transactionrequest.shipping.amount#</amount>");
				}
				if ( isDefined("authArgs.transactionrequest.shipping.name") ) {
					writeOutput("<name>#myXMLFormat(authArgs.transactionrequest.shipping.name, arguments.useXmlFormat)#</name>");
				}
				if ( isDefined("authArgs.transactionrequest.shipping.description") ) {
					writeOutput("<description>#myXMLFormat(authArgs.transactionrequest.shipping.description, arguments.useXmlFormat)#</description>");
				}
			writeOutput("</shipping>");
		}
		if ( isDefined("authArgs.transactionrequest.taxExempt") ) {
			writeOutput("<taxExempt>#authArgs.transactionrequest.taxExempt#</taxExempt>");
		}
		if ( isDefined("authArgs.transactionrequest.poNumber") ) {
			writeOutput("<poNumber>#authArgs.transactionrequest.poNumber#</poNumber>");
		}
		if ( isDefined("authArgs.transactionrequest.customer") ) {
			writeOutput("<customer>");
				if ( isDefined("authArgs.transactionrequest.customer.type") ) {
					writeOutput("<type>#authArgs.transactionrequest.customer.type#</type>");
				}
				if ( isDefined("authArgs.transactionrequest.customer.id") ) {
					writeOutput("<id>#authArgs.transactionrequest.customer.id#</id>");
				}
				if ( isDefined("authArgs.transactionrequest.customer.email") ) {
					writeOutput("<email>#authArgs.transactionrequest.customer.email#</email>");
				}
			writeOutput("</customer>");
		}
		if ( isDefined('authArgs.transactionRequest.billTo') ) {
			writeOutput("<billTo>");
			if ( isDefined('authArgs.transactionRequest.billTo.firstName') ) {
				writeOutput("<firstName>#myXMLFormat(authArgs.transactionRequest.billTo.firstName, arguments.useXmlFormat)#</firstName>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.lastName') ) {
				writeOutput("<lastName>#myXMLFormat(authArgs.transactionRequest.billTo.lastName, arguments.useXmlFormat)#</lastName>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.company') ) {
				writeOutput("<company>#myXMLFormat(authArgs.transactionRequest.billTo.company, arguments.useXmlFormat)#</company>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.address') ) {
				writeOutput("<address>#myXMLFormat(authArgs.transactionRequest.billTo.address, arguments.useXmlFormat)#</address>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.city') ) {
				writeOutput("<city>#myXMLFormat(authArgs.transactionRequest.billTo.city, arguments.useXmlFormat)#</city>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.state') ) {
				writeOutput("<state>#authArgs.transactionRequest.billTo.state#</state>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.zip') ) {
				writeOutput("<zip>#myXMLFormat(authArgs.transactionRequest.billTo.zip, arguments.useXmlFormat)#</zip>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.country') ) {
				writeOutput("<country>#myXMLFormat(authArgs.transactionRequest.billTo.country, arguments.useXmlFormat)#</country>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.phoneNumber') ) {
				writeOutput("<phoneNumber>#myXMLFormat(authArgs.transactionRequest.billTo.phoneNumber, arguments.useXmlFormat)#</phoneNumber>");
			}
			if ( isDefined('authArgs.transactionRequest.billTo.faxNumber') ) {
				writeOutput("<faxNumber>#myXMLFormat(authArgs.transactionRequest.billTo.faxNumber, arguments.useXmlFormat)#</faxNumber>");
			}
			writeOutput("</billTo>");
		}
		if ( isDefined('authArgs.transactionRequest.shipTo') ) {
			writeOutput("<shipTo>");
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_firstName') ) {
				writeOutput("<firstName>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_firstName, arguments.useXmlFormat)#</firstName>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_lastName') ) {
				writeOutput("<lastName>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_lastName, arguments.useXmlFormat)#</lastName>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_company') ) {
				writeOutput("<company>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_company, arguments.useXmlFormat)#</company>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_address') ) {
				writeOutput("<address>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_address, arguments.useXmlFormat)#</address>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_city') ) {
				writeOutput("<city>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_city, arguments.useXmlFormat)#</city>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_state') ) {
				writeOutput("<state>#authArgs.transactionRequest.shipTo.ship_state#</state>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_zip') ) {
				writeOutput("<zip>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_zip, arguments.useXmlFormat)#</zip>");
			}
			if ( isDefined('authArgs.transactionRequest.shipTo.ship_country') ) {
				writeOutput("<country>#myXMLFormat(authArgs.transactionRequest.shipTo.ship_country, arguments.useXmlFormat)#</country>");
			}
			writeOutput("</shipTo>");
		}
		writeOutput("</transactionRequest>
		<hostedPaymentSettings>");
		for ( i = 1; i <= arrayLen(authArgs.hostedPaymentSettings.setting); i++ ) {
			writeOutput("<setting>
			<settingName>#authArgs.hostedPaymentSettings.setting[i].settingName#</settingName>
			<settingValue>#authArgs.hostedPaymentSettings.setting[i].settingValue#</settingValue>
			</setting>");
		}
		writeOutput("</hostedPaymentSettings></getHostedPaymentPageRequest>");
	}

	response.XmlRequest = xmlParse(myXml);

	response = getAPIResponse(response);
	if ( response.errorcode is "0" ) {
		if ( isDefined("response.XmlResponse.getHostedPaymentPageResponse.refId") ) {
			response.refId = response.XmlResponse.getHostedPaymentPageResponse.refId.XmlText;
		}
		response.token = response.XmlResponse.getHostedPaymentPageResponse.token.XmlText;
	}

	param name="authArgs.error_email_from" default="";
	param name="authArgs.error_email_to" default="";
	param name="authArgs.error_subject" default="AutNetTools.cfc Error";
	param name="authArgs.error_smtp" default="";
	email.error_email_from=authArgs.error_email_from;
	email.error_email_to=authArgs.error_email_from;
	email.error_subject=authArgs.error_subject;
	email.error_smtp=authArgs.error_smtp;
	if ( response.error is not "" and authArgs.error_email_to is not "" ) {
		temp = emailError(a=authArgs, r=response);
	}
	return response;
} // end function getHostedPaymentPage()

public string function convertExp(string expirationDate) hint="Convert old MMYY to YYYY-MM format" {
	newExp = "20#right(arguments.expirationDate, 2)#-#left(arguments.expirationDate, 2)#";
	return newExp;
} // end function convertExp()

public struct function getAPIResponse(struct inResponse) hint="Get API Response." {

	response = arguments.inResponse;
	response.response_code = "3";
	try {
		httpService = new http(method = "POST", url = variables.url_API, throwOnError="yes"); 
		httpService.addParam(type="XML", name="xml", value=arguments.inResponse.xmlrequest);
		result = httpService.send().getPrefix();
		response.XmlResponse = REReplace(result.FileContent, "^[^<]*", "", "all" );
		response.XmlResponse = xmlParse(response.XmlResponse);
		// Check for API error
		if ( isDefined("response.XmlResponse.ErrorResponse.messages.message") ) {
			response.error = response.XmlResponse.ErrorResponse.messages.message[1].text.XmlText;
			response.errorcode = response.XmlResponse.ErrorResponse.messages.message[1].code.XmlText;
		} else {
			resultCode = xmlSearch(response.XmlResponse, "//*[local-name() = 'messages']/*[local-name() = 'resultCode']");
			errortext = xmlSearch(response.XmlResponse,"//*[local-name() = 'messages']/*[local-name() = 'message']/*[local-name() = 'text']");
			errorcode = xmlSearch(response.XmlResponse,"//*[local-name() = 'messages']/*[local-name() = 'message']/*[local-name() = 'code']");
			// CIM/ARB only checks resultCode. Payments also needs check for transactionResponse errors for decline
			if ( resultCode[1].XmlText is "Ok" and errorcode[1].XmlText is "I00001" and not isDefined("response.XmlResponse.createTransactionResponse.transactionResponse.errors") ) {
				response.response_code = "1";
				response.error = "";
				response.errorcode = "0";
			} else {
				response.response_code = "2";
				response.error = errortext[1].XmlText;
				response.errorcode = errorcode[1].XmlText;
				if ( isDefined("response.XmlResponse.createTransactionResponse.transactionResponse.errors.error.errorCode") ) {
					response.reason_code = response.XmlResponse.createTransactionResponse.transactionResponse.errors.error.errorCode.XmlText;
					response.reason_text = response.XmlResponse.createTransactionResponse.transactionResponse.errors.error.errorText.XmlText;
					response.error = response.reason_text;
					response.errorcode = response.reason_code;
				}
			}
		}
	} // end try
	catch ( any e ) {
		response.errorcode = "404";
		if ( cfcatch.detail is "" ) {
			response.error = "#cfcatch.message#";
		} else {
			response.error = "#cfcatch.message# - #cfcatch.detail#";
		}
	} // end catch
	return response;
}

public struct function xmlToQryCustomerProfile(struct xmlrequest) hint="Returns the payment profiles and addresses from getCustomerProfile in query form." {

	var response = StructNew();
	var temp	= "";
	var profile = "";
	var PaymentProfiles = "";
	var ShipToList = "";
	var i = "";

	response.error = ""; // xml errors
	response.errorcode = "0";
	response.PaymentProfiles = QueryNew("customerProfileId,merchantCustomerId,email,paymentprofiledescription,customerPaymentProfileId,customerType,address,city,company,country,faxnumber,firstName,lastName,phonenumber,state,zip,PaymentProfileType,cardnumber,expirationdate,accountnumber,accounttype,bankname,echecktype,nameonaccount,routingnumber");
	response.Addresses = QueryNew("customerProfileId,merchantCustomerId,email,addressdescription,customerAddressId,address,city,company,country,faxnumber,firstName,lastName,phonenumber,state,zip");
	profile = xmlrequest.getCustomerProfileResponse.profile;
	if ( structkeyexists(xmlrequest.getCustomerProfileResponse.profile, "paymentprofiles") ) {
		paymentprofiles = xmlrequest.getCustomerProfileResponse.profile.paymentprofiles;
		for ( i = 1; i <= arraylen(paymentprofiles); i++ ) {
			temp = queryAddRow(response.PaymentProfiles);
			temp = querySetCell(response.PaymentProfiles, 'customerProfileId', profile.customerProfileId.XmlText);
			temp = querySetCell(response.PaymentProfiles, 'merchantCustomerId', profile.merchantCustomerId.XmlText);
			temp = querySetCell(response.PaymentProfiles, 'customerPaymentProfileId', PaymentProfiles[i].customerPaymentProfileId.XmlText);
			temp = querySetCell(response.PaymentProfiles, 'email', profile.email.XmlText);
			if ( structkeyexists(PaymentProfiles[i], 'customerType') ) {
				temp = querySetCell(response.PaymentProfiles, 'customerType', PaymentProfiles[i].customerType.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'company') ) {
				temp = querySetCell(response.PaymentProfiles, 'company', PaymentProfiles[i].billTo.company.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'faxnumber') ) {
				temp = querySetCell(response.PaymentProfiles, 'faxnumber', PaymentProfiles[i].billTo.faxnumber.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'phonenumber') ) {
				temp = querySetCell(response.PaymentProfiles, 'phonenumber', PaymentProfiles[i].billTo.phonenumber.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'address') ) {
				temp = querySetCell(response.PaymentProfiles, 'address', PaymentProfiles[i].billTo.address.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'city') ) {
				temp = querySetCell(response.PaymentProfiles, 'city', PaymentProfiles[i].billTo.city.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'country') ) {
				temp = querySetCell(response.PaymentProfiles, 'country', PaymentProfiles[i].billTo.country.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'firstName') ) {
				temp = querySetCell(response.PaymentProfiles, 'firstName', PaymentProfiles[i].billTo.firstName.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'lastName') ) {
				temp = querySetCell(response.PaymentProfiles, 'lastName', PaymentProfiles[i].billTo.lastName.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'state') ) {
				temp = querySetCell(response.PaymentProfiles, 'state', PaymentProfiles[i].billTo.state.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].billTo, 'zip') ) {
				temp = querySetCell(response.PaymentProfiles, 'zip', PaymentProfiles[i].billTo.zip.XmlText);
			}
			if ( structkeyexists(PaymentProfiles[i].payment, 'creditCard') ) {
				temp = querySetCell(response.PaymentProfiles, 'PaymentProfileType', 'credit');
				temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#PaymentProfiles[i].billTo.firstName.XmlText# #PaymentProfiles[i].billTo.lastname.XmlText# (credit card #PaymentProfiles[i].payment.creditCard.cardnumber.XmlText#)');
				temp = querySetCell(response.PaymentProfiles, 'cardnumber', PaymentProfiles[i].payment.creditCard.cardnumber.XmlText);
				temp = querySetCell(response.PaymentProfiles, 'expirationdate', PaymentProfiles[i].payment.creditCard.expirationdate.XmlText);
			} else if ( structkeyexists(PaymentProfiles[i].payment, 'bankAccount') ) {
				temp = querySetCell(response.PaymentProfiles, 'PaymentProfileType', 'bank');
				temp = querySetCell(response.PaymentProfiles, 'accountnumber', PaymentProfiles[i].payment.bankAccount.accountnumber.XmlText);
				if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'accounttype') ) {
					temp = querySetCell(response.PaymentProfiles, 'accounttype', PaymentProfiles[i].payment.bankAccount.accounttype.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'bankname') ) {
					temp = querySetCell(response.PaymentProfiles, 'bankname', PaymentProfiles[i].payment.bankAccount.bankname.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'echecktype') ) {
					temp = querySetCell(response.PaymentProfiles, 'echecktype', PaymentProfiles[i].payment.bankAccount.echecktype.XmlText);
				}
				if ( structkeyexists(PaymentProfiles[i].payment.bankAccount, 'nameonaccount') ) {
					temp = querySetCell(response.PaymentProfiles, 'nameonaccount', PaymentProfiles[i].payment.bankAccount.nameonaccount.XmlText);
				}
				temp = querySetCell(response.PaymentProfiles, 'routingnumber', PaymentProfiles[i].payment.bankAccount.routingnumber.XmlText);
				switch ( response.PaymentProfiles.accounttype[i] ) {
					case "checking":
						temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (checking account #response.PaymentProfiles.accountnumber[i]#)');
						break;
					case "businessChecking":
						temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (business checking #response.PaymentProfiles.accountnumber[i]#)');
						break;
					case "savings":
						temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (savings account #response.PaymentProfiles.accountnumber[i]#)');
						break;
					default:
						temp = querySetCell(response.PaymentProfiles, 'paymentprofiledescription', '#response.PaymentProfiles.nameonaccount[i]# (bank account #response.PaymentProfiles.accountnumber[i]#)');
						break;
				}
			}
		}
	}

	if ( structkeyexists(xmlrequest.getCustomerProfileResponse.profile, "shiptolist") ) {
		shiptolist = xmlrequest.getCustomerProfileResponse.profile.shiptolist;
		for ( i = 1; i <= arraylen(shiptolist); i++ ) {
			temp = queryAddRow(response.Addresses);
			temp = querySetCell(response.Addresses, 'customerProfileId', profile.customerProfileId.XmlText);
			temp = querySetCell(response.Addresses, 'merchantCustomerId', profile.merchantCustomerId.XmlText);
			temp = querySetCell(response.Addresses, 'email', profile.email.XmlText);
			temp = querySetCell(response.Addresses, 'customerAddressId', shiptolist[i].customerAddressId.XmlText);
			if ( structkeyexists(shiptolist[i], 'company') ){
				temp = querySetCell(response.Addresses, 'company', shiptolist[i].company.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'faxnumber') ) {
				temp = querySetCell(response.Addresses, 'faxnumber', shiptolist[i].faxnumber.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'phonenumber') ) {
				temp = querySetCell(response.Addresses, 'phonenumber', shiptolist[i].phonenumber.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'address') ) {
				temp = querySetCell(response.Addresses, 'address', shiptolist[i].address.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'city') ) {
				temp = querySetCell(response.Addresses, 'city', shiptolist[i].city.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'country') ) {
				temp = querySetCell(response.Addresses, 'country', shiptolist[i].country.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'firstName') ) {
				temp = querySetCell(response.Addresses, 'firstName', shiptolist[i].firstName.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'lastName') ) {
				temp = querySetCell(response.Addresses, 'lastname', shiptolist[i].lastName.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'state') ) {
				temp = querySetCell(response.Addresses, 'state', shiptolist[i].state.XmlText);
			}
			if ( structkeyexists(shiptolist[i], 'zip') ) {
				temp = querySetCell(response.Addresses, 'zip', shiptolist[i].zip.XmlText);
			}
			if ( response.Addresses.city[i] is not "" and response.Addresses.state[i] is not "" ) {
				temp = querySetCell(response.Addresses, 'addressdescription', '#response.Addresses.address[i]#, #response.Addresses.city[i]#, #response.Addresses.state[i]#');
			} else {
				temp = querySetCell(response.Addresses, 'addressdescription', '#response.Addresses.address[i]#, #response.Addresses.country[i]#');
			}
		}
	}
	return response;
} // end function xmlToQryCustomerProfile()

public boolean function emailError(struct a, struct r) {
	try {
		if ( arguments.a.error_smtp is not "" ) {
			savecontent variable="mailBody" {
				writeOutput("Error Code: #arguments.r.errorcode#");
				writeOutput("Error: #arguments.r.error#");
				if ( structkeyexists(arguments.a, "invoice") ) {
					writeOutput("arguments.a.invoice=#arguments.a.invoice#");
				}
				if ( structkeyexists(arguments.a, "merchantCustomerId") ) {
					writeOutput("arguments.a.merchantCustomerId=#arguments.a.merchantCustomerId#");
				}
			};
			mailService = new mail(
				server = "#arguments.a.error_smtp#",
				to = "#arguments.a.error_email_to#",
				from = "#arguments.a.error_email_from#",
				subject = "#arguments.a.error_subject#",
				body = mailBody
			);
			mailService.send();
		} else {
			savecontent variable="mailBody" {
				writeOutput("Error Code: #arguments.r.errorcode#");
				writeOutput("Error: #arguments.r.error#");
				if ( structkeyexists(arguments.a, "invoice") ) {
					writeOutput("arguments.a.invoice=#arguments.a.invoice#");
				}
				if ( structkeyexists(arguments.a, "merchantCustomerId") ) {
					writeOutput("arguments.a.merchantCustomerId=#arguments.a.merchantCustomerId#");
				}
			};
			mailService = new mail(
				to = "#arguments.a.error_email_to#",
				from = "#arguments.a.error_email_from#",
				subject = "#arguments.a.error_subject#",
				body = mailBody
			);
			mailService.send();
		}
		return true;
	} // end try
	catch ( any e ) {
		return false;
	} // end catch
} // end function emailError()

public string function myXMLFormat(string inStr, boolean useXmlFormat) hint="I encodeForXML the input if requested." {
	if ( arguments.useXmlFormat ) {
		return encodeForXML(arguments.inStr);
	}
	return inStr;
} // end function myXMLFormat()
		
}
