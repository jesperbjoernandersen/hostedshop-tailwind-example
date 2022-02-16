{*

# Description
Template partial for Checkout step 2 of the checkout process. Part of Checkout page type.
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).


## Date last modified
2021-05-10


## Resource
+ [jsRender Template](http://www.jsviews.com/#jsrender)


## Primary variables


## Partials (templates)
No extra templates required for this template

*}

<input type="hidden" name="post_delivery_method" value="{$returnPostData.delivery_method}">
{if $returnPostData.delivery_multi}
	{foreach $returnPostData.delivery_multi as $key => $deliveryFixed}
		<input type="hidden" class="post_delivery_method_fixed" name="post_{$key}" value="{$deliveryFixed}">
	{/foreach}
{/if}

{literal}
<script id="deliveryMethodTemplate" type="text/x-jsrender">
{{if groupHeader}}
<div class="deliveryMethodGroupContainer">
	<div class="deliveryMethodGroupProductsHeader">{{:groupHeader}}</div>
{{/if}}
{{if fixed}}
    <div class="deliveryMethodGroupProducts">
	    {{for products}}
	        {{:#data}}<br />
	    {{/for}}
    </div>
{{/if}}
<div class="deliveryMethodContainer">
	<div class="deliveryMethodSelector radio">
		<fieldset class="form-group  m-checkout-delivery">
			<div class="input-group">
				<span class="input-group-addon">
					<input type="radio" name="{{:name}}" id="{{:id}}" value="{{:value}}" class="radiobtn deliveryMethodRadio{{if isGls}} gls{{/if}}{{if isPostDK}} postdk{{/if}}{{if isBringPP}} bringpp{{/if}}{{if isDao}} dao{{/if}}{{if isDropPoint}} droppoint{{/if}}{{if groupHeader}} header{{/if}} {{if messageField}}messageField{{/if}}" required />
				</span>
				<label for="{{:id}}" class="form-label input-group-main">
					<span class="deliveryMethodName">{{:title}}</span>
					<span class="error_text is-block">{{:priceText}}</span>
					{{if freeDelivery}}
				    	<span class="error_text is-block">{/literal}{$Text.FREE}{literal}!</span>
					{{/if}}
					<span class="deliveryMethodDescription is-block">
						<span class="deliveryMethodDescriptionText is-block">{{:text}}</span>
						{{if freeText}}
						<i class="is-block">{{:freeText}}</i>
						{{/if}}
					</span>
				</label>
			</div>
		</fieldset>
	</div>
	{{if isGls}}
	<div id="glsContainer" class="locationContainer" style="display:none;">
		{/literal}{include file='modules/checkout/partials/checkout-step2-droppoint.tpl'}{literal}
		<div class="glsTitle">
			<div class="panel panel-warning">
				<div class="panel-body">
					{/literal}{$Text.CHECKOUT_STEP_TWO_GLS_HEADER}{literal}
				</div>
			</div>
		</div>
        <div class="targetContainer">
        	<ul class="glsLocationTarget target list-unstyled" style="padding: 0 0 0 1.5em;"></ul>
        </div>
    </div>
	{{/if}}
	{{if isPostDK}}
	<div id="postdkContainer" class="locationContainer" style="display:none;">
		{/literal}{include file='modules/checkout/partials/checkout-step2-droppoint.tpl'}{literal}
		<div class="postdkTitle">
			<div class="panel panel-warning">
				<div class="panel-body">
					{/literal}{$Text.CHECKOUT_STEP_TWO_POSTDK_HEADER}{literal}
				</div>
			</div>
		</div>
        <div class="targetContainer">
        	<ul class="postdkLocationTarget target list-unstyled" style="padding: 0 0 0 1.5em;"></ul>
        </div>
    </div>
	{{/if}}
	{{if isBringPP}}
	<div id="bringppContainer" class="locationContainer" style="display:none;">
		{/literal}{include file='modules/checkout/partials/checkout-step2-droppoint.tpl'}{literal}
		<div class="bringppTitle">
			<div class="panel panel-warning">
				<div class="panel-body">
					{/literal}{$Text.CHECKOUT_STEP_TWO_BRINGPP_HEADER}{literal}
				</div>
			</div>
		</div>
        <div class="targetContainer">
        	<ul class="bringppLocationTarget target list-unstyled" style="padding: 0 0 0 1.5em;"></ul>
        </div>
    </div>
	{{/if}}
	{{if isDao}}
	<div id="daoContainer" class="locationContainer" style="display:none;">
		{/literal}{include file='modules/checkout/partials/checkout-step2-droppoint.tpl'}{literal}
		<div class="daoTitle">
			<div class="panel panel-warning">
				<div class="panel-body">
					{/literal}{$Text.CHECKOUT_STEP_TWO_DAO_HEADER}{literal}
				</div>
			</div>
		</div>
        <div class="targetContainer">
        	<ul class="daoLocationTarget target list-unstyled" style="padding: 0 0 0 1.5em;"></ul>
        </div>
    </div>
	{{/if}}
</div>
{{if lastInGroup}}
</div>
{{/if}}
</script>
<script id="glsLocationTemplate" type="text/x-jsrender">
	<li class="radio">
		<fieldset class="form-group">
			<div class="input-group">
				<span class="input-group-addon">
					<input id="gls_location{{:#index}}" type="radio" name="gls_location" class="radiobtn" value="{{:Number}}">
				</span>
				<label for="gls_location{{:#index}}" class="form-label input-group-main">
					<span class="droppointTextHeader is-block">{{:CompanyName}} </span>
					<span class="droppointTextLine is-block">{{:Streetname}}, {{:ZipCode}} {{:CityName}}</span>
				</label>
			</div>
		</fieldset>
	</li>
</script>
<script id="postdkLocationTemplate" type="text/x-jsrender">
	<li class="radio">
		<fieldset class="form-group">
			<div class="input-group">
				<span class="input-group-addon">
					<input id="postdk_location{{:#index}}" type="radio" name="postdk_location" class="radiobtn" value="{{:number}}" />
				</span>
				<label for="postdk_location{{:#index}}" class="form-label input-group-main">
					<span class="droppointTextHeader is-block">{{:name}}</span>
					<span class="droppointTextLine is-block">{{:streetName}} {{:streetNumber}}</span>
					<span class="droppointTextLine is-block">{{:postalCode}} {{:city}}</span>
					<span class="droppointTextLine is-block"><i>{{:openingHours}}</i></span>
				</label>
			</div>
		</fieldset>
	</li>
</script>
<script id="bringppLocationTemplate" type="text/x-jsrender">
	<li class="radio">
		<fieldset class="form-group">
			<div class="input-group">
				<span class="input-group-addon">
					<input id="bringpp_location{{:#index}}" type="radio" name="bringpp_location" class="radiobtn" value="{{:id}}">
				</span>
				<label for="bringpp_location{{:#index}}" class="form-label input-group-main">
					<span class="droppointTextHeader is-block">{{:name}} </span>
					<span class="droppointTextLine is-block">{{:visitingAddress}}, {{:visitingPostalCode}} {{:visitingCity}}</span>
				</label>
			</div>
		</fieldset>
	</li>
</script>
<script id="daoLocationTemplate" type="text/x-jsrender">
	<li class="radio">
		<fieldset class="form-group">
			<div class="input-group">
				<span class="input-group-addon">
					<input id="dao_location{{:#index}}" type="radio" name="dao_location" class="radiobtn" value="{{:id}}">
				</span>
				<label for="dao_location{{:#index}}" class="form-label input-group-main">
					<span class="droppointTextHeader is-block">{{:name}} </span>
					<span class="droppointTextLine is-block">{{:visitingAddress}}, {{:visitingPostalCode}} {{:visitingCity}}</span>
				</label>
			</div>
		</fieldset>
	</li>
</script>
<script id="emptyLocationTemplate" type="text/x-jsrender">
	{{if ~hasDefault }}
	<li style="margin-left: -1.5em;">
		<div class="emptyTitle">
			<div class="panel panel-warning">
				<div class="panel-body">
					{/literal}{$Text.CHECKOUT_STEP_TWO_DROPPOINT_NONE}{literal}
				</div>
			</div>
		</div>
	</li>
	<li class="radio">
		<fieldset class="form-group">
			<div class="input-group">
				<span class="input-group-addon">
					<input id="{{:input}}_random" type="radio" name="{{:input}}" class="radiobtn" value="" checked="checked" />
				</span>
				<label for="{{:input}}_random" class="form-label input-group-main">
					<span class="is-block">{{:text}}</span>
				</label>
			</div>
		</fieldset>
	</li>
	{{else}}
	<li style="margin-left: -1.5em;">
		<div class="emptyTitle">
			<div class="panel panel-warning">
				<div class="panel-body">
					{/literal}{$Text.CHECKOUT_STEP_TWO_DROPPOINT_NONE}{literal}
				</div>
			</div>
		</div>
	</li>
	{{/if}}
</script>
{/literal}
<div class="deliveryMethodNotFound">{$Text.CHECKOUT_STEP_TWO_METHODS_NONE}</div>
<div class="deliveryMethodContainerMain"></div>

{if $settings.checkout_delivery_datetime}
{addScript src='modules/checkout/includes/js/cleave.min.js'}
<div class="deliveryTimeContainer">
	<hr>
	<label class="form-label"><strong>{$Text.CHECKOUT_STEP_TWO_TIME_OF_DELIVERY}</strong></label>

	<fieldset id="m-checkout-del-date" class="form-group">
		<label class="form-label" for="m-checkout-del-date">{$Text.CHECKOUT_STEP_TWO_DELIVERY_DATE}</label>
		<div class="input-group small">
			<span class="input-group-addon"><i class="fa fa-fw fa-calendar"></i></span>
			<input type="date" id="deliveryDate" class="form-input" name="deliveryDate" value="{$returnPostData.deliveryDate}" min="{$now|date_format:"%Y-%m-%d"}">
		</div>
	</fieldset>

	<fieldset id="m-checkout-del-time" class="form-group">
		<label class="form-label" for="m-checkout-del-time">{$Text.CHECKOUT_STEP_TWO_DELIVERY_TIME}</label>
		<input type="time" id="deliveryTime" class="form-input" name="deliveryTime" value="{$returnPostData.deliveryTime}" placeholder="{$Text.CHECKOUT_STEP_TWO_DELIVERY_TIME}">
	</fieldset>
</div>
{/if}

<div class="deliveryMethodNote">
	<hr>
	<fieldset id="m-checkout-del-comment" class="form-group">
		<label class="form-label" for="m-checkout-del-comment">{$Text.CHECKOUT_STEP_TWO_COMMENT}</label>
		<textarea class="form-input" name="customerNotice" id="customerNotice" placeholder="{$Text.CHECKOUT_STEP_TWO_COMMENT}" style="min-height: 140px;">{$returnPostData.customerNotice}</textarea>
	</fieldset>
</div>
<div class="deliveryMethodNote is-hidden" data-js="customernoticedelivery">
	<div class=" panel panel-default">
		<div class="panel-heading">
			<fieldset class="form-group m-checkout-deliverymessage">
				<label class="form-label" style="font-weight:bold;" for="m-checkout-deliverymessage">{$Text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY}</label>
				<textarea class="form-input" name="customerNoticeDelivery" id="customerNoticeDelivery" placeholder="{$Text.CHECKOUT_STEP_TWO_COMMENT_DELIVERY}" style="min-height: 55px;">{$returnPostData.customerNoticeDelivery}</textarea>
			</fieldset>
		</div>
	</div>
</div>
