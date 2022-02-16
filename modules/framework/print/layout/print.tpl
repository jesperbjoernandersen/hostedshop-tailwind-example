{*

# Description
Template for print (invoice pdf)


## Date last modified
2021-05-25

## Primary variables
+ $order                                                                - Entity of orderController
+ $orderCustomer                                                        - Entity of orderCustomerController
+ $orderLine                                                            - Collection of orderLineController
+ $productController                                                    - Instance of productController
+ $tracking                                                             - Entity of trackingMethodController
+ $trackingLine                                                         - Entity of trackingMethodController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}{strip}

{* Order Customer entity *}
{entity controller=orderCustomer assign=orderCustomer orderId=$order->Id}

{* Order Lines collection *}
{collection controller=orderLine assign=orderLine orderId=$order->Id repay=false}

{controller assign=productController type=product}

{* Group order collection by class *}
{$orderList = $orderLine->groupByClass()}

{* Function to print out order customer address *}
{function orderCustomerAddress prefix=''}
    {$orderCustomer = (array)$orderCustomer}

    {if $orderCustomer["{$prefix}Company"]}
        <div class="is-bold">{$orderCustomer["{$prefix}Company"]}</div>
    {/if}

    {if $orderCustomer["{$prefix}Firstname"] || $orderCustomer["{$prefix}Lastname"]}
        <div>{$orderCustomer["{$prefix}Firstname"]} {$orderCustomer["{$prefix}Lastname"]}</div>
    {/if}

    {if $orderCustomer["{$prefix}Address"]}
        <div>{$orderCustomer["{$prefix}Address"]}</div>
    {/if}

    {if $orderCustomer["{$prefix}Address2"]}
        <div>{$orderCustomer["{$prefix}Address2"]}</div>
    {/if}

    <div class="has-padding--bottom-tiny">
    {if $orderCustomer["{$prefix}Zip"] || $orderCustomer["{$prefix}City"]}
        {$orderCustomer["{$prefix}Zip"]}{if $orderCustomer["{$prefix}State"] and $orderCustomer["{$prefix}Country"] eq 'US'} {$orderCustomer["{$prefix}State"]}{/if} {$orderCustomer["{$prefix}City"]},
    {/if}

    {entity controller=DeliveryCountry assign=countryLong iso=$orderCustomer["{$prefix}Country"] languageIso=$orderCustomer["{$prefix}Country"]}
    {if $countryLong}
        {$countryLong->Title}
    {else}
        {$orderCustomer["{$prefix}Country"]}
    {/if}
    </div>

    {if empty($prefix)}
    <div class="has-padding--bottom-tiny">
        {if $orderCustomer["{$prefix}Cvr"]}
            <div>{$text.VAT_NR}: {$orderCustomer["{$prefix}Cvr"]}</div>
        {/if}
        {if $orderCustomer["{$prefix}Ean"]}
            <div>{$text.EAN}: {$orderCustomer["{$prefix}Ean"]}</div>
        {/if}
    </div>
    {/if}

    {if $orderCustomer["{$prefix}ExtendedDataExternal"]}
        <div class="has-padding--bottom-tiny">
    {/if}
    {if $orderCustomer["{$prefix}Phone"]}
        <div>{$text.TELEPHONE}: {if $orderCustomer["{$prefix}CountryCode"]}+{$orderCustomer["{$prefix}CountryCode"]}{/if} {$orderCustomer["{$prefix}Phone"]}</div>
    {/if}
    {if $orderCustomer["{$prefix}Mobile"]}
        <div>{$text.MOBILE}: {if $orderCustomer["{$prefix}CountryCode"]}+{$orderCustomer["{$prefix}CountryCode"]}{/if} {$orderCustomer["{$prefix}Mobile"]}</div>
    {/if}
    {if $orderCustomer["{$prefix}Email"]}
        <div>{$orderCustomer["{$prefix}Email"]}</div>
    {/if}
    {if $orderCustomer["{$prefix}ExtendedDataExternal"]}
        </div>
    {/if}

    {if empty($prefix) && $orderCustomer["ExtendedDataExternal"]}
        <div>{$orderCustomer["ExtendedDataExternal"]}</div>
    {/if}
{/function}


