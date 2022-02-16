{*

# Description
AngularJS template for Javascript filtering of products. Part of the Product page type.


## Date last modified
2021-06-18


## Resource
+ [AngularJS](https://angularjs.org/)


## Primary variables
+ filterSelected                                            - AngularJS model with all selected filter data (price, brand, category ...)
+ text                                                      - Javascript version of Smarty $text with an array of translations


## Partials (templates)
No extra templates required for this template

*}

{literal}
<div class="productfilter panel panel-border ng-hide is-hidden-print" data-ng-show="showFilter" data-ng-element-ready="triggerEvent('filterloaded')">
    <div class="panel-heading">
        <div class="row">
            <div class="col-s-3 col-m-8 col-l-8 col-xl-16">
                <span class="h5" data-ng-bind-html="::text.PRODUCT_CATALOG_FILTER"></span>
            </div>
            <div class="col-s-1 col-m-4 col-l-4 col-xl-8">
                <button type="submit" class="filter-collapse-btn button xsmall pull-right" data-ng-click="reCalcSlider()" data-toggle="collapse" data-class="is-collapsed" data-target="panel-filter" data-state='true'>
                    <span class="icon-close">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-up"><polyline points="18 15 12 9 6 15"></polyline></svg>
                    </span>
                    <span class="icon-open">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-down"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </span>
                </button>
            </div>
        </div>
    </div>
    <div class="panel-body" data-group="panel-filter">
        <div class="row">
            <div class="col-s-4 col-m-6 col-l-12 col-xl-24 m-filter-search" data-ng-show="filterMap.search.show">
                <!-- Free range search -->
                <label class="form-label" data-ng-bind-html="::text.SEARCH_LONG"></label>
                <fieldset class="form-group">
                    <input class="form-input small" type="text" placeholder="{{::searchText}}" data-ng-model="filterSelected.search" data-ng-change="searchChanged = true">
                </fieldset>
            </div>
            <div class="col-s-4 col-m-6 col-l-12 col-xl-24 m-filter-price" data-ng-show="::filterMap.prices && filterMap.prices.show && (filterMap.prices.data.low || filterMap.prices.data.high)">
            	<!-- Price range -->
                <label class="form-label" data-ng-bind-html="::text.PRODUCT_CATALOG_FILTER_PRICE"></label>
                <rzslider rz-slider-floor="filterMap.prices.data.low" rz-slider-ceil="filterMap.prices.data.high" rz-slider-model="filterSelected.minPrice" rz-slider-high="filterSelected.maxPrice" rz-slider-translate="( version >= 20170711 ? currency_format_decode : currency_format )"></rzslider>
            </div>
        </div>

    	<!-- Brands and secondary categories -->
    	<div class="row">

    		<!-- Brands -->
    		<div class="col-s-4 col-m-6 col-l-12 col-xl-24" data-ng-show="::filterMap.brands.show && filterMap.brands.data.length > 0" data-ng-switch data-on="filterMap.brands.show">
                <label class="form-label" data-ng-bind-html="::text.MANUFACTUERER"></label>
                <div data-ng-switch-default>
                    <fieldset class="form-group" data-ng-repeat="data in filterMap.brands.data | orderBy:'title' track by data.id">
                        <label class="input-group small">
                            <span class="input-group-addon">
                                <input type="checkbox" checklist-model="filterSelected.brand" checklist-value="data.id" data-ng-disabled="data.disabled" checklist-change="state('brands')">
                            </span>
                            <span class="form-label input-group-main" data-ng-class="{'is-disabled':data.disabled}" data-ng-bind-html="data.title"></span>
                        </label>
                    </fieldset>
                </div>

                <div data-ng-switch-when="select" class="multiple_select trailing">
                    <span data-ng-click="brandToggle = !brandToggle" class="button small" data-ng-bind-html="multipleSelectTitle(filterMap.brands.data, filterSelected.brand) || text.CHOOSE"></span>
                    <div class="multiple_select-dropdown" data-ng-class="{'open' : brandToggle}">
                        <div class="multiple_select-dropdown-blur" data-ng-show="brandToggle" data-ng-click="brandToggle = !brandToggle"></div>
                        <div class="checklist">
                            <div class="checklist-header is-hidden-m is-hidden-l is-hidden-xl">
                                <strong data-ng-bind-html="::text.MANUFACTUERER"></strong>
                            </div>
                            <div class="checklist-body">
                                <fieldset class="form-group" data-ng-repeat="data in filterMap.brands.data | orderBy:'title' track by data.id">
                                    <label class="checkbox">
                                        <input type="checkbox" checklist-model="filterSelected.brand" checklist-value="data.id" data-ng-disabled="data.disabled" checklist-change="state('brands')">
                                        <span class="checkbox-checkmark"></span>
                                        <span class="checkbox-text" data-ng-class="{'is-disabled':data.disabled}" data-ng-bind-html="data.title"></span>
                                    </label>
                                </fieldset>
                            </div>
                            <div class="checklist-footer row">
                                <strong class="checklist-footer-reset" data-ng-click="version >= 20191004 ? clearSelect('brand') : clearFilter('brand')">{{filterSelected.brand.length ? text.PRODUCT_CATALOG_FILTER_RESET : ''}}</strong>
                                <strong class="checklist-footer-close text-right" data-ng-click="brandToggle = !brandToggle" data-ng-bind-html="::text.CONFIRM"></strong>
                            </div>
                        </div>
                    </div>
                </div>
    		</div>

    		<!-- Secondary categories -->
    		<div class="col-s-4 col-m-6 col-l-12 col-xl-24" data-ng-show="::filterMap.categories.show && filterMap.categories.data.length > 0" data-ng-switch data-on="filterMap.categories.show">
                <label class="form-label" data-ng-bind-html="::text.CATEGORYS"></label>
                <div data-ng-switch-default>
                    <fieldset class="form-group" data-ng-repeat="data in filterMap.categories.data | orderBy:'title' track by data.id">
                        <label class="input-group small">
                            <span class="input-group-addon">
                                <input type="checkbox" checklist-model="filterSelected.categories" checklist-value="data.id" data-ng-disabled="data.disabled" checklist-change="state('categories')">
                            </span>
                            <span class="form-label input-group-main" data-ng-class="{'is-disabled':data.disabled}" data-ng-bind-html="data.title"></span>
                        </label>
                    </fieldset>
                </div>

                <div data-ng-switch-when="select" class="multiple_select trailing">
                    <span data-ng-click="categoryToggle = !categoryToggle" class="button small" data-ng-bind-html="multipleSelectTitle(filterMap.categories.data, filterSelected.categories) || text.CHOOSE"></span>
                    <div class="multiple_select-dropdown" data-ng-class="{'open' : categoryToggle}">
                        <div class="multiple_select-dropdown-blur" data-ng-show="categoryToggle" data-ng-click="categoryToggle = !categoryToggle"></div>
                        <div class="checklist">
                            <div class="checklist-header is-hidden-m is-hidden-l is-hidden-xl">
                                <strong data-ng-bind-html="::text.CATEGORYS"></strong>
                            </div>
                            <div class="checklist-body">
                                <fieldset class="form-group" data-ng-repeat="data in filterMap.categories.data | orderBy:'title' track by data.id">
                                    <label class="checkbox">
                                        <input type="checkbox" checklist-model="filterSelected.categories" checklist-value="data.id" data-ng-disabled="data.disabled" checklist-change="state('categories')">
                                        <span class="checkbox-checkmark"></span>
                                        <span class="checkbox-text" data-ng-class="{'is-disabled':data.disabled}" data-ng-bind-html="data.title"></span>
                                    </label>
                                </fieldset>
                            </div>
                            <div class="checklist-footer row">
                                <strong class="checklist-footer-reset" data-ng-click="version >= 20191004 ? clearSelect('categories') : clearFilter('categories')">{{filterSelected.categories.length ? text.PRODUCT_CATALOG_FILTER_RESET : ''}}</strong>
                                <strong class="checklist-footer-close text-right" data-ng-click="categoryToggle = !categoryToggle" data-ng-bind-html="::text.CONFIRM"></strong>
                            </div>
                        </div>
                    </div>
                </div>
    		</div>
        </div>

    	<!-- Variants and custom data -->
        <div class="row">
			<div class="col-s-4 col-m-6 col-l-12 col-xl-24" data-ng-repeat="dataGroup in filterMap.data | orderBy:['sorting','title'] track by dataGroup.id" data-ng-show="dataGroup.show && (dataGroup.data.length || (dataGroup.show == 'range' && (dataGroup.data.low || dataGroup.data.high)))" data-ng-switch data-on="dataGroup.show">
				<label class="form-label" data-ng-bind-html="dataGroup.title"></label>
				<div data-ng-switch-default>
					<fieldset class="form-group" data-ng-repeat="value in dataGroup.data | orderBy:['sorting','title'] track by value.id">
						<label class="input-group small">
					        <span class="input-group-addon">
					        	<input type="checkbox" checklist-model="filterSelected.data[dataGroup.id]" checklist-value="value.id" data-ng-disabled="value.disabled" checklist-change="state(dataGroup.id)">
					        </span>
					        <span class="form-label input-group-main" data-ng-class="{'is-disabled':value.disabled}">
                                <span data-ng-show="value.color" class="checkbox-color" data-ng-style="value.color && {'background-color':value.color}"></span>
                                {{value.title}}
                            </span>
					    </label>
					</fieldset>
				</div>

                <div data-ng-switch-when="select" class="multiple_select trailing">
                    <span data-ng-click="variantToggle = !variantToggle" class="button small" data-ng-bind-html="multipleSelectTitle(dataGroup.data, filterSelected.data[dataGroup.id]) || text.CHOOSE"></span>
                    <div class="multiple_select-dropdown" data-ng-class="{'open' : variantToggle}">
                        <div class="multiple_select-dropdown-blur" data-ng-show="variantToggle" data-ng-click="variantToggle = !variantToggle"></div>
                        <div class="checklist">
                            <div class="checklist-header is-hidden-m is-hidden-l is-hidden-xl">
                                <strong data-ng-bind-html="dataGroup.title"></strong>
                            </div>
                            <div class="checklist-body">
                                <fieldset class="form-group" data-ng-repeat="value in dataGroup.data | orderBy:['sorting','title'] track by value.id">
                                    <label class="checkbox">
                                        <input type="checkbox" checklist-model="filterSelected.data[dataGroup.id]" checklist-value="value.id" data-ng-disabled="value.disabled" checklist-change="state(dataGroup.id)">
                                        <span class="checkbox-checkmark"></span>
                                        <span data-ng-show="value.color" class="checkbox-color" data-ng-style="value.color && {'background-color':value.color}"></span>
                                        <span class="checkbox-text" data-ng-class="{'is-disabled':value.disabled}">
                                            {{value.title}}
                                        </span>
                                    </label>
                                </fieldset>
                            </div>
                            <div class="checklist-footer row">
                                <strong class="checklist-footer-reset" data-ng-click="version >= 20191004 ? clearSelect(dataGroup.id) : clearFilter(dataGroup.id)">{{filterSelected.data[dataGroup.id].length ? text.PRODUCT_CATALOG_FILTER_RESET : ''}}</strong>
                                <strong class="checklist-footer-close text-right" data-ng-click="variantToggle = !variantToggle" data-ng-bind-html="::text.CONFIRM"></strong>
                            </div>
                        </div>

                    </div>
                </div>

				<div data-ng-switch-when="range">
                    <rzslider rz-slider-floor="dataGroup.data.low" rz-slider-ceil="dataGroup.data.high" rz-slider-model="filterSelected.data[dataGroup.id].from" rz-slider-high="filterSelected.data[dataGroup.id].to" rz-slider-options="filterSelected.data[dataGroup.id]" data-group-unit="{{dataGroup.data.unit}}" rz-slider-translate="rzTranslate"></rzslider>
				</div>
			</div>
    	</div>

        <hr>

        <!-- Toggle news and sale -->
        <div class="row">
            <div class="col-s-4 col-m-6 col-l-6 col-xl-12" data-ng-show="filterMap.new.show">
                <fieldset class="form-group">
                    <label class="input-group small">
                        <span class="input-group-addon">
                            <input type="checkbox" id="filter-shownews" data-ng-model="filterSelected.news" data-ng-change="state('news')" data-ng-disabled="filterMap.new.disabled">
                        </span>
                        <span class="form-label input-group-main" data-ng-class="{'is-disabled':filterMap.new.disabled}" data-ng-bind-html="::text.NEWS"></span>
                    </label>
                </fieldset>
            </div>
            <div class="col-s-4 col-m-6 col-l-6 col-xl-12" data-ng-show="filterMap.sale.show">
                <fieldset class="form-group">
                    <label class="input-group small">
                        <span class="input-group-addon">
                            <input type="checkbox" id="filter-showsale" data-ng-model="filterSelected.sale" data-ng-change="state('sale')" data-ng-disabled="filterMap.sale.disabled">
                        </span>
                        <span class="form-label input-group-main" data-ng-class="{'is-disabled':filterMap.sale.disabled}" data-ng-bind-html="::text.SALE"></span>
                    </label>
                </fieldset>
            </div>
        </div>
    </div>

    <!-- Control buttons -->
    <div class="panel-footer" data-group="panel-filter" data-ng-show="filterChanged">
    	<div class="row">
    		<div class="col-s-4 col-m-12 col-l-12 col-xl-24 text-right">
    			<button class="button small" data-ng-click="clearFilter()" data-ng-bind-html="::text.PRODUCT_CATALOG_FILTER_RESET"></button>
    		</div>
    	</div>
    </div>
</div>
{/literal}
