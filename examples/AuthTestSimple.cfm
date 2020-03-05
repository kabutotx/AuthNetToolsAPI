<cfscript>
authName = "";
authKey = "";
authSignature=""; // Optional: Signature key for transHashSha2 check

// Authorize and/or Capture Credit Card
authArgs = structNew();
// Optional name and transactionKey
// authArgs.merchantAuthentication.name=authName;
// authArgs.merchantAuthentication.transactionKey=authKey;
authArgs.transactionRequest.payment.creditCard.cardNumber = "4111111111111111";
authArgs.transactionRequest.payment.creditCard.expirationDate = "2020-12";
authArgs.transactionrequest.transactionType = "authCaptureTransaction"; // "authOnlyTransaction" for Authorize only
authArgs.transactionrequest.amount = "11.52";
authArgs.transactionrequest.billTo.address= "14 Main Street";
authArgs.transactionrequest.billTo.zip= "44628";
authArgs.transactionrequest.order.invoiceNumber = "10101";

//AuthNetTools = createObject("component", "AuthNetToolsAPI").init(1, authName, authKey);
AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.authPaymentXML(authArgs);
writeDump(var=AuthResp);
// Optional: Auth transHashSha2 check
key=binaryDecode(authSignature, "hex" );
message = '^' & authName & '^' & AuthResp.trans_id & '^' & authArgs.transactionrequest.amount & '^';
hashResult = hmac(message, key, 'HMACSHA512');
writeDump(var=hashResult);

// Capture previous authorization
authArgs = structNew();
// Optional name and transactionKey
// authArgs.merchantAuthentication.name=authName;
// authArgs.merchantAuthentication.transactionKey=authKey;
authArgs.transactionrequest.transactionType = "priorAuthCaptureTransaction"
authArgs.transactionrequest.refTransId = "1234567890";
authArgs.transactionrequest.amount = "11.52";
authArgs.transactionrequest.billTo.address= "14 Main Street";
authArgs.transactionrequest.billTo.zip= "44628";
authArgs.transactionrequest.order.invoiceNumber = "10101";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.authPaymentXML(authArgs);
writeDump(var=AuthResp);

// Refund Transaction
authArgs = structNew();
// Optional name and transactionKey
// authArgs.merchantAuthentication.name=authName;
// authArgs.merchantAuthentication.transactionKey=authKey;
authArgs.transactionrequest.transactionType = "refundTransaction"
authArgs.transactionrequest.amount = "11.52";
authArgs.transactionRequest.payment.creditCard.cardNumber = "1111";
authArgs.transactionRequest.payment.creditCard.expirationDate = "2020-12";
authArgs.transactionrequest.refTransId = "1234567890"; // Conditional - Required without Expanded Credit-Return Capabilities

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.authPaymentXML(authArgs);
writeDump(var=AuthResp);

// Void Transaction
authArgs = structNew();
// Optional name and transactionKey
// authArgs.merchantAuthentication.name=authName;
// authArgs.merchantAuthentication.transactionKey=authKey;
authArgs.transactionrequest.transactionType = "voidTransaction"
authArgs.transactionrequest.refTransId = "1234567890";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.authPaymentXML(authArgs);
writeDump(var=AuthResp);

// ACH Debit
authArgs = structNew();
// Optional name and transactionKey
// authArgs.merchantAuthentication.name=authName;
// authArgs.merchantAuthentication.transactionKey=authKey;
authArgs.transactionrequest.transactionType = "authCaptureTransaction"
authArgs.transactionrequest.amount = "11.52";
authArgs.transactionrequest.payment.bankAccount.accountType = "checking";
authArgs.transactionrequest.payment.bankAccount.routingNumber = "121122676";
authArgs.transactionrequest.payment.bankAccount.accountNumber = "123456789";
authArgs.transactionrequest.payment.bankAccount.nameOnAccount = "John Doe";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.authPaymentXML(authArgs);
writeDump(var=AuthResp);

</cfscript>