﻿@using $rootnamespace$
@using Libs
<!DOCTYPE html>

<html>
<head>
    <title>@WebContext.HtmlPageTitle</title>
    <link href="~/Areas/Admin/Scripts/Default/jqueryUI/development-bundle/themes/base/jquery.ui.all.css" rel="stylesheet" type="text/css" />
    <link href="~/Areas/Admin/Styles/Default/jquery-ui-timepicker-addon.css" rel="stylesheet" />
    <link href="~/Areas/Admin/Styles/Default/fileuploader/fineuploader.css" rel="stylesheet" />
    <link href="~/Areas/Admin/Styles/Default/toastr/toastr.css" rel="stylesheet" />
    <link href="~/Areas/Admin/Styles/Default/toastr/toastr-responsive.css" rel="stylesheet" />
    <link href="~/Areas/Admin/Styles/Default/Default.css" rel="stylesheet" type="text/css" />
    <script src="~/Scripts/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script src="~/Areas/Admin/Scripts/Default/jqueryUI/development-bundle/ui/minified/jquery-ui.custom.min.js" type="text/javascript"></script>
    <script src="~/Areas/Admin/Scripts/Default/jqueryUI/development-bundle/ui/i18n/jquery.ui.datepicker-ru.js" type="text/javascript"></script>
    <script src="~/Areas/Admin/Scripts/Default/drag/jquery.dragsort-0.5.1.min.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/util.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/button.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/header.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/header.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/handler.base.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/handler.form.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/handler.xhr.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/uploader.basic.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/dnd.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/uploader.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/fileuploader/jquery-plugin.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/jqueryUI/js/jquery-ui-sliderAccess.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/jqueryUI/js/jquery-ui-timepicker-addon.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/jqueryUI/js/ui.datepicker-ru.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/jqueryUI/js/jquery-ui-timepicker-ru.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/knockout/knockout-2.2.1.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/knockout/knockout-sortable.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/toastr/toastr.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/autoNumeric.js"></script>
    <script src="~/Areas/Admin/Scripts/Default/Default.js" type="text/javascript"></script>
    <script src="~/Areas/Admin/Scripts/Default/Mktree.js" type="text/javascript"></script>
	<script src="~/Areas/Admin/Ckeditor/ckeditor.js" type="text/javascript"></script>
	<script src="~/Areas/Admin/Scripts/Default/Myckconfig.js" type="text/javascript"></script>
    <script src="~/Areas/Admin/Scripts/Default/files-logic.js"></script>
</head>

<body>

    <table id="logo-table">
        <tr>
            <td id="logo-left"><div id="logo"><img src="@Url.Content("~/Areas/Admin/Images/Default/logo.gif")" alt="CoditCms.cms 4.0" /><div id="ozi-version">Версия — 4.0</div></div></td>
            <td id="logo-right"><span id="hello">Здравствуйте, @Request.ServerVariables["AUTH_USER"] <a href="@Url.Action(MVC.Admin.Account.Logout())">Выйти</a></span></td>
        </tr>
    </table>

    <table id="main-table">
        <tr>
            <td id="main-left">
                <div class="root">Konig Labs</div>
                
                
                @helper RenderModulesTree(IEnumerable<SitemapElement> modules)
                    {
                    foreach (var child in modules)
                    {
                        if (child.Childs.Count > 0)
                        {
                            <li><span class="folder">@child.Title</span>
                                <ul>
                                    @RenderModulesTree(child.Childs)
                                </ul>
                            </li>
                        }
                        else
                        {
                            <li><a @if (child.Controller == (string)ViewContext.RouteData.Values["Controller"] && 
                                       (string.IsNullOrEmpty(child.Action) || child.Action == (string)ViewContext.RouteData.Values["action"])){ <text>class="selected"</text> } href="@Url.Action(child.Action, child.Controller)">@child.Title</a></li>
                        }
                    }
                }
                
                <ul class="mktree" id="modules-ul">
                    @RenderModulesTree(new Sitemap(@Url.Content("~/Areas/Admin/Modules.sitemap")).SitemapList)
                </ul>
                
                <div id="left-menu">
                    <div class="header">Функции</div>
                    <div class="left-function"><a  href="@Url.Action(MVC.Admin.Utils.ClearApplicationCache())">Очистить кэш</a></div>
                    <div class="left-function"><a target="_blank" href="@Url.Action(MVC.Default.Index())">На главную</a></div>
                </div>
                
            </td>
            
            <td id="main-right">
                @RenderBody()
            </td>
        </tr>
    </table>
</body>
</html>
