{*

# Description
Template for Custom data fields


## Date last modified
2021-10-28


## Primary variables
+ $entityType                                            - Variable for storing the entity type of the custom data
+ $entityId                                              - Variable for storing the entity id (if any) of the custom data
+ $context                                               - The context the custom data is displayed in (users, checkout)
+ $display                                               - How the custom data is displayed (input, hidden, text)


## Partials (templates)
No extra templates required for this template

*}

{if !isset($entityId)}
    {$entityId = 0}
{/if}

{collection assign=customDataTypes controller=customDataType entityType=$entityType}
{if !empty($context) && $customDataTypes->getActualSize() > 0}
    {if $display === 'list'}
        {foreach $customDataTypes->getData() as $customDataType}
            {if ($context === 'user' && $customDataType->DisplayInUserContext) || ($context === 'checkout' && $customDataType->DisplayInCheckoutContext)}
                {collection assign=customDatas controller=customData typeId=$customDataType->Id entityId=$entityId}
                <div class="m-checkout-data-custom">
                    {$customDataType->Title}:
                    {foreach $customDatas->getData() as $customData}
                        {if $customDataType->Type === 1 || $customData->Selected}
                            {$customData->Value}<br>
                            <input type="hidden" name="customData[{$customDataType->Type}][{$customDataType->Id}][{if $customDataType->Type === 2}{$customData->Value}{/if}]" value="{$customData->Value}">
                        {/if}
                    {/foreach}
                </div>
            {/if}
        {/foreach}
    {elseif $display ne 'hidden'}
    <hr>
    {foreach $customDataTypes->getData() as $customDataType}
        {if ($context eq 'user' && $customDataType->DisplayInUserContext) || ($context eq 'checkout' && $customDataType->DisplayInCheckoutContext)}

            {$returnPostCustomData = null}
            {if $returnPostData}
                {$returnPostCustomData = $returnPostData.customData[{$customDataType->Type}][{$customDataType->Id}]}
            {/if}

            {collection assign=customDatas controller=customData typeId=$customDataType->Id entityId=$entityId}

            {*** Get the custom data for entity and the customdata type ***}
            <fieldset class="form-group m-custom-data-id-{$customDataType->Id}">
                <label class="form-label" for="m-custom-data-id-{$customDataType->Id}">{$customDataType->Title} {if $customDataType->Required}<span class="form-required">*</span>{/if}</label>
            {if $customDataType->Type eq 1}
                {foreach $customDatas->getData() as $customData}
                    <input type="text" class="form-input small" name="customData[{$customDataType->Type}][{$customDataType->Id}][]" value="{if $returnPostCustomData}{$returnPostCustomData[0]}{else}{$customData->Value}{/if}"{if $customDataType->Required} required{/if}>
                {/foreach}
            {elseif $customDataType->Type eq 2}
                {foreach $customDatas->getData() as $customData}

                    {$selected = false}
                    {if $returnPostCustomData and $returnPostCustomData[{$customData->Value}]}
                        {$selected = true}
                    {elseif $customData->Selected}
                        {$selected = true}
                    {/if}

                    <div class="input-group">
                        <span class="input-group-addon">
                            <input id="m-custom-data-id-{$customDataType->Id}-{$customData->Value}" type="checkbox" name="customData[{$customDataType->Type}][{$customDataType->Id}][{$customData->Value}]" value="{$customData->Value}"{if $selected} checked="checked"{/if}>
                        </span>
                        <label for="m-custom-data-id-{$customDataType->Id}-{$customData->Value}" class="form-label input-group-main">{$customData->Title}</label>
                    </div>
                {/foreach}
            {elseif $customDataType->Type eq 3}

                <select id="m-custom-data-id-{$customDataType->Id}" class="form-input form-select small" name="customData[{$customDataType->Type}][{$customDataType->Id}][]">
                    {foreach $customDatas->getData() as $customData}
                        {$selected = false}
                        {if $returnPostCustomData and $returnPostCustomData[0] eq $customData->Value}
                            {$selected = true}
                        {elseif $customData->Selected}
                            {$selected = true}
                        {/if}
                        <option value="{$customData->Value}"{if $selected} selected="selected"{/if}>{$customData->Title}</option>
                    {/foreach}
                </select>
            {/if}
            </fieldset>
        {/if}
    {/foreach}
    {else}
        {foreach $customDataTypes->getData() as $customDataType}
            {if ($context === 'user' && $customDataType->DisplayInUserContext) || ($context === 'checkout' && $customDataType->DisplayInCheckoutContext)}
                {collection assign=customDatas controller=customData typeId=$customDataType->Id entityId=$entityId}

                {foreach $customDatas->getData() as $customData}
                    {if $customDataType->Type === 1 || $customData->Selected}
                        <input type="hidden" name="customData[{$customDataType->Type}][{$customDataType->Id}][{if $customDataType->Type === 2}{$customData->Value}{/if}]" value="{$customData->Value}">
                    {/if}
                {/foreach}
            {/if}
        {/foreach}
    {/if}
{/if}