package org.zerock.test;

import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.UserVO;
import org.zerock.persistence.UserDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
		locations= {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
public class UserDAOTest {
	@Inject
	private UserDAO dao;
	
	private Logger logger = LoggerFactory.getLogger(UserDAOTest.class);
	
	//@Test
	/*public void testInsert() throws Exception{
		UserVO userVO = new UserVO();
		userVO.setUid("asdf");
		//userVO.setUpw(passwordEncodertest.encode("asdf"));
		userVO.setUname("asdf");
		logger.info(userVO.getUpw());
		
		dao.memberRegister(userVO);
		
	}*/
	
	@Test
	public void testSelect() throws Exception{
		//logger.info(dao.getUserPass("asdf"));
		System.out.println(dao.getUserPass("asdf"));
	}
}
