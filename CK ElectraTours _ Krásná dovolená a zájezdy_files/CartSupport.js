var CartSupportSettings = { InsertedAlert: null, CartFullAlert: null, RemovedAlert: null };

function IsCartEmpty(isCartEmptyCallback) {
    MagicWare.Cart.CartService.IsCartEmpty(isCartEmptyCallback);
}

function GetCartItemsCountCallback(categoryID, cartItemsCountCallback) {
    MagicWare.Cart.CartService.GetCartItemsCount(categoryID, cartItemsCountCallback);
}

function CartInsert(categoryID, productID, datumOd, datumDo, pocetNoci, routeID) {
    MagicWare.Cart.CartService.InsertToCart(categoryID, productID, datumOd, datumDo, pocetNoci, routeID, CartInsertCallback);
}

function CheckVisibilityInsertRemove(number, modeAdd)
{
    var removeButton = document.getElementById("cartRemove" + number);
    var addButton = document.getElementById("cartAdd" + number);
        
    if (modeAdd)
    {
        addButton.style.display = "inline";
        removeButton.style.display = "none";
    } else {
        addButton.style.display = "none";
        removeButton.style.display = "inline";    
    }
}

function CartInsertRefresh(categoryID, productID, datumOd, datumDo, pocetNoci, number) {
    CheckVisibilityInsertRemove(number, false);
    MagicWare.Cart.CartService.InsertToCart(categoryID, productID, datumOd, datumDo, pocetNoci, CartInsertRefreshCallback);
}

function CartInsertCallback(result) {
    CartIconRefresh();
    CartInserted(result)
    if (result >= 0) {
        if (CartSupportSettings.InsertedAlert)
            alert(CartSupportSettings.InsertedAlert);
    }  else {
        if (CartSupportSettings.CartFullAlert)
            alert(CartSupportSettings.CartFullAlert);
    }
}

function CartInserted(auctionItemID) {
    if (auctionItemID > 0 && typeof CartAddedItem == 'function') {
        CartAddedItem(auctionItemID);
    }
}

function CartInsertRefreshCallback(result) {
    CartInsertCallback(result);
}

function CartRemoveByParams(categoryID, productID, datumOd, datumDo, pocetNoci, number, storeDate) {
    CheckVisibilityInsertRemove(number, true);
    MagicWare.Cart.CartService.RemoveFromCartByParams(categoryID, productID, datumOd, datumDo, pocetNoci, storeDate, CartRemoveNoReloadCallback);
}

function CartRemove(categroryID, auctionItemID) {
    MagicWare.Cart.CartService.RemoveFromCart(categroryID, auctionItemID, CartRemoveCallback);
}

function CartRemoveWithRedirect(categroryID, auctionItemID, nextPageID) {
    MagicWare.Cart.CartService.RemoveFromCartWithRedirect(categroryID, auctionItemID, nextPageID, CartRemoveWithRedirectCallback);
}

function ShowError(error, id, cssClass, errorCssClass) {
    $("." + cssClass + id).find("." + errorCssClass).append("<div>" + error + "</div>");
}

function CartRemoveWithRedirectCallback(result, auctionItemID) {
    window.location.replace(result);
}

function CartRemoveCallback(result, auctionItemID) {
    CartIconRefresh();
    window.location.reload();
}

function CartRemoveNoReloadCallback(result) {
    if (CartSupportSettings.RemovedAlert)
        alert(CartSupportSettings.RemovedAlert);
    CartIconRefresh();
    if (typeof DeleteNotExistsItems == 'function')
        DeleteNotExistsItems();
}

function CartRemoveList(categoryID, seznam) {
    MagicWare.Cart.CartService.RemoveListFromCart(categoryID, seznam, CartRemoveCallback);
}

function CartRemoveCallback(result) {
    CartIconRefresh();
    window.location.reload();
}

function CartIconRefresh()
{
    if(typeof _CartIconRefresh == 'function') 
    {
        _CartIconRefresh();
    }
}

function CartAddRemoveButtonsRefresh() {

    $('.cart-addremove-buttons').each(function() {
        RefreshIcon($(this));
    });
}

function RefreshIcon(obj) {
    var id = obj.attr('id');

    if (id == null)
        return;
    var splitted = id.split(',');
    var productID = splitted[0];
    var datumOd = VratDatum(splitted[1]);
    var datumDo = VratDatum(splitted[2]);
    var pocetNoci = splitted[3];
    var number = splitted[4];
        
    MagicWare.Cart.CartService.GetUserContainerItemID(categoryID, productID, datumOd, datumDo, pocetNoci, true, function(result) { CartIconRefreshCallback(number, result); });
}

function CartIconRefreshCallback(number, result) {
    CheckVisibilityInsertRemove(number, result == -1);
}

function VratDatum(d) {
    var splitted = d.split('-');
    return new Date(parseInt(splitted[0]), parseInt(splitted[1]) - 1, parseInt(splitted[2]) + 1);
}