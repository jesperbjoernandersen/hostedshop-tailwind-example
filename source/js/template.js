(function($) {

  var menuItems = $(".productmenu > li");
  for (var i = 0; i < menuItems.length; i++) {
      var menuItem = $(menuItems[i]);
      if (menuItem.find("> ul > li > ul").length > 0) {
          menuItem.find("> ul").addClass("megamenu");
          menuItem.addClass("has-megamenu");
      }
  }

  var sidebar = $("#site-sidebar");
  sidebar.find("li.has-dropdown > a > .item-arrow").on("click", function(e) {
    e.preventDefault();
    var li = $(this).parent().parent();
    li.find("> ul").slideToggle();
  });

  if(platform.page.isProduct && platform.page.productId == null) {
    var productGroups = $('.m-productlist-categories').children();
    if(productGroups.first().height() < 2) {
      $(window).trigger('resize');
    }
  }

  var delay = 0;
  var offset = 100;

  document.addEventListener('invalid', function(e){
    if($(e.target).attr('id') != "acceptTerms") {
      $(e.target).addClass("invalid");
      $('html, body').animate({scrollTop: $($(".invalid")[0]).offset().top - offset }, delay);
    }
  }, true);

  document.addEventListener('change', function(e){
    $(e.target).removeClass("invalid")
  }, true);
  
})(jQuery);
