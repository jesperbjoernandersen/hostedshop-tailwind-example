{*

# Description
Overides the square aspect of the lazyload placeholder 


## Date last modified
2020-10-12


## Primary variables
+ $height                                                             - Placeholder height
+ $width                                                              - Placeholder width
+ $selector                                                           - Specific CSS selector to target placeholder-wrapper

## Partials (templates)
No extra templates required for this template

*}

{if isset($height) && isset($width)}
    {$width  = (int)$width}
    {$height = (int)$height} 
    {$aspect = ($height / $width) * 100}
    {strip}
        <style>
            {$selector} .placeholder-wrapper > .placeholder {
                padding-top: {$aspect|cat:"%"};
            }
            {$selector} .placeholder-wrapper {
                max-width: {$width|cat:"px"};
            }
        </style>
    {/strip}
{/if}