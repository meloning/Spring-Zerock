package org.zerock.interceptor;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;
import org.zerock.domain.UserVO;
import org.zerock.service.UserService;

public class AuthInterceptor extends HandlerInterceptorAdapter{
	private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);
	
	@Inject
	UserService service;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		
		if(session.getAttribute("login")==null) {
			logger.info("current user is not logined");
			System.out.println("current user is not logined");
			
			saveDest(request);
			
			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
			
			if(loginCookie!=null) {// session (x), cookie (o) 이전에 로그인한 적이 있는경우,
									// 쿠키에 저장된 세션값을 가지고 비교하여 사용자정보를 반환.
				UserVO userVO = service.checkLoginBefore(loginCookie.getValue());
				
				logger.info("USERVO: "+userVO);
				System.out.println("USERVO: "+userVO);
				
				if(userVO != null) {//이전에 로그인된 세션을 통해 얻은 사용자정보를 다시 세션에 세팅.
					session.setAttribute("login",userVO);
					return true;
				}
			}
			//로그인한적이 한번도 없는 경우(첫 방문자)
			response.sendRedirect("/user/login");
			return false;
		}
		//현재 로그인된 사용자인 경우
		return true;
	}
	
	private void saveDest(HttpServletRequest request) {
		String uri = request.getRequestURI();
		
		String query = request.getQueryString();
		
		if(query == null || query.equals("null")) {
			query = "";
		}else {
			query="?"+query;
		}
		
		if(request.getMethod().equals("GET")) {
			logger.info("dest: "+(uri+query));
			System.out.println("dest: "+(uri+query));
			request.getSession().setAttribute("dest", uri+query);
		}
	}
	
}
