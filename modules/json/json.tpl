{$file = 'modules/json/'|cat:$request.endpoint|cat:'.tpl'}
{$found = {locateFile file=$file}}
{if $found}
{include file=$file}
{else}
{$output = [
    'error' => 404,
    'file'  => $file
]}
{$output|jsonify}
{/if}
