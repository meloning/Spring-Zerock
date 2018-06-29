package org.zerock.domain;
/**
 * @author junsu
 * @since 2018.06.09
 * @see User Table에 대응하는 VO
 */
public class UserVO {
	private String uid;
	private String upw;
	private String uname;
	private int upoint;
	public String getUid() {
		return uid;
	}
	public void setUid(String uid) {
		this.uid = uid;
	}
	public String getUpw() {
		return upw;
	}
	public void setUpw(String upw) {
		this.upw = upw;
	}
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
	}
	public int getUpoint() {
		return upoint;
	}
	public void setUpoint(int upoint) {
		this.upoint = upoint;
	}
	@Override
	public String toString() {
		return "UserVO [uid=" + uid + ", upw=" + upw + ", uname=" + uname + ", upoint=" + upoint + "]";
	}
	
	
}
