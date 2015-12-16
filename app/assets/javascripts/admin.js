// Use this to customize the visual editor boot process
// Just mirror the options specified in your visual editor's config with the new
// options here.  This will completely override anything specified in your visual
// editor's boot process for that key, e.g. skin: 'something_else'

if (typeof(custom_visual_editor_boot_options) === 'undefined') {
  custom_visual_editor_boot_options = {
    classesItems: [
      {name: 'image-align', rules:['left', 'right'], join: '-'}
      , {name: 'fb', rules:['centered-paragraph'], join: '-'}
    ]
    , containersItems: [
      {'name': 'h2', 'title':'Heading_2', 'css':'wym_containers_h2'}
      , {'name': 'h3', 'title':'Heading_3', 'css':'wym_containers_h3'}
      , {'name': 'p', 'title':'Paragraph', 'css':'wym_containers_p'}
      , {'name': 'blockquote', 'title':'Blockquote', 'css':'wym_containers_blockquote'}
    ]
    , dialogFeatures: {
          width: 1080
        , height: 710
        , modal: true
      }
  };
}

// simple char-count fields
setTimeout(function() {

  $(window).ready(function() {
    if (typeof(char_count_init) === 'undefined') {
      $('textarea.char-count,textarea[name="page[meta_description]"]').each(function() {
        var max = $(this).attr('data-max-chars') || 155;
        var char_count_text = $('<p class="char-count-text">' + $(this).val().length + ' / ' + max + ' chars</p>').insertAfter(this);
        $(this).keyup(function () {
          var len = $(this).val().length;
          char_count_text.text(len + ' / ' + max + ' chars');
        });
      });
      char_count_init = 1;
    }
  });

}, 500);
