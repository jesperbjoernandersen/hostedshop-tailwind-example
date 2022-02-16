;(function($) {
	'use strict';

	function init () {
		var $wrapper = $("#m-useredit"),
		 	$deliveryWrapper = $wrapper.find("#deliveryContactInfoContainer"),
		 	$deleteWrapper = $(".m-userremove[data-userdelete='panel']");

		if ($wrapper.length > 0) {
			var stateLogic = function(e){
				$('.state-group', $wrapper).addClass('is-hidden');
				$('.state-select', $wrapper).each(function() {
					$(this).prop('disabled', true);
				});

				var $country = $('#m-useredit-country'),
				    el = $country.is('[type="hidden"]') ? $country : $country.find(':selected');
				if (el.data('hasStates') > 0) {
					$('.state-group-' + el.val(), $wrapper).removeClass('is-hidden').find('select').prop('disabled', false);
				}
			};

			// Execute form action on select change
			$('#m-useredit-country', $wrapper).on('change input', stateLogic);
			stateLogic();

			// City/county locator
			$('#m-useredit-zipcode', $wrapper).SmartForm('county', {target:'#m-useredit-city', country:'#m-useredit-country'});

			// Country code locator
			$('#m-useredit-country', $wrapper).SmartForm('countrycode', {
				target: function(code) {
					$('input.countryCode', $wrapper).val(code);
					$('span.countryCode', $wrapper).html('+' + code);
				}
			});

			// Toggle slide on activate delivery address checkbox
			$('#deliveryActive').on('change', function (e) {
				$('.deliveryContactInfo').slideToggle();
				if ($(this).is(':checked')) {
					$('.deliveryContactInfo input').attr('disabled', false);
				} else {
					$('.deliveryContactInfo input').attr('disabled', !$(this).is(':checked'));
				}
			});

			// Interest group selector
			$('#m-useredit-newsletter', $wrapper).on('change', function(e) {
				$('#m-useredit-newsletterfields', $wrapper).toggleClass('is-hidden');
			});
		}

		if( $deliveryWrapper.length > 0){
			$deliveryWrapper.removeClass('is-hidden');

			//Logic for saving delivery address
			if($('#deliveryActive').is(':checked')){
				$('.deliveryContactInfo').slideToggle();
				$('.deliveryContactInfo input').attr('disabled', false);
			}

			var $country = $('#m-useredit-del-country', $deliveryWrapper);

			var deliveryStateLogic = function(e){
				$('.del-state-group', $deliveryWrapper).addClass('is-hidden');
				$('.del-state-select', $deliveryWrapper).each(function() {
					$(this).prop('disabled', true);
				});

				var el = $country.is('[type="hidden"]') ? $country : $country.find(':selected');

				if (el.data('hasStates') > 0) {
					$('.del-state-group-' + el.val(), $deliveryWrapper)
						.removeClass('is-hidden')
							.find('select')
							.prop('disabled', false);
				}
			}

			// Execute form action on select change
			$country.on('change input', deliveryStateLogic);
			deliveryStateLogic();

			// City/county locator
			$('#deliveryZipcode', $deliveryWrapper).SmartForm('county', {target:'#deliveryCity', country:'#m-useredit-del-country'});
		}

		if ( $deleteWrapper.length ) {
			var $confirm_wrap = $deleteWrapper.find('[data-userdelete="confirm"]'),
				$description_wrap = $deleteWrapper.find("[data-userdelete='description']"),
				$delete_btn = $deleteWrapper.find("[data-userdelete='button']"),
				$cancel_btn = $deleteWrapper.find("[data-userdelete='cancel']");

			var handleDelete = function (e) {
				var $this = $(this);

				if ( $this.is("[type='button']") ) {
					e.preventDefault();
					$this
						.attr("type","submit")
						.text(text.CONFIRM)
						.removeClass("button")
						.removeClass("small")
						.addClass("button-primary");

					$confirm_wrap.removeClass("is-hidden");
				}
			}

			var handleCancellation = function (e) {
				var $this = $(this);

				e.preventDefault();

				$confirm_wrap.addClass("is-hidden");
				$delete_btn
					.attr("type","button")
					.text(text.DELETE)
					.removeClass("button-primary")
					.addClass("small")
					.addClass("button");
			}

			if ( $confirm_wrap.length && $description_wrap.length && $delete_btn.length && $cancel_btn ) {
				$deleteWrapper.removeClass("is-hidden");

				$delete_btn.on("click", handleDelete);
				$cancel_btn.on("click", handleCancellation);
			}
		}
	}


	$(function() {
		init();
	});

})(jQuery, window);
