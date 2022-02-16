;(function($, platform, exports) {
	'use strict';

	exports.platform = exports.platform || {};

	var checkoutAction = '/actions/handler/ajax',
		isProductPage = platform.page.isProduct && platform.page.paths.length > 2,
		$tmpl = platform.render.$templates,
		user = platform.user,
		credentials = {
			userType: 'private',
			cvr: '',
			zipcode: '',
			company: '',
			country: platform.general.deliveryCountryIso
		};

	if (user) {
		credentials = {
			userType : user.Type,
			cvr      : user.VatNumber,
			zipcode  : user.Zipcode,
			company  : user.Company,
			country  : user.Country
		};
	}

	function Checkout($el, type) {

		// Last Modified
		this.version = 20210719;

		this.isLoading = false;
		this.termsChecked = false;

		this.$el  = $el;
		this.type = type;

		//General partials
		this.delivery = new Delivery(this);
		this.order    = new Order(this);
		this.modal    = new Modal(this);

		if (isProductPage) {
			this.cart = new Cart(this);
		}
	}

	function Modal (checkout) {
		var self = this,
			$el = checkout.$el,
			$modal = $el.find('.w-checkout-modal'),
			$form = $modal.find('.w-checkout-form');

		self.$container = $modal.find('.modal-container');

		self.$modalOpenButton = $('[data-w-checkout-type=' + checkout.type +'] [data-w-checkout=modal-open]');
		self.$modalCloseButton = $el.find('[data-w-checkout=modal-close]');

		self.$modalOpenButton.on('click', function () {
			self.buttonLoading(true);
			if (isProductPage) {
				checkout.cart.addProduct(function () {
					self.open();
					checkout.delivery.update();
				});
			} else {
				self.open();
				checkout.delivery.update();
			}
		});

		self.$modalCloseButton.on('click', function () {
			self.close();
			self.buttonLoading(false);
		});

		// checkbox: accept terms
		$el.on('change', '#accept-terms', function () {
			self.termsChecked = $(this).is(':checked');
			self.validateForm();
		});

		// form submit: submit modal to external checkout
		self.isValid = false;

		$form.on('submit', function (e) {
			if (!self.isLoading && $.active === 0 && self.termsChecked) {
				$el.find('input[name="check_stage_all_loaded"]').val('1');
				
				if (!self.isValid) {
					'checkValidity' in $form[0] && $form[0].checkValidity();  		
					e.preventDefault();
					return false;
				}
			} else {
				alert(text.CHECKOUT_STEP_FOUR_TOTALS_NOT_LOADED);
				e.preventDefault();
				return false;
			}
		});

		var $body = $(document.body);

		self.close = function () {
			checkout.delivery.userChangedDelivery = false;
			$body.removeClass('modal--open');
			$modal.addClass('close');
		}
		
		self.open = function () {
			self.buttonLoading(false);
			$body.addClass('modal--open');
			$modal.addClass('modal-active');
			$modal.removeClass('close');
		}

		self.loading = function (isLoading) {
			checkout.isLoading = isLoading;
			self.$container[(isLoading ? 'add' : 'remove') + 'Class']('loading');
		}

		self.buttonLoading = function (isLoading) {
			checkout.isLoading = isLoading;
			self.$modalOpenButton[(isLoading ? 'add' : 'remove') + 'Class' ]('loading');
		}

		var $button = $modal.find('[type=submit]');

		self.validateForm = function () {
			var deliveryIsValid = false,
				delivery = checkout.delivery,
				$method = delivery.$deliveryMethod,
				$checkedDelivery = $el.find('.delivery-method-radio:checked');

			if ($checkedDelivery.length) {
				deliveryIsValid = true;

				if ($checkedDelivery.data('droppoint')) {
					var $empty = $method.find('.random-choice'),
						$activeDroppoint = $method.find('.droppoint-active').find('input[id*=droppoint][value]');

					deliveryIsValid = $activeDroppoint.length ? true : false;
					
					if ($empty.length) {
						deliveryIsValid = !!$empty.find('input:checked').length;
					}
				}
			}

			if ((deliveryIsValid || platform.settings.shop_delivery_hidden) && self.termsChecked && $form.is(':valid') && !delivery.droppoint.listIsOpen) {
				$button.removeClass('button-disabled');
				self.isValid = true;
			} else {
				$button.addClass('button-disabled');
				self.isValid = false;
			}
		}
	}

	function Delivery (checkout) {
		var self = this,
			$el = checkout.$el,
			$container = $el.find('.delivery-list'),
			$methodList = $container.find('.delivery-method-list');

		self.$country = $el.find('#country');
		self.$zipcode = $el.find('#zipcode');

		self.containerHeight = { min: 0, max: 0 };

		var $zipcodeContainer = $el.find('.w-checkout-zipcode');
		self.setZipcodeField = function (option) {
			if ('required' in option) {
				self.$zipcode.prop('required', option.required);
				$zipcodeContainer.find('.form-required')[(option.required ? 'remove' : 'add') + 'Class']('is-hidden');
			}
			if ('show' in option) {
				$zipcodeContainer[(option.show ? 'remove' : 'add') + 'Class']('is-hidden');
				!option.show && self.$zipcode.val('');
			}
		}

		// delivery country: select box
		self.$country.on('change', function (event) {
			self.country = $(event.target).val();

			$el.find('input[name=country]').val(self.country);

			// set VAT rates for delivery country
			$.get(checkoutAction, {
				page: 'checkout',
				action: 'delivery_country',
				delivery_country: self.country
			}).done(function () {
				self.update();
				checkout.order.update();
			});
		});

		// zipcode input
		if (user && user.Zipcode) {
			self.zipcode = user.Zipcode;
		}

		self.$zipcode.on('input', _.debounce(function (e) {
				e.preventDefault();

				var $this = $(this);
					self.zipcode = $this.val().length ? $this.val() : null;

				if (user && user.Zipcode && !self.zipcode) {
					self.zipcode = user.Zipcode;
				}
				
				if (self.droppoint.type) {
					self.droppoint.setList({ open: false });
					self.droppoint.update(self.zipcode);
				}
			}, 500)
		);

		self.methodLimit = 5;
		
		var latestRequestData = {};

		self.update = function () {
			$container.addClass('loading');
			self.hasDroppointMethods = false;
			
			self.zipcode = self.$zipcode.length && self.$zipcode.val().length ? self.$zipcode.val() : credentials.zipcode;
			self.country = self.$country.length && self.$country.val().length ? self.$country.val() : credentials.country;

			var requestData = {
				page: 'checkout',
				action: 'delivery_methods',
				cvr: credentials.cvr,
				user_type: credentials.userType,
				delivery_country: self.country,
				delivery_zip: self.zipcode,
				delivery_address: false,
				beforeSend: function (jqXHR, settings) {
					/* https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState */
					if (self.latestRequest && self.latestRequest.readyState < 4) {
						self.latestRequest.abort();
					}
				}
			}

			// stop new data rendering if the user have not changed anything
			if (JSON.stringify(latestRequestData) === JSON.stringify(requestData)) {
				checkout.modal.validateForm();
				$container.removeClass('loading');
				checkout.order.update();
				return;
			}

			requestData.delivery_zip = false;

			self.latestRequest = $.get(checkoutAction, requestData).done(function (data) {
				latestRequestData = requestData;
				self.methods = filterDeliveryData(data.result);
				if (self.methods.length) {
					$el.find('.methods-not-found').addClass('is-hidden');
					var helper = { userChangedDelivery: self.userChangedDelivery, checkout_version: checkout.version };
					$methodList.html($tmpl.deliveryMethod.render(self.methods, helper));
					self.$deliveryMethod = $methodList.find('.delivery-method-radio:checked').parents('.delivery-method');

					if (!self.userChangedDelivery) {
						self.initPreselectedMethods();
					}
				} else {
					$el.find('.methods-not-found').removeClass('is-hidden');
					$methodList.html('');
				}

				$container.removeClass('loading');

				self.setZipcodeField({ required: !!self.droppoint.type, show: self.hasDroppointMethods });

				self.updateListHeight();
				checkout.order.update();
				checkout.modal.validateForm();
			});
		}

		function filterDeliveryData(data) {
			var deliveryCount = 0,
				specificDeliveryCount = 0,
				propsToRemove = ['isBringPP', 'isDao', 'isGls', 'isPostDK'];

			return data.filter(function(deliveryMethod){
				if (deliveryMethod.name !== 'delivery_method') {
					specificDeliveryCount++;
					if (specificDeliveryCount >= 4) {
						return false;
					}
				} else {
					var limit = specificDeliveryCount ? self.methodLimit : self.methodLimit + 1;
					deliveryCount++;
					if (deliveryCount >= limit) {
						return false;
					}
				}
				propsToRemove.forEach(function(prop){
					if (deliveryMethod[prop]) {
						deliveryMethod.droppointName = droppointName(prop);
						self.hasDroppointMethods = true;
					}
					delete deliveryMethod[prop];
				});
				return true;
			});
		}

		function droppointName(propName) {
			switch (propName) {
				case 'isBringPP':
					return 'bringpp';
				case 'isDao':
					return 'dao';
				case 'isGls':
					return 'gls';
				case 'isPostDK':
					return 'postdk';
				default:
					return '';
			};
		}

		self.initPreselectedMethods = function () {
			var $radios = $methodList.find('.delivery-header').next('.delivery-method').find('.delivery-method-radio');
			$radios.change();
			self.userChangedDelivery = true;
		}

		self.getInputIDs = function (toString) {
			var vals = [];
			$methodList.find('input:radio:checked').each(function () {
				vals.push($(this).val());
			});
			return toString ? vals.join(',') : vals;
		}

		// Button: change droppoint -- show avaidable droppoints
		$el.on('click', '.delivery-method .change-droppoint', function () {
			self.droppoint.setList({ open: true });
			checkout.modal.validateForm();
		});

		$el.on('click', '.delivery-method .change-delivery', 
			_.debounce(function () {
				self.setList({ open: true });
			}, 10)
		);

		// Radio input: choose a DropPoint
		$el.on('change', '.delivery-method .target-container .radio', function () {
			var $this = $(this);
			self.droppoint.chosen = self.droppoint.list[parseInt($this.attr('data-index'))];
			self.droppoint.setList({ open: false });
			self.droppoint.renderAll();
			checkout.modal.validateForm();
		});

		var $deliveryNotice = $el.find('.notice-delivery'),
			$textarea = $deliveryNotice.find('textarea');

		self.setDeliveryNotice = function (option) {
			if ('show' in option) {
				$deliveryNotice[(option.show ? 'remove' : 'add') + 'Class']('is-hidden');
				$textarea.val('');
				$textarea.prop('required', option.show);
				$textarea.prop('disabled', !option.show);
			}
			if ('showContainer' in option) {
				$el.find('.delivery-notice')[(option.showContainer ? 'remove' : 'add') + 'Class']('is-hidden');
			}
		};

		// customer notice: expand/colapse textarea on mobile
		$el.on('focus blur', '#customerNotice, #customerNoticeDelivery', function () {
			var $this = $(this);
			if ($this.is(':focus')) {
				$this.addClass('open');
			} else if ($this.val().length < 70){
				$this.removeClass('open');
			}
		});
		
		$el.on('input', '#customerNoticeDelivery', 
			_.debounce(function () {
				checkout.modal.validateForm();
			}, 100)
		);

		// Customer notice: display clear button
		$el.on('input', '#customerNotice, #customerNoticeDelivery', function () {
			var $this = $(this),
				$clearButton = $this.parents('.form-group').find('.clear');
			$clearButton[($this.val() ? 'remove' : 'add') + 'Class']('is-hidden');
		});

		// Customer notice: clear textarea
		$el.on('click', '.delivery-notice .clear', function () {
			var $this = $(this),
				$note = $this.parents('.form-group').find('textarea');
			$note.val('');
			$note.removeClass('open');
			$this.addClass('is-hidden');
			self.updateListHeight();
			checkout.modal.validateForm();
		});

		// Delivery method: update choosen method
		$el.on('change', '.delivery-method .delivery-method-radio', function () {
			var $this = $(this);

			self.$deliveryMethod = $this.parents('.delivery-method');
			if (!self.$deliveryMethod.length || self.$deliveryMethod.hasClass('special-delivery')) {
				return;
			}

			self.$deliveryMethod.css('display', 'block');

			self.droppoint.type = $this.data('droppoint') ? $this.data('droppoint') : null;
			self.setDeliveryNotice({ show: $this.hasClass('messageField') });
			self.setZipcodeField({ required: !!self.droppoint.type });

			// Restore state if any
			var ids = self.getInputIDs();
			if (ids.length) {
				ids.forEach(function (id) {
					$el.find('.delivery-method input[value="' + id + '"]').checked(true);
				});
			} else {
				var methodInput = $el.find('input[name="post_delivery_method"]').val();
				if (methodInput != '') {
					$el.find('input[name="delivery_method"][value="' + methodInput + '"]').checked(true);
				}
				$el.find('input.post_delivery_method_fixed').each(function () {
					var $this = $(this),
						k = $this.attr('name').replace('post_', ''),
						v = $this.val();
					$el.find('input[name="delivery_method_' + k + '"][value="' + v + '"]').checked(true);
				});
			}

			checkout.order.update();
			self.setList({ open: false });
			checkout.modal.validateForm();
		});
		
		self.containerHeight.limit = window.innerHeight * 0.6;
		self.updateListHeight = function () {;
			$methodList = $el.find('.delivery-method-list');
			self.containerHeight.min = 1;
			self.containerHeight.max = 0;

			$methodList.children().each(function () {
				var $this = $(this),
					scrollHeight = parseInt($this.prop('scrollHeight'));
				
				if ($this.hasClass('active') || (self.containerHeight.min + scrollHeight) <= self.containerHeight.limit) {
					self.containerHeight.min += Math.ceil(scrollHeight);
				}
				
				self.containerHeight.max += Math.ceil(scrollHeight);
			});

			var droppointListOpen = self.$deliveryMethod && self.$deliveryMethod.find('.target-container').hasClass('open');
			$methodList.css('max-height',
				($methodList.hasClass('open') || droppointListOpen ? self.containerHeight.max : self.containerHeight.min) + 'px'
			);
		}

		// zipcode: search DropPoint
		$el.on('input', '.delivery-method .w-zipcode', _.debounce(function (e) {
			e.preventDefault();
			var $this = $(this),
				splitter = ', ',
				val = $this.val();

			if (val.indexOf(splitter) !== -1) {
				val = val.split(splitter);
				var zipcode = val[0],
					address = val.splice(1, val.length - 1).join(splitter);
				self.droppoint.update(zipcode, address);
			} else {
				self.droppoint.update(val);
			}
		}, 1000));

		self.setList = function (options) {
			if ('open' in options) {
				var	$mainContainer = $el.find('.delivery-method-list'),
					$containers = $mainContainer.find('.location-container');

				checkout.order.setOrderSummary({ collapse: options.open });

				if (options.open) {
					self.$deliveryMethod.removeClass('active');
					self.$deliveryMethod.find('input:checked').prop('checked', false);
					self.$deliveryMethod.find('.location-container').addClass('is-hidden');
					
					self.droppoint.chosen = null;
					self.droppoint.list = null;
					self.droppoint.type = null;
					$containers.addClass('is-hidden');
					
					checkout.order.update();
					checkout.modal.validateForm();
					
					self.$deliveryMethod.siblings('.delivery-method:not(.special-delivery)').fadeIn(300, function () {
						$mainContainer.find('.change-delivery').addClass('is-hidden');
						self.setDeliveryNotice({ showContainer: false });
						self.updateListHeight();
					});
				} else {
					self.$deliveryMethod.siblings().removeClass('active');
					self.$deliveryMethod.addClass('active');
					self.$deliveryMethod.find('.location-container').removeClass('is-hidden');
					
					$mainContainer.fadeOut(300, function () {
						self.$deliveryMethod.siblings('.delivery-method:not(.special-delivery)').each(function () {
							var $this = $(this);
							if ($tmpl.version && !$this.find('.delivery-method-radio').is(':checked')) {
								$this.css('display', 'none');
							}
						});
						self.droppoint.update();
					}).fadeIn(300, function () {
						if ($el.find('.delivery-method-radio:checked').lentgh > 1 && self.droppoint.chosen) {
							self.containerHeight.limit = 350;
						}
						$mainContainer.find('.change-delivery').removeClass('is-hidden');
						self.setDeliveryNotice({ showContainer: true });
						self.updateListHeight();
					});
				}
				self.listIsOpen = options.open;
			}
		}

		self.droppoint = {
			chosen     : null,
			list       : null,
			type       : null,
			listIsOpen : false,

			setList : function (options) {
				if ('open' in options) {
					if (options.open) {
						self.$deliveryMethod.find('.target-container').addClass('open');
						self.$deliveryMethod.find('.droppoint-active').addClass('is-hidden');
					} else {
						self.$deliveryMethod.find('.droppoint-active').removeClass('is-hidden');
						self.$deliveryMethod.find('.target-container').removeClass('open');
					}
					checkout.order.setOrderSummary({ collapse: options.open });
					self.setDeliveryNotice({ showContainer: !options.open });
					checkout.modal.validateForm();
					self.updateListHeight();
					this.listIsOpen = options.open;
				}
			},
			update : function (zipcode, address) {
				if (!self.droppoint.type) {
					return;
				}
				var $activeDroppoint = self.$deliveryMethod.find('.droppoint-active'),
					$container = self.$deliveryMethod.find('.location-container'),
					val = {
						address: address || (user && user.Address.length ? user.Address : false),
						zipcode: zipcode ? zipcode : self.$zipcode.val() || credentials.zipcode,
						country: self.$country.val() || credentials.country
					};

				$container.removeClass('is-hidden').addClass('loading');
				$.get(checkoutAction, {
					page: 'checkout',
					action: 'droppoints',
					type: self.droppoint.type,
					delivery_zip: val.zipcode,
					delivery_country: val.country,
					delivery_address: val.address
				}).done(function (data, status, jqXHR) {
					$container.removeClass('loading');
					if (data.result.length) {
						if (!$container.hasClass('open')) {
							self.droppoint.chosen = data.result[0];
						}
						self.droppoint.list = data.result;
						self.droppoint.renderAll();
					} else {
						var helpers = {
							hasDefault: self.droppoint.type === 'postdk' || self.droppoint.type === 'gls' && (val.country === 'DK' || val.country === 'SE')
						};
						var data = {
							gls: {
								text: text.CHECKOUT_STEP_TWO_GLS_NOT_SPECIFIED,
								input: 'gls_location'
							},
							postdk: {
								text: text.CHECKOUT_STEP_TWO_POSTDK_NOT_SPECIFIED,
								input: 'postdk_location'
							}
						};
						$container.find('.droppoint-list').html($tmpl.emptyLocation.render(helpers.hasDefault && data[self.droppoint.type], helpers));
						$activeDroppoint.html($tmpl.emptyLocation.render(helpers.hasDefault && data[self.droppoint.type], helpers));
					}
					self.updateListHeight();
					checkout.modal.validateForm();
				});
			},
			renderAll : function () {
				self.$deliveryMethod.find('.droppoint-active').html($tmpl.activeDroppoint.render(self.droppoint.chosen));
				self.$deliveryMethod.find('.droppoint-list').html($tmpl.droppoint.render(self.droppoint.list));
			}
		}
	}

	function Order (checkout) {
		var $el = checkout.$el,
			delivery = checkout.delivery,
			self = this;

		self.paymentType = $el.find('[name=betalings_type]').val();
		self.pbsType = $el.find('[name=pbs_type]').val();

		self.setOrderSummary = function (option) {
			if ('collapse' in option) {
				$el.find('.order-summary')[(option.collapse ? 'add' : 'remove') + 'Class']('is-collapsed');
			}
		}

		self.update = function () {
			var $order = $el.find('.order');
			$.get(checkoutAction, {
				page: 'checkout',
				action: 'order_summary',
				delivery_country: checkout.delivery.country,
				delivery_methods: checkout.delivery.getInputIDs(true),
				payment_method: self.paymentType,
				payment_method_online: self.pbsType
			}).done(function (data) {
				var cartData = platform.cart.data,
					orderData = $.extend(data.result, {
						orderLineLimit: 9,
						products: {
							amount: cartData.CartProductCount,
							price: platform.currency_format(data.result.orderLinesTotal)
						}
					});
					
				if (data.result.salesDiscount.id) {
					var label = parseInt(data.result.salesDiscount.price) > 0 ? text.FEE : text.DISCOUNT;
					orderData.discount = {
						price: data.result.salesDiscount.priceFormatted,
						title: label + ':&nbsp;' + data.result.salesDiscount.title
					}
				}

				$order.html($tmpl.orderSummary.render(orderData));
				
				if (delivery.listIsOpen) {
					self.setOrderSummary({collapse: true});
				}

				if (platform.settings.shop_delivery_hidden) {
					$order.find('.order-summary').css('max-height', 'none');
				}
			});
		}


		//
		// Terms and conditions
		//
		
		var $termsLink = $el.find('.termsAndConditionsLink');

		if (!$termsLink.length) {
			return;
		}

		$termsLink.on('click', function () {
			var terms = self.terms; 
			if (terms.hasContentLoaded) {
				terms.openModal();
			} else {
				terms.createModal(function () {
					terms.openModal();
					terms.hasContentLoaded = true;
				});
			}
		});
		
		$el.on('click','.w-checkout-terms-close', function () {
			self.terms.closeModal();
		});

		self.terms = new Terms();
		
		function Terms () {
			this.$overlay = null;
			this.hasModalLoaded = false;
			this.pageId = user && user.IsB2B && platform.settings.link_terms_and_conditions_b2b
					? platform.settings.link_terms_and_conditions_b2b
					: platform.settings.link_terms_and_conditions;

			this.getPageContent = function (callback) {
				var self = this;
				$.get('/json/page', {id: self.pageId})
					.done(function(data) {
						callback && callback(data);
					}
				);
			},
			this.createModal = function (callback) {
				var self = this;
				this.getPageContent(function (data) {
					var html = $tmpl.terms.render(data);
					var $modal = $el.find('.modal-container');
					$modal.append(html);
					self.$modal = $modal.find('.w-checkout-terms-overlay');
					callback && callback(data);
				});
			},
			this.openModal = function () {
				this.$modal.addClass('open');
			},
			this.closeModal = function () {
				this.$modal.removeClass('open');
			}
		}
	}

	function Cart (checkout) {
		var self = this;

		platform.subscribe('/product/selected', function (event, data) {
			if(data && data[1]) {
				self.variantChosenData = data[1];
			}
		});

		self.addProduct = function(callback) {
			var product = platform.product,
				cart = platform.cart,
				$notification = checkout.$el.find('[data-w-checkout=cart-response]');

			if (!product) {
				checkout.modal.buttonLoading(false);
				return;
			}
			
			if ((product.Type === 'packet' || product.Type === 'variant') && !platform.productController.productType.canDoActions()) {
				checkout.modal.buttonLoading(false);
				product.showWarning();
				return;
			}

			cart.action( 'add', {
				data: $('form[name=cartadd]').serialize(),
				then: function (data) {
					if (data.type == 'cart_add_success') {
						if (cart.data.CartBlock) {
							window.location.href = '/' + text.CART_LINK + '/';
							return;
						}
						$notification.text(text.CART_ADD_SUCCESS);
						setTimeout(function () {
							$notification.addClass('active');
							setTimeout(function () {
								$notification.removeClass('active');
							}, 4000);
						}, 1500);
						callback && callback();
					} else {
						reset(data.text);
					}
				},
				fail: function () {
					checkout.modal.buttonLoading(false);
				}
			});

			function reset(error) {
				product.showWarning();
				checkout.order.update();
				checkout.modal.close();
				checkout.modal.buttonLoading(false);
				error && error.length && alert(error);
			}
		}
	}

	$(function () {
		var $widgets = $('[data-w-checkout=modal]'),
			$buttons = $('.w-checkout-buttons'),
			hasGeneralRequirements = !!platform.cart.get,
			hasCartRequirements = !!platform.cart.action && !!platform.subscribe && !!platform.productController;
		
		if (!$widgets.length || !$buttons.length) {
			return;
		} else if ((isProductPage && !hasCartRequirements) || !hasGeneralRequirements) {
			$buttons.detach();
			$widgets.detach();
			console.error('Checkout widget has been disabled: please update your app.js');
			return;
		} else if (!$buttons.hasClass('w-checkout-buttons--block')) {
			platform.cart.get(function (data) {
				if (data.CartBlock) {
					$buttons.addClass('w-checkout-buttons--block');
					return;
				}
			});
		}

		platform.checkout = platform.checkout || {};

		$widgets.each(function () {
			var $this = $(this), 
				type = $this.find('input[name=checkoutType]').val();
			platform.checkout[type] = new Checkout($this, type);
		});
	});

})(jQuery, window.platform, window);
