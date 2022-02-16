;(function($, platform, exports) {
	'use strict';

	var hasPromiseSupport = (function() {
		return 'Promise' in window &&
			// Some of these methods are missing from
			// Firefox/Chrome experimental implementations
			'resolve' in window.Promise &&
			'reject' in window.Promise &&
			'all' in window.Promise &&
			'race' in window.Promise &&
			// Older version of the spec had a resolver object
			// as the arg rather than a function
			(function () {
				var resolve;
				new window.Promise(function (r) { resolve = r; });
				return typeof resolve === 'function';
			}());
	})();

	var hasSupportTests = typeof window.OnPayIO == "function";

	if (hasPromiseSupport && hasSupportTests) {
		OnPayIO.applePay.available().then(function(v) {
			exports.platform.checkout.hasApplePaySupport = v;
		});
		OnPayIO.googlePay.available().then(function(v) {
			exports.platform.checkout.hasGooglePaySupport = v;
		});
	}

	exports.platform = exports.platform || {};
	exports.platform.checkout =
	{
		firstload: true,
		loader: null,
		wrapper: null,
		ajaxUrl: '/actions/handler/ajax',
		hasApplePaySupport: false,
		hasGooglePaySupport: false,
		load: function () {

			var self = this;

			self.wrapper = $('.checkoutFrame');

			self.loader = $('<img/>').attr({
				'class': 'loader',
				src: platform.template.cdn + '/_design/common/img/preloader/preloader-black.gif',
				alt: ''
			});

            if (platform.hasOwnProperty("UserLookupService")) {
                platform.checkout.userlookup = new platform.UserLookupService(
                   {
                    'firstname'     : '#firstname',
                    'lastname'      : '#lastname',
                    'companyname'   : '#company',
                    'vatnumber'     : '#vatNumber',
                    'phonenumber'   : '#phone, #mobile',
                    'adress'        : '#address',
                    'zipcode'       : '#zipcode',
                    'city'          : '#city'
                   }
                );
            }

			// Bind events
			self.binds();

			if ($('.step3', self.wrapper).length) {
				self.STEP3.load();
			}

			self.STEP1.load();

			self.drawStepNumbers();

            // Check if cvr is set by browser back or reload event
            // and set Vat rates appropriately
            var fields = self.STEP1.relevantFieldDatas();
            if (fields.cvr && fields.cvr.length) {
                self.setVatRates();
            }
		},
		binds: function() {

			var self = this;

			// Validate the submit of the checkout form
			// The global field "check_stage_all_loaded" should have a value of "1"
			// and there should be no active jQuery requests (jQuery.active)
			$('.checkoutForm', self.wrapper).on('submit', function () {
				var that = this;

				if ($('#check_stage_all_loaded').val() == '1' && $.active === 0) {
					var step4 = platform.checkout.STEP4.relevantFieldDatas();
					self.authorized = false;

					if (step4.paymentMethod == "9" && step4.paymentType && !self.authorized) {
						var orderData = platform.checkout.STEP4.orderSummaryData;

						self.toggleSubmitButton(true);

						$.when(platform.checkout.STEP4.klarnaHandler.authorize(step4.paymentType, orderData)).always(
							function (isAuthorized) {
								self.authorized = isAuthorized;
								if (self.authorized) {
									that.submit();
								} else {
									self.toggleSubmitButton(false);
								}
							}
						);

						return false;
					} else {
						// avoid order duplicates
						self.toggleSubmitButton(true);
						setTimeout(function () { self.toggleSubmitButton(false); }, 3000);
					}
					return true;
				}
				alert(text.CHECKOUT_STEP_FOUR_TOTALS_NOT_LOADED);
				return false;
			});

			if (!platform.getSetting('shop_delivery_hidden')) {
			    $(self.STEP1).on('addresschange', function() {
					$('#check_stage_all_loaded').val('0');
					self.STEP2.load();
				});
				$(self.STEP2).on('change', function() {
                    $('#check_stage_all_loaded').val('0');
                    self.STEP4.load();
				});
			}

			$(self.STEP1).on('countrychange', function() {
				$('#check_stage_all_loaded').val('0');
				if (!platform.getSetting('shop_delivery_hidden')) {
					self.STEP2.load();
				} else {
					self.STEP4.load();
				}
			});

			if (platform.getSetting('module_shop_packing')) {
				$('#check_stage_all_loaded').val('0');
                $(self.STEP3).on('change', function() {
					self.STEP4.load();
				});
			}
		},
		setVatRates: function() {
			var self = this;

			// When country changes, make sure to change the VAT calculations
			$('#check_stage_all_loaded').val('0');

            var fields = self.STEP1.relevantFieldDatas();

            $.get(platform.checkout.ajaxUrl, {
            	page: 'checkout',
            	action: 'delivery_country',
            	'delivery_country': fields.country,
            	company: fields.company,
            	cvr: fields.cvr,
            	createUserChecked: $('.step1 #createUser').is(':checked')
            }).then(function(data) {
                $(self.STEP1).trigger('countrychange');
			});
		},
		toggleSubmitButton: function(disable) {
			var self = this,
				btn = $("button[type='submit']", self.wrapper);

			if (disable) {
				btn.prop("disabled", "disabled");
			} else {
				btn.prop("disabled", false);
			}
		},
		loaded: function(data) {
			var self = this;

			// Bind standard data to certain fields, containing their original value/ checked state
			$('.step1', self.wrapper).find('input:text').each(function() {
				$(this).data('pre', $(this).val());
			});

			$('.step2, .step3, .step4', self.wrapper).find('input:radio').each(function() {
				$(this).data('pre', $(this).is(':checked'));
			});

			// Bind a new event to textfields, it only triggers if the value changes from or to empty
			$('.step1', self.wrapper).find('input:text').on('keyup', function() {
				if (($(this).data('pre') == '' && $(this).val() != '') || ($(this).data('pre') != '' && $(this).val() == '')) {
					$(this).trigger('valuechange');
				}

				$(this).data('pre', $(this).val());
				self.STEP1.loadpostdk = true;
				self.STEP1.loadgls = true;
				self.STEP1.loadbringpp = true;
				self.STEP1.loaddao = true;
			});

			if (self.firstload) {

                $('.checkoutLoading').hide();

                self.wrapper.show();

				$(platform.checkout).trigger('firstdone', [data.result]);

				if (typeof window.gtag === 'function' && typeof ga === 'function' && window.platform && window.platform.subscribe) {
					window.platform.subscribe("/cart/ready", function () {
						if (window.platform.analytics) {
							platform.checkout.STEP2.googleAnalytics();
							platform.checkout.STEP4.googleAnalytics();
						}
					});
				}
			}

            $('#check_stage_all_loaded').val('1');

			self.firstload = false;

            $(self).trigger('done', [data.result]);
		},
		showMessage: function (type, message) {
			alert(message);
		},
		drawStepNumbers: function () {
			var i = 1,
				self = this;
			$('.stepNumber', self.wrapper).each(function () {
				$(this).text(i++ + '.');
			});
		},
		STEP1: {
			wrapper: null,
			// Activate step 1
			load: function() {

				this.wrapper = $('.step1');

				// Bind events
				this.binds();

				// Run actions
				this.actions();

				// Load triggers
				this.triggers();

				// Module loaded
				this.loaded();
			},
			// Bind actions to step1
			binds: function () {

				var self = this,
                    countryCode;

				// Toggle slide on activate delivery address checkbox
				$('#deliveryActive').on('change', function (e) {
					$('.deliveryContactInfo').slideToggle();
					if ($(this).is(':checked')) {
						$('.deliveryContactInfo input').attr('disabled', false);
					} else {
						$('.deliveryContactInfo input').attr('disabled', true);
					}
				});

				$('#newsletter').on('change', function (e) {
					self.toggleInterests();
				});

				// Bind slidetoggle to create user checkbox
				$('#createUser').on('change', function (e) {
					$('#inputPassword').slideToggle();
					self.toggleInterests();

					if ($(this).is(':checked')) {
						$('#inputPassword input').attr('disabled', false);
					} else {
						$('#inputPassword input').attr('disabled', true);
					}
				});

				$('#zipcode', self.wrapper)
					.on('blur', function (event) {
						event.target.value = event.target.value.trim();
						self.findCounty('normal');
					})
					.on('input', function () {
						$('#city').val('');
					});

				$('#deliveryZipcode', self.wrapper)
					.on('blur', function (event) {
						event.target.value = event.target.value.trim();
						self.findCounty('delivery');
					})
					.on('input', function () {
						$('#deliveryCity').val('');
					});

				$('#city, #deliveryCity', self.wrapper).on('keyup', function () {
					$(this).removeData('autofilled');
				});

				$('#country', self.wrapper).SmartForm('countrycode', {
					target: function (code) {
						$('.step1 span.countryCode').text('+' + code);
						$('.step1 input.countryCode').val(code);
						platform.checkout.setVatRates();

                        if (platform.hasOwnProperty("UserLookupService")) {
                            countryCode = code;
                            platform.checkout.userlookup.setCountry({'country':$("#country").val(), 'code': countryCode});
                        }
					}
				});

                $('#deliveryCountry', self.wrapper).SmartForm('countrycode', {
                    target: function (code) {
                        $('.step1 span.deliveryCountryCode').text('+' + code);
                        $('.step1 input.deliveryCountryCode').val(code);
                    }
                });

                var handleCountryChange = function(e) {
                    var $this = $(this);

					if ($('#city').data('autofilled')) {
						$('#city').val('').removeData('autofilled');
					}

                    if (platform.hasOwnProperty("UserLookupService")) {
                        platform.checkout.userlookup.setCountry({'country':$("#country").val(), 'code': countryCode ? countryCode : platform.general.deliveryCountryCode });
                    }

                    handleCountryChangeState($this);
              	};

                var handleCountryChangeState = function ($this) {
                    // State
                    $('.' + $this.attr('id') + '-state-group', self.wrapper).addClass('is-hidden');
                    $('.' + $this.attr('id') + '-state-select', self.wrapper).each(function() {
                        $(this).val('');
                        $(this).attr('disabled', true);
                    });

                    var el = $this.is('[type="hidden"]') ? $this : $this.find(':selected');
                    if (el.data('hasStates') > 0) {
                        var $group = $('.' + $this.attr('id') + '-state-group-' + el.val(), self.wrapper);
                        $group.removeClass('is-hidden');
                        $('select', $group).attr('disabled', false);
                    }
                };

                var countryInput = $('.country-select', self.wrapper);
                if (countryInput.length) {
                    countryInput.on('change', handleCountryChange);
                } else {
                    countryInput = $("#country");
                }
                handleCountryChange.call(countryInput, []);

              	$('#deliveryCountry', self.wrapper).on('change', function(e) {
					platform.checkout.setVatRates();

                    handleCountryChangeState( $(this) );

					if ($('#deliveryCity').data('autofilled')) {
						$('#deliveryCity').val('').removeData('autofilled');
					}
              	});

				var customerTypeInput = $('input[name=customer-type]', self.wrapper);
				if (customerTypeInput.length) {
					customerTypeInput.on('click', function (e) {
						$('input[name=customer-type]').each(function (index, el) {
							$(el.parentNode).addClass('button');
							$(el.parentNode).removeClass('button-primary');
						})
						$(e.currentTarget.parentNode).removeClass('button');
						$(e.currentTarget.parentNode).addClass('button-primary');
					});
	
					customerTypeInput.on('change', function (e) {
						var companyInputFields = $('[data-active-on-customer-type="company"]');
						var institutionInputFields = $('[data-active-on-customer-type="institution"]');
						var selectedCustomerType = e.target.value;
	
						if (selectedCustomerType === 'company') {
							$.each(companyInputFields, enableField);
							$.each(institutionInputFields, disableField);
						} else if (selectedCustomerType === 'institution') {
							$.each(companyInputFields, disableField);
							$.each(institutionInputFields, enableField);
						} else { // Private
							$.each(institutionInputFields, disableField);
							$.each(companyInputFields, disableField);
						}
						
						platform.checkout.setVatRates();
						
						function disableField (index, fieldsetEl) {
							var input = $(fieldsetEl).find('input');
							input.val('');
							input.prop('required', false);
							input.prop('disabled', true);
							$(fieldsetEl).hide();
						}
	
						function enableField (index, fieldsetEl) {
							var el = $(fieldsetEl)
							el.find('input').prop('disabled', false);
							el.find('[data-is-required]').prop('required', true);
							el.show();
						}
					});
				}

			},
			// Trigger needed actions
			actions: function () {

				// Check the activate delivery address checkbox if active
				if ($('#deliveryActive').is(':checked')) {
					$('#deliveryActive').trigger('change');
					platform.checkout.setVatRates();
				}

				// Check the create user checkbox if active
				if ($('#createUser').is(':checked')) {
					$('#createUser').trigger('change');
				}

				// Check the newsletter checkbox if active
				if ($('#newsletter').is(':checked')) {
					$('#newsletter').trigger('change');
				}
			},
			// Certain field changes needs to trigger a change in the oter steps
			triggers: function() {
				var self = this;

              	$('#zipcode, #address, #deliveryZipcode, #deliveryAddress', self.wrapper).on('change', function(e) {
                    $(self).trigger('addresschange');
              	});

              	$('#vatNumber, #eanNumber, #company, #deliveryCompany', self.wrapper).on('valuechange', function(e) {
					platform.checkout.setVatRates();
              	});

              	$('#deliveryActive, #createUser', self.wrapper).on('change', function(e) {
					platform.checkout.setVatRates();
              	});
			},
			findCounty: function(type) {
				if (type == 'normal') {
					var zipField = '#zipcode';
					var cityField = '#city';
					var countryField = '#country';
				} else {
					var zipField = '#deliveryZipcode';
					var cityField = '#deliveryCity';
					var countryField = '#deliveryCountry';
				}

				if ($(zipField).val().length == 4 && $(countryField).val() == 'DK') {
					$.getJSON(platform.checkout.ajaxUrl, {
						page: 'helper',
						action: 'find_county',
						zip: $(zipField).val(),
						country: $(countryField).val().toLowerCase()
					}).then(function(data) {
	                    if (data.result) {
	                        $(cityField).val(data.result);
	                        $(cityField).data('autofilled', '1').blur();
	                    }
	                });
	            }
			},
			// Toggles interest fields
			toggleInterests : function() {
                var newsbox = $("#newsletter").is(':checked');
                var userbox = $("#createUser").is(':checked');

                var interests = $("#interests_customer");
                var interests_customer = $("#interests");

                $('.interestsContainer input').checked(false);
                var el = (newsbox ? (userbox ? interests : interests_customer) : '');
                if (el != '') {
                    if (interests != el) interests.slideUp();
                    else interests_customer.slideUp();
                    el.slideDown();
                } else {
                    interests.slideUp();
                    interests_customer.slideUp();
                }
            },
            relevantFieldDatas: function(noDelivery) {
				if (noDelivery != true && $('.step1 #deliveryActive').is(':checked')) {
					var eventData = {
						country: $('.step1 #deliveryCountry').val(),
						zip: $('.step1 #deliveryZipcode').val().trim(),
						city: $('.step1 #deliveryCity').val(),
						address: $('.step1 #deliveryAddress').val(),
						company: $('.step1 #company:enabled').length ? $('.step1 #company:enabled').val() : '',
						cvr: $('.step1 #vatNumber:enabled').length ? $('.step1 #vatNumber:enabled').val() : '',
						ean: $('.step1 #eanNumber:enabled').length ? $('.step1 #eanNumber:enabled').val() : ''
					};
                } else {
					var eventData = {
						country: $('.step1 #country').val(),
						zip: $('.step1 #zipcode').val().trim(),
						city: $('.step1 #city').val(),
						address: $('.step1 #address').val(),
						company: $('.step1 #company:enabled').length ? $('.step1 #company:enabled').val() : '',
						cvr: $('.step1 #vatNumber:enabled').length ? $('.step1 #vatNumber:enabled').val() : '',
						ean: $('.step1 #eanNumber:enabled').length ? $('.step1 #eanNumber:enabled').val() : ''
					};
                }

                eventData.deliveryActive = $('.step1 #deliveryActive').is(':checked');
                eventData.deliveryCompany = eventData.deliveryActive ? $('.step1 #deliveryCompany').val() : '';

                return eventData;
	        },
	        showDeliveryAddressOption: function(show) {
	        	var deliveryAddressOption = $('.step1 .deliveryContactInfoContainer');

	        	if (show) {
	        		deliveryAddressOption.show();
	        	} else {
	        		deliveryAddressOption.hide();
	        	}
	        },
	        loaded: function(data) {
				$(this).trigger('countrychange');

				if ($('input[name=customer-type]').length) {
					// Show customer-type input and enable dynamic fields
					$('.m-checkout-customer-type').show();
					$('.customer-type-dynamic-fields').show();

					// Hide old static company and institution fields
					$('.customer-type-static-fields').remove();
					
					// Preselct customer type
					var cvr = $('#vatNumber').val();
					var ean = $('#eanNumber').val();				
					if (cvr !== '') {
						$('input[name="customer-type"][value="company"]').click();
					} else if (ean !== '') {
						$('input[name="customer-type"][value="institution"]').click();
					}
				}
			},
			loadpostdk: true,
			loadgls: true,
			loadbringpp: true,
			loaddao: true
		},
		STEP2 : {
			wrapper: null,
			firstload: true,
            load: function() {
            	var self = this;

            	self.wrapper = $('.step2');

                if (self.firstload) {
                    self.$deliverymessage = $('[data-js="customernoticedelivery"]');
                	self.binds();
                	self.firstload = false;

                    var $deliveryTime = $("#deliveryTime");

                    if ( window.hasOwnProperty("Cleave") && !hasInputTimeSupport() && $deliveryTime.length ) {
                        var cleaveCustom = new Cleave($deliveryTime[0], {
                            blocks: [2, 2],
                            delimiter: ':'
                        });
                    }
				}

            	self.deliveryMethods();
            },
			deliveryMethods: function() {
				var self = this,
                	step1fields = platform.checkout.STEP1.relevantFieldDatas(),
                	step2fields = this.relevantFieldDatas();

				self.oldData = self.oldData || undefined;
				self.latestRequest = self.latestRequest || false;

				self.latestRequest = $.ajax({
					url: platform.checkout.ajaxUrl,
					dataType: "json",
                	data: {
                		'page': 'checkout',
			        	'action': 'delivery_methods',
			        	'delivery_country': step1fields.country,
			        	'delivery_zip': step1fields.zip,
			        	'cvr': (step1fields.deliveryActive ? (step1fields.deliveryCompany != '' ? '1' : '') : (step1fields.company != '' ? '1' : '')),
			        	'delivery_address': step1fields.deliveryActive,
						'user_type': (step1fields.company == '' && step1fields.ean == '' && step1fields.cvr == '' ? 'private' : (step1fields.company != '' && step1fields.cvr != '') ? 'company' : (step1fields.company != '' && step1fields.ean != '') ? 'institution' : 'private'),

						'beforeSend': function name(jqXHR, settings) {
							/* https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState */
							if (self.latestRequest && self.latestRequest.readyState < 4) {
								self.latestRequest.abort();
							}
						}
					}
				})
				.done( function(data, textStatus, jqXHR) {

					$('.deliveryMethodContainerMain', self.wrapper).empty();

					if (self.$deliverymessage && self.$deliverymessage.length) {
						self.$deliverymessage
							.addClass("is-hidden")
							.detach();
					}

					if (data.result.length) {
						$('.deliveryMethodNotFound', self.wrapper).hide();
						$('.deliveryMethodContainerMain', self.wrapper).html($('#deliveryMethodTemplate').render( data.result ));
					} else {
						$('.deliveryMethodNotFound', self.wrapper).show();
						$(self).trigger('change');
					}

					// Restore state if any
					if (step2fields.deliveryMethodIds != '') {
						$(step2fields.deliveryMethodIds.split(',')).each(function() {
							$('.deliveryMethodSelector input[value="'+this+'"]', self.wrapper).checked(true);
						});
					} else {
						var deliveryMethod = $('input[name="post_delivery_method"]', self.wrapper).val();
						if (deliveryMethod != '') {
							$('input[name="delivery_method"][value="' + deliveryMethod + '"]', self.wrapper).checked(true);
						}

						$('input.post_delivery_method_fixed', self.wrapper).each(function() {
							var k = $(this).attr('name').replace('post_', '');
							var v = $(this).val();
							$('input[name="delivery_method_'+k+'"][value="' + v + '"]', self.wrapper).checked(true);
						});
					}

					// Overwrite restore state if a new deliveryMethod has lower sorting
					if ( data.result.length && $.isArray(self.oldData) && self.oldData.length && data.result[0].value !== self.oldData[0].value ) {
						$('input.deliveryMethodRadio:checked', self.wrapper).checked(false);
					}
					self.oldData = data.result;

					// Check for pre-checked methods and trigger them
					var methods = $('input.deliveryMethodRadio:checked', self.wrapper);
					if (methods.length) {
						methods.trigger('change');

					// If several groups exists, check all the firsts, but trigger only one
					} else if ($('.deliveryMethodGroupContainer').length > 1) {
						$('.deliveryMethodGroupContainer').find('input.deliveryMethodRadio:first').checked(true).first().trigger('change');

					// If none or not enough groups exists, check and trigger the very first delivery method
					} else {
						$('input.deliveryMethodRadio:first', self.wrapper).checked(true).trigger('change');
					}

					self.loaded(data);
				});
		    },
			droppointTemplate: $.templates('<li class="radio"><fieldset class="form-group"><div class="input-group"><span class="input-group-addon"><input id="droppoint_{{:inputName}}_{{:#index}}" type="radio" name="{{:inputName}}" class="radiobtn" value="{{:reference}}"></span><label for="droppoint_{{:inputName}}_{{:#index}}" class="form-label input-group-main"><span class="droppointTextHeader is-block">{{:title}}</span><span class="droppointTextLine is-block">{{:address}}</span><span class="droppointTextLine is-block">{{:zipcode}} {{:city}}</span>{{if extra}}<span class="droppointTextLine is-block"><i>{{:extra}}</i></span>{{/if}}</label></div></fieldset></li>'),
			binds: function() {

				var self = this;

				$(self.wrapper).on(
					{
						change: function (e, type) {
							var method = $(this),
								fields = platform.checkout.STEP1.relevantFieldDatas(true),
								$this = $(this).parents('.deliveryMethodContainer'),
								$container = $('.locationContainer', $this),
								$droppointAddressContainer = $('.DroppointAddressContainer', $this),
								$droppointAddress = $('input[name="droppoint_address"]', $droppointAddressContainer),
								$droppointAddress = $droppointAddress.length ? $droppointAddress.val() : null,
								$droppointZipcode = $('input[name="droppoint_zipcode"]', $droppointAddressContainer),
								$droppointZipcode = $droppointZipcode.length ? $droppointZipcode.val() : null,
								hasDroppointAddress = (type == 'droppointAddress' && ($droppointAddress || $droppointZipcode)),
								fields = hasDroppointAddress ? {
									address: $droppointAddress,
									zip: $droppointZipcode,
									country: fields.country
								} : fields;

							$('.locationContainer', self.wrapper).hide();
							$droppointAddressContainer.show();

							var droppointType = null;
							if (method.hasClass('gls')) {
								droppointType = 'gls';
							}
							else if (method.hasClass('postdk')) {
								droppointType = 'postdk';
							}
							else if (method.hasClass('bringpp')) {
								droppointType = 'bringpp';
							}
							else if (method.hasClass('dao')) {
								droppointType = 'dao';
                            }

                            if (self.$deliverymessage && self.$deliverymessage.length) {
                                if (method.hasClass('messageField')) {
                                    self.$deliverymessage
                                        .removeClass("is-hidden")
                                        .appendTo($this.find('.deliveryMethodSelector'));

                                    self.$deliverymessage
                                        .find("#customerNoticeDelivery")
                                        .prop("required", true);
                                } else {
                                    self.$deliverymessage
                                        .addClass("is-hidden")
                                        .detach();

                                    self.$deliverymessage
                                        .find("#customerNoticeDelivery")
                                        .prop("required", false);
                                }
							}

							if (droppointType && (fields.zip.length >= 4 || hasDroppointAddress)) {

								platform.checkout.STEP1.showDeliveryAddressOption(false);

								self.wrapper.find('.target').empty();

								var $target = $('.target', $this);

								$target.append(platform.checkout.loader);

								$container.show();

								$.getJSON(platform.checkout.ajaxUrl, {
									page: 'checkout',
									action: 'droppoints',
									type: droppointType,
									'delivery_address': fields.address,
									'delivery_zip': fields.zip,
									'delivery_country': fields.country
								}).then(function (data, status, jqXHR) {

									if (data.result.length) {
										$target.html(self.droppointTemplate.render(data.result));
										$('input:radio', $container).first().checked(true);
										platform.fancybox && platform.fancybox.applyClass($target.find('.fancybox'));
									} else {
                                        var helpers = {
                                            hasDefault: droppointType === 'postdk' || droppointType === 'gls' && (fields.country === 'DK' || fields.country === 'SE')
                                        };

                                        var data = {
                                                'gls': {
                                                    'text': text.CHECKOUT_STEP_TWO_GLS_NOT_SPECIFIED,
                                                    'input': 'gls_location'
                                                },
                                                'postdk': {
                                                    'text': text.CHECKOUT_STEP_TWO_POSTDK_NOT_SPECIFIED,
                                                    'input': 'postdk_location'
                                                }
                                            };

										template = $('#emptyLocationTemplate');
										$target.html(template.render( helpers.hasDefault && data[droppointType], helpers));
									}
									self.droppointsLoaded(data.result, $target);

									$(self).trigger('change');
								});
							} else {
								$('.DroppointAddressContainer').each(function () {
									$('input', this).each(function () {
										$(this).val('');
									});
									platform.checkout.STEP1.showDeliveryAddressOption(true);
								});
								$(self).trigger('change');
							}

							self.googleAnalytics();
						}
					},
					'input.deliveryMethodRadio'
				);

				self.wrapper.on('click', '.SearchDroppointAddress', function () {
					$(this).parents('.deliveryMethodContainer').find('input.deliveryMethodRadio').trigger('change', ['droppointAddress']);
				});

				self.wrapper.on('click', '.DroppointAddressToggle', function () {
					var $self = $(this),
						el = $($self.data('target'), $self.parents('.DroppointAddressContainer'));
					if (el.length) {
						el.slideToggle(function () {
							$('input', el).each(function () {
								$(this).val('');
							});
							if (el.is(':hidden')) {
								$('input.deliveryMethodRadio:checked', this.wrapper).trigger('change');
							}
							$self.toggleClass('is--toggled');
						});
					}
					return false;
				});
			},
			relevantFieldDatas: function() {
				var self = this,
					vals = [];

				$('.deliveryMethodSelector input:radio:checked', self.wrapper).each(function() {
					vals.push($(this).val())
				});

				return {
					deliveryMethodIds: vals.join(',')
				}
			},
			googleAnalytics: function () {

				if (typeof window.gtag === 'function' && typeof ga === 'function' && window.platform.analyticsCart) {
					var self = this,
						fields = self.relevantFieldDatas(),
						id = fields.deliveryMethodIds.split("_");

					gtag('event', 'checkout_progress', {
						"checkout_step": 2,
						"items": window.platform.analyticsCart

					});

					gtag('event', 'set_checkout_option', {
						"checkout_step": 2,
						"checkout_option": "shipping method",
						"value": (id.length ? id[0] : '0')
					});
				}
			},
	        droppointsLoaded: function(locations, target) {
	        	$(platform.checkout).trigger('droppointsLoaded', [
		        	{
		        		locations: locations,
		        		target: target
		        	}
		        ]);
	        },
	        loaded: function(data) {
				$(platform.checkout).trigger('deliveryMethodsLoaded', [data.result]);
			}
		},
		STEP3: {
			wrapper: null,
			load: function() {
				var self = this;

				self.wrapper = $('.step3');

				self.binds();

				$.getJSON(platform.checkout.ajaxUrl, {
					page: 'checkout',
					action: 'giftwrappings'
				}).then(function (data) {
					// If giftwrappings were returned, render the template
	        		if (data.code == 0 && data.result && data.result.length) {
	        			$('.giftWrappingLeftContainer', self.wrapper).html( $('#giftWrappingTemplate').render( data.result ) );
						self.triggers();
	        		}

	        		// Else hide the giftwrappings box
	        		else {
	        			self.wrapper.remove();
	        			platform.checkout.drawStepNumbers();
	        		}
	        	});

            },
            relevantFieldDatas: function() {
				var self = this;

				return {
				 	wrappingId: $('input[name="packingType"]:checked', self.wrapper).val()
				}
			},
			triggers: function () {
				var self = this;

				// Restore state
				var state = $('input[name="post_packingType"]', self.wrapper).val();
				if (state != '') {
					$('input:radio[name="packingType"][value="' + state + '"]', self.wrapper).checked(true).trigger('change');
				}

				// Auto click the first choice
				else if (!$('input:radio:checked', self.wrapper).length) {
					$('input:radio', self.wrapper).first().checked(true);
					$(".giftWrappingRightContainer").attr('disabled', true).hide()
				}

				$('input:radio', self.wrapper).on('change', function(e){
					if(this.id =='packing_id0'){
						$(".giftWrappingRightContainer").attr('disabled', true).slideUp()
					}else{
						$(".giftWrappingRightContainer").attr('disabled', false).slideDown()
					}
				});

			},
			binds: function () {
				var self = this;
				$(self.wrapper).on('change', 'input:radio', function() {
                    $(self).trigger('change');
              	});
			}
		},
		STEP4: {
			wrapper: null,
			firstload: false,
			load: function() {
				var self = this;

				self.wrapper = $('.step4');

				if (!self.firstload) {
					self.binds();
					self.firstload = true;

					if (exports.platform.hasOwnProperty('KlarnaHandler')) {
						self.klarnaHandler = new exports.platform.KlarnaHandler();
					}
				}

				self.paymentMethods();
			},
			relevantFieldDatas: function() {
				var self = this;
				return {
					paymentMethod: $('input.paymentMethodRadio:checked', self.wrapper).val(),
					paymentType: $('input.paymentMethodRadio:checked', self.wrapper).parents('.paymentMethodContainer').find('input[type="hidden"]').val(),
					paymentMethodOnline: $('input.paymentMethodOnlineRadio:checked', self.wrapper).val()
				};
	        },
			paymentMethods: function () {
				var self = this;

				var step1fields = platform.checkout.STEP1.relevantFieldDatas();
				var step2fields = platform.checkout.STEP2.relevantFieldDatas();
				var step3fields = platform.checkout.STEP3.relevantFieldDatas();
				var step4fields = this.relevantFieldDatas();

				$.getJSON(platform.checkout.ajaxUrl, {
					page: 'checkout',
					action: 'payment_methods',
					'delivery_country': step1fields.country,
                    'delivery_zip': step1fields.zip,
					'delivery_methods': step2fields.deliveryMethodIds,
					company: step1fields.company,
					country: step1fields.country,
					cvr: step1fields.cvr,
					giftWrapping: step3fields.wrappingId,
					'user_type': (step1fields.company == '' && step1fields.ean == '' && step1fields.cvr == '' ? 'private' : (step1fields.company != '' && step1fields.cvr != '') ? 'company' : (step1fields.company != '' && step1fields.ean != '') ? 'institution' : 'private')
				}).then(function(data) {
					var $container = $('.paymentMethodContainerMain', self.wrapper),
						$notfound = $('.paymentMethodNotFound', self.wrapper);

					$container.empty();

               		if (data.result.length) {
						$notfound.hide();

						var filteredData = data.result.map(function (item) {
							if (item.onlineMethods && item.onlineMethods.length) {
								item.onlineMethods = item.onlineMethods.filter(function (om) {
									var tests = {
										'32': exports.platform.checkout.hasApplePaySupport,
										'33': exports.platform.checkout.hasGooglePaySupport
									};

									return !tests.hasOwnProperty(om.id) || tests[om.id];
								})
							}

							return item;
						});

						$container.append(
							$('#paymentMethodTemplate').render(
								filteredData,
								{
									paymentGraphic: function(logo) {
										return logo ? '<img alt="" src="' + platform.template.cdn + logo.split('|').join('"><img alt="" src="' + platform.template.cdn) + '">' : '';
									},
                                    isKlarnaCompany: (
                                        step1fields.cvr.trim() !== ''
                                    )
								}
							)
						);
						//rebuild VIABILL integration tags
						if (window.vb) {
							window.vb.buildTags();
						}

						for (var i=0; i < data.result.length; i++) {
							var element = data.result[i];

							if (element.payment_type && element.payment_type == 'klarnaKP' && self.klarnaHandler) {
								self.klarnaHandler.init(element);
							}
						}
                    } else {
						$notfound.show();
						self.orderSummary();
                    }

					self.selectPaymentInput();
					$(platform.checkout).trigger('paymentMethodsLoaded', [data.result]);
					self.googleAnalytics();
				});
			},

			selectPaymentInput: function () {
				var self = this,
					step4fields = this.relevantFieldDatas();

				// Find the top payment method in the list, this is the default method
				var paymentMethod = $('input[name="paymentType"]:first', self.wrapper).val();

				// Restore previous selection if there was one and it still exists
				if (step4fields.paymentMethod && $('input[name="paymentType"][value="' + step4fields.paymentMethod + '"]', self.wrapper).length) {
					paymentMethod = step4fields.paymentMethod;
				}
				// Restore from session if the information is there
				else {
					var postPaymentType = $('input[name="post_paymentType"]', self.wrapper).val();
					if (postPaymentType != '' && $('input[name="paymentType"][value="' + postPaymentType + '"]', self.wrapper).length) {
						paymentMethod = postPaymentType;
					}
				}

				var $paymentMethod = $('input[name="paymentType"][value="' + paymentMethod + '"]:first', self.wrapper);

				// Check selected payment method
				$paymentMethod.checked(true);

				// Enable all sub-inputs for selected payment method
				self.selectPaymentMethod($paymentMethod);

				if (step4fields.paymentMethodOnline && $('#pbs_type_' + step4fields.paymentMethodOnline, self.wrapper).length) {
					$('#pbs_type_' + step4fields.paymentMethodOnline, self.wrapper).checked(true);
				}
				else {
					var postOnlinePaymentType = $('input[name="post_onlinePaymentType"]', self.wrapper).val();
					if (postOnlinePaymentType != '') {
						$('#pbs_type_' + postOnlinePaymentType, self.wrapper).checked(true);
					} else {
						$('input.paymentMethodOnlineRadio:first', self.wrapper).checked(true);
					}
				}

				self.triggers();
			},

			selectPaymentMethod: function (selected) {
                var $selected = $(selected),
                    $inputs = $('.paymentMethodOnlineContainerMain input');

				$selected.trigger('showactive');


				if ($selected.val() == 9 && $selected.data('klarna') && exports.platform.hasOwnProperty('KlarnaHandler')) {
					this.klarnaHandler.update($selected.data('klarna'), this.orderSummaryData);
				}

                if ($selected.val() == 1) {
                    $inputs
                        .attr('disabled', false)
                        .filter(function() { return $(this).data('was-checked'); })
                            .checked(true)
                        .end().data('was-checked', false);
                } else {
                    $inputs
                        .filter(":checked")
                            .data('was-checked', true)
                            .checked(false)
                        .end().attr('disabled', true);
				}

			},
			orderSummary: function () {

				var self = this,
					wrapper = $('.step5'),
					step1fields = platform.checkout.STEP1.relevantFieldDatas(),
					step2fields = platform.checkout.STEP2.relevantFieldDatas(),
					step3fields = platform.checkout.STEP3.relevantFieldDatas(),
					step4fields = self.relevantFieldDatas();

				$.getJSON(platform.checkout.ajaxUrl, {
					page: 'checkout',
					action: 'order_summary',
					'delivery_country': step1fields.country,
					cvr: (step1fields.deliveryActive ? (step1fields.deliveryCompany != '' ? '1' : '') : (step1fields.company != '' ? '1' : '')),
					company: step1fields.company,
					'delivery_methods': step2fields.deliveryMethodIds,
					giftWrapping: step3fields.wrappingId,
					'payment_method': step4fields.paymentMethod,
					'payment_method_online': step4fields.paymentMethodOnline
				}).then(function(data) {
					var orderData = $.extend( data.result, {
						orderLineLimit: 9
					});
                    $('.orderSummary', wrapper).html($('#orderSummaryTemplate').render( orderData ));
                    $('#check_stage_all_loaded').val('1');
                    $('.orderline-hidden-button', wrapper).on('click', function (e) {
                    	$('.orderLine.is-hidden', wrapper).removeClass('is-hidden');
                    	$('.orderLine.l-orderline-hidden-info', wrapper).fadeOut().remove();
					});

					self.loaded(data);

					if (data.result && self.klarnaHandler) {
						if (!self.orderSummaryData) {
							self.orderSummaryData = data.result;
							self.selectPaymentInput();
						} else {
							self.orderSummaryData = data.result;
						}
					}
				});
			},
			googleAnalytics: function () {

				if (typeof window.gtag === 'function' && typeof ga === 'function' && window.platform.analyticsCart) {
					var self = this,
						fields = self.relevantFieldDatas();

					gtag('event', 'checkout_progress', {
						"checkout_step": 4,
						"items": window.platform.analyticsCart

					});

					gtag('event', 'set_checkout_option', {
						"checkout_step": 4,
						"checkout_option": "payment method",
						"value": fields.paymentMethod
					});
				}
			},
			binds: function() {
			 	var self = this;

				$(self.wrapper).on('change', 'input[name="onlinePaymentType"]', function() {
					self.orderSummary();
					self.googleAnalytics();
				});

				$(self.wrapper).on('change', 'input[name="paymentType"]', function() {
					self.selectPaymentMethod(this);
					self.orderSummary();
					self.googleAnalytics();
				});
		    },
		    triggers: function () {
		    	var self = this;
				self.orderSummary();
		    },
			loaded: function(data) {
                // Hide loading icon
				platform.checkout.loaded(data);
			}
		}
	};

    var hasInputTimeSupport = function () {
        var hasSupport = false;

        try {
            var input = document.createElement("input");
            input.type = "time";
            hasSupport = (input.type === "time");
        } catch(e) { }

        return hasSupport;
	};

	$(function() {
		if (platform.page.type == 'checkout' && $('.checkoutFrame').length) {
			exports.platform.checkout.load();
		}
	});

})(jQuery, window.platform, window);
