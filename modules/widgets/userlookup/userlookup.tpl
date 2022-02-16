{*

# Description
Userlookup widget. A widget is a small helper template, with some functionality.
A widget to lookup user or company information.


## Date last modified
2016-12-22


## Primary variables
+ none

## Partials (templates)
+ none

*}

{if $access.userLookup}
    <div class="w-userlookup is-hidden" data-lookup="controller">
        <fieldset class="form-group w-userlookup-search">
            <label class="w-userlookup-headline trailing">{$Text.USERLOOKUP_HEADLINE}:</label>
            <div class="input-group" data-lookup="field">
                <input type="text" id="lookupSearch" data-lookup="input" placeholder="{$Text.USERLOOKUP_HEADLINE}" name="lookupInput" class="form-input input-group-main">
            </div>
        </fieldset>

        <fieldset class="form-group w-userlookup-choice">
            <ul class="list-inline">
                <li><label class="form-label"><input type="radio" name="lookupChoice" data-lookup="choice" value="phonenumber" id="lookupPhoneNumber" {if $returnPostData.lookupChoice != 'vatNumber'}checked='checked'{/if}> <span class="w-userlookup-text">{$text.TELEPHONE}</span></label></li>
                <li><label class="form-label"><input type="radio" name="lookupChoice" data-lookup="choice" value="vatNumber" id="lookupVatNumber" {if $returnPostData.lookupChoice == 'vatNumber'}checked='checked'{/if}> <span class="w-userlookup-text">{$Text.VAT_NR}</span></label></li>
            </ul>
        </fieldset>
        <hr>
    </div>
    {addScript src='modules/widgets/userlookup/include/main.js'}
{/if}

