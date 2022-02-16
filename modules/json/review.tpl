{$output = []}

{if $request.method eq 'GET'}
	
	{if !empty($request.args.0)}

		{$productId = $request.args.0}

		{controller assign=controller type=productReview}

		{if $request.verb eq 'get'}

			{collection assign=reviews controller=$controller productId=$productId}
			{$output = $reviews->getData()}

		{elseif $request.verb eq 'average'}

			{$output = $controller->getAverageRating($productId)}

		{/if}

	{/if}

{/if}

{$output|jsonify}