package com.example.model1;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class CommentDAO {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
	public int commentWrite(CommentTO cto) {
		String sql = "insert into boardcmt values (0,?,?,?,now())";
		
		int flag = jdbcTemplate.update(sql,cto.getBseq(),cto.getSeq(),cto.getCContent());
		
		return flag;
	}
}
