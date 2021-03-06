﻿@using System.Collections
@using System.ComponentModel
@using CMS.Controllers
@using CMS.Helpers
@using CMS.PagesSettings.Forms
@using $rootnamespace$
@using $rootnamespace$.Core
@using DB.Entities
@using Libs

@{
    
    /*  описание свойств:
     * 
     
   		string Data - имя ключа, по которому можно получить список элементов для селекта
		string OptionTitle - текст
		string OptionValue - ключ
		List<OptionSettings> Options - предпределённые элементы
		bool Levels - использует ли вложенность
		bool Multiple - доступен ли множественный выбор

		string TypeName - тип, с помощью которого можно получить данные
		string PropertyName - свойство, возвращающее список доступных элементов (работает только при указанном типе)
		string MethodName - метод, возвращающий список доступных элементов (работает только при указанном типе)

     * если по данным ничего не установлено, берутся значения из бд по типу
     
     * 
     *  принцип работы
     *     берём текущее значение из модели
     *     если оно не указано, смотрим, есть ли такое значение в предопределённых (PreValue должно быть выставлено в true), если да, то устанавливаем именно его
     *     
     *      получаем данные: сначала просматривается свойство Data, если оно пустое, то тип, в котором свойство или метод, через которые и получаем данные
     *      
     * 
     */


    var fieldSettings = (SelectSettings)WebContext.FieldSettings;

    var model = TypeHelpers.GetPropertyValue(WebContext.Model, fieldSettings.Name, null); // текущее значение свойства

    var modelString = model != null ? model.ToString() : "";
    if (fieldSettings.PreValue && string.IsNullOrEmpty(modelString))
    {
        modelString = Session[string.Format("prevalue_{0}_{1}", fieldSettings.Name, ViewBag.EditViewModel.FormData.GetType().Name)];
    }

    IEnumerable<object> data = null;

    if (!string.IsNullOrEmpty(fieldSettings.Data))
    {
        data = (IEnumerable<object>)WebContext.ViewData[fieldSettings.Data];
    }
    else if (!string.IsNullOrEmpty(fieldSettings.TypeName))
    {
        if (!string.IsNullOrEmpty(fieldSettings.PropertyName))
        {
            data = (IEnumerable<object>)TypeHelpers.GetPropertyValue(fieldSettings.TypeName, fieldSettings.PropertyName);
        }
        else if (!string.IsNullOrEmpty(fieldSettings.MethodName))
        {
            data = (IEnumerable<object>)TypeHelpers.ExecuteMethod(fieldSettings.TypeName, fieldSettings.MethodName);
        }
    }
    else if (!string.IsNullOrEmpty(fieldSettings.Reference))
    {
        var db = ((CoditController)ViewContext.Controller).DataModelContext;
        if (db != null)
        {
            var t = TypeHelpers.GetPropertyType(WebContext.ModelType, fieldSettings.GetFullPropertyName());
            var d = TypeHelpers.GetEntitySet(db, t).Cast<IEntity>();
            
            if (typeof(ISortableEntity).IsAssignableFrom(t))
            {
                d = d.OrderBy(entity => ((ISortableEntity)entity).Sort);
            }

            if (fieldSettings.Levels)
            {
                d = PlainTree.GetTree(d.Cast<IPlainTreeItem>().Where(p => WebContext.Model == null || (p.GetType() != WebContext.Model.GetType() || (p.ParentId != WebContext.Model.Id || p.ParentId == null) && p.Id != WebContext.Model.Id)));
            }
            data = d.ToList();
        }
    }
}

