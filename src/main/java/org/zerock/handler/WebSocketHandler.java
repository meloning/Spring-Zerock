package org.zerock.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.zerock.domain.UserVO;

public class WebSocketHandler extends TextWebSocketHandler{
	private static Logger logger = LoggerFactory.getLogger(WebSocketHandler.class);
	
	private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	/**
     * 클라이언트 연결 이후에 실행되는 메소드
     */
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		
		sessionList.add(session);

        logger.info("{} 연결됨", session.getId());
        
	}
	/**
     * 클라이언트가 웹소켓서버로 메시지를 전송했을 때 실행되는 메소드
     */
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		
		 Map<String,Object> map = session.getAttributes();
		 System.out.println(map.toString());
		 //System.out.println(session.getAttributes());
		 String userId = ((UserVO)map.get("login")).getUname();
		 System.out.println("로그인 한 아이디 : " + userId);
		 logger.info("{}로 부터 {} 받음", session.getId(), message.getPayload());

	        for(WebSocketSession sess : sessionList){

	            sess.sendMessage(new TextMessage(userId +" : "+ message.getPayload()));

	        }

	}
	/**
     * 클라이언트가 연결을 끊었을 때 실행되는 메소드
     */
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		
		sessionList.remove(session);

        logger.info("{} 연결 끊김", session.getId());
		
	}
	
}
