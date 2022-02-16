;(function ($, eksport, undefined) {
    'use strict';

    // ==========================================================================
    // Product Prototype
    // ==========================================================================

    var Product = function(id) {
        var self = this;
        this.id = id;
        this.tries = 0;
        this.version = 20191219;

        this.API = {
            product : "/json/products/id/{productId}"
        };


        this.selectors = {
            unitTitle               : "[data-controller='unittitle']",
            input                   : "[data-controller='input']",
            amount                  : "[data-controller='amount']",
            panel                   : "[data-controller='infoPanel']",
            descriptionShort        : "[data-controller='description--short']",
            description             : "[data-controller='description']",
            descriptionWrap         : "[data-controller='description--wrap']",
            descriptionWrapShort    : "[data-controller='description--wrap-short']",
            tmpl                    : "#entity-js-infopanel"
        }


        // Get used elements from DOM
        this.$input                 = $(this.selectors.input);
        this.$amount                = $(this.selectors.amount);
        this.$panel                 = $(this.selectors.panel);
        this.$unitTitle             = $(this.selectors.unitTitle);
        this.$descShort             = $(this.selectors.descriptionShort);
        this.$descWrap              = $(this.selectors.descriptionWrap);
        this.$descWrapShort         = $(this.selectors.descriptionWrapShort);
        this.$desc                  = $(this.selectors.description);


        // Save original data
        this.originalUnitTitle      = this.$unitTitle.html();
        this.originalPanel          = this.$panel.html();
        this.descContent            = this.$desc.html();
        this.descShortContent       = this.$descShort.html();
    };


    Product.prototype = {
        get : function(cb) {

            if (!this.id) {
                return;
            }

            var self = this;
            self.tries = self.tries + 1;

            $.get(this.API.product.replace("{productId}", this.id))
                .done(function( data ) {
                    self.item = (data.amount && data.products) ? data.products[0] : undefined;
                    $.extend(self, self.item);
                    cb( self.item );
                })
                .fail(function () {
                    if (self.tries < 3) {
                        self.get(self.id);
                    } else {
                        self.item = undefined;
                        cb( self.item );
                    }
                });
        },




        showWarning : function(stop) {
            var self = this,
                panel = this.$panel.find(".panel");

            if ( panel.length ) {
                panel
                    .css({
                        "-webkit-transition": "opacity 0.24s ease-in-out",
                        "-moz-transition": "opacity 0.24s ease-in-out",
                        "transition": "opacity 0.24s ease-in-out"
                    })
                    .removeClass("panel-warning").addClass("panel-danger");

                setTimeout( function () {
                    panel.removeClass("panel-danger").addClass("panel-warning");

                    if (!stop) {
                        self.showWarning(true);
                    }
                }, 600);
            }
        },




        updateUnitTitle : function (variant, reset) {
            var self = this;

            if (reset) {
                self.$unitTitle.html(self.originalUnitTitle);
            } else {
                self.$unitTitle.html(variant.UnitTitle);
            }
        },




        updatePanel : function (variant, reset) {
            var self = this,
                data = {},
                helpers = {};

            if (!self.$panel.length) {
                return;
            }

            if (reset) {
                self.$panel.html(self.originalPanel);
                self.$panel.removeClass("open");
                return;
            }

            data.product = self;
            data.selected = variant;

            helpers.version = this.version;
            helpers.hidePrice = window.platform.product.Type === 'discontinued'
                || window.platform.product.CallForPrice
                || ( window.platform.getSetting("shop_b2b_hidden_prices") === true && !window.platform.user );
            helpers.hasVat = window.platform.currency.hasVat;
            helpers.showPrice = (!helpers.hidePrice && !!variant.Price && variant.Price.PriceMin !== "undefined");
            helpers.staticdomain = window.platform.template.cdn;

            var infoPanelTmpl = $.templates(this.selectors.tmpl);
            var html = infoPanelTmpl.render(data, helpers);

            self.$panel.html(html);
            self.$panel.addClass("open");
        },





        updatePacketPanel : function (item, reset) {
            var self = this,
                data = {},
                helpers = {},
                html = "";

            if (!self.$panel.length) {
                return;
            }

            if (reset) {
                self.$panel.html(self.originalPanel);
                self.$panel.removeClass("open");
                return;
            }

            if (window.platform.getSetting("shop_product_delivery_time")) {
                data.selected = $.extend({}, item);
                html = $.templates("#entity-js-stock").render(data, helpers);
            } else {
                var tmpl = $.templates('#entity-packet-selected');

                if (!tmpl) {
                    self.$panel.remove();
                    return;
                }

                html = tmpl.render(data, helpers);
            }

            self.$panel.html(html).addClass("open");

        },




        updateInputs : function (item, reset) {
            var self = this;

            if (reset) {
                self.$input.length && self.$input.val(self.$input.prop("defaultValue"));
                self.$amount.length && self.$amount.val(self.$amount.prop("defaultValue"));
            } else {
                self.$input.length && self.$input.val(item.Id);
                self.$amount.length && self.$amount.val(item.MinAmount);
            }
        },




        updateDescriptions : function (item, reset) {
            var self = this,
                newDesc,
                newDescShort;

            self.$descWrap.length && self.$descWrap.addClass("is-hidden");
            self.$descWrapShort.length && self.$descWrapShort.addClass("is-hidden");

            if (reset) {
                newDesc = self.descContent;
                newDescShort = self.descShortContent;
            } else {
                newDesc = item.Description && item.Description.length ? item.Description : self.descContent;
                newDescShort = item.DescriptionShort && item.DescriptionShort.length ? item.DescriptionShort : self.descShortContent;
            }

            self.$desc.length && self.$desc.html(newDesc);
            self.$descShort.length && self.$descShort.html(newDescShort);

            self.$descWrap.length && newDesc.trim().length && self.$descWrap.removeClass("is-hidden");
            self.$descWrapShort.length && newDescShort.trim().length && self.$descWrapShort.removeClass("is-hidden");
        }
    };







    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.Product = Product;
})(jQuery, window);
