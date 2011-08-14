$(function()
{
    if ($("#flash").text().replace(/ /g,"").replace(/\n/g,"").length > 0)
    {
        $("#flash").show();
        hideFlash();
    }
})
var flashHandle;
function hideFlash()
{
    flashHandle = null;
    flashHandle = setTimeout(function(){
        $("#flash").fadeOut();
    },2000);    
}
function showFlash(msg, type)
{
    $("#flash *").text('');
    $("#flash ."+type).text(msg);
    $("#flash").show();
    hideFlash();
}

function parse_url_params()
{
    var params = window.location.hash.slice(window.location.hash.indexOf('?') + 1).split('&')
    var get_parameters = {};
    $.each(params,function(k,i)
    {
        var p_split = i.split('=');
        get_parameters[p_split[0]] = p_split[1];
    });    
    return get_parameters;
}
