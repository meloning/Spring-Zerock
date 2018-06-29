package org.zerock.domain;

public class Criteria {
	private int page;
	private int perPageNum;
	
	public Criteria() {
		this.page=1;
		this.perPageNum=10;
	}
	public Criteria(int page, int perPageNum) {
		super();
		this.page = 1;
		this.perPageNum = 10;
	}
	
	

	public int getPage() {
		return page;
	}
	
	
	//method for MyBatis SQL Mapper -
	public int getPageStart() {
		return(this.page-1)*perPageNum;
	}

	
	public void setPage(int page) {
		this.page = page;
	}


	//method for MyBatis SQL Mapper -
	public int getPerPageNum() {
		return this.perPageNum;
	}



	public void setPerPageNum(int perPageNum) {
		if(perPageNum<=0||perPageNum>100) {
			this.perPageNum=10;
			return;
		}
		this.perPageNum = perPageNum;
	}



	@Override
	public String toString() {
		return "Criteria [page=" + page + ", perPageNum=" + perPageNum + "]";
	}
	
	
}
