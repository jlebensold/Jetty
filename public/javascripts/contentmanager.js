function initContentmanager(basepath)
{
  $(".reprocess").click(function()
    {
    $.ajax({
        url: basepath + "/postprocess",
        type: 'POST',
        data: {
            id : $("#content_id").val()
        },
        dataType : 'json',
        success : function(resp) {}});
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