{/strip}<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{$print->Subject}</title>
    <style>{includeStyle file='modules/framework/print/layout/print.css'}</style>
    {* Certain languages such as russian and greek cannot be rendered properly to PDF using standard font *}
    {if $request->isPDF && $request->requiresSpecialFont}
    <style>{includeStyle file='modules/framework/print/layout/fontOverwrite.css'}</style>
    {/if}
</head>
<body class="{if isset($smarty.get.debug)}in-debug{/if} {if $request->isPreview}is-preview{/if}">

{if $order && isset($order->Id)}
    <div class="container top has-margin--bottom-small has-margin--top-large">
        <div class="row">
            <div class="col-12">
                <p class="is-center is-bold has-margin--bottom-small">
                    {if $request->isInvoice}
                        {$text.MY_ORDERS_INVOICE}{if isset($order->Invoice)} #{$order->Invoice->Id}{/if}
                    {elseif $request->isCredit}
                        {$text.MY_ORDERS_ORDER_CREDIT}{if isset($order->Invoice)} #{$order->Invoice->Id}{/if}
                    {elseif $request->isReceipt}
                        {$text.MY_ORDERS_RECEIPT}{if isset($order->Invoice)} #{$order->Invoice->Id}{/if}
                    {else}
                        {$text.MY_ORDERS_LINES} #{$order->Id}
                    {/if}
                </p>
            </div>
        </div>

        {include assign=logoCapture file="modules/framework/widgets/logo.tpl" style=false}

        {if empty($template.settings.LOGO_SOURCE_NEGATIVE) and empty($template.settings.LOGO_SOURCE)}
            <div class="header__logo row">
                <div class="col-12">{$logoCapture}</div>
            </div>
        {/if}

        <div class="row header">
            <div class="header__info col-4">
                <h3>{$text.CHECKOUT_RECIEPT}</h3>
                <hr>
                {orderCustomerAddress ordercustomer=$ordercustomer}
                {if $orderCustomer->ShippingFirstname}
                    <br />
                    <h3>{$text.CHECKOUT_DELIVERY_ADRESS}</h3>
                    <hr>
                    {orderCustomerAddress ordercustomer=$ordercustomer prefix="Shipping"}
                {/if}
            </div>

            <div class="header__logo col-8">
                {if !empty($template.settings.LOGO_SOURCE_NEGATIVE) or !empty($template.settings.LOGO_SOURCE)}{$logoCapture}{/if}

                <div class="is-right has-padding--top">
                    {if isset($order->Invoice)}
                    <div class="has-margin--bottom">
                        <p>{if $request->isCredit}{$text.MY_ORDERS_ORDER_CREDIT}{else}{$text.MY_ORDERS_INVOICE_NUMBER}{/if}: {$order->Invoice->Id}</p>
                        <p>{$text.MY_ORDERS_INVOICE_DATE}: {$order->Invoice->Date|date_format:$text.DATE_FORMAT}</p>
                        <p>{$text.MY_ORDERS_INVOICE_DUE_DATE}: {$order->Invoice->DueDate|date_format:$text.DATE_FORMAT}{if $order->Invoice->Paid} {$text.PAID}{/if}</p>
                    </div>
                    {/if}

                    <p>{$text.CHECKOUT_STEP_FIVE_ORDER_NUMBER}: {$order->Id}</p>
                    <p>{$text.CHECKOUT_STEP_FIVE_ORDER_DATE}: {$order->Date|date_format:$text.DATE_FORMAT}</p>

                    <p>
                        {$text.CHECKOUT_STEP_FIVE_ORDER_PAYMENT_METHOD}: {$order->PaymentTitle}
                        {if $order->TransactionNumber}
                             (#{$order->TransactionNumber})
                        {/if}
                    </p>

                    {if $order->CardType}
                        <p>{$text.CHECKOUT_PAYMENT_FORM_CARD_TYPE}: {$order->CardType}</p>
                    {/if}

                    <p>{$text.MY_ORDERS_STATUS}: {translation id=$order->Status module='order_status_code' title='title'}</p>

                    {if !empty($order->DeliveryTime) and $order->DeliveryTime != '0000-00-00 00:00:00'}
                        <p>{$text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}: {$order->DeliveryTime|date_format:$text.DATE_FORMAT_SMARTY}</p>
                    {/if}

                    {if $order->ServiceType}
                        {* Service type entity *}
                        {entity controller=trackingMethod id=$order->ServiceType assign=tracking}
                    {/if}

                    {if $order->TrackingCode}
                    <div class="has-padding--top">
                        {$trackings = explode(';', $order->TrackingCode)}

                        <p class="p">{$text.MY_ORDERS_TRACKING}:</p>
                        <p class="p">
                        {foreach $trackings as $trackingCode}
                            {if $trackingCode}
                                {if $order->ServiceType && $order->ServiceType !== 'normal'}
                                    <a href="{$tracking->getTrackingUrl($trackingCode)}" target="_blank" rel="noopener" style="margin-bottom:3px;line-height:16px;">
                                    {if !$request->isPDF}
                                        <img style="vertical-align: middle;" src="{"/_design/common/img/icons/delivery/{$tracking->Icon->Filename}"|solutionPath}" alt="{$tracking->Title|escape:'html'}">&nbsp;
                                    {/if}

                                    {$tracking->Title}:&nbsp;{$trackingCode}
                                    </a>
                                {else}
                                    {$trackingCode}<br />
                                {/if}
                            {/if}
                        {/foreach}
                        </p>
                    </div>
                    {/if}

                    {if $order->ReferenceNumber}
                    <div class="has-padding--top">
                        <p>{$text.MY_ORDERS_REFERENCE_NUMBER}: {$order->ReferenceNumber}</p>
                    </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>

    <div class="container order-info has-margin--bottom">
        <div class="row">
            <div class="col-12">
                {if $top && !empty($top)}
                    <hr>
                    <div class="order-text order-text--top">{$top}</div>
                {/if}
                <hr>
            </div>
        </div>
    </div>

    <div class="container order-header has-padding--bottom-tiny">
        <div class="row">
            <div class="col-12">
                <div class="has-margin--bottom-small">
                    <h3>{$text.MY_ORDERS_LINES}</h3>
                </div>

                <table class="order-header__table table--full {if $request->showPrice}order-header__table--has-price{/if}">
                    <thead>
                        <tr>
                            <td class="order-header__table-column order-header__table--product">
                                <div class="is-bold has-padding--bottom-tiny">{$text.CART_PRODUCTS}</div>
                            </td>
                            <td class="order-header__table-column order-header__table--note">
                                <div class="is-bold has-padding--bottom-tiny">{$text.CART_NOTE}</div>
                            </td>
                            <td class="order-header__table-column order-header__table--price">
                                <div class="is-bold has-padding--bottom-tiny">
                                    {if $request->showPrice}
                                        {$text.CART_PRICE}
                                    {/if}
                                    {if $request->isPackage}
                                        &nbsp;
                                    {/if}
                                </div>
                            </td>
                            <td class="order-header__table-column order-header__table--count">
                                <div class="is-bold has-padding--bottom-tiny{if !$request->showPrice} is-right{/if}">{$text.CART_COUNT}</div>
                            </td>
                            {if $request->showPrice}
                            <td class="order-header__table-column order-header__table--total">
                                <div class="is-bold has-padding--bottom-tiny has-padding--right-tiny is-right">{$text.CART_PRICE_ALL}</div>
                            </td>
                            {/if}
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    {foreach $orderList.CollectionOrderLine as $line}
        {$item_link = null}
        {if $line->Type != 'wrapping' and $line->Type != 'sale'}
            {$item_link = "{$general.domain}{$productController->link($line->ProductId)}"}
        {/if}


        <div class="container order-line{if $line@last} order-line--last{else} has-padding--bottom-tiny{/if}">
            <div class="row">
                <div class="col-12">
                    <table class="order-line__table table--full {if $request->showPrice}order-line__table--has-price{/if}">
                        <tbody>
                            <tr>
                                <td class="order-line__table-column order-line__table--product has-padding--right-tiny" valign="top">
                                    <table class="table--full table--reset table--fluid">
                                        <tbody>
                                            <tr>
                                                {if $line->ProductId && !in_array($line->Type, ['wrapping','sale'])}
                                                    {$image = null}
                                                    {if ($settings.module_shop_order_picklist_picture && $request->isPackage) or
                                                        ($settings.module_shop_order_note_picture && $request->isOrder)}

                                                        {$imageSize = 40}
                                                        {if $line->VariantId}
                                                            {entity assign=image controller=files type=variant productId=$line->ProductId variantId=$line->VariantId}
                                                        {/if}
                                                        {if !$image}
                                                            {entity assign=image controller=files type=product productId=$line->ProductId}
                                                        {/if}

                                                        {if $image}
                                                            {$imageSrc = $image->thumbnail($imageSize,$imageSize, true)}
                                                            <td style="height:{$imageSize}px;width:{$imageSize}px;" class="order-line__table-column order-line__table--image" valign="top">
                                                                <img style="width:{$imageSize}px;height:{$imageSize}px;" src="{if $request->isPDF}{$imageSrc|pdfPath}{else}{$imageSrc|solutionPath}{/if}" />
                                                            </td>
                                                        {/if}
                                                    {/if}
                                                {/if}
                                                <td valign="top" {if $image}class="has-padding--left-tiny"{/if}>
                                                    <div class="small is-bold">{$line->ProductTitle}{if $line->VariantTitle} {$line->VariantTitle}{/if}</div>

                                                    {if $line->PacketTitle}
                                                        <div class="small">{$line->PacketTitle}</div>
                                                    {/if}

                                                    {if $line->AdditionalTitle}
                                                        <div class="small">{$line->AdditionalTitle}</div>
                                                    {/if}

                                                    {if $line->ItemNumber && $settings.shop_product_number eq true}
                                                        <div class="small">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER} {$line->ItemNumber}</div>
                                                    {/if}

                                                    {if $line->SupplierItemNumber && $request->isPackage}
                                                        <div class="small">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER_SUPPLIER}: {$line->SupplierItemNumber}</div>
                                                    {/if}

                                                    {if $line->WrappingText or $line->WrappingFrom}
                                                        {if $line->WrappingText}
                                                            <div class="small">{$text.CHECKOUT_STEP_THREE_NOTE}: {$line->WrappingText}</div>
                                                        {/if}
                                                        {if $line->WrappingFrom}
                                                            <div class="small">{$text.CHECKOUT_STEP_THREE_NOTE_FROM}: {$line->WrappingFrom}</div>
                                                        {/if}
                                                    {/if}

                                                    {if $line->CouponTo || $line->CouponText || $line->CouponCode}
                                                        {if $line->CouponTo}
                                                            <div class="small">{$text.GIFT_CARD_NAME}: {$line->CouponTo}</div>
                                                        {/if}
                                                        {if $line->CouponText}
                                                            <div class="small">{$text.GIFT_CARD_MESSAGE}: {$line->CouponText}</div>
                                                        {/if}
                                                        {if $line->CouponCode}
                                                            <div class="small">{$text.GIFT_CARD_CODE}: {$line->CouponCode}</div>
                                                        {/if}
                                                    {/if}
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>

                                {* 3 = padding left tiny *}
                                <td class="order-line__table-column order-line__table--note has-padding--right-tiny" valign="top">
                                    <div class="has-padding--bottom-tiny">
                                        {if $line->DeliveryTime && $settings.shop_product_delivery_time eq true}
                                            <div class="small">{$line->DeliveryTime}</div>
                                        {/if}

                                        {if $line->Status}
                                            <div class="small">{$text.MY_ORDERS_STATUS}: {translation id=$line->Status module='order_status_code' title='title'}</div>
                                        {/if}
                                    </div>

                                    {if isset($line->CouponTo)}
                                        <div class="small">{$text.GIFT_CARD_NAME}: {$line->CouponTo}</div>
                                        {if isset($line->CouponCode)}<div class="small">{$text.GIFT_CARD_CODE}: {$line->CouponCode}</div>{/if}
                                    {/if}

                                    {if $line->Weight && $settings.shop_product_weight eq true}
                                        <div class="small">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT}: {$line->Weight|formatNumber} {$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}</div>
                                    {/if}

                                    {if $line->ExtendedDataExternal}
                                        {foreach $line->ExtendedDataExternal as $extendedDataType}
                                        <div class="small">
                                            <span>{$extendedDataType->Name}: </span>
                                            <span>{$extendedDataType->Data}</span>
                                        </div>
                                        {/foreach}
                                    {/if}

                                    {* Secondary delivery line *}
                                    {if $line->Address}
                                        <div class="small has-padding--top-tiny">
                                            <div class="is-bold">{$text.CHECKOUT_DELIVERY_TO}</div>
                                            <div>
                                                {if $line->Address->Company}{$line->Address->Company},{/if}
                                                {if $line->Address->Firstname}{$line->Address->Firstname} {$line->Address->Lastname},{/if}
                                                {if $line->Address->Address}{$line->Address->Address}{/if}
                                                {if $line->Address->Zip}{$line->Address->Zip} {$line->Address->City}, {$line->Address->CountryIso}{/if}
                                                ({$line->Address->Amount} {$line->UnitTitle})
                                            </div>

                                            {if $line->Address->Comment}
                                                <div>{$text.CHECKOUT_STEP_TWO_COMMENT}: {$line->Address->Comment}</div>
                                            {/if}

                                            {if $line->Address->DeliveryDate}
                                            <div>{$text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}: {$line->Address->DeliveryDate|date_format:$text.DATE_FORMAT} {$line->Address->DeliveryTime}</div>
                                            {/if}
                                        </div>
                                    {/if}

                                    {if $line->DeliveryId}
                                        <div class="small">{$text.CHECKOUT_STEP_TWO}:&nbsp;{translation module=delivery_method title=title id=$line->DeliveryId}</div>
                                    {/if}
                                    {if $line->ServiceType}
                                        {* Service type entity *}
                                        {entity controller=trackingMethod id=$line->ServiceType assign=trackingLine}
                                    {/if}
                                    {if $line->TrackingCode}
                                        <div class="small">{$text.MY_ORDERS_TRACKING}: {$line->TrackingCode}</div>
                                    {/if}
                                </td>

                                <td class="order-line__table-column order-line__table--price has-padding--right-tiny" valign="top">
                                    {if $request->showPrice}
                                    <div class="small">
                                        {if $request->isInvoice || $request->isCredit || $request->isOrder}
                                            {if $line->FullPrice == $line->Price}
                                                {$line->Price|formatPriceOrder:$order->Id}
                                            {else}
                                                <del>{$line->FullPrice|formatPriceOrder:$order->Id}</del><br />
                                                {$line->Price|formatPriceOrder:$order->Id}
                                            {/if}
                                        {else}
                                            {$line->Price|formatPriceOrder:$order->Id}
                                        {/if}
                                    </div>

                                    <div class="small">
                                        {if $settings.shop_product_tax_after_price}
                                            {if $currency.hasVat and ($settings.vat_label_advanced eq false or $line->Vat gt 0)}
                                                {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
                                            {else}
                                                {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
                                            {/if}
                                        {/if}
                                    </div>
                                    {/if}
                                    {if $request->isPackage && isset($line->StockLocationTitle)}
                                        <div class="small">{$line->StockLocationTitle}</div>
                                    {/if}
                                </td>
                                <td class="order-line__table-column order-line__table--count{if $request->showPrice} has-padding--right-tiny{/if}" valign="top">
                                    <div {if !$request->showPrice}class="is-right"{/if}>{$line->Amount} {$line->UnitTitle}</div>
                                </td>

                                {if $request->showPrice}
                                <td class="order-line__table-column order-line__table--total is-right" valign="top">
                                    <div class="small">
                                        {($line->Price * $line->Amount)|formatPriceOrder:$order->Id}
                                    </div>
                                    <div class="small">
                                        {if $settings.shop_product_tax_after_price}
                                            {if $currency.hasVat and ($settings.vat_label_advanced eq false or $line->Vat gt 0)}
                                                {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
                                            {else}
                                                {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
                                            {/if}
                                        {/if}
                                    </div>
                                </td>
                                {/if}
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    {/foreach}

    <div class="container order-footer has-margin--bottom">
        <div class="row">
            <div class="col-12">
                <div class="has-padding--top-tiny has-padding--bottom-tiny"><hr class="has-no-margin"></div>
            </div>
        </div>
        {if !$request->showPrice}
            {if isset($orderList['CollectionOrderDeliveryLine'])}
            <div class="row">
                <div class="col-12 color--300">
                    <p>{$text.DELIVERY}: {$orderList.CollectionOrderDeliveryLine.0->Title}</p>
                </div>
            </div>
            {/if}
        {else}
            {if isset($orderList['CollectionOrderDeliveryLine'])}
            <div class="row">
                <div class="col-6 color--300">
                    <p>{$text.DELIVERY}: {$orderList.CollectionOrderDeliveryLine.0->Title}</p>
                </div>
                <div class="col-6 color--300 is-right">
                    <p>{$orderList.CollectionOrderDeliveryLine.0->Price|formatPriceOrder:$order->Id}</p>
                </div>
            </div>
            {/if}

            {if isset($orderList['CollectionOrderSubTotalLine'])}
            <div class="row">
                <div class="col-6 color--300">
                    <p>{$text.CART_PRICE_SUM}</p>
                </div>
                <div class="col-6 color--300 is-right">
                    <p>{$orderList.CollectionOrderSubTotalLine.0->Price|formatPriceOrder:$order->Id}</p>
                </div>
            </div>
            {/if}

            {if isset($orderList['CollectionOrderVatTotalLine'])}
            <div class="row">
                <div class="col-6 color--300">
                    <p>{if $currency.hasVat}{$text.CART_VAT_INCLUSIVE}{else}{$text.CART_VAT_EXCLUSIVE}{/if}</p>
                </div>
                <div class="col-6 color--300 is-right">
                    <p>{$orderList.CollectionOrderVatTotalLine.0->Price|formatPriceOrder:$order->Id}</p>
                </div>
            </div>
            {/if}

            {if isset($orderList['CollectionOrderPaymentLine']) && $orderList.CollectionOrderPaymentLine.0->Price != 0}
            <div class="row">
                <div class="col-6 p">
                    <p>{$text.MY_ORDERS_FEE}</p>
                </div>
                <div class="col-6 p is-right">
                    <p>{$orderList.CollectionOrderPaymentLine.0->Price|formatPriceOrder:$order->Id}</p>
                </div>
            </div>
            {/if}
            <div class="row">
                <div class="col-12">
                    <div class="has-padding--top-tiny has-padding--bottom-tiny">
                        <hr class="has-no-margin">
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-6">
                    <p><b>{$text.CART_TOTAL}</b></p>
                </div>
                <div class="col-6 is-right">
                    <p><b>{$orderList.CollectionOrderTotalLine.0->Price|formatPriceOrder:$order->Id}</b></p>
                </div>
            </div>
        {/if}
    </div>

    {if $order->ExternalComment or $order->CustomerComment or $order->DeliveryComment}
    <div class="container order-extra has-margin--bottom">
        <div class="row">
            <div class="col-12">
                {if $order->ExternalComment}
                <div class="has-margin--bottom-small">
                    <h3>{$text.MY_ORDERS_SHOP_COMMENT}</h3>
                    <hr>
                    {$order->ExternalComment}
                    <br>
                </div>
                {/if}
                {if $order->CustomerComment}
                <div class="has-margin--bottom-small">
                    <h3>{$text.MY_ORDERS_CUSTOMER_COMMENT}</h3>
                    <hr>
                    {$order->CustomerComment}
                    <br>
                </div>
                {/if}
                {if $order->DeliveryComment}
                <div class="has-margin--bottom-small">
                    <h3>{$text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY}</h3>
                    <hr>
                    {$order->DeliveryComment}
                    <br>
                </div>
                {/if}
            </div>
        </div>
    </div>
    {/if}

    {if $bottom && !empty($bottom)}
        <div class="container order-text order-text--bottom">
            <div class="row">
                <div class="col-12">{$bottom}</div>
            </div>
        </div>
    {/if}

    <div class="container footer has-margin--bottom">
        <div class="row">
            <div class="col-12 has-padding--top-small has-padding--bottom-small"><hr></div>
        </div>

        <div class="row">
            <div class="footer__contact col-12">
                <center>
                    <div class="has-padding--bottom-tiny small">{strip}
                        {$hasPrevious = false}
                        {if $contactdata.name}
                            {$hasPrevious = true}
                            <span class="is-bold"><b>{$contactdata.name}</b></span>
                        {/if}
                        {if $contactdata.company}
                            {if $hasPrevious} - {/if}{$contactdata.company}
                            {$hasPrevious = true}
                        {/if}
                        {if $contactdata.address}
                            {if $hasPrevious} - {/if}{$contactdata.address}
                            {$hasPrevious = true}
                        {/if}

                        {if $contactdata.zipcode || $contactdata.city}
                            {if $hasPrevious} - {/if}
                            {if $contactdata.zipcode}{$contactdata.zipcode} {/if}
                            {if $contactdata.city} {$contactdata.city} {/if}
                            {$hasPrevious = true}
                        {/if}

                        {if $contactdata.country}{if $hasPrevious} - {/if}{$contactdata.country}{/if}
                    {/strip}</div>
                    <div class="has-padding--bottom-tiny small">
                        {$hasPrevious = false}
                        {if $contactdata.phone}
                            {$text.TELEPHONE}: {$contactdata.phone}
                            {$hasPrevious = true}
                        {/if}
                        {if $contactdata.mobilephone}
                            {if $hasPrevious} - {/if}{$text.MOBILE}: {$contactdata.mobilephone}
                            {$hasPrevious = true}
                        {/if}
                        {if $contactdata.email}
                            {if $hasPrevious} - {/if}{$contactdata.email}
                            {$hasPrevious = true}
                        {/if}
                        {if $contactdata.domain}
                            {if $hasPrevious} - {/if}{$contactdata.domain}
                            {$hasPrevious = true}
                        {/if}
                        {if $contactdata.fax}
                            {if $hasPrevious} - {/if}{$text.FAX}: {$contactdata.fax}
                        {/if}
                    </div>
                    <div class="small">
                        {$hasPrevious = false}
                        {if $contactdata.vatnumber}
                            {$text.VAT_NR}: {$contactdata.vatnumber}
                            {$hasPrevious = true}
                        {/if}
                        {if $contactdata.bankinfo}
                            {if $hasPrevious} - {/if}{$text.BANK_DETAILS}: {$contactdata.bankinfo}
                        {/if}
                    </div>
                </center>
            </div>
        </div>
    </div>
{/if}
</body>
</html>
