<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ include file="include/header.jsp"%>
<!-- Main Content -->
	<section class="content">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<div class="box">
					<div class="box-header with-border">
						<h3 class="box-title">HOME PAGE</h3>
					</div>
					<div class="box-body">
						<%-- <h4>${exception.getMessage() }</h4>
						<ul>
							<c:forEach items="${exception.getStackTrace() }" var="stack">
								<li>${stack.toString() }</li>
							</c:forEach>
						</ul> --%>
						<h4>지송지송 요청 페이지를 찾을수 없다능...</h4>
					</div>
				</div>
			</div>
			<!-- End. left column -->
		</div>
	</section>
	<!-- End. Main Content -->
<%@ include file="include/footer.jsp"%>