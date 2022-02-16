{*

# Description
Template partial for the additional product information organized in tabs. Part of the Product page type.


## Date last modified
2021-05-28


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $hasActive                                                            - Boolean telling if active tabs has been found
+ $active                                                               - Variable telling which tab is active
+ $hasExtraBuy                                                          - Boolean telling if we have extraBuy products (extrabuy products move product actions)
+ $extraBuyCategories                                                   - Collection of productExtraBuyCategoryController
+ $extraBuys                                                            - Collection of productExtraBuyController
+ $productCustomDatas                                                   - Collection of productCustomDataController
+ $productPdfs                                                          - Collection of filesController with type productPdf
+ $text                                                                 - Global scope variable containing translations
+ $user                                                                 - Global scope variable containing user data
+ $settings                                                             - Global scope variable containing platform settings

## Partials (templates)
+ "/modules/product/partials/entity-navigation.tpl"                     - Partial template for product navigation (next, previous, pdf, send to friend)
+ "/modules/product/partials/entity-extra-buy.tpl"                      - Partial template for extrabuy products
+ "/modules/product/partials/entity-custom-data.tpl"                    - Partial template for products custom data
+ "/modules/product/partials/entity-files.tpl"                          - Partial template for products files
+ "/modules/product/partials/entity-reviews-comments.tpl"               - Partial template for product revies (comment section)
+ "/modules/product/partials/entity-tags.tpl"                           - Partial template for user and product tags
+ "/modules/widgets/social/facebook.tpl"                                - Social media widget for Facebook elements (Like box)
+ "/modules/widgets/social/google.tpl"                                  - Social media widget for Google+ elements (+1 box)
+ "/modules/widgets/social/twitter.tpl"                                 - Social media widget for Twitter elements (Tweet box)

*}

{* Preload related entities to optimize load times *}
{include file='modules/product/partials/entity-additional-info-preload.tpl' scope=parent}

{*** Used to set the active tab ***}
{$hasActive = false}

{* Product extra buy *}
{collection assign=extraBuyCategories controller=productExtraBuyCategory productId=$product->Id}

{*** Boolean / test value for ExtraBuy ***}
{$hasExtraBuy = false}
{*** Iterate each category ***}
{foreach $extraBuyCategories->getData() as $ebc}
    {*** Pull put all the extrabuy to figure out, if we hav any ***}
    {collection assign=extraBuys controller=productExtraBuy productId=$product->Id categoryId=$ebc->Id}
    {*** IF we have some, set the boolean / test value ***}
    {if $extraBuys and $extraBuys->getActualSize() gt 0}
        {$hasExtraBuy = true}
        {*** Break the iteration if we found any ***}
        {break}
    {/if}
{/foreach}


{*** Get the long description from the current product ***}
{$longDesc = $productController->getDescription($product->Id)}

{*** Collection entity of the customdataType controller ***}
{collection assign=productCustomDatas controller=productCustomData productId=$product->Id}
{collection assign=productCustomDataTypes controller=productCustomDataType productId=$product->Id}
{*** Product custom data ***}
{$hasCustomData = false}
{*** Loop all customdatatypes **}
{foreach $productCustomDataTypes->getData() as $productCustomDataType}
    {*** Get the custom data for the the product and the customdata type ***}
    {collection assign=productCustomDatas controller=productCustomData productId=$product->Id typeId=$productCustomDataType->Id}

    {*** If there are any datas show them ***}
    {if $productCustomDatas->getActualSize() gt 0 and $productCustomDataType->Display == "1"}
        {foreach $productCustomDatas->getData() as $productCustomData}
            {$hasCustomData = true}
            {break}
        {/foreach}
    {/if}
{/foreach}


{*** Collection entity of the files controller ***}
{collection assign=productPdfs controller=files type=productPdf id=$product->Id}

