

class CheckoutSwitcher {
    $el;

    isCheckout;
    isCheckoutKlarna;
    isCheckoutComplete;
    shouldRenderAgain;

    platform;
    text;

    constructor($el, page, platform, text) {
        this.$el = $el;

        this.platform = platform;
        this.text = text;

        this.isCheckout = page.isCheckout;
        this.isCheckoutKlarna = page.isCheckoutKlarna;
        this.isCheckoutComplete = page.isCheckoutComplete;

        if (!$el.length) { return; }
        if (!this.isCheckout) { return; }
        if (this.isCheckoutComplete) { return; }

        // call bootstrap with timeout to put at end of call stack
        setTimeout(this.bootstrap.bind(this), 0);
    }

    bootstrap() {
        let handlerFn;

        if (this.isCheckoutKlarna) {
            const data = {
                'link': `/${this.text.CHECKOUT_LINK}/`,
                'text': this.text.CHECKOUT_FROM_KLARNA_LINK_TEXT
            };

            this.$el.prepend(
                this.renderSwitcher(
                    data,
                    $('#CheckoutSwitcherKlarna')
                )
            );


            handlerFn = (e, data = [{}]) => {
                if ( !(data instanceof Array)) { return; }

                // render images for all payment methods
                this.$el.find('.w-checkout-switcher__container .m-checkout-switcher__image-wrap').remove();
                this.$el.find('.w-checkout-switcher__container .m-checkout-switcher__image-list').append(
                    this.renderPaymentImages(data)
                );
            }
        } else {
            handlerFn = (e, data = [{}]) => {
                if ( !(data instanceof Array)) { return; }

                // render the switcher
                this.$el.find('.w-checkout-switcher__container').remove();
                this.$el.prepend(
                    this.renderSwitcher(
                        this.dataForCheckout(data),
                        $('#CheckoutSwitcherTop')
                    )
                );
            }
        }

        // setup listener
        $(this.platform.checkout).on('paymentMethodsLoaded', handlerFn);
    }

    renderSwitcher (data = [], $tpl) {
        return `<div class="w-checkout-switcher__container ${this.isCheckoutKlarna ? ' w-checkout-switcher__container--klarna' : ''}">
            ${ $tpl.render(data) }
        </div>`;
    }

    renderPaymentImages(paymentMethods = []) {
        const images = [];
        paymentMethods.forEach((value, index, arr) => {
            // skip klarna
            if (value.id === '9') { return; }

            // handle paypal
            if (value.id === '6') {
                images.push('<img src="/_design/common/img/payment/card_paypal.gif" alt="PayPal">');
                return;
            }

            // handle creditcards
            if (value.onlineMethods && value.onlineMethods instanceof Array) {
                value.onlineMethods.forEach(ov => {
                    if (ov.graphic) {
                        images.push(...ov.graphic.replace(/></g, ">|<").split("|"));
                    } else if (ov.logo) {
                        images.push(...ov.logo
                            .split("|")
                            .map(lv => `<img src="${this.platform.template.cdn}${lv}" alt="${ov.title || ''}">`));
                    }
                });
            }
        });

        // filter down to uniques
        const forRender = images.filter((v, i, a) => a.indexOf(v) === i).slice(0, 4);

        return $('#CheckoutSwitcherImages').render(forRender);
    }

    dataForCheckout(paymentMethods = []) {
        return paymentMethods.filter(this.filterKlarna);
    }

    filterKlarna (value = {}) {
        return value.id === '9' && value.payment_type === 'klarnaKCO';
    }

    filterOutKlarna (value = {}) {
        // it's enough to filter on id 9 since Klarna will only be available once
        return value.id !== '9';
    }
}

export { CheckoutSwitcher };