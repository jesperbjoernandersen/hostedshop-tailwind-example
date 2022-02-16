{*

# Description
Template for inclusion of metadata for an ImageObject (see http://schema.org/ImageObject).


## Date last modified
2017-05-22


## Primary variables
+ $itemprops 						- The item properties that should be associated with this ImageObject (as a string)
+ $imageURL							- URL of the image
+ $height 							- Height of the image (in pixels)
+ $width 							- Width of the image (in pixels)

*}

{$data = [
	'image'  => $imageURL,
	'url'    => $imageURL,
	'height' => $height|default:0,
	'width'  => $width|default:0
]}

<div {if isset($itemprops)}itemprop="{$itemprops}"{/if} itemscope itemtype="http://schema.org/ImageObject">
	{foreach $data as $itemprop => $val}
		<meta itemprop="{$itemprop}" content="{$val}">
	{/foreach}
</div>