<meta charset="windows-1252">
<title>{$head.title}</title>
{*** Viewport setting for responsive websites ***}
<meta name="viewport" content="width=device-width, initial-scale=1">
{*** Generator tag ***}
<meta name="generator" content="{$general.generator}">
{*** Meta CSRF token ***}
{csrf type="meta"}
{*** Display all meta's added thru addMeta helper ***}
{foreach $head.metas as $meta}
{if !isset($meta->attributes.content) or $meta->attributes.content != null}<meta {foreach $meta->attributes as $k => $v}{$k}="{$v}" {/foreach}/>
{/if}
{/foreach}

{*** Favicon ***}
{if isset($template.settings.IMAGE_FAVICON) and !empty($template.settings.IMAGE_FAVICON)}
	<link rel="shortcut icon" href="{$template.settings.IMAGE_FAVICON}" type="image/x-icon" />
{/if}

<!--[if lte IE 9]>
<script src="{$template.cdn}{locateFile file="assets/js/ie.js"}"></script>
<link href="{$template.cdn}{locateFile file="assets/css/ie.css"}" rel="stylesheet" type="text/css">
<link href="{$template.cdn}{locateFile file="assets/css/template.ie.css"}" rel="stylesheet" type="text/css">
<![endif]-->

{*** Preconnect (dns lookup) to appropriate domains ***}
<link rel="preconnect" href="{$template.cdn}" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>

{*** Loads link assets ***}
<link rel="stylesheet" href="{$template.cdn}/_design/common/libs/font-awesome/latest/css/font-awesome.dirty.min.css">
{foreach $head.links as $link}<link {foreach $link->attributes as $k => $v}{$k}="{$v}" {/foreach}>
{/foreach}

<script>
{strip}
    window.platform = window.platform || {};
    (function (q) {
        var topics = {}, subUid = -1;
        q.subscribe = function(topic, func) {
            if (!topics[topic]) {
                topics[topic] = [];
            }
            var token = (++subUid).toString();
            topics[topic].push({
                token: token,
                func: func
            });
            return token;
        };

        q.publish = function(topic, args) {
            if (!topics[topic]) {
                return false;
            }
            setTimeout(function() {
                var subscribers = topics[topic],
                    len = subscribers ? subscribers.length : 0;

                while (len--) {
                    subscribers[len].func(topic, args);
                }
            }, 0);
            return true;

        };

        q.unsubscribe = function(token) {
            for (var m in topics) {
                if (topics[m]) {
                    for (var i = 0, j = topics[m].length; i < j; i++) {
                        if (topics[m][i].token === token) {
                            topics[m].splice(i, 1);
                            return token;
                        }
                    }
                }
            }
            return false;
        };
    })(window.platform);
{/strip}
</script>

{*** Add Google+ Author and Publisher ***}
{include file="modules/widgets/meta/google.tpl"}

{*** Google integrations ***}
{include file="modules/widgets/integrations/google_analytics.tpl"}
{include file="modules/widgets/integrations/google_tagsmanager.tpl"}

{*** Add JS to head from Design Manager ***}
{includeScript file='partials/head.js.tpl'}

{*** Add CSS to head from Design Manager ***}
{includeStyle file='partials/head.css.tpl' assign='includeCSS'}
{if !empty($includeCSS)}<style type="text/css">{$includeCSS}</style>{/if}
