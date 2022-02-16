

/*
 * Selectors for elements
 */
const BLOCK = '[data-js-checkoutsteps="usertype"]';
const BUTTON = 'input[type="hidden"][name="usertype"]';
const CONTACT = '.w-checkout-steps__step__toggle';
const CONTACT_INPUTS = 'input, textarea, select';

class UserType {
    $parent = [];
    platform;
    $block = [];
    $inputs = [];
    $contactInfoInputs = [];
    contactInfoValues = {};
    state = [];
    first = true;
    isOpen = false;
    map = [
        "private",
        "company",
        "institution"
    ];

    // local transition function
    transition;

    // local checkout intermediate class
    checkoutIntermediate;

    constructor($parent, platform, transition, checkoutIntermediate) {
        this.$parent = $parent;
        this.platform = platform;
        this.transition = transition;
        this.checkoutIntermediate = checkoutIntermediate;

        this.$block = $parent.find(BLOCK);
        this.$inputs = this.$block.find(BUTTON);
        this.$contactInfo = this.$block.find(CONTACT);
        this.$contactInfoInputs = this.$contactInfo.find(CONTACT_INPUTS);

        this.triggerTypeHandler();
    }

    triggerTypeHandler() {
        const self = this;
        setTimeout(() => {
            self.typeHandler({currentTarget: self.$inputs[0]});
        }, 0);
    }

    typeHandler (e) {
        const $el = $(e.currentTarget);
        this.state.push($el.val());

        // transition new checkout
        this.transition(
            { status: 'idle' },
            { type: 'PICK_USER_TYPE' }
        );

        // trigger old checkout
        this.checkoutIntermediate.updateCheckoutUserType();
    }

    getContactInformation() {
        this.contactInfoValues = {};
        this.$contactInfoInputs.each((idx, el) => {

            // filter unwanted data
            if ((el.type === 'checkbox' || el.type === 'radio') && el.checked === false) { return; }
            if (el.type === 'hidden' && el.name !== 'post_packingType') { return; }
            if (el.type === 'text' && el.value.trim() === '') { return; }
            if (el.disabled) { return; }

            this.contactInfoValues[el.name] = el.value;

            if ((el.type === 'checkbox' || el.type === 'radio')) {
                this.contactInfoValues[el.name] = (el.value === 'on') ? true : el.value;
            }
        });

        return this.contactInfoValues;
    }

    wasFirst () {
        return this.state.length === 1;
    }

    open() {
        this.isOpen = true;
    }

    get() {
        return this.state[this.state.length-1];
    }
}

export { UserType };
