$(function()
{
    if ($("#flash").text().replace(/ /g,"").replace(/\n/g,"").length > 0)
    {
        $("#flash").show()
        setTimeout(function(){
            $("#flash").fadeOut();
        },2000);
    }
})