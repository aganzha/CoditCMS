﻿@using $rootnamespace$
@{
    WebContext.HtmlPageTitle = "CoditCms.cms — создание объекта";
}

@using (Html.BeginForm("Create", Request.RequestContext.RouteData.Values["controller"].ToString(), FormMethod.Post, new { enctype = "multipart/form-data", id = "edit-form" }))
{
    <table class="form-table">
        <tr><th>Новый объект</th></tr>
    </table>
    
    <input type="hidden" name="returnUrl" value="@WebContext.ReturnUrl"/>

    @Html.ValidationSummary(true)
        
    Html.RenderPartial(Url.Content("~/Areas/Admin/Views/Shared/Form/FormButtons.cshtml"));
    
    @Html.EditorFor(model => model, "CoditCms_Object")
    
    Html.RenderPartial(Url.Content("~/Areas/Admin/Views/Shared/Form/FormButtons.cshtml"));
}
