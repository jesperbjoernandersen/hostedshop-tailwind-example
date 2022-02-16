{*

# Description
Trustpilot widget. A widget is a small helper template, with some functionality.


## Date last modified
2018-11-16


## Primary variables
+ $user                                                             - Array with user information


## Partials (templates)
No extra templates required for this template

*}
<script type="application/json+trustpilot">
{
	"recipientEmail": "{if isset($trustpilot['email'])}{$trustpilot['email']}{else}''{/if}",
	"recipientName": "{if isset($trustpilot['name'])}{$trustpilot['name']}{else}''{/if}",
	"referenceId": "{if isset($trustpilot['orderId'])}{$trustpilot['orderId']}{else}''{/if}"
}
</script>