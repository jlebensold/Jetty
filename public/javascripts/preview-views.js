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
window.PurchaseView = Backbone.View.extend({
   template: _.template($('#purchasebox-template').html()),
   el: "#purchasebox",
   events: {
       "click a": "close",
       "submit #frmlogin": "login",
       "submit #frmregister": "register"
   },
   initialize: function() {
      _.bindAll(this,"render","close","login","register","stepOneSuccess","ajax");
      this.model.bind('change', this.render, this);
   },
   close: function(e) {
        $(this.el).hide();
        e.preventDefault();
   },
   login: function(e) {
     $.ajax(this.ajax(loginurl,$(this.el).find("#frmlogin"),this.stepOneSuccess));
     e.preventDefault();
   },
   register: function(e) {
     $.ajax(this.ajax(regurl,$(this.el).find("#frmregister"),this.stepOneSuccess));
     e.preventDefault();
   },
   ajax: function(url, form,success)
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
        success   : success
      }
   },
   stepOneSuccess: function(e){
      var self = this;
      $(this.el).find(".step1").fadeOut('fast',function(){
        $(self.el).find(".step2").fadeIn('fast');
      });
   },
   render: function() {
       $(this.el).html(this.template(this.model.toJSON()));
       $("#purchasebox").show();
       return this;
   }
});
window.CourseItemView = Backbone.View.extend({
   tagName: 'li',
   template: _.template($('#courseitem-template').html()),
   events: {
       "click a": "select"
   },
   initialize: function() {
      _.bindAll(this,"render","modelchanged","rendercontent","renderpurchasebox");
      this.model.bind('change', this.render, this);
      this.model.bind('change:selected',this.modelchanged,this)
   },
   select: function(ev)
   {
       ev.preventDefault();
       if (this.model.get("available"))
           this.model.collection.select(this.model);
       else
           this.model.buy();
   },
   modelchanged: function() {
       // code smell?
       if (this.model.get("available"))
           this.rendercontent();
       else
           this.renderpurchasebox();
   },
   renderpurchasebox: function() {
     new PurchaseView({model : this.model}).render();
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


