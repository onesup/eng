$(document).ready(function(){
	$('#poster_inbox').owlCarousel({
		navigation : true, // Show next and prev buttons
		slideSpeed : 300,
		paginationSpeed : 400,
    singleItem:true,
    navigationText: ["<<",">>"]
	});

  
  $("#info_address").focus(function(){
    alert("검색할 주소를 입력하세요. (예: 종로구 새문안로 58 또는 종로구 신문로2가 92번지)");
  });

	var q;	

  $('#info_address_btn').click(function(e){
    e.preventDefault();
		q = $("#info_address").val();
		test_out(q);
  });

	var handler = function(event){
			if (event.which == 13) {
				q = $("#info_address").val();
				test_out(q);
	        }
	};
	$('#info_address').keyup(handler);

  var swt = true;
  $('.menu_form').css('height', $(window).height());
  $('#menu').click(function(e){
    e.preventDefault();
    if( swt ){
      $('.contain').animate({'margin-left': '-60%'});
      swt = false;
    } else {
      $('.contain').animate({'margin-left': '0%'});
      swt = true;
    }
  });

  var posterPage = 0;

  get_poster_code();

});


function get_poster_code(){
  $(".poster_select").click(function(e){
    var code = $(this).attr("code");
    get_poster_btn_href(code);
  });

}

function get_poster_btn_href(code){
    var href = $("#poster_btn").attr("href");
    var data_href = $("#poster_btn").attr("data-href");
    href = data_href+"?code="+code;
    $("#poster_btn").attr("href", href);
}

function test_out(q){

    $.ajax({
        "url": "//api.poesis.kr/post/search.php",
        "type": "get",
        "data": { "v": "1.1", "q": q, "ref": window.location.hostname },
        "dataType": "jsonp",
        "processData": true,
        "cache": false,

        // 요청이 성공한 경우 이 함수를 호출한다.

        "success": function(data, textStatus, jqXHR) {

			// address: "광주광역시 광산구 월곡산정로 80"
			// canonical: "월곡동 613-1"
			// code5: "62356"
			// code6: "506-825"
			// dbid: "2920012800106130001001692"
			// english_address: "80, Wolgoksanjeong-ro, Gwangsan-gu, Gwangju"
			// extra_info_long: "월곡동 613-1, 금호아파트"
			// extra_info_short: "월곡동, 금호아파트"
			// jibeon_address: "광주광역시 광산구 월곡동 613-1"
			// other: "월곡1동; 금호타운아파트"


            // 검색후 콜백 함수를 실행한다.
			query_results = data.results;

			$("#addresses").empty();
      	$("#addresses").append("<option selected disabled>주소검색결과</option>");


			if(query_results.length > 20 || query_results.length === 0){
				$(".address_box").css("display", "none");
				alert("주소를 자세히 입력해 주세요. (예: 종로구 새문안로 58 또는 종로구 신문로2가 92번지");

			}else {

				$.each(query_results, function( index, value ) {


          extra_info = "<optgroup label='"+value.address+"'>";
          address = "<option class='address_list' value='"+value.address+"'>"+value.extra_info_long+"</option></optgroup>";

					$("#addresses").append(extra_info+address);
					$(".address_box").css("display", "block");
				});

				$('#addresses').on("change", function(){
					code6 = $(this).attr("code6");
					address_data = $(this).val();
					$("#info_code6").val(code6);
					$("#info_address").val(address_data);
					$(".address_box").hide();

				});
			}
        },

        // 요청이 실패한 경우 이 함수를 호출한다.

        "error": function(jqXHR, textStatus, errorThrown) {


			  dd
		},

        // 요청 후에는 이 함수를 호출한다.

        "complete": function(jqXHR, textStatus) {

		}
    });
}
