{*

# Description
AngularJS template for paging of the product list. Part of the Product page type.


## Date last modified
2015-06-18


## Resource
+ [AngularJS](https://angularjs.org/)


## Primary variables
+ page 														- Number telling the current page displayed


## Partials (templates)
No extra templates required for this template

*}


{literal}
<div class="productpagination row ng-hide" data-ng-show="maxPage > 1">
	<div class="w-pagination widget text-center col-s-4 col-m-12 col-l-12 col-xl-24">
    	<ul class="pagination">
			<li data-ng-class="{'is-disabled': page == 1}">
				<a data-ng-href="{{link('prev')}}" href="" data-ng-click="version >= 20170706 ? nav($event, 'prev') : prevPage()"><i class="fa fa-angle-left"></i></a>
			</li>

			<li data-ng-repeat="n in range()"
				data-ng-class="{current: n == page}"
				data-ng-click="version >= 20170706 ? nav($event, n) : setPage()">
					<a data-ng-href="{{link(n)}}" href="" data-ng-bind="n">1</a>
			</li>

			<li data-ng-class="{'is-disabled': page == maxPage}">
				<a data-ng-href="{{link('next')}}" href="" data-ng-click="version >= 20170706 ? nav($event, 'next') : nextPage()"><i class="fa fa-angle-right"></i></a>
			</li>
		</ul>
	</div>
</div>
{/literal}
