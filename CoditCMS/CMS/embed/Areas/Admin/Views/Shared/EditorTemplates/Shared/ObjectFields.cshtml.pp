﻿@using $rootnamespace$
@using Libs
@{
    var settings = WebContext.CurrentTab;
    var roles = Roles.GetRolesForUser(User.Identity.Name);
    Func<string, bool> allowed = role => string.IsNullOrEmpty(role) || roles.Contains(role);
}


@foreach (var field in settings.Fields.Where(field => allowed(field.RoleName)))
{
    WebContext.FieldSettings = field;
    if (field.Control == "hidden")
    {
        @Html.Editor(field.Name, field.Control, field.Name, new { FieldSettings = field })
    }
    else if (string.IsNullOrEmpty(field.Condition) || (bool)TypeHelpers.GetPropertyValue(Model, field.Condition))
    {
        <tr class="form-table-row">
            @if (field.Control == "hr")
            {
                <td colspan="2">
                    <hr />
                </td>
            }
            else
            {
                <td class="form-table-label">
                    @field.Title
                </td>
                <td class="form-table-data">
                    @Html.Editor(field.Name, field.Control, field.Name)
                    @if (field.Info != null)
                    {
                        <div class="field-info">@field.Info</div>
                    }
                    <div class="error-message">@Html.ValidationMessage(field.Name)</div>
                </td>
            }
        </tr>
    }
}