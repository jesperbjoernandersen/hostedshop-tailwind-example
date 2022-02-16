{*

# Description
Template partial for the product of type giftcard. Part of the Product page type.


## Date last modified
2019-09-26


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $variantController                                                    - Instance of productVariantController
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

{$giftcard_default_price = '100'}

<div class="m-product-giftcard">
    <fieldset class="form-group">
        <label class="form-label" for="gift_price">{$text.GIFT_CARD_INPUT_AMOUNT} <span class="form-required">*</span></label>
        <div class="input-group small">
            <span class="input-group-addon"><i class="fa fa-gift"></i></span>
            <input type="text" pattern="[0-9]*" name="product[{$product->Id}][giftcard][price]" required id="gift_price" value="{$giftcard_default_price}" class="form-input input-group-main text-right">
            <span class="input-group-addon">{$currency.symbol}</span>
        </div>
    </fieldset>

    <fieldset class="form-group">
        <label class="form-label" for="gift_name">{$text.GIFT_CARD_INPUT_NAME} <span class="form-required">*</span></label>
        <div class="input-group small">
            <span class="input-group-addon"><i class="fa fa-user"></i></span>
            <input type="text" name="product[{$product->Id}][giftcard][name]" id="gift_name" required value="" placeholder="{$text.GIFT_CARD_INPUT_NAME}" class="form-input input-group-main">
        </div>
    </fieldset>

    <fieldset class="form-group">
        <label class="form-label" for="gift_message">{$text.GIFT_CARD_INPUT_MESSAGE}</label>
        <textarea class="form-input" name="product[{$product->Id}][giftcard][message]" placeholder="{$text.MESSAGE}" id="gift_message" style="height:150px;"></textarea>
    </fieldset>
</div>
