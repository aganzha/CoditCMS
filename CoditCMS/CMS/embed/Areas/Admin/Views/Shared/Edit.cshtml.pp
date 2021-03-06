﻿@using $rootnamespace$
@using $rootnamespace$
@{
    WebContext.HtmlPageTitle = "CoditCms.cms — редактирование объекта";
    Layout = MVC.Admin.Shared.Views._Main;
}

<script type="text/javascript">
    var _editFormId = "edit-form";
</script>

@using (Html.BeginForm(Constants.EditView, Request.RequestContext.RouteData.Values["controller"].ToString(), FormMethod.Post, new { enctype = "multipart/form-data", id = "edit-form" }))
{
    <input type="hidden" name="returnUrl" value="@WebContext.ReturnUrl"/>
    @Html.Hidden("Id")
    <table class="form-table">
        <tr>
            <th>
                @if (WebContext.PrevId.HasValue)
                {
                    <span style="float:left;"> &larr; @Html.ActionLink("Предыдущий элемент", Actions.Edit, new { id = WebContext.PrevId.Value})</span>
                }
                @Html.Raw(Model.ToString())
                @if (WebContext.NextId.HasValue)
                {
                    <span style="float:right;">@Html.ActionLink("Следующий элемент", Actions.Edit, new { id = WebContext.NextId.Value}) &rarr; </span>
                }
            </th>
        </tr>

    </table>

    @Html.ValidationSummary(true)
        
	Html.RenderPartial(Url.Content("~/Areas/Admin/Views/Shared/Form/FormButtons.cshtml"));
    
    @Html.EditorFor(model => model, "CoditCms_Object")
    
	Html.RenderPartial(Url.Content("~/Areas/Admin/Views/Shared/Form/FormButtons.cshtml"));
}