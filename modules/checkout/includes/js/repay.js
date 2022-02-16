/**
*	Logic for specific repay checkout
*/
;(function ($, exports) {

	var Repay = function (wrapper) {
		this.wrapper = $(wrapper);
	}

	Repay.prototype.init = function () {
		this.paymentMethods();
	}

	Repay.prototype.paymentMethods = function () {

		var self = this;
		self.container = $('.paymentMethods', self.wrapper);
		self.$selected = $('input[name="paymentType"]:checked', self.container);

		self.binds = function () {

			var self = this;

			self.container.on('change', 'input[name="paymentType"]', function (e) {
				var $this = $(this).parents('.paymentMethodContainer'),
					$showOnClick = $('.showOnClick', $this);

				// Hide all sub-input fields
				$('.showOnClick', self.container).not('.paymentMethodOnlineContainerMain').hide();
				$('.showOnClick input', self.container).attr('disabled', true);

				// Show hidden container and enable sub-input fields
				$showOnClick.show();
				$('input', $this).attr('disabled', false);
			});
		}

		// Handle pre-selected value
		if (self.$selected.length) {
			var $selected = self.$selected.parents('.paymentMethodContainer');
			$('input:radio', $selected).attr('disabled', false);
			$('.showOnClick', $selected).show();
		}

		// Init
		self.binds();

	}

	$( function () {

		if ( platform.page.type == 'checkout' && $('#repay').length && typeof platform.shop.checkout.repay !== 'undefined' ) {
			exports.platform = exports.platform || {};
			exports.platform.repay = new Repay('#repay');
			exports.platform.repay.init();
		}

	});

})(jQuery, window);