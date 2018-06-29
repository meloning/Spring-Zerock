package org.zerock.test;

import java.util.List;

import javax.inject.Inject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.SearchCriteria;
import org.zerock.persistence.BoardDAO;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
		locations= {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
public class BoardDAOTest {
	
	@Inject
	private BoardDAO dao;
	
	private static Logger logger = LoggerFactory.getLogger(BoardDAOTest.class);
	
	//@Test
	public void testCreate() throws Exception{
		BoardVO board = new BoardVO();
		board.setTitle("새로운 글 등록");
		board.setContent("새로운 내용 등록");
		board.setWriter("user14");
		dao.create(board);
	}
	
	//@Test
	public void testRead() throws Exception{
		logger.info(dao.read(13).toString());
	}
	
	//@Test
	public void testUpdate() throws Exception{
		BoardVO board = new BoardVO();
		board.setBno(13);
		board.setTitle("수정된 제목2");
		board.setContent("수정 테스트2");
		dao.update(board);
	}
	
	//@Test
	public void testDelete() throws Exception{
		dao.delete(11);
		dao.delete(12);
	}
	
	//@Test
	public void testListPage() throws Exception{
		int page=3;
		List<BoardVO> list = dao.listPage(page);
		for(BoardVO vo : list) {
			logger.info(vo.getBno()+":"+vo.getTitle());
		}
	}
	
	//@Test
	public void testListCriteria() throws Exception{
		Criteria cri = new Criteria();
		cri.setPage(2);
		cri.setPerPageNum(20);
		
		List<BoardVO> list = dao.listCriteria(cri);
		
		for(BoardVO vo : list) {
			logger.info(vo.getBno()+":"+vo.getTitle());
		}
	}
	
	//@Test
	public void testURI() throws Exception{
		UriComponents uriComponents = 
				UriComponentsBuilder.newInstance()
				.path("/{module}/{page}")
				.queryParam("bno", 12)
				.queryParam("perPageNum", 20)
				.build()
				.expand("board","read")
				.encode();
		
		logger.info("/board/read?bno=12&perPageNum=20");
		logger.info(uriComponents.toString());
	}
	
	@Test
	public void testSearch() throws Exception{
		SearchCriteria cri = new SearchCriteria();
		cri.setPage(1);
		cri.setKeyword("test6");
		cri.setSearchType("tc");
		
		logger.info("=============================================");
		
		List<BoardVO> list = dao.listSearch(cri);
		
		for(BoardVO vo : list) {
			logger.info(vo.getBno()+":"+vo.getTitle());
		}
		
		logger.info("=============================================");
		
		logger.info("COUNT: "+dao.listSearchCount(cri));
	}
	
}
