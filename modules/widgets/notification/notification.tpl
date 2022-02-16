{*

# Description
Notification widget. A widget is a small helper template, with some functionality.
Panel used to show system notifications


## Date last modified
2014-08-01


## Primary variables
+ $message                                                              - Message information from the system
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}
{if $message}
<div class="w-notification">
    <div class="panel {if $message->status() eq 0}panel-success{else}panel-danger{/if}">
        <div class="panel-body text-center">
            {$message->text()}
        </div>
    </div>
</div>
{/if}
