{*

# Description
AngularJS template for product column display mode. Part of the Product page type.
The template uses [Select2](http://ivaynberg.github.io/select2/) to generate the dropdowns.


## Date last modified
2021-02-09


## Resource
+ [AngularJS](https://angularjs.org/)
+ [Select2](http://ivaynberg.github.io/select2/)


## Primary variables
+ product                                            		- Single product entity
+ text                                                      - Javascript version of Smarty $text with an array of translations


## Partials (templates)
No extra templates required for this template

*}

{literal}
<article class="productContent list-js-col m-productlist-item">

	<form method="post" action="/actions/cart/add">

		<input type="hidden" name="returnUrl" data-ng-value="returnUrl">

		<figure class="image m-productlist-figure">

			<!-- Product splashes, news, discount and sold out -->
			<div class="splash m-productlist-splash" data-ng-show="::settings.show_product_icons">

				<!-- NEW icon if newer than 30 days (2.592.000 seconds) -->
				<span class="badge badge-succes m-productlist-new" data-ng-if="::isNew" data-ng-bind-html="::text.NEWS"></span>

				<!-- DISCOUNT icon if discount it active -->
				<span class="badge badge-warning m-productlist-sale" data-ng-if="onSale" data-ng-bind-html="::text.SALE"></span>

				<!-- SOLD OUT icon if not in stock -->
				<span class="badge badge-danger m-productlist-soldout" data-ng-if="soldout" data-ng-bind-html="::text.SOLD_OUT"></span>
			</div>

			<!-- Product image -->
			<a data-ng-href="{{product.Handle}}" class="m-productlist-link trailing-db text-center">
				<span data-ng-if="::general.hasLazyload()" ng-style="{'max-width': imageWidth + 'px' }" class="placeholder-wrapper">
					<span class="placeholder"></span>
					<img class="responsive m-productlist-image lazyload"
					data-ng-src="{{image}}"
					data-src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
					alt="{{product.Title}}">
				</span>
				<img data-ng-if="::general.hasLazyload() == false"
					class="responsive m-productlist-image"
					data-ng-src="{{image}}"
					src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
					alt="{{product.Title}}">
			</a>
		</figure>

		<div class="content product-description" data-equalizer="type-col">

			<!-- Product title and brand -->
			<header class="title m-productlist-heading">
				<a data-ng-href="{{product.Handle}}" class="is-block m-productlist-link">
					<b><h4 class="h6 m-productlist-title" data-ng-bind-html="::product.Title"></h4></b>
				</a>
				<a class="m-productlist-brand-link" data-ng-if="::product.ProducerHandle" data-ng-href="{{::product.ProducerHandle}}">
					<small class="is-block m-productlist-brand" data-ng-bind-html="::product.ProducerTitle"></small>
				</a>
				<!-- Item number -->
				<small data-ng-if="::settings.shop_product_number && itemNumber" class="m-productlist-itemNumber" data-ng-bind-html="itemNumber"></small>
			</header>

			<!-- Stock status -->
			<div class="product-delivery m-productlist-stock" data-ng-if="::settings.shop_product_delivery_time && settings.shop_product_delivery_time_list">
				<p data-ng-if="!showVariants || hasChosenVariant" data-delivery-text></p>
			</div>

			<!-- Description -->
			<div class="description m-productlist-description">

				<!-- Short description -->
				<div class="short-description m-productlist-short-description" data-ng-if="::product.DescriptionList" data-ng-bind-html="::product.DescriptionList"></div>

			</div>

			<!-- Rating visually made with FontAwesome -->
			<div class="m-reviews-stars" data-ng-if="::settings.module_shop_review_products" data-raty="::product.AverageRating" data-readonly="true"></div>
		</div>

		<!-- Prices and transaction -->
		<div class="content product-transaction m-productlist-transactions" data-equalizer="type-col-prices">

            <!-- Variant dropdown of Product -->
            <div class="variants m-productlist-variants" data-ng-if="::showVariants" data-ng-class="{'flash': flashVariant}">
                <input type="hidden" name="product[{{product.Id}}][variant]" class="variantContainer m-productlist-variantContainer" style="width:100%;" data-variant-ajax="product.Id" data-variant-default="variantDefault" data-hide-price="showPrices" data-image-width="imageWidth" data-image-height="imageHeight" data-required>
            </div>

			<!-- Price calculation of Product -->
			<div class="prices" data-ng-if="::showPrices">

				<!-- Discount price -->
				<p class="m-productlist-discount" data-ng-if="discount">
					<!-- Price -->
					<s class="is-block m-productlist-price-before-discount" data-ng-bind-html="discount | currency_format"></s>
				</p>

				<!-- Price -->
				<span class="m-productlist-price h5 is-block" data-ng-bind-html="price"></span>

				<!-- Various price info -->
				<div class="product-various-price-info">

					<!-- VAT -->
					<span data-ng-if="::settings.shop_product_tax_after_price" class="is-block m-productlist-vat" data-ng-bind-html="::vatText"></span>

					<!-- Cheapest combo -->
					<span data-ng-if="combo" class="is-block" data-ng-bind-html="combo"></span>

					<!-- VAT -->
					<span data-ng-if="::settings.shop_product_tax_after_price && combo" class="is-block m-productlist-vat" data-ng-bind-html="::vatText"></span>

					<!-- Price terms -->
					<span data-ng-if="::shop.priceTerms" class="product-price-terms is-block m-productlist-price-terms">
						<a href="#overlaypriceTerms" class="fancybox" data-ng-bind-html="::text.PRODUCT_CATALOG_SHOW_DELIVERY_LINK"></a>
					</span>
				</div>

			</div>
		</div>

		<!-- Action -->
		<div class="content product-transaction product-action" data-ng-if="showButtons">
            <div class="m-productlist-tractions-amount">

                <!-- Amount -->
                <fieldset class="form-group m-productlist-amount">
                    <input type="text" pattern="[0-9]*" class="form-input text-center m-productlist-input" name="product[{{product.Id}}][amount]" value="{{minAmount}}" placeholder="{{::text.CART_COUNT}}" title="{{::text.CART_ADD_ERROR_EMPTY}}" required data-ng-disabled="buttonMode != 1">
                </fieldset>
            </div>
            <div class="m-productlist-tractions-button">

                <!-- Call-to-action -->
                <fieldset class="form-group" data-ng-switch data-on="buttonMode">
                    <a data-ng-switch-default data-ng-href="{{product.Handle}}" class="button-primary is-block m-productlist-link" data-ng-bind-html="::text.PRODUCT_CATALOG_PRODUCT_SHOW"></a>
                    <button data-ng-switch-when="1" type="submit" name="cartadd" class="button-primary is-block normal" data-ng-click="processProductSubmit()">
                        <span data-ng-bind-html="::text.PRODUCT_CATALOG_PRODUCT_BUY"></span>
                    </button>
                    <button data-ng-switch-when="2" type="button" class="button-primary is-block variant" data-ng-click="toggleFlashVariant()" data-ng-bind-html="::text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT"></button>
                </fieldset>
            </div>
		</div>

	</form>

</article>
{/literal}
