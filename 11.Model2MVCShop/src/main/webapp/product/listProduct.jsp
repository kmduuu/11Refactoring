<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>

<html lang="ko">

<head>
	<meta charset="EUC-KR">
	
<title>상품 목록조회</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>

	<!-- Bootstrap Dropdown Hover CSS -->
   	<link href="/css/animate.min.css" rel="stylesheet">
   	<link href="/css/bootstrap-dropdownhover.min.css" rel="stylesheet">
    <!-- Bootstrap Dropdown Hover JS -->
  	<script src="/javascript/bootstrap-dropdownhover.min.js"></script>
   
   
   	<!-- jQuery UI toolTip 사용 CSS-->
  	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  	<!-- jQuery UI toolTip 사용 JS-->
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  
 	 <style>
	  body {
            padding-top : 50px;
        }
   	 </style>
    
     <!--  ///////////////////////// JavaScript ////////////////////////// -->
	<script type="text/javascript">
	
		//=============    검색 / page 두가지 경우 모두  Event  처리 =============	
		function fncGetProductList(currentPage) {
			$("#currentPage").val(currentPage)
			$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu=${menu}").submit();
		}
		
		
		//============= "검색"  Event  처리 =============	
		 $(function() {
			 //==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			 $( "button.btn.btn-default" ).on("click" , function() {
				fncGetProductList(1);
			});
		 });
		
		 $(function() {
				
				//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
				$( "td:nth-child(2)" ).on("click" , function() {
					
					var text1 = $(this).children("input:hidden").val();
					
					if(${menu eq 'manage'}){
						self.location ="/product/updateProductView?prodNo="+text1;
					}
					else{
						self.location ="/product/getProduct?menu=${menu}&prodNo="+text1;
					}
					
		});
							
				//==> prodNo LINK Event End User 에게 보일수 있도록 
				$( "td:nth-child(2)" ).css("color" , "red");
		});
	
	// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
	//function fncGetProductList(currentPage) {
	//	document.getElementById("currentPage").value = currentPage;
	//  	document.detailForm.submit();		
	//}
	
	$(function(){	
		$(".ct_list_pop td:nth-child(2)").on("click", function(){
			
			var text = $(this).text();
			
			//alert(text); 
			$.ajax( // 비동기식 Ajax를 이용하여 Http 요청을 전송한다.
					// 데이터를 주고받는 역할을 담당
					// 아마 JSON형식으로 주고받음(?)
					
					{
					url : "/product/json/getProduct/"+text,
					method : "GET",
					dataType : "json" ,
					headers : {
						"Accept" : "application/json",
						"Content-Type" : "application/json"
					}, 
					success : function(JSONData, status)
					// status == 200, stats == 4 
					{
						var displayValue = "<h3>"
													+"상품명 : "+JSONData.prodName+"<br/>"
													+"상세정보 : "+JSONData.prodDetail+"<br/>"
													+"제조일자 : "+JSONData.manuDate+"<br/>"
													+"가격 : "+JSONData.price+"<br/>"
													+"등록일자 : "+JSONData.regDateString+"<br/>"
													+"</h3>";
													
						$("h3").remove();
						$( "#"+text+"" ).html(displayValue);
					}
				});
			
			});
		
		
		$( ".ct_list_pop td:nth-child(2)" ).css("color" , "red");
		$("h7").css("color" , "red");
		
		
		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
		//<a href="/product/updateProductView?prodNo=${product.prodNo}">${product.prodName}</a>
	});

</script>

</head>

<body>
	
	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->
	
	<!--  화면구성 div Start /////////////////////////////////////-->
	<div class="container">
	
		<div class="page-header text-info">
		
	       <c:if test="${menu eq 'manage'}">
							<h3>상품관리</h3>
		   </c:if>
		   <c:if test="${menu eq 'search'}">
							<h3>상품목록조회</h3>
		   </c:if>
	    </div>
	    
		<div class="row">
	    
		    <div class="col-md-6 text-left">
		    	<p class="text-primary">
		    		전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage}  페이지
		    	</p>
		</div>

		<div class="col-md-6 text-right">
			  <form class="form-inline" name="detailForm">
			    
				  <div class="form-group">
				    <select class="form-control" name="searchCondition" >
						<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
						<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
						<option value="2"  ${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>가격</option>
					</select>
		</div>

				<div class="form-group">
				    <label class="sr-only" for="searchKeyword">검색어</label>
				    <input type="text" class="form-control" id="searchKeyword" name="searchKeyword"  placeholder="검색어"
				    value="${! empty search.searchKeyword ? search.searchKeyword : '' }"  >
				</div>

			<button type="button" class="btn btn-default">검색</button>
				  
				  <!-- PageNavigation 선택 페이지 값을 보내는 부분 -->
				  <input type="hidden" id="currentPage" name="currentPage" value=""/>
				  
			</form>
		</div>
	</div>
	<table class="table table-hover table-striped" >
	<thread>
	<tr>
		<th align="center">No</th>
		<th align="left">상품명</th>
		<th align="left">가격</th>
		<th align="left">등록일</th>
		<th align="left">상품상세정보</th>
		<th align="left">현재상태</th>
	</tr>
	</thread>
	
	<tbody>
		
		 <c:set var="i" value="0" />
		  <c:forEach var="product" items="${list}">
			<c:set var="i" value="${ i+1 }" />
			<tr class="ct_list_pop">
			  <td align="center">${i}</td>
			  <td align="left" title="Click : 상품정보 확인">${product.prodName}
			  <input type="hidden" id="hiddenInput" value="${product.prodNo}">
			  </td>
			  <td align="left">${product.price}</td>
			  <td align="left">${product.manuDate}</td>
			  <td align="left">${product.prodDetail}</td>
			  <td align="left"><input type="hidden" id="hiddenInput" value="${product.prodNo}"></td>
			</tr>
          </c:forEach>
        
       </tbody>
</table>
</div>
			<jsp:include page="../common/pageNavigator_new2.jsp"/>	

</body>
</html>
