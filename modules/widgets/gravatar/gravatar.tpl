{*

# Description
Gravatar widget. A widget is a small helper template, with some functionality.
Get either a Gravatar URL or complete image tag for a specified email address.


## Date last modified
2014-08-01


## Resource
+ [Gravatar dokumentation](http://gravatar.com/site/implement/images/php/)


## Primary variables
+ $widgetSettings   - A Array() of widgetSettings for the avatar
+ $email            - The email address


### widgetSettings
+ email             - The email address
+ size              - Size in pixels, defaults to 80px [ 1 - 2048 ]
+ fallback          - Fallback imageset to use [ 404 | mm | identicon | monsterid | wavatar ]
+ rating            - Maximum rating (inclusive) [ g | pg | r | x ]
+ attrs             - Array of HTML attributes that will be applied to the element


#### Fallback description
+ 404               - Do not load any image if none is associated with the email hash, instead return an HTTP 404 (File Not Found) response
+ mm                - (mystery-man) a simple, cartoon-style silhouetted outline of a person (does not vary by email hash)
+ identicon         - A geometric pattern based on an email hash
+ monsterid         - A generated 'monster' with different colors, faces, etc
+ wavatar           - Generated faces with differing features and backgrounds
+ retro             - Awesome generated, 8-bit arcade-style pixelated faces
+ blank             - A transparent PNG image (border added to HTML below for demonstration purposes)


#### Rating
+ G                 - Rated gravatar is suitable for display on all websites with any audience type.
+ PG                - Rated gravatars may contain rude gestures, provocatively dressed individuals, the lesser swear words, or mild violence.
+ R                 - Rated gravatars may contain such things as harsh profanity, intense violence, nudity, or hard drug use.
+ X                 - Rated gravatars may contain hardcore sexual imagery or extremely disturbing violence.

 *}

{*** Setup base url for gravatar ***}
{$baseurl = '//www.gravatar.com/avatar/'}

{*** Size in pixels, defaults to 80px [ 1 - 2048 ] ***}
{if !isset($widgetSettings) OR !isset($widgetSettings.size)}
    {$size = 50}
{else}
    {$size = $widgetSettings.size}
{/if}

{*** Fallback imageset to use [ 404 | mm | identicon | monsterid | wavatar ] ***}
{if !isset($widgetSettings) OR !isset($widgetSettings.fallback)}
    {$fallback = 'mm'}
{else}
    {$fallback = $widgetSettings.fallback}
{/if}

{*** Fallback imageset to use [ 404 | mm | identicon | monsterid | wavatar ] ***}
{if !isset($widgetSettings) OR !isset($widgetSettings.rating)}
    {$rating = 'g'}
{else}
    {$rating = $widgetSettings.rating}
{/if}

{*** Array of HTML attributes that will be applied to the element ***}
{if !isset($widgetSettings) OR !isset($widgetSettings.attrs)}
    {$attributes = []}
{else}
    {$attributes = $widgetSettings.attrs}
{/if}

{*** If email is empty, send a empty has and use fallback ***}
{if empty($email)}
    {$emailHash = ""}
{else}
    {$emailHash = md5($email|lower)}
{/if}

{$attributes["src"] = "{$baseurl}{$emailHash}?s={$size}&amp;d={$fallback}&amp;r={$rating}"}
{img useArray=$attributes}
