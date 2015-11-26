$(document).bind('page:load', function() {
  if(CKEDITOR.instances != 'undefined') {
    for(var instance in CKEDITOR.instances) {
      if(CKEDITOR.instances[instance].status == 'ready') {
        CKEDITOR.dom.element.get(instance) && CKEDITOR.replace(instance);
      }
    }
  }
});
