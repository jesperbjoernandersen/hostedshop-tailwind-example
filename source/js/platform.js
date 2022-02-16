;(function ($, exports) {

	// fallback to not break template.
	$.fn.Thumbelina = function() {
		$(this).remove();
	};

	//pickaday datepicker
	var text = window.text,

		months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"],
		weekdays = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"],

		dateTranslations = {
			months: _.map(months, function (month) { return text["DATE_MONTH_" + month]; }),
			weekdays: _.map(weekdays, function (day) { return text["DATE_DAY_" + day]; }),
			weekdaysShort: _.map(weekdays, function (day) { return text["DATE_DAY_" + day].substring(0, 3); })
		};

	function datepickerInit(el) {

		// Pickaday object
		var picker = {
			field: el,
			firstDay: 1,
			keyboardInput: false,
			onSelect: function (date) {
				// Format: YYYY-MM-DD
				var year = date.getFullYear(),
				month = date.getMonth() + 1,
				day = date.getDate(),
				formattedDate = [
					year,
					month < 10 ? '0' + month : month,
					day < 10 ? '0' + day : day
				].join('-');
				el.value = formattedDate;
			},
			// Translations
			i18n: {
				previousMonth: window.text.PREVIOUS,
				nextMonth: window.text.NEXT,
				months: dateTranslations.months,
				weekdays: dateTranslations.weekdays,
				weekdaysShort: dateTranslations.weekdaysShort
			}
		};

		var minDate = $(el).attr('min')
		if (minDate) {
			picker.minDate = new Date(minDate);
		}

		if (Date) {
			var d = new Date();
			picker.yearRange = [(d.getFullYear() - 100), (d.getFullYear() + 1)];
		}

		return new Pikaday(picker);
	}

	//
	// Media query breakpoints
	//
	var bp = {
	    _error: function (fn) {
	        throw new Error("Modernizr needed to test media queries with function "+fn+": http://modernizr.com/");
	    },

	    _hasModernizr: function () {
	        return (typeof exports.Modernizr.mq === 'function');
	    },

	    _miw: function (width) {
	        return exports.Modernizr.mq('(min-width: '+width+'px)');
	    },

	    _maw: function (width) {
	        return exports.Modernizr.mq('(max-width: '+width+'px)');
	    },

	    _mmw: function (start, finish) {
	        return exports.Modernizr.mq('(min-width: '+start+'px) and (max-width: '+finish+'px)');
	    },

	    is: exports.Modernizr.mq,

	    current: function() {
	        if (!this._hasModernizr) this._error("current");

	        var notFound = true,
	            i = 4,
	            bp;

	        while (notFound) {
	            if (this._miw(this._slices[i])) {
	                notFound = false;
	                bp = this._sizes[i];
	            }
	            i--;
	        }

	        return bp;
	    }
	};

	bp._slices = [0,480,768,960,1280];

	bp._sizes = {
	    1: "s",
	    2: "m",
	    3: "l",
	    4: "xl"
	};

	bp.all = {
	    s: bp._slices[1],
	    m: bp._slices[2],
	    l: bp._slices[3],
	    xl: bp._slices[4]
	};

	bp.s = bp._slices[1];
	bp.m = bp._slices[2];
	bp.l = bp._slices[3];
	bp.xl = bp._slices[4];

	exports.template = exports.template || {};
	exports.template.bp = bp;

	exports.platform = exports.platform || {};

	_.extend(exports.platform, {

	    number_format: function(number, decimals, dec_point, thousands_sep) {
	      number = (number + '')
	        .replace(/[^0-9+\-Ee.]/g, '');
	      var n = !isFinite(+number) ? 0 : +number,
	        prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
	        sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
	        dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
	        s = '',
	        toFixedFix = function (n, prec) {
	          var k = Math.pow(10, prec);
	          return '' + (Math.round(n * k) / k)
	            .toFixed(prec);
	        };
	      // Fix for IE parseFloat(0.55).toFixed(0) = 0;
	      s = (prec ? toFixedFix(n, prec) : '' + Math.round(n))
	        .split('.');
	      if (s[0].length > 3) {
	        s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
	      }
	      if ((s[1] || '')
	        .length < prec) {
	        s[1] = s[1] || '';
	        s[1] += new Array(prec - s[1].length + 1)
	          .join('0');
	      }
	      return s.join(dec);
	    },

	    currency_format: function(amount, format) {

	    	format = format || false;
	    	amount = amount || 0;
	        amount = exports.platform.number_format(amount, exports.platform.currency.decimalCount, exports.platform.currency.decimal, exports.platform.currency.point);
	        amount = format ? '<span class="amount">' + amount + '</span>' : amount;

	        var symbol = exports.platform.currency.symbol;
	        symbol = format ? '<span class="symbol">' + symbol + '</span>' : symbol;

	        var formattedNumber = '';

	        if (exports.platform.currency.symbolPlace == 'left') {
	            formattedNumber = symbol + ' ' + amount;
	        }

	        else {
	            formattedNumber = amount + ' ' + symbol;
	        }

	        return formattedNumber;
	    },

	    fancybox: {

	    	// check http://fancyapps.com/fancybox/ for default values
	    	settingsDefault 	: 	{
		    	beforeLoad		: 	function () {
		    		var $this = $(this.element);
		    		if ($this.data("fancybox-title")) {
		    			this.title = $this.data("fancybox-title");
		    		} else {
		    			this.title = $this.attr("title");
		    		}
		    	},
	    		helpers 		: 	{
					media 		: 	{},
					title		: 	{
						type 	: 	'inside'
					},
					thumbs		: 	{
						width	: 	50,
						height	: 	50
					}
			    },
			    padding 		: 	0,
			    tpl 			: 	{
			    	closeBtn 	: 	'<a title="Close" class="fancybox-item fancybox-close fa-stack fa-lg" href="javascript:;"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-times fa-stack-1x fa-inverse"></i></a>',
			    	prev 		: 	'<a title="Previous" class="fancybox-nav fancybox-prev" href="javascript:;"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-chevron-left fa-stack-1x fa-inverse"></i></span></a>',
			    	next 		: 	'<a title="Next" class="fancybox-nav fancybox-next" href="javascript:;"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-chevron-right fa-stack-1x fa-inverse"></i></span></a>'
			    }
	    	},

	    	// settings for modal
	    	settingsModal: {
		    	beforeLoad		: 	function () {
		    		var $this = $(this.element);
		    		if ($this.data("fancybox-title")) {
		    			this.title = $this.data("fancybox-title");
		    		} else {
		    			this.title = $this.attr("title");
		    		}
		    	},
		       	transitionIn  	: 	'none',
		    	transitionOut 	: 	'none',
		        modal         	: 	true,
			    padding 		: 	0,
			    tpl 			: 	{
			    	closeBtn 	: 	'<a title="Close" class="fancybox-item fancybox-close fa-stack fa-lg" href="javascript:;"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-times fa-stack-1x fa-inverse"></i></a>',
			    	prev 		: 	'<a title="Previous" class="fancybox-nav fancybox-prev" href="javascript:;"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-chevron-left fa-stack-1x fa-inverse"></i></span></a>',
			    	next 		: 	'<a title="Next" class="fancybox-nav fancybox-next" href="javascript:;"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-chevron-right fa-stack-1x fa-inverse"></i></span></a>'
			    }
		    },

    		// settings for gallery
		    settingsGallery: {
		    	beforeLoad		: 	function () {
		    		var $this = $(this.element);
		    		if ($this.data("fancybox-title")) {
		    			this.title = $this.data("fancybox-title");
		    		} else {
		    			this.title = $this.attr("title");
		    		}
		    	},
		       	transitionIn	:	'elastic',
				transitionOut	:	'elastic',
				speedIn			:	600,
				speedOut		:	200,
				helpers			: 	{
					buttons		: 	{},
					media 		: 	{},
					title		: 	{
						type 	: 	'inside'
					},
					thumbs		: 	{
						width	: 	50,
						height	: 	50
					}
				},
			    padding 		: 	0,
			    tpl 			: 	{
			    	closeBtn 	: 	'<a title="Close" class="fancybox-item fancybox-close fa-stack fa-lg" href="javascript:;"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-times fa-stack-1x fa-inverse"></i></a>',
			    	prev 		: 	'<a title="Previous" class="fancybox-nav fancybox-prev" href="javascript:;"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-chevron-left fa-stack-1x fa-inverse"></i></span></a>',
			    	next 		: 	'<a title="Next" class="fancybox-nav fancybox-next" href="javascript:;"><span class="fa-stack fa-lg"><i class="fa fa-circle fa-stack-2x"></i><i class="fa fa-chevron-right fa-stack-1x fa-inverse"></i></span></a>'
			    }
		    },

		    applyClass: function (className, settings) {
		    	var options = _.clone(this.settingsDefault);
		    	if (settings) {
		    		options = _.extend(options, settings);
		    	}
		    	$((className ? className : '.fancybox')).fancybox(options);
		    },

		    init: function () {

		    	// Set fancybox default
		        this.applyClass();
                this.applyClass('[data-fancybox=""]', this.settingsDefault);
                this.applyClass('.fancybox-modal, [data-fancybox="modal"]', this.settingsModal);
                this.applyClass('.fancybox-gallery, [data-fancybox="gallery"]', this.settingsGallery);
		    }
	    },

	    cookieBox: {
	    	init: function () {
				if (!platform.template.settings.COOKIE_TYPE) platform.template.settings.COOKIE_TYPE = 'COOKIE_POPUP';
				if (platform.general.linkToCookies && platform.template.settings.COOKIE_TYPE === 'COOKIE_POPUP') {
		    		var text = exports.text.COOKIES_TEXT.replace('#COOKIES_LINK#', '');

                    var config = {
                        palette: {
                            popup: {
                                background: '#00000075',
                                text: '#ffffff'
                            },
                            button: {
                                background: exports.platform.template.settings.BUTTON_PRIMARY_BACKGROUND_COLOR,
                                border: exports.platform.template.settings.BUTTON_PRIMARY_BACKGROUND_COLOR,
                                text: exports.platform.template.settings.BUTTON_PRIMARY_FONT_COLOR
                            },
                        },
                        content: {
                            message: text,
                            dismiss: exports.text.COOKIES_BUTTON,
                            link: exports.text.COOKIES_LINK,
                            href: platform.general.linkToCookies
                        },
                        elements: {
                          dismiss: '<a aria-label="dismiss cookie message" tabindex="0" style="font-weight: normal" class="cc-btn cc-dismiss">{{dismiss}}</a>',
                          allow: '<a aria-label="allow cookies" tabindex="0" style="font-weight: normal" class="cc-btn cc-allow">{{allow}}</a>',
                          deny: '<a aria-label="deny cookies" tabindex="0" style="font-weight: normal" class="cc-btn cc-deny">{{deny}}</a>'
                        },
                        law: {
                          regionalLaw: false,
                        }
                    };

                    if ( exports.platform.template.settings.COOKIE_PLACEMENT == 'top-static' ) {
                        config.position = "top";
                        config.static = true;
                    } else {
                        if ( exports.platform.template.settings.COOKIE_PLACEMENT ) {
                            config.position = exports.platform.template.settings.COOKIE_PLACEMENT;
                        }
                    }

                    if ( exports.platform.template.settings.COOKIE_BUTTON_BACKGROUND_COLOR && exports.platform.template.settings.COOKIE_BUTTON_FONT_COLOR ) {
                        config.palette.button.background = exports.platform.template.settings.COOKIE_BUTTON_BACKGROUND_COLOR;
                        config.palette.button.border = exports.platform.template.settings.COOKIE_BUTTON_BACKGROUND_COLOR;
                        config.palette.button.text = exports.platform.template.settings.COOKIE_BUTTON_FONT_COLOR;
                    }

                    if ( exports.platform.template.settings.COOKIE_BACKGROUND_COLOR && exports.platform.template.settings.COOKIE_FONT_COLOR ) {
                        config.palette.popup.background = exports.platform.template.settings.COOKIE_BACKGROUND_COLOR;
                        config.palette.popup.text = exports.platform.template.settings.COOKIE_FONT_COLOR;
                    }

					window.cookieconsent.initialise(config);
		    	}
	    	}
	    },

	    paymentOptions: {
	    	init: function () {

	    		if ( !exports.platform.shop ) return;

	    		var self = this;

    			self.klarna.init();
	    	},
	    	klarna: {
	    		init: function () {
	    			var self = this;
					if (platform.consent && platform.consent['MARKETING'] && platform.consent['STATISTICS'] && platform.consent['FUNCTIONAL']) {
						self.widget();
					} else if (!platform.consent) {
						self.widget();
					}
	    		},
	    		widget: function () {
	    			var self = this,
	    				$elements = $('.klarna-widget');

	    			if ( $elements.length ) {
	    				$.getScript("https://cdn.klarna.com/1.0/code/client/all.js");
	    			}
	    		}
	    	}
	    },

	   	formSpamCheck: {
	   		init: function () {
		        $("body").on("submit", "form", function () {
		        	var $this = $(this),
		        		$check = $this.find("input[name='check']");

		        	if ($check.length) {
		        		$check.val("checked");
		        	}
		        });
	   		},
	   	},

	   	render: {
	   		init: function () {
	   			this.addHelpers();
	   			this.addConverters();
	   			this.addTags();
	   		},
	   		addHelpers: function () {
				var vatText = '',
					hasVat = (platform.currency != null && typeof platform.currency.hasVat !== 'undefined' ? platform.currency.hasVat : false);
				
				if ( platform.currency != null && platform.getSetting('shop_product_tax_after_price') ) {
					vatText = platform.currency.hasVat ? window.text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX : window.text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO;
				}

				$.views.helpers({
					text: function(key) {
						return window.text[key];
					},
					settings: function(key) {
						return platform.getSetting(key);
					},
					hasVat: hasVat,
					vatText: vatText,
					productVatText: function (priceVat, priceNoVat) {
						var hasProductVat = parseFloat(priceVat) > parseFloat(priceNoVat);
						return (hasVat && (platform.getSetting('vat_label_advanced') == false || hasProductVat)
							? vatText 
							: window.text.PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO);
					}
				});
			},

			addConverters: function () {

				$.views.converters({
					currency_format: function(val) {
						return window.platform.currency_format(val);
					},
					number_format: function (amount) {
						var amountStr = String(amount);
						var hasFloat = amountStr.indexOf(".") !== -1;
						var decimalCount = hasFloat ? amountStr.split('.')[1].length : 0;
						return exports.platform.number_format(amount, decimalCount, exports.platform.currency.decimal, exports.platform.currency.point);
					}
				});
			},

	   		addTags: function () {
	   			$.views.tags({

	   			});
	   		}
	   	},


	   	equalHeight: {
	   		init: function () {
	   			// http://brm.io/jquery-match-height/
	   			if (!window.jQuery || !window.jQuery.fn.matchHeight) {
	   				return;
	   			}

	   			window.jQuery.fn.matchHeight._throttle = 64;
	   		}
	   	}
	});

	exports.platform.cart = {
		init: function () {
			var self = this;

			self.dummyCart = { CartProduct: [] };

			// no reason to get cart if not shop
			if ( platform.general.isShop !== '1' ) { return; }

			// no reason to get cart if empty but still tell event listeners
			if ( !platform.general.hasCartItems ) {
				exports.platform.publish("/cart/ready", self.dummyCart);
				return;
			}

			this.get( function(cart) {
				exports.platform.publish("/cart/ready", cart);
			});
		},

		get: function (cb) {
            var self = this;
            self.tries = self.tries + 1;

            $.get("/json/cart?lastCache"+ (exports.platform.settings.hasOwnProperty("cartLastCache") ? "="+exports.platform.settings.cartLastCache : '') )
                .done(function( data ) {
                    self.data = ( data ) ? data : self.dummyCart;
                    $.extend(self, self.data);
                    cb( self.data );
                })
                .fail(function () {
                    if (self.tries < 3) {
                        self.get(cb);
                    } else {
                        self.data = self.dummyCart;
                        cb( self.data );
                    }
            	}
            );
		},

		action: function (action, options) {
			var self = this;
			options = options || {};
			$.post("/actions/cart/"+action, options && options.data).setRequestHeader("HTTP_X_REQUESTED_WITH", "xmlhttprequest")
				.done(function (data) {
					// sync cart data
					exports.platform.settings.cartLastCache = Date.now();
					self.get(function (cartData) {
						platform.cart.data = cartData;
						options.then && options.then(data);
					});
				})
				.fail(function (error) {
					options.fail && options.fail();
					console.error(error);
				}
			);
		}
	}

	// jQuery init
	$(function() {

		// fancybox
		exports.platform.fancybox.init();

		// cookie box
		exports.platform.cookieBox.init();

		// payment options
		exports.platform.paymentOptions.init();

		// enable spam check for forms
		exports.platform.formSpamCheck.init();

		// setup global JsRender
		exports.platform.render.init();

		// setup matchHeight
		exports.platform.equalHeight.init();

		// setup cart
		exports.platform.cart.init();

		// notify world that we are ready
		exports.platform.publish("/platform/ready");

		// setup automatic ajax csrf-token
		$.ajaxSetup({
		    headers: {
		        'X-CSRF-TOKEN': $('meta[name="csrf_token"]').attr('content')
		    }
		});

		// Pickaday Datepicker init
		var dateInputs = $("input[type=date]");

		if (dateInputs.length && !Modernizr.inputtypes.date) {
			$.each(dateInputs, function() {
				datepickerInit(this);
			});
		}

		// Pickaday CSS fallback
		if ($(".pika-single").css("background-color") != "rgb(255, 255, 255)") {
			$(document.head).prepend("<style>.pika-single{background-color:#fff;padding:0.5em;box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);}</style>")
		}

	});

})(jQuery, window);
