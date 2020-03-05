<cfscript>
// Testing
// 1. Success
// 2. Invalid CC number
// 3. Decline - Bill To Zip 46282
// 4. Invalid Auth Name

authName = "";
authKey = "";

// Optional name and transactionKey
// merchantAuth = structNew();
// merchantAuth.name=authName;
// merchantAuth.transactionKey=authKey;

// Create the payment data for a credit card
creditCard = structNew();
creditCard.cardNumber = "4111111111111111";
creditCard.expirationDate = "2020-12";
creditCard.cardCode = "123";

// Add the payment data to a payment structure
payment = structNew();
payment.creditCard = creditCard;

// Create order information
order = structNew();
order.invoiceNumber = "10101";
order.description = "Golf Shirts";

// Set the customer's Bill To address
customerAddress = structNew();
customerAddress.firstName = "Ellen";
customerAddress.lastName = "Johnson";
customerAddress.company = "Souveniropolis";
customerAddress.address = "14 Main Street";
customerAddress.city = "Pecan Springs";
customerAddress.state = "TX";
//customerAddress.zip = "46282"; // to decline
customerAddress.zip = "44628";
customerAddress.country = "USA";

// Set the customer's identifying information
customerData = structNew();
customerData.type = "individual";
customerData.id = "99999456654";
customerData.email = "EllenJohnson@example.com";

// Add values for transaction settings
duplicateWindowSetting = structNew();
duplicateWindowSetting.settingName = "duplicateWindow";
duplicateWindowSetting.settingValue = "600";
settings = structNew();
settings.setting = arrayNew();
arrayAppend(settings.setting, duplicateWindowSetting);

// setup individual line items
line_item_1 = structNew();
line_item_1.itemId = "12345";
line_item_1.name = "first";
line_item_1.description = "Here's the first line item";
line_item_1.quantity = "2";
line_item_1.unitPrice = "12.95";
line_item_2 = structNew();
line_item_2.itemId = "67890";
line_item_2.name = "second";
line_item_2.description = "Here's the second line item";
line_item_2.quantity = "3";
line_item_2.unitPrice = "7.95";

// build the array of line items
line_items = structNew();
line_items.lineItem = arrayNew();
arrayAppend(line_items.lineItem, line_item_1);
arrayAppend(line_items.lineItem, line_item_2);

// tax
tax = structNew();
tax.amount = "5.23";

// User fields
user_field_1 = structNew();
user_field_1.name = "MerchantDefinedFieldName1";
user_field_1.value = "MerchantDefinedFieldValue1";
user_field_2 = structNew();
user_field_2.name = "favorite_color";
user_field_2.value = "blue";
userFields = structNew();
userFields.userField = arrayNew();
arrayAppend(userFields.userField, user_field_1);
arrayAppend(userFields.userField, user_field_2);

// Create CIM profile 
profile = structNew();
profile.createProfile = true;


// TransactionRequest XML key structure
transactionrequest = structNew();
transactionrequest.transactionType = "authCaptureTransaction"
transactionrequest.amount = "11.52";
transactionrequest.payment = payment;
//transactionrequest.profile = profile;
transactionrequest.order = order;
transactionrequest.billTo = customerAddress;
transactionrequest.customer = customerData;
transactionrequest.lineItems = line_items;
transactionrequest.tax = tax;
transactionrequest.userFields = userFields;
//transactionrequest.transactionSettings = settings;

// create full request structure
createtransactionrequest = structNew();
// createtransactionrequest.merchantAuthentication = merchantAuth;
createtransactionrequest.refId = "MerchantID-0001";
createtransactionrequest.transactionRequest = transactionrequest;

//AuthNetTools = createObject("component", "AuthNetToolsAPI").init(1, authName, authKey);
AuthNetTools =  new AuthNetToolsAPI(1, authName, authKey);
AuthResp = AuthNetTools.authPaymentXML(createtransactionrequest);
if (AuthResp.response_code eq 1) {
    WriteOutput("Success - TransId = " & #AuthResp.trans_id#);
} elseif (AuthResp.response_code eq 2) {
    WriteOutput("Declined - Error Code: " & #AuthResp.errorcode# & " Error: " & #AuthResp.error#);
} else {
    WriteOutput("Error! - Error Code: " & #AuthResp.errorcode# & " Error: " & #AuthResp.error#);
}
writeDump(var=AuthResp);
</cfscript>