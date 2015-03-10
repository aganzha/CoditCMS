﻿@using System.Collections
@using System.ComponentModel
@using CMS.Controllers
@using CMS.PagesSettings.Forms
@using DB.Entities
@using Libs
@using DateSettings = CMS.PagesSettings.Forms.DateSettings
@using StringSettings = CMS.PagesSettings.Forms.StringSettings

@{
    var settings = (CollectionSettings)WebContext.FieldSettings;
    var model = WebContext.Model;
}

@if (model == null)
{
    <div>
        Необходимо сначала сохранить объект
    </div>
}
else
{

    @*    
    // генерация пустых значений для имён (это если будет удалена вся коллекция)
    @RenderIds(settings);
    
    // генерация вьюхи
    *@
    
    <div class="knockout-root" id="@(settings.Name)List" >
        <ul data-bind="{foreach: { data: elements, afterRender: renderPlugins }}">
            @RenderView(settings)
        </ul>
        @RenderButtons(settings)
    </div>
    //   генерация скриптов (модели и вьюмодели, а также их инициализация)
    
    <script>
@RenderModel(settings)
var @(settings.Name)ViewModel = function() {
    var self = this;
    self.plugins = [];
    self.renderPlugins = function() {
        $(self.plugins).each(function(index, f) {
            f();
        });
        self.plugins = [];
        //alert("hi viewModel!");
    };
    self.elements = ko.observableArray([]);
    self.add@(settings.Name)Item = function() {
        self.elements.push(new @(settings.GetFullPropertyName().Replace(".", string.Empty))Model({}, self.elements().length, self.elements, self));
    };
};

        $(function() {
            var vm = new @(settings.Name)ViewModel();
            var elems = @RenderInitModelValues(settings, model);
            $.each(elems, function(index, elem) {
                @{ var parentElName = settings.GetFullPropertyName().Replace(".", string.Empty); }
                var elem@(parentElName) = new @(parentElName)Model(elem, index, vm.elements, vm); // инициируем обычные поля
                @RenderInitViewModel(settings, parentElName)
                vm.elements.push(elem@(parentElName));
            });
            ko.applyBindings(vm, $("#@(settings.Name)List").get(0));
        });
    </script>
}

@helper RenderView(CollectionSettings settings)
{
    <li>
        <input type="hidden" data-bind="{value: ItemId, attr: { name: generateName() + '.Id' }}"/>
        @foreach (var item in settings.Fields)
        {
            <div class="collection-item">
                <label>@(item.Title)</label>
                @if (item is CollectionSettings)
                {
                    <ul data-bind="{foreach: { data: @item.Name, afterRender: renderPlugins}}">
                        @RenderView((CollectionSettings) item)
                    </ul>
                    @RenderButtons((CollectionSettings) item)
                }
                else
                {
                    @RenderPropertyView(item)
                }
            </div>
        }
        <input type="button" value="Удалить" data-bind="{click: removeItem}"/>
    </li>
}

@*@helper RenderIds(CollectionSettings settings)
{
    <input type="hidden" name="@(settings.GetFullPropertyName())" />
    foreach (var item in settings.Fields.Where(fieldSettings => fieldSettings is CollectionSettings))
    {
        @RenderIds((CollectionSettings)item);
    }
}*@

@helper RenderButtons(CollectionSettings settings)
{
    <input type="button" value="Добавить" data-bind="{click: add@(settings.Name)Item}"/>
}

@helper RenderInitViewModel(CollectionSettings settings, string parentElName)
{
    foreach (var item in settings.Fields.GetOf<FieldSettings, CollectionSettings>())
    {
        // инициируем коллекции
        var elName = item.GetFullPropertyName().Replace(".", string.Empty);
        <text>
            $.each(elem.@(item.Name), function(index, elem@(elName)){
                var item@(elName) = new @(elName)Model(elem@(elName), index, elem@(parentElName).@(item.Name), elem@(parentElName));
                @RenderInitViewModel(item, elName)
                elem@(parentElName).@(item.Name).push(item@(elName));
            });
        </text>
    }
}

