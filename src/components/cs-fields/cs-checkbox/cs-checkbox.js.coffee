"use strict"

app = angular.module('cloudStorm.checkbox', [])

# ===== DIRECTIVE =============================================================

app.directive "csCheckbox", ['$rootScope', 'csInputBase', 'csSettings', ($rootScope, csInputBase, csSettings) ->


  # ===== COMPILE =============================================================

  compile = ($templateElement, $templateAttributes) ->

    # Only modify the DOM in compile, use (pre/post) link for others
    $templateElement.addClass "cs-checkbox"

    # Pre-link: gets called for parent first
    pre: (scope, element, attrs, controller) ->
      return

    # Post-link: gets called for children recursively after post() traversed the DOM tree
    post: link


  # ===== LINK ================================================================

  link = ($scope, element, attrs, controller) ->
    csInputBase $scope

    $scope.i18n = csSettings.settings['i18n-engine']

    if $scope.formMode == 'create'
      if $scope.field.default?
        $scope.formItem.attributes[$scope.field.attribute] = $scope.field.default

    $scope.formItem.attributes[$scope.field.attribute] = !!$scope.formItem.attributes[$scope.field.attribute]

    # ===== WATCHES =======================================

    $scope.$watch 'formItem.attributes[field.attribute]', (newValue, oldValue) ->
      if (newValue != oldValue)
        $scope.$emit 'input-value-changed', $scope.field

    $scope.$on 'form-reset', () ->
      $scope.formItem.attributes[$scope.field.attribute] = false

    return

  # ===== CONFIGURE ===========================================================

  return {
    restrict: 'E'
    templateUrl: 'components/cs-fields/cs-checkbox/cs-checkbox-template.html'
    scope:
      field: '=' # The resource item which the form is working with
      formItem: '='
      formMode: '='
      options: '='
    compile: compile
  }

]
