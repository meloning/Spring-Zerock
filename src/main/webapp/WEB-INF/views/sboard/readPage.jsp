<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="../include/header.jsp"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script type="text/javascript" src="/resources/dist/js/upload.js"></script>

<style>
.popup{
	position:absolute;
}
.back{
	background-color:gray;
	opacity:0.5;
	width:100%;
	height:300%;
	overflow:hidden;
	z-index:1101;
}
.front{
	z-index:1110;
	opacity:1;
	border:1px;
	margin:auto;
}
.show{
	position:relative;
	max-width:1200px;
	max-height:800px;
	overflow:auto;
}
</style>

<script id="template" type="text/x-handlebars-template">
{{#each .}}
<li class="replyLi" data-rno={{rno}}>
<i class="fa fa-comments bg-blue"></i>
	<div class="timeline-item">
		<span class="time">
			<i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
		</span>
		<h3 class="timeline-header"><strong>{{rno}}</strong> -{{replyer}}</h3>
		<div class="timeline-body">{{replytext}}</div>
			<div class="timeline-footer">
			{{#eqReplyer replyer }}
				<a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">Modify</a>
			{{/eqReplyer}}
			</div>
	</div>
</li>
{{/each}}
</script>

<script id="templateAttach" type="text/x-handlebars-template">
<li data-src='{{fullName}}'>
	<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
	<div class="mailbox-attachment-info">
	<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
	<div>
</li>

</script>

<script>
Handlebars.registerHelper("eqReplyer",function(replyer,block){
	var accum = '';
	
	if(replyer=='${login.uid}'){
		accum+=block.fn();
	}
	
	return accum;
});

Handlebars.registerHelper("prettifyDate",function(timeValue){
	var dateObj= new Date(timeValue);
	var year = dateObj.getFullYear();
	var month = dateObj.getMonth() + 1;
	var date = dateObj.getDate();
	return year+"/"+month+"/"+date;
});

var printData = function(replyArr,target,templateObject){
	var template = Handlebars.compile(templateObject.html());
	
	var html = template(replyArr);
	$(".replyLi").remove();
	target.after(html);
}
</script>
<script>
var bno = ${boardVO.bno};
var replyPage =1;
function getPage(pageInfo){
	$.getJSON(pageInfo,function(data){
		printData(data.list,$("#repliesDiv"),$("#template"));
		printPaging(data.pageMaker,$(".pagination"));
		$("#modifyModal").modal("hide");
		$("#replycntSmall").html("["+data.pageMaker.totalCount+"]");
	});
}
var printPaging=function(pageMaker,target){
	var str="";
	
	if(pageMaker.prev){
		str+="<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
	}
	
	for(var i=pageMaker.startPage, len = pageMaker.endPage;i<=len;i++){
		var strClass=pageMaker.cri.page==i?"class='active'":"";
		str+="<li "+strClass+"><a href='"+i+"'>"+i+"</a></li>";
	}
	
	if(pageMaker.next){
		str+="<li><a href='"+(pageMaker.endPage+1)+"'> >> </a></li>";
	}
	target.html(str);
};
</script>
<script>
$(document).ready(function(){
	var result = '${msg}';
	
	if(result == 'FAIL'){
    	alert("비밀번호를 잘못입력하였습니다.")
    }
	
	var formObj=$("form[role='form']");
	var formObj2=$("form[role='form2']");
	
	console.log(formObj);
	
	$(".btn-warning").on("click",function(){
		formObj.attr("action","/sboard/modifyPage");
		formObj.attr("method","get");
		formObj.submit();
	});
	
	$("#checkSubmit").on("click",function(){
		//if(confirm("정말 삭제하시겠습니까?")){
			
			var replyCnt = $("#replycntSmall").html().replace(/[^0-9]/g,"");
			
			if(replyCnt > 0){
				alert("댓글이 달린 게시물을 삭제할 수 없습니다.");
				return;
			}
			
			var arr = [];
			$(".uploadedList li").each(function(index){
				arr.push($(this).attr("data-src"));//파일명
			});
			
			if(arr.length>0){
				$.post("/deleteAllFiles",{files:arr},function(){
					
				});
			}
			
			formObj2.attr("method","post");
			formObj2.attr("action","/sboard/removePage");
			formObj2.submit();
		//}
	});
	
	$(".list").on("click",function(){
		//self.location="/board/listAll";
		formObj.attr("method","get");
		formObj.attr("action","/sboard/list");
		formObj.submit();
	});
	
	$("#repliesDiv").on("click",function(){
		if($(".timeline li").size()>1){
			return;
		}
		getPage("/replies/"+bno+"/1");
	});
	
	$(".pagination").on("click","li a",function(e){
		e.preventDefault();
		
		replyPage=$(this).attr("href");
		
		getPage("/replies/"+bno+"/"+replyPage);
	});
	
	$("#replyAddBtn").on("click",function(){
		var replyerObj = $("#newReplyWriter");
		var replytextObj = $("#newReplyText");
		var replyer = replyerObj.val();
		var replytext = replytextObj.val();
		
		$.ajax({
			type:"post",
			url:"/replies/",
			headers:{
				"Content-Type":"application/json",
				"X-HTTP-Method-Override":"POST"
			},
			dataType:"text",
			data:JSON.stringify({bno:bno, replyer:replyer, replytext:replytext}),
			success:function(result){
				console.log("result:"+result);
				if(result=="SUCCESS"){
					alert("등록 완료.");
					replyPage=1;
					getPage("/replies/"+bno+"/"+replyPage);
					replyerObj.val("");
					replytextObj.val("");
				}
			}
		});
	});
	
	$(".timeline").on("click",".replyLi",function(e){
		var reply=$(this);
		
		$("#replytext").val(reply.find(".timeline-body").text());
		$(".modal-title").html(reply.attr("data-rno"));
	});
	
	$("#replyModBtn").on("click",function(){
		var rno = $(".modal-title").html();
		var replytext = $("#replytext").val();
		
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
				if(result == "SUCCESS"){
					alert("수정 완료");
					getPage("/replies/"+bno+"/"+replyPage);
				}
			}
		});
	});
	
	$("#replyDelBtn").on("click",function(){
		var rno=$(".modal-title").html();
		var replytext = $("#replytext").val();
		
		$.ajax({
			type:"delete",
			url:"/replies/"+rno,
			headers:{
				"Content-Type":"application/json",
				"X-HTTP-Method-Override":"DELETE"
			},
			dataType:"text",
			success:function(result){
				console.log("result:"+result);
				if(result == "SUCCESS"){
					alert("삭제 완료");
					getPage("/replies/"+bno+"/"+replyPage);
				}
			}
		})
	});
	
	var template = Handlebars.compile($("#templateAttach").html());
	
	$.getJSON("/sboard/getAttach/"+bno,function(list){
		$(list).each(function(){
			var fileInfo = getFileInfo(this);
			
			var html = template(fileInfo);
			
			$(".uploadedList").append(html);
		});
	});
	
	$(".uploadedList").on("click",".mailbox-attachment-info a",function(e){
		var fileLink = $(this).attr("href");
		
		if(checkImageType(fileLink)){
			e.preventDefault();
			
			var imgTag=$("#popup_img");
			imgTag.attr("src",fileLink);
			
			console.log(imgTag.attr("src"));
			
			$(".popup").show("slow");
			imgTag.addClass("show");
		}
	});
	
	$("#popup_img").on("click",function(){
		$(".popup").hide("slow");
	})
});
</script>
<!-- Main content -->
<section class="content">
	<div class="row">
		<!-- left column -->
		<div class="col-md-12">
			<!-- general form elements -->
			<div class="box box-primary">
				<div class="box-header">
					<h3 class="box-title">REGISTER BOARD</h3>
				</div>
				<!-- /.box-header -->
				
				<!-- popup -->
				<div class="popup back" style="display:none;"></div>
				<div id="popup_front" class="popup front" style="display:none;">
					<img id="popup_img">
				</div>
				<!-- /.popup -->
				
				<form role="form" method="post">
					<input type="hidden" name="bno" value="${boardVO.bno }">
					<input type="hidden" name="page" value="${cri.page }">
					<input type="hidden" name="perPageNum" value="${cri.perPageNum }">
					<input type="hidden" name="searchType" value="${cri.searchType }">
					<input type="hidden" name="keyword" value="${cri.keyword }">
				</form>
				
				
				<div class="box-body">
					<div class="form-group">
						<label for="exampleInputTitle1">Title</label>
						<input type="text" name="title" class="form-control" value="${boardVO.title }" readonly>
					</div>
					<div class="form-group">
						<label for="exampleInputContent1">Content</label>
						<textarea name="content" class="form-control" rows="3" readonly>${boardVO.content }</textarea>
					</div>
					<div class="form-group">
						<label for="exampleInputWirter1">Writer</label>
						<input type="text" name="writer" class="form-control" value="${boardVO.writer }" readonly>
					</div>
				</div>
				<!-- /.box-body -->
				
				<div class="box-footer">
					<ul class="mailbox-attachments clearfix uploadedList">
					</ul>
					<c:if test="${login.uid == boardVO.writer }">
						<button type="submit" class="btn btn-warning">MODIFY</button>
						<button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModal3">REMOVE</button>
					</c:if>
					<button type="submit" class="btn btn-primary list">LIST ALL</button>
				</div>
				<!-- The Modal -->
				<div class="modal fade" id="myModal3">
					<div class="modal-dialog modal-dialog-centered">
						<div class="modal-content">
				
							<!-- Modal Header -->
							<div class="modal-header">
								<h4 class="modal-title">Input Password</h4>
								<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
							</div>
				
							<!-- Modal body -->
							<div class="modal-body">
							<form role="form2" method="post">
								<input type="hidden" name="bno" value="${boardVO.bno }">
								<input type="hidden" name="page" value="${cri.page }">
								<input type="hidden" name="perPageNum" value="${cri.perPageNum }">
								<input type="hidden" name="searchType" value="${cri.searchType }">
								<input type="hidden" name="keyword" value="${cri.keyword }">
								<input type="password" name="password" class="form-control password" placeholder="Enter Password">
							</form>
							</div>
				
							<!-- Modal footer -->
							<div class="modal-footer">
								<button type="submit" class="btn btn-primary" id="checkSubmit">Check</button>
								<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancle</button>
							</div>
				  
						</div>
					</div>
				</div>
				
			</div>
			<!-- /.box -->
		</div>
		<!--/.col (left) -->

	</div>
	<!-- /.row -->
	
	<!-- /row -->
	<div class="row">
		<!-- /col -->
		<div class="col-md-12">
			<!-- /box-success -->
			<div class="box box-success">
				<div class="box-header">
					<h3 class="box-title">ADD NEW REPLY</h3>
				</div>
				<c:if test="${not empty login }">
					<!-- /box-body -->
					<div class="box-body">
						<label for="newReplyWriter">Writer</label>
						<input type="text" class="form-control" placeholder="USER ID" value="${login.uid }" id="newReplyWriter" readonly>
						<label for="newReplyText">ReplyText</label>
						<input type="text" class="form-control" placeholder="REPLY TEXT" id="newReplyText">
					</div>
					<!-- /.box-body -->
					<div class="box-footer">
						<button type="submit" class="btn btn-primary" id="replyAddBtn">ADD REPLY</button>
					</div>
				</c:if>
				<c:if test="${empty login }">
					<!-- /box-body -->
					<div class="box-body">
						<div><a href="javascript:goLogin();" class="btn btn-default">Login Please</a></div>
					</div>
				</c:if>
			</div>
			<!-- /.box-success -->
			<!-- The time line -->
			<ul class="timeline">
				<!-- timeline time label -->
				<li class="time-label" id="repliesDiv">
					<span class="bg-green">Replies List<small id="replycntSmall">[${boardVO.replycnt}]</small></span>
				</li>
			</ul>
			<div class="text-center">
				<ul id="pagination" class="pagination pagination-sm no-margin">
				
				</ul>
			</div>
			
		</div>
		<!-- /.col -->
	</div>
	<!-- /.row -->
	
	<!-- Modal -->
	<div id="modifyModal" class="modal modal-primary fade" role="dialog">
		<div class="modal-dialog">
			<!-- Modal Content -->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title"></h4>
				</div>
				<div class="modal-body" data-rno>
					<p><input type="text" id="replytext" class="form-control"></p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-info" id="replyModBtn">Modify</button>
					<button type="button" class="btn btn-danger" id="replyDelBtn">Delete</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
			<!-- /.Modal Content -->
		</div>
	</div>
	<!-- /.Modal -->
</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<%@include file="../include/footer.jsp"%>
