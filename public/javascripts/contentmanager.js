function initContentmanager()
{
  $("#type").change(function()
  {
    $(".filetypes > li").hide();
    console.log($(this).find(':selected'));
    $(".filetypes ." + $($(this).find(':selected')).attr('panel')).show().addClass('active');
  });
  $("form").submit(function(evt){
    var data =
      {
        'type' : $("#content_type").val(),
        'title': $(".filetypes .active input#content_title").val()
      };

    $.ajax({
    url: "<%= contents_path %>/<%= @content.id %>",
    type: 'POST',
    data: {content: data,
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