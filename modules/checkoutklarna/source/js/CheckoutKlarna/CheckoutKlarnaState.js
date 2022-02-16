const machine = {
    initial: 'loading',
    states: {
        loading: {
            on: {
                SET_USER_TYPE: {
                    target: 'idle',
                    actions: [
                        { type: 'resumeKlarna' },
                        { type: 'open', action: 'usertype' },
                        { type: 'complete', action: 'usertype' },
                        { type: 'open', action: 'delivery' }
                    ]
                },
                KLARNA_APPROVED_READY: {
                    target: 'idle',
                    actions: [
                        { type: 'enableCheckoutApproved' }
                    ]
                },
                KLARNA_CHECKOUT_READY: {
                    target: 'idle',
                    actions: [
                        { type: 'enableCheckout' }
                    ]
                },
                KLARNA_CHECKOUT_FINALIZED: {
                    target: 'idle',
                    actions: [
                        { type: 'resumeKlarna' },
                        { type: 'validateKlarnaCallback' }
                    ]
                }
            }
        },
        idle: {
            on: {
                PICK_USER_TYPE: {
                    target: 'loading',
                    actions: [
                        { type: 'pauseKlarna' },
                        { type: 'asyncUpdate', action: 'usertype' }
                    ]
                },
                PICK_SHIPPING_METHOD: {
                    target: 'idle',
                    actions: [
                        { type: 'pauseKlarna' },
                        { type: 'asyncUpdate', action: 'delivery' }
                    ]
                },
                SET_SHIPPING_METHOD: {
                    target: 'idle',
                    actions: [
                        { type: 'resumeKlarna' },
                        { type: 'complete', action: 'usertype' },
                        { type: 'complete', action: 'delivery' },
                        { type: 'open', action: 'payment' }
                    ]
                },
                KLARNA_CHECKOUT_FINALIZE: {
                    target: 'loading',
                    actions: [
                        { type: 'pauseKlarna' },
                        { type: 'asyncUpdate', action: 'finalize' },
                    ]
                },
                HANDLED_ERROR: {
                    target: 'idle',
                    actions: [
                        { type: 'unblock' }
                    ]
                }
            }
        },
        blocking: {
            on: {
                KLARNA_NOT_READY: {
                    target: 'blocking',
                    actions: [
                        { type: 'errorLoading' }
                    ]
                }
            }
        }
    }
}

export { machine as CheckoutKlarnaStates };
