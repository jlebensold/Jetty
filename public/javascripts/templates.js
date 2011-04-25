function sanitize(p)
{
    $.each(p,function(k,v){
        if (p[k] == null) p[k] = '';
    });
    return p;
}
function tpl_icon(p)
{
    var iconpath = basepath+"/../images/icons/";
    switch(p.type)
    {
        case "Video":
            if (p.status == "complete")
                return '<img src="'+iconpath+'film.png" />';
            return '<img alt="conversion in progress" src="'+iconpath+'film_error.png" />';
            break;
        case "Pdf":
            return '<img src="'+iconpath+'page_white_acrobat.png" />';
            break;
        case "Image":
            return '<img src="'+iconpath+'image.png" />';
            break;
        default:
            return '<img src="'+iconpath+'page.png" />';
            break;
    }
}
function tpl_course_item(p)
{
    if (p == null) return '';
    p = sanitize(p);
    var disabled = (p.monetize) ? '' : ' disabled="disabled" ';
    var o =
        '<div class="course_item hide">'+
            '<a href="/contents/'+p.content_id+'/edit">edit '+p.content.title+'</a>'+
            '<input class="id" type="hidden" value="'+p.id+'" />'+
            '<input class="course_id" type="hidden" value="'+p.course_id+'" />'+
            '<input class="content_id" type="hidden" value="'+p.content_id+'" />'+
            tpl_checkbox('monetize',p.monetize,'monetize') +
            '<label>Amount</label>'+
            '<input class="amount monetizetoggle" '+disabled+' type="text" value="'+p.amount+'" />'+
            '<label>Return URL</label>'+
            '<input class="monetize_return_url monetizetoggle" '+disabled+' type="text" value="'+p.monetize_return_url+'" />'+
            '<button class="save">Save</button>'+
            '<a class="delete" href="#">delete</a><div class="clear" />'+
        '</div>'

    return tpl_content(p.content,o);
}
function tpl_checkbox(klass,val,txt)
{
    chk = (val) ? ' checked="checked" ' : '';
    return '<label><input class="'+klass+'" type="checkbox" '+chk+' />'+txt+'</label>';
}
function tpl_content(p,suffix)
{
    if (suffix == undefined) suffix = '';
    p = sanitize(p);
    return '<li>'+tpl_icon(p)+'<a content_id="'+p.id+'" href="">'+p.title+'</a>'+suffix+'</li>'
}

function tpl_course(p)
{
    p = sanitize(p);
 return '<dt class="closed">'+
          '<a>+</a>'+
          '<a class="title">'+p.title+'</a>'+
        '</dt>'+
        '<dd class="hide">'+
          '<label>Description</label>'+
          '<input type="hidden" class="id" value="'+p.id+'" />'+
          '<textarea class="description" cols="20" rows="4">'+p.description+'</textarea>'+
          '<a class="delete" href="#">delete</a>'+
          '<button class="save">Save</button>'+
          '<button class="cancel">Cancel</button>'+
          '<div class="clear" />'+
        '</dd>';
}