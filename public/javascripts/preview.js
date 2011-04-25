var basepath;
function init(bp)
{
    basepath = bp;
    $(".play").live('click',play_content);
    $(".playlist").tabs();    
    $(".buy").click(buy_click);
    $(".playlist .play").first().click();
    $(".ddl").click(function(e)
    {
        $($(this).attr('rel')).toggle();
        e.preventDefault();
    });
    $(".buybutton").click(function(e)
    {
        e.preventDefault();
        $("#buy").submit();
    });
}
function buy_click(e)
{
    $("#buy input[name=ci]").val($(this).attr('rel'));

    if ($(this).hasClass('popup_login'))
    {
        $(".popup").dialog();
        var self = $(this);
        $(".popup").show();
        $(".done").click(function(e)
        {
            $(this).parents('.popup').hide();
            self.removeClass('popup_login');
            e.preventDefault();
        })
        e.preventDefault();
        return;
    }
    $("#buy").submit();
    e.preventDefault();
}

function play_content(evt)
{
    $.ajax({
        url: basepath + '/../contents/show/'+$(this).attr('cid'),
        type: 'GET',
        dataType : 'json',
        data: {},
        success : function(resp)
        {
            $(".player").html(resp.content.contentboxhtml);
            $(".title").text(resp.content.title);
            $(".tagline").text(resp.content.tagline);
            $(".player *").css({"width": "500px","height":"400px"});
            $(".ipad").attr('href',resp.content.ipad);
            $(".iphone").attr('href',resp.content.iphone);
            $("ul.referencelist").empty();
            $.each(resp.references,function(i,v){
                $("ul#referencelist").append('<li>'+v.html+'</li>');
            });
            $.each(resp.subcontents,function(i,v){
                $("ul#morelist").append('<li>'+v.contentboxhtml+'</li>');
            });
        }
    });
    evt.preventDefault();
}