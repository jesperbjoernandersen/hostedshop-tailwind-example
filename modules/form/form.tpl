{*

# Description
Controller for the Contact Page page type.


## Date last modified
2020-08-28


## Primary variables
+ $formController                                                       - Instance of FormController
+ $formEntity                                                           - An entity of FormController
+ $formElementController                                                - Instance of FormElementController
+ $formElements                                                         - A collection of FormElementController
+ $formElement                                                          - $formElement represents an entity in the collection $formElements and is used in the loop
+ $page                                                                 - Global scope variable containing all information about the page type


## Partials (templates)
+ "/modules/widgets/meta/opengraph.tpl"                                 - Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}

{*** Initiate form controller ***}
{controller assign=formController type=form}

{*** Formular entity ***}
{entity assign=formEntity controller=$formController}

{*** Initiate formElement controller ***}
{controller assign=formElementController type=formElement}

{*** Initiate formElement collection ***}
{collection assign=formElements controller=$formElementController formId=$formEntity->Id}

{*** Calculate the actual size of the collection ***}
{$collectionSize = $formElements->getActualSize()}

{* Start of module *}
<div class="modules m-form">
    <article class="m-form-article">
        <header class="m-form-header page-title">
            <h1 class="m-form-headline">{$page.headline}</h1>
        </header>

    	{if isset($smarty.get.a)}
            {if $formController->getConfirmation($formEntity->Id)}
                {$formController->getConfirmation($formEntity->Id)|unescape:"html"}
            {else}
                <p>{$text.FORMMODULE_MAIL_TITLE_VISITOR}.</p>
            {/if}
    	{else}
            {if $collectionSize gt 0}
            	<form id="m-form" method="post" action="/actions/form/send" enctype="multipart/form-data">
                    {csrf type="input"}
            		<input type="hidden" name="pageId" value="{$page.id}">

                    <div class="panel panel-border">
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-s-4 col-m-12 col-l-12 col-xl-24">
                        			{foreach $formElements->getData() as $formElement}
                        				{* Include view for form entity *}
                        				{include file='modules/form/form-entity.tpl' formElementController=$formElementController formElement=$formElement}
                        			{/foreach}

                                    {* Spam check *}
                                    {if $settings.spam_check}
                                    <div class="m-form-spam-check">
                                        <hr>
                                        {include file="modules/widgets/recaptcha/recaptcha.tpl"}
                                    </div>
                                    {/if}

                                    {if $settings.privacy_policy_form_module}
                                    <div class="m-checkout-consent">
                                        <div class="row">
                                            <div class="col-s-4 col-m-6 col-l-6 col-xl-12">
                                                {include file="modules/widgets/consent/consent.tpl"}
                                            </div>
                                        </div>
                                    </div>
                                    {/if}
                                </div>
                            </div>
                        </div>

                        <div class="panel-footer">
                            {* Submit button *}
                            <button name="submit" type="submit" class="{if !empty($modalCallToActionStyle) AND $modalCallToActionStyle eq "primary"}button-primary{else}button{/if} small">
                                {if $formController->getTranslation($formEntity->Id, "form-element", "button")}
                                    {$formController->getTranslation($formEntity->Id, "form-element", "button")}
                                {else}
                                    {$text.SEND}
                                {/if}
                            </button>
                        </div>
                    </div>
            	</form> {* end: Form *}
                <div class="m-contact-description-bottom description trailing">
                    <p class="m-contact-description-bottom consent-description">{if $general.isShop}{$text.FORM_MODULE_CONSENT_DESCRIPTION_SHOP}{else}{$text.FORM_MODULE_CONSENT_DESCRIPTION_CMS}{/if}</p>
                </div>
            {else}
                <div class="panel panel-warning">
                    <div class="panel-body">
                       <span>{$text.NO_DATA}</span>
                    </div>
                </div>
            {/if}
    	{/if}
    </article>
</div>{* end: .m-formular *}

{$opengraph_title = $page.title}
{if isset($smarty.get.a)}
    {$opengraph_description = $formController->getConfirmation($formEntity->Id)|unescape:"html"|strip_tags|truncate:160}
{/if}

{*** Global widgets ***}
{include file="modules/widgets/meta/opengraph.tpl"
    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
}
