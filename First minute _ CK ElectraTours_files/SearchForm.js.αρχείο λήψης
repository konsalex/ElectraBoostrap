/// <reference path="jquery.min.js" />
/// <reference path="AjaxPanel.js" />
/// <reference path="js.cookie.js" />

var MagicWare = MagicWare || {};
MagicWare.SearchForm = MagicWare.SearchForm || {};

MagicWare.SearchForm.Form = function (containerSelector, defaultQueryString) {
    ///<field name="$FormContainer" type="$" />
    ///<field name="Targets" type="Array" elementType="String" />
    ///<field name="Controls" type="Array" />
    this.$FormContainer = $(containerSelector);
    this.DefaultQueryString = defaultQueryString;
    this.Targets = [];
    this.Controls = [];
    this.OnValueChangedHandlers = [];
    this._MemorySourceName = null;
}
//verejne rozhrani
MagicWare.SearchForm.Form.prototype.
    CreateLiveForm = function (configuration) {
        ///<param name="configuration" type="MagicWare.SearchForm.LiveFormConfiguration" />
        ///<returns type="MagicWare.SearchForm.LiveForm"></returns>
        var liveForm = new MagicWare.SearchForm.LiveForm(this.$FormContainer, this, configuration);
        configuration.OnInitForm(liveForm);
        this.AddOnValueChangedHander(liveForm.RefreshFormValues.bind(liveForm));
        liveForm.RefreshFormValues();
        return liveForm;
    }
MagicWare.SearchForm.Form.prototype.
    AddOnValueChangedHander = function(onValueChangeHandler) {
        this.OnValueChangedHandlers.push(onValueChangeHandler);
    }
MagicWare.SearchForm.Form.prototype.
    GetQueryString = function() {
        var queryString = this.DefaultQueryString;
        for (var i = 0; i < this.Controls.length; i++) {
            var searchParam = this.Controls[i].GetSearchParam();
            if (searchParam != null && searchParam.length > 0) {
                queryString = queryString + "&" + searchParam;
            }
        }
        return queryString;
    }
MagicWare.SearchForm.Form.prototype.
    InitSimpleLiveForm = function(liveForm) {
        for (var i = 0; i < this.Controls.length; i++) {
            this.Controls[i].InitLiveForm(liveForm);
        }
    }
MagicWare.SearchForm.Form.prototype.
    UpdateSimpleLiveForm = function(liveForm, liveFormData) {
        for (var i = 0; i < this.Controls.length; i++) {
            this.Controls[i].UpdateLiveForm(liveForm, liveFormData);
        }
    }
MagicWare.SearchForm.Form.prototype.
    GetSimpleLiveFormDefinition = function(memorySourceName) {
        var definition = {
            SourceName: memorySourceName || this._MemorySourceName,
            Items: []
        };
        for (var i = 0; i < this.Controls.length; i++) {
            this.Controls[i].AddLiveFormDefinition(definition.Items);
        }
        return [definition];
    }
//----------------    
MagicWare.SearchForm.Form.prototype.
    CreateSimpleLiveForm = function(memorySourceName) {
        this._MemorySourceName = memorySourceName;
        var configuration = new MagicWare.SearchForm.LiveFormConfiguration();
        configuration.OnInitForm = this.InitSimpleLiveForm.bind(this);
        configuration.OnUpdateForm = this.UpdateSimpleLiveForm.bind(this);
        configuration.OnGetDefinition = this.GetSimpleLiveFormDefinition.bind(this);
        this.CreateLiveForm(configuration);
    }
MagicWare.SearchForm.Form.prototype.
    AddAjaxPanelTarget = function(target) {
        this.Targets.push({ 'type': 'ajaxPanel', 'target': target });
    }
MagicWare.SearchForm.Form.prototype.
    AddGoogleMapTarget = function(target) {
        this.Targets.push({ 'type': 'googleMap', 'target': target });
    }
MagicWare.SearchForm.Form.prototype.
    RegisterControl = function(control, containerSelector, parameterName, cookieKeyPrefix, cookieExpiration) {
        this.Controls.push(control);
        control.Inicialize(this, containerSelector, parameterName);
        control.CookieKeyPrefix = cookieKeyPrefix == undefined ? null : cookieKeyPrefix;
        control.CookieExpiration = cookieExpiration == undefined ? null : cookieExpiration;
    }
MagicWare.SearchForm.Form.prototype.
    RegisterButton = function(buttonSelector, targetAjaxPanels, targetGoogleMaps) {
        var self = this;
        this.$FormContainer.find(buttonSelector).click(function () {
            self.OnButtonClicked(targetAjaxPanels, targetGoogleMaps);
            return false;
        });
    }
MagicWare.SearchForm.Form.prototype.
    OnButtonClicked = function(targetAjaxPanels, targetGoogleMaps) {
        var queryString = this.GetQueryString();
        var targets = [];
        for (var i = 0; i < targetAjaxPanels.length; i++)
            targets.push({ 'type': 'ajaxPanel', 'target': targetAjaxPanels[i] });
        for (var i = 0; i < targetGoogleMaps.length; i++)
            targets.push({ 'type': 'googleMap', 'target': targetGoogleMaps[i] });
        this.RefreshTargets(targets, queryString);
    }
MagicWare.SearchForm.Form.prototype.
    Inicialize = function() {
        var queryString = this.GetQueryString();
        this.RefreshTargets(this.Targets, queryString);
    }
MagicWare.SearchForm.Form.prototype.
    SetCookieValue = function(control, paramName, value) {
        if (control.CookieKeyPrefix != null) {
            var cookieKey = control.CookieKeyPrefix + paramName;
            if (value)
                Cookies.set(cookieKey, value, { expires: control.CookieExpiration });
            else
                Cookies.remove(cookieKey);
        }
    }
MagicWare.SearchForm.Form.prototype.
    SetJoinedCookieValue = function(control, paramName, selectedValues, useLegacyParameterName, valueSeparator) {
        if (this.useLegacyParameterName)
            this.SetCookieValue(control, paramName + "s", null);
        this.SetCookieValue(control, paramName, null);

        if (selectedValues.length > 0) {
            if (selectedValues.length > 1 && useLegacyParameterName)
                paramName += "s";
            var searchValue = selectedValues.join(valueSeparator);
            this.SetCookieValue(control, paramName, searchValue);
        }
    }
