<cfscript>
authName = "";
authKey = "";

/* createCustomerProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.merchantCustomerId = "Merchant_Customer_ID";
authArgs.customerdescription = "Profile description here";
authArgs.email = "customer-profile-email@here.com";
authArgs.customerType = "individual"; // or business
authArgs.firstName = "John";
authArgs.lastName = "Doe";
authArgs.address = "123 Main St.";
authArgs.city = "Bellevue";
authArgs.state = "WA";
authArgs.zip = "98004";
authArgs.country = "USA";
authArgs.phoneNumber = "000-000-0000";
authArgs.cardNumber = "4111111111111111";
authArgs.expirationDate = "2021-12";
authArgs.testrequest = TRUE;

//AuthNetTools = createObject("component", "AuthNetToolsAPI").init(1, authName, authKey);
AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.createCustomerProfile(argumentCollection=authArgs);
*/

/* getCustomerProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.customerProfileId="1234567890";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.getCustomerProfile(argumentCollection=authArgs);
*/

/* getCustomerProfileIds()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.getCustomerProfileIds(argumentCollection=authArgs);
*/

/* updateCustomerProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.customerProfileId = "1234567890";
authArgs.merchantCustomerId = "custId123";
authArgs.customerdescription = "some description";
authArgs.email = "newaddress@example.com";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.updateCustomerProfile(argumentCollection=authArgs);
*/

/* deleteCustomerProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.customerProfileId = "1234567890";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.deleteCustomerProfile(argumentCollection=authArgs);
*/

/* createCustomerPaymentProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.customerProfileId = "1234567890";
authArgs.customerType = "individual"; // or business
authArgs.firstName = "John";
authArgs.lastName = "Doe";
authArgs.address = "123 Main St.";
authArgs.city = "Bellevue";
authArgs.state = "WA";
authArgs.zip = "98004";
authArgs.country = "USA";
authArgs.phoneNumber = "000-000-0000";
authArgs.cardNumber = "4111111111111111";
authArgs.expirationDate = "2021-12";
authArgs.testrequest = TRUE;

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.createCustomerPaymentProfile(argumentCollection=authArgs);
*/

/* getCustomerPaymentProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.customerProfileId = "1234567890";
authArgs.customerPaymentProfileId = "1234567890";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.getCustomerPaymentProfile(argumentCollection=authArgs);
*/

/* getCustomerPaymentProfileList()

authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.searchType = "cardsExpiringInMonth";
authArgs.month = "2022-01";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.getCustomerPaymentProfileList(argumentCollection=authArgs);
*/

writeDump(var=AuthResp);
</cfscript>