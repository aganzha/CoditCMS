﻿@using $rootnamespace$.Models
@{
    var field = (ReferralField)WebContext.Model;
    var vm = new ReferralNameValueViewModel
        {
            Field = field,
        };
}

<style>
    dl {}
    dt { float: left;font-weight: bold;font-family: monospace;padding-right: 15px;}
    dt:after { content: ' — ';}
    dd {}

    
/*refferal*/
#refferal { border:3px solid #f2f2f2; padding:10px; font-size:12px; }
#refferal * { font-family:Arial; }
#refferal div { margin:0 0 18px 0; }
#refferal div span { margin:0 10px; font-size:22px; }
#refferal .text, #refferal .text-box { border:1px solid #000; margin-left:10px; vertical-align:middle; width:300px; padding:4px 0; }
#refferal .chkbx { margin:0 10px 0 0; vertical-align:middle; }
#refferal .field { width:150px; display:inline-block; }
#refferal #tooths-c { border:1px solid #000; padding:3px 0; width:562px; margin:0 auto 22px auto; }
#refferal #tooths { border:0; margin:0 auto; }
#refferal #tooths td { width:50%; border:0; text-align:center; font-size:12px; padding:5px 2px; }
#refferal #tooths td input { vertical-align:middle; margin:0 1px 0 0; }
#refferal #tooths td label, #refferal #tooths td span { margin:0 4px 0 0; vertical-align:middle; font-size:14px; }
#refferal .d-item { background:#f2f2f2; padding:6px 10px; text-align:left; }
#refferal .d-item textarea { margin:0; padding:0; width:80%; height:100px; }
#refferal .serviceCalc {float: right;margin-top: -10%;}
	
</style>
<link href="~/Areas/Admin/Styles/Default/sh_style.css" rel="stylesheet" />
<script src="~/Areas/Admin/Scripts/Default/sh_main.min.js"></script>
<script src="~/Areas/Admin/Scripts/Default/sh_html.min.js"></script>
<script src="~/Areas/Admin/Scripts/Default/sh_javascript.min.js"></script>

<p>Если у данной услуги особый способ расчёта цены, необходимо написать функцию, которая будет возвращать значение по выбранным параметрам.</p>
<p>Метод будет вызываться при каждой итерации расчёта цены.</p>
<p>Можно использовать методы библиотеки jQuery.</p>
<p>Параметры, передаваемые в функцию:</p>

<dl>
    <dt>property</dt>
    <dd>
        Корневой элемент, свойство
    </dd>
</dl>
<dl>
    <dt>values</dt>
    <dd>Коллекция дочерних элементов, значения свойства</dd>
</dl>

<p>Конечная разметка для текущего поля выглядит так:</p>
<pre class="sh_html sh_sourceCode">@Html.Encode(Html.EditorFor(m => vm, string.Format("fields/{0}", field.Type)))</pre>

<p>Пример для стандартного способа</p>
<pre class="sh_javascript sh_sourceCode">    function(property, values) {
        if (!!property.data("price") && 
            ((values.length == 0 && property.is(":checked")) || values.filter(':checked').length > 0)) { // Если для элемента указана цена, то возвращаем её
            return parseFloat(property.data("price").toString().replace(",", "."));
        }
        // суммируем выделеные дочерние элементы
        var cp = values.filter(':checked').map(function() {
            var price = $(this).data("price");
            if (!price)
                return 0;
            return parseFloat(price.toString().replace(",", "."));
        });
        return Math.sum(cp) || 0;
    };
</pre>

<script>
    $(function () {
        sh_highlightDocument();
    });
</script>