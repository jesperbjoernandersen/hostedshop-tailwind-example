{*

# Description
Controller for the print template.

The controller uses $request, $order and $user to decided which type of content to generate.


## Date last modified
2018-08-29


## Primary variables
+ $request                                                              - Global scope variables containing build request information
+ $order                                                                - Global scope variable containing order information
+ $user                                                                 - Global scope variable containing user information


## Partials (templates)
+ "/modules/framework/print/print.tpl"                                  - Controller for print generation
+ "/modules/framework/layout/print.tpl"                                 - Standard layout forprint

*}
{* Controller to get email texts (top and bottom) *}
{controller type=printText assign=printTextCtrl}

{* Get text for top *}
{$print_top = $printTextCtrl->getTop($request->TypeId, null, null, $request->isPDF)}
{$print_bottom = $printTextCtrl->getBottom($request->TypeId, null, null, $request->isPDF)}

{* Include layout that renders top, bottom and content *}
{include
    file=$request->Template['Layout']
    top=$print_top
    bottom=$print_bottom
}
