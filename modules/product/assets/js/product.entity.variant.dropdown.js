;(function ($, eksport, undefined) {
    'use strict';

    var VARIANT_TYPE = "dropdown",
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
                        first       : idx === 0 ? true : false,
                        last        : idx === $variants.length-1 ? true : false,
                        productId   : self.product.Id,
                        id          : $this.data("varianttypeid"),
                        title       : _.filter(self.product.VariantTypes, { 'Id': $this.data("varianttypeid") })[0].Title,
                        variant     : self
                    };

                var my_variantType = new VariantType(settings);
                my_variantType.init();
                self.variantTypes.push(my_variantType);
            });


            self.handleVariantDataSelected = $.proxy(self.handleVariantDataSelected, self);

            window.platform.subscribe("/variant/variantType/selected", self.handleVariantDataSelected);
        },





        //
        // Event handlers
        //

        handleVariantDataSelected : function (event,args) {
            var self = this;
            /**
             * args:
             *  0 : variantTypeId,
             *  1 : variantDataId,
             *  2 : isFirst,
             *  3 : isLast
             */

            if (args[3]) {
                self.getVariant(function (variant) {
                    if (variant && variant.Id) {
                        self.hasVariant = true;
                        self.variant = variant;
                        window.platform.publish("/product/variant/selected", [self.variant]);
                    } else {
                        self.hasVariant = false;
                        self.variant = undefined;
                        window.platform.publish("/product/variant/unselected");
                    }
                });
            } else {
                self.UpdateVariantTypes(args[0]);
                self.hasVariant = false;
                self.variant = undefined;
                window.platform.publish("/product/variant/unselected");
            }
        },




        getSearchTerms : function (variantTypeId, isFirst) {
            var self = this;

            if (isFirst) {
                return "";
            } else {
                var index = _.findIndex(self.variantTypes, function(obj) { return obj.id == variantTypeId; }),
                    types = self.variantTypes.slice(0, index),
                    dataIds = [];

                $.each(types, function () { dataIds.push(this.dataId) });
                return dataIds.join(",");
            }
        },




        UpdateVariantTypes : function (id) {
            var self = this;

            $.each(self.variantTypes, function (idx) {
                this.enable();
            });

            var index = _.findIndex(self.variantTypes, function(obj) { return obj.id == id; });
            $.each(self.variantTypes.slice(index+1), function (idx) {
                if (idx == 0) {
                    this.disable(true);
                } else {
                    this.disable();
                }
            });
        },




        getDataIds : function () {
            var self = this;
            return _.map(_.filter(self.variantTypes, 'dataId'), 'dataId').join(",");
        },




        getVariant : function (cb) {
            var self = this;

            if (typeof cb !== "function") return;

            self.tries = self.tries + 1;
            $.get(this.API.variant.replace("{productId}", self.product.Id), {dataIds: self.getDataIds()})
                .done(function( data ) {
                    self.item = (data.count) ? data.data[0] : undefined;
                    $.extend(self, self.item);
                    cb( self.item );
                })
                .fail(function () {
                    if (self.tries < 3) {
                        self.getVariant(cb);
                    } else {
                        self.item = undefined;
                        cb( self.item );
                    }
                });
        },




        canDoActions : function () {
            var self = this;
            return self.hasVariant && self.variant && (self.variant.Stock >= self.variant.MinAmount || (self.variant.Stock < self.variant.MinAmount && self.variant.AllowOutOfStockPurchase));
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
            typeDatas   : "/json/productvariants/data/{productId}"
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
                placeholder : window.text.CHOOSE_VARIANT +" "+ self.title,
                minimumResultsForSearch: -1,
                ajax: {
                    url: self.API.typeDatas.replace("{productId}", self.productId),
                    dataType: 'json',
                    cache: false,
                    results: function (data, page) {
                        return {results: data};
                    },
                    data: function () {
                        var ret = {
                           typeId : self.id
                        };

                        var dataIds = self.variant.getSearchTerms(self.id, self.first);

                        if (dataIds) {
                            ret.dataIds = dataIds;
                        }

                        return ret;
                    }
                },
                formatResult : function(item) {
                    var tmpl = '<div class="row"><div class="col-s-4 col-m-12 col-l-12 col-xl-24">{{gfx}}{{title}}{{soldout}}</div></div>';
                    return tmpl
                        .replace("{{title}}", self.getTitle(item))
                        .replace("{{gfx}}", self.getGfx(item))
                        .replace("{{soldout}}", self.getSoldout(item));
                },
                formatSelection : function(item) {
                    var tmpl = '<div>{{gfx}}{{title}}</div>';
                    return tmpl
                        .replace("{{title}}", self.getTitle(item))
                        .replace("{{gfx}}", self.getGfx(item));
                },
                formatSearching : function() {
                    return '<img class="spinner" alt src="' + window.platform.template.cdn + '/_design/common/img/ajax-loader-bar.gif">';
                }
            });

            if (!this.first) {
               self.disable();
            }

            // listen for user has selected event
            self.$this.on('select2-selecting', {id: self.id}, function (e) {
                self.dataId = e.val;
                window.platform.publish("/variant/variantType/selected", [self.id, self.dataId, self.first, self.last]);
            });

            return self;
        },




        getGfx : function (item) {
            var self = this,
                color,
                tmpl = "<span class='fa fa-square' style='{{color}}'></span> ";

            // if no color defined for variant set to blank
            if ( !item.Color ) {
                return "";
            }

            color = "color:#"+item.Color+";";

            if ( item.Color && item.Color.toLowerCase() === "ffffff" ) {
                color = color+";border-radius:3px;border:1px solid #888;";
            }

            return tmpl.replace("{{color}}", color);
        },




        getTitle : function (item) {
            return item.Title;
        },




        getSoldout : function (item) {
            var self = this;
            return item.disabled && !item.AllowOutOfStockPurchase
                ? '<span class="pull-right">'+ window.text.SOLD_OUT + '</span>'
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
    eksport.platform.classes.variant.Dropdown = Variant;
})(jQuery, window);
