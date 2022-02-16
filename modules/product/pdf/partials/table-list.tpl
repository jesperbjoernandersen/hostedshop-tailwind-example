{*

# Description
Prints out a table grid from recived data

## Date last modified
2021-08-24

*}

{* use cell count of first row if theres nothing specified *}
{$cellsPerRow = $cellsPerRow|default:count($list[0].cells)}

{$listCount = count($list)}

{if $listCount > 0}
    {strip}
        {function row cells=false isHead=false}
            <tr {if $isHead}class="head"{/if}>
            {foreach $cells as $cell}
                <td class="cell">
                    {$cell}
                </td>
            {/foreach}
            </tr>
        {/function}

        <table class="table-list {$name}">
            {foreach $list as $listRow}
                {if $listRow@first}
                    <tbody>
                {/if}
                {row cells=$listRow.cells isHead=$listRow.isHead}
                {if $listRow@last}
                    </tbody>
                {/if}
            {/foreach}
        </table>
    {/strip}
{/if}