<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>
<script>
	$(document).ready(function() {
		var result = '${msg}';

		if (result == 'FAIL') {
			alert("비밀번호가 일치하지 않습니다.");
		}
		
		var formObj = $("form[role='form']");

		console.log(formObj);

		$(".btn-warning").on("click", function() {
			self.location = "/board/listPage?page=${cri.page}&perPageNum=${cri.perPageNum}";
		});

		$("#checkSubmit").on("click", function() {
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
			formObj.submit();
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
					<h3 class="box-title">READ BOARD</h3>
				</div>
				<!-- /.box-header -->

<form role="form" method="post">

	<div class="box-body">

		<!-- <div class="form-group">
			<label for="exampleInputEmail1">BNO</label>
		</div> -->
		<input type="hidden"
				name='bno' class="form-control" value="${boardVO.bno}">
		<input type="hidden" name="page" class="form-control" value="${cri.page }">
		<input type="hidden" name="perPageNum" class="form-control" value="${cri.perPageNum }">
		<div class="form-group">
			<label for="exampleInputEmail1">Title</label> <input type="text"
				name='title' class="form-control" value="${boardVO.title}">
		</div>
		<div class="form-group">
			<label for="exampleInputPassword1">Content</label>
			<textarea class="form-control" name="content" rows="3">${boardVO.content}</textarea>
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Writer</label> <input
				type="text" name="writer" class="form-control"
				value="${boardVO.writer}" readonly>
		</div>
	</div>
	<!-- /.box-body -->
	
<!-- The Modal -->
<div class="modal fade" id="myModal2">
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


<div class="box-footer">
	<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal2">SAVE</button>
	<button type="submit" class="btn btn-warning">CANCEL</button>
</div>

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
