package org.zerock.service;

import java.util.List;


import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.SearchCriteria;
import org.zerock.persistence.BoardDAO;
/**
 * @author 장준수
 * @since 2018.06.07
 * @version 1
 * @see 어떤 역할을 하는 클래스인지 내용을 기술
 */
@Service
public class BoardServiceImpl implements BoardService{
	
	@Inject
	private BoardDAO dao;
	
	//Transactional 적용해야 LAST_INSERT_ID()가 증가되는 bno의 값을 보장하여 처리가 가능.
	//if 없으면...?
	//-> insert되는 과정에서 LAST_INSERT_ID()가 순서를 보장하지 못하기에 default값으로 넣어버림
	//따라서, 반드시 Transactional을 걸어 LAST_INSERT_ID()가 순서를 보장하여 참조할수있도록 구성해야함.
	@Transactional
	@Override
	public void regist(BoardVO board) throws Exception {
		dao.create(board);
		
		String[] files = board.getFiles();
		
		if(files==null) return;
		
		for(String fileName:files) {
			dao.addAttach(fileName);
		}
	}
	
	@Transactional(isolation=Isolation.READ_COMMITTED)
	@Override
	public BoardVO read(Integer bno) throws Exception {
		// TODO Auto-generated method stub
		dao.updateViewCnt(bno);
		return dao.read(bno);
	}
	@Transactional
	@Override
	public void modify(BoardVO board) throws Exception {
		// TODO Auto-generated method stub
		dao.update(board);
		
		Integer bno = board.getBno();
		
		dao.deleteAttach(bno);
		
		String[] files = board.getFiles();
		
		if(files == null) return;
		
		for(String fileName: files) {
			dao.replaceAttach(fileName, bno);
		}
	}
	@Transactional
	@Override
	public void remove(Integer bno) throws Exception {
		// TODO Auto-generated method stub
		dao.deleteAttach(bno);
		dao.delete(bno);
	}

	@Override
	public List<BoardVO> listAll() throws Exception {
		// TODO Auto-generated method stub
		return dao.listAll();
	}

	@Override
	public List<BoardVO> listCriteria(Criteria cri) throws Exception {
		// TODO Auto-generated method stub
		return dao.listCriteria(cri);
	}

	@Override
	public int listCountCriteria(Criteria cri) throws Exception {
		// TODO Auto-generated method stub
		return dao.countPage(cri);
	}

	@Override
	public String checkPassword(Integer bno) throws Exception {
		// TODO Auto-generated method stub
		return dao.checkPassword(bno);
	}

	@Override
	public List<BoardVO> listSearchCriteria(SearchCriteria cri) throws Exception {
		// TODO Auto-generated method stub
		return dao.listSearch(cri);
	}

	@Override
	public int listSearchCount(SearchCriteria cri) throws Exception {
		// TODO Auto-generated method stub
		return dao.listSearchCount(cri);
	}
	@Override
	public List<String> getAttach(Integer bno) throws Exception {
		// TODO Auto-generated method stub
		return dao.getAttach(bno);
	}

}
