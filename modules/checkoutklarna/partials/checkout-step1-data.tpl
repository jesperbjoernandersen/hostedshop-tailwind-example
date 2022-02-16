{*

# Description
Checkout template partial for step 1, if the customer is a new user. Part of Checkout page type.


## Date last modified
2022-01-24


## Primary variables
+ $text                                                     			- Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}

<input type="hidden" name="bruger" value="0" />

{if $access.user && $settings.news_signup}
<div class="newsletterContainer">
	<div class="stepColumn column3">
		<div class="step3">
			<p class="title">{$Text.NEWLSLETTER_MENU}</p>
			<div class="stepBox clearfix">
				<div class="newsletter checkbox">
					<fieldset class="form-group m-checkout-newsletter">
						<div class="input-group">
							<span class="input-group-addon"><input type="checkbox" name="newsletter" class="radiobtn" id="newsletter" {if $returnPostData.newsletter}checked{/if} /></span>
							<label for="newsletter" class="form-label input-group-main">{$Text.USER_NEWSLETTER} <i class="fa fa-question-circle tooltip"><span class="tooltiptext">{$text.NEWSLETTER_TYPE_DESCRIPTION_SHOP}</span>
								</i></label>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
</div>
{/if}

