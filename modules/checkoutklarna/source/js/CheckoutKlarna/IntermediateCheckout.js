


/*
 * Checkout intermediate
 *
 * A class to handle communication between old and new checkout
 */

class IntermediateCheckout {

    platform;

    logStyle = 'background-color:#6495ED;color:white;font-weight:bold;padding:5px;';

    constructor(platform) {
        this.platform = platform;
    }

    /*
     * Remove an event listener that was caysing awkward double load on exit
     * new functionality uses input and a debouncer
     */
    removeZipcodeChangeTrigger() {
        $('#zipcode, #address, #deliveryZipcode, #deliveryAddress', $('.step2')).off('change');
    }

    /**
     * Reference for setVatRates in old checkout
     * Used when User types change in new flow
     */
    updateCheckoutUserType() {
        $('input[type=hidden][name=customer-type]').trigger('change');
    }

    /*
     * Bind and listen to old checkout events
     */
    bind(event, fn, once = false) {
        const binder = (once) ? 'one' : 'on';

        if (!fn) {
            const promise = $.Deferred();
            fn = () => {
                promise.resolve();
            }

            return promise
        }

        switch (event) {

            case 'deliveryMethodsLoaded':
                $(this.platform.checkout)[binder]('deliveryMethodsLoaded', fn);
                break;

            case 'countrychange':
                $(this.platform.checkout.STEP1)[binder]('countrychange', fn);
               break;

            case 'addresschange':
                $(this.platform.checkout.STEP1)[binder]('addresschange', fn);
                break;

            case 'firstdone':
                $(this.platform.checkout)[binder]('firstdone', fn);
                break;

            case 'done':
                $(this.platform.checkout)[binder]('done', fn);
                break;

            case 'doneall':
                $(this.platform.checkout)[binder]('firstdone', fn);
                $(this.platform.checkout)[binder]('done', fn);
                break;

            case 'step1.change':
                $(this.platform.checkout.STEP1)[binder]('change', fn);
                break;
            case 'step2.change':
                $(this.platform.checkout.STEP2)[binder]('change', fn);
                break;
            case 'step3.change':
                $(this.platform.checkout.STEP3)[binder]('change', fn);
                break;

            case 'changeall':
                $(this.platform.checkout.STEP1)[binder]('change', fn);
                $(this.platform.checkout.STEP2)[binder]('change', fn);
                $(this.platform.checkout.STEP3)[binder]('change', fn);
                break;
        }

        return this;
    }

    /*
     * Trigger old checkout events
     */
    trigger(event, data) {

        switch (event) {

            case 'deliveryMethodsLoaded':
                $(this.platform.checkout).trigger('deliveryMethodsLoaded');
                break;
            case 'countrychange':
                $(this.platform.checkout.STEP1).trigger('countrychange');
                break;
            case 'addresschange':
                $(this.platform.checkout.STEP1).trigger('addresschange');
                break;
            case 'firstdone':
                $(this.platform.checkout).trigger('firstdone');
                break;
            case 'done':
                $(this.platform.checkout).trigger('done');
                break;
            case 'step1.change':
                $(this.platform.checkout.STEP1).trigger('change');
                break;
            case 'step2.change':
                $(this.platform.checkout.STEP2).trigger('change');
                break;
            case 'step3.change':
                $(this.platform.checkout.STEP3).trigger('change');
                break;

        }
    }

    getOrderSummaryData() {
        const
            step1fields = this.platform.checkout.STEP1.relevantFieldDatas(),
            step2fields = this.platform.checkout.STEP2.relevantFieldDatas(),
            step3fields = this.platform.checkout.STEP3.relevantFieldDatas(),
            step4fields = this.platform.checkout.STEP4.relevantFieldDatas();

        const cvr = step1fields.deliveryActive ? step1fields.deliveryCompany : step1fields.company;

        return {
            'delivery_country': step1fields.country,
            'cvr': cvr !== '' ? '1' : '',
            'company': step1fields.company,
            'delivery_methods': step2fields.deliveryMethodIds,
            'giftWrapping': step3fields.wrappingId,
            'payment_method': step4fields.paymentMethod,
            'payment_method_online': step4fields.paymentMethodOnline
        };
    }
}

export { IntermediateCheckout }
