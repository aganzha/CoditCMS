﻿@using $rootnamespace$
@model DB.Entities.ISortableEntity

<input type="hidden" name="SortListItems.Index" value="@Model.Id" />
<input type="hidden" name="SortListItems[@Model.Id].Id" value="@Model.Id" />
<input type="text" name="SortListItems[@Model.Id].Sort" class="sort" value="@Model.Sort" />
