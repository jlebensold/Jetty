// models
window.Purchase = Backbone.Model.extend({
    defaults: function(){
        return {
            purchaseable: null,
            user: null,
            purchaseType: '',
            toptext: 'fasds',
            path: ''
        };
    },
    initialize : function(){
    },
    baz : function()
    {
        
        console.log('baz');
        return 'aaaa';
    },
    refresh : function(){
        if (this.get('purchaseType') == 'item')
            this.set({toptext:"Purchase \u201c"+this.get('purchaseable').get('content').title+"\u201d" });        
        if (this.get('purchaseType') == 'course')
            this.set({toptext:"Purchase \u201c"+this.get('purchaseable').get('title')+"\u201d" });        
    }
    
});
window.User = Backbone.Model.extend({
    defaults: function(){
        return {
        email : "",
        signedIn: false,
        logouturl: "",
        success: function(){}
        };
    },
    initialize: function()
    {
        if(this.get('email').length > 0)
           this.set({"signedIn":true});
    },
    signIn: function(email)
    {
        this.set({"email":email});
        this.set({"signedIn":true});
    },
    logout: function()
    {
        this.set({"email":''});
        this.set({"signedIn":false});
        $.ajax({
        url: this.get('logouturl'),
        type      : 'GET',
        success   : this.get('success')
      });
    }
});

window.Login = Backbone.Model.extend({
    defaults:function(){return {};},
    initialize: function(){},
    request: function()
    {
        this.ajax();  
    },
    ajax: function(url, form,success)
    {
      return $.ajax({
        url: this.get('url'),
        data: {
              remote : true,
              utf8 : "✓",
              user: this.serializeObject($(this.get('form')))
        },
        type      : 'POST',
        dataType  : 'json',
        success   : this.get('success'),
        error     : this.get('success')
      });
    },
  serializeObject : function(obj)
  {
    var o = {};
    var a = obj.serializeArray();
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
  }
});
window.Course = Backbone.Model.extend({
    url: function(){ 
        return this.get('basepath') +"course/"+this.id 
    },
    defaults: function(){
        return {
            basepath: '',
            id: -1,
            amount: 0,
            courseitems: {},
            title: '',
            description: '',
            purchased: false
        }
    },
    initialize: function(){}
});
window.CourseItem = Backbone.Model.extend({
    defaults: function() {
      return {
        purchase: null,
        selected: false,
        contentboxhtml: '',
        references: [],
        subcontents: []
      };
    },
    initialize: function() {},
    unselect: function(){this.set({selected:false});},
    select : function(){ this.set({selected:true});},
    buy : function(){this.set({purchase:new Purchase,selected: true})}
});
// collections
window.CourseItemList = Backbone.Collection.extend({
   model: CourseItem,
   value: null,
   purchase: null,
   basepath : '',
   url: function(){ return this.basepath +"courselist/"+this.courseid },
   initialize: function() {},
   clearSelected: function() {
       if (this.selected().length != 0) this.selected()[0].unselect();
   },
   rendered: function() {    
      if (this.selected().length == 0 && this.models.length > 0)
          this.models[0].select();
   },
   select: function(model){
       this.clearSelected();
       model.select();
   },
   selected: function(){
       return _.select(this.models, function(i){return i.get('selected') == true});
   }
});
window.PurchaseList = Backbone.Collection.extend({
   model: Purchase,
   initialize: function() {},
   url: function() { return this.basepath + '/../../purchases';}
});