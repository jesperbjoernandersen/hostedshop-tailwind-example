{*

# Description
Template for Top Products in a column box, the template is build with [AngularJS](https://angularjs.org/).


## Date last modified
2015-10-26


## Resource
+ [AngularJS](https://angularjs.org/)


## Primary variables
+ $pageSize                                                 - Shop setting that tells how many top products to show
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
+ "/modules/column/partials/topproducts.html"				- A [AngularJS](https://angularjs.org/) HTML template used to generate the list.

*}

{* Settings *}
{$pageSize = $template.settings.MODULEBOX_TOPTEN_COUNT}

{locateFile assign=topProductsTemplate file='modules/column/partials/topproducts.html'}

<div class="panel panel-border column-box b-topproducts ng-cloak" data-ng-cloak data-ng-controller="top-products-ctrl">
	<div class="panel-heading b-topproducts-header b-header">
		<span class="h5">{$text.TOP_TEN_HEADLINE}</span>
	</div>

	{if !$client.isCrawler}
		{literal}
		<div class="panel-body" data-ng-show="boxCount > 1">
			<ul class="nav nav-tabs b-topproducts-list">
				<li data-ng-show="box1" data-ng-class="{'active': active == 1}" class="b-topproducts-li b-topproducts-newest">
					<a data-ng-click="active = 1" href="" data-ng-bind-html="text.TOP_TEN_NEWEST"></a>
				</li>
				<li data-ng-show="box2" data-ng-class="{'active': active == 2}" class="b-topproducts-li b-topproducts-bought">
					<a data-ng-click="active = 2" href="" data-ng-bind-html="text.TOP_TEN_BOUGHT"></a>
				</li>
				<li data-ng-show="box3" data-ng-class="{'active': active == 3}" class="b-topproducts-li b-topproducts-offers">
					<a data-ng-click="active = 3" href="" data-ng-bind-html="text.TOP_TEN_OFFER"></a>
				</li>
			</ul>
		</div>
		{/literal}

		<div class="modules m-top-products">
			<div class="toggle-content" data-ng-switch data-on="active">
				<div data-ng-switch-default class="pane active b-topproducts-template b-topproducts-newest-template" id="top-products-pane1" data-print-products="Age" data-page-size="{$pageSize}" data-template-url="{$topProductsTemplate}"></div>
				<div data-ng-switch-when="2" class="pane active b-topproducts-template b-topproducts-bought-template" id="top-products-pane2" data-print-products="-Sold" data-page-size="{$pageSize}" data-template-url="{$topProductsTemplate}"></div>
				<div data-ng-switch-when="3" class="pane active b-topproducts-template b-topproduct-offers-template" id="top-products-pane3" data-print-products="OnSale" data-page-size="{$pageSize}" data-template-url="{$topProductsTemplate}"></div>
			</div>
		</div>
	{/if}
</div>
