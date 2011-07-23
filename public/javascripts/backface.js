function backface(options)
{
    var uid = function()
    {
        return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    }
    var guid = uid();
    var tgt = options.target
    var default_text = "";
    $(tgt).addClass("backface_input");

    if ($(tgt).val().length == 0)
       $(tgt).val(default_text);

    var frontface = $('<h2 class="backface"><a href="">'+$(tgt).val()+'</a></h2>');
    frontface.data('bfguid',guid).addClass('bfguid');
    frontface.insertAfter(tgt);


    $(tgt).data('bfguid',guid).addClass('bfguid');
    $(tgt).hide();

    $(tgt).blur(function(evt)
    {
        var found = $('.bfguid').filter(function(emt) {return $(this).is('h2') && $(this).data('bfguid') == guid;});

        $(this).hide();
        $(found).show();
        $(frontface).find('a').text($(tgt).val());
        if(options.change)
           options.change(evt)
        $(tgt).trigger('bfblur');
        evt.preventDefault();
    });
    $(frontface).click(function(evt)
    {
        var found = $('.bfguid').filter(function(emt) {return $(this).is($(this).get(0).tagName) && $(this).data('bfguid') == guid;});
        $(found).show();
        $(found).select();
        $(found).keypress(function(e)
        {
           var code = (e.keyCode ? e.keyCode : e.which);
           if (code == 13)
           {
               $(tgt).blur();
               $(found).unbind('keypress');
           }
               
        });
        $(frontface).hide();
        $(tgt).trigger('bfclick');
        evt.preventDefault();
    });
    $(tgt).trigger('loaded');
}