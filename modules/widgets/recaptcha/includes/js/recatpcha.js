(function ($) {

    var $recaptcha = $('form .g-recaptcha');
    if (!$recaptcha.length) {
        return;
    }

    var $forms = $recaptcha.closest('form');
    var badgeOptions = $recaptcha.data('options');
    var hasLazyload = true;

    $recaptcha.each(function () {
        var options = $(this).data('options');
        if (!options.lazyload) {
            hasLazyload = false;
        }
    });

    window.reCaptchaCallback = globalCallback(badgeOptions, $recaptcha);

    if (hasLazyload) {
        $forms.one('mouseover.recaptchaInit focus.recaptchaInit', function () {
            $forms.off('.recaptchaInit');
            setLoading(true);
            load( setLoading(false) );
        });
    } else {
        load();
    }

    function load(complete) {
        var $script = $('script#recaptcha');
        var lazyloadSrc = $script.data('lazyload-src');

        $.getScript(lazyloadSrc).done(function () {
            !!complete && complete();
        }).fail(function () {
            console.error('failed to load recaptcha from google');
        });
    }

    function globalCallback() {

        // cache recatcha width
        var reCaptchaWidth = 304;
        var reCaptchaInvisibleWidth = 256;

        return function () {
            $recaptcha.each(function () {
                var self = this,
                    // elements
                    $this = $(this),
                    $form = $this.closest('form'),
                    // badge options
                    options = $this.data('options'),
                    version = options.version,
                    config = options.config,
                    isInvisible = config.size === 'invisible',
                    // box styling
                    boxWidth = isInvisible ? reCaptchaInvisibleWidth : reCaptchaWidth,
                    hasBoxOverflow = config.badge === 'inline' && boxWidth > $form.outerWidth();

                if (version === 'V3') {
                    if (hasBoxOverflow) {
                        $this.addClass('g-recaptcha-small');
                    }
                    var holderId = grecaptcha.render(self, config);
                    grecaptcha.ready(function () {
                        grecaptcha.execute(holderId, { action: 'submit' }).then(function (token) {
                            $form.find('[name="recaptcha_response"]').val(token);
                        });
                    });
                } else if (version === 'V2') {
                    var $parent = $this.closest('fieldset.w-recatpcha');

                    config.callback = function (recaptchaToken) {
                        if (isInvisible) {
                            $form.find('#g-recaptcha-response').val(recaptchaToken);
                            $form.find(':submit').click();
                        }
                    }
                    if (isInvisible) {
                        if (hasBoxOverflow) {
                            $this.addClass('g-recaptcha-small');
                        }
                    } else {
                        config.size = hasBoxOverflow ? 'compact' : 'normal';
                    }

                    var holderId = grecaptcha.render(self, config);
                    if (config.size === 'invisible') {
                        $form.on('submit', function (evt) {
                            var token = window.grecaptcha.getResponse(holderId);
                            var checkValidity = true;
                            if (typeof $form[0].checkValidity === 'function') {
                                checkValidity = $form[0].checkValidity(); //Trigger HTML5 validation
                            }
                            // if no token, mean user is not validated yet
                            if (checkValidity && !token) {
                                // trigger validation
                                evt.preventDefault();
                                window.grecaptcha.execute(holderId);
                            }
                        });
                    }

                    // Bind reset button to the associated field
                    $parent.find('i').click(function () { grecaptcha.reset(widgetId) });
                }
            });
        }
    }

    function setLoading(isLoading) {
        $forms.find('[type=submit]').prop('disabled', isLoading);
    }

})(jQuery);