{*

# Description
Template partial for the product reviews. Part of the Product page type.


## Date last modified
2020-01-03


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $productReviewscontroller                                             - Instance of productReviewController
+ $productReviews                                                       - Collection of productReviewController
+ $image                                                                - Entity of fileController with type user
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/product/partials/entity-reviews-stars.tpl"                  - Partial template for product views as stars
+ "/modules/widgets/gravatar/gravatar.tpl"                              - Gravatar image widget, for blog comment author picture
+ "/modules/widgets/recaptcha/recaptcha.tpl"                            - Recaptcha widget, for blog comments
+ "/modules/widgets/login/login.tpl"                                    - Login widget, for log in

*}

{*** Reviews controller ***}
{controller assign=productReviewscontroller type=productReview primary=true}

{*** Collection entity of the reviews controller ***}
{collection assign=productReviews controller=productReview productId=$product->Id}



{*** Rating visually made with FontAwesome ***}
{$avgRating = $productReviewscontroller->getAverageRating($product->Id)}
{$bestRating = $productReviewscontroller->getAverageRating($product->Id, null, false)}



{* Reviews data *}
<div class="m-product-reviews">
    {* Reviews title and count *}
    <p class="m-product-review-header"><span class="h6">{$text.COMMENTS} <span class="badge badge-info">{$productReviews->getActualSize()}</span></span></p>

    {*** Display log in form if user is not logged in and it is required ***}
    {if !$user and $settings.module_shop_review_products === true}
        <div class="m-product-review-login">
            {if !$user}
                <div class="panel panel-warning panel-rounded">
                    <div class="panel-body">
                        <p><span>{$text.PRODUCT_CATALOG_REVIEW_LOGIN}</span></p>
                        <a href="#modal" data-fancybox="" class="button">{$Text.LOGIN_MENU}</a>
                    </div>
                </div>

                {*** Display log in form is user is not logged in ***}
                <div id="modal" class="container" style="display: none;">
                    {include file="modules/widgets/login/login.tpl" modalBtnClose="true" modalGoto="{$page.request}"}
                </div>
            {/if}
        </div>
    {else}
        {* Add new review*}
        <form action="/actions/review/product" data-blog="form" method="post">
            {csrf type="input"}
            {*** Post information also present in product.reviews.stars.js & entity-reviews-stars.tpl ***}
            <input type="hidden" name="score" value="0">
            <input type="hidden" name="product_id" value="{$product->Id}">

            {* Stars for review *}
            {*** Enable rating for stars if settings tells us we can ***}
            {if $settings.module_shop_review_products_type==="full"}
            <fieldset class="form-group m-product-review-stars comment-rate">
                <label class="form-label">{$text.PRODUCT_CATALOG_REVIEW_ADD_STARS}</label>
                <div class="input-group">
                    {include file="modules/product/partials/entity-reviews-stars.tpl" product=$product type="comment-rate"}
                </div>
            </fieldset>
            {/if}

            {*** If user is logged in, use their credentials ***}
            {if $user}
                <input type="hidden" name="name" value="{$user->Firstname} {$user->Lastname}" >
            {else}{*** else request them ***}
                <fieldset class="form-group m-product-review-name">
                    <label for="review-name" class="form-label">{$text.NAME} <span class="form-required">*</span></label>
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                        <input type="text" id="review-name" name="name" class="form-input input-group-main" placeholder="{$text.NAME}" required="">
                    </div>
                </fieldset>
            {/if}

            {* Input field for review headline *}
            <fieldset class="form-group m-product-review-headline">
                <label class="form-label" for="review-headline">{$text.PRODUCT_CATALOG_REVIEW_ADD_HEADER} <span class="form-required">*</span></label>
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-pencil"></i></span>
                    <input type="text" id="review-headline" name="headline" class="form-input input-group-main" placeholder="{$text.PRODUCT_CATALOG_REVIEW_ADD_HEADER}" required="">
                </div>
            </fieldset>

            {* Input for review text *}
            <fieldset class="form-group m-product-review-text">
                <label class="form-label" for="review-text">{$text.PRODUCT_CATALOG_REVIEW_ADD_REVIEW} <span class="form-required">*</span></label>
                <textarea id="review-text" name="text" class="form-input" style="height: 100px;" required="" placeholder="{$text.PRODUCT_CATALOG_REVIEW_ADD_REVIEW}"></textarea>
            </fieldset>

            {*** If we should show a spam check include the recaptcha ***}
            {if $settings.spam_check}
            <div class="m-product-review-recaptcha">
                {include file="modules/widgets/recaptcha/recaptcha.tpl"}
            </div>
            {/if}

            {if !$user && $settings.privacy_policy_product_review}
            <div class="m-reviews-consent">
                <div class="row">
                    <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                        {include file="modules/widgets/consent/consent.tpl"}
                    </div>
                </div>
            </div>
            {/if}

            {* Button used for submit *}
            <button type="submit" class="button m-product-review-button trailing">{$text.PRODUCT_CATALOG_COMMENT_ADD_HEADLINE}</button>
        </form>
        {if !$user}
            <div class="m-reviews-description-bottom description trailing">
                <p class="m-reviews-description-bottom consent-description">{if $general.isShop}{$text.REVIEW_CONSENT_DESCRIPTION_SHOP}{else}{$text.REVIEW_CONSENT_DESCRIPTION_CMS}{/if}</p>
            </div>
        {/if}
    {/if} {* END: check if logged in *}

    <hr>

    <ul class="l-list-border m-product-review-list">
        {*** Iterate over all reviews and print them ***}
        {foreach $productReviews->getData() as $review}
            <li class="media m-product-review-item">

                <div class="m-product-review-body media-body" itemprop="review" itemscope itemtype="http://schema.org/Review">
                    {if $review->Title}
                        <p itemprop="name" class="h6">{$review->Title}</p>
                    {/if}

                    {* include rating *}
                    {if $settings.module_shop_review_products_type==="full"}
                        {*** Reviews stars ***}
                        {include file="modules/product/partials/entity-reviews-stars.tpl" type="comment-show" rating=$review->Rating product=$product}
                    {/if}

                    {*** Time of creation ***}
                    <p><small>
                        {if $review->UserName}
                            <span class="m-product-review-reviewedby">{$text.PRODUCT_CATALOG_REVIEW_CREATED_BY}</span> <strong itemprop="author" itemscope itemtype="http://schema.org/Person"><span class="m-product-review-reviewer" itemprop="name">{$review->UserName}</span></strong>
                        {else}
                            <span itemprop="author" itemscope itemtype="http://schema.org/Person"><meta itemprop="name" content="Unknown" /></span>
                        {/if}
                        <time class="m-product-review-postedat" datetime="{$review->DateCreated}">{$review->DateCreated|date_format:$general.dateTimeFormat}</time>
                    </small></p>

                    <meta itemprop="datePublished" content="{$review->DateCreated}">

                    {*** Review text ***}
                    {if $review->Text}
                        <p class="m-product-review-description" itemprop="reviewBody">{$review->Text}</p>
                    {/if}
                </div>
            </li>
        {/foreach}
    </ul>{* END: .l-list-border *}
</div>{* END: .m-product-reviews *}
