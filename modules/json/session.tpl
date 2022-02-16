{$output = []}

{if $request.method eq 'GET'}

	{if !empty($request.fields)}
		{helperSession assign=set mode=set key=$request.verb value=$request.fields}
	{/if}
	
	{helperSession assign=output key=$request.verb}

{elseif $request.method eq 'POST'}
	
	{$output = false}

	{if !empty($request.input)}
		{helperSession assign=output mode=set key=$request.input.key value=$request.input.value}
	{/if}

{elseif $request.method eq 'PUT'}
	
	{$output = false}

	{if !empty($request.file)}
		{assign var=payload value=$request.file|json_decode}
		{helperSession assign=output mode=set key=$payload->key value=$payload->value}
	{/if}

{else}
	
	{$output = 'Only accepts GET and PUT requests'}

{/if}

{$output|jsonify}