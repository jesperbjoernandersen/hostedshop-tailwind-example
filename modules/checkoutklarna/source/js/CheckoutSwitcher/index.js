/*
    Design philosophy this is the controller file for the stacked version of the
    checkout it uses the normal index.js, that is filled with logic about how checkout
    should work.

    The controller listens to events from components. Controller is the only one that
    knows and manages the state of all the components. Components only broadcast what
    happened, the state and flow is managed here.

 */

import "core-js/stable";
import "regenerator-runtime/runtime";


import { CheckoutSwitcher } from "./CheckoutSwitcher";

;(function ($, exports, platform, undefined) {
    'use strict';

    $(function() {
        const $el = $('.checkoutFrame');
        let switcher;
        const logStyle = 'color:white;font-weight:bold;font-size:1.275em;padding:5px;background-color:#303030;';

        if (platform.page.type === 'checkout' && $el.length) {
            switcher = new CheckoutSwitcher($el, platform.page, platform, window.text);
            console.log('%cCheckout switcher', logStyle, 'CheckoutSwitcher initiated!');
        } else {
            console.log('%cCheckout switcher', logStyle, 'CheckoutSwitcher initiation failed!');
        }

        platform = platform || {};
        platform.checkoutSwitcher = platform.checkoutSwitcher || switcher;
    });

})(jQuery, window, window.platform);
