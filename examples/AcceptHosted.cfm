<cfscript>
authName = "";
authKey = "";

// Hosted Page Settings. Must have at least one setting.
setting_1 = structNew();
setting_1.settingName = "hostedPaymentReturnOptions";
setting_1.settingValue = '{"showReceipt": true, "url": "https://mysite.com/receipt", "urlText": "Continue", "cancelUrl": "https://mysite.com/cancel", "cancelUrlText": "Cancel"}';
setting_2 = structNew();
setting_2.settingName = "hostedPaymentButtonOptions";
setting_2.settingValue = '{"text": "Pay Me"}';

// build the array of page settings
hostedPaymentSettings = structNew();
hostedPaymentSettings.setting = arrayNew();
arrayAppend(hostedPaymentSettings.setting, setting_1);
arrayAppend(hostedPaymentSettings.setting, setting_2);

authArgs = structNew();
// Optional name and transactionKey
// authArgs.merchantAuthentication.name=authName;
// authArgs.merchantAuthentication.transactionKey=authKey;
authArgs.transactionrequest.transactionType = "authCaptureTransaction" // "authOnlyTransaction" for Authorize only
authArgs.transactionrequest.amount = "11.52";
authArgs.hostedPaymentSettings = hostedPaymentSettings;

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.getHostedPaymentPage(authArgs);
writeDump(var=AuthResp);
</cfscript>