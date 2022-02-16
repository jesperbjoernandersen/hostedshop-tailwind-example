;(function ($, platform, exports) {

    platform.render = platform.render || {};

    platform.render['$templates'] = {

        // Last Modified
        version : 20210719,

        // General

        emptyLocation : $.templates([
            '<div class="empty-location">',
                '<div class="empty-title">',
                    '{{:~text("CHECKOUT_STEP_TWO_DROPPOINT_NONE")}}',
                '</div>',
                '{{if ~hasDefault}}',
                    '<fieldset class="random-choice">',
                        '<span class="material-radio">',
                            '<input id="{{:input}}_random" type="radio" name="{{:input}}" class="radio" value="" checked />',
                            '<span class="material-marker"></span>',
                        '</span>',
                        '<label for="{{:input}}_random" class="random-choice-label">{{:text}}</label>',
                    '</fieldset>',
                '{{/if}}',
            '</div>'].join('')),

        // Delivery

        deliveryMethod : $.templates([
            '{{if groupHeader}}',
                '<li class="delivery-header">',
                    '<strong class="delivery-method-group-title">{{:groupHeader}}</strong>',
                '</li>',
            '{{/if}}',
            '{{if fixed}}',
                '<li class="delivery-method-group-products">',
                    '{{for products}}',
                        '{{:#data}}<br />',
                    '{{/for}}',
                '</li>',
            '{{/if}}',
            '<li class="delivery-method{{if droppointName}} droppoint-method{{/if}}{{if name !== "delivery_method"}} special-delivery{{/if}}"',
                '{{if ~checkout_version >= 20210125 && #index !== 0 && !~userChangedDelivery}}style="display: none"{{/if}}>',
                '<div class="delivery-method-header">',
                    '<div class="material-radio">',
                        '<input type="radio" name="{{:name}}" id="{{:id}}" value="{{:value}}" ',
                            'class="radio delivery-method-radio{{if groupHeader}} header{{/if}}{{if messageField}} messageField{{/if}}"',
                            'data-droppoint="{{if droppointName}}{{:droppointName}}{{/if}}"',
                            '{{if groupHeader.length && !~userChangedDelivery}}checked{{/if}} required />',
                        '<div class="material-marker"></div>',
                    '</div>',
                    '<label for="{{:id}}" class="delivery-method-label">',
                        '<div class="delivery-method-info">',
                            '<p class="delivery-method-name">{{:title}}</p>',
                            '<p class="delivery-method-description">{{:text}}{{if freeText}}<i class="is-block">{{:freeText}}</i>{{/if}}</p>',
                            '<p class="delivery-method-price">',
                                '{{if freeDelivery}}',
                                    '{{:~text("FREE")}}!',
                                '{{else}}',
                                    '{{:priceText}}',
                                '{{/if}}',
                            '</p>',
                        '</div>',
                        '{{if ~checkout_version >= 20210125}}',
                            '<div class="text-right">',
                                '<button type="button" class="button change-delivery is-hidden">{{:~text("CHECKOUT_WIDGET_CHANGE")}}</button>',
                            '</div>',
                        '{{else}}',
                            '<div class="text-right delivery-header">',
                                '<button type="button" class="button change-delivery go-back">{{:~text("CHECKOUT_WIDGET_CHANGE")}}</button>',
                            '</div>',
                        '{{/if}}',
                    '</label>',
                '</div>',
                '{{if droppointName}}',
                    '<div class="location-container is-hidden" id="{{if droppointName}}{{:droppointName}}-container{{/if}}">',
                        '<div class="loader"><div></div><div></div><div></div></div>',
                        '<div class="droppoint-active"></div>',
                        '<div class="target-container">',
                            '<div class="droppoint-search">',
                                '<input class="w-zipcode" type="text" name="droppoint_zipcode" placeholder="{{:~text("POSTCODE")}}, {{:~text("ADDRESS")}}">',
                                '<button class="w-search button-primary form-submit" type="button">{{:~text("SEARCH")}}</button>',
                            '</div>',
                            '<ul class="{{if droppointName}}{{:droppointName}}-location-target{{/if}} droppoint-list list-unstyled"></ul>',
                        '</div>',
                    '</div>',
                '{{/if}}',
            '</li>'].join('')),

        droppoint : $.templates([
            '<li class="droppoint">',
                '<span class="material-radio">',
                    '<input id="droppoint_{{:inputName}}_{{:#index}}" type="radio" class="radio" value="{{:reference}}" data-index="{{:#index}}">',
                    '<div class="material-marker"></div>',
                '</span>',
                '<label for="droppoint_{{:inputName}}_{{:#index}}" class="form-label">',
                    '<span class="droppointTextHeader is-block">{{:title}}</span>',
                    '<span class="droppointTextLine is-block">{{:address}}</span>',
                    '<span class="droppointTextLine is-block">{{:zipcode}} {{:city}}</span>',
                    '{{if extra}}<span class="droppointTextLine is-block"><i>{{:extra}}</i></span>{{/if}}',
                '</label>',
            '</li>'].join('')),

        activeDroppoint : $.templates([
            '<div class="droppoint-result">',
                '<input id="droppoint_{{:inputName}}_{{:#index}}" type="hidden" name="{{:inputName}}" value="{{:reference}}">',
                '<fieldset class="form-group">',
                    '<span class="droppointTextHeader is-block">{{:title}}</span>',
                    '<span class="droppointTextLine is-block">{{:address}}</span>',
                    '<span class="droppointTextLine is-block">{{:zipcode}} {{:city}}</span>',
                    '{{if extra}}<span class="droppointTextLine is-block"><i>{{:extra}}</i></span>{{/if}}',
                '</fieldset>',
                '<div class="text-right">',
                    '<button type="button" class="button change-droppoint">{{:~text("CHECKOUT_WIDGET_CHANGE")}}</button>',
                '</div>',
            '</div>'].join('')),
    
        glsLocation : $.templates([
            '<li class="option">',
                '<fieldset class="form-group">',
                    '<div class="input-group">',
                        '<span class="material-radio">',
                            '<input id="gls_location{{:#index}}" type="radio" name="gls_location" class="radio" value="{{:Number}}">',
                            '<span class="material-marker"></span>',
                        '</span>',
                        '<label for="gls_location{{:#index}}" class="form-label input-group-main">',
                            '<span class="droppointTextHeader is-block">{{:CompanyName}} </span>',
                            '<span class="droppointTextLine is-block">{{:Streetname}}, {{:ZipCode}} {{:CityName}}</span>',
                        '</label>',
                    '</div>',
                '</fieldset>',
            '</li>'].join('')),
    
        postdkLocation : $.templates([
            '<li class="option">',
                '<fieldset class="form-group">',
                    '<div class="input-group">',
                        '<span class="material-radio">',
                            '<input id="postdk_location{{:#index}}" type="radio" name="postdk_location" class="radio" value="{{:number}}" />',
                            '<span class="material-marker"></span>',
                        '</span>',
                        '<label for="postdk_location{{:#index}}" class="form-label input-group-main">',
                            '<span class="droppointTextHeader is-block">{{:name}}</span>',
                            '<span class="droppointTextLine is-block">{{:streetName}} {{:streetNumber}}</span>',
                            '<span class="droppointTextLine is-block">{{:postalCode}} {{:city}}</span>',
                            '<span class="droppointTextLine is-block"><i>{{:openingHours}}</i></span>',
                        '</label>',
                    '</div>',
                '</fieldset>',
            '</li>'].join('')),
    
        bringppLocation : $.templates([
            '<li class="option">',
                '<fieldset class="form-group">',
                    '<div class="input-group">',
                        '<span class="material-radio">',
                            '<input id="bringpp_location{{:#index}}" type="radio" name="bringpp_location" class="radio" value="{{:id}}">',
                            '<span class="material-marker"></span>',
                        '</span>',
                        '<label for="bringpp_location{{:#index}}" class="form-label input-group-main">',
                            '<span class="droppointTextHeader is-block">{{:name}} </span>',
                            '<span class="droppointTextLine is-block">{{:visitingAddress}}, {{:visitingPostalCode}}',
                                '{{:visitingCity}}</span>',
                        '</label>',
                    '</div>',
                '</fieldset>',
            '</li>'].join('')),
    
        daoLocation : $.templates([ 
            '<li class="option">',
                '<fieldset class="form-group">',
                    '<div class="input-group">',
                        '<span class="material-radio">',
                            '<input id="dao_location{{:#index}}" type="radio" name="dao_location" class="radio" value="{{:id}}">',
                            '<span class="material-marker"></span>',
                        '</span>',
                        '<label for="dao_location{{:#index}}" class="form-label input-group-main">',
                            '<span class="droppointTextHeader is-block">{{:name}} </span>',
                            '<span class="droppointTextLine is-block">{{:visitingAddress}}, {{:visitingPostalCode}} {{:visitingCity}}</span>',
                        '</label>',
                    '</div>',
                '</fieldset>',
            '</li>'].join('')),

        // order

        orderSummary : $.templates([
            '<div class="order-summary" data-group="w-checkout-order" data-target="w-checkout-order" data-toggle="collapse">',
                '<ul class="order-list list-unstyled">',
                    '<li class="order-line-products">',
                        '<ul class="list-unstyled">',
                            '{{for orderLines.lines}}',
                                '<li class="{{if ~root.orderLineLimit && #index >= ~root.orderLineLimit}}is-hidden{{/if}}">',
                                    '<span>',
                                        '<span>',
                                            '{{:amount}}{{if unit}}&nbsp;<span class="orderLineAmountText">{{:unit}}</span>{{/if}}&nbsp;',
                                        '</span>',
                                        '<span class="title">{{:title}}</span>',
                                        '{{if hasAdditional}}',
                                            '<div>{{:titleAdditional}} {{:titleForm}}</div>',
                                        '{{/if}}',
                                        '{{if titlePacketProducts}}',
                                            '<div>{{:titlePacketProducts}}</div>',
                                        '{{/if}}',
                                        '{{if giftcard}}',
                                            '<div>{{:~text("GIFT_CARD_NAME")}}: {{:giftcard.name}}</div>',
                                        '{{/if}}',
                                    '</span>',
                                    '<span class="cart-total-value text-right">',
                                        '{{:priceTotal}}&nbsp;{{:~productVatText(priceVatCalc,  priceNoVatCalc)}}',
                                    '</span>',
                                '</li>',
                            '{{/for}}',
                            '{{if coupon}}',
                            '<li>',
                                '<span>{{:~text("GIFT_CARD")}}:&nbsp;{{:coupon.title}}</span>',
                                '<span>{{:coupon.priceFormatted}}&nbsp;{{:~vatText}}</span>',
                            '</li>',
                            '{{/if}}',
                            '{{if discount}}',
                            '<li>',
                                '<span>{{:discount.title}}</span>',
                                '<span>{{:discount.price}}&nbsp;{{:~vatText}}</span>',
                            '</li>',
                            '{{/if}}',
                            '<li>',
                                '<span>{{:~text("PRODUCT_CATALOG_COUNT")}}&nbsp;{{:products.amount}}</span>',
                                '<span><a class="w-checkout-link" href="/{{:~text("CART_LINK")}}/">{{:~text("EDIT")}}</a></span>',
                            '</li>',
                        '</ul>',
                    '</li>',
                    '<li class="order-line-delivery">',
                        '<span>{{:~text("CHECKOUT_STEP_FOUR_DELIVERY")}} {{:delivery.title}}</span>',
                        '<span class="text-right">{{:delivery.priceFormatted}}</span>',
                    '</li>',
                    '<li class="order-line-subTotal">',
                        '<span>{{:~text("CART_PRICE_SUM")}}</span>',
                        '<span class="text-right">{{:subTotalFormatted}}</span>',
                    '</li>',
                    '<li class="order-line-vat">',
                        '<span>{{if ~hasVat}}{{:~text("CART_VAT_INCLUSIVE")}}{{else}}{{:~text("CART_VAT_EXCLUSIVE")}}{{/if}}</span>',
                        '<span class="text-right">{{:totalvatFormatted}}</span>',
                    '</li>',
                    '{{if payment.price != "0"}}',
                    '<li class="order-line-payment">',
                        '<span>{{:~text("MY_ORDERS_FEE")}}</span>',
                        '<span class="text-right">{{:payment.priceFormatted}}</span>',
                    '</li>',
                    '{{/if}}',
                '</ul>',
            '</div>',
            '<div class="order-total" data-target="w-checkout-order" data-toggle="collapse">',
                '<strong><i class="fa fa-info-circle"></i>{{:~text("CART_TOTAL")}}&nbsp;<span>({{:~text("PRODUCT_CATALOG_COUNT")}} {{:products.amount}})<span></strong>',
                '<strong>{{:totalFormatted}}</strong>',
            '</div>'
        ].join('')),

        terms: $.templates([
            '<style>',
                '.w-checkout-terms-overlay {',
                    'background: #fff;',
                    'display: none;',
                    'position: absolute;',
                    'width: 100%;',
                    'height: 100%;',
                '}',
                '.w-checkout-terms-overlay.open {',
                    'display: flex;',
                    'flex-direction: column;',
                    'position: absolute;',
                    'top: 0;',
                '}',
                '.w-checkout-terms-content {',
                    'overflow-y: auto;',
                    'width: 100%;',
                    'height: 100%;',
                    'padding: 8px;',

                    // Scroll shadow
                    'background-position: 0 0, 0 100%, 0 0, 0 100%;',
                    'background-size: 100% 1em, 100% 1em, 100% 1em, 100% 1em;',
                    'background-attachment: local, local, scroll, scroll;',
                    'background-repeat: no-repeat;',
                    'background-image: -webkit-linear-gradient(top, #fff, #fff), -webkit-linear-gradient(bottom, #fff, #fff), -webkit-linear-gradient(top, #cfcfcf, #fff), -webkit-linear-gradient(bottom, #cfcfcf, #fff);',
                    'background-image: linear-gradient(to bottom, #fff, #fff), linear-gradient(to top, #fff, #fff), linear-gradient(to bottom, #cfcfcf, #fff), linear-gradient(to top, #cfcfcf, #fff);',
                '}',
                '.w-checkout-terms-controls {',
                    'display: flex;',
                    'justify-content: center;',
                    'padding: 8px;',
                '}',
            '</style>',
            '<div class="w-checkout-terms-overlay">',
                '<div class="w-checkout-terms-content">',
                    '<h3>{{:Headline}}</h3>',
                    '{{:Text}}',
                '</div>',
                '<div class="w-checkout-terms-controls">',
                    '<button class="w-checkout-terms-close button">{{:~text("MODAL_CLOSE")}}</button>',
                '</div>',
            '</div>'
        ].join(''))

    }

})(jQuery, window.platform, window);
