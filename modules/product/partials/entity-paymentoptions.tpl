{*

# Description
Template partial for payment options


## Date last modified
2020-02-20


## Primary variables
+ $price                                            - Product price


## Partials (templates)
No extra templates required for this template

*}

{collection controller=paymentOption assign=paymentOptions price=$price}

{*** Payment Options ***}
{foreach $paymentOptions->getData() as $option}
	{* Klarna v2 support *}
	{if $option->Type==="klarna"}
		<div style="height:80px"
		     class="option option-klarna klarna-widget klarna-part-payment"
		     data-eid="{$option->Code}"
		     data-locale="{$option->Locale}"
		     data-price="{$price}"
		     data-layout="pale-v2">
		</div>
	{elseif $option->Type === "klarnakp"}
		<div class="option option-{$option->Type}">
			 {img class="clearfix" alt="{$option->Title}" style="vertical-align:middle;margin:0;" src="{$option->Logo}"}
		</div>
	{else}
		<div class="option option-{$option->Type}">
			{img class="clearfix" alt="{$option->Title}" style="vertical-align:middle;margin:0;" src="{$option->Logo}"}
		   	{if $option->Text}<span class="optionPriceFormat clearfix">{$option->Text}</span>{/if}
		   	{if $option->Price}<span class="optionPriceFormat clearfix">{$option->PriceFormatted}.</span>{/if}
		</div>
	{/if}
{/foreach}
