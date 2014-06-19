$(document).ready(function(){
  var swt = true;
  $('.menu_form').css('height', $(window).height());
  $('#menu').click(function(){
    if( swt ){
      $('.contain').animate({'margin-left': '-70%'});
      swt = false;
    } else {
      $('.contain').animate({'margin-left': '0%'});
      swt = true;
    }
  });
});
