{*

# Description
Controller for the Pole page type


## Date last modified
2020-08-28


## Primary variables
+ $pollController 											- Instance of pollController
+ $pollPage 												- Entity of pollController (controller for the single poll)
+ $pollData 												- Poll data for the selected poll
+ $userVoted   												- Boolean telling if current user already voted
+ $voteCountTotal 											- Variable with the total vote count
+ $text                                                     - Global scope variable containing translations


## Partials (templates)
+ "/modules/widgets/meta/opengraph.tpl"                     - Social meta data

*}


{*** Global widgets defaults ***}
{$opengraph_image = null}
{$opengraph_title = null}
{$opengraph_description = null}


{* Fetch poll page data *}
{controller type=poll assign=pollController}
{entity controller=$pollController assign=pollPage}


<div class="modules m-poll">
	<article class="m-poll-article">
		<header class="m-poll-header page-title">
			<h1 class="m-poll-headline">{$page.headline}</h1>
		</header>

		{if $pollPage}
			{$pollData = $pollController->getPollData($pollPage->Id)}
			{$userVoted = $pollController->isVoteCast($pollPage->Id, {$user->Id})}
			{$voteCountTotal = $pollController->voteCount($pollPage->Id)}
			{$activePoll = true}

			{if $activePoll}
				{$opengraph_title = "{$page.title} - {$pollData.title}"}
				{$opengraph_description = $pollData.text}
			{else}
				{$opengraph_description = $text.POLL_ACTIVE_NONE}
			{/if}

			<form id="m-poll" method="post" action="/actions/poll/vote">
				{csrf type="input"}
				<input type="hidden" name="poll_id" value="{$pollPage->Id}">

				<div class="panel panel-border">
					<div class="panel-body">
						{if $activePoll}
							<div class="panel-heading">
								<span class="m-poll-title h4 is-block">{$pollData.title}</span>
								<span class="m-poll-text">{$pollData.text}</span>
							</div>
						</div>
						<div class="panel-body">

							{if $userVoted}
								<p class="m-poll text-vote"><em>{$text.POLL_VOTE_TEXT}</em></p>
							{/if}

							<p class="m-poll text-question"><strong>{$pollData.question}</strong></p>

							{if isset($pollData.answer1)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer1">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer1" type="radio" name="vote" value="{$pollData.answer1}"></span>
											<label class="form-label input-group-main" for="m-poll-answer1">{$pollData.answer1}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer1 is-block">
										{$voteCount1 = $pollController->voteCount($pollPage->Id, $pollData.answer1)}
										{$pollData.answer1} - {($voteCount1 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer2)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer2">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer2" type="radio" name="vote" value="{$pollData.answer2}"></span>
											<label class="form-label input-group-main" for="m-poll-answer2">{$pollData.answer2}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer2 is-block">
										{$voteCount2 = $pollController->voteCount($pollPage->Id, $pollData.answer2)}
										{$pollData.answer2} - {($voteCount2 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer3)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer3">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer3" type="radio" name="vote" value="{$pollData.answer3}"></span>
											<label class="form-label input-group-main" for="m-poll-answer3">{$pollData.answer3}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer3 is-block">
										{$voteCount3 = $pollController->voteCount($pollPage->Id, $pollData.answer3)}
										{$pollData.answer3} - {($voteCount3 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer4)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer4">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer4" type="radio" name="vote" value="{$pollData.answer4}"></span>
											<label class="form-label input-group-main" for="m-poll-answer4">{$pollData.answer4}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer4 is-block">
										{$voteCount4 = $pollController->voteCount($pollPage->Id, $pollData.answer4)}
										{$pollData.answer4} - {($voteCount4 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer5)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer5">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer5" type="radio" name="vote" value="{$pollData.answer5}"></span>
											<label class="form-label input-group-main" for="m-poll-answer5">{$pollData.answer5}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer5 is-block">
										{$voteCount5 = $pollController->voteCount($pollPage->Id, $pollData.answer5)}
										{$pollData.answer5} - {($voteCount5 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer6)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer6">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer6" type="radio" name="vote" value="{$pollData.answer6}"></span>
											<label class="form-label input-group-main" for="m-poll-answer6">{$pollData.answer6}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer6 is-block">
										{$voteCount6 = $pollController->voteCount($pollPage->Id, $pollData.answer6)}
										{$pollData.answer6} - {($voteCount6 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer7)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer7">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer7" type="radio" name="vote" value="{$pollData.answer7}"></span>
											<label class="form-label input-group-main" for="m-poll-answer7">{$pollData.answer7}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer7 is-block">
										{$voteCount7 = $pollController->voteCount($pollPage->Id, $pollData.answer7)}
										{$pollData.answer7} - {($voteCount7 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer8)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer8">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer8" type="radio" name="vote" value="{$pollData.answer8}"></span>
											<label class="form-label input-group-main" for="m-poll-answer8">{$pollData.answer8}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer8 is-block">
										{$voteCount8 = $pollController->voteCount($pollPage->Id, $pollData.answer8)}
										{$pollData.answer8} - {($voteCount8 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer9)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer9">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer9" type="radio" name="vote" value="{$pollData.answer9}"></span>
											<label class="form-label input-group-main" for="m-poll-answer9">{$pollData.answer9}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer9 is-block">
										{$voteCount9 = $pollController->voteCount($pollPage->Id, $pollData.answer9)}
										{$pollData.answer9} - {($voteCount9 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
							{if isset($pollData.answer10)}
								{if !$userVoted}
									<fieldset class="form-group m-poll-answer10">
										<div class="input-group">
											<span class="input-group-addon"><input id="m-poll-answer10" type="radio" name="vote" value="{$pollData.answer10}"></span>
											<label class="form-label input-group-main" for="m-poll-answer10">{$pollData.answer10}</label>
										</div>
									</fieldset>
								{else}
									<span class="m-poll-answer10 is-block">
										{$voteCount10 = $pollController->voteCount($pollPage->Id, $pollData.answer10)}
										{$pollData.answer10} - {($voteCount10 / $voteCountTotal * 100)|round:0} %
									</span>
								{/if}
							{/if}
						{else}
							<p class="m-poll no-data">{$text.POLL_ACTIVE_NONE}</p>
						{/if}

						{if !$userVoted && $activePoll}
					        <div class="panel-footer">
					            <button class="form-submit {if !empty($modalCallToActionStyle) AND $modalCallToActionStyle eq "primary"}button-primary{else}button{/if} small" type="submit">{$text.SEND}</button>
					        </div>
				        {/if}
					</div>
				</div>
			</form>

			{*** Global widgets ***}
			{include file="modules/widgets/meta/meta.tpl" prev=$prev next=$next}
			{include file="modules/widgets/meta/opengraph.tpl"
			    og=["title" => $opengraph_title, "description" => $opengraph_description, "image" => $opengraph_image]
			}

		{else}
	        <div class="panel panel-warning">
	            <div class="panel-body">
	               <span>{$text.POLL_ACTIVE_NONE}</span>
	            </div>
	        </div>
		{/if}
	</article>
</div>
