﻿@using $rootnamespace$
@model DB.Entities.IEntity

<a class="list-action" onclick="if(!confirm('Удалить объект?')) return false;" href="@Url.Action(Constants.DeleteAction, new { id = Model.Id })"><img src="/Areas/Admin/Images/Default/delete.png" alt="Удалить" /></a>