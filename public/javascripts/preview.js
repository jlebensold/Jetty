var basepath;
function init(bp)
{
    basepath = bp;
    $(".play").live('click',play_content);
    $(".tablist li a").click(toggle_tabs);
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
            $(".player *").css({"width": "600px","height":"400px"});
            $("ul.referencelist").empty();
            $.each(resp.references,function(i,v){
                $("ul.referencelist").append('<li><a href="'+v.meta+'">'+v.meta+'</a></li>');
            });
        }
    });
    evt.preventDefault();
}
function toggle_tabs(evt)
{
    $(this).parent().parent().find('.active').removeClass('active');
    $(this).parent().addClass('active');
    $(this).parents('div').find('ul.active').removeClass("active").addClass("hide");
    $("ul."+$(this).attr('class')).addClass('active').removeClass('hide');
    evt.preventDefault();
}