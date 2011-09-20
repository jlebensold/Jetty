var basepath;



function init(bp)
{
    basepath = bp;
    $("a.play").live('click',play_content);
    $(".playlist").tabs();    
    $(".buy").click(buy_click);
    $(".courselist .play").first().click();
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
    $(".close").click(function(ev)
    {
        $(this).parents('.popup').hide();
        ev.preventDefault();
    });
}
function buy_click(e)
{
    e.preventDefault();
    var cid = $(this).attr('rel');
    $("#buy input[name=ci]").val(cid);
    //console.log($(this).attr('rel'));
    $("#purchase_title").text($("#courselist li[data-cid="+cid+"] .title").text());
    if ($(this).hasClass('popup_login'))
    {
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
    else
    {
        $(".popup").show();
    }
//    $("#buy").submit();

}
function play_content(evt)
{
    evt.preventDefault();
    $('#courselist').find('.nowplaying').removeClass('nowplaying');
    $('#courselist').find('.medium_gradient').removeClass('medium_gradient');
    $('#courselist').find('.hard_gradient').removeClass('hard_gradient');
    $(this).parent().addClass('nowplaying');
    $(this).parent().addClass('medium_gradient');
    $(this).parent().find('.soft_gradient').addClass('hard_gradient');
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
            $(".player *").css({"width": "675px","height":"380px"});
            $(".ipad").attr('href',resp.content.ipad);
            $(".iphone").attr('href',resp.content.iphone);
            $("ul#referencelist,ul#morelist").empty();
            $.each(resp.references,function(i,v){
                $("ul#referencelist").append('<li class="link">'+v.html+'</li>');
            });
            $.each(resp.subcontents,function(i,v){
                var src = v.src;
                if (v.type == "Image")
                    src = v.large;                
                $("ul#morelist").append('<li class="'+v.type+'"><a href="'+src+'">'+v.title+'</a></li>');
            });
        }
    });
}
