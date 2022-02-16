{*

# Description
Customer input widget. A widget that allows the user form to handle different user types in a more elegant manner.

## Date last modified
2021-08-05

*}

{addLink src='modules/widgets/customertypeinput/include/customertypeinput.css'}
{addScript src='modules/widgets/customertypeinput/include/customertypeinput.js'}

{* Parameters *}
{$inputFieldPrefix = $inputFieldPrefix|default:'w'}
{$showPrivateOption = $showPrivateOption|default:true}
{$requireCompanyFields = $requireCompanyFields|default:false}
{$companyName = $companyName|default:null}
{$vatNumber = $vatNumber|default:null}
{$eanNumber = $eanNumber|default:null}

{* Logic *}
{$amountOfCustomerTypeOption = 0}
{if $showPrivateOption}
    {$amountOfCustomerTypeOption = $amountOfCustomerTypeOption + 1}
{/if}

{if $settings.shop_customer_company || $requireCompanyFields}
    {$amountOfCustomerTypeOption = $amountOfCustomerTypeOption + 1}
{/if}

{if $settings.shop_customer_institution}
    {$amountOfCustomerTypeOption = $amountOfCustomerTypeOption + 1}
{/if}

{* Markup *}
<fieldset 
    class="form-group w-customer-type-input"
    {if $amountOfCustomerTypeOption < 2}style="display:none;"{/if}
>
    <label class="form-label">{$Text.CUSTOMER_TYPE}</label>
    <div class="button-group">
        {if $showPrivateOption}
        <label class="button-primary">
            <input type="radio" name="customer-type" value="private">
            <span>{$Text.CUSTOMER_TYPE_PRIVATE}</span>
        </label>
        {/if}

        {if $settings.shop_customer_company || $requireCompanyFields}
        <label class="button">
            <input type="radio" name="customer-type" value="company">
            <span>{$Text.CUSTOMER_TYPE_COMPANY}</span>
        </label>
        {/if}
        
        {if $settings.shop_customer_institution}
        <label class="button">
            <input type="radio" name="customer-type" value="institution">
            <span>{$Text.CUSTOMER_TYPE_INSTITUTION}</span>
        </label>
        {/if}
    </div>
</fieldset>

{if $settings.shop_customer_company || $requireCompanyFields}
    <fieldset class="form-group {$inputFieldPrefix}-company" data-active-on-customer-type="company" style="display: none;">
        <label class="form-label" for="{$inputFieldPrefix}-company">{$Text.COMPANY} <span class="form-required">*</span></label>
        <input type="text" name="company" autocomplete="organization" {if $companyName}value="{$companyName}"{/if} id="company" class="form-input" placeholder="{$Text.COMPANY}" data-is-required disabled>
    </fieldset>
    
    <fieldset class="form-group {$inputFieldPrefix}-vatnumber" data-active-on-customer-type="company" style="display: none;">
        <label class="form-label" for="{$inputFieldPrefix}-vatnumber">{$Text.VAT_NR} <span class="form-required">*</span></label>
        <input type="text" name="vatNumber" autocomplete="disable" {if $vatNumber}value="{$vatNumber}"{/if} id="vatNumber" class="form-input" placeholder="{$Text.VAT_NR}" data-is-required disabled>
    </fieldset>
    
    <fieldset class="form-group {$inputFieldPrefix}-eannumber" data-active-on-customer-type="company" style="display: none;">
        <label class="form-label" for="{$inputFieldPrefix}-eannumber">{$Text.EAN}</label>
        <input type="text" name="eanNumber" autocomplete="disable" {if $eanNumber}value="{$eanNumber}"{/if} id="eanNumber" class="form-input" placeholder="{$Text.EAN}" disabled>
    </fieldset>
{/if}

{if $settings.shop_customer_institution}
    <fieldset class="form-group {$inputFieldPrefix}-company" data-active-on-customer-type="institution" style="display: none;">
        <label class="form-label" for="{$inputFieldPrefix}-company">{$Text.COMPANY_OR_INSTITUTION} <span class="form-required">*</span></label>
        <input type="text" name="company" autocomplete="organization" {if $companyName}value="{$companyName}"{/if} id="company" class="form-input" placeholder="{$Text.COMPANY_OR_INSTITUTION}" data-is-required disabled>
    </fieldset>
    
    <fieldset class="form-group {$inputFieldPrefix}-eannumber" data-active-on-customer-type="institution" style="display: none;">
        <label class="form-label" for="{$inputFieldPrefix}-eannumber">{$Text.EAN} <span class="form-required">*</span></label>
        <input type="text" name="eanNumber" autocomplete="disable" {if $eanNumber}value="{$eanNumber}"{/if} id="eanNumber" class="form-input" placeholder="{$Text.EAN}" data-is-required disabled>
    </fieldset>
{/if}
