{*

# Description
Template partial for product page type, to display stock information based on product and product settings.


## Date last modified
2018-03-21


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $variantController                                                    - Instance of productVariantController
+ $hasAdditionals                                                       - Boolean telling if product has additional products
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ no partials

*}


{*** Stock status for the product (NoStock) ***}
{if $item->Soldout and $settings.shop_product_delivery_time}
    {* Seperator *}
    <div class="panel panel-danger panel-rounded m-product-stock m-product-soldout">
        <div class="panel-body">
            <strong class="m-product-soldout-status m-product-stock-status">{$text.CHECKOUT_STEP_TWO_STOCK_STATUS}:</strong>

            {*** Check if we should show a icon ***}
            {if $settings.shop_product_delivery_time === "texticon"}
                <i class="fa fa-fw fa-clock-o"></i>
            {/if}

            {*** CHeck if we should use the default or a custom oder text ***}
            <span class="m-product-soldout-text m-product-stock-text">
            {if $item->DeliveryTimeId <= 0}
                <span class="m-product-soldout-message m-product-stock-message has-nocount">{$text.PRODUCT_CATALOG_STOCK_NOT_HOME}</span>
            {else}
                <span class="m-product-soldout-message m-product-stock-message is-custom">{translation id=$item->DeliveryTimeId module='delivery_time' title='title_no_stock'}</span>
            {/if}
            </span>
        </div>
    </div>
{/if}

{*** Stock status for the product (OnStock) ***}
{if !$item->Soldout and $settings.shop_product_delivery_time}
    {* Seperator *}
    <div class="panel panel-success panel-rounded m-product-stock m-product-instock">
        <div class="panel-body">
            <strong class="m-product-instock-status m-product-stock-status">{$text.CHECKOUT_STEP_TWO_STOCK_STATUS}:</strong>

            {*** Check if we should show a icon ***}
            {if "texticon" === $settings.shop_product_delivery_time}
                <i class="fa fa-fw fa-check"></i>
            {/if}

            {*** Check if we should use the default or a custom oder text ***}
            <span class="m-product-instock-text m-product-stock-text">
                {if $item->DeliveryTimeId === 0}

                    {*** Show stock count, but make sure packet products skip this, as they do not have any ***}
                    {if $item->Type !== "packet"}
                        <span class="m-product-instock-count m-product-stock-count">{$item->Stock - $item->StockReservation}</span> <span class="m-product-instock-unit m-product-stock-unit">{translation id=$item->UnitId module='unit' title='title'}</span>
                    {/if}
                    <span class="m-product-instock-message m-product-stock-message is-withcount">{$text.PRODUCT_CATALOG_STOCK_HOME|lower}</span>
                {else if $item->DeliveryTimeId === -1}
                    <span class="m-product-instock-message m-product-stock-message has-nocount">{$text.PRODUCT_CATALOG_STOCK_HOME}</span>
                {else}
                    <span class="m-product-instock-message m-product-stock-message is-custom">{translation id=$item->DeliveryTimeId module='delivery_time' title='title_on_stock'}</span>
                {/if}
            </span>
        </div>
    </div>
{/if}
