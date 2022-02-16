;(function($, exports) {

    "use strict";

    angular
        .module('platform-app', [
            'ngSanitize',
            'ngRoute',
            'platformDirectives',
            'platformFilters',
            'productlistApp',
            'topProductsApp',
            'pageControllers'
        ])
        .config(['$locationProvider', '$sceDelegateProvider', '$compileProvider', function($locationProvider, $sceDelegateProvider, $compileProvider) {
            $locationProvider.html5Mode({
                enabled: !!(!platform.page.isProduct || platform.page.productId),
                requireBase: false,
                rewriteLinks: false
            }).hashPrefix('!');

            $sceDelegateProvider.resourceUrlWhitelist([
               // Allow same origin resource loads.
               'self',
               // Allow loading from our assets domain.  Notice the difference between * and **.
               exports.platform.template.cdn + '/**'
            ]);

            $compileProvider.debugInfoEnabled(false);
        }]);

    //pageControllers for widgets
    angular.module('pageControllers', []);

})(jQuery, window);
