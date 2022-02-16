{*

# Description
Standard layout template for emails


# Credit
Credit goes to Cerberus project. Cerberus is a collection of Responsive Email Patterns found at [Cerberus Responsive Email Patterns](https://github.com/TedGoas/Cerberus).
Licensed under MIT.


## Date last modified
2021-05-28


## Primary variables
+ $request                                                              - Global scope variables containing build request information
+ $order                                                                - Global scope variable containing order information
+ $user                                                                 - Global scope variable containing user information


## Partials (templates)


*}
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
    <meta charset="windows-1252">
    <meta name="viewport" content="width=device-width">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="x-apple-disable-message-reformatting">
    <title>{$request->Subject}</title>

    {strip}

    {* Include styles formatted as Smarty to be reused *}
    {include file="modules/framework/widgets/email-style.tpl"}

    {* Web Font / @font-face : BEGIN *}
    {* Desktop Outlook chokes on web font references and defaults to Times New Roman, so we force a safe fallback font. *}
    <!--[if mso]>
        <style>
            * { {$css->font->family} !important; }
            h1,h2,h3,h4,h5 { {$css->font->family_headline} !important; }
        </style>
    <![endif]-->

    {* none outlook client *}
    <!--[if !mso]><!-->
    {* Insert web font reference, eg: <link href='https://fonts.googleapis.com/css?family=Roboto:400,700' rel='stylesheet' type='text/css'> *}
    <style type="text/css">
        img {
            max-width: 100%; 
            height: auto !important;
            min-height: 1px !important;
        }
    </style>
    <!--<![endif]-->

    {if !isset($template.settings.EMAIL_CONTACT_INFORMATION)}
        {$template.settings.EMAIL_CONTACT_INFORMATION = 'BOTTOM'}
    {/if}

    {if !isset($template.settings.EMAIL_SOCIAL)}
        {$template.settings.EMAIL_SOCIAL = false}
    {/if}
    {/strip}

    {* CSS Reset : BEGIN *}
    <style>
        {strip}
        {*
            What it does: Remove spaces around the email design added by some email clients.
            Beware: It can remove the padding / margin and add a background color to the compose a reply window.
        *}
        html,
        body {
            margin: 0 auto !important;
            padding: 0 !important;
            height: 100% !important;
            width: 100% !important;
        }
        {/strip}

        {strip}
        {* What it does: Stops email clients resizing small text. *}
        * {
            -ms-text-size-adjust: 100%;
            -webkit-text-size-adjust: 100%;
        }

        {/strip}{* What it does: Centers email on Android 4.4 *}
        div[style*="margin: 16px 0"] { margin: 0 !important; }

        {strip}
        {* What it does: Stops Outlook from adding extra spacing to tables. *}
        table,
        td {
            mso-table-lspace: 0pt !important;
            mso-table-rspace: 0pt !important;
        }

        {* What it does: Fixes webkit padding issue. Fix for Yahoo mail table alignment bug. Applies table-layout to the first 2 tables then removes for anything nested deeper. *}
        table {
            border-spacing: 0 !important;
            border-collapse: collapse !important;
            table-layout: fixed !important;
            margin: 0 auto !important;
        }
        table table table { table-layout: auto; }

        {/strip}{* What it does: Uses a better rendering method when resizing images in IE. *}
        img { -ms-interpolation-mode:bicubic; }

        {* What it does: Prevents Windows 10 Mail from underlining links despite inline CSS. Styles for underlined links should be inline. *}
        a, a:link, a:visited { text-decoration: none; }
        a:hover { text-decoration: underline; }

        {* What it does: Setups defaults for typography *}
        h1, h1 a, h1 a:visited, h2, h2 a, h2 a:visited, h3, h3 a, h3 a:visited, h4, h5, h6, .t_cht { {$css->text}; }
        h1 { {$css->h1}; }
        h2 { {$css->h2}; }
        h3 { {$css->h3}; }
        p { {$css->p}; }

        {strip}
        {* What it does: A work-around for email clients meddling in triggered links. *}
        *[x-apple-data-detectors],  {* iOS *}
        .unstyle-auto-detected-links *,
        .aBn {
            border-bottom: 0 !important;
            cursor: default !important;
            color: inherit !important;
            text-decoration: none !important;
            font-size: inherit !important;
            font-family: inherit !important;
            font-weight: inherit !important;
            line-height: inherit !important;
        }


        {* If the above doesn't work, add a .g-img class to any image in question. *}
        img.g-img + div { display: none !important; }

        {*
            What it does: Removes right gutter in Gmail iOS app: https://github.com/TedGoas/Cerberus/issues/89
            Create one of these media queries for each additional viewport size you'd like to fix
        *}

        {/strip}
        {* iPhone 4, 4S, 5, 5S, 5C, and 5SE *}
        @media only screen and (min-device-width: 320px) and (max-device-width: 374px) {
            .email-container { min-width: 320px !important; }
        }
        {* iPhone 6, 6S, 7, 8, and X *}
        @media only screen and (min-device-width: 375px) and (max-device-width: 413px) {
            .email-container { min-width: 375px !important; }
        }
        {* iPhone 6+, 7+, and 8+ *}
        @media only screen and (min-device-width: 414px) {
            .email-container { min-width: 414px !important; }
        }

        {* What i does: Outlook web adds .ExternalClass to a wrapping element of the email *}
        .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td { {$css->text}; }
        .ExternalClass { width: 100%; }
    </style>

    {strip}
    {* CSS Reset : END *}
    {* Reset list spacing because Outlook ignores much of our inline CSS. *}
    <!--[if mso]>
    <style type="text/css">
        ul,
        ol {
            margin: 0 !important;
        }
        li {
            margin-left: 30px !important;
        }
        li.list-item-first {
            margin-top: 0 !important;
        }
        li.list-item-last {
            margin-bottom: 10px !important;
        }
    </style>
    <![endif]-->

    {* Progressive Enhancements : BEGIN *}
    <style>
        {* Media Queries *}
        @media screen and (max-width: 600px) {
            {* What it does: Adjust typography on small screens to improve readability *}
            .email-container p { font-size: 17px !important; }
        }
    </style>
    {* Progressive Enhancements : END *}

    {* What it does: Makes background images in 72ppi Outlook render at correct size. *}
    <!--[if gte mso 9]>
    <xml>
        <o:OfficeDocumentSettings>
            <o:AllowPNG/>
            <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
    </xml>
    <![endif]-->
    {/strip}
</head>
{*
    The email background color (#ffffff) is defined in three places:
    1. body tag: for most email clients
    2. center tag: for Gmail and Inbox mobile apps and web versions of Gmail, GSuite, Inbox, Yahoo, AOL, Libero, Comcast, freenet, Mail.ru, Orange.fr
    3. mso conditional: For Windows 10 Mail
*}
<body width="100%" style="margin: 0; padding: 0 !important; mso-line-height-rule: exactly; {$css->background["main"]}{$css->p}"><center style="width: 100%; {$css->background["main"]}">
    <!--[if mso | IE]>
    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="{$css->background["main"]}">
    <tr>
    <td>
    <![endif]-->


        {* Full Bleed Background Section : BEGIN *}
        {if $request->isEmailCopy}
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="{$css->background['footer']}">
            <tr>
                <td valign="top">
                    <div style="max-width: 600px; margin: auto;" class="email-container">
                        <!--[if mso]>
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="600" align="center">
                        <tr>
                        <td>
                        <![endif]-->
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr><td valign="center" align="center" style="{$css->paddingSmall}{$css->color["footer"]}{$css->font_family}{$css->font->p}">{$text.CHECKOUT_MAIL_ORDER_COPY_TEXT}</td></tr>
                        </table>
                        <!--[if mso]>
                        </td>
                        </tr>
                        </table>
                        <![endif]-->
                    </div>
                </td>
            </tr>
        </table>
        {/if}
        {* Full Bleed Background Section : END *}

        {*
            Set the email width. Defined in two places:
            1. max-width for all clients except Desktop Windows Outlook, allowing the email to squish on narrow but never go wider than 600px.
            2. MSO tags for Desktop Windows Outlook enforce a 600px width.
        *}
        <div style="max-width: 640px; margin: 0 auto;" class="email-container">
            <!--[if mso]>
            <table align="center" role="presentation" cellspacing="0" cellpadding="0" border="0" width="600">
            <tr>
            <td>
            <![endif]-->

            {* Email Body : BEGIN *}
            <table bgcolor="{$css->rawColors['000']}" align="center" role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="margin: 0 auto;">
                {* Email Header : BEGIN *}
                <tr>
                    {if $template.settings.EMAIL_CONTACT_INFORMATION eq 'TOP'}
                        <td height="100%" valign="top" width="100%" style="padding:{$css->rawPadding*2}px {$css->rawPadding}px 0 {$css->rawPadding}px;">
                            <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="table-layout:auto !important;">
                                <tr>
                                    <td height="100%" valign="center" align="left" style="{if $template.settings.LOGO_TYPE eq 'PICTURE' and !empty($template.settings.LOGO_SOURCE_NEGATIVE)}{else}padding:{$css->rawPadding}px {$css->rawPadding}px 0 0;{/if}{$css->background['000']}{$css->text};">{include file="modules/framework/widgets/logo.tpl" style=false}</td>
                                    <td height="100%" valign="top" align="left" style="width:5%;">&nbsp;</td>
                                    <td height="100%" valign="top" align="left" style="width:30%;">
                                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                            {if $contactdata.name && $template.settings.SETTINGS_SHOW_CONTACT_TITLE}
                                                <tr><td valign="top" align="right"><b style="{$css->p}{$css->bold}">{$contactdata.name}</b></td></tr>
                                            {/if}

                                            {if $contactdata.address && $template.settings.SETTINGS_SHOW_CONTACT_ADDRESS}
                                                <tr><td valign="top" align="right" style="{$css->small}">{$contactdata.address}</td></tr>
                                            {/if}

                                            {if ($contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE) || ($contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY)}
                                                <tr><td valign="top" align="right" style="{$css->small}">{if $contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE}{$contactdata.zipcode}{/if} {if $contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY}{$contactdata.city}{/if}</td></tr>
                                            {/if}

                                            {if $contactdata.country && $template.settings.SETTINGS_SHOW_CONTACT_COUNTRY}
                                                <tr><td valign="top" align="right" style="{$css->small}">{$contactdata.country}</td></tr>
                                            {/if}

                                            {if $contactdata.phone && $template.settings.SETTINGS_SHOW_CONTACT_PHONE}
                                                <tr><td valign="top" align="right" style="{$css->small}">{$text.TELEPHONE}: {$contactdata.phone}</td></tr>
                                            {/if}
                                            {if $contactdata.mobilephone && $template.settings.SETTINGS_SHOW_CONTACT_MOBILE}
                                                <tr><td valign="top" align="right" style="{$css->small}">{$text.MOBILE}: {$contactdata.mobilephone}</td></tr>
                                            {/if}
                                            {if $contactdata.fax && $template.settings.SETTINGS_SHOW_CONTACT_FAX}
                                                <tr><td valign="top" align="right" style="{$css->small}">{$text.FAX}: {$contactdata.fax}</td></tr>
                                            {/if}
                                            {if $contactdata.email && $template.settings.SETTINGS_SHOW_CONTACT_EMAIL}
                                                <tr><td valign="top" align="right" style="{$css->small}">{$text.MAIL}: <a style="{$css->link}" href="mailto:{$contactdata.email}">{$contactdata.email}</a></td></tr>
                                            {/if}

                                            <tr>
                                                <td valign="top" align="right" style="{$css->small}">
                                                    {if $contactdata.vatnumber && $template.settings.SETTINGS_SHOW_CONTACT_VAT_NUMBER}{$text.VAT_NR}: {$contactdata.vatnumber}{/if}
                                                    {if $contactdata.bankinfo && $template.settings.SETTINGS_SHOW_CONTACT_BANK_NUMBER}{$text.BANK_DETAILS}: {$contactdata.bankinfo}{/if}
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    {else}
                        <td height="100%" align="center" valign="top" width="100%" style="{if $template.settings.LOGO_TYPE eq 'PICTURE' and !empty($template.settings.LOGO_SOURCE_NEGATIVE)}padding-top:{$css->rawPadding*2}px;{else}padding:{$css->rawPadding*2}px {$css->rawPadding}px 0 {$css->rawPadding}px;{/if}{$css->background['000']}{$css->text};">
                            <!--[if mso]>
                            <p>&nbsp;</p>
                            <p>&nbsp;</p>
                            <![endif]-->
                            {if $template.settings.LOGO_TYPE eq 'TEXT'}
                                {include file="modules/framework/widgets/logo.tpl" style="{$css->headline}{$css->bold};font-size:32px;line-height:40px;font-weight:normal;text-decoration:none;"}
                            {else}
                                {include file="modules/framework/widgets/logo.tpl" style=false}
                            {/if}
                        </td>
                    {/if}
                </tr>
                {* Email Header : END *}

                <tr>
                    <td height="100%" valign="top" width="100%" style="padding: {$css->rawPadding*2}px {$css->rawPadding}px {$css->rawPadding}px {$css->rawPadding}px;{$css->background['000']}">
                        {if !empty($subject)}
                            <center style="padding: 0 0 {$css->rawPadding*2}px 0;">
                                <h1 style="{$css->h1}">{$subject}</h1>
                            </center>
                        {/if}

                        {if $request->Recipient && !$request->isForm}
                            <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td style="{$css->p};padding: 0;padding-bottom: 1em;">DEAR MAIL_RECIEVER,</td>
                                </tr>
                            </table>
                        {/if}

                        {if !empty($top)}
                            <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td style="{$css->p_content};padding: 0;">
                                        {$top}
                                    </td>
                                </tr>
                            </table>
                        {/if}

                        {* Include content template based on setting *}
                        {include
                            file=$request->Template['Content']
                            order=$order
                            user=$user
                        }

                        {if !empty($bottom)}
                            <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td style="{$css->p_content};padding: 0;">
                                        {$bottom}
                                    </td>
                                </tr>
                            </table>
                        {/if}
                    </td>
                </tr>
            </table>
            {* Email Body : END *}

            {* Email Footer : BEGIN *}

            {$socialFooter =  !empty($settings.social_instagram_pageurl)
                || $settings.social_facebook and !empty($settings.social_plugin_likebox_pageurl)
                || $settings.social_twitter  and !empty($settings.social_twitter_pageurl)
                || $settings.social_youtube  and !empty($settings.social_youtube_pageurl)
                || $settings.social_linkedin and !empty($settings.social_linkedin_pageurl)
            }

            {if $access.social and $socialFooter && $template.settings.EMAIL_SOCIAL}
            <table align="center" role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="margin: 0 auto;table-layout:auto !important;">
                <tr>
                    <td style="width:10%;"></td>
                    <td valign="top" style="padding: {$css->rawPadding*2}px {$css->rawPadding}px;{$css->background['main']}">
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                {if $settings.social_plugin_likebox_pageurl and $settings.social_facebook}
                                <td align="center" style="{$css->p} line-height: 100%;">
                                    <a style="{$css->link}" href="{$settings.social_plugin_likebox_pageurl}" title="{$text.SOCIAL_BOX_FACEBOOK}" target="_blank" rel="noopener"><img src="{$template.cdn}/{locateFile file='assets/images/facebook.png'}" alt="{$text.SOCIAL_BOX_FACEBOOK}"></a>
                                </td>
                                {/if}
                                {if $settings.social_twitter_pageurl and $settings.social_twitter}
                                <td align="center" style="{$css->p} line-height: 100%;">
                                    <a style="{$css->link}" href="{$settings.social_twitter_pageurl}" title="{$text.SOCIAL_BOX_TWITTER}" target="_blank" rel="noopener"><img src="{$template.cdn}/{locateFile file='assets/images/twitter.png'}" alt="{$text.SOCIAL_BOX_TWITTER}"></a>
                                </td>
                                {/if}
                                {if $settings.social_youtube_pageurl and $settings.social_youtube}
                                <td align="center" style="{$css->p} line-height: 100%;">
                                    <a style="{$css->link}" href="{$settings.social_youtube_pageurl}" title="{$text.SOCIAL_BOX_YOUTUBE}" target="_blank" rel="noopener"><img src="{$template.cdn}/{locateFile file='assets/images/youtube.png'}" alt="{$text.SOCIAL_BOX_YOUTUBE}"></a>
                                </td>
                                {/if}
                                {if $settings.social_linkedin_pageurl and $settings.social_linkedin}
                                <td align="center" style="{$css->p} line-height: 100%;">
                                    <a style="{$css->link}" href="{$settings.social_linkedin_pageurl}" title="{$text.SOCIAL_BOX_LINKEDIN}" target="_blank" rel="noopener"><img src="{$template.cdn}/{locateFile file='assets/images/linkedin.png'}" alt="{$text.SOCIAL_BOX_LINKEDIN}"></a>
                                </td>
                                {/if}
                                {if $settings.social_instagram_pageurl}
                                <td align="center" style="{$css->p} line-height: 100%;">
                                    <a style="{$css->link}" href="{$settings.social_instagram_pageurl}" title="{$text.SOCIAL_BOX_INSTAGRAM}" target="_blank" rel="noopener"><img src="{$template.cdn}/{locateFile file='assets/images/instagram.png'}" alt="{$text.SOCIAL_BOX_INSTAGRAM}"></a>
                                </td>
                                {/if}
                            </tr>
                        </table>
                    </td>
                    <td style="width:10%;"></td>
                </tr>
            </table>
            {/if}

            {if $template.settings.EMAIL_CONTACT_INFORMATION neq 'TOP' || $request->isNewsletter}
            <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="{$css->background['footer']}">
                {if $template.settings.EMAIL_CONTACT_INFORMATION neq 'TOP'}
                <tr>
                    <td style="{$css->padding}{$css->color["footer"]}">
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                            {if $contactdata.name && $template.settings.SETTINGS_SHOW_CONTACT_TITLE}
                                <tr><td valign="top" align="center"><b style="{$css->font_family}{$css->font->p}{$css->color['footer']}">{$contactdata.name}</b></td></tr>
                            {/if}

                            <tr>
                                <td valign="top" align="center" style="{$css->font_family}{$css->font->p}{$css->color['footer']}">
                                    {if $contactdata.address && $template.settings.SETTINGS_SHOW_CONTACT_ADDRESS}{$contactdata.address}{/if}

                                    {if ($contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE) || ($contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY)}
                                        {if $contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE}{$contactdata.zipcode}{/if}
                                        {if $contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY}{$contactdata.city}{/if}
                                    {/if}

                                    {if $contactdata.country && $template.settings.SETTINGS_SHOW_CONTACT_COUNTRY}{$contactdata.country}{/if}
                                </td>
                            </tr>

                            <tr>
                                <td valign="top" align="center" style="{$css->font_family}{$css->font->p}{$css->color['footer']}">
                                    {if $contactdata.phone && $template.settings.SETTINGS_SHOW_CONTACT_PHONE}{$text.TELEPHONE}: {$contactdata.phone}{/if}
                                    {if $contactdata.mobilephone && $template.settings.SETTINGS_SHOW_CONTACT_MOBILE}{$text.MOBILE}: {$contactdata.mobilephone}{/if}
                                    {if $contactdata.fax && $template.settings.SETTINGS_SHOW_CONTACT_FAX}{$text.FAX}: {$contactdata.fax}{/if}
                                    {if $contactdata.email && $template.settings.SETTINGS_SHOW_CONTACT_EMAIL}{$text.MAIL}: <a style="{$css->link}" href="mailto:{$contactdata.email}">{$contactdata.email}</a>{/if}
                                </td>
                            </tr>

                            <tr>
                                <td valign="top" align="center" style="{$css->font_family}{$css->font->p}{$css->color['footer']}">
                                    {if $contactdata.vatnumber && $template.settings.SETTINGS_SHOW_CONTACT_VAT_NUMBER}{$text.VAT_NR}: {$contactdata.vatnumber}{/if}
                                    {if $contactdata.bankinfo && $template.settings.SETTINGS_SHOW_CONTACT_BANK_NUMBER}{$text.BANK_DETAILS}: {$contactdata.bankinfo}{/if}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                {/if}

                {if $request->isNewsletter}
                <tr>
                    <td style="{$css->padding}{if $template.settings.EMAIL_CONTACT_INFORMATION neq 'TOP'}padding-top:0;{/if}{$css->color["footer"]}">
                        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr><td valign="top" align="center"><unsubscribe><a style="{$css->text}{$css->font->p}{$css->color["secondary"]}text-decoration:underline;" href="{$general.domain}/{$text.NEWLSLETTER_LINK}/?unsubscribe">{$text.NEWSLETTER_SIGNOFF}</a></unsubscribe></td></tr>
                        </table>
                    </td>
                </tr>
                {/if}
            </table>
            {/if}

            <!--[if mso]>
            </td>
            </tr>
            </table>
            <![endif]-->
        </div>

    <!--[if mso | IE]>
    </td>
    </tr>
    </table>
    <![endif]-->
    </center>

    {if $request->isOrder && $request->isTrustpilot}
        {if !isset($orderCustomer)}
            {* Order Customer entity *}
            {entity controller=orderCustomer assign=orderCustomer orderId=$order->Id}
        {/if}

        {include file="modules/framework/widgets/trustpilot.tpl" trustpilot=[
            'email'     => $request->Recipient,
            'name'      => "{$orderCustomer->Firstname} {$orderCustomer->Lastname}",
            'orderId'   => $order->Id
        ]}
    {/if}
</body>
</html>
