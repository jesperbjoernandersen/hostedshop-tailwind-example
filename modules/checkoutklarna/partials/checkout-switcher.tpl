{*

# Description
Checkout template partial for Checkout switcher between Klarna Checkout and Checkout
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).

## Resource
+ [jsRender Template](http://www.jsviews.com/#jsrender)


## Date last modified
2022-01-24


## Primary variables
+ $text                                                     			- Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{addScript src='modules/checkoutklarna/includes/js/checkoutswitcher.min.js'}
{addLink src='modules/checkoutklarna/includes/css/checkoutswitcher.min.css'}

{literal}
<script id="CheckoutSwitcherImages" type="text/x-jsrender">
    <li class="m-checkout-switcher__image-wrap">{{:}}</li>
</script>
{/literal}

{literal}
<script id="CheckoutSwitcherSVG" type="text/x-jsrender">
<div class="paymentMethodLinkGraphics">
    <svg viewBox="0 0 22 39" xmlns="http://www.w3.org/2000/svg">
        <g stroke-width="2">
            <path stroke="#707070" d="m1 1 19.5 18.5"/>
            <path stroke="#707070" d="m1 38 19.5-18.5"/>
        </g>
    </svg>
</div>
</script>
{/literal}

{literal}
<script id="CheckoutSwitcher" type="text/x-jsrender">
<a href="{{:klarna.link}}" class="w-checkout-switcher w-checkout-switcher--paymentmethod is-block">
    <div class="paymentMethodTitle">
        <span class="l-payment-method-title-text">{{:title}}{{if subtitle}}: <small>{{:subtitle}}</small>{{/if}}</span>
    </div>
    {{if priceFixed || pricePercentage}}
    <div class="paymentMethodFee">
        {{if priceFixed}}<span class="paymentMethodFeeFixed is-block">{{:priceFixed}}</span>{{/if}}
        {{if pricePercentage}}<span class="paymentMethodFeePercentage is-block">{{:pricePercentage}}%</span>{{/if}}
    </div>
    {{/if}}
    <div class="paymentMethodDescription">{{:description}}</div>
    <div class="paymentMethodPaypalIcons"><img src="{{:klarna.asset.normal}}" style="margin:0;" alt="Klarna Checkout"></div>
    {{include tmpl="#CheckoutSwitcherSVG" /}}
</a>
</script>
{/literal}

{literal}
<script id="CheckoutSwitcherKlarna" type="text/x-jsrender">
<a href="{{:link}}" class="w-checkout-switcher w-checkout-switcher--kco-top is-inline-block">
    <ul class="m-checkout-switcher__image-list list-unstyled">
        <li class="m-checkout-switcher__text is-inline-block">{{:text}}</li>
        <li class="m-checkout-switcher__image-wrap m-checkout-switcher__image-wrap--placeholder"><img src='/_design/common/img/blank.gif' style='height:24px;width:34px;'></li>
        <li class="m-checkout-switcher__image-wrap m-checkout-switcher__image-wrap--placeholder"><img src='/_design/common/img/blank.gif' style='height:24px;width:34px;'></li>
        <li class="m-checkout-switcher__image-wrap m-checkout-switcher__image-wrap--placeholder"><img src='/_design/common/img/blank.gif' style='height:24px;width:34px;'></li>
        <li class="m-checkout-switcher__image-wrap m-checkout-switcher__image-wrap--placeholder"><img src='/_design/common/img/blank.gif' style='height:24px;width:34px;'></li>
    </ul>
    {{include tmpl="#CheckoutSwitcherSVG" /}}
</a>
</script>
{/literal}

{literal}
<script id="CheckoutSwitcherTop" type="text/x-jsrender">
<a href="{{:klarna.link}}" class="w-checkout-switcher w-checkout-switcher--checkout-top is-inline-block">
    <div class="paymentMethodKlarna">{{:klarna.linkText}}</div>
    <div class="paymentMethodPaypalIcons"><img src="{{:klarna.asset.normal}}" style="margin:0;" alt="Klarna Checkout"></div>
    {{include tmpl="#CheckoutSwitcherSVG" /}}
</a>
</script>
{/literal}
