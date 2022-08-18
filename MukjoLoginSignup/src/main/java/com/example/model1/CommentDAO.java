package com.example.model1;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
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
	
	public ArrayList<CommentTO> commentView(String bseq) {
		
		String sql = "select cseq,boardcmt.seq, member.name as writer, bseq,ccontent,cdate from boardcmt inner join member on boardcmt.seq = member.seq where bseq = ? order by cseq desc ";
		ArrayList<CommentTO> commentLists = (ArrayList)jdbcTemplate.query(sql, new BeanPropertyRowMapper<CommentTO>(CommentTO.class),bseq);
		
		return commentLists;
	}
	
	public int commentDelete(CommentTO cto) {

		String sql = "delete from boardcmt where cseq=?";		
		
		int flag = jdbcTemplate.update(sql, cto.getCseq());

		
		return flag;
	}
}
