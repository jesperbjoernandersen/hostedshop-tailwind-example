{includeScript file='partials/body.js.tpl'}

<div class="navbar-placeholder">
    <nav class="navbar site-header">
        <div class="container">
            <div class="navbar-content">
                <div class="navbar-left">

                    {* LOGO *}
                    {include file='modules/widgets/logo/logo.tpl'}

                </div>

                <div class="navbar-center">

                    {* PRODUCT MENU *}
                    {collection assign=categories controller=productCategory pageSize=6}
                    {include file='modules/widgets/menu/menu.tpl' categories=$categories classes="productmenu menu-inline" isCategories=true}

                </div>

                <div class="navbar-right">

                    {* ICON MENU *}
                    <ul class="menu menu-inline navbar-icons">

                        {* LANGUAGE SELECTOR *}
                        {collection controller=language assign=languages}
                        {if $languages->getActualSize() gt 1}
                            <li class="is-hidden-s">
                                {include file="modules/widgets/language/language.tpl" collection=$languages type="dropdown"}
                            </li>
                        {/if}

                        {* CURRENCY SELECTOR *}
                        {collection controller=currency assign=currencies}
                        {if $currencies and $currencies->getActualSize() gt 1}
                            <li class="is-hidden-s">
                                <div class="w-currency-picker is-inline-block">
                                    {include file="modules/widgets/currency/currency.tpl" collection=$currencies type="dropdown"}
                                </div>
                            </li>
                        {/if}

                        {* WISHLIST *}
                        {if $settings.module_shop_wishlist and $access.wishlist and $user}
                            <li><a href="/{$text.WISHLIST_LINK}/">{include file="modules/widgets/icon/icon.tpl" icon=heart}</a></li>
                        {/if}

                        {* SEARCH *}
                        {if $template.settings.SETTINGS_SHOW_SEARCH}
                            <li>
                                {include file="modules/widgets/search/search.tpl"}
                            </li>
                        {/if}

                        {* CART *}
                        {if $general.isShop && $template.settings.SETTINGS_SHOW_CART && $page.type != 'cart' && $page.type != 'checkout'}
                            <li>
                                {include file="modules/widgets/cart/cart.tpl"}
                            </li>
                        {/if}

                        {* MOBILE MENU *}
                        <li class="mobile-menu"><label for="toggleSidebar">{include file='modules/widgets/icon/icon.tpl' icon=menu}</label></li>

                    </ul>
                </div>
            </div>
        </div>
    </nav>
</div>
