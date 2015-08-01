$.gdgr = $.gdgr || {};

// firebellydesign projects
$.gdgr.projects = (function() {

  var is_animating = false;
  var scroll_speed = 500;

  function _init() {
    // make the .intro div play nice with waypoints
    $('.content .intro').data('project', 'information');

    if ($('body').hasClass('single')) {
      $('.fancybox').fancybox({
        padding: 0
      });
    }

    // nav links clicks scroll to project, hover shows project title
    $('#project-nav .project-category').click(function(e) {
      e.preventDefault();
     _slideTo($(this).data('project'));
    }).hover(function(e) {
      $('.current-category span').text($(this).text());
    }, function(e) {
      $('.current-category span').text($('#project-nav .selected').text());
    });

    // keyboard nerds
    $(document).bind('keydown',function(e) {
        if (e.keyCode == 37) {
          $('.image-nav span.selected').parent().prev('li').find('span').trigger('click');
          e.preventDefault();
        } else if (e.keyCode == 39) {
          $('.image-nav span.selected').parent().next('li').find('span').trigger('click');
          e.preventDefault();
        }
    });

    // init waypoints to trigger selected section in nav
    if ($('body').hasClass('single')) {
      $('.content .intro, .image-list > li').waypoint(function() {
        if (!is_animating) _setCurrentProject($(this).data('project'));
      });
    }

    // always start w/ Information selected
    $('#project-nav span:first').addClass('selected');

    // scrolling to particular project or saving filter state?
    if (window.hash) {
      var hash = window.hash.slice(1);
      if ($('body').hasClass('single')) {
        _slideTo(hash);
      } else {
        $('#filters a[data-filter='+hash+']').trigger('click');
      }
    }

    // init .clear-left on first-in-row thumbs
    // _resize();

  }; // END _init()

  function _setCurrentProject(project) {
    $('#project-nav .project-category').removeClass('selected');
    var textTo = $('#project-nav .project-category[data-project=' + project + ']').addClass('selected').text();
    $('.current-category span').text(textTo);
  };

  function _slideTo(project) {
    var $projectLink = $('#project-nav .project-category[data-project=' + project + ']');
    var $projectTarget = $(".image-list [data-project=" + project + "]");

    if ($projectLink.hasClass('information')) {
      scrollTop = 0;
    } else {
      scrollTop = $projectTarget.offset().top - 15;
    }

    is_animating = true;
    $('html,body').stop().animate({
      'scrollTop': scrollTop
    }, scroll_speed, function() {
      window.location.hash = '#' + project;
      // waypoints wasn't catching this when scrolling back up
      _setCurrentProject(project);
      is_animating = false;
    });
  };

  function _resize() {
    if ($('body').hasClass('index') && $(window).width() >= 730) {
      var pageWidth = ($(window).width() > 1382) ? $('#wrapper').width() : 730;
      
      // make each first work thumb in row clear left
      $('.portfolio .project').removeClass('clear-left').removeClass('tail');
      var perRow = Math.floor(pageWidth / $('.project').outerWidth(true));
      $('.portfolio .project:nth-child(' + perRow + 'n+1)').addClass('clear-left');
      $('.portfolio .project:nth-child(' + perRow + 'n)').addClass('tail');
      
      // set width of headers so mantra is right-flush with thumb edges
      $('#page, footer').width((perRow * $('.portfolio .project').outerWidth(true)) - 6);
    } else {
      // remove width declaration for mobile
      $('#page, footer').width('');
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
  $.gdgr.projects.init();
});

$(window).resize(function(){
  // $.gdgr.projects.resize();
});