MagicWare.SearchForm.Form.prototype.
    OnValueChanged = function() {
        ///<summary>Slouží pro jakoukoliv aktualizaci uživatelského rozhraní po změně vyhledávané hodnoty - např. aktualizace přidružených AjaxPanelů apod.</summary>
        var queryString = this.GetQueryString();
        this.RefreshTargets(this.Targets, queryString);
    }
MagicWare.SearchForm.Form.prototype.
    RefreshTargets = function(targets, queryString) {
        var error = null;
        for (var i = 0; i < targets.length; i++) {
            try {
                if (targets[i].type == 'ajaxPanel') {
                    ReloadAjaxPanel(targets[i].target, null, queryString)
                }
                else if (targets[i].type == 'googleMap') {
                    MagicWare.GoogleMap.ReloadWithQueryString(targets[i].target, queryString);
                }
            }
            catch (err) {
                error = err; //vyvolani chyby odlozime (musime totiz zaktualizovat vsechny, co jdou)
            }
        }

        for (var i = 0; i < this.OnValueChangedHandlers.length; i++) {
            try {
                this.OnValueChangedHandlers[i](queryString);
            }
            catch (err) {
                error = err; //vyvolani chyby odlozime (musime totiz zaktualizovat vsechny, co jdou)
            }
        }
        if (error != null)
            throw error;
    }

MagicWare.SearchForm.InputControl = function (isDateBox) {
    ///<field name="ParameterName" type="String">Název vyhledávacího parametru</field>
    ///<field name="form" type="MagicWare.SearchForm.Form">Hlavní formulář</field>    
    ///<field name="$inputControl" type="$">Ovládací prvek pro zadání vyhledávané hodnoty</field>
    ///<field name="isDateBox" type="boolean">Příznak, zdali se jedná o datumovou hodnotu</field>
    this.ParameterName = null;
    this.form = null;
    this.$inputControl = null;
    this.isDateBox = isDateBox;
}

MagicWare.SearchForm.InputControl.prototype.
    Inicialize = function(form, containerSelector, parameterName) {
        ///<param name="form" type="MagicWare.SearchForm.Form" />
        this.form = form;
        this.$inputControl = form.$FormContainer.find(containerSelector).find("input");
        this.ParameterName = parameterName;
        var self = this;
        this.$inputControl.change(function () { self.OnValueChanged(); });
    }
MagicWare.SearchForm.InputControl.prototype.
    GetSearchParam = function() {
        var searchValue = this.GetSearchValue();
        if (searchValue != null && searchValue.length > 0) {
            return this.ParameterName + "=" + encodeURIComponent(searchValue);
        }
        else {
            return null;
        }
    }
MagicWare.SearchForm.InputControl.prototype.
    OnValueChanged = function() {
        this.form.OnValueChanged();
        this.form.SetCookieValue(this, this.ParameterName, this.GetSearchValue());
    }
MagicWare.SearchForm.InputControl.prototype.
    GetSearchValue = function() {
        ///<summary>Vrací stringovou nezakodovanou vyhledávací hodnotu určenou pro URL.</summary>
        var value = this.$inputControl.val();
        if (this.isDateBox) {
            var dateValue = null;
            if (value.length > 0) {
                var date = buildDate(value, "%d.%m.%Y");
                if (date != null && date instanceof Date)
                    dateValue = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            }
            value = dateValue;
        }
        return value;
    }
MagicWare.SearchForm.InputControl.prototype.
    InitLiveForm = function(liveForm) {
    }
MagicWare.SearchForm.InputControl.prototype.
    UpdateLiveForm = function(liveForm, liveFormData) {
    }
MagicWare.SearchForm.InputControl.prototype.
    AddLiveFormDefinition = function(items) {
        //{ SearchFormItemName: 'TransportTypes', ResultType: 'Set', FieldNames: 'Transport.TransportTypeID', FilterParameters: ['TransportTypeID'] },
    }

MagicWare.SearchForm.CheckBoxControl = function () {
    ///<field name="ParameterName" type="String">Název vyhledávacího parametru</field>
    ///<field name="form" type="MagicWare.SearchForm.Form">Hlavní formulář</field>    
    ///<field name="$checkBoxControl" type="$">Ovládací prvek pro zadání vyhledávané hodnoty</field>
    this.ParameterName = null;
    this.form = null;
    this.$checkBoxControl = null;
}
MagicWare.SearchForm.CheckBoxControl.prototype.
    Inicialize = function(form, containerSelector, parameterName) {
        ///<param name="form" type="MagicWare.SearchForm.Form" />
        this.form = form;
        this.$checkBoxControl = form.$FormContainer.find(containerSelector).find("input");
        this.ParameterName = parameterName;
        var self = this;
        this.$checkBoxControl.change(function () { self.OnValueChanged(); });
    }
MagicWare.SearchForm.CheckBoxControl.prototype.
    GetSearchParam = function() {
        var searchValue = this.GetSearchValue();
        if (searchValue != null) {
            return this.ParameterName + "=" + encodeURIComponent(searchValue);
        }
        else {
            return null;
        }
    }
MagicWare.SearchForm.CheckBoxControl.prototype.
    OnValueChanged = function() {
        this.form.OnValueChanged();
        this.form.SetCookieValue(this, this.ParameterName, this.GetSearchValue());
    }
MagicWare.SearchForm.CheckBoxControl.prototype.
    GetSearchValue = function() {
        ///<summary>Vrací stringovou nezakodovanou vyhledávací hodnotu určenou pro URL.</summary>
        if (this.$checkBoxControl.attr("checked") == "checked")
            return "true";
        else
            return null;
    }
MagicWare.SearchForm.CheckBoxControl.prototype.
    InitLiveForm = function(liveForm) {
    }
MagicWare.SearchForm.CheckBoxControl.prototype.
    UpdateLiveForm = function(liveForm, liveFormData) {
    }
MagicWare.SearchForm.CheckBoxControl.prototype.
    AddLiveFormDefinition = function(items) {
        //{ SearchFormItemName: 'TransportTypes', ResultType: 'Set', FieldNames: 'Transport.TransportTypeID', FilterParameters: ['TransportTypeID'] },
    }

