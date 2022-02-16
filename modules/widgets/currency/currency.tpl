{*

# Description
Currency widget. A widget is a small helper template, with some functionality.


## Date last modified
2014-08-01


## Primary variables
+ $collection                                                           - Collection of currencyController
+ $type                                                                 - View type (dropdown, select or list)


## Partials (templates)
No extra templates required for this template

*}

<div class="w-currency">

    {*** Type: Dropdown ***}
    {if $type eq 'dropdown'}

        <div class="dropdown w-currency-dropdown">
            <button class="button xsmall" data-toggle="dropdown">{$general.currencyIso}</button>
            <div class="dropdown-menu">
                <div class="dropdown-container">
                    <ul>
                    {foreach $collection->getData() as $item}
                        <li>
                            <a href="{$page.request}?currency={$item->Iso}">
                                {$item->Title} ({$item->Iso})
                            </a>
                        </li>
                    {/foreach}
                    </ul>
                </div>
            </div>
        </div>

    {*** Type: Select ***}
    {elseif $type eq 'select'}

		<div class="w-currency-form">
			<form id="w-currency-form-selector" method="POST" action="#!">
				<select name="currency" class="form-input form-select xsmall" onchange="this.form.submit()">
					{foreach $collection->getData() as $item}
						<option {if $general.currencyIso eq $item->Iso}selected{/if} value="{$item->Iso}">{$item->Title} ({$item->Iso})</option>
					{/foreach}
				</select>
				<button type="submit" style="display:none;"></button>
			</form>
		</div>

    {*** Type: List (else) ***}
    {else}

        <ul class="list-inline w-currency-item-list">
            {foreach $collection->getData() as $item}
                <li class="w-currency-item item-{$item->Id}">
                    <a href="{$page.request}?currency={$item->Iso}" {if $general.currencyIso eq $item->Iso}class="active"{/if}>
                        {$item->Title} ({$item->Iso})
                    </a>
                </li>
            {/foreach}
        </ul>

	{/if}

</div>
