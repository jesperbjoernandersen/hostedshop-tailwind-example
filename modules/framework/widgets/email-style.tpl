{*

# Description
Style widget. A widget is a small helper template, with some functionality. This one contains
variables for easier reuse in inline styling.

## Date last modified
2019-04-10


## Primary variables
No primary variables


## Partials (templates)
No extra templates required for this template

*}{strip}

{* Variables for easier reuse in inline styling *}
{$styling = []}

{* Initial colors in raw format *}
{$styling['rawColors'] = [
    "900" => "#000000",
    "700" => "#4a4a4a",
    "500" => "#1a1a1a",
    "300" => "#757575",
    "100" => "#e2e2e2",
    "000" => "#ffffff",
    "main" => "#cfe0e4",
    "secondary" => "#5ac5de",
    "footer" => "#757575",
    "footer_color" => "#FFFFFF"
]}

{* Overwrite initial colors with user defined colors *}
{if isset($template.settings.EMAIL_COLOR_BACKGROUND) && !empty($template.settings.EMAIL_COLOR_BACKGROUND)}
    {$styling['rawColors']['main'] = $template.settings.EMAIL_COLOR_BACKGROUND}
{/if}
{if isset($template.settings.EMAIL_COLOR_LINKS) && !empty($template.settings.EMAIL_COLOR_LINKS)}
    {$styling['rawColors']['secondary'] = $template.settings.EMAIL_COLOR_LINKS}
{/if}
{if isset($template.settings.EMAIL_FOOTER_COLOR_BACKGROUND) && !empty($template.settings.EMAIL_FOOTER_COLOR_BACKGROUND)}
    {$styling['rawColors']['footer'] = $template.settings.EMAIL_FOOTER_COLOR_BACKGROUND}
{/if}
{if isset($template.settings.EMAIL_FOOTER_COLOR) && !empty($template.settings.EMAIL_FOOTER_COLOR)}
    {$styling['rawColors']['footer_color'] = $template.settings.EMAIL_FOOTER_COLOR}
{/if}

{* Setting background-colors *}
{$styling['background'] = [
    "900" => "background-color: {$styling['rawColors']['900']};",
    "700" => "background-color: {$styling['rawColors']['700']};",
    "500" => "background-color: {$styling['rawColors']['500']};",
    "300" => "background-color: {$styling['rawColors']['300']};",
    "100" => "background-color: {$styling['rawColors']['100']};",
    "000" => "background-color: {$styling['rawColors']['000']};",
    "main" => "background-color: {$styling['rawColors']['main']};",
    "secondary" => "background-color: {$styling['rawColors']['secondary']};",
    "footer" => "background-color: {$styling['rawColors']['footer']};"
]}

{* Setting colors *}
{$styling['color'] = [
    "900" => "color: {$styling['rawColors']['900']};",
    "700" => "color: {$styling['rawColors']['700']};",
    "500" => "color: {$styling['rawColors']['500']};",
    "300" => "color: {$styling['rawColors']['300']};",
    "100" => "color: {$styling['rawColors']['100']};",
    "000" => "color: {$styling['rawColors']['000']};",
    "main" => "color: {$styling['rawColors']['main']};",
    "secondary" => "color: {$styling['rawColors']['secondary']};",
    "footer" => "color: {$styling['rawColors']['footer_color']};"
]}

{* Styling typography *}
{$styling['rawFont'] = [
    "h1" => "font-size: 20px; line-height: 30px;",
    "h2" => "font-size: 16px; line-height: 24px;",
    "h3" => "font-size: 15px; line-height: 22px;",
    "p" => "font-size: 14px; line-height: 19px;",
    "small" => "font-size: 12px; line-height: 16px;",
    'family' => "sans-serif",
    'family_headline' => "sans-serif"
]}

{if isset($template.settings.EMAIL_FONT_FAMILY_BASE) && !empty($template.settings.EMAIL_FONT_FAMILY_BASE)}
    {$styling['rawFont']['family'] = $template.settings.EMAIL_FONT_FAMILY_BASE}
{/if}
{if isset($template.settings.EMAIL_FONT_FAMILY_HEADLINE) && !empty($template.settings.EMAIL_FONT_FAMILY_HEADLINE)}
    {$styling['rawFont']['family_headline'] = $template.settings.EMAIL_FONT_FAMILY_HEADLINE}
{/if}

{$styling['font'] = (object)$styling['rawFont']}


{$styling['font_family'] = "font-family: {$styling['font']->family};"}
{$styling['font_head'] = "font-family: {$styling['font']->family_headline};"}
{$styling['text'] = "margin:0;mso-line-height-rule:exactly;{$styling['font_family']}{$styling['color']['500']}"}
{$styling['headline'] = "margin:0;mso-line-height-rule:exactly;{$styling['font_head']}{$styling['color']['500']}"}
{$styling['bold'] = "font-weight: bold;"}
{$styling['h1'] = "{$styling['headline']}{$styling['bold']}{$styling['font']->h1}"}
{$styling['h2'] = "{$styling['headline']}{$styling['bold']}{$styling['font']->h2}"}
{$styling['h3'] = "{$styling['headline']}{$styling['bold']}{$styling['font']->h3}"}
{$styling['p'] = "{$styling['text']}{$styling['font']->p}"}
{$styling['p_300'] = "margin:0;{$styling['font_family']}{$styling['font']->p}{$styling['color']['300']}"}
{$styling['p_content'] = "font-size:14px;line-height:normal;margin:0;{$styling['font_family']}{$styling['color']['500']}"}
{$styling['small'] = "{$styling['text']}{$styling['font']->small}"}
{$styling['small_300'] = "margin:0;{$styling['font_family']}{$styling['font']->small}{$styling['color']['300']}"}
{$styling['link'] = "margin:0;text-decoration:none;{$styling['color']['secondary']}{$styling['font_family']}"}


{* Styling layout *}
{$styling['rawPadding'] = 18}
{$styling['rawPaddingSmall'] = 12}
{$styling['rawPaddingTiny'] = 6}
{$styling['padding'] = "padding: {$styling['rawPadding']}px;"}
{$styling['paddingSmall'] = "padding: {$styling['rawPaddingSmall']}px;"}
{$styling['paddingTiny'] = "padding: {$styling['rawPaddingTiny']}px;"}
{$styling['hr'] = "height:0;border-top: 1px solid {$styling['rawColors']['100']};margin:8px 0 8px;"}


{* Wrap up styling into $css *}
{assign var="css" value=(object)$styling scope=global}
{/strip}