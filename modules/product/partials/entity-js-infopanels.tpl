{*

# Description
Template partial for variants and packet-products. A JS assets template. Part of the Product page type.
Consisting mostly of a [jsRender Template](http://www.jsviews.com/#jsrender).


## Date last modified
2020-10-05


## Resource
+ [jsRender Template](http://www.jsviews.com/#jsrender)


## Primary variables
 No variables for this template


## Partials (templates)
No extra templates required for this template

*}

{literal}
<script id="entity-js-infopanel" type="text/x-jsrender">
    {{if (selected.ItemNumber && ~settings("shop_product_number")) || (selected.Weight && selected.Weight != 0 && ~settings("shop_product_weight")) || ~showPrice }}
    <div class="panel panel-warning panel-rounded">
        <div class="panel-body">
            {{if ~showPrice }}
                {{if product.CallForPrice}}
                    <span class="is-block">{{:~text("PRODUCT_CATALOG_CALL_FOR_PRICE")}}</span>
                {{else}}
                    <div class="product-priceLines">
                    {{for selected.Prices  tmpl="#entity-js-priceLines" /}}
                    </div>
                {{/if}}

                {{if ~settings("shop_product_tax_after_price")}}
                <span class="is-block priceVatText">
                    {{if ~productVatText}}
                        {{:~productVatText(selected.Price.PriceMinWithVat, selected.Price.PriceMinWithoutVat)}}
                    {{else ~hasVat}}
                        {{:~text("PRODUCT_CATALOG_PRODUCT_PRICE_TAX")}}
                    {{else}}
                        {{:~text("PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO")}}
                    {{/if}}
                </span>
                {{/if}}

                {{if product.GuidelinePrice > 0}}
                <p>
                    <span class="priceSuggested">{{:~text("PRODUCT_CATALOG_PRICE_LIST")}} {{currency_format:product.GuidelinePrice}}</span>
                    {{if ~settings("shop_product_tax_after_price") || (~hasVat == false && ~settings("shop_product_lineprice_vat"))}}
                        <span class="priceVatText">
                            {{if ~hasVat && (!~settings("vat_label_advanced") || selected.Price.PriceMinWithVat > selected.Price.PriceMinWithoutVat) || ~settings("shop_product_lineprice_vat")}}
                                {{:~text("PRODUCT_CATALOG_PRODUCT_PRICE_TAX")}}
                            {{else}}
                                {{:~text("PRODUCT_CATALOG_PRODUCT_PRICE_TAX_NO")}}
                            {{/if}}
                        </span>
                    {{/if}}
                </p>
                {{/if}}

                <p class="product-priceOptions option">
                {{for selected.PaymentOptions tmpl="#entity-js-priceOptions" /}}
                </p>
            {{/if}}

            {{if selected.ItemNumber && ~settings("shop_product_number") tmpl="#entity-js-itemnumber" /}}

            {{if selected.Weight && selected.Weight != 0 && ~settings("shop_product_weight") tmpl="#entity-js-weight" /}}
        </div>
    </div>
    {{/if}}

    {{if ~settings("shop_product_delivery_time") tmpl="#entity-js-stock" /}}
</script>
{/literal}

{*** PriceLines ***}
{literal}
<script id="entity-js-priceLines" type="text/x-jsrender">
{{if #index === 0 }}<span class="h5">{{/if}}
{{if #index === 1 }}<p>{{/if}}
    <span class="selected-priceLine is-block">
        {{if ~root.selected.Prices.length > 1 || Amount > 1}}
        <span class="priceFor">{{:~text("PRODUCT_CATALOG_PRICE_FOR")}} {{:Amount}} {{:~root.selected.UnitTitle}}</span>
        {{/if}}

        {{if PriceMin !== PriceMax }}
            <span class="priceFrom">{{:~text("PRODUCT_CATALOG_PRICE_FROM")}}</span>
        {{/if}}

        <span class="price">{{currency_format:PriceMin}}</span>

        {{if PriceMin < FullPriceMin }}
            - <s class="priceBeforeDiscount">{{currency_format:FullPriceMin}}</s>
        {{/if}}
    </span>
{{if #index === 0 }}</span>{{/if}}
{{if #index === ~root.selected.Prices.length-1 }}</p>{{/if}}
</script>
{/literal}

{*** PriceOptions ***}
{literal}
<script id="entity-js-priceOptions" type="text/x-jsrender">
    <img class="clearfix" style="height:30px;width:auto;vertical-align:middle;margin:0;" alt="{{:title}}" title="{{:title}}" src="{{:~staticdomain}}{{:logo}}">
    <span class="optionPriceFormat">{{:priceFormat}}.</span>
    {{if type === "KlarnaSW"}}<span class="klarnaTerms"></span>{{/if}}
</script>
{/literal}

{*** ItemNumber ***}
{literal}
<script id="entity-js-itemnumber" type="text/x-jsrender">
    <p>
        <span class="product-itemNumber selected-itemNumber">
            <strong class="product-itemNumber-text selected-itemNumber-text">{{:~text("PRODUCT_CATALOG_PRODUCT_NUMBER")}}</strong>
            <span class="product-itemNumber-value selected-itemNumber-value">{{:selected.ItemNumber}}</span>
        </span>
    </p>
</script>
{/literal}

{*** Weight ***}
{literal}
<script id="entity-js-weight" type="text/x-jsrender">
    <p>
        <strong class="product-weight-text selected-weight-text">{{:~text("PRODUCT_CATALOG_PRODUCT_WEIGHT")}}:</strong>
        <span class="product-weight selected-weight">
            <span class="product-weight-value selected-weight-value">
                {{if ~version && ~version >= 20191219}}{{number_format:selected.Weight}}{{else}}{{:selected.Weight}}{{/if}}
            </span>
            <span class="product-weight-unitTitle selected-weight-unitTitle">{{:~text("PRODUCT_CATALOG_PRODUCT_WEIGHT_UNIT")}}</span>
        </span>
    </p>
</script>
{/literal}

{*** Stock and deliverytime ***}
{literal}
<script id="entity-js-stock" type="text/x-jsrender">
    <div class="panel panel-{{if (selected.isPacket && selected.InStock) || (!selected.isPacket && selected.Stock >= selected.MinAmount) }}success{{else}}danger{{/if}} panel-rounded">
        <div class="panel-body">
            <strong>{{:~text("CHECKOUT_STEP_TWO_STOCK_STATUS")}}: </strong>
            {{if (!selected.isPacket && selected.Stock >= selected.MinAmount)}}
                {{if ~settings("shop_product_delivery_time") === "texticon" }}<span class="product-stock-icon selected-stock-icon onStock"><i class="fa fa-fw fa-check"></i></span> {{/if}}
                {{if selected.DeliveryTimeId == 0}}<span class="product-stock-value selected-stock-value">{{:selected.Stock}}</span> {{/if}}
            {{else}}
                {{if ~settings("shop_product_delivery_time") === "texticon" }}<span class="product-stock-icon selected-stock-icon noStock"><i class="fa fa-fw fa-clock-o"></i> {{/if}}
            {{/if}}
            <span class="product-stock-text selected-stock-text">{{:selected.DeliveryTimeText}}</span>
        </div>
    </div>
</script>
{/literal}

{*** Packet selected ***}
{literal}
<script id="entity-packet-selected" type="text/x-jsrender">
    <div class="panel panel-success panel-rounded">
        <div class="panel-body">
            <strong><span class="m-product-packet-selected-text"><i class="fa fa-check"></i> {{:~text('CHOOSE_PACKET')}}</span></strong>
        </div>
    </div>
</script>
{/literal}
