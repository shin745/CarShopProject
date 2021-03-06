<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<link
	href="https://fonts.googleapis.com/css?family=Roboto:100,100i,300,300i,400,400i,500,500i,700,700i,900,900i"
	rel="stylesheet">
<link href='/resources/lib/main.css' rel='stylesheet' />  <!-- 캘린더 경로 바꿈 -성연 2020.12.31 -->
<!-- 달력 css -->
<script src='/resources/lib/main.js'></script>  <!-- 캘린더 경로 바꿈 -성연 2020.12.31 -->
<!-- 달력 js  -->

<%@ include file="../include/header.jsp"%>


<title>Aroma Shop</title>
<link rel="stylesheet" href="/resources/vendors/linericon/style.css">
<link rel="stylesheet"
	href="/resources/vendors/nouislider/nouislider.min.css">

<body>
	<!-- ================ start banner area ================= -->

	<div id='calendar'></div>



	<!-- ================ end banner area ================= -->

	<!--================Order Details Area =================-->
	<section class="order_details section-margin--small">
		<div class="container">
			<div class="order_details_table">
				<h2>교환/반품 정보</h2>
				<div class="table-responsive">
					<table class="table">
						<thead>
							<tr>
								<th scope="col"><strong>주문번호</strong></th>
								<th scope="col"><strong>구매자</strong></th>
								<th scope="col"><strong>상품명</strong></th>
								<th scope="col"><strong>사유</strong></th>
								<th scope="col"><strong>구매 날짜</strong></th>
								<th scope="col"><strong>결제수단</strong></th>
								<th scope="col"><strong>교환/환불</strong></th>
							</tr>
						</thead>
						<tbody id="tbodyid">
							<c:forEach items="${list }" var="list">
								<tr id="tr${list.ono }">
									<td scope="col" id="ono"><c:out value="${list.ono}" /></td>
									<td scope="col" id="u_id"><c:out value="${list.u_id}" /></td>
									<td scope="col" id="p_name"><c:out value="${list.pname}" /></td>
									<td scope="col" id="content" data-content="${list.content }"
										data-toggle="modal" data-target="#exampleModalCenter">
										<c:choose>
											<c:when test="${fn:length(list.content) > 2 }">
												<c:out value="${fn:substring(list.content,0,2	) }" />...<small>더보기</small>	
											</c:when>
											<c:otherwise>
												<c:out value="${list.content}" />
											</c:otherwise>

										</c:choose> 
									</td>

									<td scope="col" id="order_date"><c:out
											value="${list.order_date}" /></td>
									<td scope="col" id="pay"><c:out value="${list.pay}" /></td>
									<td scope="col" class="span1" id=""><button id="btn_click"
											class="btn btn-success" data-ono="${list.ono }">
											<span><strong>교환/반품</strong></span>
										</button></td>
								</tr>
							</c:forEach>
						
						</tbody>
					</table>
					<!--  Modal -->
				<div id="modalEvent">
					<div class="modal fade" id="exampleModalCenter" tabindex="-1"
						role="dialog" aria-labelledby="exampleModalCenterTitle"
						aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="exampleModalLongTitle">교환/환불</h5>
								</div>
								<div class="modal-body">
									<div class="form-group" id="modal_conten"></div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-primary"
										data-dismiss="modal" id="modalbtn" >닫기</button>
								</div>
							</div>
						</div>
					</div>
				</div>
					<!-- /.modal -->


				</div>
			</div>
		</div>
	</section>
