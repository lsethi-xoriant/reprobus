
$(document).ready( function() {
  if (typeof CKEDITOR != 'undefined' && $('.ckeditor-textarea').size() > 0) {
    for (instance in CKEDITOR.instances) {
      var editor = CKEDITOR.instances[instance];
      if (editor) { editor.destroy(); }
        CKEDITOR.replace(instance, {"toolbar":"mini"});
    }
  }
});
