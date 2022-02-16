{*

# Description
Controller for the email templates.

The controller uses $request, $user and $page to decided which type of collection to show.


## Date last modified
2020-10-05


## Primary variables
+ $request                                                              - Global scope variable containing request information
+ $user                                                                 - Global scope variable containing user information
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

*}

{* ******************************** *
    HELPER FUNCTIONS DEFINED FIRST
  ********************************* *}

{* Function to print out order customer address *}
{function orderCustomerAddress prefix=''}{strip}
    {$orderCustomer = (array)$orderCustomer}

    {if $orderCustomer["{$prefix}Company"]}
        {$orderCustomer["{$prefix}Company"]} <br />
    {/if}

    {if $orderCustomer["{$prefix}Firstname"] || $orderCustomer["{$prefix}Lastname"]}
        {$orderCustomer["{$prefix}Firstname"]} {$orderCustomer["{$prefix}Lastname"]} <br />
    {/if}

    {if $orderCustomer["{$prefix}Address"]}
        {$orderCustomer["{$prefix}Address"]} <br />
    {/if}

    {if $orderCustomer["{$prefix}Address2"]}
        {$orderCustomer["{$prefix}Address2"]} <br />
    {/if}

    {if $orderCustomer["{$prefix}Zip"] || $orderCustomer["{$prefix}City"]}
        {$orderCustomer["{$prefix}Zip"]}{if $orderCustomer["{$prefix}State"] and $orderCustomer["{$prefix}Country"] eq 'US'} {$orderCustomer["{$prefix}State"]}{/if}{if $orderCustomer["{$prefix}City"]} {$orderCustomer["{$prefix}City"]}, {/if}
    {/if}

    {entity controller=DeliveryCountry assign=countryLong iso=$orderCustomer["{$prefix}Country"] languageIso=$orderCustomer["{$prefix}Country"]}
    {if $countryLong}
        {$countryLong->Title} <br />
    {else}
        {if $orderCustomer["{$prefix}Country"]}{$orderCustomer["{$prefix}Country"]} <br />{/if}
    {/if}

    {if empty($prefix)}
        {if $orderCustomer["{$prefix}Cvr"]}
            {$text.VAT_NR}: {$orderCustomer["{$prefix}Cvr"]} <br />
        {/if}

        {if $orderCustomer["{$prefix}Ean"]}
            {$text.EAN}: {$orderCustomer["{$prefix}Ean"]} <br />
        {/if}
    {/if}

    {if $orderCustomer["{$prefix}Phone"]}
        {$text.TELEPHONE}: {if $orderCustomer["{$prefix}CountryCode"]}+{$orderCustomer["{$prefix}CountryCode"]}{/if} {$orderCustomer["{$prefix}Phone"]} <br />
    {/if}

    {if $orderCustomer["{$prefix}Mobile"]}
        {$text.MOBILE}: {if $orderCustomer["{$prefix}CountryCode"]}+{$orderCustomer["{$prefix}CountryCode"]}{/if} {$orderCustomer["{$prefix}Mobile"]} <br />
    {/if}

    {if $orderCustomer["{$prefix}Email"]}
        {$orderCustomer["{$prefix}Email"]}<br />
    {/if}

    {if empty($prefix) && $orderCustomer["ExtendedDataExternal"]}
        {$orderCustomer["{$prefix}ExtendedDataExternal"]}<br />
    {/if}
{/strip}{/function}

