﻿@using CMS.PagesSettings.Forms
@using $rootnamespace$
@model TextareaSettings
@{
    var bind = string.Format("{{text: {0}, attr: {{ name: generateName() + '.{0}' }}}}", Model.Name);
}
<textarea 
    @Html.Raw(string.Format("data-bind=\"{0}\"", bind) ) 
    class="ozi-textarea" 
    @if (Model.Rows != 0) {<text> rows="@Model.Rows" </text>} else {<text> rows="10" </text>}></textarea>