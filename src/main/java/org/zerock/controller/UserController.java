package org.zerock.controller;

import java.sql.Date;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;
import org.zerock.domain.LoginDTO;
import org.zerock.domain.UserVO;
import org.zerock.service.UserService;
import org.zerock.test.UserDAOTest;

@Controller
@RequestMapping("/user")
public class UserController {
	@Inject
	private UserService service;
	
	private Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public void loginGET(@ModelAttribute("dto") LoginDTO dto) {
		
	}
	
	@RequestMapping(value="/loginPost",method=RequestMethod.POST)
	public void loginPOST(LoginDTO dto, HttpSession session, Model model)throws Exception{
		UserVO vo = service.login(dto);
		System.out.println("vo:"+vo);	
		if(vo==null) {
			return;
		}
		
		model.addAttribute("userVO",vo);
		
		if(dto.isUseCookie()) {
			int amount = 60*60*24*7;
			
			Date sessionLimit = new Date(System.currentTimeMillis()+(1000*amount));
			
			service.keepLogin(vo.getUid(), session.getId(), sessionLimit);
		}
	}
	
	@RequestMapping(value="/logout",method=RequestMethod.GET)
	public String logout(HttpServletRequest request,HttpServletResponse response,HttpSession session)throws Exception{
		
		Object obj = session.getAttribute("login");
		
		if(obj != null) {
			UserVO vo = (UserVO)obj;
			
			session.removeAttribute("login");
			session.invalidate();
			
			Cookie loginCookie = WebUtils.getCookie(request, "loginCookie");
			
			if(loginCookie != null) {
				loginCookie.setPath("/");
				loginCookie.setMaxAge(0);
				response.addCookie(loginCookie);
				service.keepLogin(vo.getUid(), session.getId(), new Date(System.currentTimeMillis()+1000));
			}
		}
		
		return "user/logout";
	}
	
	@RequestMapping(value="/memberRegister",method=RequestMethod.GET)
	public void memberRegisterGET() {
		
	}
	
	@RequestMapping(value="/memberRegisterPOST",method=RequestMethod.POST)
	public String memberRegisterPOST(UserVO userVO, RedirectAttributes rttr) throws Exception{
		service.memberRegister(userVO);
		logger.info("Member Info Insert Success!!");
		rttr.addFlashAttribute("msg","SUCCESS");
		return "redirect:/user/login";
	}
}
