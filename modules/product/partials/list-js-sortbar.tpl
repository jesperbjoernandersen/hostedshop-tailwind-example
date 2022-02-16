{*

# Description
AngularJS template for Javascript sorting of products. Part of the Product page type.


## Date last modified
2021-02-09


## Resource
+ [AngularJS](https://angularjs.org/)


## Primary variables
+ orderProp                                                 - AngularJS model with order options (price, most bought ...) based on shop settings
+ limitProp                                                 - AngularJS model with limit options (items pr. page) based on shop settings
+ items                                                     - Collection of products based on: category, filter and sorting
+ text                                                      - Javascript version of Smarty $text with an array of translations


## Partials (templates)
No extra templates required for this template

*}

{literal}
<div class="productsortbar product-scroll-target is-hidden-print trailing" data-ng-hide="empty || (orderOptions.length < 2 && (!limitOptions.length || amount < limitOptions[0].amount) && !settings.module_shop_productlist_allow_switch && maxPage < 2)">

	<div class="sortbar-body trailing-trip" data-group="panel-sorting">
		<div class="trailing is-hidden-s clearfix">

			<span class="amount-display" data-ng-bind-html="amountText() || text.PRODUCT_CATALOG_PRODUCTS +': '+ amount"></span>

			<span class="sortbar-content">
				<fieldset class="is-inline-block productlist-display" data-ng-if="settings.module_shop_productlist_allow_switch" data-ng-style="{'max-width':'90px'}">
                    <div data-ng-class="{'active': typeId == 1}" class="input-group-button"><button class="button is-block" data-ng-click="changeType(1)">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-row"><path d="M4,2h16c1.1,0,2,0.9,2,2v4c0,1.1-0.9,2-2,2H4c-1.1,0-2-0.9-2-2V4C2,2.9,2.9,2,4,2z"/><path d="M4,14h16c1.1,0,2,0.9,2,2v4c0,1.1-0.9,2-2,2H4c-1.1,0-2-0.9-2-2v-4C2,14.9,2.9,14,4,14z"/></svg>
                    </button></div>
                    <div data-ng-class="{'active': typeId == 2}" class="input-group-button"><button class="button is-block" data-ng-click="changeType(2)">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-columns"><path d="M12 3h7a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-7m0-18H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7m0-18v18"></path></svg>
                    </button></div>
				</fieldset>

				<div class="sortbar-selects">
					<fieldset data-ng-show="orderOptions.length > 1" class="form-group sortbar-select">
						<label for="option-orderby" class="ng-pristine ng-valid ng-touched" data-ng-style="{'border':'none'}">
							<select id="option-orderby" class="form-input is-block" name="option-orderby" data-ng-change="changeOrder()" data-ng-model="orderProp" data-ng-options="option.id as option.title for option in orderOptions"></select>
						</label>
					</fieldset>

					<fieldset class="form-group" data-ng-show="limitOptions.length > 1 && hasAmountDropdown() || !hasAmountDropdown">
						<label for="option-limit" class="form-input list-order" data-ng-onclick="limitProp" data-ng-style="{'border':'none'}">
							<select id="option-limit" name="option-limit" data-ng-change="changeLimit()" data-ng-model="limitProp" data-ng-options="limit.amount as limit.title for limit in limitOptions"></select>
						</label>
					</fieldset>
				</div>
			</span>

		</div>

		<!-- MOBILE DISPLAY -->
		<div class="row is-hidden-m is-hidden-l is-hidden-xl trailing">

			<div data-ng-show="orderOptions.length > 1" class="col-s-2 trailing">
				<fieldset class="form-group">
					<label for="option-orderby-mobile" class="form-label" data-ng-bind-html="::text.PRODUCT_CATALOG_ORDER_BY_TEXT"></label>
					<select id="option-orderby-mobile" name="option-orderby-mobile" class="form-input form-select" data-ng-change="changeOrder()" data-ng-model="orderProp" data-ng-options="option.id as option.title for option in orderOptions"></select>
				</fieldset>
			</div>

			<div data-ng-show="limitOptions.length > 1 && hasAmountDropdown() || !hasAmountDropdown" class="col-s-2 trailing">
				<fieldset class="form-group">
        			<label for="option-limit-mobile" class="form-label" data-ng-bind-html="::text.PRODUCT_CATALOG_LIMIT_TEXT">Sorter efter:</label>
					<select name="option-limit-mobile" id="option-limit-mobile" class="form-input form-select" data-ng-change="changeLimit()" data-ng-model="limitProp" data-ng-options="limit.amount as limit.title for limit in limitOptions"></select>
				</fieldset>
			</div>

			<div class="col-s-4">
				<span class="amount-display" data-ng-bind-html="amountText() || text.PRODUCT_CATALOG_PRODUCTS +': '+ amount"></span>
			</div>

		</div>

	</div>
</div>
{/literal}
