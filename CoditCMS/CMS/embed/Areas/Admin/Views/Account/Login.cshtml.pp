﻿@using System.Configuration
@using $rootnamespace$
@model $rootnamespace$.Areas.Admin.ViewModels.Accounts.LogOnModel
@{
    Layout = "../Shared/_Account.cshtml";
	ViewBag.CoditPageTitle = "CoditCms.cms — Авторизация";    
}    

@using (Html.BeginForm()) 
{
        
    <div class="auth-block">
    <div id="logo"><img src="/Areas/Admin/Images/Default/logo.gif" alt="CoditCms.cms 3.0" /></div>
        <fieldset>
            <legend>Авторизация</legend>
            @Html.ValidationSummary(true, "Ошибка")
            <div class="editor-label">
                @Html.LabelFor(m => m.UserName)
            </div>
            <div class="editor-field">
                @Html.TextBoxFor(m => m.UserName)
                @Html.ValidationMessageFor(m => m.UserName)
            </div>
                
            <div class="editor-label">
                @Html.LabelFor(m => m.Password)
            </div>
            <div class="editor-field">
                @Html.PasswordFor(m => m.Password)
                @Html.ValidationMessageFor(m => m.Password)
            </div>
                
            <div class="editor-label">
                @Html.CheckBoxFor(m => m.RememberMe)
                @Html.LabelFor(m => m.RememberMe)
            </div>
                
            <p>
                <input type="submit" value="Войти" />
            </p>
        </fieldset>
    </div>
}

<script>document.getElementById("UserName").focus();</script>

