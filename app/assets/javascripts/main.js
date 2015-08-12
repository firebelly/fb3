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

    // "quick" project image upload on frontend for admins
    if ($('.batch-upload').length) {
      Dropzone.autoDiscover = false;
      var dropzone = new Dropzone ('.dropzone', {
        paramName: 'images',
        autoProcessQueue: false,
        addRemoveLinks: true,
        uploadMultiple: true,
        parallelUploads: 20,
        queuecomplete: function() {
          // reload page after upload to show new images in project
          location.reload();
        }
      }); 
      // upload images button
      $('.batch-upload button.submit').click(function(e) {
        if ($('.dz-preview').length) {
          // any images? upload 'em
          dropzone.processQueue();
        } else if ($('#images_number').val() + $('#images_title').val() + $('#images_desc').val() != '') {
          // just adding text?
          dropzone.disable();
          $('.batch-upload form')[0].submit();
        }
      });
      // allow user to sort the images to be uploaded
      $('.dropzone').sortable({
        itemSelector: '.dz-preview',
        'containerSelector': '.dropzone',
        'placeholder': '<div class="dz-preview placeholder"></div>',
        onDrop: function ($item, container, _super, event) {
          // default sortable behavior onDrop
          $item.removeClass(container.group.options.draggedClass).removeAttr('style');
          $('body').removeClass(container.group.options.bodyClass);

          // get sorted array of filenames
          var fileSort = [];
          $('.dz-preview').each(function() {
            fileSort.push($(this).find('.dz-filename span').text());
          });

          // grab the dropzone queued files and clear them out
          var files = dropzone.getQueuedFiles();
          dropzone.removeAllFiles();

          // re-add each file based on the sorted order
          $.each(fileSort, function(i, name) {
            var file = $.grep(files, function(e){ return e.name == name; });
            dropzone.addFile(file[0]);
          });
        }
      });
    }

    // responsive videos
    $('.user-content').fitVids();

    // ajax newsletter form
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
      if (!$(e.target).is('a, a > *,button,input')) {
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
      _scrollBody($('.projects'), 250, 0); 
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
          // var filter_type = $(this).attr('data-filter-type');
          $('.filter-items li').each(function() {
            if (filter=='' || $(this).attr('data-industry').match(filter) || $(this).attr('data-services').match(filter)) {
              $(this).removeClass('dim').addClass('selected');
            } else {
              $(this).removeClass('selected').addClass('dim');
            }
            window.location.hash = '#' + filter;
          });
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