{$hasTabs = false}
{if $hasExtraBuy
or !empty($longDesc)
or ($productCustomDatas and $hasCustomData and $access.customData)
or ($productPdfs and $productPdfs->getActualSize() gt 0)
or ($settings.module_shop_review_products_type!=="stars" and $settings.module_shop_review_products and $access.reviews)
or ($settings.module_shop_tag_products and $access.tags)
or $settings.social_facebook
or $settings.social_twitter}
    {$hasTabs = true}
{/if}
{* Additional information *}
<div class="m-product m-product-additional-info{if !$hasTabs} is-hidden" data-controller="description--wrap{/if}">
    {* Seperator *}
    <hr class="m-product-additional-separator">

    {* Additional information tabs navigation *}
    <ul class="nav nav-tabs m-product-additional-info-tabs">
        {*** EXTRA BUY PRODUCTS FOR PRODUCT ***}
        {if $hasExtraBuy}
            <li class="active m-product-additional-info extra-buy"><a style="cursor:pointer;" data-toggle="content" data-target="#tabs-pane0">{$text.PRODUCT_CATALOG_EXTRABUY}</a></li>
            {*** We found a active first tabe ***}
            {$hasActive = true}
            {*** Set the active tab ***}
            {$active = "extrabuy"}
        {/if}

        {*** Tab nav: Description ***}
        <li class="{if (!$hasActive && !empty($longDesc)) || !$hasTabs}active{/if} m-product-additional-info description{if empty($longDesc)} is-hidden" data-controller="description--wrap{/if}"><a style="cursor:pointer;" data-target="#tabs-pane1" data-toggle="content">{$text.DESCRIPTION}</a></li>
        {*** We found a active first tabe ***}
        {if (!$hasActive && !empty($longDesc)) || !$hasTabs}
            {$hasActive = true}
            {*** Set the active tab ***}
            {$active = "description"}
        {/if}

        {*** Tab nav: Specifications ***}
        {if $hasCustomData and $access.customData}
            <li class="{if !$hasActive}active{/if} m-product-additional-info customdata"><a style="cursor:pointer;" data-target="#tabs-pane2" data-toggle="content">{$text.SPECIFICATIONS}</a></li>
            {*** We found a active first tabe ***}
            {if !$hasActive}
                {$hasActive = true}
                {*** Set the active tab ***}
                {$active = "customdata"}
            {/if}
        {/if}

        {*** Tab nav: Files ***}
        {if $productPdfs->getActualSize() gt 0}
            <li class="{if !$hasActive}active{/if} m-product-additional-info files"><a style="cursor:pointer;" data-target="#tabs-pane3" data-toggle="content">{$text.DOWNLOADS}</a></li>
            {*** We found a active first tabe ***}
            {if !$hasActive}
                {$hasActive = true}
                {*** Set the active tab ***}
                {$active = "files"}
            {/if}
        {/if}

        {*** Tab nav: Reviews ***}
        {if $settings.module_shop_review_products_type!=="stars" and $settings.module_shop_review_products and $access.reviews}
            <li class="{if !$hasActive}active{/if} m-product-additional-info review"><a style="cursor:pointer;" data-target="#tabs-pane4" data-toggle="content">{$text.PRODUCT_CATALOG_REVIEW_ADD_REVIEWS}</a></li>
            {if !$hasActive}
                {$hasActive = true}
                {*** Set the active tab ***}
                {$active = "reviews"}
            {/if}
        {/if}

        {*** Tab nav: Tags ***}
        {if $settings.module_shop_tag_products and $access.tags}
        <li class="{if !$hasActive}active{/if} m-product-additional-info tags"><a style="cursor:pointer;" data-target="#tabs-pane5" data-toggle="content">{$text.TAGS}</a></li>
            {if !$hasActive}
                {$hasActive = true}
                {*** Set the active tab ***}
                {$active = "tags"}
            {/if}
        {/if}
    </ul>

    {* Additional information tabs content ***}
    <div class="toggle-content t-panel-clean m-product-additional-info-content">
        {*** Tab content: Extra buy products for product ***}
        {if $hasExtraBuy}
            <div class="pane active m-product-additional-info extra-buy" id="tabs-pane0">
                {include file="modules/product/partials/entity-extra-buy.tpl" product=$product productController=$controller extraBuyCategories=$extraBuyCategories}
            </div>{* END: tab-content ExtraBuy *}
        {/if}

        {*** Tab content: Description ***}
        <div class="pane {if $hasActive and $active==="description"}active{/if} m-product-additional-info description clearfix{if empty($longDesc)} is-hidden" data-controller="description--wrap{/if}" id="tabs-pane1" itemprop="description">
            <div class="ck-content" data-controller="description">{$longDesc}</div>
        </div>{* END: tab-content Description *}

        {*** Tab content: Specifications ***}
        {if $hasCustomData and $access.customData}
            <div class="pane {if $hasActive and $active==="customdata"}active{/if} m-product-additional-info customdata" id="tabs-pane2">
                {include file="modules/product/partials/entity-custom-data.tpl" product=$product productController=$controller productCustomDataTypes=$productCustomDataTypes}
            </div>{* END: tab-content Specifications *}
        {/if}

        {*** Tab content: Files ***}
        {if $productPdfs->getActualSize() gt 0}
            <div class="pane {if $hasActive and $active==="files"}active{/if} m-product-additional-info files" id="tabs-pane3">
                {include file="modules/product/partials/entity-files.tpl" product=$product productController=$controller}
            </div>{* END: tab-content files *}
        {/if}

        {*** Tab content: Reviews ***}
        {if $settings.module_shop_review_products_type!=="stars" and $settings.module_shop_review_products and $access.reviews}
            <div class="pane {if $hasActive and $active==="reviews"}active{/if} m-product-additional-info review" id="tabs-pane4">
                {include file="modules/product/partials/entity-reviews-comments.tpl" product=$product productController=$controller}
            </div>{* END: tabs-content reviews *}
        {/if}

        {* Tab content: Tags *}
        {if $settings.module_shop_tag_products and $access.tags}
            <div class="pane {if $hasActive and $active==="tags"}active{/if} m-product-additional-info tags" id="tabs-pane5">
                {include file="modules/product/partials/entity-tags.tpl" product=$product}
            </div>{* END: Tab: Tags *}
        {/if}

    </div>{* END: tab-content tags *}
</div>