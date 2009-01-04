// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
hide_show_content = function(button_cls, content_cls, name){
  (function($){
   $(document).ready(function(){
     $(button_cls).click(function(){
        var class_string = $(content_cls).attr('class')
        var state = class_string.split(" ");

        if (state[1] == 'hide') {
           $(this).find('a').text("＋");
           $(content_cls).removeClass("hide").addClass("show");
           $.ajax({
              url: '/member/set_default_option',
              type: 'POST',
              data: {'side_name': name, 'side_status': 'show'}
           });
        }
        else {
           $(this).find('a').text("－");
           $(content_cls).removeClass("show").addClass("hide");
           $.ajax({
              url: '/member/set_default_option',
              type: 'POST',
              data: {'side_name': name, 'side_status': 'hide'}
           });
       }
     });
     });
   })(jQuery);
}

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

//jQuery.fn.submitWithAjax = function() {
//  this.submit(function() {
//    $.post(this.action, $(this).serialize(), null, "script");
//    return false;
//  })
//};

// $(document).ready(function(){
//   $("#new_forum_comment form").submitWithAjax();
// })
