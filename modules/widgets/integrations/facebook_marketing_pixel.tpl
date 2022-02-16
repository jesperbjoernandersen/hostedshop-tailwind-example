{*

# Description
This is a Facebook Marketing Pixel widget for all pages. [Facebook Marketing](https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-audiences/).

The file is included in index.tpl before </body> tag.


## Date last modified
2021-11-08


## Resource
+ [Facebook Marketing](https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-audiences/)


## Primary variables
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}
{if isset($settings.facebook_pixel_id) && !empty($settings.facebook_pixel_id) && (isset($cookieConsent.consent) && $cookieConsent.consent['MARKETING'])}
    {*** Helper function to generate 'content_category' in product page section ***}
    {function breadcrumbCategory id=0 productCategoryId=0}{strip}
        {entity assign=category controller=productCategory id=$id}
        {if $id != 0 && $category}
            {if $id != $productCategoryId}|{/if}
            {$category->Title|unescape:"htmlall"}
            {breadcrumbCategory id=$category->ParentId productCategoryId=$productCategoryId}
        {/if}
    {/strip}{/function}

    {*** Facebook Marketing pixel code ***}
    {literal}
    <script>
    !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
    n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
    document,'script','//connect.facebook.net/en_US/fbevents.js');

    fbq('init', '{/literal}{$settings.facebook_pixel_id}{literal}');
    fbq('track', "PageView");</script>
    <noscript><img height="1" width="1" style="display:none" alt=""
    src="https://www.facebook.com/tr?id={/literal}{$settings.facebook_pixel_id}{literal}&amp;ev=PageView&amp;noscript=1"
    /></noscript>

    <script>
    (function (w) {
        w.platform = w.platform || {};
        w.platform.convertFloats = function (val) {
            if (val.hasOwnProperty('value') && typeof val['value'] === 'number' ) { val['value'] = w.platform.toFixedIfNecessary(val['value']); }
            if (val.hasOwnProperty('item_price') && typeof val['item_price'] === 'number' ) { val['item_price'] = w.platform.toFixedIfNecessary(val['item_price']); }
            if (val.hasOwnProperty('contents') && val['contents'] instanceof Array ) {
                var i;
                for (i = 0; i < val['contents'].length; i++) {
                    val['contents'][i] = w.platform.convertFloats(val['contents'][i]);
                }
            }
            return val;
        };
        w.platform.toFixedIfNecessary = function (val){
            return Number(val.toFixed(2));
        }
    })(window);
    </script>
    {/literal}

    {*** Facebook Marketing for product ***}
    {if $page.isProduct && isset($page.paths.2)}
        {controller assign=productCtrl type=product primary=true}
        {entity assign=product controller=$productCtrl}

        {controller assign=productCategory type=productCategory}
        {$productCategory->preload($productCategory->categoryIdPath($product->CategoryId))}

        {if $product}

            {$eventData = [
                'eventID'       => $facebook.eventId
            ]}

            {$responseData = [
                'currency'      => $general.currencyIso
            ]}

            {$productTitle = $product->Title}

            {*** content_category data ***}
            {entity assign=category controller=$productCategory id=$product->CategoryId}
            {capture "foo"}{breadcrumbCategory id=$product->CategoryId productCategoryId=$product->CategoryId}{/capture}
            {$categoryList = explode("|",$smarty.capture.foo)}
            {$categoryList = array_reverse($categoryList)}
            {$content_category = implode(" > ", $categoryList)}


            {*** value data ***}
            {if isset($smarty.get.variantId)}
                {$responseData['content_type'] = 'product'}

                {entity assign=variant controller=productVariant productId=$product->Id variantId=(int)$smarty.get.variantId}

                {*** contet_name data ***}
                {collection assign=variantDatas controller=productVariantData productId=$product->Id variantId=(int)$smarty.get.variantId}
                {$variantTitle = $productTitle}

                {foreach $variantDatas->getData() as $variantData}
                    {$variantTitle = "$variantTitle `$variantData->Title`"}
                {/foreach}
                {$responseData['content_name'] = $variantTitle}

                {*** content_category data ***}
                {$responseData['content_category'] = $content_category}

                {$responseData['id'] = "{$product->Id}-{$variant->Id}"}
                {$responseData['content_ids'] = [$responseData['id']]}

                {if (((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly") && $product->Type !== 'discontinued' ) && !$product->CallForPrice}
                    {collection assign=prices controller=productPrice productId=$product->Id variantId=(int)$smarty.get.variantId productDiscountGroupId=$product->DiscountGroupId productTypeId=$product->Type}
                    {$priceData = $prices->getData()}
                    {$priceInterval = $priceData[0]}

                    {$responseData['value'] = $priceInterval->PriceMin}
                    {$responseData['item_price'] = $priceInterval->PriceMin}
                {else}
                    {$responseData['value'] = 0}
                    {$responseData['item_price'] = 0}
                {/if}

                {$responseData['quantity'] = $variant->Stock}

                <script id="ViewContent_VariantId">
                    var eventData = {$eventData|jsonify};
                    var data = {$responseData|jsonify};
                    fbq('track', 'ViewContent', (window.platform && window.platform.hasOwnProperty('convertFloats')) ? window.platform.convertFloats(data) : data, eventData );
                </script>

            {elseif $product->Type == 'variant'}
                {$content_ids = []}
                {$contents = []}

                {$responseData['id'] = "{$product->Id}"}
                {$responseData['item_group_id'] = "{$product->Id}"}
                {$responseData['content_type'] = 'product'}
                {$stock = 0}

                {if (((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly") && $product->Type !== 'discontinued' ) && !$product->CallForPrice}
                    {collection assign=prices controller=productPrice productId=$product->Id productDiscountGroupId=$product->DiscountGroupId productTypeId=$product->Type}
                    {$priceData = $prices->getData()}
                    {$priceInterval = $priceData[0]}

                    {$responseData['value'] = $priceInterval->PriceMin}
                    {$responseData['item_price'] = $priceInterval->PriceMin}
                {/if}

                {*** Add variant data ***}
                {collection assign=variants controller=productVariant productId=$product->Id}

                {* Preload variant data *}
                {controller assign=productVariantData type=productVariantData}
                {$productVariantData->preload($variants->pluck('Id'))}

                {foreach $variants->getData() as $variant}
                    {$contentItem = [
                        'id'            => "{$product->Id}-{$variant->Id}",
                        'item_price'    => 0,
                        'value'         => 0,
                        'quantity'      => $variant->Stock
                    ]}

                    {$stock = $stock + $variant->Stock}

                    {*** content price for variant ***}
                    {if (((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly") && $product->Type !== 'discontinued' ) && !$product->CallForPrice}
                        {collection assign=prices controller=productPrice productId=$product->Id variantId=$variant->Id productDiscountGroupId=$product->DiscountGroupId productTypeId=$product->Type}
                        {$priceData = $prices->getData()}
                        {$priceInterval = $priceData[0]}

                        {$contentItem['item_price'] = $priceInterval->PriceMin}
                        {$contentItem['value'] = $priceInterval->PriceMin}
                    {/if}

                    {*** content_category data ***}
                    {$contentItem['content_category'] = $content_category}

                    {** content_name data ***}
                    {collection assign=variantDatas controller=$productVariantData productId=$product->Id variantId=$variant->Id}
                    {$variantTitle = $productTitle}
                    {foreach $variantDatas->getData() as $variantData}
                        {$variantTitle = "$variantTitle `$variantData->Title`"}
                    {/foreach}
                    {$contentItem['content_name'] = $variantTitle}


                    {$content_ids[] = $contentItem['id']}
                    {$contents[] = $contentItem}
                {/foreach}

                {$responseData['content_ids'] = $content_ids}
                {$responseData['contents'] = $contents}

                <script id="ViewContent_Variant">
                    var eventData = {$eventData|jsonify};
                    var data = {$responseData|jsonify};
                    fbq('track', 'ViewContent', (window.platform && window.platform.hasOwnProperty('convertFloats')) ? window.platform.convertFloats(data) : data, eventData );
                </script>
            {/if}

            {$responseData = [
                'id'                => $product->Id,
                'currency'          => $general.currencyIso,
                'content_type'      => 'product',
                'content_category'  => $content_category,
                'content_name'      => $productTitle,
                'content_ids'       => [$product->Id],
                'value'             => 0,
                'item_price'        => 0
            ]}

            {if $product->Type == 'normal'}
                {$responseData['quantity'] = $product->Stock}
            {elseif $product->Type == 'variant' && !isset($smarty.get.variantId)}
                {$responseData['quantity'] = $stock}
            {/if}

            {if (((!$settings.shop_b2b_hidden_prices or $user) or $settings.shop_b2b_hidden_prices === "partly") && $product->Type !== 'discontinued' ) && !$product->CallForPrice}
                {collection assign=prices controller=productPrice productId=$product->Id productDiscountGroupId=$product->DiscountGroupId productTypeId=$product->Type}
                {$priceData = $prices->getData()}
                {$priceInterval = $priceData[0]}

                {$responseData['value'] = $priceInterval->PriceMin}
                {$responseData['item_price'] = $priceInterval->PriceMin}
            {/if}

            <script id="ViewContent_Product">
                var eventData = {$eventData|jsonify};
                var data = {$responseData|jsonify};

                fbq('track', 'ViewContent', (window.platform && window.platform.hasOwnProperty('convertFloats')) ? window.platform.convertFloats(data) : data, eventData );
            </script>
        {/if}
    {/if}

    {*** Facebook Marketing for purchase complete ***}
    {if $page.isCheckoutComplete && !empty($page.orderId)}

        {* Order entity *}
        {entity controller=order assign=order id=$page.orderId userId=false statusId=false}

        {* Implementation to avoid double registering of orders *}
        {if !$order->JavascriptConfirmationLoaded}

            {collection controller=orderLine assign=orderLine orderId=$page.orderId repay=false}
            {$orderList = $orderLine->groupByClass()}

            {if $orderLine->getActualSize() gt 0}
                {if isset($orderList['CollectionOrderLine'])}
                    {$content_ids = []}
                    {$contents = []}

                    {$responseData = [
                        'content_type'  => 'product',
                        'currency'      => $general.currencyIso,
                        'value'         => $orderList.CollectionOrderTotalLine.0->Price
                    ]}

                    {foreach $orderList.CollectionOrderLine as $line}
                        {$contentItem = []}

                        {if isset($line->ProductId)}
                            {$contentItem['id'] = (string)$line->ProductId}
                            {$contentItem['item_price'] = $line->Price}
                            {$contentItem['value'] = $line->Price}
                            {$contentItem['quantity'] = $line->Amount}
                            {$contentItem['content_name'] = $line->ProductTitle}

                            {if $line->VariantId}
                                {$contentItem['id'] = "{$contentItem['id']}-{$line->VariantId}"}
                                {$contentItem['content_name'] = "{$contentItem['content_name']} {$line->VariantTitle}"}
                            {/if}

                            {*** content_category data ***}
                            {entity assign=category controller=productCategory productId=$line->ProductId}
                            {capture "foo"}{breadcrumbCategory id=$category->Id productCategoryId=$category->Id}{/capture}
                            {$categoryList = explode("|",$smarty.capture.foo)}
                            {$categoryList = array_reverse($categoryList)}
                            {$contentItem['content_category'] = implode(" > ", $categoryList)}

                            {$content_ids[] = $contentItem['id']}
                            {$contents[] = $contentItem}

                        {/if}
                    {/foreach}

                    {$responseData['contents'] = $contents}
                    {$responseData['content_ids'] = $content_ids}

                    <script id="Purchase">
                        {$eventData = [
                            'eventID'       => $page.orderId
                        ]}

                        var eventData = {$eventData|jsonify};
                        var data = {$responseData|jsonify};
                        fbq('track', 'Purchase', (window.platform && window.platform.hasOwnProperty('convertFloats')) ? window.platform.convertFloats(data) : data, eventData );
                    </script>
                {/if}
            {/if}
        {/if}
    {/if}

    {*** Facebook Marketing for initialzing cart ***}
    {if $page.isCheckout and !isset($smarty.get.approved) and empty($page.orderId)}
        <script id="InitiateCheckout">

            {$eventData = [
                'eventID'       => $facebook.eventId
            ]}

            var eventData = {$eventData|jsonify};

            fbq('track', 'InitiateCheckout', null, eventData);
        </script>
    {/if}

    {*** Facebook Marketing for add to cart ***}
    {if $message && in_array($message->type(), ["cart_update_success", "cart_plus_success", "cart_reorder_one_success", "cart_reorder_all_success", "cart_add_variant_success", "cart_add_success"])}

        {*** Get cart total ***}
        {collection controller=cart assign=cartData}
        {$cartList = $cartData->groupByClass()}

        {if isset($cartList.CartProductLine)}
            {$content_ids = []}
            {$contents = []}
            {$messageItem = $message->itemId()}

            {$responseData = [
                'content_type'  => 'product',
                'currency'      => $general.currencyIso
            ]}

            {if count($messageItem) == 1}
                {$messageItem = array_pop($messageItem)}
            {/if}

            {if isset($messageItem.product)}
                {foreach $cartList.CartProductLine as $lineItem}

                    {if ($lineItem->ProductId == $messageItem.product && !isset($messageItem.variant))
                     OR ($lineItem->ProductId == $messageItem.product && isset($messageItem.variant) && $lineItem->VariantId == $messageItem.variant)}

                        {$responseData['content_name'] = $lineItem->Title}
                        {$itemId = (string)$messageItem.product}
                        {if $messageItem.variant}
                            {$itemId = "{$itemId}-{$messageItem.variant}"}
                            {$responseData['content_name'] = "{$responseData['content_name']} {$lineItem->VariantTitle}"}
                        {/if}

                        {*** content_category data ***}
                        {entity assign=category controller=productCategory productId=$messageItem.product}
                        {capture "foo"}{breadcrumbCategory id=$category->Id productCategoryId=$category->Id}{/capture}
                        {$categoryList = explode("|",$smarty.capture.foo)}
                        {$categoryList = array_reverse($categoryList)}

                        {$responseData['content_category'] = implode(" > ", $categoryList)}
                        {$responseData['value'] = $lineItem->Price}

                        {$content_ids[] = $itemId}

                        {break}
                    {/if}
                {/foreach}
            {else}
                {foreach $messageItem as $item}
                    {$contentItem = []}

                    {foreach $cartList.CartProductLine as $lineItem}

                        {if ($lineItem->ProductId == $item.product && !isset($item.variant))
                         OR ($lineItem->ProductId == $item.product && isset($item.variant) && $lineItem->VariantId == $item.variant)}

                            {$contentItem['id'] = (string)$lineItem->ProductId}
                            {$contentItem['item_price'] = $lineItem->Price}
                            {$contentItem['quantity'] = (int)$item.amount}

                            {if $lineItem->VariantId}
                                {$contentItem['id'] = $contentItem['id']|cat:"-{$lineItem->VariantId}"}
                                {$contentItem['content_name'] = "{$contentItem['content_name']} {$lineItem->VariantTitle}"}
                            {/if}


                            {*** content_category data ***}
                            {entity assign=category controller=productCategory productId=$item.product}
                            {capture "foo"}{breadcrumbCategory id=$category->Id productCategoryId=$category->Id}{/capture}
                            {$categoryList = explode("|",$smarty.capture.foo)}
                            {$categoryList = array_reverse($categoryList)}
                            {$contentItem['content_category'] = implode(" > ", $categoryList)}

                            {$content_ids[] = $contentItem['id']}

                            {break}
                        {/if}
                    {/foreach}

                    {if !empty($contentItem)}{$contents[] = $contentItem}{/if}
                {/foreach}

                {$responseData['contents'] = $contents}
            {/if}

            {$responseData['content_ids'] = $content_ids}

            <script id="AddToCart">
                {$eventData = [
                    'eventID'       => $facebook.eventId
                ]}

                var eventData = {$eventData|jsonify};
                var data = {$responseData|jsonify};

                fbq('track', 'AddToCart', (window.platform && window.platform.hasOwnProperty('convertFloats')) ? window.platform.convertFloats(data) : data, eventData);
            </script>
        {/if}
    {/if}
{/if}
