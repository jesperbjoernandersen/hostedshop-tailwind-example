;(function ($, platform) {
	
	"use strict";

	var app = angular.module('platformDirectives', ['platformFilters']);

    app.directive('repeatDone', function () {
        return function(scope, element, attrs) {
            if (scope.$last) { // all are rendered
                if (attrs.repeatDone) {
                    if (typeof attrs.repeatDone == "function") {
                        scope.$eval(attrs.repeatDone);
                    } else {
                        $(platform).trigger(attrs.repeatDone, element);
                    }
                }
            }
        }
    });

    app.directive('ngElementReady',
        function() {
            return {
                priority: Number.MIN_SAFE_INTEGER, // execute last, after all other directives if any.
                restrict: "A",
                link: function($scope, $element, $attributes) {
                    $scope.$eval($attributes.ngElementReady); // execute the expression in the attribute.
                }
            }
        }
    );

})(jQuery, platform);