</body>
<script>
let calendar =null;

		// 캘린더 이벤트
    document.addEventListener('DOMContentLoaded', function() {
    	let tbody = $('#tbodyid');
    	let str = '';
    	
        var calendarEl = document.getElementById('calendar');
        calendar = new FullCalendar.Calendar(calendarEl, {
        	selectable: true,
        	// 캘린더 요일 클릭 시 이벤트 발생
              dateClick: function(info) {
            	  tbody.empty();
            	  let text = '';
//                   alert('Date: ' + info.dateStr);
//                   alert('Resource ID: ' + info.resource.id);
			// ajax 로 주문날짜와 현재날짜를 비교하여 가져온다
           			$.ajax({
            	    url :'clickDate?click_date=' ,
            	    data : {
            	    		"click_date" : info.dateStr
            	    		,"s_id" : '${id}'
            	    		},
               		type : 'get',
               		dataType : 'JSON',
               		success : function(data){
                  		console.log("data : ",data);

               			if(data.errorCode ==1){
                    		let result = '';
                    		   $.each(data.list,function(key,value){
                    	  		 text += '<tr id="tr'+value.ono+'"><td scope="col" id="ono">'+value.ono+'</td><td scope="col" id="u_id">'+value.u_id+'</td>'
                    	   	   	 text += '<td scope="col" id="p_name">'+value.pname+'</td><td scope="col" id="content" data-content="'+value.content+'"data-toggle="modal" data-target="#exampleModalCenter">'
                    	  		if(value.content.length >2){
        					result =	value.content.substring(0,2) +'...<small>더보기</small>';

                    	   }else{
                    		  result= value.content;
                    		   
                    	   }
                    	   text += ''+result+'</td>'
                    	   text += '<td scope="col" id="order_date">'+value.order_date+'</td><td scope="col" id="pay">'+value.pay+'</td>'
                    	   text += '<td scope="col" class="span1" id=""><button id="btn_click" class="btn btn-success" data-ono='+value.ono+'><span><strong>교환/반품</strong></span></button></td></tr>'
                       })
                	   tbody.append(text);
               			}else{
               				location.href="/carshop/error";
               				
               			}


               },
               error : function(){	
                  console.log("통신실패");
               }
               
              
            })
            
              },
          



              

        initialView: 'dayGridMonth'

          
        });
        calendar.render();

      });

	$(document).ready(function() {

		// id가 content인 td태그가 클릭 시 이벤트 발생 하여 모달창에 content(내용) 를 넣는다
		 $(document).on("click","td#content",function() {
			 
			console.log("내용클릭");
			let content = $(this).data("content");
			console.log("data  :", content);
			let conten = $('#modal_conten');
			conten.append('<p>' + content + '</p>');

		})
		// 모달 이벤트가 발생하고 버튼 클릭 시  내용을 비워준다
		$(document).on("click","#modalbtn",function() {
			console.log("클릭확인");
			$('#exampleModalCenter');
			console.log("console : ",$('exampleModalCenter'));
			$('#modal_conten').empty();
			
		})
		

		<c:forEach items='${count}' var="schd">
        calendar.addEvent({
        	title : "<c:out value='${schd.count}건' />",
			start : "<c:out value='${schd.order_date}' />",
            allDay: true
          });
        </c:forEach>
        
		// 교환 반품 이벤트

       $(document).on("click","#btn_click",function(){
    	  let ono = $(this).data("ono");
    	   console.log("ono : " + ono);
    	   
    	  $.ajax({
    		  url : 'delete',
    		  data : {'ono' : ono},
    		  dataType : 'JSON',
    		  type : 'POST',
    		  success : function(data){
    			  console.log(data);
    			  if(data.errorCode ==1){
    	    			$('#tr'+ono+'').remove();
    	    			Swal.fire({
    	    				  title: '처리 되었습니다',
    	    				  text: 'Success',
    	    				  confirmButtonText: `확인`
    	    				}).then((result) => {
    	    				  /* Read more about isConfirmed, isDenied below */
    	    				  if (result.isConfirmed) {
    	    					  location.reload();
    	    				  }
    	    				})
//       	     			location.reload();
    			  }else{
  	    			Swal.fire({
	    				  title: '처리되지 않았습니다',
	    				  confirmButtonText: `확인`
	    				}).then((result) => {
	    				  /* Read more about isConfirmed, isDenied below */
	    				  if (result.isConfirmed) {
	    					  location.reload();
	    				  }
	    				})
    			  }

    		  },
    		  error : function(){
    			  console.log("통신실패");
    		  }
    	  })
       })

	});
		
</script>
<style>
#calendar { /* 달력 크기 */
	max-width: 750px;
	margin: 0 auto;
}
</style>


<%@ include file="../include/footer.jsp"%>