MagicWare.SearchForm.ListControlBase = function () {
    ///<field name="ParameterNames" type="Array" elementType="String">Pole názvů vyhledávacích parametrů (pokud je jich více, je použito pro případy, kdy je hodnota vyhledávání chápána jako rozsah).</field>
    ///<field name="form" type="MagicWare.SearchForm.Form">Hlavní formulář</field>    
    this.ParameterNames = null;
    this.form = null;
}
MagicWare.SearchForm.ListControlBase.prototype.
    GetSelectedValues = function() { 
        throw new Error();
    }
MagicWare.SearchForm.ListControlBase.prototype.
    InitParameterNames = function(parameterName) {
        this.ParameterNames = parameterName.split(',');
    }
MagicWare.SearchForm.ListControlBase.prototype.
    GetSearchParam = function() {
        var selectedValues = this.GetSelectedValues();
        if (selectedValues.length == 0)
            return null;

        if (selectedValues.length == 1 && this.ParameterNames.length > 1)
            return this.GetMultiSearchParameters(selectedValues[0]);

        var paramName = this.ParameterNames[0];
        if (selectedValues.length > 1 && this.useLegacyParameterName)
            paramName += "s";

        var searchValue = selectedValues.join(this.valueSeparator);
        return paramName + "=" + encodeURIComponent(searchValue);
    }
MagicWare.SearchForm.ListControlBase.prototype.
    GetMultiSearchParameters = function(selectedValue) {
        var multiValues = selectedValue.split(",");
        var queryString = "";
        for (var i = 0; i < multiValues.length; i++) {
            if (multiValues[i].length > 0) {
                if (queryString.length > 0)
                    queryString += "&";
                queryString += this.ParameterNames[i] + "=" + encodeURIComponent(multiValues[i]);
            }
        }
        return queryString;
    }
MagicWare.SearchForm.ListControlBase.prototype.
    OnValueChanged = function() {
        this.form.OnValueChanged();
        if (this.CookieKeyPrefix != null) {
            var selectedValues = this.GetSelectedValues();
            if (selectedValues.length == 1 && this.ParameterNames.length > 1) {
                var multiValues = selectedValues[0].split(",");
                for (var i = 0; i < multiValues.length; i++) {
                    if (multiValues[i].length > 0)
                        this.form.SetCookieValue(this, this.ParameterNames[i], multiValues[i]);
                    else
                        this.form.SetCookieValue(this, this.ParameterNames[i], null);
                }
            }
            else {
                this.form.SetJoinedCookieValue(this, this.ParameterNames[0], selectedValues, this.useLegacyParameterName, this.valueSeparator);
            }
        }
    }

MagicWare.SearchForm.SelectControl = function (valueSeparator, useLegacyParameterName, liveSearchFormConfig) {
    ///<field name="valueSeparator" type="String">Znak sloužící k oddělení více vybraných hodnot.</field>
    ///<field name="useLegacyParameterName" type="Boolean">Příznak, zdali se má v případě multivýběru k názvu parametru přídat znak 's'.</field>
    ///<field name="$selectControl" type="$">Ovládací prvek pro zadání vyhledávané hodnoty</field>
    MagicWare.SearchForm.ListControlBase.call(this);
    this.valueSeparator = valueSeparator;
    this.useLegacyParameterName = useLegacyParameterName;
    this._liveSearchFormConfig = liveSearchFormConfig;
    this.$selectControl = null;
}
MagicWare.SearchForm.SelectControl.prototype = Object.create(MagicWare.SearchForm.ListControlBase.prototype);
MagicWare.SearchForm.SelectControl.prototype.
    Inicialize = function (form, containerSelector, parameterName) {
        ///<param name="form" type="MagicWare.SearchForm.Form" />
        this.form = form;
        this.$selectControl = form.$FormContainer.find(containerSelector).find("select");
        this.InitParameterNames(parameterName);
        var self = this;
        this.$selectControl.change(function () { self.OnValueChanged(); });
    }
MagicWare.SearchForm.SelectControl.prototype.
    GetSelectedValues = function() {
        ///<returns type="Array" elementType="string"></returns>
        ///<summary>Vrací seznam vybraných hodnot.</summary>
        var selectedOptions = this.$selectControl.find("option:selected");
        var selectedValues = [];
        for (var i = 0; i < selectedOptions.length; i++) {
            var option = selectedOptions[i];
            if (option.value && option.value.length > 0) {
                selectedValues.push(option.value);
            }
        }
        return selectedValues;
    }
MagicWare.SearchForm.SelectControl.prototype.
    InitLiveForm = function(liveForm) {
        ///<param name="liveForm" type="MagicWare.SearchForm.LiveForm" />
        if (this._liveSearchFormConfig) {
            liveForm.InitSelect(this.$selectControl);
        }
    }
MagicWare.SearchForm.SelectControl.prototype.
    UpdateLiveForm = function(liveForm, liveFormData) {
        ///<param name="liveForm" type="MagicWare.SearchForm.LiveForm" />
        if (this._liveSearchFormConfig) {
            liveForm.UpdateSelect(liveFormData, this.$selectControl, this.ParameterNames[0]);
        }
    }
MagicWare.SearchForm.SelectControl.prototype.
    AddLiveFormDefinition = function(items) {
        if (this._liveSearchFormConfig) {
            items.push({
                SearchFormItemName: this.ParameterNames[0],
                ResultType: this._liveSearchFormConfig.DataType,
                FieldNames: this._liveSearchFormConfig.FieldTypes,
                ValueConverter: this._liveSearchFormConfig.Converter,
                FilterParameters: this.ParameterNames
            });
        }
    }

