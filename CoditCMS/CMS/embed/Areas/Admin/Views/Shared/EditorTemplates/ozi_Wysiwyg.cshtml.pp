﻿@using CMS.PagesSettings.Forms
@using $rootnamespace$

@{
    var fieldSettings = (WysiwygSettings)WebContext.FieldSettings;
    var value = ViewData.TemplateInfo.FormattedModelValue;
    var bind = (string)ViewBag.Bind;
}
<textarea class="wysiwyg" @Html.Raw(string.IsNullOrEmpty(bind) ? string.Empty : string.Format("data-bind=\"{0}\"", bind) ) name="@ViewData.TemplateInfo.HtmlFieldPrefix" id="ck-@ViewData.TemplateInfo.HtmlFieldPrefix" class="ozi-textarea" @if(fieldSettings.Rows != 0) {<text> rows="@fieldSettings.Rows" </text>} else {<text> rows="10" </text>}>@value</textarea>
