# CloudStorm Components
> [**Home**](../README.md) ▸ [**Reference**](../docs/README.md) ▸ **CloudStorm Components**

CloudStorm is a collection of components that are designed to work together; you can use the components independently, or you can use them together as part of the default setup.

High-level components   | Form Input components                  | Misc components
----------------------- | -------------------------------------- | ---------------
[CS Wizard](#cs-wizard) | [CS Field](#cs-field)                  | [CS Alert](#cs-alert)
[CS Form](#cs-form)     | [CS Textfield](#cs-textfield)
[CS Index](#cs-index)   | [CS Checkbox](#cs-checkbox)
                        | [CS Date](#cs-date)
                        | [CS Time](#cs-time)
                        | [CS DateTime](#cs-datetime)
                        | [CS Enum](#cs-enum)
                        | [CS Number](#cs-number)
                        | [CS Resource Input](#cs-resource-input)

## CS Wizard
<a href="../src/components/cs-wizard"><img src="images/go_to_source.png" align="right"></a>

If you want to open a CS Wizard in a modal view, use the following snippet:

```javascript
$uibModal.open({
  scope: $scope,
  keyboard: false,
  backdrop: 'static',
  windowTopClass: 'modal-wizard',
  template: "<div cs-wizard cs-wizard-options=wizardOptions></div>",
});
```

### Options
**panel-number-callback**
* expects a function with one paremeter: `length`: To keep track of the number of panels open, callback is called with length as parameter

**cs-wizard-options**

Option                | Type       | Description
--------------------- | ---------- | -----------
`resource-type`       | string     | The type of the form item. Should match the type of its csResource descriptor
`max-depth`           | integer    | How many panels deep should the wizard open. If the max depth is reached, there will be no "NEW" buttons on resources of the last open panel.
`form-item`           | expression | The object to edit
`form-mode`           | string     | What kind of form is this? Available options: 'create', 'edit'
`keep-first`          | boolean    | Does not pop the panel on the root form submit
`template-overrides`  | object     | See at [CS Field](#cs-field)
`directive-overrides` | object     | See at [CS Field](#cs-field)
`attributes-to-hide`  | object     | You can set attribute visibility at component level similarly to [CS Resource](basics.md) level.
`events`              | object     | You can add one callback per lifecycle event. Example:
```
"events": {
  'wizard-canceled': (resource) ->
    <<handle event>>
  'wizard-submited': (resource) ->
    <<handle happy event>>
  'wizard-error': (resource) ->
    <<handle sad event>>
}
```

> Note: You can augment the list of CS Wizard Options with options of CS Form and CS Fields -> the options will trickle down to CS Forms and CS Fields, so you only need to set them at the root, where you place a CS Wizard.


### Lifecycle events

Event              | Direction | Description
------------------ | --------- | -----------
`wizard-finished`  | up        | Emited when a wizard completed, regardless of outcome
`wizard-canceled`  | up        | Emited when user cancels the wizard
`wizard-submited`  | up        | Emited when a wizard is successfully submited
`wizard-error`     | up        | Emited when there was an error submiting a form within the wizard
`wizard-cancel`    | down      | When the form was canceled


> Note: The wizard cancels the current form on `ESC` key press.

[to top ↑](./components.md)

## CS Form
<a href="../src/components/cs-form"><img src="images/go_to_source.png" align="right"></a>

### Options
**cs-form-options**

Option            | Type     | Description
----------------- | -------- | -----------
`reset-on-submit` | boolean  | Resets all inputs in the form on form submit
`skip-on-enter`   | boolean  | Form should not be submited when hitting enter in a CS Textfield

### Lifecycle events

Event              | Direction | Description
------------------ | --------- | -----------
`form-init`        | up        | Emited when the form is linked. The scope of the form is passed as first argument.
`form-cancel`      | up        | Emited when user cancels a form (in a CS Wizard or a self-contained CS Form)
`form-submit`      | up        | Emited when a form is successfully submited
`form-error`       | up        | Emited when there was server side error with the submited form
`form-reset`       | down      | When form should be reset
`form-scroll`      | down      | When the form was scrolled
`field-error`      | down      | When there was server side error with the submited form
`field-cancel`     | down      | When the form was canceled
`field-submit`     | down      | When the form was submited

### Client-side validation
CS Form implements basic Angular client-side validation. You can evaluate the form's validity in the template through the boolean expression `csForm.$invalid`

[to top ↑](./components.md)

## CS Field
<a href="../src/components/cs-field"><img src="images/go_to_source.png" align="right"></a>

### Lifecycle events

Event                 | Direction | Description
--------------------- | --------- | -----------
`input-value-changed` | up        | Emited when a value changes
`create-resource`     | up        | Emited when an input requests the CS Wizard to push a new form to the panel stack for creating a certain type of resource

### Handling server-side validation
* If a validation error is returned for an API call in the [correct JSON API format](http://jsonapi.org/format/#errors), the affected CS Fields automatically show bootstrap `has-error` behavior and a hint text is displayed with the description of the error for the particular fields.

### Overrides
It is possible to set a __template override__ or __directive override__ for all occurrences of a __type__ of CSField (Eg.: CSResourceInput) or for a certain __attribute__.
You can set an override at the following stages of the template chain: [CSWizard, CSForm, CSField].
The respective component options hash may have a `template-overrides` as well as a `directive-overrides` key with array value. You can override any number of attributes or types with the arrays.

#### How to set a directive override
1) overrding inputs for a certain attribute
`{attribute: 'serial_numbers', directive: "directive-for-serial-numbers"}`

2) overrding type of input
`{type: 'resource', directive: "new-resource-directive"}`

(attribute has precedence over type)

> directive-overrides expect the name of the new directive in `kebab-case` as opposed to `normalizedCamelCase`
> When using `directive-override` the entire default logic of the default directive is overriden.

#### How to set a template override
1) overrding inputs for a certain attribute
`{attribute: 'serial_numbers', template: "directives/resource-with-checkboxes.html"}`

2) overrding type of input
`{type: 'resource', template: "directives/resource-with-checkboxes.html"}`

(attribute has precedence over type)

> template-overrides expect a path to a template which will override the default template of the component, leaving the default directive logic intact. Additional logic can be included eg. using a child ng-controller introduced in the new template.

### Example usage:

```
$scope.csWizardOptions =
  "resource-type": "products"
  "form-item": {}
  "form-mode": "create"
  "template-overrides": [ {type: 'resource', template: "directives/resource-with-checkboxes.html"} ]
  "directive-overrides": [ {attribute: 'serial-number', directive: "new-serial-number"},
                           {type: 'boolean' directive: "new-checkbox-directive"} ]
]
```

> :warning: When overriding CSResourceInput, don't forget to: call `$scope.refresh()` at initialization, as we rely on this call to populate the selectable resource.

> In order to get access to the helper functions of [CSInputBase](#cs-input-base), inject CSInputBase in your controller / directive and call `CSInputBase($scope)` in controller initialization / directive link of your custom template.

[to top ↑](./components.md)

## CS Checkbox
<a href="../src/components/cs-checkbox"><img src="images/go_to_source.png" align="right"></a>

The `required` attribute has no effect on a CS Checkbox.

## CS Date
<a href="../src/components/cs-date"><img src="images/go_to_source.png" align="right"></a>

**cs-field-options**

Option             | Type     | Description
------------------ | -------- | -----------
`date-format`      | string   | (optional) If exist, the ng-model of date is parsed with this format through Angular UI's uibDateParser
`time-zone-offset` | string   | (optional) Defaults to 'utc'. If exist, the offset of the date is altered through the ng-model-options parameter of the uib-datepicker. Use a time zone offset, for example, '+0430' (4 hours, 30 minutes east of the Greenwich meridian). Read more at the [official Angular docs](https://docs.angularjs.org/api/ng/directive/ngModelOptions)

[to top ↑](./components.md)

## CS Time
<a href="../src/components/cs-time"><img src="images/go_to_source.png" align="right"></a>

## CS DateTime
<a href="../src/components/cs-datetime"><img src="images/go_to_source.png" align="right"></a>

## CS Enum
<a href="../src/components/cs-enum"><img src="images/go_to_source.png" align="right"></a>

## CS Number
<a href="../src/components/cs-number"><img src="images/go_to_source.png" align="right"></a>

## CS Resource Input
<a href="../src/components/cs-resource-input"><img src="images/go_to_source.png" align="right"></a>

[to top ↑](./components.md)

## CS Textfield
<a href="../src/components/cs-textfield"><img src="images/go_to_source.png" align="right"></a>

#### Lifecycle events

Event                  | Direction | Description
-----------------------| --------- | -----------
`submit-form-on-enter` | up        | Emited to programmatically submit a form on hitting enter in a `cardinality: one` CS Texfield

[to top ↑](./components.md)

## CS Input Base
Provides helper fuctions through decorating the scope of every directive that calls CSInputBase($scope) on it.
(poor man's directive inheritance - helps to keep the code of different CS Inputs DRY)

[to top ↑](./components.md)

## CS Index
<a href="../src/components/cs-index"><img src="images/go_to_source.png" align="right"></a>

If the resource's descriptor contains a `hint` attribute, it's value will be shown as the subheading of the component.

**cs-index-options**

Option               | Type     | Description
-------------------- | -------- | -----------
`resource-type`      | string   | The type of the items to be listed. Should match the type of its csResource descriptor
`hide-actions`       | boolean  | Whether to show the actions at the end of each row (`default: false`)

Example usage:

##### example.html
```html
  <cs-index resource-type=resourceType cs-index-option=options></cs-index>
```
##### example.js
```javascript
  $scope.resourceType = "procedures";
  $scope.options = { 'hide-actions' : true };

```

[to top ↑](./components.md)

## CS Alert
<a href="../src/components/cs-alert"><img src="images/go_to_source.png" align="right"></a>

**Usage**

1. Place a `<cs-alert></cs-alert>` element in your layout.
1. Include `csAlertService` as dependency in controller/directive
1. Add an alert by calling `csAlertService.addAlert(message,type)`. Available types are same as Bootstrap: 'success', 'info', 'warning', 'danger'.

> When used from template make `csAlertService`accessible on $scope
(eg: in `ng-click => csAlertService.addAlert('alert','success')`)

:warning:
> Place only one cs-alert element per app, or make sure that there is only one such element in your view at the same time (eg: by placing it in a shared header template)!