{if $order && isset($order->Id)}
    {* Order Customer entity *}
    {entity controller=orderCustomer assign=orderCustomer orderId=$order->Id}

    {* Order Lines collection *}
    {collection controller=orderLine assign=orderLine orderId=$order->Id repay=false}

    {controller assign=productController type=product}

    {* Group order collection by class *}
    {$orderList = $orderLine->groupByClass()}

    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
            <tr>
                <td valign="top" style="padding:0 0 {$css->rawPadding*2}px 0;">
                    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td valign="top" align="left" style="{$css->h2}" colspan="2">
                                    <h3 style="{$css->h3}padding-bottom:{$css->rawPaddingTiny}px;">
                                    {if isset($order->Invoice)}
                                        {$text.MY_ORDERS_INVOICE}
                                    {elseif $request->isReceipt}
                                        {$text.MY_ORDERS_RECEIPT}
                                    {else}
                                        {$text.MY_ORDERS_LINES}
                                    {/if}
                                    </h3>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" align="left" width="50%" style="{$css->p};">
                                    {if isset($order->Invoice)}
                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                                            <tr><td valign="top" align="left" width="50%" style="{$css->p};">{if $request->isReceipt}{$text.MY_ORDERS_RECEIPT_NUMBER}{else}{$text.MY_ORDERS_INVOICE_NUMBER}{/if}: {$order->Invoice->Id}</td></tr>
                                            {if !$request->isReceipt}
                                                <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.MY_ORDERS_INVOICE_DATE}: {$order->Invoice->Date|date_format:$text.DATE_FORMAT}</td></tr>
                                                <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.MY_ORDERS_INVOICE_DUE_DATE}: {$order->Invoice->DueDate|date_format:$text.DATE_FORMAT}{if $order->Invoice->Paid} {$text.PAID}{/if}</td></tr>
                                                <tr><td valign="top" align="left" width="50%" style="{$css->p};"><hr style="{$css->hr}"></td></tr>
                                            {/if}
                                        </table>
                                    {/if}

                                    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                                        <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.CHECKOUT_STEP_FIVE_ORDER_NUMBER}: {$order->Id}</td></tr>
                                        <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.CHECKOUT_STEP_FIVE_ORDER_DATE}: {$order->Date|date_format:$text.DATE_FORMAT}</td></tr>
                                        <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.CHECKOUT_STEP_FIVE_ORDER_PAYMENT_METHOD}: {$order->PaymentTitle}
                                        {if $order->TransactionNumber}
                                             (#{$order->TransactionNumber})
                                        {/if}
                                        </td></tr>

                                        {if $order->CardType}
                                            <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.CHECKOUT_PAYMENT_FORM_CARD_TYPE}: {$order->CardType}</td></tr>
                                        {/if}

                                        <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.MY_ORDERS_STATUS}: {translation id=$order->Status module='order_status_code' title='title'}</td></tr>
                                    {if !empty($order->DeliveryTime) and $order->DeliveryTime != '0000-00-00 00:00:00'}
                                        <tr><td valign="top" align="left" width="50%" style="{$css->p};">{$text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}: {$order->DeliveryTime|date_format:$text.DATE_FORMAT_SMARTY}</td></tr>
                                    {/if}
                                    </table>
                                </td>
                                <td valign="top" align="left" width="50%" style="{$css->p}; padding-left:{$css->rawPadding}px;">
                                    {if $order->ServiceType}
                                        {* Service type entity *}
                                        {entity controller=trackingMethod id=$order->ServiceType assign=tracking}
                                    {/if}

                                    {if $order->TrackingCode}
                                        {$trackings = explode(';', $order->TrackingCode)}

                                        {$text.MY_ORDERS_TRACKING}:<br />
                                        {foreach $trackings as $trackingCode}
                                            {if $trackingCode}
                                                {if $order->ServiceType && $order->ServiceType !== 'normal'}
                                                    <img style="vertical-align: text-bottom;" src="{"/_design/common/img/icons/delivery/{$tracking->Icon->Filename}"|solutionPath}" alt="{$tracking->Title}">&nbsp;<span style="{$css->small}">{$tracking->Title}:</span>&nbsp;<a href="{$tracking->getTrackingUrl($trackingCode)}" target="_blank" rel="noopener" style="{$css->small}{$css->link}">{$trackingCode}</a>
                                                {else}
                                                    {$trackingCode}
                                                {/if}
                                                <br />
                                            {/if}
                                        {/foreach}
                                    {/if}

                                    {if $order->ReferenceNumber}
                                        {$text.MY_ORDERS_REFERENCE_NUMBER}: {$order->ReferenceNumber}<br />
                                    {/if}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>

            {if $orderLine->getActualSize() gt 0 && isset($orderList['CollectionOrderLine'])}
            <tr>
                <td valign="top">
                    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                        <tbody>
                            <tr>
                                <td valign="top" align="left" style="{$css->p};padding-bottom:{$css->rawPaddingTiny}px;">
                                    <h3 style="{$css->h3}">{$text.CART_PRODUCTS}</h3>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    {foreach $orderList.CollectionOrderLine as $line}
                        {$item_link = null}
                        {if !in_array($line->Type, ['wrapping','sale'])}
                            {$item_link = "{$general.domain}{$productController->link($line->ProductId)}"}
                        {/if}

                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                            <tbody>
                                <tr>
                                    {$image = null}
                                    {if $line->ProductId && !in_array($line->Type, ['wrapping','sale'])}
                                        {$imageSize = 80}
                                        {if $line->VariantId}
                                            {entity assign=image controller=files type=variant productId=$line->ProductId variantId=$line->VariantId}
                                        {/if}
                                        {if !$image}
                                            {entity assign=image controller=files type=product productId=$line->ProductId}
                                        {/if}

                                        {$productTitle = "{$line->ProductTitle}{if $line->VariantTitle} - {$line->VariantTitle}{/if}"}

                                        {if $image}
                                            <td valign="top" align="center" width="{$css->rawPaddingSmall + $imageSize}" style="text-align:center">
                                                {if $item_link}<a href="{$item_link}" title="{$productTitle|escape:"html"}">{/if}
                                                    <img src="{$image->thumbnail($imageSize,$imageSize)|solutionPath}" alt="{$productTitle|escape:"html"}">
                                                {if $item_link}</a>{/if}
                                            </td>
                                        {/if}
                                    {/if}
                                    <td valign="top">
                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                                            <tbody>
                                                <tr>
                                                    <td valign="top" align="left">
                                                        {if $item_link}
                                                            <a href="{$item_link}" style="text-decoration:none;" title="{$productTitle|escape:"html"}">
                                                        {/if}
                                                        <span style="{$css->bold}{$css->p}">
                                                            {$line->ProductTitle} {if $line->VariantTitle} {$line->VariantTitle}{/if}
                                                        </span>
                                                        {if $item_link}
                                                            </a>
                                                        {/if}
                                                    </td>
                                                    <td valign="top" align="right" style="{$css->p}">
                                                      {$price = $line->Price * $line->Amount}
                                                      {$fullPrice = $line->FullPrice * $line->Amount}
                                                      {if $fullPrice != $price}
                                                        <del style="color: #757575;">{($fullPrice)|formatPriceOrder:$order->Id|replace:" ":"&nbsp;"}</del>
                                                      {/if}
                                                      <span>{($price)|formatPriceOrder:$order->Id|replace:" ":"&nbsp;"}</span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                                            <tbody>
                                                <tr>
                                                    <td valign="top" align="left">
                                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                                                            <tbody>
                                                                <tr><td valign="top" style="{$css->small_300}">{$text.CART_COUNT}: {$line->Amount} {$line->UnitTitle}</td></tr>

                                                                {if $line->AdditionalTitle}
                                                                <tr><td valign="top" style="{$css->small_300}">{$line->AdditionalTitle}</td></tr>
                                                                {/if}

                                                                {if $line->PacketTitle}
                                                                <tr><td valign="top" style="{$css->small_300}">{$line->PacketTitle}</td></tr>
                                                                {/if}

                                                                {if $line->ItemNumber && $settings.shop_product_number eq true}
                                                                <tr><td valign="top" style="{$css->small_300}">{$text.PRODUCT_CATALOG_PRODUCT_NUMBER} {$line->ItemNumber}</td></tr>
                                                                {/if}

                                                                {if isset($line->CouponTo)}
                                                                <tr><td valign="top" style="{$css->small_300}">{$text.GIFT_CARD_NAME}: {$line->CouponTo}</td></tr>
                                                                    {if isset($line->CouponText)}
                                                                        <tr><td valign="top" style="{$css->small_300}">{$text.GIFT_CARD_MESSAGE}: {$line->CouponText}</td></tr>
                                                                    {/if}
                                                                    {if isset($line->CouponCode)}
                                                                    <tr><td valign="top" style="{$css->small_300}">{$text.GIFT_CARD_CODE}: {$line->CouponCode}</td></tr>
                                                                    {/if}
                                                                {/if}

                                                                {if isset($line->FileDownloadLink)}
                                                                <tr><td valign="top" style="{$css->small_300}"><a style="{$css->link}" href="{$general.domain}/{$text.FILE_SALE_LINK}/{$line->FileDownloadLink}" target="_blank" rel="noopener">{$text.FILE_SALE_MENU}</a></td></tr>
                                                                {/if}

                                                                {if $line->Weight && $settings.shop_product_weight eq true}
                                                                <tr><td valign="top" style="{$css->small_300}">{$text.PRODUCT_CATALOG_PRODUCT_WEIGHT}: {$line->Weight|formatNumber} {$text.PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT}</td></tr>
                                                                {/if}

                                                                {* Secondary delivery line *}
                                                                {if $line->Address}
                                                                <tr>
                                                                    <td valign="top">
                                                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                                                                            <tbody>
                                                                                <tr><td valign="top" style="{$css->small_300}{$css->bold}">{$text.CHECKOUT_DELIVERY_TO}</td></tr>
                                                                                <tr>
                                                                                    <td valign="top" style="{$css->small_300}">
                                                                                        {if $line->Address->Company}{$line->Address->Company},{/if}
                                                                                        {if $line->Address->Firstname}{$line->Address->Firstname} {$line->Address->Lastname},{/if}
                                                                                        {if $line->Address->Address}{$line->Address->Address}{/if}
                                                                                        {if $line->Address->Zip}{$line->Address->Zip} {$line->Address->City}, {$line->Address->CountryIso}{/if}
                                                                                        ({$line->Address->Amount} {$line->UnitTitle})
                                                                                    </td>
                                                                                </tr>

                                                                                {if $line->Address->Comment}
                                                                                <tr><td valign="top" style="{$css->small_300}">{$text.CHECKOUT_STEP_TWO_COMMENT}: {$line->Address->Comment}</td></tr>
                                                                                {/if}

                                                                                {if $line->Address->DeliveryDate}
                                                                                <tr><td valign="top" style="{$css->small_300}">{$text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}: {$line->Address->DeliveryDate|date_format:$text.DATE_FORMAT} {$line->Address->DeliveryTime}</td></tr>
                                                                                {/if}
                                                                            <tbody>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                {/if}

                                                                {if $line->Status}
                                                                    <tr><td valign="top" style="{$css->small_300}">{$text.MY_ORDERS_STATUS}: {translation id=$line->Status module='order_status_code' title='title'}</td></tr>
                                                                {/if}

                                                                {if $line->ServiceType}
                                                                    {* Service type entity *}
                                                                    {entity controller=trackingMethod id=$line->ServiceType assign=trackingLine}
                                                                {/if}
                                                                {if $line->TrackingCode}
                                                                <tr>
                                                                    <td valign="top" style="{$css->small_300}">
                                                                        {$text.MY_ORDERS_TRACKING}{if $line->ServiceType} - <img style="vertical-align: text-bottom;" src="{"/_design/common/img/icons/delivery/{$trackingLine->Icon->Filename}"|solutionPath}" alt="{$trackingLine->Title}"> {$trackingLine->Title}{/if}:<br />
                                                                        {if $line->ServiceType && $line->ServiceType !== 'normal'}
                                                                            <a style="{$css->link}" href="{$trackingLine->getTrackingUrl($line->TrackingCode)}" target="_blank" rel="noopener">
                                                                            {$line->TrackingCode}</a>
                                                                        {else}
                                                                            {$line->TrackingCode}
                                                                        {/if}
                                                                    </td>
                                                                </tr>
                                                                {/if}

                                                                {* Gift wrapping *}
                                                                {if isset($line->WrappingText)}
                                                                <tr>
                                                                    <td valign="top" style="{$css->small_300}">
                                                                        {$text.CHECKOUT_STEP_THREE_NOTE}:<br />
                                                                        {if isset($line->WrappingText)}
                                                                            {$line->WrappingText}<br />
                                                                            {if isset($line->WrappingText)}
                                                                                {$text.CHECKOUT_STEP_THREE_NOTE_FROM}: {$line->WrappingFrom}
                                                                            {/if}
                                                                        {/if}
                                                                    </td>
                                                                </tr>
                                                                {/if}

                                                                {if $line->ExtendedDataExternal}
                                                                <tr><td valign="top">
                                                                    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                        <tbody>
                                                                        {foreach $line->ExtendedDataExternal as $extendedDataType}
                                                                            <tr>
                                                                                <td valign="top" style="{$css->small_300}">{$extendedDataType->Name}: {$extendedDataType->Data}</td>
                                                                            </tr>
                                                                        {/foreach}
                                                                        </tbody>
                                                                    </table>
                                                                </td></tr>
                                                                {/if}
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                    <td valign="top" align="right">
                                                        {if $line->Amount > 1 || $settings.shop_product_tax_after_price || ($line->DeliveryTime && $settings.shop_product_delivery_time eq true) || $line->DeliveryId}
                                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%" style="table-layout:auto !important;">
                                                            <tbody>
                                                                {if $line->Amount > 1}
                                                                <tr><td valign="top" align="right" style="{$css->small_300}">
                                                                  {$text.POS_DISCOUNT_PRODUCT_UNITPRICE|replace:" ":"&nbsp;"}:
                                                                  {$line->Price|formatPriceOrder:$orderId|replace:" ":"&nbsp;"}
                                                                </td></tr>
                                                                {/if}
                                                                {if $settings.shop_product_tax_after_price}
                                                                <tr><td valign="top" align="right" style="{$css->small_300}">
                                                                  {if $currency.hasVat and ($settings.vat_label_advanced eq false or $line->Vat gt 0)}
                                                                      {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX}
                                                                  {else}
                                                                      {$text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO}
                                                                  {/if}
                                                                </td></tr>
                                                                {/if}
                                                                {if $line->DeliveryTime && $settings.shop_product_delivery_time eq true}
                                                                <tr><td valign="top" align="right" style="{$css->small_300}">{$line->DeliveryTime}</td></tr>
                                                                {/if}
                                                                {if $line->DeliveryId}
                                                                <tr><td valign="top" align="right" style="{$css->small_300}">
                                                                    {$text.CHECKOUT_STEP_TWO}:&nbsp;{translation module=delivery_method title=title id=$line->DeliveryId}
                                                                </td></tr>
                                                                {/if}
                                                                <tr><td aria-hidden="true" height="{$css->rawPaddingTiny}" style="font-size: 0px; line-height: 0px;">&nbsp;</td></tr>
                                                            </tbody>
                                                        </table>
                                                        {else}
                                                          &nbsp;
                                                        {/if}
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>

                                    </td>
                                </tr>
                                {if !$line@last}<tr><td colspan="2" aria-hidden="true" height="{$css->rawPaddingSmall*2}" style="font-size: 0px; line-height: 0px;">&nbsp;</td></tr>{/if}
                            </tbody>
                        </table>
                    {/foreach}
                </td>
            </tr>
            {/if}

            <tr>
                <td valign="top" style="padding-bottom:{$css->rawPaddingTiny}px;">
                    <hr style="{$css->hr}">
                    <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tbody>
                            {if isset($orderList['CollectionOrderDeliveryLine'])}
                                <tr>
                                    <td style="{$css->small_300}">{$text.DELIVERY}: {$orderList.CollectionOrderDeliveryLine.0->Title}</td>
                                    <td align="right" style="{$css->small_300}">{$orderList.CollectionOrderDeliveryLine.0->Price|formatPriceOrder:$order->Id}</td>
                                </tr>
                            {/if}

                            {if isset($orderList['CollectionOrderSubTotalLine'])}
                                <tr>
                                    <td style="{$css->small_300}">{$text.CART_PRICE_SUM}</td>
                                    <td align="right" style="{$css->small_300}">{$orderList.CollectionOrderSubTotalLine.0->Price|formatPriceOrder:$order->Id}</td>
                                </tr>
                            {/if}

                            {if isset($orderList['CollectionOrderVatTotalLine'])}
                                <tr>
                                    <td style="{$css->small_300}">{if $currency.hasVat}{$text.CART_VAT_INCLUSIVE}{else}{$text.CART_VAT_EXCLUSIVE}{/if}</td>
                                    <td align="right" style="{$css->small_300}">{$orderList.CollectionOrderVatTotalLine.0->Price|formatPriceOrder:$order->Id}</td>
                                </tr>
                            {/if}

                            {if isset($orderList['CollectionOrderPaymentLine']) && $orderList.CollectionOrderPaymentLine.0->Price != 0}
                                <tr>
                                    <td style="{$css->small_300}">{$text.MY_ORDERS_FEE}</td>
                                    <td align="right" style="{$css->small_300}">{$orderList.CollectionOrderPaymentLine.0->Price|formatPriceOrder:$order->Id}</td>
                                </tr>
                            {/if}
                        </tbody>

                        <tfoot>
                            <tr>
                                <td style="{$css->p}"><b style="{$css->bold}">{$text.CART_TOTAL}</b></td>
                                <td align="right" style="{$css->p}"><b style="{$css->bold}">{$orderList.CollectionOrderTotalLine.0->Price|formatPriceOrder:$order->Id}</b> </td>
                            </tr>
                        </tfoot>
                    </table>
                </td>
            </tr>

            {if $user && $access.user}
                <tr>
                    <td style="padding: {$css->rawPadding*2}px {$css->rawPadding}px;{$css->background["000"]}">
                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tbody>
                                <tr>
                                    <td valign="top" align="center" style="text-align: center;">
                                        <table width="272" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td style="{$css->color['500']}{$css->background['000']}border-radius:0px;border:2px solid {$css->rawColors['500']}" height="42.0" bgcolor="{$css->rawColors["000"]|replace:"#":""}" align="center">
                                                        <a href="{$general.domain}/{$text.MY_ORDERS_LINK}/" style="{$css->color['500']}text-decoration:none;display:inline-block;border-radius:0px;padding-top:12px;padding-right:0px;padding-bottom:12px;padding-left:0px;width:100%;font-weight:bold;" target="_blank" rel="noopener">{$text.MY_ORDERS_MENU}</a>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            {/if}

            <tr>
                <td valign="top" style="padding:0 0 {$css->rawPadding*2}px 0;">
                    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td valign="top" align="left" width="50%" style="{$css->p};">
                                    {if $orderCustomer->ShippingFirstname}
                                        <h3 style="{$css->h3}padding-bottom:{$css->rawPaddingTiny}px;">{$text.CHECKOUT_DELIVERY_ADRESS}</h3>
                                        {orderCustomerAddress ordercustomer=$orderCustomer prefix="Shipping"}
                                    {else}
                                        <h3 style="{$css->h3}padding-bottom:{$css->rawPaddingTiny}px;">{$text.CHECKOUT_RECIEPT}</h3>
                                        {orderCustomerAddress ordercustomer=$orderCustomer}
                                    {/if}
                                </td>
                                <td valign="top" align="left" width="50%" style="{$css->p}; padding-left:{$css->rawPadding}px;">
                                    {if $orderCustomer->ShippingFirstname}
                                        <h3 style="{$css->h3}padding-bottom:{$css->rawPaddingTiny}px;">{$text.CHECKOUT_RECIEPT}</h3>
                                        {orderCustomerAddress ordercustomer=$orderCustomer}
                                    {/if}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>

            {if $order->ExternalComment or $order->CustomerComment or $order->DeliveryComment}
            <tr>
                <td valign="top" style="padding:0 0 {$css->rawPadding*2}px 0;">
                    <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            {if $order->ExternalComment}
                            <tr>
                                <td valign="top" align="left" style="{$css->p} padding-bottom: {$css->rawPadding}px;">
                                    <h3 style="{$css->h3};padding-bottom: {$css->rawPaddingTiny}px;">{$text.MY_ORDERS_SHOP_COMMENT}</h3>
                                    {$order->ExternalComment}
                                    <br />
                                </td>
                            </tr>
                            {/if}
                            {if $order->CustomerComment}
                            <tr>
                                <td valign="top" align="left" style="{$css->p} padding-bottom: {$css->rawPadding}px;">
                                    <h3 style="{$css->h3};padding-bottom: {$css->rawPaddingTiny}px;">{$text.MY_ORDERS_CUSTOMER_COMMENT}</h3>
                                    {$order->CustomerComment}
                                    <br />
                                </td>
                            </tr>
                            {/if}
                            {if $order->DeliveryComment}
                            <tr>
                                <td valign="top" align="left" style="{$css->p} padding-bottom: {$css->rawPadding}px;">
                                    <h3 style="{$css->h3};padding-bottom: {$css->rawPaddingTiny}px;">{$text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY}</h3>
                                    {$order->DeliveryComment}
                                    <br />
                                </td>
                            </tr>
                            {/if}
                        </tbody>
                    </table>
                </td>
            </tr>
            {/if}
        </tbody>
    </table>
{/if}
