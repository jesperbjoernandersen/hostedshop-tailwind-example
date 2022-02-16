{*

# Description
PDF Render: prints out a version of product-entity that is compatible with print. 
This template is meant for PDF-conversion by using browsers print functionality

## Date last modified
2021-08-24

*}
{strip}
<!DOCTYPE html>
<html lang="{$general.languageIso639}">
    <head>
        <meta charset="UTF-8">

        {* Prevent title for the fallback url print *}
        <title>&nbsp;</title>

        {* CK editor 5 Support*}
        <link rel="stylesheet" href="{$template.cdn}/_design/smartytemplates/store/template001/source/libs/ckeditor5/latest/grid.css">
        <link rel="stylesheet" href="{$template.cdn}/_design/smartytemplates/store/template001/source/libs/ckeditor5/latest/content.css">
        <link rel="stylesheet" href="{$template.cdn}/_design/smartytemplates/store/template001/source/libs/ckeditor5/latest/image.css">
        <link rel="stylesheet" href="{$template.cdn}/_design/smartytemplates/store/template001/source/libs/ckeditor5/latest/table.css">

        <style>
            {*** General styling of tags ***}
            * {
                box-sizing: border-box;
            }
            html, body {
                background: black;
                font-size: 12px;
                font-family: {$template.settings.EMAIL_FONT_FAMILY_BASE};
                
                {* Make it possible print background colors *}
                -webkit-print-color-adjust: exact !important;
            }
            h1 {
                margin: 0;
            }
            h1, h2, h3, h4, h5, h6 {
                font-weight: 400;
                font-family: {$template.settings.EMAIL_FONT_FAMILY_HEADLINE};
            }
            h2 {
                margin-top: 20px;
                margin-bottom: 0;
            }
            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 40px;
            }
            hr {
                border: 0;
                background: transparent;
                border-bottom: 2px solid #eee;
                margin-bottom: 20px;
            }
            s {
                color: #777;
            }
            ul {
                list-style: none;
            }
            .additionals-description ul {
                list-style-type: disc;
            }

            {*** General styling of helper classes ***}
            .contact-data-list {
                display: flex;
                justify-content: space-around;
                flex-wrap: wrap;
            }
            .contact-data-list > * {
                min-width: 100px;
                margin-bottom: 10px;
            }
            @media screen {
                .paper {
                    padding: 10mm;
                }
            }
            .paper {
                margin: 0 auto;
                background: white;
                width: 210mm;
                min-height: 275mm;
                display: flex;
                flex-direction: column;
            }
            .flex-row {
                display: flex;
                align-items: center;
            }
            .title-cell {
                padding: 0 5px;
            }
            .title-cell .row > * {
                margin-right: 5px;
            }
            .clock-icon {
                fill: red;
            }

            {*** Partials: Table list ***}
            .table-list {
                margin: 0 0 10px 0;
                padding: 0;
                width: 100%;
            }
            .table-list .head {
                font-weight: 600;
            }
            .table-list ul {
                padding-left: 10px;
            }
            .table-list p {
                margin: 0;
            }
            .table-list p:not(:first-child) {
                margin: 5px 0 0 0;
            }
            .table-list .cell {
                padding: 10px 5px;
            }
            .table-list .head:first-child .cell {
                padding-top: 0;
            }
            .table-list tr:not(:nth-child(even)):not(.head) {
                background-color: #eeeeee;
            }
            .table-list tr:nth-child(even):not(.head) {
                background-color: #f5f5f5;
            }
            .extra-buy-table tr:not(.head) td:last-child,
            .variant-table tr:not(.head) td:last-child {
                text-align: right;
            }
        </style>
    </head>
    <body>

        <div class="paper">
            <header>
                {include file="modules/product/pdf/partials/top-logo.tpl"}
            </header>
            {include file="modules/product/pdf/product.tpl"}
        </div>
        
        <script>
            window.print();
            
            // Close tab if print is done or canceled
            if ( !isIE() ) {
                window.addEventListener("afterprint", function() {  
                    window.close();
                });
            }
            function isIE() {
                var ua = navigator.userAgent;
                return ua.indexOf('MSIE') > -1 || ua.indexOf('Trident') > -1;
            }
        </script>
    </body>
</html>
{/strip}