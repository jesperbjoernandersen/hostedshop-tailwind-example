
import { publish, subscribe } from "./PubSub";

class KlarnaKCO {
    $parent = [];
    isEnabled = false;
    api = {};
    logStyle = 'font-weight:bold;background-color:pink;padding:5px;';
    events = [
        'load',
        'change',
        'customer',
        'billing_address_change',
        'shipping_address_change',
        'checkbox_change',
        'can_not_complete_order',
        'network_error',
        'redirect_initiated',
        'load_confirmation',
        'validation_callback'
    ];

    // local transition function
    transition;

    constructor($parent, transition) {
        this.$parent = $parent;
        this.transition = transition;

        const self = this;

        if(!this.hasKlarna()) { return; }

        this._bind((event, ...args) => {
            if (DEBUG) {
                console.log('%cKlarna Checkout', this.logStyle, event, ...args);
            }
            publish(event, [...args]);
        });
    }

    hasKlarna() {
        return (window._klarnaCheckout && typeof window._klarnaCheckout === 'function');
    }

    bind(event, fn) {
        if (event === 'all') {
            this.events.map((element) => { subscribe(element, fn); });
        } else if (event === 'address') {
            ['change', 'customer', 'billing_address_change', 'shipping_address_change'].map((element) => {
                subscribe(element, fn);
            });
        } else {
            subscribe(event, fn);
        }
    }

    _bind(fn) {
        if(!this.hasKlarna()) { return; }

        const obj = {};

        this.events.map((element) => {
            obj[element] = (...args) => { fn(element, ...args); };
        });

        window._klarnaCheckout((api) => {
            api.on(obj);
        });
    }

    pause() {
        if(!this.hasKlarna()) { return; }

        const response = window._klarnaCheckout(function (api) {
            api.suspend();
        });

        console.log('%cKlarna Checkout', this.logStyle, 'pause', response);
    }

    resume() {
        if(!this.hasKlarna()) { return; }

        const response = window._klarnaCheckout(function (api) {
            api.resume();
        });

        console.log('%cKlarna Checkout', this.logStyle, 'resume', response);
    }
}



export {KlarnaKCO};