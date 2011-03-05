var basepath;
function initContentmanager(bp)
{
    basepath = bp;
    createUploader($('#maincontent'));
    createUploader($('#subcontents'));
    $("#referenceslist li a.delete").live('click',function(evt)
    {
        $(this).parents('li').remove();
        save();
        evt.preventDefault();
    });
    $("#bt_addurl").click(function(evt)
    {
        $("#referenceslist").append(getReferencesTemplate($("#tb_addurl").val(),""));
        save();
        evt.preventDefault();
    });
    $(".reprocess").click(function(evt)
    {
        $.ajax({
            url: basepath + "/postprocess",
            type: 'POST',
            data: {id : $("#content_id").val()},
            dataType : 'json',
            success : function(resp) {}
        });
        evt.preventDefault();
    });
  
  $(".addsubcontent").click(function(evt){
    $("#addsubcontent li" ).clone().appendTo(".subcontents");
    evt.preventDefault();
  });
  $(".subcontent .type").live('change',function()
  {
        $(this).parents("li").find(".upload").toggle();
        $(this).parent("li").find(".url").toggle();
  });
  $("#type").change(function()
  {
    $(".filetypes > li").hide();
    $(".filetypes ." + $($(this).find(':selected')).attr('panel')).show().addClass('active');
  });
  $("form").submit(function(evt){
    save();
    evt.preventDefault();
  });
}
function save()
{
    var data = {
            id : $("#content_id").val(),
            subcontent: getSubcontent(),
            content: {
                'type' : $("#content_type").val(),
                'title': $("#content_title").val()
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
            renderReferences(resp.references);
        }
    });
}
function renderReferences(refs)
{
    $("#referenceslist").empty();
    $(refs).each(function(i)
    {
        $("#referenceslist").append(getReferencesTemplate(this.meta,this.id));
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
    return subc;
}


function createUploader(emt)
{
    var uploader = new qq.FileUploader({
        element: emt.get(0),
        action: basepath + "/upload",
        debug: false,
        template: getUploaderTemplate(emt.text()),
        params: uploadparams,
        onSubmit: function(id, filename)
        {
            if(this.element.id == 'subcontents')
            {
                console.log('subcontent');
                this.params.content = {
                        id: '',
                        type: getType(filename)
                    }
                this.params.parent_id = $("#content_id").val();
            }
            else
            {
                $("#content_type").val(getType(filename));                
                this.params.content = {type: getType(filename) , title:$("#content_title").val() }
            }
            $(".total").css('width',"0%");  
        },
        onComplete: function(id, filename, responseJSON)
        {
          $(".filestatus").text(getType(filename) + " Upload successful. processing...");
          $(".total").css('width',"100%");
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
            return "PDF";
        default:
            return "BinaryFile";
    }
}
function getUploaderTemplate(txt)
{
    return '<div class="qq-uploader">' +
                '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' +
                '<div class="qq-upload-button">'+txt+'</div>' +
                '<ul class="qq-upload-list"></ul>' +
             '</div>'
}
function getReferencesTemplate(url,id)
{
    if (url.length == 0) return "";
    return '<li cid="'+id+'" ><span>'+url+'</span><a href="#" class="delete">x</a></li>';
}