@if (!fieldSettings.Editable)
{

    <select name="@ViewData.TemplateInfo.HtmlFieldPrefix" class="ozi-select" 
        @if (fieldSettings.Multiple)
        {
            <text>multiple="multiple" style="width: 400px;"</text>
            if (fieldSettings.Height != 0)
            {
                <text>size="@(fieldSettings.Height)"</text>
            }
        } 
        @if (fieldSettings.Disabled)
        { <text>disabled="disabled"</text> }
        @if (fieldSettings.Readonly)
        { <text>readonly="readonly"</text>}>
        
        @foreach (OptionSettings option in fieldSettings.Options)
        {<option @IsValue(option.Value, model, modelString) value="@option.Value">@option.Title</option>}
        @if (data != null)
        {
            foreach (var option in data)
            {
                var optionValue = TypeHelpers.GetPropertyValue(option, fieldSettings.OptionValue).ToString();
                var value = TypeHelpers.GetPropertyValue(option, fieldSettings.OptionTitle);
                if (fieldSettings.Localizable && value is Guid)
                {
                    value = Lp.GetMessage((Guid) value);
                }
                <option @IsValue(optionValue, model, modelString) value="@optionValue">@if (fieldSettings.Levels)
                                                                                       {
                                                                                           for (var i = 0; i < (Int32.Parse(TypeHelpers.GetPropertyValue(option, "Level").ToString()) - 1); i++)
                                                                                           {<text>&nbsp;-&nbsp;</text>}<text>○&nbsp;</text> }@value</option>
            }
        }
    </select>
}
else
{
    string val = string.Empty;
    string label = string.Empty;
    if (model != null)
    {
        if (fieldSettings.Multiple)
        {
            label = string.Join(", ", ((IListSource) model).GetList().Cast<object>().ToList().Select<object, string>(a => (TypeHelpers.GetPropertyValue(a, fieldSettings.OptionTitle)).ToString()));
        }
        else
        {
            label = (TypeHelpers.GetPropertyValue(model, fieldSettings.OptionTitle)).ToString();
            val = (TypeHelpers.GetPropertyValue(model, fieldSettings.OptionValue)).ToString();
        }
    }
    <input type="hidden" name="@(fieldSettings.Name).@(fieldSettings.OptionValue)" id="@(fieldSettings.Name)_@(fieldSettings.OptionValue)" value="@val" />
    <input value="@label" class="autocomplete ozi-string" type="text" @Html.Raw(ByCondition(fieldSettings.Multiple, "multiple='true'")) data-hiddenid="@(fieldSettings.Name)_@(fieldSettings.OptionValue)" data-sourcename="@(fieldSettings.Name)" name="@(fieldSettings.Name).@(fieldSettings.OptionTitle)" />
    <script>
        var d;
        try {
            d = $("body").data("@(fieldSettings.Name)");
        } catch(e) {
            
        }
        if (!d) {
                d = [
                    @foreach (var option in data)
                    {
                        var optionValue = TypeHelpers.GetPropertyValue(option, fieldSettings.OptionValue).ToString();
                        var value = TypeHelpers.GetPropertyValue(option, fieldSettings.OptionTitle);
                        <text>{ value: '@optionValue', label : '</text>if (fieldSettings.Levels){for (var i = 0; i < (Int32.Parse(TypeHelpers.GetPropertyValue(option, "Level").ToString()) - 1); i++){<text>&nbsp;-&nbsp;</text>}<text>○&nbsp;</text>}<text>@value'},</text>
                    }
                ];
                $("body").data("@(fieldSettings.Name)", d);
            }
    </script>
}
@*
    curVal - текущее значение рендеринга
    model - исходное значение
    mString - строковое представление исходного значения
*@


@helper IsValue(string curVal, object model, string mString = null)
{
    if (mString != null && curVal == mString)
    {
        <text>selected="selected"</text>
    }
    if (model is string && curVal == (string)model)
    {
        <text>selected="selected"</text>
    }
    else if (model is IEnumerable && !(model is string))
    {
        var list = ((IEnumerable)model).Cast<IEntity>();
        if (list.Any(entity => entity.Id.ToString() == curVal))
        {
            <text>selected="selected"</text>
        }
    }
    else if (model != null)
    {
        var modelString = model.ToString();
        if (modelString.Equals(curVal, StringComparison.InvariantCultureIgnoreCase))
        {
            <text>selected="selected"</text>
        }
    }
}