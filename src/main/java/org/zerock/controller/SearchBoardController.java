package org.zerock.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.PageMaker;
import org.zerock.domain.SearchCriteria;
import org.zerock.service.BoardService;

@Controller
@RequestMapping("/sboard/*")
public class SearchBoardController {
	private static final Logger logger = LoggerFactory.getLogger(SearchBoardController.class);
	
	@Inject
	private BoardService service;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public void listPage(@ModelAttribute("cri") SearchCriteria cri,Model model) throws Exception{
		logger.info(cri.toString());
		
		//model.addAttribute("list",service.listCriteria(cri));
		model.addAttribute("list",service.listSearchCriteria(cri));
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		
		//pageMaker.setTotalCount(service.listCountCriteria(cri));
		pageMaker.setTotalCount(service.listSearchCount(cri));
		
		model.addAttribute("pageMaker",pageMaker);
	}
	
	@RequestMapping(value="/readPage",method=RequestMethod.GET)
	public void read(@RequestParam("bno") int bno, @ModelAttribute("cri") SearchCriteria cri,Model model)throws Exception{
		model.addAttribute(service.read(bno));
	}
	
	@RequestMapping(value="/removePage",method=RequestMethod.POST)
	public String remove(BoardVO board, SearchCriteria cri, RedirectAttributes rttr)throws Exception{
		logger.info("remove post.....");
		
		String checkpass=service.checkPassword(board.getBno());
		logger.info(checkpass+":"+board.getPassword());
		
		rttr.addAttribute("page",cri.getPage());
		rttr.addAttribute("perPageNum",cri.getPerPageNum());
		rttr.addAttribute("searchType",cri.getSearchType());
		rttr.addAttribute("keyword",cri.getKeyword());
		
		if(!checkpass.equals(board.getPassword())) {
			rttr.addFlashAttribute("msg","FAIL");
			return "redirect:/sboard/readPage?bno="+board.getBno();
		}else {
			service.remove(board.getBno());
			int totalCount=service.listSearchCount(cri);
			if(totalCount%cri.getPerPageNum()==0) {
				if(totalCount<=10) {
					cri.setPage(1);
				}else {
					cri.setPage(cri.getPage()-1);
				}
			}
			
			
			rttr.addFlashAttribute("msg","SUCCESS");
		}
		
		return "redirect:/sboard/list";
	}
	
	@RequestMapping(value="/modifyPage",method=RequestMethod.GET)
	public void modifyPageGET(int bno,@ModelAttribute("cri")SearchCriteria cri, Model model)throws Exception{
		model.addAttribute(service.read(bno));
	}
	
	@RequestMapping(value="/modifyPage",method=RequestMethod.POST)
	public String modifyPagePOST(BoardVO board,SearchCriteria cri,RedirectAttributes rttr)throws Exception{
		logger.info("modPage post.....");
		logger.info(cri.toString());
		
		String checkpass=service.checkPassword(board.getBno());
		logger.info(checkpass+":"+board.getPassword());
		
		rttr.addAttribute("page",cri.getPage());
		rttr.addAttribute("perPageNum",cri.getPerPageNum());
		rttr.addAttribute("searchType",cri.getSearchType());
		rttr.addAttribute("keyword",cri.getKeyword());
		
		if(!checkpass.equals(board.getPassword())) {
			
			rttr.addFlashAttribute("msg","FAIL");
			return "redirect:/sboard/modifyPage?bno="+board.getBno();
		}
		
		service.modify(board);
		rttr.addFlashAttribute("msg","SUCCESS");
		
		logger.info(rttr.toString());
		
		return "redirect:/sboard/list";
	}
	
	@RequestMapping(value="/register",method=RequestMethod.GET)
	public void registerGET() throws Exception{
		logger.info("regist get......");
	}
	
	@RequestMapping(value="/register",method=RequestMethod.POST)
	public String registPOST(BoardVO board,RedirectAttributes rttr)throws Exception{
		logger.info("regist post.....");
		logger.info(board.toString());
		
		service.regist(board);
		
		rttr.addFlashAttribute("msg","SUCCESS");
		return "redirect:/sboard/list";
	}
	
	@RequestMapping("/getAttach/{bno}")
	@ResponseBody
	public List<String> getAttach(@PathVariable("bno") Integer bno) throws Exception{
		return service.getAttach(bno);
	}
}
