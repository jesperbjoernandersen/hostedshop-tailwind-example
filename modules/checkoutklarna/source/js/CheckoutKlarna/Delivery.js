import { debounce } from "./DebounceEvent";
import { getLoader } from "./LoadingIndicator";



/*
 * Selectors for elements
 */
const BLOCK = '[data-js-checkoutsteps="delivery"]';
const INPUTS = '[data-js-checkoutdelivery="inputs"]';
const INPUTS_COUNTRY = '[data-js-checkoutdelivery="country"]';
const INPUTS_ZIPCODE = '[data-js-checkoutdelivery="zipcode"]';
const INPUTS_CITY = '[data-js-checkoutdelivery="city"]';
const NORMAL = '[data-js-checkoutdelivery="normal"]';
const CLOSED_MODIFIER = 'w-checkout-delivery__normal--is-closed';
const DELIVERY_METHODS = '.deliveryMethodSelector input:radio:checked';
const INPUT_DATE = 'input[name="deliveryDate"]';
const INPUT_DATETIME = 'input[name="deliveryTime"]';
const INPUT_DROPPOINT = 'input[name="dao_location"]:checked,input[name="bringpp_location"]:checked,input[name="gls_location"]:checked,input[name="postdk_location"]';
const TEXT_CUSTOMER_NOTICE = '#customerNotice';
const TEXT_CUSTOMER_NOTICE_DELIVERY = '#customerNoticeDelivery';


const TYPE_DROPPOINT = 0;
const TYPE_NORMAL = 1;

class Delivery {
    // variables setup for jQuery elements
    $parent = [];

    platform;
    text;

    $block = [];

    $inputsCity = [];
    $inputsCountry = [];
    $inputsZipcode = [];

    $normal = [];
    // internal variables
    isLoading = false;
    isNormalOpen = false;
    isOpen = false;
    _wasFirst = true;
    state = false;
    $loader = [];

    // local transition function
    transition;

    // local checkout intermediate class
    checkoutIntermediate;

    // local klarna
    klarnaAPI;

    constructor($parent, platform, text, transition, checkoutIntermediate) {
        this.$parent = $parent;

        this.platform = platform;
        this.text = text;

        this.transition = transition;
        this.checkoutIntermediate = checkoutIntermediate;

        this.$block = $parent.find(BLOCK);

        this.$inputs = $parent.find(INPUTS);
        this.$inputsCity = $parent.find(INPUTS_CITY);
        this.$inputsCountry = $parent.find(INPUTS_COUNTRY);
        this.$inputsZipcode = $parent.find(INPUTS_ZIPCODE);

        this.$normal = $parent.find(NORMAL);

        if (this.$block.length
         && this.$inputs.length
         && this.$inputsCity.length
         && this.$inputsCountry.length
         && this.$inputsZipcode.length
         && this.$normal.length
         && platform.checkout
        ) {
            this.bootstrap();
        }
    }

    bootstrap() {
        // Listen to "old" checkout events
        this.checkoutIntermediate.bind('step2.change', this.handleLoaded.bind(this));
        this.checkoutIntermediate.bind('countrychange', this.setLoading.bind(this));
        this.checkoutIntermediate.bind('addresschange', this.setLoading.bind(this));

        // setup zipcode and city lookup
        this.$parent.on('input', INPUTS_ZIPCODE, debounce(this.updateCity.bind(this), 800));

        // remove old event listener from checkout.js
        this.checkoutIntermediate.removeZipcodeChangeTrigger();

        this.setLoading();

        // if user is logged in
        if (this.$inputsZipcode.length && this.$inputsZipcode.val() && this.$inputsZipcode.length) {
            this.updateCity();
        }
    }

    /*
     * When delivery methods are loaded from old checkout, trigger picking delivery method
     */
    handleLoaded(e) {
        if (!this.isOpen || this._wasFirst) { return; }

        this.setIdle();
        this.openNormal();
        this.transitionToNextStep();
    }

    transitionToNextStep () {
        this.transition(
            { status: 'idle' },
            { type: 'PICK_SHIPPING_METHOD' }
        );
    }

