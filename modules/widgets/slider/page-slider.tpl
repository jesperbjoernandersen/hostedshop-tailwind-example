{*

# Description
Widget for the general picture element slider.


## Supplied variables
+ $crop       - Possible values: false, true, "fill", "white", default: "fill"


## Date last modified
2015-03-13

*}

{* Picture element settings *}
{controller type=page assign=pageController}
{$peSettings = $pageController->pictureElementSettings($page.id)}

{* Default height *}
{$height = 440}
{if !empty($peSettings["height"])}
    {$height = $peSettings["height"]}
{/if}

{* Default time between slides *}
{$cycleSpeed = 5000}
{if !empty($peSettings["cycleSpeed"])}
    {$cycleSpeed = $peSettings["cycleSpeed"]}
{/if}

{* Default setting for random pictures *}
{$cycleRandom = false}
{if !empty($peSettings["sortingOrder"]) and $peSettings["sortingOrder"] == "random"}
    {$cycleRandom = true}
{/if}

{* Default setting for cropping *}
{if !isset($crop)}
    {if !empty($template.settings.DESIGN_IMAGE_BACKGROUND_COLOR)}
        {$crop = $template.settings.DESIGN_IMAGE_BACKGROUND_COLOR}
    {else}
        {$crop = "fill"}
    {/if}
{/if}

{$sliderSettings = [
    "slider"    => "single",
    "theme"     => "hero-slider-theme",
    "pagination"=> "true",
    "nav"       => "true",
    "nav-text"  => "false",
    "width"     => 1240,
    "height"    => $height,
    "crop"      => $crop,
    "speed"     => $cycleSpeed,
    "random"    => $cycleRandom
]}

{include file="modules/widgets/slider/slider.tpl" widgetSettings=$sliderSettings type=page id=$page.id}