MagicWare.SearchForm.CheckInputsControl = function (valueSeparator, useLegacyParameterName, liveSearchFormConfig) {
    ///<field name="valueSeparator" type="String">Znak sloužící k oddělení více vybraných hodnot.</field>
    ///<field name="useLegacyParameterName" type="Boolean">Příznak, zdali se má v případě multivýběru k názvu parametru přídat znak 's'.</field>
    ///<field name="$container" type="$">Kontejnerový objekt obsahující ovládací prvky pro zadání vyhledávané hodnoty tohoto parametru.</field>
    MagicWare.SearchForm.ListControlBase.call(this);
    this.valueSeparator = valueSeparator;
    this.useLegacyParameterName = useLegacyParameterName;
    this._liveSearchFormConfig = liveSearchFormConfig;
    this.$container = null;
}
MagicWare.SearchForm.CheckInputsControl.prototype = Object.create(MagicWare.SearchForm.ListControlBase.prototype);
MagicWare.SearchForm.CheckInputsControl.prototype.
    Inicialize = function(form, containerSelector, parameterName) {
        ///<param name="form" type="MagicWare.SearchForm.Form" />
        this.form = form;
        this.$container = form.$FormContainer.find(containerSelector);
        this.InitParameterNames(parameterName);
        this.ParameterName = parameterName;
        var self = this;
        this.$container.find("input").click(function () { self.OnValueChanged(); });
    }
MagicWare.SearchForm.CheckInputsControl.prototype.
    GetSelectedValues = function() {
        ///<returns type="Array" elementType="string"></returns>
        ///<summary>Vrací seznam vybraných hodnot.</summary>
        var selectedInputs = this.$container.find("input:checked");
        var selectedValues = [];
        for (var i = 0; i < selectedInputs.length; i++) {
            var input = selectedInputs[i];
            if (input.value && input.value.length > 0) {
                selectedValues.push(input.value);
            }
        }
        return selectedValues;
    }
MagicWare.SearchForm.CheckInputsControl.prototype.
    InitLiveForm = function(liveForm) {
        ///<param name="liveForm" type="MagicWare.SearchForm.LiveForm" />
        if (this._liveSearchFormConfig) {
            liveForm.InitList(this.$container.find("ul"), "li");
        }
    }
MagicWare.SearchForm.CheckInputsControl.prototype.
    UpdateLiveForm = function(liveForm, liveFormData) {
        ///<param name="liveForm" type="MagicWare.SearchForm.LiveForm" />
        if (this._liveSearchFormConfig) {
            liveForm.UpdateList(liveFormData, this.$container.find("ul"), "li", this.ParameterName);
        }
    }
MagicWare.SearchForm.CheckInputsControl.prototype.
    AddLiveFormDefinition = function(items) {
        if (this._liveSearchFormConfig) {
            items.push({
                SearchFormItemName: this.ParameterName,
                ResultType: this._liveSearchFormConfig.DataType,
                FieldNames: this._liveSearchFormConfig.FieldTypes,
                ValueConverter: this._liveSearchFormConfig.Converter,
                FilterParameters: [this.ParameterName]
            });
        }
    }

MagicWare.SearchForm.CascadingSelectItem = function () {
    ///<field name="Value" type="String"></field>
    ///<field name="Name" type="String"></field>
    ///<field name="IsSelected" type="Boolean"></field>
    ///<field name="IsHidden" type="Boolean"></field>
    ///<field name="Items" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem"></field>
    ///<field name="ParentItem" type="MagicWare.SearchForm.CascadingSelectItem"></field>
}

