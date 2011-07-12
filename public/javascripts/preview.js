var basepath;
function init(bp)
{
    basepath = bp;
    $(".play").live('click',play_content);
    $(".courselist .play").live('click',set_upnext);

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
}
function buy_click(e)
{
    $("#buy input[name=ci]").val($(this).attr('rel'));
//    console.log($("#buy input[name=ci]").val());
//    return false;
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
function set_upnext(evt)
{
    var next = $(this).parents('li').next();
    if (next.length == 0) 
        $(".upnext").text('');
    else
        $(".upnext").text('Next: ' + next.find('.play').text().split('$')[0]);
    

    //evt.preventDefault();
}
function play_content(evt)
{
    $('#courselist').find('.nowplaying').removeClass('nowplaying');
    $(this).parent().addClass('nowplaying');
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
