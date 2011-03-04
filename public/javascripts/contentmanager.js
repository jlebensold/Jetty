function initContentmanager(basepath)
{
  $(".reprocess").click(function(evt)
    {
        $.ajax({
            url: basepath + "/postprocess",
            type: 'POST',
            data: { id : $("#content_id").val() },
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
    var data =
      {
        'type' : $("#content_type").val(),
        'title': $("#content_title").val()
      };
    $.ajax({
        url: basepath + "/save",
        type: 'POST',
        data: {
            id : $("#content_id").val(),
            subcontent: getSubcontent(),
            content: data,
            name : $('meta[name=csrf-param]').attr('content'),
            value : $('meta[name=csrf-token]').attr('content')
          },
        dataType: 'json',
        success : function(resp)
        {

        }
    });
    evt.preventDefault();
  });
}
function getSubcontent()
{
    var subc = [];
    $(".subcontents li").each(function()
    {
        subc.push({title: $(this).find('input[name=title]').val() , value : $(this).find('input[name=url]').val()});
    });
    return subc;
}