MagicWare.SearchForm.CascadingSelectControl = function (valueSeparator, useLegacyParameterName, liveSearchFormConfig, subSelects, treeItems) {
    ///<field name="valueSeparator" type="String">Znak sloužící k oddělení více vybraných hodnot.</field>
    ///<field name="useLegacyParameterName" type="Boolean">Příznak, zdali se má v případě multivýběru k názvu parametru přídat znak 's'.</field>
    ///<field name="ParameterName" type="String">Název vyhledávacího parametru</field>
    ///<field name="form" type="MagicWare.SearchForm.Form">Hlavní formulář</field>    
    ///<field name="TreeItems" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem">Stromovita struktura parametru</field>    
    ///<field name="Selects" type="Array">Seznam subselectu</field>    
    this.valueSeparator = valueSeparator;
    this.useLegacyParameterName = useLegacyParameterName;
    this._liveSearchFormConfig = liveSearchFormConfig;
    this.ParameterName = null;
    this.form = null;
    this.$container = null;
    this.$selectedFieldControl = null;
    this.TreeItems = treeItems;
    this.Selects = [];
    for (var i = 0; i < subSelects.length; i++) {
        var subSelect = new MagicWare.SearchForm.CascadingSelectSubListControl(this, subSelects[i]);
        this.Selects.push(subSelect);
    }
}
/* ---------------------------- VEŘEJNÉ ROZHRANÍ ---------------------------- */
MagicWare.SearchForm.CascadingSelectControl.prototype.
    GetDataTree = function() {
        return this.TreeItems;
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    Rebuild = function(treeItems, triggerChange) {
        this.ResetDataSources();
        if (triggerChange != false)
            this.OnValueChanged();
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    SetSelectionState = function(value, selectionState) {
        ///<param name="value" type="String"></field>
        ///<field name="selectionState" type="Bool"></field>
        var item = this.FindItemRecursive(value, this.TreeItems);

        if (item == null)
            throw new Error("Item with given value does not exists.");

        if (selectionState == true) {
            while (item != null && item !== undefined) {
                item.IsSelected = true;
                item = item.ParentItem;
            }
        } else if (selectionState == false) {
            item.IsSelected = false;
        }

        this.Rebuild();
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    DeselectAll = function(value) {
        ///<param name="value" type="String"></field>

        if (value === undefined) {
            for (var i = 0; i < this.TreeItems.length; i++) {
                this.DeselectRecursive(this.TreeItems[i]);
            }
        }
        else {
            var item = this.FindItemRecursive(value, this.TreeItems);
            if (item == null)
                throw new Error("Item with given value does not exists.");
            this.DeselectRecursive(item);
            item = item.ParentItem;

            while (item != null && item !== undefined) {

                var isAnySubItemSelected = false;
                if (item.Items) {
                    for (var i = 0; !isAnySubItemSelected && i < item.Items.length; i++) {
                        isAnySubItemSelected = item.Items[i].IsSelected;
                    }
                }

                if (isAnySubItemSelected)
                    break;

                item.IsSelected = false;
                item = item.ParentItem;
            }
        }

        this.Rebuild();
    }
/* -------------------------------------------------------------------------- */
MagicWare.SearchForm.CascadingSelectControl.prototype.
    FindItemRecursive = function(value, items) {
        ///<returns type="MagicWare.SearchForm.CascadingSelectItem"></returns>
        ///<param name="items" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem"></param>    
        for (var i = 0; i < items.length; i++) {
            var item = items[i];

            if (item.Value == value)
                return item;

            if (item.Items) {
                var subItem = this.FindItemRecursive(value, item.Items);
                if (subItem != null)
                    return subItem;
            }
        }
        return null;
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    DeselectRecursive = function(item) {
        ///<param name="item" type="MagicWare.SearchForm.CascadingSelectItem"></param>    
        item.IsSelected = false;
        if (item.Items) {
            for (var i = 0; i < item.Items.length; i++) {
                this.DeselectRecursive(item.Items[i]);
            }
        }
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    Inicialize = function(form, containerSelector, parameterName) {
        ///<param name="form" type="MagicWare.SearchForm.Form" />
        this.SetParentItems(null, this.TreeItems);
        this.form = form;
        this.$container = form.$FormContainer.find(containerSelector);
        this.$selectedFieldControl = this.$container.find("input.search-form-control-selectedfield");
        this.ParameterName = parameterName;
        for (var i = 0; i < this.Selects.length; i++) {
            var subSelectContainer = this.$container.find("div.search-form-control-treeselect" + i)
            this.Selects[i].Inicialize(subSelectContainer);
        }
        this.$selectedFieldControl.val();
        this.ResetDataSources();
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    SetParentItems = function(parentItem, items) {
        ///<param name="parentItem" type="MagicWare.SearchForm.CascadingSelectItem"></param>    
        ///<param name="items" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem"></param>    
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            item.ParentItem = parentItem;
            if (item.Items) {
                this.SetParentItems(item, item.Items);
            }
        }
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    GetSearchParam = function() {
        ///<var type="String" />
        var selectedValues = this.$selectedFieldControl.val();
        if (selectedValues.length == 0)
            return null;

        var paramName = this.ParameterName;
        if (selectedValues.indexOf(this.valueSeparator) > 0)
            paramName += "s";

        return this.ParameterName + "=" + encodeURIComponent(selectedValues);
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    OnValueChanged = function() {
        this.form.OnValueChanged();
        if (this.CookieKeyPrefix != null) {
            this.form.SetJoinedCookieValue(this, this.ParameterName, this.$selectedFieldControl.val().split(this.valueSeparator), this.useLegacyParameterName, this.valueSeparator);
        }
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    ResetDataSources = function(changeSource) {

        var currentDataSource = this.TreeItems;

        var startIndex = 0;

        if (changeSource) {
            for (var selectIndex = 1; selectIndex < this.Selects.length; selectIndex++) {
                if (this.Selects[selectIndex] == changeSource) {
                    startIndex = selectIndex + 1;
                    currentDataSource = this.GetSelectedItems(this.Selects[selectIndex].DataSource);
                }
            }
        }

        for (var selectIndex = startIndex; selectIndex < this.Selects.length; selectIndex++) {
            var select = this.Selects[selectIndex];
            select.SetDataSource(currentDataSource);
            currentDataSource = this.GetSelectedItems(select.DataSource);
        }

        this.SetSelectedValuesField();

        this.$container.trigger("mwCascadingSelect-rebuilt");
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    GetSelectedItems = function(items) {
        var result = [];
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item.IsSelected && !item.IsHidden)
                result.push(item);
        }
        return result;
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    SetSelectedValuesField = function() {
        ///<returns type="Array" elementType="string"></returns>
        ///<summary>Vrací seznam vybraných hodnot.</summary>
        var selectedValues = [];

        this.AddSelectedValues(selectedValues, this.TreeItems);

        var newValues = selectedValues.join(this.valueSeparator);

        if (this.$selectedFieldControl.val() != newValues) {
            this.$selectedFieldControl.val(newValues);
            this.OnValueChanged();
        }
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    AddSelectedValues = function(selectedValues, items) {
        ///<param name="items" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem" />
        var initialSize = selectedValues.length;
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (!item.IsHidden) {
                var isAnyChildSelected = item.Items && this.AddSelectedValues(selectedValues, item.Items);
                if (item.IsSelected && !isAnyChildSelected)
                    selectedValues.push(item.Value);
            }
        }
        return initialSize < selectedValues.length;
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    InitLiveForm = function(liveForm) {
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    UpdateLiveForm = function(liveForm, liveFormData) {
        ///<param name="liveForm" type="MagicWare.SearchForm.LiveForm" />
        if (this._liveSearchFormConfig) {
            liveForm.UpdateCascadingSelect(this, liveFormData, this.ParameterName);
        }
    }
MagicWare.SearchForm.CascadingSelectControl.prototype.
    AddLiveFormDefinition = function(items) {
        if (this._liveSearchFormConfig) {
            items.push({
                SearchFormItemName: this.ParameterName,
                ResultType: this._liveSearchFormConfig.DataType,
                FieldNames: this._liveSearchFormConfig.FieldTypes,
                ValueConverter: this._liveSearchFormConfig.Converter,
                FilterParameters: [this.ParameterName]
            });
        }
    }


MagicWare.SearchForm.CascadingSelectSubListControl = function (parentControl, definition) {
    ///<field name="DataSource" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem">Stromovita struktura parametru</field>    
    ///<field name="Definition">Definice obsahujici nastaveni pro select</field>
    ///<field name="parentControl" type="MagicWare.SearchForm.CascadingSelectControl">Definice obsahujici nastaveni pro select</field>
    this.DataSource = null;
    this.Definition = definition;
    this.parentControl = parentControl;
    this.controlRenderer = null;
}
MagicWare.SearchForm.CascadingSelectSubListControl.prototype.
    Inicialize = function($container) {
        ///<summary>Vytvori UI obsahujici select.</summary>
        switch (this.Definition.Mode) {
            case "DropDownList":
                this.controlRenderer = new MagicWare.SearchForm.CascadingSelectSelectRenderer(this, $container, false);
                break;
            case "ListBox":
                this.controlRenderer = new MagicWare.SearchForm.CascadingSelectSelectRenderer(this, $container, true);
                break;
            case "CheckBoxList":
                this.controlRenderer = new MagicWare.SearchForm.CascadingSelectCheckBoxListRenderer(this, $container);
                break;
            default:
                throw new Error("not supported");
        }
    }
MagicWare.SearchForm.CascadingSelectSubListControl.prototype.
    SetDataSource = function(items) {
        ///<param name="items" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem" />
        this.DataSource = [];
        this.SetItemsLevel(this.Definition.LvlOffset, items);
        this.controlRenderer.ResetUI();
    }
MagicWare.SearchForm.CascadingSelectSubListControl.prototype.
    SetItemsLevel = function(currentLevel, items) {
        ///<param name="items" type="Array" elementType="MagicWare.SearchForm.CascadingSelectItem">Polozky v aktualnim levelu</field>    
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            var addItem = currentLevel == 0 || !(item.Items);

            if (addItem) {
                if (!item.IsHidden)
                    this.DataSource.push(item);
            }
            else {
                this.SetItemsLevel(currentLevel - 1, item.Items);
            }
        }
    }
MagicWare.SearchForm.CascadingSelectSubListControl.prototype.
    OnSelectionChanged = function() {
        var selectionStates = this.controlRenderer.GetSelectionStates();
        for (var i = 0; i < this.DataSource.length; i++) {
            var item = this.DataSource[i];
            var isSelected = selectionStates[i];
            if (item.IsSelected && !isSelected)
                this.DeselectAll(item);
            item.IsSelected = isSelected;
        }
        this.parentControl.ResetDataSources(this);
    }
MagicWare.SearchForm.CascadingSelectSubListControl.prototype.
    DeselectAll = function(item) {
        ///<param name="item" type="MagicWare.SearchForm.CascadingSelectItem" />
        if (item.Items) {
            for (var i = 0; i < item.Items.length; i++) {
                var subItem = item.Items[i];
                subItem.IsSelected = false;
                this.DeselectAll(subItem);
            }
        }
    }
MagicWare.SearchForm.CascadingSelectSubListControl.prototype.
    GetLegendParent = function(item) {
        ///<param name="item" type="MagicWare.SearchForm.CascadingSelectItem" />
        if (this.Definition.ParentLegend == "Parent")
            return item.ParentItem;
        else
            return null;
    }


MagicWare.SearchForm.CascadingSelectSelectRenderer = function (parent, $container, multipleSelect) {
    ///<field name="parent" type="MagicWare.SearchForm.CascadingSelectSubListControl"></field>    
    ///<field name="$select" type="$">Select obsahujici vyhledavaci hodnoty.</field>
    this.parent = parent;
    this.multipleSelect = multipleSelect;
    this.$select = $("<select />");
    if (this.multipleSelect)
        this.$select.attr("multiple", "multiple");
    $container.append(this.$select);
    var self = this;
    this.$select.change(function () {
        self.parent.OnSelectionChanged();
    });
    this.dataSourceOptionIndexOffset = 0;
}
MagicWare.SearchForm.CascadingSelectSelectRenderer.prototype.
    ResetUI = function() {
        var options = "";
        if (!this.multipleSelect && this.parent.Definition.EmptyItemText != null) {
            options += "<option value=''>" + this.parent.Definition.EmptyItemText + "</option>";
            this.dataSourceOptionIndexOffset = 1;
        }

        var lastParentLegend = null;

        for (var i = 0; i < this.parent.DataSource.length; i++) {
            var item = this.parent.DataSource[i];

            var legendParent = this.parent.GetLegendParent(item);
            if (lastParentLegend != legendParent) {
                if (lastParentLegend != null) {
                    options += "</optgroup>";
                }
                lastParentLegend = legendParent;
                options += "<optgroup label='" + legendParent.Name + "'>";
            }

            var option = "<option value='" + item.Value + "'";
            if (item.IsSelected)
                option += " selected='selected'";
            option += ">" + item.Name + "</option>"

            options += option;
        }

        if (lastParentLegend != null) {
            options += "</optgroup>";
        }

        this.$select.html(options);

        this.$select.trigger("mwCascadingSelectControl-rebuilt");
    }
MagicWare.SearchForm.CascadingSelectSelectRenderer.prototype.
    GetSelectionStates = function() {
        var result = [];
        var options = this.$select.find("option");
        for (var i = this.dataSourceOptionIndexOffset; i < options.length; i++) {
            result.push(options.eq(i).is(":selected"));
        }
        return result;
    }

MagicWare.SearchForm.CascadingSelectCheckBoxListRenderer = function (parent, $container) {
    ///<field name="parent" type="MagicWare.SearchForm.CascadingSelectSubListControl"></field>    
    ///<field name="$container" type="$">Container obsahujici vyhledávací optiony.</field>
    this.parent = parent;
    this.$container = $container;
}
MagicWare.SearchForm.CascadingSelectCheckBoxListRenderer.prototype.
    ResetUI = function() {
        var html = "";

        var lastParentLegend = null;

        for (var i = 0; i < this.parent.DataSource.length; i++) {
            var item = this.parent.DataSource[i];

            var legendParent = this.parent.GetLegendParent(item);
            if (lastParentLegend != legendParent) {
                lastParentLegend = legendParent;
                html += "<label>" + legendParent.Name + "</label>";
            }

            var checkBox = "<div><label><input type='checkbox' value='" + item.Value + "'";
            if (item.IsSelected)
                checkBox += " checked='checked'";
            checkBox += "/><span>" + item.Name + "</span></label></div>\n"

            html += checkBox;
        }
        this.$container.html(html);
        var self = this;
        this.$container.find("input").click(function () {
            self.parent.OnSelectionChanged();
        });

        this.$container.trigger("mwCascadingSelectControl-rebuilt");
    }
MagicWare.SearchForm.CascadingSelectCheckBoxListRenderer.prototype.
    GetSelectionStates = function() {
        var result = [];
        var inputs = this.$container.find("input");
        for (var i = 0; i < inputs.length; i++) {
            result.push(inputs.eq(i).is(":checked"));
        }
        return result;
    }

MagicWare.SearchForm.LiveFormConfiguration = function () {
    this.OnGetDefinition = null;
    this.OnInitForm = null;
    this.OnUpdateForm = null;
}

MagicWare.SearchForm.LiveForm = function (containerSelector, searchForm, config) {
    ///<param name="containerSelector" type="$"></param>
    ///<param name="searchForm" type="MagicWare.SearchForm.Form"></param>
    ///<param name="config" type="MagicWare.SearchForm.LiveFormConfiguration"></param>
    ///<field name="$debugContainer" type="$" />
    ///<field name="$debugDataContainer" type="$" />
    ///<field name="configuration" type="MagicWare.SearchForm.LiveFormConfiguration" />
    this.$debugContainer = containerSelector.find(".live-form-debug");
    this.$debugDataContainer = containerSelector.find(".live-form-data-debug");
    this.configuration = config;
    this.searchForm = searchForm;
    this.lastRequestOrder = 0;
    this.DefaultSelectDisableOnly = false;
    this.DefaultListDisableOnly = false;
}
MagicWare.SearchForm.LiveForm.prototype.DataTypeSet = 0
MagicWare.SearchForm.LiveForm.prototype.DataTypeCountedSet = 1
MagicWare.SearchForm.LiveForm.prototype.DataTypeRange = 2
MagicWare.SearchForm.LiveForm.prototype.
    RefreshFormValues = function() {

        var queryString = this.searchForm.GetQueryString();

        this.$debugDataContainer.text(queryString);

        var searchFormDefinitions = this.configuration.OnGetDefinition();

        this.lastRequestOrder += 1;

        var postData = { RequestOrder: this.lastRequestOrder, LiveSearchFormDefinitions: JSON.stringify(searchFormDefinitions) }

        var handlerUrl = '/LiveSearchFormHandler.ashx?' + queryString;
        handlerUrl = handlerUrl.replace('?&', '?');

        this.lastLoadTime = new Date();
        $.post(handlerUrl, postData, this._OnLoadCompleted.bind(this));
    }
MagicWare.SearchForm.LiveForm.prototype.
    _OnLoadCompleted = function(result) {

        if (result.RequestOrder != this.lastRequestOrder)
            return;

        if (this.$debugContainer.length > 0) {
            this.$debugContainer.html("Loaded in " + (new Date() - this.lastLoadTime) + " ms, ItemsCount: " + result.DataItemsCount);
        }
        if (this.$debugDataContainer.length > 0) {
            var lines = [];
            lines.push("Loaded in " + (new Date() - this.lastLoadTime) + " ms");
            lines.push("ItemsCount: " + result.DataItemsCount);
            for (var i = 0; i < result.Items.length; i++) {
                var item = result.Items[i];
                lines.push(item.SearchFormItemName + "(" + item.DataType + "): " + JSON.stringify(item.Data));
            }
            this.$debugDataContainer.html("");
            for (var i = 0; i < lines.length; i++) {
                this.$debugDataContainer.append(lines[i]);
                this.$debugDataContainer.append("<br />");
            }
        }

        if (result.DebugInfo != null) {
            if (this.$debugContainer.length > 0)
                this.$debugContainer.append("<br />" + result.DebugInfo);
            else if (this.$debugDataContainer.length > 0)
                this.$debugDataContainer.prepend(result.DebugInfo);
            else {
                this.searchForm.$FormContainer.find('.live-search-form-debug-info-auto-container').remove();
                var loadedInString = "Loaded in " + (new Date() - this.lastLoadTime) + " ms, ItemsCount: " + result.DataItemsCount;
                this.searchForm.$FormContainer.prepend("<div class='live-search-form-debug-info-auto-container'>" + loadedInString + result.DebugInfo + "</div>");
            }
        }

        this.configuration.OnUpdateForm(this, result);

        this.searchForm.$FormContainer.trigger("mwLiveSearchForm-updated", [this, result]);
    }
MagicWare.SearchForm.LiveForm.prototype.
    _GetOriginalItems = function($select) {
        ///<param name="$select" type="$"></param>
        ///<returns type="$"></returns>
        return $select.data("OriginalItems");
    }
MagicWare.SearchForm.LiveForm.prototype.
    FindDataItem = function(liveFormData, name) {
        for (var i = 0; i < liveFormData.Items.length; i++) {
            if (liveFormData.Items[i].SearchFormItemName == name)
                return liveFormData.Items[i];
        }
        return null;
    }
MagicWare.SearchForm.LiveForm.prototype.
    UpdateCascadingSelect = function(cascadingSelect, liveFormData, formItemName) {
        ///<param name="cascadingSelect" type="MagicWare.SearchForm.CascadingSelectControl"></param>

        var dataTree = cascadingSelect.GetDataTree();

        var itemContext = this._CreateItemContext(liveFormData, formItemName);

        this._HideCascadingSelectTreeItems(itemContext, dataTree);

        cascadingSelect.Rebuild(dataTree, false);

        cascadingSelect.$container.trigger("mwLiveSearchFormControl-updated");
    }
MagicWare.SearchForm.LiveForm.prototype.
    _HideCascadingSelectTreeItems = function(itemContext, dataTree) {
        for (var i = 0; i < dataTree.length; i++) {
            var item = dataTree[i];
            var count = itemContext.Counter(item.Value, itemContext.FormItem);
            item.IsHidden = count <= 0;
            if (item.Items && item.Items.length > 0) {
                this._HideCascadingSelectTreeItems(itemContext, item.Items);
            }
        }
    }
MagicWare.SearchForm.LiveForm.prototype.
    InitSelect = function(selector) {
        var $select = this.searchForm.$FormContainer.find(selector);
        $select.data("OriginalItems", $select.find("option"));
    }
MagicWare.SearchForm.LiveForm.prototype.
    UpdateSelect = function(liveFormData, selector, formItemName, valueSeparator, disableOnly) {

        if (disableOnly === null || disableOnly === undefined)
            disableOnly = this.DefaultSelectDisableOnly;

        var $select = this.searchForm.$FormContainer.find(selector);
        if ($select.length == 0)
            return;

        var itemContext = this._CreateItemContext(liveFormData, formItemName, "option", valueSeparator);

        var $options = this._GetOriginalItems($select);

        var selectValue = $select.val();

        var $selectedOptions = $options.filter(":selected");

        if (disableOnly)
            $options.prop("disabled", "disabled");
        else
            $options.detach();

        //tohle je fakt haluz - v Chrome se po provedení detach/remove z nějakého 
        //záhadného důvodu mění příznak selected - musíme ho tedy narovnat zpět
        $options.removeAttr("selected");
        $selectedOptions.attr("selected", "selected");

        for (var i = 0; i < $options.length; i++) {
            var $option = $options.eq(i);
            var optValue = $option.attr("value");
            var count = itemContext.Counter(optValue, itemContext.FormItem);
            if ($option.is(":selected") || count > 0) {
                itemContext.Modifier($option, count, optValue);
                if (disableOnly)
                    $option.prop("disabled", null);
                else
                    $select.append($option);
            }
        }

        $select.val(selectValue);

        $select.trigger("mwLiveSearchFormControl-updated");
    }
MagicWare.SearchForm.LiveForm.prototype.
    InitList = function(listSelector, listItemSelector) {
        var $list = this.searchForm.$FormContainer.find(listSelector);
        $list.data("OriginalItems", $list.find(listItemSelector));
    }
MagicWare.SearchForm.LiveForm.prototype.
    UpdateList = function(liveFormData, listSelector, listItemSelector, formItemName, disableOnly, valueSeparator) {

        if (disableOnly === null || disableOnly === undefined)
            disableOnly = this.DefaultListDisableOnly;

        var $list = this.searchForm.$FormContainer.find(listSelector);
        if ($list.length == 0)
            return;

        var itemContext = this._CreateItemContext(liveFormData, formItemName, listItemSelector, valueSeparator);

        var $items = this._GetOriginalItems($list);

        if (!disableOnly)
            $items.detach();

        for (var i = 0; i < $items.length; i++) {
            var $item = $items.eq(i);
            var $input = $item.find("input");
            var optValue = $input.attr("value");
            var count = itemContext.Counter(optValue, itemContext.FormItem);

            var isValid = $input.is(":checked") || count > 0;

            if (disableOnly) {
                itemContext.Modifier($item, count, optValue);
                $input.prop("disabled", !isValid);
                $item.toggleClass("disabled", !isValid);
            } else if (isValid) {
                itemContext.Modifier($item, count, optValue);
                $list.append($item);
            }
        }

        $list.trigger("mwLiveSearchFormControl-updated");
    }
MagicWare.SearchForm.LiveForm.prototype.
    _CreateItemContext = function(liveFormData, formItemName, itemSelector, valueSeparator) {

        var result = {};

        result.FormItem = this.FindDataItem(liveFormData, formItemName);

        result.Counter = null;
        result.Modifier = function () { };
        if (result.FormItem.DataType == this.DataTypeCountedSet) {
            result.Counter = valueSeparator ? this._GetMultiItemCount.bind(this, valueSeparator) : this._GetItemCount.bind(this);
            if (itemSelector == "option")
                result.Modifier = this._AppendItemCountToOption.bind(this);
            else
                result.Modifier = this._AppendItemCountSpan.bind(this);
        } else if (result.FormItem.DataType == this.DataTypeSet) {
            result.Counter = valueSeparator ? this._GetMultiItemCountFromSet.bind(this, valueSeparator) : this._GetItemCountFromSet.bind(this);
        } else if (result.FormItem.DataType == this.DataTypeRange) {
            result.Counter = this._GetItemCountFromRange.bind(this);
        } else {
            result.Counter = function () { return 0; };
        }

        return result;
    }
MagicWare.SearchForm.LiveForm.prototype.
    _AppendItemCountToOption = function($option, count, optionValue) {
        if (optionValue != "") {
            var originalText = $option.data("text");
            if (!originalText) {
                originalText = $option.text();
                $option.data("text", originalText);
            }
            $option.text(originalText + " (" + count + ")");
        }
    }
MagicWare.SearchForm.LiveForm.prototype.
    _AppendItemCountSpan = function($itemContainer, count, optionValue) {
        if (optionValue != "") {
            $itemContainer.find(".count-span").remove();
            var $targetElement = $itemContainer.find("label");
            if ($targetElement.length == 0)
                $targetElement = $itemContainer;
            $targetElement.append(" <span class='count-span'>(" + count + ")</span>");
        }
    }
MagicWare.SearchForm.LiveForm.prototype.
    _GetItemCount = function(value, formItem) {
        for (var i = 0; i < formItem.Data.Values.length; i++) {
            if (formItem.Data.Values[i].Value.toString() == value) {
                return formItem.Data.Values[i].Count;
            }
        }
        return 0;
    }
MagicWare.SearchForm.LiveForm.prototype.
    _GetMultiItemCount = function(valueSeparator, value, formItem) {
        if (value == '')
            return 1;
        var values = value.split(valueSeparator);

        var totalCount = 0;
        for (var vIdx = 0; vIdx < values.length; vIdx++) {
            var singleValue = values[vIdx];
            for (var i = 0; i < formItem.Data.Values.length; i++) {
                if (formItem.Data.Values[i].Value.toString() == singleValue) {
                    totalCount += formItem.Data.Values[i].Count;
                }
            }
        }
        return 0;
    }
MagicWare.SearchForm.LiveForm.prototype.
    _GetItemCountFromSet = function(value, formItem) {
        if (value == '')
            return 1;
        for (var i = 0; i < formItem.Data.Values.length; i++) {
            if (formItem.Data.Values[i].toString() == value) {
                return 1;
            }
        }
        return 0;
    }
MagicWare.SearchForm.LiveForm.prototype.
    _GetItemCountFromRange = function(value, formItem) {
        if (value == '')
            return 1;
        var range = value.split(',');

        range[0] = parseInt(range[0]);
        range[1] = parseInt(range[1]);

        var isMaxRangeOk = isNaN(range[0]) || formItem.Data.MaxValue == null || range[0] <= formItem.Data.MaxValue;
        var isMinRangeOk = isNaN(range[1]) || formItem.Data.MinValue == null || range[1] >= formItem.Data.MinValue;

        if (isMaxRangeOk && isMinRangeOk)
            return 1;
        else
            return 0;
    }
MagicWare.SearchForm.LiveForm.prototype.
    _GetMultiItemCountFromSet = function(valueSeparator, value, formItem) {
        if (value == '')
            return 1;
        var values = value.split(valueSeparator);

        for (var vIdx = 0; vIdx < values.length; vIdx++) {
            var singleValue = values[vIdx];
            for (var i = 0; i < formItem.Data.Values.length; i++) {
                if (formItem.Data.Values[i].toString() == singleValue) {
                    return 1;
                }
            }
        }
        return 0;
    }
