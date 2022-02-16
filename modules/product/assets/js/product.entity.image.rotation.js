; (function ($, eksport, undefined) {
    'use strict';

    // ==========================================================================
    // Rotation Prototype
    // ==========================================================================

    var Rotation = function (product) {
        var self = this;

        self.product = product;

        self.selectors = {
            wrap: "#template-myRotation-{id}".replace("{id}", product.Id),
            owl: "#template-myRotation-{id} .owl-carousel".replace("{id}", product.Id),
            'owl-container': "#template-myRotation-{id} .w-slider-container".replace("{id}", product.Id),
            thumb: "#slider-{id}".replace("{id}", product.Id)
        };

        self.$wrap = $(self.selectors.wrap);
        self.$owl = $(self.selectors.owl);
        self.$container = $(self.selectors['owl-container']);
        self.$thumb = $(self.selectors.thumb);

        self.$originalContent = self.$container.find('[data-fancybox-group="product"]').clone();
    };




    Rotation.prototype = {

        hasElement : function () {
            var self = this;
            return self.$wrap.length && self.$thumb.length && self.$owl;
        },




        select: function (variant) {

            var self = this,
                fileId = variant.FileId,
                fileIds = variant.FileIds;

            self.owlObject = self.owlObject || self.$container.data("owlCarousel");

            if ( !self.hasElement() ) { return; }

            self.$thumb.find('li').css("display","inline");

            self.reset();

            if ( fileIds.length ) {
                // handle owlslider
                var sliderSearch = fileIds.map(function (n) { return ".item-"+n; }).join();

                self.removeItems();

                self.$originalContent.each(function() {
                    var $this = $(this);
                    if ( $this.is(sliderSearch) ) {
                        $this = self.lazyOwlReset($this);
                        self.owlObject.addItem($this);
                    }
                });

                // handle thumbeline below owl
                var search = fileIds.map(function (n) { return "[data-fileid='"+n+"']"; }).join();
                self.$thumb.find('img').not(search).parents('li').css("display","none");
                self.$thumb.find('li:visible').first().find('img').trigger("click");
            }
        },


        blankGif: 'data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==',

        lazyOwlReset : function ($el) {
            var self = this,
                $img = $el.find('img');
            
            if ($img.hasClass('lazyOwl')) {
                var src = $img.attr('src').indexOf(self.blankGif) === -1 ? $img.attr('src') : $img.data('src');
                $img.attr({ 'src': self.blankGif, 'data-src': src });
            }

            return $el;
        },


        unselect: function () {
            var self = this;

            if (!self.hasElement()) { return; }

            self.reset();

            self.$thumb.find('li')
                .css("display","inline")
                .first().find('img').trigger("click");
        },




        reset: function () {
            var self = this;
            self.removeItems();
            self.addItems(self.$originalContent.clone());
            self.$thumb.find('.owl-carousel').data("owlCarousel").goTo(0);
        },




        removeItems: function () {
            if (!this.owlObject) { return; }
            var self = this;
            self.$originalContent.each(function (i, n) { self.owlObject.removeItem(); });
        },




        addItems: function (items) {
            if (!this.owlObject) { return; }
            var self = this;
            items.each(function (i, n) {
                self.owlObject.addItem(n);
            });
        }
    };





    eksport.platform = eksport.platform || {};
    eksport.platform.classes = eksport.platform.classes || {};
    eksport.platform.classes.image = eksport.platform.classes.image || {};
    eksport.platform.classes.image.rotation = Rotation;
})(jQuery, window);
