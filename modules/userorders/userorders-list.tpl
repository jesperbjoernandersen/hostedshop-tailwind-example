
{*

# Description
Template partial for the User Orders List. Part of the User orders page type.


## Date last modified
2015-08-25


## Primary variables
+ $orders                                                               - Collection of orderController
+ $orderLinesUser                                                       - Collection of orderLineUserController
+ $orderLine                                                            - Collection of orderLineController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/recaptcha/recaptcha.tpl"                            - Recaptcha widget, for blog comments
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}


{* Order collection *}
{collection controller=order assign=orders userId=$user->Id}

{* OrderLines collection for preorder *}
{collection controller=orderLine assign=orderLinesUser userId=$user->Id}

<ul class="nav nav-tabs">
    <li class="active"><a data-toggle="content" href="#tabs-pane1">{$text.MY_ORDERS_HEADLINE}</a></li>
    <li><a data-toggle="content" href="#tabs-pane2">{$text.MY_ORDERS_POPULAR}</a></li>
</ul>

<div class="toggle-content t-panel-clean">
    <div class="pane active" id="tabs-pane1">
        {if $orders->getActualSize() gt 0}
            <div class="panel panel-border">
                <ul class="list-unstyled t-striped">
                    {foreach $orders->getData() as $order}
                        {* Order Lines collection *}
                        {collection controller=orderLine assign=orderLine orderId=$order->Id}
                        {* Group order collection by class *}
                        {$orderList = $orderLine->groupByClass()}

                        <li>
                            <div class="row">
                                <div class="col-s-4 col-m-8 col-l-8 col-xl-16">
                                    <div class="row">
                                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                                            <p>
                                                <span class="is-block">
                                                    <small>{$text.MY_ORDERS_DATE}</small>
                                                </span>
                                                <span>{$order->Date|date_format:$text.DATE_FORMAT}</span>
                                            </p>
                                        </div>
                                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                                            <p>
                                                <span class="is-block">
                                                    <small>{$text.MY_ORDERS_NUMBER}</small>
                                                </span>
                                                <span>{$order->Id}</span>
                                            </p>
                                        </div>
                                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                                            <p>
                                                <span class="is-block">
                                                    <small>{$text.MY_ORDERS_STATUS}</small>
                                                </span>
                                                <span>{$order->StatusText}</span>
                                            </p>
                                        </div>
                                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                                            <p>
                                                <span class="is-block">
                                                    <small>{$text.MY_ORDERS_PRICE}</small>
                                                </span>
                                                <span>{$orderList.CollectionOrderTotalLine.0->Price|formatPriceOrder:$order->Id}</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-s-4 col-m-4 col-l-4 col-xl-8">
                                    <div class="dropdown">
                                        <button class="button button-icon small is-block" data-toggle="dropdown"><i class="fa fa-caret-down fa-fw"></i>{$text.OPTIONS}</button>
                                        <div class="dropdown-menu">
                                            <div class="dropdown-container">
                                                <ul>
                                                    <li><a href="/{$text.MY_ORDERS_LINK}/?order={$order->Id}">{$text.MY_ORDERS_DETAILS_SEE}</a></li>

                                                    {*** Check for invoice file ***}
                                                    {entity assign=invoiceFile controller=files type=invoice id=$order->Id userId=$user->Id}

                                                    {*** If a file exists, link to it ***}
                                                    {if $invoiceFile}
                                                        <li><a target="_blank" rel="noopener" href="{$invoiceFile->getFile()}">{$text.MY_ORDERS_INVOICE}</a></li>

                                                    {*** If a regular invoice exists, link to it ***}
                                                    {elseif $order->Invoice}
                                                        <li><a href="/{$text.MY_ORDERS_LINK}/?order={$order->Id}&amp;invoice={$order->Invoice->Id}">{$text.MY_ORDERS_INVOICE}</a></li>
                                                    {/if}

                                                    <li><a href="/actions/cart/reorder?id={$order->Id}&{csrf type='get'}">{$text.MY_ORDERS_REORDER}</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </li>
                    {/foreach}
                </ul>
            </div>
        {else}
            <span>{$text.MY_ORDERS_NONE}</span>
        {/if}
    </div>

    <div class="pane" id="tabs-pane2">
        {if $orderLinesUser->getActualSize() gt 0}
            <div class="panel panel-border">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-s-4 col-m-2 col-l-2 col-xl-4 is-hidden-s">
                            <span class="h6">{$text.PRODUCT_CATALOG_PRODUCT}</span>
                        </div>
                        <div class="col-s-4 col-m-2 col-l-2 col-xl-4 is-hidden-s">
                            <span class="h6">{$text.CART_COUNT}</span>
                        </div>
                        <div class="col-s-4 col-m-2 col-l-2 col-xl-6 is-hidden-s">
                            <span class="h6">{$text.CART_PRICE}</span>
                        </div>
                        <div class="col-s-4 col-m-4 col-l-4 col-xl-6 is-hidden-s">
                            <span class="h6">{$text.MY_ORDERS_REORDER}</span>
                        </div>
                    </div>
                </div>
                <ul class="list-unstyled t-striped">
                    {$count = 1}
                    {foreach $orderLinesUser->getData() as $line}
                        {if $line->Type != 'wrapping' and $line->Type != 'sale'}
                            <li>
                                <div class="row">
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4">
                                        <p>
                                            <span class="h6">{$count}. {$line->ProductTitle} {$line->VariantTitle}</span>
                                        </p>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-4 is-hidden-s">
                                        <span>{$line->Amount} {$line->UnitTitle}</span>
                                    </div>
                                    <div class="col-s-4 col-m-2 col-l-2 col-xl-6">
                                        <p>
                                            <span>
                                                {* Find the current price for the product / variant of the order line *}
                                                {collection assign=price controller=productPrice productId=$line->ProductId variantId=$line->VariantId}

                                                {$priceData = $price->getData()}
                                                {$priceInterval = array_pop($priceData)}

                                                {$priceInterval->PriceMin|formatPrice}
                                                {if $priceInterval->PriceMin lt $priceInterval->FullPriceMin}
                                                    <del>{$priceInterval->FullPriceMin|formatPrice}</del>
                                                {/if}
                                            </span>
                                        </p>
                                    </div>
                                    <div class="col-s-4 col-m-4 col-l-4 col-xl-6">
                                        <a class="button button-icon small trailing-db-mobile" href="/actions/cart/reorderItem?id={$line->LineId}&{csrf type='get'}"><i class="fa fa-shopping-cart"></i> {$text.MY_ORDERS_REORDER}</a>
                                    </div>
                                </div>
                            </li>

                            {$count = $count + 1}
                        {/if}
                    {/foreach}
                </ul>
            </div>
        {else}
            <p>{$text.MY_ORDERS_NONE}</p>
        {/if}
    </div>
</div>
