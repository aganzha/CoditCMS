﻿@using CMS.PagesSettings
@using $rootnamespace$
@model Object

@{
    var settings = WebContext.GetSettings();
    var tabsCount = settings.FormSettings.Tabs.Count;
}


@if (tabsCount > 1)
{
    var index = 0;
    @:<div id="edit-form-tabs">
        <ul>
            @foreach (var tab in settings.FormSettings.Tabs)
            {
                index++;
                var name = tab.Name ?? string.Format("tab-{0}", index);
                <li><a href="#tab@(index)">@name</a></li>
            }
        </ul>
}
@RenderTabs(settings)
@if (tabsCount > 1)
{
@:</div>
}

@helper RenderTabs(Settings settings)
{
    var index = 0;
    foreach (var tab in settings.FormSettings.Tabs)
    {
        index++;
        WebContext.CurrentTab = tab;
        <div id="tab@(index)">
            <table class="form-table">
                @{ Html.RenderPartial("EditorTemplates/Shared/ObjectFields"); }
            </table>
        </div>
    }
}