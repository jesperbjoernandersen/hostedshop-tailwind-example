
<footer class="footer site-footer">
    <div class="container">
        <div class="footer-content">
            {if $access.user && $template.settings.SETTINGS_SHOW_FOOTER_USER}
            <div>
                <strong>{$text.YOUR_ACCOUNT}</strong>
                <ul class="menu menu-vertical">
                    {if $general.isShop}
                        <li><a href="/{$text.MY_ORDERS_LINK}/">{$text.MY_ORDERS_MENU}</a></li>
                        {if $settings.module_shop_wishlist and $access.wishlist}
                            <li><a href="/{$text.WISHLIST_LINK}/">{$text.WISHLIST_MENU}</a></li>
                        {/if}
                    {/if}
                    <li><a href="/{$text.USER_UPDATE_LINK}/">{$text.USER_UPDATE_MENU}</a></li>
                    {if $user}
                        <li><a href="/actions/user/logout">{$text.LOGOUT_HEADLINE}</a></li>
                    {else}
                        <li><a href="/{$text.LOGIN_LINK}/">{$text.LOGIN_HEADLINE}</a></li>
                    {/if}
                </ul>
            </div>
            {/if}
            {if $template.settings.SETTINGS_SHOW_FOOTER_NAV}
            <div>
                <strong>{$text.WHERE_AM_I_NAVIGATION}</strong>
                {menu assign=primaryMenu static=$static}
                {include
                    file='modules/widgets/menu/menu.tpl'
                    items=$primaryMenu
                    classes="menu-vertical"
                }
                {if $template.settings.SETTINGS_SHOW_SITEMAP}
                    <span class="sitemap-link"><a href="/{$text.SITEMAP_LINK}/">{$text.SITEMAP_HEADLINE}</a></span>
                {/if}
            </div>
            {/if}
            {if $access.user && $settings.news_signup && $template.settings.SETTINGS_SHOW_FOOTER_NEWS_SIGNUP}
            <div>
                <strong>{$text.NEWSLETTER_TYPE_HEADLINE}</strong>
                {include file="modules/widgets/newsletter/newsletter.tpl" lazyloadRecaptcha=true}
            </div>
            {/if}
            <div>
                {if $contactdata.name && $template.settings.SETTINGS_SHOW_CONTACT_TITLE}
                    <strong>{$contactdata.name}</strong>
                {/if}
                <ul class="contacts">
                    {if ($contactdata.address && $template.settings.SETTINGS_SHOW_CONTACT_ADDRESS) || ($contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE) || ($contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY) || ($contactdata.country && $template.settings.SETTINGS_SHOW_CONTACT_COUNTRY)}
                    <li>
                        {include file='modules/widgets/icon/icon.tpl' icon=mapPin}
                        <div>
                            {if $contactdata.address && $template.settings.SETTINGS_SHOW_CONTACT_ADDRESS}
                                <strong>{$contactdata.address}</strong>
                            {/if}
                            {if ($contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE) || ($contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY) || ($contactdata.country && $template.settings.SETTINGS_SHOW_CONTACT_COUNTRY)}
                                <span>{if $contactdata.zipcode && $template.settings.SETTINGS_SHOW_CONTACT_ZIPCODE}{$contactdata.zipcode}{/if}{if $contactdata.city && $template.settings.SETTINGS_SHOW_CONTACT_CITY} {$contactdata.city}{/if}{if $contactdata.country && $template.settings.SETTINGS_SHOW_CONTACT_COUNTRY}, {$contactdata.country}{/if}</span>
                            {/if}
                        </div>
                    </li>
                    {/if}
                    {if ($contactdata.phone && $template.settings.SETTINGS_SHOW_CONTACT_PHONE) || ($contactdata.mobilephone && $template.settings.SETTINGS_SHOW_CONTACT_MOBILE)}
                    <li>
                        {include file='modules/widgets/icon/icon.tpl' icon=phone}
                        <div>
                            <strong>{$text.TELEPHONE}</strong>
                            {if $contactdata.phone && $template.settings.SETTINGS_SHOW_CONTACT_PHONE}
                                <a href="tel:{$contactdata.phone|replace:' ':''}">{$contactdata.phone}</a>
                            {/if}
                            {if ($contactdata.phone && $template.settings.SETTINGS_SHOW_CONTACT_PHONE) && ($contactdata.mobilephone && $template.settings.SETTINGS_SHOW_CONTACT_MOBILE)}
                                <small> / </small>
                            {/if}
                            {if $contactdata.mobilephone && $template.settings.SETTINGS_SHOW_CONTACT_MOBILE}
                                <a href="tel:{$contactdata.mobilephone|replace:' ':''}">{$contactdata.mobilephone}</a>
                            {/if}
                        </div>
                    </li>
                    {/if}
                    {if $contactdata.email && $template.settings.SETTINGS_SHOW_CONTACT_EMAIL}
                    <li>
                        {include file='modules/widgets/icon/icon.tpl' icon=mail}
                        <div>
                            <strong>{$text.MAIL}</strong>
                            <a href="mailto:{$contactdata.email}">{$contactdata.email}</a>
                        </div>
                    </li>
                    {/if}

                    {$socialFooter =  !empty($settings.social_instagram_pageurl) ||
                    $settings.social_facebook and !empty($settings.social_plugin_likebox_pageurl) ||
                    $settings.social_twitter  and !empty($settings.social_twitter_pageurl) ||
                    $settings.social_youtube  and !empty($settings.social_youtube_pageurl) ||
                    $settings.social_linkedin and !empty($settings.social_linkedin_pageurl)}

                    {if $access.social and $socialFooter}
                    <li>
                        <ul class="socials menu menu-inline">
                            {if $settings.social_plugin_likebox_pageurl and $settings.social_facebook}
                                <li><a href="{$settings.social_plugin_likebox_pageurl}" title="{$text.SOCIAL_BOX_FACEBOOK}" target="_blank">{include file="modules/widgets/icon/icon.tpl" icon="facebook"}</a></li>
                            {/if}
                            {if $settings.social_twitter_pageurl and $settings.social_twitter}
                                <li><a href="{$settings.social_twitter_pageurl}" title="{$text.SOCIAL_BOX_TWITTER}" target="_blank">{include file="modules/widgets/icon/icon.tpl" icon="twitter"}</a></li>
                            {/if}
                            {if $settings.social_youtube_pageurl and $settings.social_youtube}
                                <li><a href="{$settings.social_youtube_pageurl}" title="{$text.SOCIAL_BOX_YOUTUBE}" target="_blank">{include file="modules/widgets/icon/icon.tpl" icon="youtube"}</a></li>
                            {/if}
                            {if $settings.social_linkedin_pageurl and $settings.social_linkedin}
                                <li><a href="{$settings.social_linkedin_pageurl}" title="{$text.SOCIAL_BOX_LINKEDIN}" target="_blank">{include file="modules/widgets/icon/icon.tpl" icon="linkedin"}</a></li>
                            {/if}
                            {if $settings.social_instagram_pageurl}
                                <li><a href="{$settings.social_instagram_pageurl}" title="{$text.SOCIAL_BOX_INSTAGRAM}" target="_blank">{include file="modules/widgets/icon/icon.tpl" icon="instagram"}</a></li>
                            {/if}
                        </ul>
                    </li>
                    {/if}
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <span>{date('Y')} &copy; {$contactdata.company}.</span>
            <span>
                {if $contactdata.vatnumber && $template.settings.SETTINGS_SHOW_CONTACT_VAT_NUMBER}
                    <small>{$text.VAT_NR}: {$contactdata.vatnumber}</small>
                {/if}
                {if $contactdata.bankinfo && $template.settings.SETTINGS_SHOW_CONTACT_BANK_NUMBER}
                    <small>{$text.BANK_DETAILS}: {$contactdata.bankinfo}</small>
                {/if}
                {if $contactdata.fax && $template.settings.SETTINGS_SHOW_CONTACT_FAX}
                    <small>{$text.FAX}: {$contactdata.fax}</small>
                {/if}
            </span>
            {* payment icons *}
            {if $general.isShop && $template.settings.SETTINGS_SHOW_CART_ICONS_FOOTER}
                <span>
                    <div class="text-center footer-paymenticons">
                        {if $template.settings.SETTINGS_SHOW_BIG_CART_ICONS_FOOTER}
                            {$imageWidth  = 54}
                            {$imageHeight = 30}
                            {paymentIcons assign=icons iconSize=large}
                        {else}
                            {$imageWidth  = 34}
                            {$imageHeight = 24}
                            {paymentIcons assign=icons}
                        {/if}
                        {$imageAspect = "{($imageHeight / $imageWidth) * 100}%"}
                        {if $icons->getActualSize() gt 0}
                            <ul class="payment-icons list-unstyled">
                                {foreach $icons->getData() as $icon}
                                    <li class="payments-icon payments-icon-{$icon@index} is-inline-block placeholder-wrapper" data-placeholder-max-width="{$imageWidth}px">
                                        <span class="placeholder" data-placeholder-aspect="{$imageAspect}"></span>
                                        {img alt="{$icon->Title}" title="{$icon->Title}" src="{$template.cdn}{$icon->RelativeFile}"}
                                    </li>
                                {/foreach}
                            </ul>
                        {/if}
                    </div>
                </span>
            {/if}
        </div>
    </div>
</footer>