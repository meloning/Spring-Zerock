package org.zerock.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.SampleVO;

@RestController
@RequestMapping("/sample")
public class SampleController {

	//문자열을 리턴 -> HTML Type으로 출력
	@RequestMapping("/hello")
	public String sayHello() {
		return "Hello World!";
	}
	
	//객체를 리턴 -> JSON형태로 출력 (1건)
	@RequestMapping("/sendVO")
	public SampleVO sendVO() {
		SampleVO vo = new SampleVO();
		vo.setFirstName("길동");
		vo.setLastName("홍");
		vo.setMno(123);
		return vo;
	}
	
	//컬렉션 타입 리턴 -> List형태로 출력 (여러건)
	@RequestMapping("/sendList")
	public List<SampleVO> sendList(){
		
		List<SampleVO> list = new ArrayList<>();
		for(int i=0;i<10;i++) {
			SampleVO vo =new SampleVO();
			vo.setFirstName("길동");
			vo.setLastName("홍");
			vo.setMno(i);
			list.add(vo);
		}
		return list;
	}
	
	//컬렉션 타입 리턴 -> Map형태로 출력 (여러건)
	@RequestMapping("/sendMap")
	public Map<Integer,SampleVO> sendMap(){
		Map<Integer,SampleVO> map = new HashMap();
		
		for(int i=0;i<10;i++) {
			SampleVO vo = new SampleVO();
			vo.setFirstName("길동");
			vo.setLastName("홍");
			vo.setMno(i);
			map.put(i, vo);
		}
		return map;
	}
}
