{*

# Description
Controller for the framework related templates.

The controller decides whether the incoming request is to generate print or email content


## Date last modified
2019-05-06


## Primary variables
+ $request                                                              - Global scope variables containing build request information
+ $order                                                                - Global scope variable containing order information
+ $user                                                                 - Global scope variable containing user information


## Partials (templates)
+ "/modules/email/email.tpl"                                            - Email content builder
+ "/modules/print/print.tpl"                                            - Print content builder

*}

{* Short code replacemten variable with fallbacks *}
{$replacements = [
    "MAIL_SUBJECT"      => "",
    "MAIL_RECIEVER"     => "",
    "MAIL_RECEIVER"     => "",
    "ORDER_NUMBER"      => "",
    "#ORDER_NUMBER#"    => "",
    "#ORDER_STATUS#"    => "",
    "#INVOICE_NUMBER#"  => ""
]}

{* Controller includes *}
{if $request->isEmail}
    {include file="modules/framework/email/email.tpl" assign=result}

    {* Setting up mail receiver *}
    {$mailReceiver = $request->Recipient}
    {if $request->isBlog
     || $request->isContactForm
     || $request->isReview
     || ($request->isApplyB2B && !$request->hasEmailText)
    }
        {$mailReceiver = $contactdata['company']}
    {else}
        {$userObj = $user}
        {if $request->isOrder}
            {$userObj = $orderCustomer}
        {/if}

        {if $userObj}
            {if $request->isApplyB2B}
                {$mailReceiver = $userObj->Company}
            {elseif $userObj->Firstname}
                {$mailReceiver = $userObj->Firstname}
            {elseif $userObj->Company}
                {$mailReceiver = $userObj->Company}
            {/if}
        {/if}
    {/if}

    {$replacements["MAIL_SUBJECT"] = $request->Subject} {* Mail subject *}
    {$replacements["MAIL_RECIEVER"] = $mailReceiver} {* Name of recipient *}
    {$replacements["MAIL_RECEIVER"] = $mailReceiver} {* Name of recipient *}
{elseif $request->isPrint}
    {include file="modules/framework/print/print.tpl" assign=result}
{/if}


{* Replace all replacements and print out request content *}
{include file="modules/framework/widgets/replacements.tpl" assign=response result=$result replacements=$replacements}

{$response}