<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>
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
			formObj.attr("action","/board/modifyPage");
			formObj.attr("method","get");
			formObj.submit();
		});
		
		$("#checkSubmit").on("click",function(){
			//if(confirm("정말 삭제하시겠습니까?")){
				formObj2.attr("method","post");
				formObj2.attr("action","/board/removePage");
				formObj2.submit();
			//}
		});
		
		$(".list").on("click",function(){
			//self.location="/board/listAll";
			formObj.attr("method","get");
			formObj.attr("action","/board/listPage");
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
					<h3 class="box-title">REGISTER BOARD</h3>
				</div>
				<!-- /.box-header -->

				<form role="form" method="post">
					<input type="hidden" name="bno" value="${boardVO.bno }">
					<input type="hidden" name="page" value="${cri.page }">
					<input type="hidden" name="perPageNum" value="${cri.perPageNum }">
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
					<button type="submit" class="btn btn-warning">MODIFY</button>
					<button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModal3">REMOVE</button>
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
</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<%@include file="../include/footer.jsp"%>