    /*
     * Update city based on zip code, triggered by input
     */
    updateCity() {
        let zipcode = this.$inputsZipcode.val();
        let country = this.$inputsCountry.val();

        this._wasFirst = false;

        if (zipcode.length === 4 && country === 'DK') {
            $.getJSON(this.platform.checkout.ajaxUrl, {
                page: 'helper',
                action: 'find_county',
                zip: zipcode,
                country: country ? country.toLowerCase() : ""
            }).then((data) => {
                if (!data.result) { return; }

                this.$inputsCity.val(data.result);
                this.$inputsCity.data('autofilled', '1').blur();
            });
        }

        this.checkoutIntermediate.trigger('addresschange');

        return true;
    }

    unlock() {
        this.$inputsCountry.removeAttr('readonly');
    }

    /*
     * Open the normal delivery methods choice
     */
    openNormal() {
        console.log('Delivery.js', 'openNormal');
        this.isNormalOpen = true;
        this.$normal.removeClass(CLOSED_MODIFIER);
    }

    /*
     * Toggle loading state on
     */
    setLoading() {
        if (this.$loader.length || this.isLoading) { return; }

        this.$loader = this.getLoadingContent();
        this.$normal.prepend(this.$loader);
        this.$normal.css({ 'display': 'none' });
        this.isLoading = true;
    }

    /*
     * Toggle loading state off
     */
    setIdle() {
        this.isLoading = false;
        if (this.$loader.length) {
            this.$loader.parent().find('.w-checkout-loader').remove();
            this.$loader = [];
            this.$normal.css({
                'display': 'block',
                'height': 'auto',
                'overflow': 'auto'
            });
        }
    }

    /*
     * Toggle module open
     */
    open() {
        this.isOpen = true;

        // if delivery is hidden (by setting) continue to payment
        if (!this.$block.length && $('#zipcode').length) {
            this.transitionToNextStep();
            return;
        }
    }

    wasFirst () {
        return this._wasFirst;
    }

    getLoadingContent () {
        const style = "position:absolute;left:0;right:0;top:0;bottom:0;z-index:99;visibility: visible;";
        return (this.$inputsZipcode.val().trim().length)
            ? getLoader(style)
            : getLoader(style, `<div style="margin-top:5em;" class="deliveryMethodGroupProductsHeader">${this.text.KLARNAKCO_FILL_OUT_ZIP_CODE}</div>`);
    }

    getValue ($el = []) {
        return $el.length
            ? $el.val()
            : '';
    }

    getDeliveryMethods () {
        const values = {};
        console.log('Delivery.js', 'getDeliveryMethods', this.$parent.find(DELIVERY_METHODS));

        this.$parent.find(DELIVERY_METHODS).each(function( index ) {
            values[this.name] = this.value;
        });

        return values;
    }

    getDroppointMethod () {
        const values = {};
        console.log('Delivery.js', 'getDroppointMethod', this.$parent.find(INPUT_DROPPOINT));

        this.$parent.find(INPUT_DROPPOINT).each(function (index) {
            values[this.name] = this.value;
        });

        return values;
    }

    /*
     * Return the information
     */
    getAddressInformation() {
        const klarnaCountry = (self.$inputsCountry.length && self.$inputsCountry[0].tagName && self.$inputsCountry[0].tagName.toLowerCase() !== 'select')
            ? this.$inputsCountry.data('alpha3')
            : this.$inputsCountry.find('option:selected').data('alpha3');

        return {
            'zipcode': this.$inputsZipcode.val(),
            'country': this.$inputsCountry.val(),
            'klarnaCountry': klarnaCountry
        };
    }

    getDeliveryData() {
        return {
            'deliveryMethods': this.getDeliveryMethods(),
            'deliveryDate': this.getValue(this.$parent.find(INPUT_DATE)),
            'deliveryTime': this.getValue(this.$parent.find(INPUT_DATETIME)),
            'customerNotice': this.getValue(this.$parent.find(TEXT_CUSTOMER_NOTICE)),
            'customerNoticeDelivery': this.getValue(this.$parent.find(TEXT_CUSTOMER_NOTICE_DELIVERY)),
            ...self.getDroppointMethod()
        };
    }

    getDeliveryType() {
        const self = this;

        return this.$parent.find(INPUT_DROPPOINT).slice(0, 1).parents('.deliveryMethodContainer').find('.locationContainer').length
            ? TYPE_DROPPOINT
            : TYPE_NORMAL;
    }
}

export { Delivery, TYPE_DROPPOINT, TYPE_NORMAL }
