{*

# Description
Template partial for product tags. Part of the Product page type.


## Date last modified
2014-08-01


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $user                                                                 - Global scope variable containing user data
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


{*** Get all the tags to our product ***}
{controller assign=tagController type=productTag}
{$productTagsGrouped = $tagController->getTagsGrouped(999, $product->Id)}

<div class="m-product-tags">
    <div class="row">
        <div class="col-s-4 col-m-6 col-l-6 col-xl-12 m-product-tags-heading">
            <p><span class="h6 m-product-tags-title">{$text.PRODUCT_TAGGING_HEADLINE}</span></p>
            {* Fetch products link *}
            {$productLink = {page id=$page.productPageId print=Link}}

            {if count($productTagsGrouped) > 0}
                <ul class="list-inline list-unstyled m-product-tags-list">
                {foreach $productTagsGrouped as $group}
                    {$tagCount = $group.count}
                    {if $tagCount===1}
                        {$tagClass = $text.PRODUCT_TAGGING_RATING_CLASS_SIX}
                    {else if $tagCount > 1 and $tagCount <= 3}
                        {$tagClass = $text.PRODUCT_TAGGING_RATING_CLASS_FIVE}
                    {else if $tagCount > 3 and $tagCount <= 5}
                        {$tagClass = $text.PRODUCT_TAGGING_RATING_CLASS_FOUR}
                    {else if $tagCount > 5 and $tagCount <= 7}
                        {$tagClass = $text.PRODUCT_TAGGING_RATING_CLASS_THREE}
                    {else if $tagCount > 7 and $tagCount <= 9}
                        {$tagClass = $text.PRODUCT_TAGGING_RATING_CLASS_TWO}
                    {else}
                        {$tagClass = $text.PRODUCT_TAGGING_RATING_CLASS_ONE}
                    {/if}
                    <li class="m-product-tags-list-item">
                        <a href="/{$productLink}/?tag={$group.title}" title="{$tagCount} {$text.PRODUCT_TAGGING_RATING_TEXT} {$group.title}" class="{$tagClass} m-product-tags-link">{$group.title}
                        </a>
                    </li>
                {/foreach}
                </ul>
            {else}
                <p class="m-product-tags-none">{$text.PRODUCT_TAGGING_NONE}</p>
            {/if}

        </div>

        {*** If user is logged in, we want to display his/her tags ***}
        <div class="col-s-4 col-m-6 col-l-6 col-xl-12 m-product-tags-form">
            <p><span class="h6 m-product-tags-form-title">{$text.PRODUCT_TAGGING_USER_HEADLINE}</span></p>
            {if $user}
                {collection assign=productTags controller=$tagController productId=$product->Id uId=$user->Id}
                <form action="/actions/productTag/add" method="post" style="margin:0;">
                    {csrf type="input"}
                    <input type="hidden" name="product_id" value="{$product->Id}">
                    <div class="row">
                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                            <fieldset class="form-group xsmall">
                                <div class="input-group m-product-tags-form-tag">
                                    <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                                    <input type="text" name="tag" class="form-input xsmall input-group-main" placeholder="{$text.PRODUCT_TAGGING_USER_HEADLINE}">
                                </div>
                            </fieldset>
                        </div>
                        <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                            <button type="submit" name="commit" class="button xsmall m-product-tags-form-button">{$text.PRODUCT_TAGGING_TAG}</button>
                        </div>
                    </div>
                </form>

                {*** Get tags for the individual user ***}
                {if $productTags->getActualSize() gt 0}
                    <div class="row m-product-tags-usertags">
                        <ul class="list-unstyled m-product-tags-usertags-list m-product-tags-list">
                        {foreach $productTags->getData() as $tag}
                            <li class="col-s-2 col-m-6 col-l-6 col-xl-12 m-product-tags-usertags-list-item m-product-tags-list-item">
                                <form action="/actions/productTag/remove?id={$tag->Id}" class="tag-form-delete" method="post">
                                    {csrf type="input"}
                                    <input type="hidden" name="tag_id" value="{$tag->Id}">
                                    <input type="hidden" name="product_id" value="{$product->Id}">
                                    <input type="hidden" name="user_id" value="{$user->Id}">

                                    <button title="{$text.DELETE} {$tag->Title}" type="submit" class="tag-delete-button button button-text xsmall m-product-tags-usertags-form-button">
                                        <i class="fa fa-minus-circle tag-delete"></i> {$tag->Title}
                                    </button>
                                </form>
                            </li>
                        {/foreach}
                        </ul>
                    </div>
                {/if}
            {else}
                <p class="m-product-tags-login"><span class="tag-user-login m-product-tags-login-text">{$text.PRODUCT_TAGGING_USER_LOGIN}</span></p>
            {/if}
        </div>
    </div>{* END: .row *}
</div>
