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
      this.model.fetch({url: "/p/contentbox/"+this.model.get('id'),success: function(){}});
      return this;
   }
});
window.PurchaseView = Backbone.View.extend({
   template: _.template($('#purchasebox-template').html()),
   el: "#purchasebox",
   events: {
       "click a": "close",
       "click .buybutton":"buy"
   },
   initialize: function() {
      _.bindAll(this,"render","close","buy");
      this.model.bind('change', this.render, this);
   },
   buy : function(e){
       e.preventDefault();
       $(this.el).find("form").submit();
   },
   close: function(e) {
        $(this.el).hide();
        e.preventDefault();
   },
   render: function() {
       this.model.refresh();
       var obj = this.model.toJSON();
       console.log(obj);
       $(this.el).html(this.template(obj));
       $("#purchasebox").show();
       return this;
   }
});
window.LoginBoxView = Backbone.View.extend({
   template: _.template($("#loginbox-template").html()),
   el: "#loginbox",
   events: {
       "click a": "close",
       "submit .frmlogin":"login",
       "submit .frmregister":"register"
   },
   initialize: function(){
        _.bindAll(this,"close","render","login","register","onSuccess");
   },
   close: function(e) {
        $(this.el).hide();
        e.preventDefault();
   },
   errorLoginOrRegister: function()
   {
     alert('failed');  
   },
   onSuccess: function(resp) {
      if(resp.status && resp.status == "401")
          return this.errorLoginOrRegister();      
      $(this.el).fadeOut();
      for(var k in resp) {
          if(resp[k].email) this.model.signIn(resp[k].email);
      }
      
      if (this.options.success != undefined)
          this.options.success();
      return null;
   },
   login: function(e) {
     new Login({url:window.app.options.loginurl, 
               form:$(this.el).find(".frmlogin"), 
               success: this.onSuccess}).request();
     e.preventDefault();
   },
   register: function(e) {
     new Login({url:window.app.options.regurl, 
               form:$(this.el).find(".frmregister"), 
               success: this.onSuccess}).request();
     e.preventDefault();
   },
   render: function(){
       $(this.el).show();
       var text = this.options.toptext;
       if (!this.options.toptext)
           text = "Sign Up or Log In!";   
       $(this.el).html(this.template({toptext: text}));     
   }
});
window.LoginStatusView = Backbone.View.extend({
   template: _.template($("#loginstatus-template").html()),
   el: "#loginstatus",
   events: 
   {
    "click .login" : "loginclicked",
    "click .logout" : "logoutclicked"
   //TODO: click and view list of my purchases
   },
   initialize: function() {
       _.bindAll(this,"render","loginclicked","logoutclicked");
       this.model.bind('change',this.render,this)
   },
   loginclicked: function(e){
       e.preventDefault();
       new LoginBoxView({model: this.model}).render();
   },
   logoutclicked: function(e){
       this.model.logout(window.app.options.logouturl);
       e.preventDefault();
   },
   render: function(){
       $(this.el).html(this.template(this.model.toJSON()));   
   }
});
window.CourseItemView = Backbone.View.extend({
   tagName: 'li',
   template: _.template($('#courseitem-template').html()),
   events: {
       "click a": "select"
   },
   initialize: function() {
      _.bindAll(this,"render","modelchanged","rendercontent","renderpurchasebox","loginSuccessful");
      this.model.bind('change', this.render, this);
      this.model.bind('change:selected',this.modelchanged,this)
   },
   select: function(ev)
   {
       ev.preventDefault();
       if (this.model.get("available"))
           this.model.collection.select(this.model);
       else
       {
           if (window.app.options.user.get('signedIn'))
           {
               this.renderpurchasebox();    
           }
           else
           {
               new LoginBoxView({model: window.app.options.user,
                                 success:this.loginSuccessful,
                                 toptext:"Purchase “"+this.model.get('content').title+"”"}).render();
           }
       }
   },
   modelchanged: function() {
       // code smell?
       if (this.model.get("available"))
           this.rendercontent();

   },
   loginSuccessful: function() {
     this.renderpurchasebox();  
   },
   renderpurchasebox: function() {     
     var purchase = new Purchase({
         purchaseable: this.model, 
         user: window.app.options.user, 
         purchaseType:'item',
         path: window.app.options.purchasepath
     });
     purchase.refresh();
     new PurchaseView({model:purchase}).render();
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
        _.bindAll(this,"render","contentSelected","initCourseItems"); 
        this.options.user.bind('change',this.initCourseItems, this);
        this.initCourseItems();
    },
    initCourseItems: function(){
        $("#courselist").empty();
        this.courseitems = new CourseItemList( null, {view: this});        
        this.courseitems.bind('reset',this.render, this);
        this.courseitems.basepath = this.options.basepath,
        this.courseitems.courseid = this.options.courseid;
        this.courseitems.fetch();        
    },
    contentSelected: function(item) {
        this.courseitems.select(item);
    },
    render: function () {
        $("#courselist").empty();
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
window.AppView = Backbone.View.extend({
   initialize: function() {
       this.courseitemView = new CourseItemListView({
                                                     basepath:this.options.basepath,
                                                     courseid:this.options.courseid,
                                                     user: this.options.user
                                                    });
       this.loginstatusView = new LoginStatusView({model: this.options.user}).render();
   }
   
});


