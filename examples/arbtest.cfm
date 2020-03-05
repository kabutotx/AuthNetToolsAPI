<cfscript>
authName = "";
authKey = "";

/* ARBCreateSubscription()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.subscriptionName = "Test";
authArgs.length = 1; //days: 7-365 months: 1-12
authArgs.unit = "months"; // months or days
authArgs.startDate = "2021/01/01"; // YYYY-MM-DD
authArgs.totalOccurrences = 12;
authArgs.amount = 10.00;

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBCreateSubscription(argumentCollection=authArgs);
*/

/* ARBCreateSubscriptionFromProfile()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.subscriptionName = "Test";
authArgs.length = 1; //days: 7-365 months: 1-12
authArgs.unit = "months"; // months or days
authArgs.startDate = "2021/01/01"; // YYYY-MM-DD
authArgs.totalOccurrences = 12;
authArgs.amount = 10.00;
authArgs.customerProfileId = "1234567890";
authArgs.customerPaymentProfileId = "1234567890";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBCreateSubscriptionFromProfile(argumentCollection=authArgs);
*/

/* ARBGetSubscription()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.subscriptionId = "1234567";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBGetSubscription(argumentCollection=authArgs);
*/

/* ARBGetSubscriptionStatus()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.subscriptionId = "1234567";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBGetSubscriptionStatus(argumentCollection=authArgs);
*/

/* ARBUpdateSubscription() Fix returns
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.subscriptionId = "1234567";
authArgs.subscriptionName = "Updated Name";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBUpdateSubscription(argumentCollection=authArgs);
*/

/* ARBGetSubscriptionList()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.searchType = "subscriptionActive";
authArgs.orderBy = "id"; //default

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBGetSubscriptionList(argumentCollection=authArgs);
*/

/* ARBCancelSubscription()
authArgs = structNew();
// Optional name and transactionKey
// authArgs.name=authName;
// authArgs.transactionkey=authKey;
authArgs.subscriptionId = "1234567";

AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.ARBCancelSubscription(argumentCollection=authArgs);
*/

writeDump(var=AuthResp);
</cfscript>