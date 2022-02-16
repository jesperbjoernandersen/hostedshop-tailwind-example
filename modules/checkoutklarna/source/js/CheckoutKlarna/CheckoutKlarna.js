import { Async } from "./Async";
import { Delivery } from "./Delivery";
import { Steps } from "./Steps";
import { UserType } from "./UserType";
import { KlarnaKCO } from "./KlarnaKCO";
import { CheckoutKlarnaStates } from "./CheckoutKlarnaState";
import { IntermediateCheckout } from "./IntermediateCheckout";


import { subscribe } from "./PubSub";
import { runActions, transition } from "./StateMachine";
import { Validator } from "./Validator";


class CheckoutKlarna {

    $el;
    isCheckoutComplete;

    checkoutIntermediate;
    klarnaDeliveryIntermediate;
    klarna;
    api;

    delivery;
    steps;
    usertype;
    checkoutValidator;

    transitionFn;
    runActionsFn;

    klarnaHasLoaded = false;
    klarnaShipping = {};
    isLoading = true;

    platform;
    text;

    constructor($el, isCheckoutComplete, platform, text) {
        this.$el = $el;
        this.isCheckoutComplete = isCheckoutComplete;
        this.platform = platform;
        this.text = text;

        if (!$el.length) { return; }

        this.bootstrap();
    }

    bootstrap() {
        const self = this;

        // Init utils
        this.transitionFn = transition(CheckoutKlarnaStates);
        this.runActionsFn = runActions(this);

        this.checkoutIntermediate = new IntermediateCheckout(this.platform);
        this.api = new Async(this.transitionFn, this.checkoutIntermediate);
        this.klarna = new KlarnaKCO(this.$el, this.transitionFn);

        // Init modules
        this.steps = new Steps(this.$el, this.transitionFn);
        this.usertype = new UserType(this.$el, this.platform, this.transitionFn, this.checkoutIntermediate);
        this.delivery = new Delivery(this.$el, this.platform, this.text, this.transitionFn, this.checkoutIntermediate);

        this.checkoutValidator = new Validator(this.platform, this.text, this.delivery, this.klarnaDeliveryIntermediate, this.transitionFn);

        //
        // Listen to klarna events

        // Listen to checkout load
        this.klarna.bind('load', (event, data) => {
            this.klarnaHasLoaded = true;

            if (data?.[0].shipping_address) {
                this.checkoutValidator.handleShippingAddressChange('shipping_address', [data[0].shipping_address]);
            }

            this.transitionFn(
                { status: 'loading' },
                { type: 'KLARNA_CHECKOUT_READY' }
            );
        });

        // Listen to checkout approved load
        this.klarna.bind('load_confirmation', (event, data) => {
            this.klarnaHasLoaded = true;
            this.transitionFn(
                { status: 'loading' },
                { type: 'KLARNA_APPROVED_READY' }
            );
        });

        // Listen to updates to address
        this.klarna.bind('shipping_address_change', this.checkoutValidator.handleShippingAddressChange);

        // Listen to redirect
        this.klarna.bind('validation_callback', (event, [data, callback]) => {
            this.klarnaCallback = callback || false;

            try {
                // validate
                this.checkoutValidator.validate();
            } catch (err) {
                callback({ should_proceed: false, message: err });
            }

            this.transitionFn(
                { status: 'idle' },
                { type: 'KLARNA_CHECKOUT_FINALIZE' }
            );
        });

        // handle cases where Klarna didn't load
        setTimeout(() => {
            if (!this.klarnaHasLoaded) {
                this.transitionFn(
                    { status: 'blocking' },
                    { type: 'KLARNA_NOT_READY' }
                );
            }
        }, 10000);

        // add up event listeners
        subscribe("transition", this.transitionReducer.bind(this));
    }


    /*
     * In case there is a issue loading Klarna show toast to go to original checkout
     */
    errorLoading() {
        console.log('%cError', 'font-weight:bold;color:white;background-color:firebrick;padding:5px;', 'CheckoutKlarna.js', 'handleErrorLoading');

        $('.checkoutError').removeClass('is-hidden');
        $('.checkoutLoading.preloader').addClass('is-hidden');
    }

    /*
     * Handle incoming transitions from state machine
     */
    transitionReducer(event, state) {
        console.log('%cState', 'font-weight:bold;color:white;background-color:#9FE2BF;padding:5px;', event, state.status, state.actions);

        switch (state.status) {
            case 'loading':
                if (!this.isLoading) {
                    this.setLoading(true);
                    this.setBlocking(false);
                }

                this.isLoading = true;

                break;

            case 'idle':
                this.setLoading(false);
                this.setBlocking(false);

                this.isLoading = false;

                break;

            case 'blocking':
                this.setBlocking(true);

                break;

            default: return;
        }

        if (state.actions) {
            this.runActionsFn(state.actions);
        }
    }

    /*
     * Proxy for cpmplete action into steps
     */
    complete(step) {
        this.steps.complete(step);
        this.callModuleFunction(step, 'complete');
    }

    /*
     * Proxy for open action into steps
     */
    open(step) {
        this.steps.open(step);
        this.callModuleFunction(step, 'open');
    }

    /*
     * Proxy for reset action into steps
     */
    reset(step) {
        this.steps.reset(step);
        this.callModuleFunction(step, 'reset');
    }

    /*
     * Proxy for to call module function if
     * module exists and function exists
     */
    callModuleFunction(module, fn) {
        this?.[module]
          && this[module]?.[fn]
          && typeof this[module][fn] === 'function'
          && this[module][fn]();
    }

    /*
     * Enable checkout, after Klarna has been loaded
     */
    enableCheckout() {
        this.platform.checkout.loaded({});
    }


    /*
     * Set the loading ui
     */
    setLoading(isLoading) {
        this.steps.setLoading(isLoading);
    }

    /*
     * Set the complete ui as blocking (show modals)
     */
    setBlocking(shouldBlock) {
        console.log('CheckoutKlarna.js', 'setBlocking', shouldBlock);
    }

    /*
     * Reducer for ASYNC events
     */
    asyncUpdate(action) {
        console.log('%cAsyncUpdate', 'font-weight:bold;background-color:#FFBF00;color:white;padding:5px;', action);

        switch (action) {
            case 'delivery':
                this.api?.[action]();
                break;

            case 'usertype':
                this.api.usertype({
                    'checkoutData': this.checkoutIntermediate.getOrderSummaryData(),
                    'userType': this.usertype.get(),
                });
                break;

            case 'finalize':
                const orderSummary = this.checkoutIntermediate.getOrderSummaryData();
                this.api.finalize(
                    orderSummary,
                    this.usertype.get(),
                    this.usertype.getContactInformation(),
                    this.delivery.getDeliveryData(),
                    orderSummary
                );
                break;

            default:
                break;
        }
    }

    /*
     * Pause klarna iframe for backend input
     */
    pauseKlarna() {
        this.klarna.pause();
    }

    /*
     * Resume klarna iframe after backend input
     */
    resumeKlarna() {
        this.klarna.resume();
    }

    /*
     * Resume after validated
     */
    validateKlarnaCallback() {
        if (typeof this.klarnaCallback === 'function') {
            this.klarnaCallback({ should_proceed: true });
        }
    }
}

export { CheckoutKlarna };
