$.gdgr = $.gdgr || {};

// firebellydesign people
$.gdgr.people = (function() {

  var is_animating = false;

  function _init() {
    // waypoint the People
    $('.child-pages > li').waypoint(function() {
      if (!is_animating) {
        _setCurrentPerson($(this).data('page'));
      }
    });

    function _setCurrentPerson(page) {
      $('#filters a').removeClass('selected');
      $('#filters a[data-page=' + page + ']').addClass('selected');
    };

    // keyboard nerds
    $(document).bind('keydown',function(e) {
      if (e.keyCode == 37) {
        $('.section-nav a.selected').parent().prev('li').find('a').trigger('click');
      } else if (e.keyCode == 39) {
        $('.section-nav a.selected').parent().next('li').find('a').trigger('click');
      }
    });

    // scrolly anchor tags, now for a[name]
    $('.smoothscroll a').click(function(e){
      e.preventDefault();
      var page = $(this).data('page');
      is_animating = true;
      _setCurrentPerson(page);
      $('html,body').animate({scrollTop:$('.child-pages > li[data-page=' + page + ']').offset().top}, 500, function() {
        is_animating = false;
        window.location.hash = '#'+page;
      });
    });
  };

  return {
    init: function() {
      _init();
    }
  };

})();

$(window).ready(function(){
  if ($('#people-page').length) {
    $.gdgr.people.init();
  }
});
