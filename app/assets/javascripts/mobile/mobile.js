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
  
  get_poster_code();
  
});


function get_poster_code(){
  $(".poster_select").click(function(e){
    var code = $(this).attr("code");
    get_poster_btn_href(code);
  });
  
  //console.log(e.result);
  // return code;
}


function get_poster_btn_href(code){
    var href = $("#poster_btn").attr("href");   
    var data_href = $("#poster_btn").attr("data-href");                                
    href = data_href+"?code="+code;                   
    $("#poster_btn").attr("href", href);            
    console.log($("#poster_btn").attr("href"));    
    
}