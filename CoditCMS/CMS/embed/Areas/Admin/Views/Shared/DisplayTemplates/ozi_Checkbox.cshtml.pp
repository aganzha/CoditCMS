﻿@using $rootnamespace$
<div style="text-align:center;">@Html.CheckBox("",Boolean.Parse(ViewData.TemplateInfo.FormattedModelValue.ToString()),  new { @class = "ozi-checkbox", @disabled="true" })</div>