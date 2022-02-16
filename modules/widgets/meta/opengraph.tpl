{*

# Description
Open Graph widget for "The Open Graph meta Protocol". A widget is a small helper template, with some functionality


## Date last modified
2014-08-01


## Resource
+ [The Open Graph protocol for Facebook, Twitter and Google+](http://ogp.me/)


## Primary variables
+ $og                                                                   - Collection of meta properties for opengraph
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
No extra templates required for this template

*}


{if isset($og)}
    {foreach $og as $k => $v}
        {$og[$k] = $v|strip_tags}
    {/foreach}
{/if}


{*** Open Graph type ***}
{if (isset($settings.og_type) and $settings.og_type)}
    {$og_type = "article"}
    {if isset($og) and isset($og['type'])}
        {$og_type = $og['type']}
    {elseif $page.isFrontPage}
        {$og_type = "website"}
    {/if}
    {addMeta property="og:type" content=$og_type}
{/if}

{*** Open Graph title ***}
{if isset($settings.og_title) and $settings.og_title}
    {if isset($og) and isset($og['title'])}
        {$og_title = $og['title']}
    {else}
        {if isset($page.headline) and !empty($page.headline)}
            {$og_title = $page.headline}
        {else}
            {$og_title = $page.title}
        {/if}
    {/if}
    {addMeta property="og:title" content=$og_title}
{/if}

{*** Open Graph url ***}
{if isset($settings.og_url) and $settings.og_url}
    {$og_url = $page.url}
    {if isset($og) and isset($og['url'])}
        {$og_url = $og['url']}
    {/if}

    {addMeta property="og:url" content=$og_url}
{/if}

{*** Open Graph image ***}
{if isset($settings.og_image) and $settings.og_image}
    {if isset($og) and isset($og['image'])}
        {$og_image = $og['image']}
    {elseif $template.settings.LOGO_TYPE eq 'PICTURE' && !empty($template.settings.LOGO_SOURCE[$general.languageIso])}
        {$og_image = $template.settings.LOGO_SOURCE[$general.languageIso]|solutionPath}
    {/if}

    {addMeta property="og:image" content=$og_image}
{/if}

{*** Open Graph sitename ***}
{if isset($settings.og_sitename) and $settings.og_sitename}
    {$og_sitename = ""}
    {if isset($contactdata["name"]) and !empty($contactdata["name"])}
        {$og_sitename = $contactdata["name"]}
    {/if}

    {if isset($og) and isset($og['sitename'])}
        {$og_sitename = $og['sitename']}
    {/if}

    {if !empty($og_sitename)}
        {addMeta property="og:sitename" content=$og_sitename}
    {/if}
{/if}

{*** Open Graph description ***}
{if (isset($settings.og_description) and $settings.og_description) or isset($description)}
    {if isset($og) and isset($og["description"]) and !empty($og["description"])}
        {$og_description = $og["description"]}
    {else}
        {controller assign=pageController type=page}
        {$og_description = {translation module=seo_page title=description id=$page.id}}
    {/if}

    {$og_description = $og_description|trim}
    {if !empty($og_description)}
        {addMeta property="og:description" content=$og_description}
    {else}
        {addMeta property="og:description" content=$contactdata.name}
    {/if}
{/if}

{if $og_type eq "website"}
    {*** Open Graph address ***}
    {if isset($settings.og_address) and $settings.og_address}
        {$address = [
            "street-address" => $contactdata["address"],
            "locality"       => $contactdata["city"],
            "postal-code"    => $contactdata["zipcode"],
            "country-name"   => $contactdata["country"]
        ]}

        {if isset($og) and isset($og["address"]) and is_array($og["address"])}
            {foreach $address|@array_keys as $v}
                {if isset($og["address"][$v])}
                    {$address[$v] = $og["address"][$v]}
                {/if}
            {/foreach}
        {/if}

        {foreach $address as $k => $v}
            {if !empty($v)}
                {addMeta property="og:"|cat:$k content=$v}
            {/if}
        {/foreach}
    {/if}


    {*** Open Graph fax ***}
    {if isset($settings.og_fax) and $settings.og_fax}
        {$og_fax = ""}
        {if isset($contactdata["fax"]) and !empty($contactdata["fax"])}
            {$og_fax = $contactdata["fax"]}
        {/if}

        {if isset($og) and isset($og['fax'])}
            {$og_fax = $og['fax']}
        {/if}

        {addMeta property="og:fax" content=$og_fax}
    {/if}


    {*** Open Graph phone ***}
    {if isset($settings.og_phone) and $settings.og_phone}
        {$og_phone = ""}
        {if isset($contactdata["phone"]) and !empty($contactdata["phone"])}
            {$og_phone = $contactdata["phone"]}
        {/if}

        {if isset($og) and isset($og['phone'])}
            {$og_phone = $og['phone']}
        {/if}

        {addMeta property="og:phone" content=$og_phone}
    {/if}


    {*** Open Graph email ***}
    {if isset($settings.og_email) and $settings.og_email}
        {$og_phone = ""}
        {if isset($contactdata["email"]) and !empty($contactdata["email"])}
            {$og_phone = $contactdata["email"]}
        {/if}

        {if isset($og) and isset($og['email'])}
            {$og_phone = $og['email']}
        {/if}

        {addMeta property="og:email" content=$og_phone}
    {/if}


    {*** Open Graph latitude ***}
    {if isset($settings.og_latitude) and $settings.og_latitude}
        {$og_latitude = $settings.og_latitude}

        {if isset($og) and isset($og['latitude'])}
            {$og_latitude = $og["latitude"]}
        {/if}

        {addMeta property="og:latitude" content=$og_latitude}
    {/if}


    {*** Open Graph og_longitude ***}
    {if isset($settings.og_longitude) and $settings.og_longitude}
        {$og_longitude = $settings.og_longitude}

        {if isset($og) and isset($og['longitude'])}
            {$og_longitude = $og["longitude"]}
        {/if}

        {addMeta property="og:longitude" content=$og_longitude}
    {/if}
{/if}

{*** fb:appid ***}
{if isset($settings.fb_appid) and !empty($setting.fb_appid)}
    {addMeta property="fb:app_id" content=$settings.fb_appid}
{/if}
