;(function ($, eksport, undefined) {
    'use strict';

    // ==========================================================================
    // Variant Prototype
    // ==========================================================================

    var Variant = function(product) {
        var self = this;
        this.product = product;
    };

    Variant.prototype = {

        //
        // Init function
        //

        init: function () { },

        canDoActions: function () {
            return true;
        }
    };

    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.variant = eksport.platform.classes.variant || {};
    eksport.platform.classes.variant.Orderlist = Variant;
})(jQuery, window);
