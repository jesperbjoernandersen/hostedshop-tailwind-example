{*

# Description
Controller and template for the User Orders page type.


## Date last modified
2015-04-21


## Primary variables
+ $deliveryCountries                                                    - Collection of deliveryCountryController
+ $interestFields                                                       - Collection of interestFieldController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $settings                                                             - Global scope variable containing platform settings
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/order/order.tpl"                                    - Template widget for the User Order Details
+ "/modules/order/order/userorders-list.tpl"                            - Template for User order list

*}

<div class="modules m-user-orders">

    {if isset($smarty.get.order)}
        <header class="page-title">
            <div class="row">
                <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                    <h1>{$page.title}</h1>
                </div>
                <div class="col-s-4 col-m-6 col-l-6 col-xl-12 text-right">
                    <a class="button button-icon trailing-db-mobile" href="/{$Text.MY_ORDERS_LINK}/"><i class="fa fa-fw fa-long-arrow-left"></i>{$Text.BACK}</a>
                    <a class="button-primary button-icon" href="/actions/cart/reorder?id={(int)$smarty.get.order}&{csrf type='get'}"><i class="fa fa-fw fa-shopping-cart"></i>{$Text.MY_ORDERS_REORDER}</a>
                </div>
            </div>
        </header>
    {else}
        <header class="page-title">
            <h1>{$page.title}</h1>
        </header>
    {/if}

    <div class="row">
        <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
            {if isset($smarty.get.order)}
                {if isset($smarty.get.invoice)}
                    {include file='modules/widgets/order/order.tpl' orderId=$smarty.get.order invoiceId=$smarty.get.invoice}
                {else}
                    {include file='modules/widgets/order/order.tpl' orderId=$smarty.get.order}
                {/if}
                <div class="row">
                    <div class="col-s-4 col-m-12 col-l-12 col-xl-24 text-right">
                        <p>
                            <a class="button button-icon" href="/{$Text.MY_ORDERS_LINK}/"><i class="fa fa-fw fa-long-arrow-left"></i>{$Text.BACK}</a>
                            <a class="button-primary button-icon" href="/actions/cart/reorder?id={(int)$smarty.get.order}&{csrf type='get'}"><i class="fa fa-fw fa-shopping-cart"></i>{$Text.MY_ORDERS_REORDER}</a>
                        </p>
                    </div>
                </div>
            {else}
                {include file='modules/userorders/userorders-list.tpl'}
            {/if}
        </div>
    </div>
</div>
