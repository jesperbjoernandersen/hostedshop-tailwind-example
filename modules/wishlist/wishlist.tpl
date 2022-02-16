{*

# Description
Controller and template for Wishlist page type.


## Date last modified
2021-02-09


## Primary variables
+ $wishlist																- Entity of wishlistController
+ $product																- Entity of productController
+ $priceInterval														- Entity of productPriceController
+ $variantTypes															- Collection of productVariantTypesController
+ $variantData															- Collection of productVariantDataController
+ $category																- Entity of productCategoryController
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/login/login.tpl"                      				- Login widget, for log in

*}

{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{*** Meta tag - no noindex,follow ***}
{addMeta name="robots" content="noindex,follow"}


{entity controller=wishlist assign=wishlist primary=true}

{if !$user}
	<div id="modal" class="container" style="display: none;">
 		{include file="modules/widgets/login/login.tpl" modalBtnClose="true" modalGoto="{$page.request}"}
	</div>
{/if}

{$opengraph_title = $text.WISHLIST_HEADLINE}
{$opengraph_description = $text.WISHLIST_FRONTPAGE_TEXT}

<div class="modules m-wishlist">
	<article class="m-wishlist-article">
		<header class="m-wishlist-header">
			<div class="row">
				<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
					<h1 class="m-wishlist-headline page-title">{$text.WISHLIST_HEADLINE}</h1>
				</div>
				<div class="col-s-4 col-m-6 col-l-6 col-xl-12 text-right">
					{if !isset($smarty.get.send) && !isset($smarty.get.edit) && $user}
						{if count($wishlist->WishlistLines) gt 0}
							<p><a href="?send" class="button-primary" title="{$text.WISHLIST_SEND}">{$text.WISHLIST_SEND}</a></p>
						{/if}
					{/if}
					{if isset($smarty.get.send) || isset($smarty.get.edit)}
						<a class="button" href="/{$text.WISHLIST_LINK}/"><span>{$text.BACK}</span></a>
					{/if}
					{if !$user}
						<a href="#modal" class="button-primary fancybox-modal"><span>{$text.LOGIN_MENU}</span></a>
						{if $access.user && $settings.user_add}
							<a class="button" href="/{$text.USER_ADD_LINK}/?goto=/{$text.WISHLIST_LINK}/"><span>{$text.USER_ADD_MENU}</span></a>
						{/if}
					{/if}
				</div>
			</div>
		</header>
		<div class="row">
			<div class="col-s-4 col-m-12 col-l-12 col-xl-24">

				{if !$wishlist}
					<p class="m-wishlist-login-text">
						{$text.WISHLIST_FRONTPAGE_TEXT}
					</p>
					<p class="m-wishlist-login-link">
						{$text.WISHLIST_FRONTPAGE_LOG_IN_TEXT}
					</p>
				{else}

					{if $user && isset($smarty.get.send)}
						<form id="m-wishlist-send" method="post" action="/actions/wishlist/send">
							{csrf type="input"}
							<div class="panel panel-border">
								<div class="panel-body">
									<div class="row">
										<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
	                						<fieldset class="form-group m-wishlist-subject">
									        	<label class="form-label" for="m-wishlist-subject">{$text.WISHLIST_SEND_MAIL_TOPIC} <span class="form-required">*</span></label>
												<input id="m-wishlist-subject" name="subject" type="text" class="form-input small" placeholder="{$text.WISHLIST_SEND_MAIL_TOPIC}" value="{$text.WISHLIST_HEADLINE} - {$user->Firstname}" required>
											</fieldset>
											<fieldset class="form-group m-wishlist-message">
												<label class="form-label" for="m-wishlist-message">{$text.WISHLIST_SEND_MAIL_MESSAGE} <span class="form-required">*</span></label>
												<textarea class="form-input" id="m-wishlist-message" name="message" style="height: 146px;"></textarea>
											</fieldset>
										</div>
										<div class="col-s-4 col-m-6 col-l-6 col-xl-12">
	                						<fieldset class="form-group m-wishlist-emailto">
									        	<label class="form-label" for="m-wishlist-emailto">{$text.WISHLIST_SEND_MAIL_TO} <span class="form-required">*</span></label>
												<input id="m-wishlist-emailto" name="emailTo" type="text" class="form-input small" placeholder="{$text.WISHLIST_SEND_MAIL_TO_EXAMPLE}" required>
											</fieldset>
	                						<fieldset class="form-group m-wishlist-email">
									        	<label class="form-label" for="m-wishlist-email">{$text.WISHLIST_SEND_MAIL_FROM_MAIL} <span class="form-required">*</span></label>
												<input id="m-wishlist-email" name="email" type="text" class="form-input small" placeholder="{$text.WISHLIST_SEND_MAIL_FROM_MAIL}" value="{$user->Email}" required>
											</fieldset>
	                						<fieldset class="form-group m-wishlist-name">
									        	<label class="form-label" for="m-wishlist-name">{$text.WISHLIST_SEND_MAIL_FROM_NAME} <span class="form-required">*</span></label>
												<input id="m-wishlist-name" name="name" type="text" class="form-input small" placeholder="{$text.WISHLIST_SEND_MAIL_FROM_NAME}" value="{$user->Firstname} {$user->Lastname}" required>
											</fieldset>
											<fieldset class="form-group">
												<button name="submit" type="submit" class="button small">{$text.SEND}</button>
											</fieldset>
										</div>
									</div>
									{if $settings.spam_check}
									<div class="row">
										<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
											<div class="m-wishlist-spam-check">
												<br />
												{include file="modules/widgets/recaptcha/recaptcha.tpl"}
						    				</div>
										</div>
									</div>
				    				{/if}
								</div>
							</div>
						</form>
					{/if}

					<div class="row">
						<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
							<form id="m-wishlist-data" method="post" action="/actions/wishlist/edit">
								{csrf type="input"}
								<div class="panel panel-border">
									<div class="panel-heading">
										<div class="row">
											<div class="col-s-2 col-m-6 col-l-6 col-xl-20">
												<span class="h6">{$text.WISHLIST_HEADLINE}</span>
											</div>
											<div class="col-s-2 col-m-6 col-l-6 col-xl-4 text-right">
												{if $user}
													{if !isset($smarty.get.edit)}
														<a href="?edit" class="button xsmall" title="{$text.EDIT}"><span>{$text.EDIT}</span></a>
													{else}
														<button name="submit" type="submit" class="button small">{$text.SAVE}</button>
													{/if}
												{/if}
											</div>
										</div>
									</div>
									<div class="responsive">
										<input type="hidden" name="id" value="{$wishlist->Id}">
										<table class="table">
											<tbody>
												<tr>
													<td><span class="m-wishlist-event-title">{$text.WISHLIST_EVENT}</span></td>
													<td>
														{if !isset($smarty.get.edit)}
															<span class="m-wishlist-event"><strong>{$wishlist->EventTitle}</strong></span>
														{else}
															<fieldset class="form-group m-wishlist-text">
																<input id="m-wishlist-text" type="text" name="type" class="form-input small" value="{$wishlist->EventTitle}">
															</fieldset>
														{/if}
													</td>
												</tr>
												<tr>
													<td><span class="m-wishlist-date-title">{$text.WISHLIST_DATE}</span></td>
													<td>
														{if !isset($smarty.get.edit)}
															<span class="m-wishlist-date"><strong>{$wishlist->EventDate|date_format:'%d/%m %Y'}</strong></span>
														{else}
															<fieldset class="form-group m-wishlist-date">
																<div class="input-group small">
																	<span class="input-group-addon">{include file="modules/widgets/icon/icon.tpl" icon="calendar"}</span>
																	<input id="m-wishlist-date" type="date" name="day" class="form-input small" value="{$wishlist->EventDate|date_format:'%Y-%m-%d'}">
																</div>
															</fieldset>
														{/if}
													</td>
												</tr>
												{if $user && !isset($smarty.get.edit)}
													<tr>
														<td><span class="m-wishlist-link-title">{$text.WISHLIST_PUBLIC_LINK}</span></td>
														<td>
															<input type="text" name="link" class="form-input small" value="{$page.url}?wishlist={$wishlist->Id}&amp;hash={$wishlist->Hash}" readonly=readonly>
														</td>
													</tr>
												{/if}
											</tbody>
										</table>
									</div>
								</div>
							</form>
						</div>
					</div>

					{if count($wishlist->WishlistLines) gt 0}
						<div class="row">
							<div class="col-s-4 col-m-12 col-l-12 col-xl-24">
							<form id="m-wishlist" method="post" action="/actions/wishlist/update">
								{csrf type="input"}
								<div class="panel panel-border">
									<div class="panel-heading">
										<div class="row">
											<div class="col-s-4 col-m-4 col-l-4 col-xl-10 is-hidden-s">
												<span class="m-wishlist-headline-product h6">{$text.CART_PRODUCTS}</span>
											</div>
											<div class="col-s-4 col-m-2 col-l-3 col-xl-4 is-hidden-s">
												<span class="m-wishlist-headline-price h6">{$text.CART_PRICE}</span>
											</div>
											<div class="col-s-4 col-m-6 col-l-5 col-xl-10">
												<span class="m-wishlist-headline-amount h6">{$text.WISHLIST_AMOUNT}</span>
											</div>
										</div>
									</div>
									<ul class="list-unstyled t-striped m-wishlist-list">
										{foreach $wishlist->WishlistLines as $line}
											{* Product *}
											{entity assign=product controller=product id=$line->ProductId}
											{entity controller=productPrice productId=$line->ProductId variantId=$line->VariantId amount=$line->Amount assign=priceInterval}

											{* Variant *}
											{$wishlistVariantTitle = ''}
											{if $line->VariantId}
												{collection assign=variantTypes controller=productVariantType productId=$line->ProductId variantId=$line->VariantId}

								                {foreach $variantTypes->getData() as $variantType}
								                    {entity assign=variantData controller=productVariantData productId=$line->ProductId variantId=$line->VariantId typeId=$variantType->Id}

								                    {$wishlistVariantTitle = $wishlistVariantTitle|cat:" "|cat:$variantData->Title}
												{/foreach}
											{/if}

											{if $product}
											    {$productLink = ProductController::link($product->Id, false, $product)}
											    {if $line->VariantId}
											    	{$productLink="`$productLink`?variantId=`$line->VariantId`"}
											    {/if}

												<li class="m-wishlist-row">
													<div class="row">
														<div class="col-s-4 col-m-4 col-l-4 col-xl-10">
															<p class="m-wishlist-product-title">
																<a href="{$productLink}" title="{$product->Title} {$wishlistVariantTitle}">{$product->Title} {$wishlistVariantTitle}</a>
															</p>
														</div>
														<div class="col-s-4 col-m-2 col-l-3 col-xl-4">
															<p class="m-wishlist-product-price">
																{$priceInterval->PriceMin|formatPrice}
																{if $priceInterval->PriceMin != $priceInterval->FullPriceMin}
																	<del>{$priceInterval->FullPriceMin|formatPrice}</del>
																{/if}
															</p>
														</div>
														<div class="col-s-4 col-m-2 col-l-2 col-xl-3">
															{if $user}
																<fieldset class="form-group m-wishlist-amount">
																	<input type="text" class="form-input input-group-main small" name="wishlist[{$line->Id}][amount]" value="{$line->Amount}">
																</fieldset>
															{else}
																<p class="m-wishlist-product-amount">{$line->Amount} {$text.PEACES}</p>
															{/if}
														</div>

														<div class="col-s-4 col-m-2 col-l-3 col-xl-4 pull-right">
															<fieldset class="form-group m-wishlist-buy">
																<a href="{$productLink}" class="button-primary small is-block" title="{$text.PRODUCT_CATALOG_PRODUCT_BUY}"><span>{$text.PRODUCT_CATALOG_PRODUCT_BUY}</span></a>
															</fieldset>
														</div>

														<div class="col-s-4 col-m-2 col-l-2 col-l-offset-10 col-xl-3 col-xl-offset-0">
															{if $user}
																<a href="/actions/wishlist/delete?id={$line->Id}&{csrf type='get'}" class="button small is-block" title="{$text.DELETE}">{$text.DELETE}</a>
															{/if}
														</div>

													</div>
												</li>
											{/if}
										{/foreach}
									</ul>
								</div>
								{if !isset($smarty.get.send) && !isset($smarty.get.edit) && $user}
									<div class="row">
										<div class="col-s-4 col-m-12 col-l-12 col-xl-24 text-right">
											<button name="submit" type="submit" class="button">{$text.UPDATE}</button>
											{if count($wishlist->WishlistLines) gt 0}
												<a href="?send" class="button-primary" title="{$text.WISHLIST_SEND}">{$text.WISHLIST_SEND}</a>
											{/if}
										</div>
									</div>
								{/if}
								</form>
							</div>
						</div>
					{else}

						{$opengraph_description = $text.WISHLIST_EMPTY_TEXT}

				        <div class="panel panel-warning">
				            <div class="panel-body">
				               <span>{$text.WISHLIST_EMPTY_TEXT}</span>
				            </div>
				        </div>
					{/if}

				{/if}
			</div>
		</div>
	</article>
</div>


{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
