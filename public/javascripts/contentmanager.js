var basepath;
function initContentmanager(bp)
{
  basepath = bp;
  loadListeners();
  VideoJS.setupAllWhenReady();
  list_subcontent()
}
function list_subcontent()
{
    $.ajax({
        url: basepath + "/subcontents",
        type: 'POST',
        data: {id : $("#content_id").val()},
        dataType : 'json',
        success : function(resp) {render_subcontents(resp.subcontents)}
    });
}
function loadListeners()
{
    createUploader($('#maincontent'));
    createUploader($('#subcontent'));
    $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});
    $("li a.delete").live('click',delete_subcontent);
    $("#bt_addurl").click(add_subcontent);
    $(".reprocess").click(reprocess_content);
    $(".subcontent .type").live('change',function(){
        $(this).parents("li").find(".upload").toggle();
        $(this).parent("li").find(".url").toggle();
    });
    $("#type").change(function() {
        $(".filetypes > li").hide();
        $(".filetypes ." + $($(this).find(':selected')).attr('panel')).show().addClass('active');
    });
    $("form").submit(save_form);
}
function reprocess_content(evt)
{
    $.ajax({
        url: basepath + "/postprocess",
        type: 'POST',
        data: {id : $("#content_id").val()},
        dataType : 'json',
        success : function(resp) {}
    });
    evt.preventDefault();
}
function add_subcontent(evt)
{
    $("#referenceslist").append(tpl_reference($("#tb_addurl").val(),""));
    save();
    evt.preventDefault();
}
function delete_subcontent(evt)
{
    $(this).parents('li').remove();
    save();
    evt.preventDefault();
}
function save_form(evt) {save();evt.preventDefault();}
function save()
{
    var data = {
            id : $("#content_id").val(),
            subcontent: getSubcontent(),
            content: {
                'type'   : $("#content_type").val(),
                'title'  : $("#content_title").val(),
                'publish': $("#content_publish").val(),
                'expire': $("#content_expire").val()
              },
            name : $('meta[name=csrf-param]').attr('content'),
            value : $('meta[name=csrf-token]').attr('content')
          };
    $.ajax({
        url: basepath + "/save",
        type: 'POST',
        data: data,
        dataType: 'json',
        success : function(resp)
        {
            render_references(resp.references);
            render_subcontents(resp.subcontents);
            
        }
    });
}
function render_subcontents(subcontents)
{
    $("#subcontentslist").empty();
    $.each(subcontents,function(i,v)
    {
        $("#subcontentslist").append(tpl_subcontent(v));
    });
}
function render_references(refs)
{
    $("#referenceslist").empty();
    $(refs).each(function(i)
    {
        $("#referenceslist").append(tpl_reference(this.meta,this.id));
    });
}
function getSubcontent()
{
    var subc = [];
    $("#referenceslist li").each(function()
    {
        subc.push({
             meta: $(this).find('span').text(),
             id: $(this).attr('cid'),
             type : "Url"
         });
    });
    $("#subcontentslist li").each(function(){
        subc.push({
             id: $(this).attr('cid'),
             type : $(this).attr('type')
         });
    });
    
    return subc;
}


function createUploader(emt)
{
    new qq.FileUploader({
        element: emt.get(0),
        action: basepath + "/upload",
        debug: false,
        template: tpl_uploader(emt.text()),
        params: uploadparams,
        onSubmit: function(id, filename)
        {
            if(this.element.id == 'subcontent')
            {
                this.params.content = {
                        id: '',
                        type: getType(filename)
                    }
                this.params.parent_id = $("#content_id").val();
            }
            else
            {
                $("#content_type").val(getType(filename));                
                this.params.content = {type: getType(filename) , title:$("#content_title").val()}
            }
            $(".total").css('width',"0%");  
        },
        onComplete: function(id, filename, responseJSON)
        {
          $(".filestatus").text(getType(filename) + " Upload successful. processing...");
          $(".total").css('width',"100%");
          render_subcontents(responseJSON.subcontents)
        },
        onProgress: function(id, filename, loaded, total)
        {
            $(".total").css('width',(parseFloat(loaded / total) * 100)+"%");
        }
    });
}
function getType(filename)
{
    var ext = $(filename.split('.')).last()[0].toLowerCase();
    switch(ext)
    {
        case "jpeg":
        case "jpg":
        case "gif":
        case "png":
            return "Image";
        case "mp4":
        case "wmv":
        case "mov":
        case "avi":
        case "m4v":
        case "xvid":
        case "ogv":
        case "ogg":
            return "Video";
        case "pdf":
            return "Pdf";
        default:
            return "BinaryFile";
    }
}
//templates:
function tpl_subcontent(c)
{
    return '<li cid="'+c.id+'" type="'+c.type+'">'+
          '<h4>'+c.type+', '+c.status+ ' <a href="#" class="delete">x</a></h4>'+
          '<p>'+c.contentboxhtml+'<a href="#">more...</a></p>'+
        '</li>';
}
function tpl_uploader(txt)
{
    return '<div class="qq-uploader">' +
                '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' +
                '<div class="qq-upload-button">'+txt+'</div>' +
                '<ul class="qq-upload-list"></ul>' +
             '</div>'
}
function tpl_reference(url,id)
{
    if (url.length == 0) return "";
    return '<li cid="'+id+'" ><span>'+url+'</span><a href="#" class="delete">x</a></li>';
}