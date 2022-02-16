;(function($, exports) {

	"use strict";

	var app = angular.module('topProductsApp', ['productlistServices']);

	app.directive('printProducts',
		function () {
			return {
				strict: 'A',
				scope: {
					printProducts: '=',
					pageSize: '='
				},
				templateUrl: function(elem, attrs) {
					return attrs.templateUrl;
				},
				controller: ['$scope', '$attrs', 'ProductApi',
					function($scope, $attrs, ProductApi) {
						$scope.spinner = window.platform.template.cdn + '/_design/common/img/preloader/preloader-black.gif';
						var options = {
							field: 'orderBy',
							id: $attrs.printProducts,
							limit: $attrs.pageSize,
							filterGenerate: 'true',
							forTopList: 'true'
						};
						ProductApi.productlist.query(options,
							function (data) {
								if (data.amount && data.products) {
									$scope.products = data.products;
								}
								$scope.loaded = true;
							});
					}
				]
			}
		}
	);

	app.controller('top-products-ctrl', ['$scope', '$attrs',
		function ($scope, $attrs) {

			$scope.pageSize = $attrs.pageSize;
			$scope.text = window.text;

			$scope.box1 = platform.template.settings.MODULEBOX_TOPTEN_SHOW_NEW || false;
			$scope.box2 = platform.template.settings.MODULEBOX_TOPTEN_SHOW_BOUGHT || false;
			$scope.box3 = platform.template.settings.MODULEBOX_TOPTEN_SHOW_OFFERS || false;
			var boxCount = 0;

			if ($scope.box3) {
				$scope.active = 3;
				boxCount++;
			}
			if ($scope.box2) {
				$scope.active = 2;
				boxCount++;
			}
			if ($scope.box1) {
				$scope.active = 1;
				boxCount++;
			}

			$scope.boxCount = boxCount;

		}
	]);

})(jQuery, window);