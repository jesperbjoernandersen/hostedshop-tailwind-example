{*

# Description
Controller for the email templates.

The controller uses $request, $order and $user to decided which type of content to generate.


## Date last modified
2019-03-15


## Primary variables
+ $request                                                              - Global scope variables containing build request information
+ $order                                                                - Global scope variable containing order information
+ $user                                                                 - Global scope variable containing user information


## Partials (templates)
+ "/modules/framework/email/email.tpl"                                  - Controller for email generation
+ "/modules/framework/layout/email.tpl"                                 - Standard layout for email
+ "/modules/framework/email/standard.tpl"                               - Standard content builder
+ "/modules/framework/email/with-order.tpl"                             - Content builder with orderlines

*}
{* Controller to get email texts (top and bottom) *}
{controller type=emailText assign=emailTextCtrl}

{* Setup defaults *}
{$email_top = ''}
{$email_bottom = ''}

{* Handle email types *}
{if $request->isOrder}
    {* Set content based on input *}
    {$typeId = $request->TypeId}
    {$translationModule = 'shop_mail'}

    {* TypeId 31 is Order status changed, OrderStatusId is the new status *}
    {if $request->TypeId == 31}
        {$typeId = $request->OrderStatusId}
        {$translationModule = 'shop_order_mail'}
    {/if}

    {if $request->hasEmailText}
        {$email_top = $emailTextCtrl->getTop($typeId, $order->PaymentId, $translationModule) scope=root}
        {$email_bottom = $emailTextCtrl->getBottom($typeId, $order->PaymentId, $translationModule) scope=root}
    {/if}

{elseif $request->isUser}
    {* Set content based on input *}
    {if $request->hasEmailText}
        {$email_top = $emailTextCtrl->getTop($request->TypeId) scope=root}
        {$email_bottom = $emailTextCtrl->getBottom($request->TypeId) scope=root}
    {/if}
{/if}

{* Include layout that renders top, bottom and content *}
{include
    file=$request->Template['Layout']
    subject=$request->Subject
    top=$email_top
    bottom=$email_bottom
}
