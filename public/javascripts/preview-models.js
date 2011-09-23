// models
window.Purchase = Backbone.Model.extend({
    defaults: function(){}
})
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
