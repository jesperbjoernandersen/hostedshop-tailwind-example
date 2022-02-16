{*

# Description
Template partial for the product files. Part of the Product page type.


## Date last modified
2014-08-01


## Primary variables
+ $productController                                                    - Instance of productController
+ $product                                                              - Entity of productController (the current product)
+ $productPdfs                                                          - Entity of fileController with type productPdf
+ $text                                                                 - Global scope variable containing translations


## Partials (templates)
No extra templates required for this template

*}


{*** Collection entity of the files controller ***}
{collection assign=productPdfs controller=files type=productPdf id=$product->Id}

<div class="responsive-table-wrap m-product-files">
    <table class="table-h-striped">
        <thead class="m-product-files-heading">
            <tr>
                <th><span class="h6 m-product-files-heading-title">{$text.MEDIA_ARCHIVE_DOCUMENT_TITLE}</span></th>
                <th><span class="h6 m-product-files-heading-type">{$text.MEDIA_ARCHIVE_DOCUMENT_TYPE}</span></th>
                <th><span class="h6 m-product-files-heading-size">{$text.MEDIA_ARCHIVE_DOCUMENT_SIZE}</span></th>
                <th><span class="h6 m-product-files-heading-download">{$text.DOWNLOAD}</span></th>
            </tr>
        </thead>
        <tbody>
        {*** Iterate over the productpdfs to display them ***}
        {foreach $productPdfs->getData() as $productPdf}
        <tr>
            <td><a href="{$productPdf->getRelativeFile()}" target="_blank" rel="noopener"><span class="m-product-files-filesname">{$productPdf->Filename}</span></a></td>
            <td><span class="m-product-files-type">PDF</span></td>
            <td><span class="m-product-files-size">{$productPdf->getSize()|filesize}</span></td>
            <td><a href="{$productPdf->getRelativeFile()}" target="_blank" rel="noopener"><span class="m-product-files-download">{$text.DOWNLOAD}</span></a></td>
        </tr>
        {/foreach}
        </tbody>
    </table>
</div>{* END: table *}
