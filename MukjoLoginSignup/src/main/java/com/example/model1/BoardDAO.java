package com.example.model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDAO {
	
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private DataSource dataSource;
	
	public ArrayList<BoardTO> noticeList() {
		
		String sql = "select subject, member.name as writer, date_format(wdate, '%Y-%m-%d') wdate, hit from board inner join member on board.seq = member.seq where tseq = 1 order by bseq desc";
		ArrayList<BoardTO> noticeLists = (ArrayList)jdbcTemplate.query(sql, new BeanPropertyRowMapper<BoardTO>(BoardTO.class));
		
		return noticeLists;
	}
	
	public BoardListTO boardList(BoardListTO listTO) {

		
		int cpage = listTO.getCpage();
		int recordPerPage = listTO.getRecordPerPage();
		int blockPerPage = listTO.getBlockPerPage();
		
		int skip = (cpage -1)* recordPerPage;
			
			String sql = "select bseq, member.name as writer, subject, date_format(wdate, '%Y-%m-%d') wdate, hit from board inner join member on board.seq = member.seq where tseq = ? order by bseq desc limit ?,20";
			ArrayList<BoardTO> lists = (ArrayList)jdbcTemplate.query(sql, new BeanPropertyRowMapper<BoardTO>(BoardTO.class),listTO.getTseq(),skip);

			sql = "select count(*) from board inner join member on board.seq = member.seq where tseq=?";
			
			int totalRecord = jdbcTemplate.queryForObject(sql,int.class,listTO.getTseq());

			listTO.setTotalRecord( totalRecord );

			
			listTO.setTotalPage( ( ( listTO.getTotalRecord() -1 ) / recordPerPage ) + 1 );

			
			listTO.setBoardLists( lists );
			
			listTO.setStartBlock( ( ( cpage -1 ) / blockPerPage ) * blockPerPage + 1 );
			listTO.setEndBlock( ( ( cpage -1 ) / blockPerPage ) * blockPerPage + blockPerPage );
			if( listTO.getEndBlock() >= listTO.getTotalPage() ) {
				listTO.setEndBlock( listTO.getTotalPage() );
			}

		
		return listTO;

	}
	
	public int boardWriteOk(BoardTO bto) {	

		
		String sql = "insert into board values ( 0, ?, ?, ?, ?, ?, ?, now(), 0)";
		
		int flag = jdbcTemplate.update(sql,bto.getTseq(),bto.getSeq(),bto.getSubject(),bto.getContent(),bto.getFilename(),bto.getFilesize());
		

		
		return flag;
	}
	
	// Board Insert sql :  insert into board values  ( 0, 2, 3, 'test', 'test content' ,'','',now(),0 );
	
	//관리자페이지 - 공지 - 페이징
	public BoardListTO noticeList(BoardListTO boardListTO) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		int cpage=boardListTO.getCpage();
		int recordPerPage=boardListTO.getRecordPerPage();
		int blockPerPage=boardListTO.getBlockPerPage();

		try {
			conn=this.dataSource.getConnection();

			String sql="select bseq, subject, member.name as writer, date_format(wdate, '%Y-%m-%d %H:%i') wdate, hit from board inner join member on board.seq = member.seq where tseq = 1 order by bseq desc";
			pstmt=conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs=pstmt.executeQuery();

			rs.last(); //읽기 커서를 맨 마지막 행으로 이동
			boardListTO.setTotalRecord(rs.getRow());
			rs.beforeFirst(); //읽기 커서를 맨 첫행으로 이동

			//전체 페이지
			boardListTO.setTotalPage((boardListTO.getTotalRecord()-1)/recordPerPage+1);

			//시작번호 - 읽을 데이터 위치 지정
			int skip=(cpage-1)*recordPerPage;
			if (skip!=0) rs.absolute(skip); //커서를 주어진 행으로 이동

			ArrayList<BoardTO> boardLists=new ArrayList<BoardTO>();
			for (int i=0;i<recordPerPage && rs.next();i++) {
				BoardTO to=new BoardTO();
				to.setBseq(rs.getString("bseq"));
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
				to.setWdate(rs.getString("wdate"));
				to.setHit(rs.getString("hit"));

				boardLists.add(to);
			}
			boardListTO.setBoardLists(boardLists);
			boardListTO.setStartBlock((cpage-1)/blockPerPage*blockPerPage+1);
			boardListTO.setEndBlock((cpage-1)/blockPerPage*blockPerPage+blockPerPage);
			if (boardListTO.getEndBlock()>=boardListTO.getTotalPage()) {
				boardListTO.setEndBlock(boardListTO.getTotalPage());
			}
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try {conn.close();} catch (SQLException e) {}
			if (pstmt!=null) try {pstmt.close();} catch (SQLException e) {}
			if (rs!=null) try {rs.close();} catch (SQLException e) {}
		}
		return boardListTO;
	}
	
	//공지 쓰기
	public int noticeWriteOk(BoardTO to) {
		Connection conn=null;
		PreparedStatement pstmt=null;

		int flag=1;
		try {
			conn=this.dataSource.getConnection();

			String sql="insert into board values (0,1,1,?,?,?,?,now(),0)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSubject());
			pstmt.setString(2, to.getContent());
			pstmt.setString(3, to.getFilename());
			pstmt.setLong(4, to.getFilesize());
			if(pstmt.executeUpdate() == 1) {
				flag = 0;
			}
		} catch(SQLException e) {
			System.out.println("[에러]: " + e.getMessage());
		} finally {
			if(pstmt != null) try{ pstmt.close(); } catch(SQLException e) {}
			if(conn != null) try{ conn.close(); } catch(SQLException e) {}
		}
			
		return flag;
	}
	
	//공지 view
	public BoardTO noticeView(BoardTO to) { 
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			conn=this.dataSource.getConnection();
			
			//조회수 증가
			String sql="update board set hit=hit+1 where bseq=?;";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,to.getBseq());
			rs=pstmt.executeQuery();
			
			//본문 조회
			sql="select bseq, subject, member.name as writer, content, filename, date_format(wdate, '%Y-%m-%d %H:%i') wdate, hit from board inner join member on board.seq = member.seq where tseq = 1 and bseq = ?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,to.getBseq());
			rs=pstmt.executeQuery();
			
			if (rs.next()) {
				to.setBseq(rs.getString("bseq"));			
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
				to.setWdate(rs.getString("wdate"));
				to.setHit(rs.getString("hit"));
				to.setContent(rs.getString("content") ==null ? "" : rs.getString("content").replaceAll("\n", "<br />"));
				to.setFilename(rs.getString("filename"));
				to.setFile("<a href='../../upload/"+rs.getString("filename")+"'>"+rs.getString("filename")+"</a>");
			}
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try{conn.close();} catch (SQLException e) {}
			if (pstmt!=null) try{pstmt.close();} catch (SQLException e) {}
			if (rs!=null) try{rs.close();} catch (SQLException e) {}
		}
		return to;
	}
}