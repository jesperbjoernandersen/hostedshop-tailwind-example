{*

# Description
Cart widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-08-16


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController
+ $productImage                                                         - Entity of filesContoller
+ $variantData                                                          - Collection of productVariantDataController
+ $variantImage                                                         - Entity of filesController
+ $page                                                                 - Global scope variable containing all information about the page type
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/icon/icon.tpl"                                      - Widget for icons
+ "/modules/widgets/menu/menu.tpl"                                      - Widget for menu

*}

<aside id="site-sidebar">
    <label class="sidebar-close" for="toggleSidebar">
        {include file="modules/widgets/icon/icon.tpl" icon="x"}
    </label>

    <div class="title productmenu-title">
        {$text.CATEGORYS}
    </div>
    {* PRODUCTMENU *}
    {collection assign=categories controller=productCategory}
    {include file='modules/widgets/menu/menu.tpl' items=false categories=$categories classes="productmenu menu-vertical" isSidebar=true isCategories=true}

    <div class="title">
        {$text.WHERE_AM_I_NAVIGATION}
    </div>

    {* TOPMENU *} 
    {menu 
        assign=primaryMenu 
        static=(bool)$template.settings.SETTINGS_SHOW_MY_ACCOUNT
    }

    {include file='modules/widgets/menu/menu.tpl' items=$primaryMenu classes="menu-vertical"}

    <div class="sidebar-widgets">
        {* LANGUAGE SELECTOR *}
        {collection controller=language assign=languages}
        {if $languages->getActualSize() gt 1}
            <div>
                {include file="modules/widgets/language/language.tpl" collection=$languages type="dropdown"}
            </div>
        {/if}
        {* CURRENCY SELECTOR *}
        {collection controller=currency assign=currencies}
        {if $currencies and $currencies->getActualSize() gt 1}
            <div>
                <div class="w-currency-picker is-inline-block">
                    {include file="modules/widgets/currency/currency.tpl" collection=$currencies type="dropdown"}
                </div>
            </div>
        {/if}
    </ul>
</aside>
