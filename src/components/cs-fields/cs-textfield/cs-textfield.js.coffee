"use strict"

app = angular.module('cloudStorm.textfield', ['ui.select'])

# ===== DIRECTIVE =============================================================

app.directive "csTextfield", ['$rootScope', 'csTemplateService', 'csInputBase', ($rootScope, csTemplateService, csInputBase) ->

  # ===== COMPILE =============================================================

  compile = ($templateElement, $templateAttributes) ->

    # Only modify the DOM in compile, use (pre/post) link for others
    $templateElement.addClass "cs-textfield"

    # Pre-link: gets called for parent first
    pre: (scope, element, attrs, controller) ->
      return

    # Post-link: gets called for children recursively after post() traversed the DOM tree
    post: link

  # ===== LINK ================================================================

  link = ($scope, element, attrs, controller) ->
    csInputBase $scope
    $scope.csTemplateService = csTemplateService
    $scope.defaultTemplate = 'components/cs-fields/cs-textfield/cs-textfield-template.html'

    # ===== WATCHES =======================================

    $scope.$watch 'formItem.attributes[field.attribute]', (newValue, oldValue) ->
      if (newValue != oldValue)
        $scope.$emit 'input-value-changed', $scope.field

    # ===== UI HANDLES ====================================

    $scope.keyPressed = ($event) ->
      if $event.keyCode == 13
        $scope.$emit 'submit-form-on-enter', $scope.field

    return

  # ===== CONFIGURE ===========================================================

  return {
    restrict: 'E'
    template: '<ng-include src="csTemplateService.getTemplateUrl(field,options,defaultTemplate)"/>',
    scope:
      field: '=' # The resource item which the form is working with
      formItem: '='
      formMode: '='
      options: '='
    compile: compile
  }

]
