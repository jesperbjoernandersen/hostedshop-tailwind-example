{*

# Description
Search widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-03-16


## Primary variables
No variables


## Partials (templates)
+ "/modules/widgets/icon/icon.tpl"                                      - Widget for icons

*}

<div class="w-search">
    <input type="checkbox" id="searchToggle" hidden />
    <div class="w-search-container">
        <form class="w-search-form container" method="get" action="/{if $general.isShop}{page id=$page.productPageId print=Link}{else}{$Text.SEARCH_LINK}{/if}/">
            <label class="w-search-close" for="searchToggle">{include file='modules/widgets/icon/icon.tpl' icon=x}</label>
            <input type="text" class="w-search-input" name="search" required placeholder="{$text.SEARCH_TEXT}" />
            <button type="submit" class="w-search-submit" title="{$text.SEARCH}">{include file='modules/widgets/icon/icon.tpl' icon=search}</button>
        </form>
        <label class="w-search-open" for="searchToggle">{include file='modules/widgets/icon/icon.tpl' icon=search}</label>
    </div>
</div>