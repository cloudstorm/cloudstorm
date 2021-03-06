"use strict"

app = angular.module('cloudStorm.number', [])

# ===== DIRECTIVE =============================================================

app.directive "csNumber", ['$rootScope', 'csInputBase', ($rootScope, csInputBase) ->


  # ===== COMPILE =============================================================

  compile = ($templateElement, $templateAttributes) ->

    # Only modify the DOM in compile, use (pre/post) link for others
    $templateElement.addClass "cs-number"

    # Pre-link: gets called for parent first
    pre: (scope, element, attrs, controller) ->
      return

    # Post-link: gets called for children recursively after post() traversed the DOM tree
    post: link


  # ===== LINK ================================================================

  link = ($scope, element, attrs, controller) ->
    csInputBase $scope

    if $scope.formMode == 'create'
      if $scope.field.default?
        $scope.formItem.attributes[$scope.field.attribute] = $scope.field.default

    # ===== WATCHES =======================================

    $scope.$watch 'formItem.attributes[field.attribute]', (newValue, oldValue) ->
      if (newValue != oldValue)
        $scope.$emit 'input-value-changed', $scope.field

    return

  # ===== CONFIGURE ===========================================================

  return {
    restrict: 'E'
    templateUrl: 'components/cs-fields/cs-number/cs-number-template.html'
    scope:
      field: '=' # The resource item which the form is working with
      formItem: '='
      formMode: '='
      options: '='
    compile: compile
  }

]
