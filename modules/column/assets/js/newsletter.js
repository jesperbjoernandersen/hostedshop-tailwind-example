( function( $ ) {

  var NewsletterInit = function( $el ) {

    var spamCheck = $el.find( "[data-js=m-newsletter-spam-check]" );

    if ( spamCheck.length ) {
      spamCheck.css( 'display', 'none' );

      $el.one( "click", function() {
            spamCheck.slideDown();
        }
      );
    }
  }

  $( function() {
    var newsletterBox = $( "[data-js=w-newsletter-signup]" );
    if ( newsletterBox.length ) {
      $.each( newsletterBox, function() {
        new NewsletterInit( $( this ) );
      } );
    }
  } );

} )( jQuery );