@helper RenderInitModelValues(CollectionSettings settings, IEntity model)
{
    // тут генерируем JSON для наших объектов
    var simpleFields = settings.Fields.GetNotOf<FieldSettings, CollectionSettings>().ToList();
    var children = settings.Fields.GetOf<FieldSettings, CollectionSettings>().ToList();
    var values = (IEnumerable)TypeHelpers.GetPropertyValue(model, settings.Name);
    @:[ 
    foreach (var item in values)
    { 
        <text>{</text>
        foreach (var field in simpleFields)
        { @GenerateJsonField(field, item) }
        foreach (var child in children)
        { <text> @(child.Name): @RenderInitModelValues(child, (IEntity)item), </text> } 
        <text> ItemId: @(((IEntity)item).Id), CoditPropertiesPath: '@(settings.GetFullPropertyName())'},</text>
    }
@:]
}

@helper GenerateJsonField(FieldSettings field, object item)
{
    var val = TypeHelpers.GetPropertyValue(item, field.Name);
    if (field is UploadFileSettings)
    {
        <text>@(field.Name): '@(val == null ? string.Empty : Url.Content(((IFileEntity)val).Name))',</text>
    }
    else if (val != null)
    {
        <text>@(field.Name): '@Html.Raw(val.ToString().Replace("'", "\\'"))',</text>
    }
}

@helper RenderModel(CollectionSettings settings)
{
    var db = ((CoditController) ViewContext.Controller).DataModelContext;
    foreach (var item in settings.Fields.GetOf<FieldSettings, CollectionSettings>())
    {
@RenderModel(item)
    }
    var thisModelName = settings.GetFullPropertyName().Replace(".", string.Empty);
<text>var @(thisModelName)Model = function(m, index, parentCollection, parent){                           @*  создание класса модели  *@
    var self = this;
    self.plugins = [];
    self.renderPlugins = function() {
        $(self.plugins).each(function(index, f){
            f();
        });
        self.plugins = [];
    };
    self.index = ko.observable(index);
    self.ItemId = ko.observable(m.ItemId || 0);
    self.ModelId = @(WebContext.Model != null ? WebContext.Model.Id : 0);
    self.parent = parent;
    self.propName = '@(settings.Name)';
    self.parentCollection = parentCollection;

    @foreach (var item in settings.Fields.GetNotOf<FieldSettings, CollectionSettings>())
    {    <text>self.@(item.Name) = ko.observable(m.@(item.Name));</text> }

    @foreach (var item in settings.Fields.GetOf<FieldSettings, SelectSettings>())
    {
        var type = TypeHelpers.GetPropertyType(WebContext.Model, item.GetFullPropertyName());
        var list = ((IListSource)TypeHelpers.GetEntitySet(db, type)).GetList().Cast<object>().Select<object, string>(a => string.Format("{{value: {0}, label: '{1}'}}", TypeHelpers.GetPropertyValue(a, item.OptionValue), TypeHelpers.GetPropertyValue(a, item.OptionTitle)));
        <text>self.available@(item.Name) = [@Html.Raw(string.Join(",", list))];</text>
        <text>self.newValue = '';</text>
        <text>$("body").data("@(item.GetFullPropertyName().Replace(".", "_"))", self.available@(item.Name));</text>
        <text>self.current@(item.Name) = ko.computed({ 
            read: function(){
                var result = $(self.available@(item.Name)).filter(function(index, el){
                    return el.value == self.@(item.Name)();
                });
                return (result && result.length > 0) ? result[0].label : self.newValue;
            }, 
            write: function(value){
                var result = $(self.available@(item.Name)).filter(function(index, el){
                    return el.value == value;
                });
                if (result && result.length > 0) {
                    self.newValue = '';
                    self.@(item.Name)(result[0].value);
                } else {
                    self.newValue = value;
                    self.@(item.Name)(0);
                }
            },
            owner: self});</text>
        <text>self.parent.plugins.push(function(){
            makeAutocomplete($("#" + self.generateId() + "_@(item.OptionTitle)").get(0));
        });</text>
    }

    @foreach (var item in settings.Fields.GetOf<FieldSettings, UploadFileSettings>())
    {
        <text>self.parent.plugins.push(function(){
            makeFileUpload("#" + self.generateId() + "_@(item.Name)");
        });</text>
        <text>self.show@(item.Name)img = ko.computed(function(){
            return !!self.ItemId() && !!self.ModelId && !!self.@(item.Name)();
        }, self);</text>
        <text>self.show@(item.Name)panel = ko.computed(function(){
            return !!self.ItemId() && !!self.ModelId;
        }, self);</text>
        <text>self.show@(item.Name)text = ko.computed(function(){
            return !self.ItemId() || !self.ModelId;
        }, self);</text>
    }

    @foreach (var item in settings.Fields.GetOf<FieldSettings, CollectionSettings>())
    {    <text>
            self.@(item.Name) = ko.observableArray([]);
            self.add@(item.Name)Item = function(){
                self.@(item.Name).push(new @(item.GetFullPropertyName().Replace(".", string.Empty))Model({}, self.@(item.Name)().length, self.@(item.Name), self));
            };
         </text> 
    }
        self.removeItem = function(item){
            if(confirm("Удалить элемент?")){
                self.parentCollection.remove(self);
                $(self.parentCollection()).each(function(i, e){
                    e.index(i);
                });
            }
        };
        self.generateName = ko.computed(function(){
            var parentName = '';
            var prefix ='';
            if (!!this.parent && !!this.parent.generateName) parentName = this.parent.generateName() + ".";
            else prefix = 'collection_';
            return prefix + parentName + this.propName + "[" + this.index() + "]";
        }, self);
        self.generateId = ko.computed(function(){
            return self.generateName().replace(/[\[\]\.]/g, "_");//.replace(".", "_").replace("[", "_").replace("]", "_");
        }, self);
    };
    </text>
}


