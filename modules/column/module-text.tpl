{*

# Description
Template for page content in a column box


## Date last modified
2014-08-01


## Primary variables
+ $pager                                                    - Instance of the pageController
+ $chosenPage                                               - Entity of pageController (page to be displayed in box)


## Partials (templates)
No extra templates required for this template

*}


{controller assign=pager type=page}
{entity controller=$pager assign=chosenPage id=$box->PageId}
{$pageHeadline = $pager->getTranslation($box->PageId, 'headline')}

{if $chosenPage}
    <div class="panel panel-border column-box b-text b-{$box->PageId}">
        {$pageHeadlineTest = trim($pageHeadline)}
        {if !empty($pageHeadlineTest)}
        <div class="panel-heading b-text-header b-header">
            <span class="h5">{$pageHeadline}</span>
        </div>
        {/if}
        <div class="panel-body ck-content">
            {$pager->getText($box->PageId)}
        </div>
    </div>
{/if}
