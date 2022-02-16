{*

# Description
Controller for the email templates.

The controller uses $request, $user and $page to decided which type of collection to show.


## Date last modified
2018-04-15


## Primary variables
+ $request                                                              - Global scope variable containing request information
+ $user                                                                 - Global scope variable containing user information
+ $page                                                                 - Global scope variable containing page information


## Partials (templates)

*}

<table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
        <tr>
            <td valign="top" style="padding: 0;">
                <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tbody>
                        <tr>
                            <td valign="top" style="text-align: left;{$css->p_content}" colspan="2">
                                {$request->Content}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
    </tbody>
</table>
