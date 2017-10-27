var app = angular.module("cloudStorm.csItemList", [])

app.component("csItemList", {

  bindings : {
    itemList : "<",
    key : "<",
    uiConfig : "<",
  },
  templateUrl : "components/cs-item-list/cs-item-list-template.html",
  controller : function(csRoute){

    this.click = function(id){
      csRoute.go("show", {id : id})
    }
  }
})
