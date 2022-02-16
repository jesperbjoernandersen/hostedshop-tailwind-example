;(function ($, platform) {

	"use strict";

	var app = angular.module('productlistDirectives', ['platformFilters']);

    app.directive('deliveryText',
        function() {
            return {
                strict: 'A',
                template: "<i data-ng-show=\"settings.shop_product_delivery_time == 'texticon' || deliveryId < 1\" class=\"fa fa-fw\" data-ng-class=\"{'fa-clock-o': isSoldout, 'fa-check': !isSoldout}\"></i><span data-ng-bind-html=\"deliveryText\"></span> <span class=\"stockAmount\" data-ng-if=\"!stockIsNaN && deliveryId == 0 && hasChosenVariant && !isSoldout && product.Type !== 'packet'\">({{stock}} {{unitTitle}})</span>"
            }
        }
    );

    app.directive('variantAjax', ['$rootScope', '$filter',
        function ($rootScope, $filter) {
            return {
                strict: 'A',
                scope: {
                    productId: '=variantAjax',
                    variantDefault: '=',
                    hidePrice: '=',
                    imageWidth: '=',
                    imageHeight: '=',
                    imageCrop: '='
                },
                link: function (scope, element, attrs) {

                    var selflink = this;

                    function getColor(t) {
                        var self = this,
                            color,
                            tmpl = "<span class='fa fa-square' style='{{color}}'></span> ";

                        if (t.length >= 3) {
                            color = t[2];
                        }
                        if (!color) {
                            return "";
                        }

                        if (color.toLowerCase() === "ffffff") {
                            color = "color:#" + color + ";border-radius:3px;border:1px solid #888;";
                        }
                        else if (color) {
                            color = "color:#" + color + ";";
                        }

                        return tmpl.replace("{{color}}", color);
                    }

                    $(element).select2({
                        placeholder: scope.variantDefault,
                        ajax: {
                            url: "/json/productvariants/" + scope.productId,
                            data: function () {
                                return {
                                    imageWidth: scope.imageWidth,
                                    imageHeight: scope.imageHeight,
                                    imageCrop: scope.imageCrop
                                };
                            },
                            dataType: 'json',
                            cache: true,
                            results: function (data, page) {
                                return {results: data.data};
                            }
                        },
                        id: 'Id',
                        minimumResultsForSearch: -1,
                        formatResult: function(item) {

                            // Hide if out of stock
                            if (item.Stock < item.MinAmount && item.DisableOnEmpty) return "";

                            var html = '<div class="row">';

                            // Show price
                            //var showPrice = (!scope.hidePrice && typeof item.Price.PriceMin !== 'undefined');
                            var showPrice = false;

                            // Title
                            if (showPrice) {
                                html += '<div class="col-s-4 col-m-8 col-l-8 col-xl-16">';
                            } else {
                                html += '<div class="col-s-4 col-m-12 col-l-12 col-xl-24">';
                            }
                            if (item.TitleCombination.length == 1) {
                                html += '<div>' + getColor(item.TitleCombination[0]) + $filter('decode')(item.Title) + '</div>';
                            } else {

                                for (var i = 0; i < item.TitleCombination.length; i++) {
                                    var t = item.TitleCombination[i];
                                    html += '<div><small>' + t[0] + ':</small> <span>' + getColor(t) + $filter('decode')(t[1]) + '</span></div>';
                                }
                            }

                            if (item.disabled) {
                                html += '<div><i class="panel-danger" style="background-color:transparent;">' + $filter('decode')(window.text.SOLD_OUT) + '</i></div>';
                            }

                            html += '</div>';

                            // Price
                            if (showPrice) {
                                html += '<div class="col-s-4 col-m-4 col-l-4 col-xl-8"><small>' + $filter('currency_format')(item.Price.PriceMin) + '</small></div>';
                            }

                            html += '</div>';

                            return html;
                        },
                        formatSelection: function(item) {
                            var self = this,
                                color = "";

                            // build title and variants
                            for (var i = 0; i < item.TitleCombination.length; i++) {
                                var t = item.TitleCombination[i];
                                color += getColor(t);
                            }

                            return color + $filter('decode')(item.Title);
                        },
                        formatSearching: function() {
                            return '<img class="spinner" alt src="' + platform.template.cdn + '/_design/common/img/ajax-loader-bar.gif">';
                        }
                    })
                    .on('select2-selecting', function(e) {
                        $rootScope.$broadcast( 'update.product' + scope.productId, e.object );
                    });
                }
            }
        }]
    );

    app.directive('raty', [
        function() {
            return {
                strict: 'A',
                scope: {
                    score: '=raty',
                    readonly: '='
                },
                link: function (scope, element, attrs) {

                    if ( scope.score !== false ) {

                        $(element).raty({
                            score: scope.score,
                            readOnly: scope.readonly,
                            hints: ['', '', '', '', ''],
                            noRatedMsg: null
                        });
                    }
                }
            }
        }
    ]);

})(jQuery, platform);
