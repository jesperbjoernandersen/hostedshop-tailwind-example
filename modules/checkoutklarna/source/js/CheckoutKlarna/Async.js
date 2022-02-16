import { getAll } from "./UrlParameters";

class Async {

    endpoint = '/actions/handler/ajax';
    defaultProps = {
        subpage: 'klarna',
        page: 'checkout'
    };

    constructor(transition, checkoutIntermediate) {
        this.transition = transition;
        this.checkoutIntermediate = checkoutIntermediate;

        // rewrite the ajax urls to always contain subpage=klarna for klarna checkout
        $.ajaxPrefilter((options, originalOptions, jqXHR) => {
            const url = options.url;

            // we only want to rewrite ajax endpoint urls
            if (!url || url.indexOf(this.endpoint) === -1) { return; }

            const params = $.extend( {}, getAll(url), this.defaultProps);
            options.url = this.endpoint + '?' + $.param(params);
        });
    }

    finalize (
        checkoutData = {},
        userType = {},
        contactInfo = {},
        deliveryData = {},
        orderSummary = {}
    ) {
        const getData = {
            'action': 'klarna_finalize',
            ...checkoutData
        };

        const postData = {
            ...contactInfo,
            ...deliveryData,
            ...orderSummary
        };

        $.post(this.endpoint + '?' + $.param(getData), postData).always(() => {
            this.transition(
                {status: 'loading'},
                {type: 'KLARNA_FINALIZED'}
            );
        });
    }

    usertype(
        data = {
            checkoutData: {},
            userType: {}
        }
    ) {
        const getData = {
            'action': 'user_type',
            ...data.checkoutData
        };

        const postData = {
            'userType': data.userType,
        };

        $.when(
            $.post(this.endpoint + '?' + $.param(getData), postData),
            this.checkoutIntermediate.bind('deliveryMethodsLoaded', () => { }, true)
        )
        .always(() => {
            this.transition(
                { status: 'loading' },
                { type: 'SET_USER_TYPE' }
            );
        });
    }

    delivery() {
        this.checkoutIntermediate.bind('done', () => {
            this.transition(
                { status: 'idle' },
                { type: 'SET_SHIPPING_METHOD' }
            );
        }, true);
    }

    payment() {
        this.checkoutIntermediate.bind('done', () => {
            this.transition(
                { status: 'idle' },
                { type: 'SET_PAYMENT_METHOD' }
            );
        }, true);
    }
}

export { Async };
