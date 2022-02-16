;(function ($, eksport, undefined) {
    'use strict';

    var VARIANT_TYPE = "orderlist-dropdown",
        VARIANT_TYPE_SELECTOR = "[data-variantType='"+ VARIANT_TYPE +"']";




    // ==========================================================================
    // Variant Prototype
    // ==========================================================================

    var Variant = function(product) {
        var self = this;

        this.API = {
            // product variantTypes
            types       : "/json/productvariants/types/{productId}",

            // product variantTypes with data
            typesData   : "/json/productvariants/types/{productId}?fields=data",

           // product variantDatas
            datas       : "/json/productvariants/data/{productId}",

            // product variantTypes with data
            typeData    : "/json/productvariants/data/{productId}?typeId={typeId}",

            // product variantTypes with data
            //typeDatas   : "/json/productvariants/data/{productId}?typeId={typeId}&dataIds={dataIds}",
            typeDatas   : "/json/productvariants/data/{productId}",

            // product variant from datas
            variant     : "/json/productvariants/{productId}"
        };

        this.variantTypes = [];
        this.hasVariant = false;
        this.product = product;
        this.tries = 0;
    };




    Variant.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this,
                $variants = $(VARIANT_TYPE_SELECTOR);

            $variants.each(function (idx) {
                var $this = $(this),
                    settings = {
                        $this       : $this,
                        product     : self.product
                    };

                var my_variantType = new VariantType(settings);
                my_variantType.init();
                self.variantTypes.push(my_variantType);
            });


            self.handleVariantSelected = $.proxy(self.handleVariantSelected, self);

            window.platform.subscribe("/variant/variantType/selected", self.handleVariantSelected);
        },




        //
        // Event handlers
        //

        handleVariantSelected : function (event,args) {
            var self = this;
            /**
             * args:
             *  0 : variant
             */

            if (args[0] && args[0].Id) {
                var variant = args[0];
                self.hasVariant = true;
                self.variant = variant;
                self.updateInput(true);
                window.platform.publish("/product/variant/selected", [self.variant]);
            } else {
                self.hasVariant = false;
                self.variant = undefined;
                self.updateInput(false);
                window.platform.publish("/product/variant/unselected");
            }
        },




        canDoActions : function () {
            var self = this;
            return self.hasVariant && self.variant && (self.variant.Stock >= self.variant.MinAmount || (self.variant.Stock < self.variant.MinAmount && self.variant.AllowOutOfStockPurchase));
        },




        updateInput : function (enable) {
            var self = this;
            $("[data-product='count']").prop("disabled", !enable);
        }
    };








    // ==========================================================================
    // VariantType Prototype
    // ==========================================================================

    var VariantType = function (args) {
        var self = this;

        this.API = {
            // product variantTypes with data
            //typeDatas   : "/json/productvariants/data/{productId}?typeId={typeId}&dataIds={dataIds}",
            variants   : "/json/productvariants/{productId}"
        };

        $.extend(this, args);
    };



    VariantType.prototype = {

        //
        // Init function
        //

        init : function () {
            var self = this;

            self.$this.select2({
                id          : "Id",
                placeholder : window.text.PRODUCT_CATALOG_PRODUCT_CHOOSE_VARIANT,
                minimumResultsForSearch: -1,
                ajax: {
                    url: self.API.variants.replace("{productId}", self.product.Id),
                    dataType: 'json',
                    results: function (data, page) {
                        self.types = data.data;
                        return {results: data.data};
                    }
                },
                formatResult : function(item) {
                    var tmpl = '<div class="row">{{title}}{{price}}</div><hr class="seperator is-visible-s">';
                    return tmpl
                        .replace("{{title}}", self.getTitle(item))
                        .replace("{{price}}", self.getPrice(item))
                        .replace("{{stock}}", self.getStock(item));
                },
                formatSelection : function(item) {
                    return "<div>"+ self.getSimpleTitle(item) +"</div>";
                },
                formatSearching : function() {
                    return '<img class="spinner" alt src="' + window.platform.template.cdn + '/_design/common/img/ajax-loader-bar.gif">';
                }
            });

            // listen for user has selected event
            self.$this.on('select2-selecting', {id: self.id}, function (e) {
                window.platform.publish("/variant/variantType/selected", [e.object]);
            });

            return self;
        },




        getGfx : function (item) {
            var self = this,
                color,
                tmpl = "<span class='fa fa-square' style='{{color}}'></span> ";

            // if no color defined for variant set to blank
            if ( !item[2] ) {
                return "";
            }

            color = "color:#"+item[2]+";";

            if ( item[2] && item[2].toLowerCase() === "ffffff" ) {
                color = color+";border-radius:3px;border:1px solid #888;";
            }

            return tmpl.replace("{{color}}", color);
        },




        getPrice : function (item) {
            var self = this,
                tmpl = '<div class="col-s-4 col-m-6 col-l-6 col-xl-12"><div class="text-right">{{price}}</div><div class="text-right">{{stock}}<div></div>',
                hidePrice = window.platform.product.Type === 'discontinued'
                || window.platform.product.CallForPrice
                || ( window.platform.getSetting("shop_b2b_hidden_prices") === true && !window.platform.user ),
                showPrice = (!hidePrice && !!item.Price && item.Price.PriceMin !== "undefined"),
                price = "";


            if (showPrice) {
                if (self.product.CallForPrice) {
                    price = window.text.PRODUCT_CATALOG_CALL_FOR_PRICE;
                } else {
                    price += window.platform.currency_format(item.Price.PriceMin);
                    price += self.getMinAmount(item);
                }
            }

            return tmpl.replace("{{price}}", price);
        },




        getStock : function (item) {
            var self    = this,
                icon    = "",
                stock   = "",
                text    = "",
                css     = "",
                tmpl    = '<span class="is-block text-right {{class}}" style="background-color: transparent;">{{icon}} {{stock}} {{text}}</span>';

            if (item.disabled) {
                return tmpl
                    .replace("{{icon}}", "")
                    .replace("{{stock}}", "")
                    .replace("{{text}}", window.text.SOLD_OUT)
                    .replace("{{class}}", "panel-danger");
            }

            if ( !window.platform.getSetting("shop_product_delivery_time") ) return "";

            if ( window.platform.getSetting("shop_product_delivery_time") === "texticon" ) {
                icon = (item.Stock >= item.MinAmount)
                    ? '<i class="fa fa-fw fa-check"></i>'
                    : '<i class="fa fa-fw fa-clock-o"></i>';
            }

            // show with or without pieces
            if (item.DeliveryTimeId == 0) {
                stock = item.Stock+" "+item.UnitTitle;
            }

            // Color up the stock
            css = (item.Stock >= item.MinAmount)
                ? "panel-success"
                : "panel-danger";

            // Text
            text = item.DeliveryTimeText;

            return tmpl
                .replace("{{icon}}", icon)
                .replace("{{stock}}", stock)
                .replace("{{text}}", text)
                .replace("{{class}}", css);
        },




        getSimpleTitle : function (item) {
            var self = this,
                colors = "",
                tmpl = "<div>{{colors}} {{title}}</div>";

            for (var i = 0; i < item.TitleCombination.length; i++) {
                var tc = item.TitleCombination[i];
                colors += this.getGfx(tc) + " ";
            }

            return tmpl
                .replace("{{colors}}", colors)
                .replace("{{title}}", item.Title);
        },




        getTitle : function (item) {
            var self = this,
                tmpl = '<div class="col-s-4 col-m-6 col-l-6 col-xl-12">{{titles}}{{minBuy}}</div>',
                tmpl_item = "<div>{{title}}: {{color}}{{data}}</div>",
                titles = "";

            for (var i = 0; i < item.TitleCombination.length; i++) {
                var tc = item.TitleCombination[i];
                titles += tmpl_item
                    .replace("{{title}}", tc[0])
                    .replace("{{color}}", self.getGfx(tc))
                    .replace("{{data}}", tc[1]);
            }

            return tmpl
                .replace("{{titles}}", titles)
                .replace("{{minBuy}}", self.getMinimumBuy(item));
        },




        getMinimumBuy : function(item) {
            return (item.MinAmount > 1)
                ? " <small class='is-block'>"+ window.text.MINIMUM_BUY +" "+ item.MinAmount +" "+ item.UnitTitle +"</smalL>"
                : "";
        },




        getMinAmount : function(item) {
            return (item.MinAmount > 1)
                ? " <small class='is-block'>"+ window.text.PRODUCT_CATALOG_PRICE_FOR +" "+ item.MinAmount +" "+ item.UnitTitle +"</smalL>"
                : "";
        },




        enable : function () {
            var self = this;
            self.$this.select2("enable", true);
        },




        disable : function (reset) {
            var self = this;
            self.$this.select2("val", "");
            if (!reset) {
                self.dataId = null;
                if (!self.first) self.$this.select2("enable", false);
            }
        }
    };








    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.variant = eksport.platform.classes.variant || {};
    eksport.platform.classes.variant.OrderlistDropdown = Variant;
})(jQuery, window);
