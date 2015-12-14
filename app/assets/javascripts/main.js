$.gdgr = $.gdgr || {};

// good design for good reason for good namespace
$.gdgr.main = (function() {

  var screenWidth = 0,
      desktop = false,
      handheld = false,
      tablet = false,
      admin_status = false,
      is_animating = false;

  function _init() {
    $('#flash').hide().css('visibility','visible').fadeIn();

    // remove useless alt tooltips
    $('img').each(function () {
      if (!$(this).attr('title')) {
        $(this).attr('title', '');
      }
    });

    // "quick" project image upload on frontend for admins
    if ($('.batch-upload').length) {
      
      // also allow editing alt tags on images
      _initImageAltEditor();

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
    $('.content').fitVids();

    // lazyload images
    _initLazyload();

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

    // Keyboard nerds rejoice
    $(document).keyup(function(e) {
      if (e.keyCode == 27) {
        _hideSidebar();
      }
    });

    // Scroll down to hash afer page load
    $(window).load(function() {
      if (window.location.hash) {
        var el = $(window.location.hash);
        if (el.length) _scrollBody(el); 
      }
    });

    // Homepage
    if ($('#work-page.index').length) {
      _scrollToFilters();
      // SEO useless filter header
      var filterHeader = $('<div class="filter-header">Filter:<p><span class="filter">test</span> </p></div>').prependTo('#page .portfolio');
      $('<a href="#">X</a>').appendTo(filterHeader.find('p')).on('click', function(e) {
        e.preventDefault();
        $('#filters .show-all a').trigger('click');
      });
    }

    _resize();
    _transformicions();
    _sidebarToggle();
    _sidebarColors();
    _scrollToContact();
    _hideHeader();
    _initFilterNav();
    _initSmoothScroll();
  };

  function _initImageAltEditor() {
    var project_id = $('.single-project').data('id');
    $('.project-images img').each(function() {
      var $img = $(this);
      var old_alt = $img.prop('alt');
      var wrap = $img.wrap('<div class="alt-tag-edit" />').parent();
      $('<input type="text" name="alt" placeholder="Enter Image Alt..." value="' + old_alt + '">').appendTo(wrap).on('change', function(e) {
        var $input = $(this);
        $.ajax({
          type: 'POST',
          url: '/work/image_alt_update',
          cache: false,
          dataType: 'json',
          data: {
            new_alt: $input.val(),
            project_id: project_id,
            image_url: $img.attr('data-original')
          },
          success: function(data) {
            $input.addClass('done');
            setTimeout(function() {$input.removeClass('done');}, 500);
          }
        });
      });
    });
  }

  function _scrollBody(element, duration, delay) {
    // var headerHeight = $('.site-header').outerHeight();
    _hideHeader();
    var headerHeight = 0;
    is_animating = true;
    element.velocity("scroll", {
      duration: duration,
      delay: delay,
      offset: -headerHeight,
      complete: function(elements) { 
        is_animating = false;
      }
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

    $('html').on('click', '.project-side-toggle', function() {
      $('#project-side').toggleClass('open');
      
      // init lazyload images in sidebar if not already done
      if (!$('#project-side').hasClass('lazy-loaded')) {
        $('.lazy-side').lazyload({
          container : $('#project-side .projects'),
          effect : 'fadeIn',
        });
        $('#project-side').addClass('lazy-loaded')
      }

      $('body, #page, .site-header, .site-footer').toggleClass('project-side-open');
    });

    // Close sidebar when clicking away
    $('html').on('click', '#page.sidebar-open, .site-footer.sidebar-open, #page.project-side-open, .site-footer.project-side-open', function(e) {
      if (!$(e.target).is('a, a > *,button,input')) {
        e.preventDefault();
        _hideSidebar();
      } else {
        return e;
      }
    });
  }

  function _hideSidebar() {
    $('#side,#project-side').removeClass('open');
    $('.sidebar-open').removeClass('sidebar-open');
    $('.project-side-open').removeClass('project-side-open');
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

  function _initSmoothScroll() {
    $('#wrapper').on('click', '.smoothscroll a', function(e){
      e.preventDefault();
      var el = $( $(this).attr('href') );
      if (el.length) _scrollBody(el);
    });
  }

  function _scrollToContact() {
    $('.nav-contact a').on('click', function(e) {
      e.preventDefault();
       _hideSidebar();
       _scrollBody($('#contact'), 250, 250);
       $('body').addClass('focus-contact');
       setTimeout(function() {
         $('body').removeClass('focus-contact');
       }, 1500);
    });
  }

  function _scrollToFilters() {
    // When clicking on a filter, scroll to top of grid
    $('#filters a').on('click', function() {
      _scrollBody($('#page .projects'), 250, 0); 
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
        if (!is_animating && didScroll) {
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
          var filter = $(this).attr('data-filter');
          _filterProjects(filter);
          window.location.hash = '#' + filter;
        }
        return false;
      });
      // initial filter?
      if (window.location.hash) {
        var filter = window.location.hash.replace('#','');
        _filterProjects(filter);
        // make sure images are shown after filtering
        $('.lazy').trigger('appear');
      }
    }
  }

  function _initLazyload() {
    $('.lazy').lazyload({
      effect : 'fadeIn',
      threshold: 1500
    });
  }

  function _filterProjects(filter) {
    // highlight filter in nav
    $('#filters a').removeClass('selected');

    var activeFilter = $('#filters a[data-filter="'+filter+'"]');
    activeFilter.addClass('selected');
    if (filter != '') {
      $('.filter-header').addClass('active').find('.filter').html(activeFilter.html());
    } else {
      $('.filter-header').removeClass('active');
    }

    // dim all projects not matching filter
    $('.filter-items li').each(function() {
      if (filter=='' || $(this).attr('data-industry').match(filter) || $(this).attr('data-services').match(filter)) {
        $(this).removeClass('dim').addClass('selected');
      } else {
        $(this).removeClass('selected').addClass('dim');
      }
    });
  }

  function _resize() {
    screenWidth = document.documentElement.clientWidth;
    giant_desktop = screenWidth > 1382;
    desktop = screenWidth > 767;
    handheld = screenWidth < 481;
    tablet = !desktop && !handheld;
  };

  return {
    init: _init,
    resize: _resize,
    showSidebar: _showSidebar
  };

})();

// fire up the mothership
$(window).ready(function() {
  $.gdgr.main.init();
});

$(window).resize(function(){
  $.gdgr.main.resize();
});
