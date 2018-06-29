package org.zerock.test;

import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.persistence.ReplyDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
		locations= {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
public class ReplyDAOTest {
	
	@Inject
	private ReplyDAO dao;
	
	private static Logger logger = LoggerFactory.getLogger(ReplyDAOTest.class);
	
	//@Test
	public void testInsert() throws Exception{
		ReplyVO vo = new ReplyVO();
		vo.setBno(5);
		vo.setReplytext("테스트중");
		vo.setReplyer("테스터");
		
		dao.create(vo);
	}
	
	//@Test
	public void testUpdate() throws Exception{
		ReplyVO vo =new ReplyVO();
		vo.setReplytext("테스트수정중");
		vo.setRno(5);
		
		dao.update(vo);
	}
	
	//@Test
	public void testDelete() throws Exception{
		dao.delete(5);
	}
	
	//@Test
	public void testSelect() throws Exception{
		dao.list(5);
	}
	
	//@Test
	public void testListPage() throws Exception{
		Criteria cri = new Criteria();
		cri.setPage(1);
		cri.setPerPageNum(10);
		
		dao.listPage(5, cri);
	}
	
	//@Test
	public void testCount() throws Exception{
		dao.count(5);
	}
}
