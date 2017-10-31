"use strict"

app = angular.module("cloudStorm.descriptorPropagationSettings", [])

###############################################################################

app.provider 'csDescriptorPropagationSettings', [() ->

  @components = {

    'csForm' : {
      type : "switch",
      base : ["formMode"],
      target : ["childDescriptors", "csField", "layout"],
      rule : {
        create : "horizontal",
        edit : "horizontal",
        view : "vertical",
      }
    }
  }

  @$get = ->
    @

  return

]