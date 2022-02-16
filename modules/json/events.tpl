{$output = []}

{if $request.method eq 'GET'}
	
	{controller assign=controller type=event}

	{if $request.verb eq 'date'}

		{$date = explode('-', $request.args.0)}

		{if $date|count eq 2}
			{collection assign=events controller=$controller year=$date[0] month=$date[1]}
		{else}
			{$output = 'Wrong month parameter'}
		{/if}

	{elseif $request.verb eq 'from'}

		{collection assign=events controller=$controller dateFrom=$request.args.0|urldecode}

	{elseif $request.verb eq 'next'}

		{$pageSize = 3}
		{if !empty($request.input.limit)}
			{$pageSize = {$request.input.limit}}
		{/if}

		{collection assign=events controller=$controller dateFrom=date('Y-m-d 00:00:00') pageSize=$pageSize}

	{else}

		{$output = 'Unrecognized verb: '|cat:$request.verb}

	{/if}

	{if !empty($events)}

		{foreach $events->getData() as $event}
			{$event['Handle'] = PageController::link($event->PageId)|cat:$event->Handle|cat:'/'}

			{$output[] = $event}
		{/foreach}
	{/if}

{/if}

{$output|jsonify}