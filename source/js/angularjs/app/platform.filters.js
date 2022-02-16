;(function (platform) {

	"use strict";

	var app = angular.module('platformFilters', ['ngSanitize']);

    app.filter('truncate', function () {
        return function (text, length, end) {
            if (isNaN(length))
                length = 10;

            if (end === undefined)
                end = "...";

            if (text.length <= length || text.length - end.length <= length) {
                return text;
            }
            else {
                return String(text).substring(0, length-end.length) + end;
            }

        };
    });

    app.filter('currency_format', function() {
        return platform.currency_format;
    });

    app.filter('currency_format_decode', [
        function () {
            return function (val) {
                var str = platform.currency_format(val);
                if (typeof str == "string" && str != "") {
                    var e = document.createElement('div');
                    e.innerHTML = str;
                    return e.childNodes[0].nodeValue;
                }
                return str;
            }
        }
    ]);

    app.filter('decode', function () {
        return function (str) {
            if (typeof str == "string" && str != "") {
                var e = document.createElement('div');
                e.innerHTML = str;
                return e.childNodes[0].nodeValue;
            }
            return str;
        };
    });

    app.filter('unsafe', ['$sce',
        function ($sce) {
            return function (val) {
                return $sce.trustAsHtml(val);
            };
        }
    ]);

})(window.platform);
