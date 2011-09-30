//******************************************************
// views
//******************************************************

// Main Content
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

// Purchasing
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
//       this.model.refresh();
       var obj = this.model.toJSON();
       $(this.el).html(this.template(obj));
       $("#purchasebox").show();
       $(this.el).css("left",($(window).width() - $(this.el).width()) / 2);
       return this;
   }
});
// Login stuff:
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
   errorLoginOrRegister: function(resp)
   {
        $(this.el).find(".errors:hidden").fadeIn();
        var ul = $(this.el).find('.errors ul');
        ul.empty();
        _.each(resp.errors,function(f,e){
            ul.append('<li>' + e + ' ' + f + '</li>');
        });
        //new ErrorBoxView({model: resp}).render();
   },
   onSuccess: function(resp) {
      if(resp.status && resp.status == "401")
          return this.errorLoginOrRegister({errors: {" ": $.parseJSON(resp.responseText).error }});
      if(resp.status == 'FAIL' && resp.errors.length > 0)
          return this.errorLoginOrRegister(resp);
      
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
       $(this.el).css("left",($(window).width() - $(this.el).width()) / 2);
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
    "click .logout" : "logoutclicked",
    "click .purchases": "mypurchases"
   },
   initialize: function() {
       _.bindAll(this,"render","loginclicked","logoutclicked","mypurchases");
       this.model.bind('change',this.render,this)
   },
   mypurchases: function(e){
       e.preventDefault();
       new MyPurchasesBoxView();
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
window.MyPurchasesBoxView = Backbone.View.extend({
   template: _.template($("#purchases-template").html()),
   el: "#purchasesbox",
   events: {
       "click a": "close"
   },
   initialize: function()
   {
       _.bindAll(this,"render","close");
       this.collection = new PurchaseList();
       this.collection.basepath = window.app.options.basepath;
       this.collection.fetch();
       this.collection.bind('reset',this.render)
   },
   close: function(e) {
        $(this.el).hide();
        e.preventDefault();
   },
   render: function()
   {       
       $(this.el).show();
       $(this.el).css("left",($(window).width() - $(this.el).width()) / 2);
       console.log(this.collection.toJSON());
       var set = this.collection.toJSON();
       $(this.el).html(this.template({courses: set[0], contents: set[1] }));     
       return this;
   }
  
});
window.ErrorBoxView = Backbone.View.extend({
   template: _.template($("#errorbox-template").html()),
   el: "#errorbox",
   events: {
       "click a": "close"
   },
   initialize: function()
   {
       _.bindAll(this,"render");
   },
   close: function(e) {
        $(this.el).hide();
        e.preventDefault();
   },
   render: function()
   {       
       $(this.el).show();
       $(this.el).css("left",($(window).width() - $(this.el).width()) / 2);
       $(this.el).html(this.template(this.model));     
   }
   
})
// Right-hand panel
window.CourseDescriptionView = Backbone.View.extend({
   el: "#coursedesc",
   template: _.template($("#coursedesc-template").html()),
   events: { "click button":"buycourse"},
   initialize: function() {
     _.bindAll(this,"render","buycourse","loginSuccessful","renderpurchasebox");
     this.model.bind('change',this.render,this);
   },
   buycourse: function(){
       console.log(window.app.options.user.get('signedIn'));
       if (window.app.options.user.get('signedIn'))
           this.renderpurchasebox();    
       else
           new LoginBoxView({model: window.app.options.user,
                             success:this.loginSuccessful,
                             toptext:"Purchase \u201c"+this.model.get('title')+"\u201d"}).render();

   },
   loginSuccessful: function() {
     this.renderpurchasebox();  
   },
   renderpurchasebox: function() {
     var purchase = new Purchase({
         purchaseable: this.model, 
         user: window.app.options.user, 
         purchaseType:'course',
         path: window.app.options.purchasepath
     });
     console.log(purchase.get('purchaseable'));
//     purchase.refresh();
     new PurchaseView({model:purchase}).render();
   },
   render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
   }
});

window.CourseItemView = Backbone.View.extend({
   tagName: 'li',
   template: _.template($('#courseitem-template').html()),
   events: { "click a": "select" },
   initialize: function() {
      _.bindAll(this,"render","modelchanged","rendercontent","renderpurchasebox","loginSuccessful");
      this.model.bind('change', this.render, this);
      this.model.bind('change:selected',this.modelchanged,this)
   },
   select: function(ev)
   {
       ev.preventDefault();
       if (this.model.get("available"))
       {
           this.model.collection.select(this.model);
       }
       else
       {
           if (window.app.options.user.get('signedIn'))
               this.renderpurchasebox();    
           else
               new LoginBoxView({model: window.app.options.user,
                                 success:this.loginSuccessful,
                                 toptext:"Purchase \u201c"+this.model.get('content').title+"\u201d"}).render();
       }
   },
   modelchanged: function() {
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
     purchase.set({toptext: 'asd'});
     //console.log(purchase.get('purchaseable'));
     //purchase.refresh();
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
        // TODO: create a change method and call these on page load
        this.courseitems.fetch();
        this.options.course.set({basepath: this.options.basepath});
        this.options.course.fetch();
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
        window.app.options.course.set({courseitems :this.courseitems});
        this.trigger('courselistrendered');
        return this;
    }
});


// Init
window.AppView = Backbone.View.extend({
   initialize: function() {
       this.courseitemView  = new CourseItemListView({
                                                     basepath:this.options.basepath,
                                                     courseid:this.options.courseid,
                                                     course: this.options.course,
                                                     user: this.options.user
                                                    });
       this.loginstatusView = new LoginStatusView({model: this.options.user}).render();
       this.courseView = new CourseDescriptionView({model: this.options.course });
       this.courseitemView.bind('courselistrendered',this.courseView.render);
   }
   
});


