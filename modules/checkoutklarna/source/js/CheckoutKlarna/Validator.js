/*
 * Validate checkout before proceeding to actions
 */

import { TYPE_NORMAL, TYPE_DROPPOINT } from "./Delivery";

class Validator {

    text;
    delivery;
    klarnaDeliveryIntermediate;
    transition;

    klarnaCountry;
    klarnaZip;

    constructor(platform, text, delivery, klarnaDeliveryIntermediate, transition) {
        this.platform = platform;
        this.text = text;
        this.delivery = delivery;
        this.klarnaDeliveryIntermediate = klarnaDeliveryIntermediate;
        this.transition = transition;

        this.klarnaCountry = false;
        this.klarnaZip = false;
    }

    handleShippingAddressChange (event, data) {
        this.klarnaCountry = data?.[0]['country'] ?? false;
        this.klarnaZip = data?.[0]['postal_code'] ?? false;
    }

    validate () {
        const {
            klarnaCountry: systemKlarnaFormatCountry,
            zipcode
        } = this.delivery.getAddressInformation();

        const deliveryType = this.delivery.getDeliveryType();

        // collect errors and filter out successes
        let errors = [
            this.hasErrorsZipCode(deliveryType, this.klarnaZip, zipcode),
            this.hasErrorsCountry(deliveryType, this.klarnaCountry, systemKlarnaFormatCountry)
        ].filter(Boolean);

        if (errors.length) {
            throw errors.join("\n");
        }
    }

    hasErrorsZipCode (deliveryType, klarnaZipcode, systemZipcode) {
        console.log('%cValidation', 'font-weight:bold;color:white;background-color:orange;padding:5px;', 'Validator.js', 'hasErrorsZipCode',
            deliveryType,
            deliveryType === TYPE_DROPPOINT,
            klarnaZipcode.trim(),
            systemZipcode.trim()
        );

        if (deliveryType === TYPE_DROPPOINT) return false;

        return (klarnaZipcode && klarnaZipcode.trim() === systemZipcode.trim())
            ? false
            : this.text.KLARNAKCO_INVALID_ZIPCODE;
    }

    hasErrorsCountry (deliveryType, klarnaCountry, systemCountry) {
        console.log('%cValidation', 'font-weight:bold;color:white;background-color:orange;padding:5px;', 'Validator.js', 'hasErrorsCountry',
            deliveryType,
            deliveryType === TYPE_DROPPOINT,
            klarnaCountry.toLowerCase(),
            systemCountry.toLowerCase()
        );

        if (deliveryType === TYPE_DROPPOINT) return false;

        return (klarnaCountry && klarnaCountry.toLowerCase() === systemCountry.toLowerCase())
            ? false
            : this.text.KLARNAKCO_INVALID_DELIVERY_COUNTRY;
    }
}

export { Validator }
