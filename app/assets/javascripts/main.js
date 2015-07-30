$.gdgr = $.gdgr || {};

// good design for good reason for good namespace
$.gdgr.main = (function() {

  var screenWidth = 0,
      desktop = false,
      handheld = false,
      tablet = false,
      admin_status = false,
      delayed_resize_timer = false;

  function _init() {
    $('#flash').hide().css('visibility','visible').fadeIn();

    // "admin_status" cookie is set by Warden in devise.rb on login
    admin_status = $.cookie('admin_status');
    if (admin_status) {
      $('.edit-bug').addClass('active');
    }

    // search empty? focus it.
    $('#search').submit(function(e) {
      if ($('#query').val() == '') {
        $('#query').focus();
        return false;
      }
      return true;
    });

    // responsive videos
    $('article.news,li.project').fitVids();

    $('#email-form').validate({
      submitHandler: function(f) {
        $.getJSON(
        f.action + "?callback=?",
        $(f).serialize(),
        function (data) {
          if (data.Status === 400) {
            $('#email-form label.status').addClass('error').text("Error: " + data.Message);
          } else { // 200
            $('#email-form label.status').removeClass('error').addClass('success').text("Success: " + data.Message);
            // $(f).find('input.email').val('');
          }
        });
      }
    });

    // Some general Esc handlers
    $(document).keyup(function(e) {
      if (e.keyCode == 27) {
        _hideSidebar();
      }
    });

    _resize();
    _delayedResize();
    _transformicions();
    _sidebarToggle();
    _sidebarColors();
    _scrollToContact();
    _scrollToFilters();
    _hideHeader();
    _initFilterNav();
  };

  function _scrollBody(element, duration, delay) {
    var headerHeight = $('.site-header').outerHeight(); 
    element.velocity("scroll", {
      duration: duration,
      delay: delay,
      offset: -headerHeight
    }, "easeOutSine");
  }

  function _transformicions() {
    $('.tcon:not(.tcon-no-animate)').on('click', function(e) {
      e.preventDefault();
      $(this).toggleClass('tcon-transform');
    });
  }

  function _sidebarToggle() {
    $('html').on('click', '.menu-toggle', function() {
      $('#side').toggleClass('open');
      $('body, #page, .site-header, .site-footer').toggleClass('sidebar-open');
    });

    // Close sidebar when clicking away
    $('html').on('click', '#page.sidebar-open, .site-footer.sidebar-open', function(e) {
      console.log($(e.target),$(e.target).is('a,button,input'));
      if (!$(e.target).is('a,button,input')) {
        console.log('baz');
        e.preventDefault();
        _hideSidebar();
      } else {
        return e;
      }
    });
  }

  function _hideSidebar() {
    if ($('#side').is('.open')) {
      $('#side').removeClass('open');
      $('.sidebar-open').removeClass('sidebar-open');
    }
  }

  function _showSidebar() {
    if (!$('#side').is('.open')) {
      $('#side').addClass('open');
      $('body, #page, .site-header, .site-footer').addClass('sidebar-open');
    }
  }

  function _sidebarColors() {
    $('.site-nav a').hover(function() {
      color = $(this).attr('data-color');
      $('#side').addClass('color-' + color);
    }, function() {
      $('#side').removeClass('color-' + color);
    });
  }

  function _scrollToContact() {
    $('#nav-contact a').on('click', function(e) {
      e.preventDefault();
       _hideSidebar();
       _scrollBody($('#contact'), 250, 250); 
    });
  }

  function _scrollToFilters() {
    // When clicking on a filter, scroll to top of grid
    $('#filters a').on('click', function() {
      _scrollBody($('.campaigns'), 250, 0); 
    });
  }

  function _hideHeader() {
    // Hide Header on on scroll down
    var didScroll;
    var lastScrollTop = 0;
    var delta = 5;
    var navbarHeight = $('.site-header').outerHeight();

    $(window).scroll(function(event){
        didScroll = true;
    });

    setInterval(function() {
        if (didScroll) {
            hasScrolled();
            didScroll = false;
        }
    }, 250);

    function hasScrolled() {
        var st = $(this).scrollTop();
        
        // Make sure they scroll more than delta
        if(Math.abs(lastScrollTop - st) <= delta)
            return;
        
        // If they scrolled down and are past the navbar, add class .nav-up.
        // This is necessary so you never see what is "behind" the navbar.
        if (st > lastScrollTop && st > navbarHeight){
            // Scroll Down
            $('.site-header').removeClass('nav-down').addClass('nav-up');
        } else {
            // Scroll Up
            if(st + $(window).height() < $(document).height()) {
                $('header').removeClass('nav-up').addClass('nav-down');
            } else if (st < navbarHeight) {
              $('.site-header').removeClass('-fixed');
            }
        }
        
        lastScrollTop = st;
    }
  }

  function _initFilterNav() {
    if ($('.filter-items li').length>0) {
      // init filtering
      $('#filters a').click(function(e) {
        e.preventDefault();
        if ($(this).hasClass('selected')) {
          $('#filters .show-all a').trigger('click');
        } else {
          $('#filters a').removeClass('selected');
          $(this).addClass('selected');

          var filter = $(this).attr('data-filter');
          $('.filter-items li').each(function() {
            if (filter=='' || $(this).hasClass(filter)) $(this).removeClass('dim').addClass('selected');
            else $(this).removeClass('selected').addClass('dim');
            window.hash = '#' + filter;
          });
        }
        // if on mobile, scroll down to #filters
        if ($.gdgr.main.is_handheld()) {
          $('html,body').animate({scrollTop:$('#filters').offset().top});
        }
        return false;
      });
      
       // build SEO-useless overlay links
      $('.filter-items li').each(function() {
        $(this).find('a:first').clone().empty().addClass('overlay').prependTo($(this).find('article'));
      });

      // clicking on dimmed item triggers all to open back up
      $('.filter-items a').click(function(e) {
        if ($(this).parents('li:first').hasClass('dim')) {
          $('#filters .show-all a').trigger('click');
          return false;
        }
      });
    }
 }

  function _resize() {
    screenWidth = document.documentElement.clientWidth;
    giant_desktop = screenWidth > 1382;
    desktop = screenWidth > 767;
    handheld = screenWidth < 481;
    tablet = !desktop && !handheld;
  };

  function _delayedResize() {
    // stretch---shrink images
    $('img.responsive').each(function() {
      var uid = $(this).attr('data-uid');
      if (uid) {
        if (giant_desktop) {
          var _width = $(this).data('giant_desktop_width');
          var endpoint = "/thumbs/" + _width + "x?uid=";
        } else if (desktop) {
          var _width = $(this).data('desktop_width');
          var endpoint = "/thumbs/" + _width + "x?uid=";
        } else {
          var _width = 290;
          var endpoint = "/thumbs/" + _width + "x?uid=";
        }

        // do we need to change the src to a different size?
        if ($(this).attr('src') != endpoint + uid) {
          var $this = $(this);
          $this.addClass('loading').attr({ 'src': endpoint + uid }).imagesLoaded(function($images) {
            $this.removeClass('loading');
          });
        }
      }
    });
  };

  return {
    init: _init,
    resize: _resize,
    showSidebar: _showSidebar,
    delayedResize: _delayedResize
  };

})();

// fire up the mothership
$(window).ready(function() {
  $.gdgr.main.init();
});

$(window).resize(function(){
  // instant resize functions
  $.gdgr.main.resize();

  // delayed resize for more intensive tasks
  if($.gdgr.main.delayed_resize_timer !== false) {
    clearTimeout($.gdgr.main.delayed_resize_timer);
  }
  $.gdgr.main.delayed_resize_timer = setTimeout($.gdgr.main.delayedResize, 200);
});

// equalizes height (to max) of elements passed in
$.fn.equalizeHeight = function(){
  var maxHeight = Math.max.apply(null, $(this).map(function() {
    return $(this).height();
  }).get());
  return $(this).height(maxHeight);
};
