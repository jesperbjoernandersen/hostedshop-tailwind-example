{*

# Description
Template partial for the product reviews stars. Part of the Product page type.
Based on a modified verion of the jQuery library Raty called [Raty-Fa](http://jacob87.github.io/raty-fa/).


## Date last modified
2014-08-01


## Resource
+ Raty-Fa ( Raty with fontawesome icons) [raty-fa](http://jacob87.github.io/raty-fa/)


## Primary variables
+ $type                                                                 - Either ("comment-show", "comment-rate", "quick-rating")
+ $product                                                              - (Optional) An entity of product
+ $rating                                                               - (Optional) A value that tells the rating to display
+ $text                                                                 - Global scope variable containing translations
+ $User                                                                 - Global scope variable containing user data


## Partials (templates)
No extra templates required for this template

*}

{*** If $product is supplied, preload some data we need later ***}
{if $product}
    {*** Reviews controller ***}
    {controller assign=reviewcontroller type=productReview primary=true}

    {*** Collection of reviews for current product ***}
    {collection assign=reviews controller=$reviewcontroller productId=$product->Id}

    {*** Rating visually made with FontAwesome ***}
    {$ratingAvg = $reviewcontroller->getAverageRating($product->Id)}
{/if}

{*** Store some values for use in the different types ***}
{$ratingStars = 5}


{*** Show the star rating in a comment ($rating should be supplied) ***}
{if $type and $type==="comment-show" and $rating}
    <div class="m-product-reviews-stars m-reviews-stars" itemprop="reviewRating" itemscope itemtype="http://schema.org/Rating"
        data-reviews="stars"
        data-reviews-type="commentshow"
        data-score="{if $rating}{$rating}{else}1{/if}"
        data-number="{$ratingStars}"
        data-readOnly="true"
        data-half="true"
        data-hints="{$text.RATING_RATINGS}"
        data-noRatedMsg="{$text.RATING_NO_RATING}"
    >
        {* Rating meta - average rating for product *}
        <meta itemprop="ratingValue" content="{if $rating}{$rating}{else}1{/if}">
        <meta itemprop="worstRating" content="1">
        <meta itemprop="bestRating" content="{$ratingStars}">
    </div>{* END: itemscope *}
{/if} {* END: "comment-show" *}


{*** Show the star rating in the create comment section ($product should be supplied) ***}
{if $type and $type==="comment-rate" and $product}
    <div class="m-product-reviews-stars m-reviews-stars"
        data-reviews="stars"
        data-reviews-type="commentrate"
        data-number="{$ratingStars}"
        data-hints="{$text.RATING_RATINGS}"
        data-noRatedMsg="{$text.RATING_NO_RATING}"
        data-scoreName="score"
    ></div>{* END: itemscope *}
{/if} {* END: "comment-rate" *}


{*** Show the star rating in the create comment section ($product should be supplied) ***}
{if $type and $type==="quick-rating" and $product}
<div class="m-product-reviews-quick-review clearfix" {if $reviews->getActualSize() gt 0}itemprop="aggregateRating" itemscope itemtype="http://schema.org/AggregateRating"{/if}>
    <div class="m-product-reviews-stars m-reviews-stars"
        data-reviews="stars"
        data-reviews-type="quickrating"
        data-score="{$ratingAvg}"
        data-number="{$ratingStars}"
        data-productId="{$product->Id}"
        {*** If rating display type equals "full" only display rating, rating is done in reviews section ***}
        {if $settings.module_shop_review_products_type==="full" or $reviewcontroller->isProductRated($product->Id)}
            data-readOnly="true"
        {/if}
        {if $user}
            data-userId="{$user->Id}"
            data-name="{$user->Firstname} {$user->Lastname}"
        {/if}
        data-hints="{$text.RATING_RATINGS}"
        data-noRatedMsg="{$text.RATING_NO_RATING}"
    ></div>{* END: itemscope *}

    {*** Display a message based on count and avg rating ***}
    {if $reviews->getActualSize() gt 0 and $ratingAvg gt 0}
        {$reviewCount = 0}
        {foreach $reviews->getData() as $item}
            {if $item->Rating}{$reviewCount = $reviewCount+1}{/if}
        {/foreach}

        {* Rating meta - average rating for product *}
        <meta itemprop="ratingValue" content="{$ratingAvg}" />

        {if $reviewCount > 0}
            {*** Rating total amount of reviews/ratings ***}
            <div><span class="m-product-ratingsCount-text">{$text.BASED_ON}</span> <span class="m-product-ratingsCount-value">{$reviewCount}</span> {if $reviewCount > 1}{$text.RATING_REVIEWS}{else}{$text.RATING_REVIEW}{/if}</div>
        {/if}
        <meta itemprop="ratingCount" content="{$reviews->getActualSize()}" />
    {else}
        {*** No ratings are made yet ***}
        <div class="m-product-ratingsNone">{$text.RATING_NO_RATING}</div>
    {/if}

    {*** IF user is logged in or we don't require login ***}
    {if ($user or $settings.module_shop_review_products) and $settings.module_shop_review_products_type!=="stars" and $reviews->getActualSize() > 0}
        <span class="m-product-review-links"><a href="#tabs-pane4" class="m-product-review-product" data-toggle="content">{$text.PRODUCT_CATALOG_REVIEW_ADD_HEADLINE}</a> - <a href="#tabs-pane4" class="review-read" data-toggle="content">{if $reviews->getActualSize() > 1}{$text.RATING_SEE_REVIEWS}{else}{$text.RATING_SEE_REVIEW}{/if}</a></span>
    {/if}
</div>
{/if} {* END: "quick-rating" *}
