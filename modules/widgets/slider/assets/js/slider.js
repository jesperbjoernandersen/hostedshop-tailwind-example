//
// Slider Javascript file
// --------------------------------------------------------------------------

(function($, document, undefined) {
    'use strict';


    // ==========================================================================
    // Prototype definition
    // ==========================================================================

    var Slider = function (element) {
        this.$element   = $(element);
        this.options    = digestOptions(this.$element.data());


        if (this.$element.data("nav")) {
            this.options.afterInit = function (elem) {
                var self = this;
                var $navigation = self.owlControls.find(".owl-page");

                self.$owlItems.each(function (idx, elem) {
                    var fileid = $(elem).find(".item").data('fileid');
                    $navigation.eq(idx).attr("data-fileid",fileid);
                });
            };
        }

        this.owl = this.$element.owlCarousel(this.options);
        this.bindNavigation(this.options);
    };

    //
    // Slider defaults
    //
    // Breakpoints: 480px, 768px, 960px, 1280px
    //
    // <div class="hero-slider"
    //  data-slider="multiple" or data-slider="single"
    //  data-theme=".hero-slider"
    //  data-nav="true"
    //  data-nav-text="n&Atilde;&brvbar;ste,forrige"
    //  data-pagination="false"
    //  data-speed="200"
    //  data-style="fade"
    //  data-s-items="2"
    //  data-m-items="6"
    //  data-l-items="8"
    //  data-xl-items="8"
    //  data-itemsCustom="array"
    //  data-next=".hero-slider-next"
    //  data-prev=".hero-slider-prev"
    //  data-play=".hero-slider-play"
    //  data-stop=".hero-slider-stop"
    //  data-autoplay="true"
    // > ... </div>
    //

    Slider.DEFAULTS = {
        navigation          : false,
        navigationText      : false,
        pagination          : false,
        theme               : "slider-theme",
        transitionStyle     : "fade",
        slideSpeed          : 500,
        singleItem          : true,
        itemsDesktop        : false,
        itemsDesktopSmall   : false,
        itemsTablet         : false,
        itemsMobile         : false,
        autoPlay            : true
    };

    Slider.prototype.bindNavigation = function (options) {
        var self = this;

        var buttons = {
            play : null,
            stop : null,
            next : null,
            prev : null
        }

        //
        // Bind all buttons to their selectors
        //
        for(var btn in buttons) {
            if (options[btn]) {
                $(options[btn]).on("click", function (e) {
                    e.preventDefault();
                    self.owl.trigger("owl."+btn);
                });
            }
        }
    };

    // ==========================================================================
    // Helpers
    // ==========================================================================
    function digestOptions (rawData) {

        /**
         * Define item count for all breakpoints
         * @param String val
         * @param Object data
         */
        var handleCustom = function (val, data) {
            if ( rawData['single'] ) return false;

            if ( $.isArray(val) ) {
                data['itemsCustom'] = val;
            }
        }

        var dataMixins = {
            /**
             * Prepends a period to a string if its not already a CSS selector
             * @param  String      str
             * @return String
             */
            _makeClass : function (str) {
                if ( str.substring(0,1) !== "." && str.substring(0,1) !== "#" ) {
                    str = "."+str;
                }
                return str;
            },

            /**
             * Removes period or hash from a CSS selector
             * @param  String     str
             * @return String
             */
            _makeStr : function (str) {
                if ( str.substring(0,1) == "." || str.substring(0,1) == "#" ) {
                    str = str.substring(1);
                }
                return str;
            },

            /**
             * Returns jQuery selector for next button
             * @param  String   val
             * @param  Object   data
             */
            next : function (val, data) {
                data['next'] = this._makeClass(val);
            },

            /**
             * Returns jQuery selector for prev button
             * @param  String   val
             * @param  Object   data
             */
            prev : function (val, data) {
                data['prev'] = this._makeClass(val);
            },

            /**
             * Returns jQuery selector for stop button
             * @param  String   val
             * @param  Object   data
             */
            stop : function (val, data) {
                data['stop'] = this._makeClass(val);
            },

            /**
             * Returns jQuery selector for play button
             * @param  String   val
             * @param  Object   data
             */
            play : function (val, data) {
                data['play'] = this._makeClass(val);
            },

            /**
             * Returns if navigation should be shown
             * No modifications needed maps 1to1 with owl
             * @param  String   val
             * @param  Object   data
             */
            nav : function (val, data) {
                data['navigation'] = Boolean(val);
            },

            /**
             * Returns text for navigation buttons
             * @param  String    val
             * @param  Object    data
             */
            navText : function (val, data) {

                if ( val === false ) {
                    data['navigationText'] = false;
                    return;
                }

                var texts = val.split(",");
                for (var i = texts.length - 1; i >= 0; i--) {
                    texts[i] = texts[i].trim();
                }
                data['navigationText'] = texts;
            },

            /**
             * Returns if pagination should be shown
             * No modifications needed maps 1to1 with owl
             * @param  String   val
             * @param  Object   data
             */
            pagination : function (val, data) {
                data['pagination'] = Boolean(val);
            },

            /**
             * Returns a string containing the CSS class selector for theme
             * @param  String   val
             * @param  Object   data
             */
            theme : function (val, data) {
                data['theme'] = this._makeStr(val);
            },

            /**
             * Returns if style used for transition
             * No modifications needed maps 1to1 with owl
             * @param  String   val
             * @param  Object   data
             */
            style : function (val, data) {
                data['transitionStyle'] = val;
            },

            /**
             * Returns if speed should be shown
             * No modifications needed maps 1to1 with owl
             * @param  String   val
             * @param  Object   data
             */
            slideSpeed : function (val, data) {
                data['slideSpeed'] = parseInt(val, 10);
            },

            /**
             * Returns boolean defining if slider is a single or multiple items
             * @param  String   val
             * @param  Object data
             */
            slider : function (val, data, domData) {
                data['singleItem'] = (val === "single");

                if (val === "multiple"
                && !data['itemsCustom']
                && !domData["xlItems"]
                && !domData["lItems"]
                && !domData["mItems"]
                && !domData["sItems"]) {
                    data['itemsCustom'] = [
                        [window.template.bp.s,2],
                        [window.template.bp.m, 4],
                        [window.template.bp.l, 6],
                        [window.template.bp.xl, 8]
                    ];
                }
            },

            /**
             * Define item count for all breakpoints
             * @param String val
             * @param Object data
             */
            itemscustom: handleCustom,

            /**
             * Define item count for all breakpoints
             * @param String val
             * @param Object data
             */
            itemsCustom: handleCustom,

            /**
             * Define item count on on XL breakpoint
             * @param  String   val
             * @param  Object   data
             */
            xlItems : function (val, data) {
                if ( rawData['single'] ) return false;
                data['itemsCustom'] = data['itemsCustom'] || [];
                data['itemsCustom'].push([window.template.bp.xl, parseInt(val,10)]);
            },

            /**
             * Define item count on on L breakpoint
             * @param  String   val
             * @param  Object   data
             */
            lItems : function (val, data) {
                if ( rawData['single'] ) return false;
                data['itemsCustom'] = data['itemsCustom'] || [];
                data['itemsCustom'].push([window.template.bp.l, parseInt(val,10)]);
            },

            /**
             * Define item count on on M breakpoint
             * @param  String   val
             * @param  Object   data
             */
            mItems : function (val, data) {
                if ( rawData['single'] ) return false;
                data['itemsCustom'] = data['itemsCustom'] || [];
                data['itemsCustom'].push([window.template.bp.m, parseInt(val,10)]);
            },

            /**
             * Define item count on on S breakpoint
             * @param  String   val
             * @param  Object   data
             */
            sItems : function (val, data) {
                if ( rawData['single'] ) return false;
                data['itemsCustom'] = data['itemsCustom'] || [];
                data['itemsCustom'].push([0, parseInt(val,10)]);
            },

            /**
             * Should the slider autoplay
             * @param  String   val
             * @param  Object   data
             */
            autoplay : function (val, data) {
                if (val == "true" || val === "false") {
                    data['autoPlay'] = Boolean(val);
                } else {
                    data['autoPlay'] = val;
                }
            },

            /**
             * Should multiple items scroll pr page or pr item
             * @param String val
             * @param Object data
             */
             scrollperpage : function (val, data) {
                data['scrollPerPage'] = Boolean(val);
            },

            /**
             * Should the slider stop on hover
             */
            stoponhover : function (val, data) {
                data['stopOnHover'] = Boolean(val);
            },

            /**
             * Add a active class
             */
            addclassactive : function (val, data) {
                data['addClassActive'] = this._makeClass(val);
            },

            /**
             * Toggle touch drag function
             */
            touchdrag : function (val, data) {
                data['touchDrag'] = Boolean(val);
            },

            /**
             * Toggle mouse drag function
             */
            mousedrag : function (val, data) {
                data['mouseDrag'] = Boolean(val);
            }
        };

        var digestedData = {};
        for(var mixinKey in dataMixins) {
            if (typeof rawData[mixinKey] !== "undefined") {
                dataMixins[mixinKey](rawData[mixinKey], digestedData, rawData);
            }
        }

        return $.extend({}, Slider.DEFAULTS, digestedData);
    }


    // ==========================================================================
    // Slider plugin definition
    // ==========================================================================

    $.fn.slider = function (option) {
        return this.each( function () {
            var $this = $(this),
                data  = $this.data("template.slider");

            // convert dropdown to a prototype of dropdown
            if ( !data ) $this.data("template.slider", (data = new Slider(this)));

            if ( typeof option === "string" ) $this.data("owlCarousel")[option]();

            if ( typeof option === "array" && typeof option[0] === "string") $this.data("owlCarousel")[option[0]](option[1]);
        });
    };

    $.fn.slider.Construct = Slider;


    // ==========================================================================
    // Slider no conflict mode
    // ==========================================================================

    $.fn.slider.noConflict = function () {
        $.fn.slider = old;
        return this;
    };


    // ==========================================================================
    // Listener
    // ==========================================================================

    $(window).on("load", function () {
        $('[data-slider="single"], [data-slider="multiple"]').each(function () {
            var $slider = $(this);
            $slider.slider($slider.data());
        });
    });

})(jQuery, document);
