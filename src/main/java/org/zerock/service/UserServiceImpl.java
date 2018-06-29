package org.zerock.service;

import java.sql.Date;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.zerock.domain.LoginDTO;
import org.zerock.domain.UserVO;
import org.zerock.persistence.UserDAO;
@Service
public class UserServiceImpl implements UserService{
	@Inject
	private UserDAO dao;
	
	@Inject
	private BCryptPasswordEncoder passwordEncoder;
	
	private static Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);
	
	@Override
	public UserVO login(LoginDTO dto) throws Exception {
		// TODO Auto-generated method stub
		String notencPass = dto.getUpw();
		String encPass = dao.getUserPass(dto.getUid());
		
		if(passwordEncoder.matches(notencPass, encPass)) {
			logger.info("비밀번호 일치");
			dto.setUpw(encPass);
		}else {
			logger.info("비밀번호 불일치");
		}
		return dao.login(dto);
	}

	@Override
	public void keepLogin(String uid, String sessionId, Date next) throws Exception {
		// TODO Auto-generated method stub
		dao.keepLogin(uid, sessionId, next);
	}

	@Override
	public UserVO checkLoginBefore(String value) {
		// TODO Auto-generated method stub
		return dao.checkUserWithSessionKey(value);
	}

	@Override
	public void memberRegister(UserVO userVO) throws Exception{
		// TODO Auto-generated method stub
		String encPass = passwordEncoder.encode(userVO.getUpw());
		userVO.setUpw(encPass);
		 
		
		dao.memberRegister(userVO);
	}

}
