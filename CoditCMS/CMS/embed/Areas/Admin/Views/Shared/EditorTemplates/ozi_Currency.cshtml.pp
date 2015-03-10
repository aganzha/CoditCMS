﻿@using System.Diagnostics
@using System.Globalization
@using $rootnamespace$
@using CurrencySettings = CMS.PagesSettings.Forms.CurrencySettings

@{
    var fieldSettings = (CurrencySettings)WebContext.FieldSettings;
	Debug.Assert(fieldSettings != null);
    var text = ViewData.TemplateInfo.FormattedModelValue.ToString();
    if (!string.IsNullOrEmpty(text))
    {
        var value = 0m;
        decimal.TryParse(text, out value);
        text = value.ToString("#,#.00");
    }
    var aSep = CultureInfo.CurrentCulture.NumberFormat.CurrencyGroupSeparator;
    var dec = CultureInfo.CurrentCulture.NumberFormat.CurrencyDecimalSeparator;
}
<input data-a-sep="@aSep" data-a-dec="@dec" data-alt-dec="." type="text" name="@ViewData.TemplateInfo.HtmlFieldPrefix" value="@text" class="ozi-currency" @if(fieldSettings.Disabled) { <text>disabled="disabled"</text> } @if(fieldSettings.Readonly) { <text>readonly="readonly"</text> } />
