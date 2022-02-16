{*

# Description
Template for inclusion of metadata for an Organization (see http://schema.org/Organization).


## Date last modified
2017-05-22


## Primary variables
+ $itemprops                        - The item properties that should be associated with this Organization (as a string)

*}

{* Map of schema.org attribute names to internally recognized names *}
{$organizationFieldsMap = [
    'name' => "company",
    'address' => "address",
    'telephone' => "phone",
    'faxNumber' => "fax",
    'email' => "email",
    'vatID' => "vatnumber"
]}
{$data = []}

{foreach $organizationFieldsMap as $k => $v}
    {if isset($contactdata[$v]) and !empty($contactdata[$v])}
    	{$data[{$k}] = $contactdata[$v]}
    {/if}
{/foreach}

<div {if isset($itemprops)}itemprop="{$itemprops}"{/if} itemscope itemtype="http://schema.org/Organization">
	{foreach $data as $itemprop => $val}
		<meta itemprop="{$itemprop}" content="{$val}">
	{/foreach}

	{if !empty($template.settings.LOGO_SOURCE)}
        {include file="modules/widgets/semantics/image-object.tpl" itemprops="logo" imageURL=$template.settings.LOGO_SOURCE|solutionPath}
    {/if}
</div>