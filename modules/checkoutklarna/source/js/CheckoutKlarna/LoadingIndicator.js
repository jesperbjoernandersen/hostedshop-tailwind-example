const htmlSnippet = `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="margin: auto;display: block;shape-rendering: auto;position: absolute;left: 0;right: 0;top: 0;bottom: 0;" width="72px" height="24px" viewBox="0 -6 100 12" preserveAspectRatio="xMidYMid"><g transform="translate(25 0)"><circle cx="0" cy="0" r="6" fill="#0a0a0a"><animateTransform attributeName="transform" type="scale" begin="-0.3333333333333333s" calcMode="spline" keySplines="0.3 0 0.7 1;0.3 0 0.7 1" values="0;1;0" keyTimes="0;0.5;1" dur="1s" repeatCount="indefinite"></animateTransform></circle></g><g transform="translate(50 0)"><circle cx="0" cy="0" r="6" fill="#0a0a0a"><animateTransform attributeName="transform" type="scale" begin="-0.16666666666666666s" calcMode="spline" keySplines="0.3 0 0.7 1;0.3 0 0.7 1" values="0;1;0" keyTimes="0;0.5;1" dur="1s" repeatCount="indefinite"></animateTransform></circle></g><g transform="translate(75 0)"><circle cx="0" cy="0" r="6" fill="#0a0a0a"><animateTransform attributeName="transform" type="scale" begin="0s" calcMode="spline" keySplines="0.3 0 0.7 1;0.3 0 0.7 1" values="0;1;0" keyTimes="0;0.5;1" dur="1s" repeatCount="indefinite"></animateTransform></circle></g></svg>`;

function getLoader(style = '', snippet = htmlSnippet) {
    return $("<div style='"+ style +"' class='w-checkout-loader'><div class='text-center w-checkout-loader__wrap'>" + snippet + "</div></div>");
}

export {
    htmlSnippet as loader,
    getLoader
}