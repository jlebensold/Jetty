var basepath;
var allcontents = [];
function initCoursemanager(bp)
{
    basepath = bp;
    loadListeners();
    list_courses(function()
    {
        var params = parse_url_params();
        if (params.id != undefined)
            $("#courses input.id[value='"+params.id+"']").first().parent().prev().find('a').click();
    });
    $.when(list_contents({})).then(function(resp){
        allcontents = resp.contents    
    });

    

}
function loadListeners()
{
    $("#newcourse,#newcontent").click(function(evt){ $("."+$(this).get(0).id).toggle(); evt.preventDefault(); });
    $("#preview").click(function(evt) {
        var id = $("#courses .active").next().find(".id").val();
        location.href = "/p/"+id;
    });
    $(".top .cancel").click(function(evt){ $(this).parent().toggle();evt.preventDefault(); });

// courses
    $("#newcourse_create").click(create_course);
    $(".body dl dd .cancel").live('click',function(){hide_course_details($(this).parent().prev());});
    $(".body dl dt a").live('click',function(){show_course_details(this);});
    $(".body dl dd .save").live('click',save_course_changes);
    $(".body dl dd .delete").live('click',delete_course);
// contents
    $("#contents .newcontent ul li a").live('click',add_content_item);
    $("#contents .body ul li a").live('click',show_content_details);
    $("#contents .body ul").sortable({revert: true,stop : save_order});

// content_details
    $("#content_details .delete").live('click',delete_course_item)
    $("#content_details .save").live('click',save_course_item)
    $("#content_details .monetize").live('click',toggle_monetize);
}
function toggle_monetize(evt)
{
    if ($(this).attr('checked'))
        $(this).parent().parent().find('.monetizetoggle').removeAttr('disabled');
    else
        $(this).parent().parent().find('.monetizetoggle').val('').attr('disabled','disabled');
}
function save_course_item(evt)
{
    doAjax('/saveitem', {
        courseitem : {
          id : $(this).parent().find('.id').val(),
          monetize : $(this).parent().find('.monetize').attr('checked'),
          amount : $(this).parent().find('.amount').val(),
          monetize_return_url :$(this).parent().find('.monetize_return_url').val()
          }
    },function(resp)
    {
        var target = $("#contents .body ul li a[content_id="+resp.courseitem.content_id+"]");
        target.parent().replaceWith(tpl_course_item(resp.courseitem)).addClass('active');
        $("#contents .body ul li a[content_id="+resp.courseitem.content_id+"]").parent().addClass('active');
    });
}
function delete_course_item(evt)
{
    var id = $(this).parent().find('.id').val();
    var content_id = $(this).parent().find('.content_id').val();
    $("#content_details .body").empty();
    $('#contents .body ul li a[content_id='+content_id+']').parent().remove();
    doAjax('/deleteitem', {courseitem : {id : id} });
    evt.preventDefault();
}
function delete_course(evt)
{
    var self = this;
    $("#content_details .body,#contents .body ul").empty();
    $(".course_title").text("");
    doAjax('/delete', {
        course : {id : $(this).parent().find('.id').val()}
    },function(resp) {
        $(self).parent().prev().remove();
        $(self).parent().remove();
    });
    evt.preventDefault();
}
function save_course_changes(evt)
{
    doAjax('/save', {
        course : {
          id : $(this).parent().find('.id').val(),
          description : $(this).parent().find('.description').val(),
          title : $(this).parent().prev().find('.title').val()
          }
    });
}
function create_course(evt)
{
    $("#content_details .body,#contents .body ul").empty();
    save_course($(this).parent());
    $(this).parent().toggle();
    evt.preventDefault();
}
function save_order(evt)
{
   var orders = [];
   i = 0;
   $("#contents .body ul li").each(function(){
    orders.push({id : $(this).find('.course_item .id').val(),
                 order : i++})
   });
   doAjax('/saveorder', {ordering: orders},function(resp)
   {
            set_course_item_orders();
            render_post_content_details();
   });
   
   
}
function add_content_item(evt)
{
   $(this).parent().remove();
   doAjax('/addcontent', {
            course : {
              id : $("#courses dl dt.active").next().find('.id').val()
              },
            content : {
              id : $(this).attr('content_id')
            },
            order : $("#contents .body ul li").length
        },function(resp) 
        {   
            $("#contents .body ul").append(tpl_course_item(resp.course_item));
        });
    evt.preventDefault();
}
function hide_course_details(emt)
{
    $(emt).removeClass('active').addClass('closed');
    var title = $(emt).find('.title').attr('old_val');
    $(emt).next().toggle();
    $(emt).find('.title').replaceWith('<a class="title" >'+title+'</a>');
}
function list_addable_content(resp_contents)
{
    $(".newcontent ul").empty();
    $.each(allcontents,function(i , v)
    {
        var exists = false;
        $.each(resp_contents,function(j,w){
            if (v.id == w.id) exists = true;
        });
        if (!exists)
            $(".newcontent ul").append(tpl_content(v));
    });
}
function load_top_bar(emt)
{
    var cid = $(emt).parent().next().find('.id').val();
    $("#contents .top button").show();
    $("#contents .newcontent").hide();
    $.when(list_contents({course : {"id" : cid}})).then(function(resp)
    {
        list_addable_content(resp.contents);
        $("#contents .body ul").empty();
        $.each(resp.course_items, function(i,v)
        {
            $("#contents .body ul").append(tpl_course_item(v));
            
        });
        set_course_item_orders();

    });
}
function set_course_item_orders()
{
    $("#contents .body ul > li a[content_id]").each(function(k,i)
    {
        $(this).attr('data-ordering',k);
    });
}
function show_content_details(evt)
{
    $(this).parent().parent().find('.active').removeClass('active');
    $(this).parent().addClass('active');
    $("#content_details .body .note").remove();
    
    $("#content_details .body").html($(this).parent().find('.course_item').html());
    render_post_content_details();


    evt.preventDefault();
}
function render_post_content_details()
{
    $("#content_details .body input,#content_details .body button").removeAttr('disabled');
    if ($("a[content_id="+$("#content_details .body input.content_id").val()+"]").attr('data-ordering') == "0")
    {
        $("#content_details .body").prepend('<p class="note">Your first piece of content is always free. This will entice buyers.</p>')
        $("#content_details .body input,#content_details .body button").attr('disabled','disabled');
    }
}
function show_course_details(emt)
{
    $("#content_details .body").empty();
    $("#courses .body dl dt.active").each(function(){hide_course_details(this);});
    
    
    load_top_bar(emt);
    
    $(emt).parent().removeClass('closed').addClass('active');
    var title = $(emt).parent().find('.title').text();
    $(".course_title").text(title);
    $(emt).parent().next().toggle();
    $(emt).parent().find('.title').replaceWith('<input class="title" old_val="'+title+'" type="text" value="'+title+'"></input>');
}
function list_contents(p)
{
    return doAjax('/../contents/list', p);
}
function list_courses(callback)
{
    doAjax('/list', {},function(resp) {
        $.each(resp.courses,function(i,v){
            $("#courses .body dl").append(tpl_course(v));
        });
        
        if (callback != undefined)
            callback();
    });
}
function doAjax(method,req_data,callback)
{
    var data =  {
            name : $('meta[name=csrf-param]').attr('content'),
            value : $('meta[name=csrf-token]').attr('content')
        }

    $.each(req_data, function(i , n) {data[i] = n;});
    return $.ajax({
        url: basepath + method,
        type: 'POST',
        dataType : 'json',
        data: data,
        success : callback
    });
}
function save_course(emt)
{
    doAjax('/save', {
            course : {
              id : $(emt).find('.id').val(),
              description : $(emt).find('.description').val(),
              title : $(emt).find('.title').val()
              }
        },function(resp) {$("#courses .body dl").append(tpl_course(resp.course));});
}
