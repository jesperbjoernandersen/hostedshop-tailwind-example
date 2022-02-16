{*

# Description
Partial template for product navigation (next, previous, pdf, send to friend). Part of the Product page type.


## Date last modified
2021-08-16


## Primary variables
+ $product                                                              - Entity of productController (the current product)
+ $productController                                                    - Instance of productController
+ $links                                                                - Array with next and prev (previous) product ids (inherited from product.tpl)
+ $prev                                                                 - String containing the URL to the previous product (inherited from product.tpl)
+ $next                                                                 - String containing the URL to the next product (inherited from product.tpl)


## Partials (templates)
No extra templates required for this template

*}

{* Product navigation and links *}
<div class="m-product-nav is-hidden-print">
    <div class="row">
        <div class="col-s-4 col-m-6 col-l-6 col-xl-12 m-product-nav-cycle">
            {* Pager navigation for products *}
            {if $settings.product_browse and (isset($links['prev']) or isset($links['next']))}
            <div class="pager-group xsmall trailing-db-mobile">
                {if isset($links['prev'])}
                    <a role="button" href="{$prev}" class="left m-product-nav-prev">
                        {include file="modules/widgets/icon/icon.tpl" icon="chevronLeft"}
                    </a>
                {/if}

                {if isset($links['next'])}
                    <a role="button" href="{$next}" class="right m-product-nav-next">
                        {include file="modules/widgets/icon/icon.tpl" icon="chevronRight"}
                    </a>
                {/if}
            </div>
            {/if}
        </div>
        <div class="col-s-4 col-m-6 col-l-6 col-xl-12 text-right m-product-nav-share">
            {* Links for product *}
            {if $settings.product_send_to_a_friend}<a rel="nofollow" href="/{$text.SEND_TO_A_FRIEND_LINK}/?link={urlencode($page.request)}" role="button" title="{$text.SEND_TO_A_FRIEND_MENU}" class="m-product-nav-tellafriend trailing-db-mobile">{include file="modules/widgets/icon/icon.tpl" icon="mail"}</a>{/if}
            {if !empty($product->Url)}<a rel="nofollow" role="button" title="{$text.PRODUCT_CATALOG_PRODUCT_WEBPAGE}" href="{$product->Url}" target="_blank" class="trailing-db-mobile">{include file="modules/widgets/icon/icon.tpl" icon="link"}</a>{/if}
            {if $settings.product_pdf_export}
                <a title="{$text.SHOP_PDF_GENERATE}" target="_blank" rel="nofollow" href="/framework/pdf/product/{$product->Id}" role="button" class="m-product-nav-pdf trailing-db-mobile">
                    {include file="modules/widgets/icon/icon.tpl" icon="download"}
                </a>
            {/if}
            {* Print friendly link *}
            {if $template.settings.SETTINGS_SHOW_PRINT}
                <a title="Printvenlig" onclick="window.print(); return false;" href="#">
                    {include file="modules/widgets/icon/icon.tpl" icon="printer"}
                </a>
            {/if}
        </div>

        {if $settings.product_browse or $settings.product_send_to_a_friend or !empty($product->Url) or $settings.product_pdf_export}
        <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
            <br /><br />
        </div>
        {/if}
    </div>
</div>