@*    Вьюхи для отдельных типов данных    *@

@*@helper StringPropertyView(StringSettings settings)
{
    Html.RenderPartial("EditorTemplates/Collections/ozi_String", settings);
}

@helper TextareaPropertyView(TextareaSettings settings)
{
    Html.RenderPartial("EditorTemplates/Collections/ozi_Textarea", settings);
}

@helper WysiwygPropertyView(WysiwygSettings settings)
{
    //<textarea data-bind="{text: @(settings.Name), attr: { name: generateName() + '.@(settings.Name)' }}"></textarea>

    ViewBag.Bind = string.Format("{{text: {0}, attr: {{ name: generateName() + '.{0}' }}}}", settings.Name);
    var set = WebContext.FieldSettings;
    WebContext.FieldSettings = settings;
    Html.RenderPartial("EditorTemplates/ozi_Wysiwyg");
    WebContext.FieldSettings = set;
    ViewBag.Bind = string.Empty;
}

@helper SelectPropertyView(SelectSettings settings)
{
    Html.RenderPartial("EditorTemplates/Collections/ozi_Select");
}

@helper DatePropertyView(DateSettings settings)
{
    <input type="text" data-bind="{value: @(settings.Name)}"/>
}

@helper UploadFilePropertyView(UploadFileSettings settings)
{
    Html.RenderPartial("EditorTemplates/Collections/ozi_File");
}*@

@helper RenderPropertyView(FieldSettings settings)
{
    Html.RenderPartial(string.Format("EditorTemplates/Collections/{0}", settings.Control), settings);

    
    //if (settings is StringSettings)
    //{
    //    @StringPropertyView((StringSettings)settings)
    //}
    //else if (settings is DateSettings)
    //{
    //    @DatePropertyView((DateSettings)settings)
    //}
    //else if (settings is TextareaSettings)
    //{
    //    @TextareaPropertyView((TextareaSettings)settings)
    //}
    //else if (settings is WysiwygSettings)
    //{
    //    @WysiwygPropertyView((WysiwygSettings)settings)
    //}
    //else if (settings is SelectSettings)
    //{
    //    @SelectPropertyView((SelectSettings)settings)
    //}
    //else if (settings is UploadFileSettings)
    //{
    //    @UploadFilePropertyView((UploadFileSettings)settings)
    //}
}
