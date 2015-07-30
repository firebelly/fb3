$.gdgr = $.gdgr || {};

// firebellydesign products
$.gdgr.products = (function() {

  var is_animating = false;
  var scroll_speed = 500;
  var numSlides = 0;
  var slideAt = 0;
  var slideWidth = 0;
  var slideWrap;

  function _init() {
    // build SEO-useless overlay links
    $('.product').each(function() {
      $(this).find('a:first').clone().empty().addClass('overlay').prependTo($(this).find('article'));
    });

    // clicking on dimmed product triggers all to open back up
    $('.product a').click(function(e) {
      if ($(this).parents('li.product:first').hasClass('dim')) {
        $('#filters .show-all a').trigger('click');
        return false;
      }
    });

    // single page?
    if ($('.product.single').length>0) {
      // clicking on options with price override updates price text
      var priceText = $('.product.single h2.price');
      priceText.data('original-price', priceText.text());
      $('.product.single .options input').change(function() {
        _checkPriceOverride(this);
      });

      // check for options
      $('#product-form').submit(function(e) {
        if ($('.product.single .options input').length>0 && $('.product.single .options input:checked').length==0) {
          alert('Please select an option for this product.');
          return false;
        } else {
          return true;
        }
      });
    }

    // ajax cart actions
    $('#product-form, #cart-form').on("ajax:before ajax:success", function(){
      $('#cart, #product-form .submit').toggleClass('loading');
    });
    $('#product-form, #cart-form, #cart a.delete').on("ajax:success", function(evt, data, status, xhr){
      $('#cart').html(xhr.responseText);
    });
    $('#cart a.delete').on('click', function() {
      $(this).parents('tr:first').fadeOut();
    });
    $('#product-form, #cart-form, a.delete').on("ajax:failure", function(evt, data, status, xhr){
      alert('There was an error: '+xhr.responseText);
    });

    // faux edit/update link for cart
    $('#cart .edit-cart').on('click', function() {
      if ($(this).text()=='Edit') {
        $('#cart .cart').addClass('editing');
        $(this).text('Update');
      } else {
        $('#cart-form').submit();
      }
    });

    // paypal is freaking slow, give the user some instant feedback
    $('#paypal-form .submit').on('click', function() {
      $('#cart').addClass('loading');
      $(this).text('Please Wait...');
    });


    // no submit button, trigger saves on return
    $('#cart-form .quantity input').on('keydown', function(e) {
      if (e.keyCode==13) $('#cart-form').submit();
    }).on('focus', function() {
      $('#cart .cart').addClass('editing');
      $('#cart .edit-cart').text('Update');
    });

    // init resizing code -- homepage or single
    // _resize();
    _initSlider();

  }; // END _init()

  function _initSlider() {
    numSlides = $('ul.product-images li').length;
    if (numSlides>1) {
      slideWidth = $('.slider').width();
      $('<a class="next" />').appendTo('.slider').click(function(e) { e.preventDefault(); _nextSlide(); return false; });
      $('<a class="prev" />').appendTo('.slider').click(function(e) { e.preventDefault(); _prevSlide(); return false; });
      _slideTo(0);
    }
  }
  function _prevSlide() {
    _slideTo(--slideAt);
  }
  function _nextSlide() {
    _slideTo(++slideAt);
  }
  function _slideTo(to) {
    if (typeof to != 'undefined') slideAt = to;

    if (slideAt < 0) slideAt = numSlides-1;
    if (slideAt > (numSlides-1)) slideAt = 0;
    is_animating = true;
    $('ul.product-images').animate({'marginLeft':-slideAt*slideWidth}, function() {
      is_animating = false;
    });
  }    
  function _resetSlider() {
    $('ul.product-images').stop().css('marginLeft', 0);
    slideAt = 0;
  }

  function _checkPriceOverride(el) {
    var priceText = $('.product.single h2.price');
    var priceOverride = $(el).parent().text().match(/\$\d+\.\d+/);
    if (priceOverride) priceText.text('Price: '+priceOverride);
    else priceText.text(priceText.data('original-price'));
  }

  function _resize() {
    // store homepage 
    if ($('body').hasClass('index')) {
      if ($(window).width() >= 730) {
        var pageWidth = ($(window).width() > 1382) ? $('#wrapper').width() : 730;
        
        // make each first thumb in row clear left
        $('.products .product').removeClass('clear-left').removeClass('tail');
        var perRow = Math.floor(pageWidth / $('.product').outerWidth(true));
        $('.products .product:nth-child(' + perRow + 'n+1)').addClass('clear-left');
        $('.products .product:nth-child(' + perRow + 'n)').addClass('tail');
        
        // set width of headers/footers to match
        $('#page, footer').width((perRow * $('.products .product').outerWidth(true)));
      } else {
        // remove width declaration for mobile
        $('#page, footer').width('');
      }
    } else {
      // single product
      $('.product-images img').each(function() {
        var uid = $(this).attr('data-uid');
        if ($(window).width() >= 768) {
          var endpoint = "/thumbs/" + encodeURIComponent($(this).data('desktop_geometry')) + "?uid=" + uid;
        } else {
          var endpoint = "/thumbs/290x?uid=" + uid;
        }
        if ($(this).attr('src') != endpoint) {
          var $this = $(this);
          $this.attr({ 'src': endpoint }).addClass('loading hidden').imagesLoaded(function() {
            $this.removeClass('loading hidden');
          });
        }
      });
      // handheld goes back to 0
      if ($(window).width() < 768) {
        _resetSlider();
      }
    }
  }

  return {
    init: function() {
      _init();
    },
    resize: function() {
      // _resize();
    }
  };

})();

$(window).ready(function(){
  $.gdgr.products.init();
});

$(window).resize(function(){
  // $.gdgr.products.resize();
});
