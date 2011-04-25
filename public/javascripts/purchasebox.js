$(function()
{
  $(".step1").tabs();
  $("#frmlogin").submit(function(evt)
  {
    $.ajax(ajax_params(loginurl,this));
    evt.preventDefault();
  });
  $("#frmregister").submit(function(evt)
  {
    $.ajax(ajax_params(regurl,this));
    evt.preventDefault();
  });
  //$(".cancel").click(function(evt){$(this).parents('.popup').hide();evt.preventDefault();});

  $.fn.serializeObject = function()
  {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
  };

});
function ajax_params(url, form)
{
  return {
    url: url,
    data: {
          remote : true,
          utf8 : "✓",
          user: $(form).serializeObject()
    },
    type      : 'POST',
    dataType  : 'json',
    success   : function(resp)
    {
      $(".step1").fadeOut('fast',function()
      {
        $(".step2").fadeIn('fast');
        $(".buybutton").removeClass('hide');
      });
    }
  }
}
