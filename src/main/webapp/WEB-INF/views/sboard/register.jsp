<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>
<style>
.fileDrop{
	width:80%;
	height:100px;
	border:1px dotted gray;
	background-color: lightslategrey;
	margin:auto;
}
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
<script type="text/javascript" src="/resources/dist/js/upload.js"></script>
<script id="template" type="text/x-handlebars-template">
<li>
	<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
	<div class="mailbox-attachment-info">
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
		<a href="{{fullName}}" class="btn btn-default btx-xs pull-right delbtn">
			<i class="fa fa-fw fa-remove"></i>
		</a>
	</div>
</li>
</script>

<script>
$(document).ready(function(){
	$("#checkSubmit").click(function(){
		if($("input[name='title']").val()==""){
			alert("제목이 빈칸입니다");
			$("input[name='title']").focus();
			return false;
		}
		if($("textarea[name='content']").val()==""){
			alert("내용이 빈칸입니다");
			$("textarea[name='content']").focus();
			return false;
		}
		if($("input[name='writer']").val()==""){
			alert("작성자가 빈칸입니다");
			$("input[name='writer']").focus();
			return false;
		}
		if($("input[name='password']").val()==""){
			alert("비밀번호를 반드시 입력하세요.");
			$("input[name='password']").focus();
			return false;
		}
		return true;
	});
	
	var template=Handlebars.compile($("#template").html());
	
	$(".fileDrop").on("dragenter dragover",function(e){
		e.preventDefault();
	});
	
	$(".fileDrop").on("drop",function(e){
		e.preventDefault();
		
		var files=e.originalEvent.dataTransfer.files;
		
		var file = files[0];
		
		var formData = new FormData();
		
		formData.append("file",file);
		
		$.ajax({
			url:"/uploadAjax",
			data:formData,
			dataType:"text",
			processData:false,
			contentType:false,
			type:"POST",
			success:function(data){
				var fileInfo=getFileInfo(data);
				
				var html = template(fileInfo);
				
				$(".uploadedList").append(html);
			}
		});
	});
	$("#registerForm").submit(function(e){
		e.preventDefault();
		
		var that = $(this);
		
		var str = "";
		
		$(".uploadedList .delbtn").each(function(index){
			str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href")+"'>";
		});
		
		that.append(str);
		
		that.get(0).submit();
	});
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

				<form role="form" method="post" id="registerForm">
					<div class="box-body">
						<div class="form-group">
							<label for="exampleInputEmail1">Title</label> 
							<input type="text"
								name='title' class="form-control title" placeholder="Enter Title">
						</div>
						<div class="form-group">
							<label for="exampleInputPassword1">Content</label>
							<textarea class="form-control content" name="content" rows="3"
								placeholder="Enter ..."></textarea>
						</div>
						<div class="form-group">
							<label for="exampleInputEmail1">Writer</label> 
							<input type="text"
								name="writer" class="form-control writer" value="${login.uid }" placeholder="Enter Writer" readonly>
						</div>
						<div class="form-group">
							<label for="exampleInputFile">File DROP Here</label>
							<div class="fileDrop"></div>
						</div>
					</div>
					<!-- /.box-body -->
				
					<div class="box-footer">
						<div><hr></div>
						<ul class="mailbox-attachments clearfix uploadedList">
						</ul>
						
						<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">Submit</button>
					</div>
					
					<!-- The Modal -->
					<div class="modal fade" id="myModal">
						<div class="modal-dialog modal-dialog-centered">
							<div class="modal-content">
					
								<!-- Modal Header -->
								<div class="modal-header">
									<h4 class="modal-title">Input Password</h4>
									<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
								</div>
					
								<!-- Modal body -->
								<div class="modal-body">
									<input type="password" name="password" class="form-control password" placeholder="Enter Password">
								</div>
					
								<!-- Modal footer -->
								<div class="modal-footer">
									<button type="submit" class="btn btn-primary" id="checkSubmit">Check</button>
									<button type="button" class="btn btn-secondary" data-dismiss="modal">Cancle</button>
								</div>
					  
							</div>
						</div>
					</div>
				</form>


			</div>
			<!-- /.box -->
		</div>
		<!--/.col (left) -->

	</div>
	<!-- /.row -->
</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<%@include file="../include/footer.jsp"%>
