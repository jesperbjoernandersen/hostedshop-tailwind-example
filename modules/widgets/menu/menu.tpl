{*

# Description
Menu widget. A widget is a small helper template, with some functionality.


## Date last modified
2021-02-11


## Primary variables
+ $items                            - A variable containing the collection sent
+ $categories                       - Instance of productCategoryController
+ $classes                          - A string of classes to add to the first set of parents
+ $subclasses                       - A string of classes to add to children specificly
+ $isSidebar                        - Show "See more" link if max categories shown
+ $isCategories                     - Tells if the menu is a category or normal menu


## Partials (templates)
+ "/modules/widgets/icon/icon.tpl"  - Icon widget

# Description
Function to recursively generate any menu.

## Resource
+ [Smarty functions](http://www.smarty.net/docs/en/language.function.function.tpl)

 *}

{$pagelink = {page id=$page.productPageId print=Link}}

{function name=printMenu}
{if $isCategories && $general.isShop}
    {$showOnly = 5}
    {if $isSidebar || $nested}
        {$showOnly = 999}
    {/if}
    {if $categories->getActualSize() gt 0}
      <ul class="menu{if $classes} {$classes}{/if}">
          {foreach $categories->getData() as $cat key=k}
              {collection assign=subCat controller=productCategory parentId=$cat->Id}
              {$hasChildren = $subCat->getActualSize() gt 0}
              {if $k < $showOnly}
                  <li class="{if $hasChildren}has-dropdown{/if} {if !$nested}topitem{/if}">
                      <a href="/{$pagelink}/{$cat->Handle}/" class="{$itemClasses}" aria-haspopup="true" title="{$cat->Title}">
                          {$cat->Title}
                          {if $hasChildren}
                              <span class="item-arrow">
                                  {include file="modules/widgets/icon/icon.tpl" icon="chevronDown"}
                              </span>
                          {/if}
                      </a>
                      {if $hasChildren}
                          {call name=printMenu categories=$subCat classes=$subclasses subclasses=$subclasses nested=true}
                      {/if}
                  </li>
              {/if}
          {/foreach}
          {$hasMore = $categories->getActualSize() eq 6}
          {if !$nested && !$isSidebar && $hasMore}
              <li><a href="/{$pagelink}/">{$text.SEE_ALL}</a></li>
          {/if}
      </ul>
    {/if}
{else}
    {$itemsCount = $items|count}
    {if $itemsCount gt 0}
        <ul class="menu{if $classes} {$classes}{/if}">
            {foreach $items as $item key=k}
                {$hasChildren = isset($item['children']) and count($item['children']) gt 0}
                <li class="{if $hasChildren}has-dropdown{/if} {if !$nested}topitem{/if}">
                    <a href="{$item.handle|formatUrl}" class="{$itemClasses}" aria-haspopup="true" title="{$item.title}">
                        {$item.title}
                        {if $hasChildren}
                            <span class="item-arrow">
                                {include file="modules/widgets/icon/icon.tpl" icon="chevronDown"}
                            </span>
                        {/if}
                    </a>
                    {if $hasChildren}
                        {call name=printMenu items=$item.children classes=$subclasses subclasses=$subclasses nested=true}
                    {/if}
                </li>
            {/foreach}
        </ul>
    {/if}
{/if}
{/function}

{call name=printMenu items=$items categories=$categories classes=$classes subclasses=$subclasses}
