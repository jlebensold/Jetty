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