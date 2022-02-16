{*

# Description
Payment icons widget. A widget is a small helper template, with some functionality.


## Date last modified
2020-10-12


## Primary variables
+ $icons                                                    - Shop payment icons


## Partials (templates)
No extra templates required for this template

*}
{paymentIcons assign=icons}
{$imageWidth = 34}
{$imageHeight = 24}

{if $icons->getActualSize() gt 0}
    {include file="modules/widgets/image/placeholder-aspect.tpl" 
      width=$imageWidth 
      height=$imageHeight
      selector=":not(.ielt9) .payment-icons"}

    <div class="payment-icons">
    {foreach $icons->getData() as $icon}
        <span class="payments-icon payments-icon-{$icon@index} placeholder-wrapper is-inline-block">
          <span class="placeholder"></span>
          {img alt="{$icon->Title}" title="{$icon->Title}" src="{$template.cdn}{$icon->RelativeFile}"}
        </span>
    {/foreach}
    </div>
{/if}
