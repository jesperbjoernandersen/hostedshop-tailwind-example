;(function ($, eksport, undefined) {
    'use strict';

    var VARIANT_TYPE = "preselect",
        VARIANT_TYPE_SELECTOR = "[data-variantType='"+ VARIANT_TYPE +"']";




    // ==========================================================================
    // Variant Prototype
    // ==========================================================================

    var Variant = function(product) {
        var self = this;

        this.API = {

            // product variant from datas
            variant     : "/json/productvariants/{productId}"
        };

        this.product = product;
        this.hasVariant = false;
        this.variant = null;
    };




    Variant.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this,
                variantId = $(VARIANT_TYPE_SELECTOR).data('variantId');

            if (variantId) {
                self.getVariant(variantId, function(variant) {
                    if (variant !== undefined) {
                        self.hasVariant = true;
                        self.variant = variant;
                        self.handleSelected(self.variant);
                    }
                });
            }
        },




        getVariant : function (variantId, cb) {
            var self = this;

            if (typeof cb !== "function") return;

            self.tries = self.tries + 1;
            $.get(this.API.variant.replace("{productId}", self.product.Id))
                .done(function( data ) {
                    if (data.count) {
                        _.forEach(data.data, function (value) {
                            if (value.Id == variantId) {
                                self.item = value;
                                return false;
                            }
                        });
                    }
                    $.extend(self, self.item);
                    cb( self.item );
                })
                .fail(function () {
                    self.item = undefined;
                    cb( self.item );
                });
        },




        handleSelected : function (variant) {
            window.platform.publish("/product/variant/selected", [variant]);
        },




        canDoActions : function () {
            var self = this;
            return self.hasVariant && self.variant && (self.variant.Stock >= self.variant.MinAmount || (self.variant.Stock < self.variant.MinAmount && self.variant.AllowOutOfStockPurchase));
        }
    };





    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.variant = eksport.platform.classes.variant || {};
    eksport.platform.classes.variant.Preselect = Variant;
})(jQuery, window);
