$.gdgr = $.gdgr || {};

// firebelly products
$.gdgr.products = (function() {

  function _init() {
    // ajax cart actions
    $('#wrapper').on('ajax:before ajax:success', '#product-form, #cart-form', function(){
      $('#cart, #product-form .submit').toggleClass('loading');
    })
      .on('ajax:success', '#product-form, #cart-form, #cart a.delete', function(evt, data, status, xhr){
        $.gdgr.main.showSidebar();
        $('#cart').fadeOut(function() {
          $('#cart').html(xhr.responseText).fadeIn();
        });
      })
      .on('click', '#cart a.delete', function() {
        $(this).parents('tr:first').fadeOut();
      })
      .on('ajax:failure', '#product-form, #cart-form, a.delete', function(evt, data, status, xhr){
        alert('There was an error: '+xhr.responseText);
      });

    // paypal is freaking slow, give the user some instant feedback
    $('#paypal-form .submit').on('click', function() {
      $(this).text('Please Wait...');
    });

    // no submit button, trigger saves on return
    $('#cart-form .quantity input').on('keydown', function(e) {
      if (e.keyCode==13) $('#cart-form').submit();
    }).on('focus', function() {
      $('#cart .cart').addClass('editing');
      $('#cart .edit-cart').text('Update');
    });

  };

  return {
    init: _init
  };

})();

$(window).ready(function(){
  $.gdgr.products.init();
});
