var basepath;
// models
window.CourseItem = Backbone.Model.extend({
    defaults: function() {
      return {
        selected: false,
        contentboxhtml: '',
        references: [],
        subcontents: []
      };
    },
    initialize: function() {},
    unselect: function(){this.set({selected:false});},
    select : function(){ this.set({selected:true});}
});
// collections
window.CourseItemList = Backbone.Collection.extend({
   model: CourseItem,
   value: null,
   basepath : '',
   url: function(){ return this.basepath +"courselist/"+this.courseid },
   contentboxurl: function(){ return this.basepath +"contentbox/"+this.courseid },
   initialize: function() {},
   rendered: function() {    
      if (this.selected().length == 0)
          this.models[0].select();
   },
   select: function(model){
       if (this.selected().length != 0) this.selected()[0].unselect();
       model.select();
   },
   selected: function(){
       return _.select(this.models, function(i){return i.get('selected') == true});
   }
});
//******************************************************
// views
//******************************************************
window.ContentView = Backbone.View.extend({
   template: _.template($('#contentview-template').html()),
   initialize: function() {
      this.model.bind('change', this.render, this);
   },
   render: function() {
      var self = this;
      $("#contentview").html(self.template(self.model.toJSON()));
      $(".player *").css({"width": "675px","height":"380px"});
      if (this.model.get('contentboxhtml').length > 0) return this;
      this.model.fetch({url: "/p/contentbox/"+this.model.get('id'),success: function(){} });
      return this;
   }
});
window.CourseItemView = Backbone.View.extend({
   tagName: 'li',
   template: _.template($('#courseitem-template').html()),
   events: {
       "click a.play": "select"
   },
   initialize: function() {
      _.bindAll(this,"render","rendercontent");
      this.model.bind('change', this.render, this);
      this.model.bind('change:selected',this.rendercontent,this)
   },
   select: function()
   {
       this.model.collection.select(this.model);
   },
   rendercontent: function() {
    var view = new ContentView({model : this.model});
    this.$("#courselist").append(view.render().el);
    this.setGradients();
    

   },
   setGradients: function()
   {
    if (this.model.get("selected"))
    {
        $(this.el).parent().find('.soft_gradient').addClass('hard_gradient');
        $(this.el).addClass('nowplaying medium_gradient');
    }
    else
    {
        $(this.el).parent().find('.soft_gradient').removeClass('hard_gradient');
        $(this.el).removeClass('nowplaying medium_gradient');
    }
   },
   render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
   }
});
window.CourseItemListView = Backbone.View.extend({
    initialize: function () {
        _.bindAll(this,"render","contentSelected"); 
        this.courseitems = new CourseItemList( null, { view: this });        
        this.courseitems.bind('reset',this.render, this);
        this.courseitems.basepath = this.options.basepath,
        this.courseitems.courseid = this.options.courseid;
        this.courseitems.fetch();
    },
    contentSelected: function(item) {
        this.courseitems.select(item);
    },
    render: function () {
        this.$("#courselist").empty();
        var self = this;
        this.courseitems.each( function(model) {
            var view = new CourseItemView({model : model});
            view.bind('changeSelected',self.contentSelected,self);
            this.$("#courselist").append(view.render().el);
        });
        this.courseitems.rendered();
        return this;
    }
});





function init(bp)
{
    /*
    basepath = bp;
    
    $(".buy").click(buy_click);
    $(".buybutton").click(function(e)
    {
        e.preventDefault();
        $("#buy").submit();
    });
    $(".close").click(function(ev)
    {
        $(this).parents('.popup').hide();
        ev.preventDefault();
    });
    */
}
function buy_click(e)
{
    e.preventDefault();
    var cid = $(this).attr('rel');
    $("#buy input[name=ci]").val(cid);
    //console.log($(this).attr('rel'));
    $("#purchase_title").text($("#courselist li[data-cid="+cid+"] .title").text());
    if ($(this).hasClass('popup_login'))
    {
        var self = $(this);
        $(".popup").show();
        $(".done").click(function(e)
        {
            $(this).parents('.popup').hide();
            self.removeClass('popup_login');
            e.preventDefault();
        })
        e.preventDefault();
        return;
    }
    else
    {
        $(".popup").show();
    }
}