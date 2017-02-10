Type.registerNamespace('MagicWare.Cart');
MagicWare.Cart.CartService=function() {
MagicWare.Cart.CartService.initializeBase(this);
this._timeout = 0;
this._userContext = null;
this._succeeded = null;
this._failed = null;
}
MagicWare.Cart.CartService.prototype={
_get_path:function() {
 var p = this.get_path();
 if (p) return p;
 else return MagicWare.Cart.CartService._staticInstance.get_path();},
InsertToCart:function(categoryID,productID,dateFrom,dateTo,nights,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'InsertToCart',false,{categoryID:categoryID,productID:productID,dateFrom:dateFrom,dateTo:dateTo,nights:nights},succeededCallback,failedCallback,userContext); },
GetUserContainerItemID:function(categoryID,productID,dateFrom,dateTo,nights,storeDate,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'GetUserContainerItemID',false,{categoryID:categoryID,productID:productID,dateFrom:dateFrom,dateTo:dateTo,nights:nights,storeDate:storeDate},succeededCallback,failedCallback,userContext); },
IsItemInCart:function(categoryID,userContainerItemID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'IsItemInCart',false,{categoryID:categoryID,userContainerItemID:userContainerItemID},succeededCallback,failedCallback,userContext); },
RemoveFromCartByParams:function(categoryID,productID,dateFrom,dateTo,nights,storeDate,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RemoveFromCartByParams',false,{categoryID:categoryID,productID:productID,dateFrom:dateFrom,dateTo:dateTo,nights:nights,storeDate:storeDate},succeededCallback,failedCallback,userContext); },
IsCartEmpty:function(categoryID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'IsCartEmpty',false,{categoryID:categoryID},succeededCallback,failedCallback,userContext); },
GetCartItemsCount:function(categoryID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'GetCartItemsCount',false,{categoryID:categoryID},succeededCallback,failedCallback,userContext); },
RemoveFromCart:function(categoryID,userContainerItemID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RemoveFromCart',false,{categoryID:categoryID,userContainerItemID:userContainerItemID},succeededCallback,failedCallback,userContext); },
RemoveFromCartWithRedirect:function(categoryID,userContainerItemID,nextPageID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RemoveFromCartWithRedirect',false,{categoryID:categoryID,userContainerItemID:userContainerItemID,nextPageID:nextPageID},succeededCallback,failedCallback,userContext); },
RemoveAllFromCart:function(categoryID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RemoveAllFromCart',false,{categoryID:categoryID},succeededCallback,failedCallback,userContext); },
RemoveNonValidItemsFromCart:function(categoryID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RemoveNonValidItemsFromCart',false,{categoryID:categoryID},succeededCallback,failedCallback,userContext); },
SavePersons:function(categoryID,pocetDospelych,vekyDeti,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'SavePersons',false,{categoryID:categoryID,pocetDospelych:pocetDospelych,vekyDeti:vekyDeti},succeededCallback,failedCallback,userContext); },
RemoveListFromCart:function(categoryID,polozkyIDs,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'RemoveListFromCart',false,{categoryID:categoryID,polozkyIDs:polozkyIDs},succeededCallback,failedCallback,userContext); },
GetPrice:function(polozkaSchrankyID,nextPageID,destinationLevel,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'GetPrice',false,{polozkaSchrankyID:polozkaSchrankyID,nextPageID:nextPageID,destinationLevel:destinationLevel},succeededCallback,failedCallback,userContext); },
GetTextOfItem:function(polozkaSchrankyID,itemTemplate,maxCountOfItems,dateTimeFormat,productNextPageID,succeededCallback, failedCallback, userContext) {
return this._invoke(this._get_path(), 'GetTextOfItem',false,{polozkaSchrankyID:polozkaSchrankyID,itemTemplate:itemTemplate,maxCountOfItems:maxCountOfItems,dateTimeFormat:dateTimeFormat,productNextPageID:productNextPageID},succeededCallback,failedCallback,userContext); }}
MagicWare.Cart.CartService.registerClass('MagicWare.Cart.CartService',Sys.Net.WebServiceProxy);
MagicWare.Cart.CartService._staticInstance = new MagicWare.Cart.CartService();
MagicWare.Cart.CartService.set_path = function(value) { MagicWare.Cart.CartService._staticInstance.set_path(value); }
MagicWare.Cart.CartService.get_path = function() { return MagicWare.Cart.CartService._staticInstance.get_path(); }
MagicWare.Cart.CartService.set_timeout = function(value) { MagicWare.Cart.CartService._staticInstance.set_timeout(value); }
MagicWare.Cart.CartService.get_timeout = function() { return MagicWare.Cart.CartService._staticInstance.get_timeout(); }
MagicWare.Cart.CartService.set_defaultUserContext = function(value) { MagicWare.Cart.CartService._staticInstance.set_defaultUserContext(value); }
MagicWare.Cart.CartService.get_defaultUserContext = function() { return MagicWare.Cart.CartService._staticInstance.get_defaultUserContext(); }
MagicWare.Cart.CartService.set_defaultSucceededCallback = function(value) { MagicWare.Cart.CartService._staticInstance.set_defaultSucceededCallback(value); }
MagicWare.Cart.CartService.get_defaultSucceededCallback = function() { return MagicWare.Cart.CartService._staticInstance.get_defaultSucceededCallback(); }
MagicWare.Cart.CartService.set_defaultFailedCallback = function(value) { MagicWare.Cart.CartService._staticInstance.set_defaultFailedCallback(value); }
MagicWare.Cart.CartService.get_defaultFailedCallback = function() { return MagicWare.Cart.CartService._staticInstance.get_defaultFailedCallback(); }
MagicWare.Cart.CartService.set_enableJsonp = function(value) { MagicWare.Cart.CartService._staticInstance.set_enableJsonp(value); }
MagicWare.Cart.CartService.get_enableJsonp = function() { return MagicWare.Cart.CartService._staticInstance.get_enableJsonp(); }
MagicWare.Cart.CartService.set_jsonpCallbackParameter = function(value) { MagicWare.Cart.CartService._staticInstance.set_jsonpCallbackParameter(value); }
MagicWare.Cart.CartService.get_jsonpCallbackParameter = function() { return MagicWare.Cart.CartService._staticInstance.get_jsonpCallbackParameter(); }
MagicWare.Cart.CartService.set_path("/WebServices/CartService.asmx");
MagicWare.Cart.CartService.InsertToCart= function(categoryID,productID,dateFrom,dateTo,nights,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.InsertToCart(categoryID,productID,dateFrom,dateTo,nights,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.GetUserContainerItemID= function(categoryID,productID,dateFrom,dateTo,nights,storeDate,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.GetUserContainerItemID(categoryID,productID,dateFrom,dateTo,nights,storeDate,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.IsItemInCart= function(categoryID,userContainerItemID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.IsItemInCart(categoryID,userContainerItemID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.RemoveFromCartByParams= function(categoryID,productID,dateFrom,dateTo,nights,storeDate,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.RemoveFromCartByParams(categoryID,productID,dateFrom,dateTo,nights,storeDate,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.IsCartEmpty= function(categoryID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.IsCartEmpty(categoryID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.GetCartItemsCount= function(categoryID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.GetCartItemsCount(categoryID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.RemoveFromCart= function(categoryID,userContainerItemID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.RemoveFromCart(categoryID,userContainerItemID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.RemoveFromCartWithRedirect= function(categoryID,userContainerItemID,nextPageID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.RemoveFromCartWithRedirect(categoryID,userContainerItemID,nextPageID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.RemoveAllFromCart= function(categoryID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.RemoveAllFromCart(categoryID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.RemoveNonValidItemsFromCart= function(categoryID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.RemoveNonValidItemsFromCart(categoryID,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.SavePersons= function(categoryID,pocetDospelych,vekyDeti,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.SavePersons(categoryID,pocetDospelych,vekyDeti,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.RemoveListFromCart= function(categoryID,polozkyIDs,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.RemoveListFromCart(categoryID,polozkyIDs,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.GetPrice= function(polozkaSchrankyID,nextPageID,destinationLevel,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.GetPrice(polozkaSchrankyID,nextPageID,destinationLevel,onSuccess,onFailed,userContext); }
MagicWare.Cart.CartService.GetTextOfItem= function(polozkaSchrankyID,itemTemplate,maxCountOfItems,dateTimeFormat,productNextPageID,onSuccess,onFailed,userContext) {MagicWare.Cart.CartService._staticInstance.GetTextOfItem(polozkaSchrankyID,itemTemplate,maxCountOfItems,dateTimeFormat,productNextPageID,onSuccess,onFailed,userContext); }
