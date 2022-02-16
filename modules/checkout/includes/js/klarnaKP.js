; (function ($, exports, undefined) {
    'use strict';

    var KlarnaHandler = function () {
        this.windows = [];
    };

    KlarnaHandler.prototype = {
        init: function (element) {
            var self = this;
            var el = '[data-klarna-id="' + element.id + '"][data-klarna-group="' + element.klarna.group + '"]';

            var klarna = new exports.platform.KlarnaKP(el, element.session.client_token, [element.klarna.group]);

            if (typeof window.klarnaAsyncCallback == 'function') {
                self.show(element.klarna.group);
            } else {
                $.when(klarna.init()).always(
                    function (status) {
                        self.handleResponse(status, element.klarna.group);
                    }
                );

                var debounced = _.debounce(function(e) {
                    self.handleInput.call(self, e);
                }, 500);

                if (!self.windows.length) {
                    $('#company, #vatNumber, #eanNumber, #deliveryCompany, #phone, #mobile, #email, #deliveryPhone, #deliveryMobile, #deliveryPhone, #deliveryMobile').keyup(debounced);
                }

            }
            self.windows.push(klarna);
        },
        update: function (payment_method_category, orderData) {
            var self = this;
            var klarnaInstance = false;

            // find the correct Klarna instance
            for (var i = 0; i < self.windows.length; i++) {
                var element = self.windows[i];

                if (element.instance_id == payment_method_category) {
                    klarnaInstance = element;
                }
            }

            // if nothing was found exit
            if (!klarnaInstance || !Object.prototype.hasOwnProperty.call(window, 'Klarna')) { return; }

            // data for klarna iframe instance to update
            var step1fields = platform.checkout.STEP1.relevantFieldDatas();
            var contactData = extendContact(step1fields);

            var order = self.constructOrder(contactData, orderData);

            // update the correct klarna iframe instance
            $.when(klarnaInstance.load(order)).always(
                function (status) {
                    self.handleResponse(status, payment_method_category);
                }
            );
        },
        authorize: function (payment_method_category, orderData) {
            var self = this;
            var klarnaInstance = false;

            // find the correct Klarna instance
            for (var i = 0; i < self.windows.length; i++) {
                var element = self.windows[i];

                if (element.instance_id == payment_method_category) {
                    klarnaInstance = element;
                }
            }

            // if nothing was found exit
            if (!klarnaInstance) { return; }

            // data for klarna iframe instance to update
            var step1fields = platform.checkout.STEP1.relevantFieldDatas();
            var contactData = extendContact(step1fields);
            var order = self.constructOrder(contactData, orderData);

            var dfd = jQuery.Deferred();

            // authorize the correct klarna iframe instance
            $.when(klarnaInstance.authorize(order)).always(
                function (status) {
                    if (status && status.finalize_required) {
                        $.when(klarnaInstance.finalize(order)).always(
                            function (status) {
                                self.setToken(klarnaInstance.isAuthorized, klarnaInstance.el, status.authorization_token);
                                self.handleResponse(status, payment_method_category);
                                dfd.resolve(klarnaInstance.isAuthorized);
                            }
                        );
                    } else {
                        self.setToken(klarnaInstance.isAuthorized, klarnaInstance.el, status.authorization_token);
                        self.handleResponse(status, payment_method_category);
                        dfd.resolve(klarnaInstance.isAuthorized);
                    }
                }
            );

            return dfd.promise();
        },
        finalize: function (payment_method_category, orderData) {
            var self = this;
            var klarnaInstance = false;

            // find the correct Klarna instance
            for (var i = 0; i < self.windows.length; i++) {
                var element = self.windows[i];

                if (element.instance_id == payment_method_category) {
                    klarnaInstance = element;
                }
            }

            // if nothing was found exit
            if (!klarnaInstance) { return; }

            // data for klarna iframe instance to update
            var step1fields = platform.checkout.STEP1.relevantFieldDatas();
            var contactData = extendContact(step1fields);
            var order = self.constructOrder(contactData, orderData);

            // authorize the correct klarna iframe instance
            $.when(klarnaInstance.finalize(order)).always(
                function (status) {
                    self.handleResponse(status, payment_method_category);
                }
            );
        },
        handleInput: function (e) {
            var self = this;
            var orderData = platform.checkout.STEP4.orderSummaryData;
            var selectedPayment = platform.checkout.STEP4.relevantFieldDatas();
            if (selectedPayment.paymentMethod === "9") {
                self.update(selectedPayment.paymentType, orderData);
            }
        },
        handleResponse: function (status, payment_method_category) {
            var self = this;

            if (status.show_form === false) {

            } else if (status.error) {
                self.handleError(status, payment_method_category);
            } else {
                self.show(payment_method_category);
            }
        },
        handleError: function (status, payment_method_category) {
            // console.log(status, payment_method_category);
        },
        setToken: function (isAuthorized, el, authorization_token) {
            $(el).parents('.m-klarna-container').find('input[type="hidden"][name="klarnakp_authorization_token"]').val(isAuthorized ?  authorization_token : '');
        },
        show: function (payment_method_category) {
            var $el = $('#paymentMethodContainer_9_' + payment_method_category).removeAttr('style');
        },

        constructOrder: function (contactInfo, orderSummary) {
            var self = this;
            var order = {};

            order['options'] = self.getOptions();
            order['customer'] = self.getCustomer(contactInfo);
            order['billing_address'] = self.getBilling(contactInfo, orderSummary);

            if (contactInfo.isDroppoint) {
                order['shipping_address'] = self.getDroppoint(contactInfo, orderSummary);
            } else if (contactInfo.deliveryActive) {
                order['shipping_address'] = self.getShipping(contactInfo, orderSummary);
            } else {
                order['shipping_address'] = self.getBilling(contactInfo, orderSummary);
            }

            return order;
        },

        getBilling: function (contactInfo) {
            var data = {};
            var matrix = {
                "city": contactInfo.city,
                "email": contactInfo.email,
                "family_name": contactInfo.lastname,
                "given_name": contactInfo.firstname,
                "phone": contactInfo.phonenumber,
                "postal_code": contactInfo.zip,
                "street_address": contactInfo.address,
                "street_address2": contactInfo.address2
            };


            if (contactInfo.country !== '') {
                data["country"] = convertCountry(contactInfo.country);
            }

            if (contactInfo.state && contactInfo.state.length && data["country"] === "US") {
                data['region'] = contactInfo.state;
            }

            if (contactInfo.cvr !== '' && contactInfo.company !== '') {
                data["organization_name"] = contactInfo.company;
            }

            return extendNoneEmpty(data, matrix);
        },

        getShipping: function (contactInfo) {
            var data = {};
            var matrix = {
                "city": contactInfo.deliveryCity,
                "email": contactInfo.email,
                "country": contactInfo.deliveryCountry,
                "family_name": contactInfo.deliveryLastname,
                "given_name": contactInfo.deliveryFirstname,
                "organization_name": contactInfo.deliveryCompany,
                "phone": contactInfo.deliveryPhonenumber,
                "postal_code": contactInfo.deliveryZipcode,
                "street_address": contactInfo.deliveryAddress,
                "street_address2": contactInfo.adddeliveryAddress2
            };

            if (contactInfo.country !== '') {
                data["country"] = convertCountry(contactInfo.deliveryCountry);
            }

            if (contactInfo.deliveryState && contactInfo.deliveryState.length && data["country"] === "US") {
                data['region'] = contactInfo.deliveryState;
            }

            return extendNoneEmpty(data, matrix);
        },

        getDroppoint: function (contactInfo) {
            var data = {};
            var matrix = {
                "email": contactInfo.email,
                "country": contactInfo.country,
                "family_name": contactInfo.lastname,
                "given_name": contactInfo.firstname,
                "organization_name": contactInfo.droppoint.name,
                "city": contactInfo.droppoint.city,
                "postal_code": contactInfo.droppoint.zip,
                "street_address": contactInfo.droppoint.address
            };

            if (contactInfo.country !== '') {
                data["country"] = convertCountry(contactInfo.country);
            }

            if (contactInfo.state && contactInfo.state.length && data["country"] === "US") {
                data['region'] = contactInfo.state;
            }

            return extendNoneEmpty(data, matrix);
        },

        getCustomer: function (contactInfo) {
            var customer = {};

            customer['type'] = 'person';
            if (contactInfo.cvr && contactInfo.cvr.length) {
                customer['type'] = 'organization';
                customer['organization_registration_id'] = contactInfo.cvr;
            } else if (contactInfo.ean && contactInfo.length) {
                customer['organization_entity_type'] = 'PUBLIC_INSTITUTION';
                customer['type'] = 'organization';
            }

            return customer;
        },

        getOptions: function () {
            return {
                "color_border": "#cfcfcf",
                "color_border_selected": "#cfcfcf",
                "color_button": platform.template.settings.BUTTON_DEFAULT_BACKGROUND_COLOR,
                "color_button_text": platform.template.settings.BUTTON_DEFAULT_FONT_COLOR,
                "color_checkbox": "#656764",
                "color_checkbox_checkmark": "#656764",
                "color_details": "#656764",
                "color_header": "#656764",
                "color_link": platform.template.settings.FONT_COLOR_LINK,
                "color_text": "#656764",
                "color_text_secondary": "#656764",
                "radius_border": "0px"
            };
        }
    };






    // Klarna Payments 3.0 implementation
    var KlarnaKP = function (el, client_token, payment_method_categories) {
        this.el = el;
        this.client_token = client_token;
        this.payment_method_categories = payment_method_categories;
        this.instance_id = payment_method_categories[0];
        this.isAuthorized = false;
    };

    KlarnaKP.prototype = {
        init: function () {
            var self = this;
            var dfd = jQuery.Deferred();

            jQuery.getScript("https://x.klarnacdn.net/kp/lib/v1/api.js");
            window.klarnaAsyncCallback = function () {
                try {
                    Klarna.Payments.init({ client_token: self.client_token });
                    dfd.resolve(1);
                } catch (e) {
                    dfd.reject(e);
                }
            }

            return dfd.promise();
        },

        load: function (order) {
            var self = this;
            var dfd = jQuery.Deferred();

            try {
                Klarna.Payments.load(
                    {
                        container: self.el,
                        instance_id: self.instance_id,
                        payment_method_categories: self.payment_method_categories
                    },
                    order,
                    function (res) { // load~callback
                        dfd.resolve(res);
                    }
                );
            } catch (e) {
                dfd.reject(e);
            }

            return dfd.promise();
        },

        authorize: function (order) {
            var self = this;
            var dfd = jQuery.Deferred();

            try {
                Klarna.Payments.authorize(
                    {
                        instance_id: self.instance_id,
                        payment_method_categories: self.payment_method_categories
                    },
                    order,
                    function (res) { // load~callback
                        self.isAuthorized = (res && res.approved);
                        dfd.resolve(res);
                    }
                );
            } catch (e) {
                dfd.reject(e);
            }

            return dfd.promise();
        },

        finalize: function (order) {
            var self = this;
            var dfd = jQuery.Deferred();

            try {
                Klarna.Payments.finalize(
                    {
                        instance_id: self.instance_id,
                        payment_method_categories: self.payment_method_categories
                    },
                    order,
                    function (res) { // load~callback
                        self.isAuthorized = (res && res.approved);
                        dfd.resolve(res);
                    }
                );
            } catch (e) {
                dfd.reject(e);
            }

            return dfd.promise();
        }
    };

    var convertCountry = function (country) {
        return country.toLowerCase() == "uk" ? "GB" : country;
    }

    var extendNoneEmpty = function (object, matrix) {
        for (var key in matrix) {
            if (matrix.hasOwnProperty(key) && matrix[key] !== '') {
                object[key] = matrix[key];
            }
        }
        return object;
    }

    var extendContact = function (contactInfo) {
        var selectors = {
            'firstname': '#firstname',
            'lastname': '#lastname',
            'city' : '#city',
            'zip': '#zipcode',
            'address': '#address',
            'address2': '#address2',
            'ean': '#eanNumber',
            'vat': '#vatNumber',
            'companyname': '#company',
            'vatnumber': '#vatNumber',
            'phonenumber': '#mobile',
            'email': '#email',
            'state': "select[id^='state']",
            'deliveryFirstname': "#deliveryFirstname",
            'deliveryLastname': "#deliveryLastname",
            'deliveryCompany': "#deliveryCompany",
            'deliveryAddress': "#deliveryAddress",
            'deliveryZipcode': "#deliveryZipcode",
            'deliveryCity': "#deliveryCity",
            'deliveryCountry': "#deliveryCountry",
            'deliveryState': "select[id^='deliveryState']",
            'deliveryPhonenumber': "#deliveryMobile"
        };

        $.each(selectors, function (key, value) {
            var $value = $(value);

            contactInfo[key] = null;
            if (key == 'phonenumber') {
                if ($value.length && $value.val().length) {
                    contactInfo[key] = $value.val();
                } else {
                    $value = $("#phone");
                    if ($value.length && $value.val().length) {
                        contactInfo[key] = $value.val();
                    }
                }
            } else if (key == 'deliveryPhonenumber') {
                if ($value.length && $value.val().length) {
                    contactInfo[key] = $value.val();
                } else {
                    $value = $("#deliveryPhone");
                    if ($value.length && $value.val().length) {
                        contactInfo[key] = $value.val();
                    }
                }
            } else {
                if ($value.length && $value.val() && $value.val().length) {
                    contactInfo[key] = $value.val();
                }
            }
        });

        // handle if delivery is droppoint
        contactInfo.isDroppoint = false;
        var checkedDroppointCheckbox = $('input[id^="droppoint_"][type="radio"]:visible:checked', platform.checkout.STEP2.wrapper);
        if ( checkedDroppointCheckbox.length )  {
            contactInfo.isDroppoint = true;
            var label = checkedDroppointCheckbox.first().parents('.input-group').find('label')
            var droppoint = {};

            if (label.find('.droppointTextHeader').find('a').length) {
                droppoint.name = label.find('.droppointTextHeader').find('a').text();
            } else {
                droppoint.name = label.find('.droppointTextHeader').text();
            }

            var labelTexts = label.find('.droppointTextLine');
            if (labelTexts.length) {
                droppoint.address = labelTexts.first().text();

                var zipCity = labelTexts.eq(1).text().split(" ");
                if (zipCity.length > 1) {
                    droppoint.zip = zipCity[0];
                    droppoint.city = zipCity.splice(1).join(" ");
                }
            }

            contactInfo.droppoint = droppoint;
        }

        return contactInfo;
    };


    var myStripTags = function (html) {
        var div = document.createElement("div");
        div.innerHTML = html;
        return div.textContent || div.innerText || "";
    }

    exports.platform = exports.platform || {};
    exports.platform.KlarnaKP = exports.platform.KlarnaKP || KlarnaKP;
    exports.platform.KlarnaHandler = exports.platform.KlarnaHandler || KlarnaHandler;

})(jQuery, window);
