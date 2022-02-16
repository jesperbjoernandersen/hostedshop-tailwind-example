import { getLoader } from "./LoadingIndicator";


const COMPONENT = '[data-js-checkoutsteps="main"]';
const TABS = '[data-js-checkoutsteps__tabitem]'
const STEP = '[data-js-checkoutsteps="%s"]';

const STEP_HEADER_CONTENT = '.stepHeader';
const STEP_BOX_CONTENT = '.stepBox';

const CSS_CLOSED_MODIFIER = 'w-checkout-steps__step--is-closed';
const CSS_ACTIVE_MODIFIER = 'w-checkout-steps__tabitem--is-active';
const CSS_COMPLETE_MODIFIER = 'w-checkout-steps__tabitem--is-complete';

const CSS_STYLE = "position:absolute;left:0;right:0;top:0;bottom:0;z-index:99;visibility: visible;";

class Steps {
    $el = [];
    $parent = [];
    active;
    isLoading = false;
    steps = {};
    transition;

    constructor($parent, transition) {
        this.$parent = $parent;
        this.transition = transition;

        this.bootstrap();
    }

    bootstrap () {
        // store all steps
        $(TABS).each( (idx, el) => {
            const tab = $(el),
                  key = tab.data("js-checkoutsteps__tabitem"),
                  step = $(STEP.replace("%s", key));

            this.steps[key] = {
                key,
                tab,
                step,
                isOpen: tab.is("."+CSS_ACTIVE_MODIFIER)
            };

            if (tab.is("."+CSS_ACTIVE_MODIFIER)) {
                this.active = key;
            }
        });
    }

    open(key) {
        if (this.steps.hasOwnProperty(key)) {
            this.steps[key].isOpen = true;
            const step = this.steps[key];
            this.active = key;

            step.tab.addClass(CSS_ACTIVE_MODIFIER);
            step.step.removeClass(CSS_CLOSED_MODIFIER);
        }
    }

    complete(key) {
        if (this.steps.hasOwnProperty(key)) {
            this.steps[key].tab.addClass(CSS_COMPLETE_MODIFIER);
        }
    }

    reset(key) {
        if (this.steps.hasOwnProperty(key)) {
            this.steps[key].isOpen = false;
            const step = this.steps[key];

            step.tab.addClass(CSS_ACTIVE_MODIFIER);
            step.tab.removeClass(CSS_COMPLETE_MODIFIER);
        }
    }

    setLoading(isLoading) {
        this.isLoading = isLoading;
        for (const key in this.steps) {
            if (this.steps[key].hasOwnProperty("tab")) {
                if (isLoading) {
                    if (!this.steps[key]['tab'].hasClass(CSS_COMPLETE_MODIFIER)) {
                        this.setStepLoading(key);
                    }
                } else {
                    this.resetStepLoading(key);
                }
            }
        }
    }

    setStepLoading(key) {
        if (this.steps.hasOwnProperty(key)) {
            const step = this.steps[key].step,
                  tab = this.steps[key].tab;

            if (!this.steps[key].isOpen) {
                // get header and height before modified
                const header = step.find(STEP_HEADER_CONTENT);
                this.steps[key].isBox = false;

                header.css({ 'visibility': 'hidden', 'position': 'relative' });
                header.prepend(
                    getLoader(CSS_STYLE)
                );
            } else {
                // get header and height before modified
                const box = step.find(STEP_BOX_CONTENT);
                this.steps[key].isBox = true;

                box.css({ 'visibility': 'hidden', 'position': 'relative' });
                box.prepend(
                    getLoader(CSS_STYLE)
                );
            }
        }
    }

    resetStepLoading(key) {
        let selector = STEP_HEADER_CONTENT;
        if (this.steps[key].isBox) {
            selector = STEP_BOX_CONTENT;
        }

        if (this.steps.hasOwnProperty(key)) {
            this.steps[key].step.find(selector + ' > .w-checkout-loader').remove();
            this.steps[key].step.find(selector).css({
                'visibility': 'visible',
            });
        }
    }
}

export { Steps };
