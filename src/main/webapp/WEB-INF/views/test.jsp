<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!-- Bootstrap 3.3.4 -->
<link href="/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<!-- Bootstrap 3.3.2 JS -->
<script src="/resources/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<style>
#modDiv{
	width:300px;
	height:100px;
	background-color:gray;
	position:absolute;
	top:50%;
	left:50%;
	margin-top:-50px;
	margin-left:-150px;
	padding:10px;
	z-index:1000;
}
/* .pagination{
	list-style:none;
}
.pagination li{
	float:left;
}
.active{
	color:yellow;    
	background-color:darkgray;
}
.pagination li a{
	padding:0px 5px 0px 5px; 
	border:1px solid black;
	text-decoration:none;
	width:10px;
} */
</style>

<!-- JQuery 2.1.4 -->
<script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script>
	var bno=5;
	var replyPage=1;
	function getAllList(){
		
		$.getJSON("/replies/all/"+bno,function(data){
			var str="";
			console.log(data.length);
			
			$(data).each(function(){
				str+="<li data-rno='"+this.rno+"' class='replyLi'>"+
				this.rno+":"+this.replytext+
				"<button>MOD</button></li>";
				$("#replies").html(str);
			});
		});
	}
	
	function getPageList(page){
		$.getJSON("/replies/"+bno+"/"+page,function(data){
			console.log(data.list.length);
			
			var str=""; 
			
			$(data.list).each(function(){
				str+="<li data-rno='"+this.rno+"' class='replyLi'>"+
				this.rno+":"+this.replytext+
				"<button>MOD</button></li>";
			});
			
			$("#replies").html(str);
			
			printPaging(data.pageMaker);
		});	
	}
	
	function printPaging(pageMaker){
		var str="";
		
		if(pageMaker.prev){
			str+="<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
		}
		
		for(var i=pageMaker.startPage, len = pageMaker.endPage;i<=len;i++){
			var strClass=pageMaker.cri.page==i?"class='btn active'":"class='btn'";
			str+="<li "+strClass+"><a href='"+i+"'>"+i+"</a></li>";
		}
		
		if(pageMaker.next){
			str+="<li><a href='"+(pageMaker.endPage+1)+"'> >> </a></li>";
		}
		$(".pagination").html(str);
	}
	
	$(document).ready(function(){
		
		$("#replyAddBtn").on("click",function(){
			var replyer = $("#newReplyWriter").val();
			var replytext = $("#newReplyText").val();
			
			$.ajax({
				type:"post",
				url:"/replies",
				headers:{
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType:"text",
				data:JSON.stringify({
					bno:bno,
					replyer:replyer,
					replytext:replytext
				}),
				success:function(result){
					if(result=="SUCCESS"){
						alert("등록되었습니다.");
						//getAllList();
						getPageList(replyPage);
					}
				}
			});
			$("#newReplyWriter").val("");
			$("#newReplyText").val("");
		});
		$("#replies").on("click",".replyLi button",function(){
			var reply = $(this).parent();
			
			var rno = reply.attr("data-rno");
			var replytext = reply.text();
			
			$(".modal-title").html(rno);
			$("#replytext").val(replytext);
			$("#modDiv").show("slow");
			
			//alert(rno+":"+replytext);
		});
		
		$("#replyDelBtn").on("click",function(){
			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();
			
			$.ajax({
				type:"delete",
				url:"/replies/"+rno,
				headers:{
					"Content-Type":"application/json",
					"X-HTTP-Method-Override" : "DELETE"
				},
				dataType:"text",
				success:function(result){
					console.log("result:"+result);
					if(result=="SUCCESS"){
						alert("삭제 완료");
						$("#modDiv").hide("slow");
						//getAllList();
						getPageList(replyPage);
					}
				}
			})
		});
		
		$("#replyModBtn").on("click",function(){
			var rno=$(".modal-title").html();
			var replytext=$("#replytext").val();
			
			$.ajax({
				type:"put",
				url:"/replies/"+rno,
				headers:{
					"Content-Type":"application/json",
					"X-HTTP-Method-Override":"PUT"
				},
				data:JSON.stringify({replytext:replytext}),
				dataType:"text",
				success:function(result){
					console.log("result:"+result);
					if(result=="SUCCESS"){
						alert("수정 완료");
						$("modDiv").hide("slow");
						getPageList(replyPage);
					}
				}
			});
		});
		
		$("#closeBtn").on("click",function(){
			$("#modDiv").hide("slow");
		});
		
		$(".pagination").on("click","li a",function(e){
			e.preventDefault();
			
			replyPage = $(this).attr("href");
			
			getPageList(replyPage);
		});
		
		//getAllList();
		getPageList(1);
	});
</script>
</head>
<body>
	<h2>Ajax Test Page</h2>
	
	<ul id="replies">
	</ul>
	<div>
		<div>
		Replyer: <input type="text" name="replyer" id="newReplyWriter">
		</div>
		<div>
		Reply text: <input type="text" name="replytext" id="newReplyText">
		</div>
		<button id="replyAddBtn">ADD REPLY</button>
	</div>
	<div id="modDiv" style="display:none;">
	<div class="modal-title"></div>
	<div>
		<input type="text" id="replytext">
	</div>
	<div>
		<button type="button" id="replyModBtn">Modify</button>
		<button type="button" id="replyDelBtn">delete</button>
		<button type="button" id="closeBtn">Close</button>
	</div>
	</div>
	
	<!-- 페이징 시작 -->
	<ul class="pagination">
	</ul>
	<!-- 페이징 시작 -->
</body>
</html>