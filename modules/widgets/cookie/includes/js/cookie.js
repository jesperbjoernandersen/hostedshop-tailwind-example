;(function($, platform, exports) {
    'use strict';

    var cookieRemoveWrap = $('[data-inject="cookieremove"]'),
        consentForm = $('[data-group=w-cookie-form]'),
        acceptButton = consentForm.find('button[type="submit"][name="accept"]');

    if (consentForm.length) {
        // Cookie submit handler
        consentForm.find('button[type="submit"]').on('click', cookieFormHandler);
        // Cookie toggle handler
        consentForm.find('input[type="checkbox"]').on('change', cookieChangeHandler);
    };

    // Build table with cookies injected: <div id="cookiedetails"></div>
    if ($('[data-inject="cookiedetails"]').length) {
        if (platform.cookielist.internal && platform.cookielist.external) {
            $.get( platform.cookielist.internal ).done(function( internal ) {
                $.get( platform.cookielist.external ).done(function( external ) {
                    cookieDetails(internal, external);
                });
            });
        }
    };

    // Inject remove cookies button via: <div id="cookieremove"></div>
    if (platform.cookies.indexOf("cookie_consent") > -1 && cookieRemoveWrap.length) {
        cookieRemoveWrap.html('<button class="cookie-button button-primary sw-cookie-remover">' + text.COOKIES_BUTTON_DELETE + '</button>');
        cookieRemoveWrap.find('button.sw-cookie-remover').on('click', cookieRemove);
    }

    // Accordion handler start
    platform.initAccordion = function() {
        $('button.accordion-btn').each(function() {
            $(this).unbind('click');
            $(this).click(function(evt) {
                var wrapper = $(evt.target).closest('.accordion-wrapper');
                wrapper.toggleClass('closed');
                wrapper.parent().find('button.accordion-btn').each(function() {
                    if (this !== evt.target) {
                        $(this).closest('.accordion-wrapper').addClass('closed');
                    }
                })
            });
        });
        $('.handle-scrollHeight').each(function() {
            var maxHeight = $(this).prop('scrollHeight') + 50 + 'px';
            $(this).css({'maxHeight': maxHeight});
        });
    }
    platform.initAccordion();
    // Accordion handler end

    // Handles the cookie form submit event start
    function cookieFormHandler(evt) {
        evt.preventDefault();
        var acceptAll = evt.target.name == 'accept_all';
        var inputVerification = ['REQUIRED', 'FUNCTIONAL', 'STATISTICS', 'MARKETING'];
        var inputs = consentForm.find('input');
        var states = [];
        var errors = false;

        // Show spinner
        consentForm.find('.w-cookie-loader').removeClass('is-hidden');

        // Handle form states
        inputs.each(function() {if (acceptAll || this.checked) states.push(this.name)});

        // Verification handler start
        states.forEach(function(state) { errors = inputVerification.indexOf(state) === -1});
        if (states.indexOf('REQUIRED') === -1) errors = true;
        // Verification handler end

        // Tjek for errors, otherwise continue
        if (errors) {
            errorHandler();
        } else {
            $.ajax({
              type: 'POST',
              url: '/api/actions/cookies/consent',
              data: {
                  'ip': platform.client.ip,
                  'consent_given': states.length > 0,
                  'allowed_cookie_types': states.toString()
              },
              success: function(){
                  var current = new Date();
                  var expiration = new Date(current.getFullYear() + 1, current.getMonth(), current.getDate());
                  document.cookie = 'cookie_consent=' + states.toString() + ';expires=' + expiration.toGMTString() + ';path=/';
                  sessionStorage.setItem('referrer', document.referrer);
                  window.location.reload();
              },
              dataType: 'json'
            }).fail(function(jqXHR) {
                errorHandler(JSON.parse(jqXHR.responseText).map(function(item){
                    return item.field[0] + ': ' + item.message;
                }).join('\n'));
            });
        };

        // Error handler
        function errorHandler(message) {
            consentForm.find('.w-cookie-loader').addClass('is-hidden');
            alert(message ? message : text.COOKIES_VERIFICATION_ERROR + ': ' + inputVerification.join(', '));
        };
    }
    // Handles the cookie form submit event end

    // Handles changes to cookie checkboxes
    function cookieChangeHandler(evt) {
        evt.preventDefault();
        var optionalCookiesSelected = consentForm.find('input[type="checkbox"][name!="REQUIRED"]:checked');
        
        if (optionalCookiesSelected.length) {
            acceptButton.html(text.COOKIES_ACCEPT);
        } else {
            acceptButton.html(text.COOKIES_DECLINE_ALL);
        }
    }

    // Builds Cookie details
    function cookieDetails(internal, external) {

        var categoriesDeDubed = Object.keys($.extend({}, internal, external));
        var listedCookies = [];
        var cookies = {};

        categoriesDeDubed.forEach(function(category) {
            listedCookies = listedCookies.concat(Object.keys(internal[category]).concat(Object.keys(external[category])));
            var categoryCookies = $.extend({}, internal[category], external[category]);
            cookies[category] = Object.keys(categoryCookies).map(function(item) {
                if (typeof categoryCookies[item] === 'object') {
                    var output = categoryCookies[item];
                    var settingsRequirement = !output.requires || !output.requires.length || output.requires.map(function(setting){
                        return Boolean(platform.settings[setting]) || Boolean(platform.template.settings[setting]);
                    }).indexOf(true) !== -1;
                    output.name = item;

                    return settingsRequirement && output;
                }
            }).filter(function(item) {
                return item;
            });
        });

        // Add unregisted cookies
        platform.cookies.forEach(function(key) {
            if (listedCookies.indexOf(key) === -1) cookies['uncategorized'].push({name: key});
        });

        // Build accordion cookie tables
        $('[data-inject="cookiedetails"]').html(categoriesDeDubed.map(function(category) {
            return buildSection(cookies[category], category);
        }).join(''));
        platform.initAccordion();

        // Builds list items for cookie details
        function buildSection(cookieList, category) {
            var categoryTrans = text['COOKIES_' + category.toUpperCase()] ? text['COOKIES_' + category.toUpperCase()] : category;
            var categoryDescription = text['COOKIES_DESCRIPTION_' + category.toUpperCase()] ?
            '<p class="accordion-description">' + text['COOKIES_DESCRIPTION_' + category.toUpperCase()] + '</p>' : '';

            var listString = cookieList.map(function(cookie) {
                var category = cookie.category ? text['COOKIES_' + cookie.category.toUpperCase()] : text.COOKIES_UNKNOWN;
                var translation = { description: text.COOKIES_UNKNOWN, expiration: text.COOKIES_UNKNOWN };

                if (cookie.translations && cookie.translations[platform.language.iso]) {
                    translation = cookie.translations[platform.language.iso];
                } else if (cookie.translations && cookie.translations[platform.language.iso.substring(0,2)]) {
                    translation = cookie.translations[platform.language.iso.substring(0,2)];
                } else if (cookie.translations && cookie.translations.UK) {
                    translation = cookie.translations.UK;
                };
                return [
                    '<tr>',
                        '<td>',
                            '<p>' + cookie.name + '</p>',
                            '<strong class="is-visible-s">' + text.COOKIES_LIST_ORIGIN + ':</strong>',
                            '<p class="is-visible-s">' + (cookie.origin ? cookie.origin : '') + '</p>',
                            '<strong class="is-visible-s">' + text.COOKIES_LIST_DESCRIPTION + ':</strong>',
                            '<p class="is-visible-s">' + translation.description + '</p>',
                        '</td>',
                        '<td class="is-hidden-s"><p>' + (cookie.origin ? cookie.origin : '') + '</p></td>',
                        '<td class="is-hidden-s"><p>' + translation.description + '</p></td>',
                        '<td><p>' + translation.expiration + '</p></td>',
                    '</tr>'
                ].join('');
            }).join('');

            return listString.length ? [
                '<div class="accordion-wrapper closed">',
                    '<button type="button" class="accordion-btn"><i class="fa fa-fw fa-caret-down"></i><div class="accordion-text"><strong class="accordion-title">' + categoryTrans + '</strong>' + categoryDescription + '</div></button>',
                    '<div class="accordion-section handle-scrollHeight">',
                        '<table class="table w-cookie-list">',
                            '<thead>',
                                '<th>' + text.COOKIES_LIST_COOKIE + ':</th>',
                                '<th class="is-hidden-s">' + text.COOKIES_LIST_ORIGIN + ':</th>',
                                '<th class="is-hidden-s">' + text.COOKIES_LIST_DESCRIPTION + ':</th>',
                                '<th>' + text.COOKIES_LIST_EXPIRE + ':</th>',
                            '</thead>',
                            '<tbody>' + listString + '</tbody>',
                        '</table>',
                    '</div>',
                '</div>'
            ].join('') : '';
        };
    };

    function cookieRemove() {
        var cookies = document.cookie.split(';');
        cookies.forEach(function(cookieItem){
            var cookie = cookieItem.trim();
            var name = cookie.indexOf('=') > -1 ? cookie.substr(0, cookie.indexOf('=')) : cookie;
            document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/';
        })
        window.location.reload();
    };
})(jQuery, window.platform, window);
