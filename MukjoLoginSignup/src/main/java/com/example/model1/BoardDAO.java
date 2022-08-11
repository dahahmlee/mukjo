package com.example.model1;

import java.io.File;
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
	private String uploadPath="C:\\Users\\JungGyuJin\\Desktop\\mukjo_project\\git\\mukjo\\MukjoLoginSignup\\src\\main\\webapp\\upload";
	
	public ArrayList<BoardTO> noticeList() {
		
		String sql = "select subject, member.name as writer, date_format(wdate, '%Y-%m-%d') wdate, hit from board inner join member on board.seq = member.seq where tseq = 1 order by bseq desc";
		ArrayList<BoardTO> noticeLists = (ArrayList)jdbcTemplate.query(sql, new BeanPropertyRowMapper<BoardTO>(BoardTO.class));
		
		return noticeLists;
	}
	
	public BoardListTO boardList(BoardListTO listTO) {
		
		ArrayList<BoardTO> noticeLists = this.noticeList();
		
		int cpage = listTO.getCpage();
		int recordPerPage = listTO.getRecordPerPage();
		
		recordPerPage = listTO.getRecordPerPage();
		
		
		int blockPerPage = listTO.getBlockPerPage();
		
		int skip = (cpage -1)* recordPerPage;
			String sql = "";
			
			ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
			if (cpage == 1) {
			sql = "select bseq, member.name as writer, subject, date_format(wdate, '%Y-%m-%d') wdate, hit from board inner join member on board.seq = member.seq where tseq = ? order by bseq desc limit ?,?";
			lists = (ArrayList)jdbcTemplate.query(sql, new BeanPropertyRowMapper<BoardTO>(BoardTO.class),listTO.getTseq(),skip,recordPerPage - noticeLists.size());
			} else {
				sql = "select bseq, member.name as writer, subject, date_format(wdate, '%Y-%m-%d') wdate, hit from board inner join member on board.seq = member.seq where tseq = ? order by bseq desc limit ?,?";
			lists = (ArrayList)jdbcTemplate.query(sql, new BeanPropertyRowMapper<BoardTO>(BoardTO.class),listTO.getTseq(),skip,recordPerPage);	
				
			}
			
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
	
	public BoardTO boardView(BoardTO to) {

		
		String sql = "update board set hit=hit+1 where bseq=?";
		jdbcTemplate.update(sql,to.getBseq());

		
		sql = "select bseq,tseq, subject, member.seq, member.name as writer, wdate, hit, content, filename, filesize from board inner join member on board.seq = member.seq where bseq=?";
		to = jdbcTemplate.queryForObject(sql,new RowMapper<BoardTO>()  {
			
					@Override
					public BoardTO mapRow(ResultSet rs, int rowNum) throws SQLException {
						BoardTO to2 = new BoardTO();
						to2.setBseq(rs.getString("bseq"));
						to2.setTseq(rs.getString("tseq"));
						to2.setSubject(rs.getString("subject"));
						to2.setSeq(rs.getString("member.seq"));
						to2.setWriter(rs.getString("writer"));
						to2.setWdate(rs.getString("wdate"));
						to2.setHit(rs.getString("hit"));
						to2.setContent(rs.getString("content") == null ? "" : rs.getString("content").replaceAll("\n","</br>"));
						to2.setFilename(rs.getString("filename"));
						to2.setFilesize(rs.getLong("filesize"));


						
						return to2;

					} },to.getBseq());		
			

		
				return to;
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

			String sql2 = "SET foreign_key_checks = 0";
			pstmt = conn.prepareStatement(sql2);
			pstmt.executeUpdate();
			
			String sql="insert into board values (0,1,1,?,?,?,?,now(),0)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSubject());
			pstmt.setString(2, to.getContent());
			pstmt.setString(3, to.getFilename());
			pstmt.setLong(4, to.getFilesize());
			if(pstmt.executeUpdate() == 1) {
				flag = 0;
			}
			
			String sql3 = "SET foreign_key_checks = 1";
			pstmt = conn.prepareStatement(sql3);
			pstmt.executeUpdate();
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
	
	//글 수정
	public BoardTO noticeModify(BoardTO to) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			conn=this.dataSource.getConnection();
			
			String sql="select bseq, subject, content, filename from board where bseq=?;";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,to.getBseq());
			rs=pstmt.executeQuery();
			
			if (rs.next()) {
				to.setBseq(rs.getString("bseq"));
				to.setSubject(rs.getString("subject"));
				to.setContent(rs.getString("content"));
				to.setFilename(rs.getString("filename"));
			}	
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try{conn.close();} catch(SQLException e) {}
			if (pstmt!=null) try{pstmt.close();} catch(SQLException e) {}
			if (rs!=null) try{rs.close();} catch(SQLException e) {}
		}
		return to;
	}
	
	//글 modify_ok
	public int noticeModifyOk(BoardTO to) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		int flag=2; 
		try {
			conn=this.dataSource.getConnection();
				
			String sql="select filename from board where bseq=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,to.getBseq());
			rs=pstmt.executeQuery();
			
			to.setOldFileName("");
			if (rs.next()) { //기존 파일명
				to.setOldFileName(rs.getString("filename"));
			}
			if (to.getNewFileName()!=null) { //새 첨부파일 있는 경우
				sql = "update board set subject=?, content=?, filename=?, filesize=? where bseq=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1,to.getSubject());
				pstmt.setString(2,to.getContent());
				pstmt.setString(3,to.getNewFileName());
				pstmt.setLong(4,to.getNewFileSize());
				pstmt.setString(5,to.getBseq());
				
			} else { //새 첨부파일 없는 경우
				sql = "update board set subject=?, content=? where bseq=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1,to.getSubject());
				pstmt.setString(2,to.getContent());
				pstmt.setString(3,to.getBseq());
			}
			
			int result=pstmt.executeUpdate();
			if (result==1) {
				flag=0;
				//기존 파일 삭제
				if (to.getNewFileName()!=null) {
					File file=new File(uploadPath,to.getOldFileName());
					file.delete();
				}
			}
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try{conn.close();} catch(SQLException e) {}
			if (pstmt!=null) try{pstmt.close();} catch(SQLException e) {}
		}
		return flag;
	}
	
	//게시물 삭제
	public int noticeDelete(String bseq) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		int flag=2; //비정상
		try {
			conn=this.dataSource.getConnection();
			String sql="select filename from board where bseq=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,bseq);
			
			rs=pstmt.executeQuery();
			
			BoardTO to=new BoardTO();
			to.setBseq(bseq);
			to.setFilename("");
			if (rs.next()) {
				to.setFilename(rs.getString("filename"));
			}
			
			sql="delete from board where bseq=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,to.getBseq());
			pstmt.executeUpdate();
			
			flag=0;
			if (to.getFilename()!=null) {
				File file=new File(uploadPath, to.getFilename());
				file.delete();
			}
			
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try{conn.close();} catch(SQLException e) {}
			if (pstmt!=null) try{pstmt.close();} catch(SQLException e) {}
		}
		return flag;
	}
	
	//마이페이지 - 내가 쓴 글 보기 - 페이징
	public BoardListTO myPageList(BoardListTO boardListTO, String seq) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		int cpage=boardListTO.getCpage();
		int recordPerPage=boardListTO.getRecordPerPage();
		int blockPerPage=boardListTO.getBlockPerPage();

		try {
			conn=this.dataSource.getConnection();
			String sql="select bseq, board.seq, board.tseq, tname, subject, date_format(wdate, '%Y-%m-%d %H:%i') wdate, hit from board inner join team on (board.tseq=team.tseq) where board.seq=? order by bseq desc";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,seq);
			
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
				to.setSeq(rs.getString("seq"));
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setSubject(rs.getString("subject"));
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
	
	//내가쓴글보기 view
	public BoardTO myPageView(BoardTO to) { 
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
			sql="select bseq, tseq, subject, member.name as writer, content, filename, date_format(wdate, '%Y-%m-%d %H:%i') wdate, hit from board inner join member on board.seq = member.seq where bseq = ?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,to.getBseq());
			rs=pstmt.executeQuery();
			
			if (rs.next()) {
				to.setBseq(rs.getString("bseq"));	
				to.setTseq(rs.getString("tseq"));
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
	
	//내가쓴글보기 view
	public String myPageViewTname(String tseq) { 
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String tname="";
		try {
			conn=this.dataSource.getConnection();
			
			String sql="select tname from team where tseq=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,tseq);
			rs=pstmt.executeQuery();
			
			if (rs.next()) {
				tname=rs.getString("tname");	
			}
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try{conn.close();} catch (SQLException e) {}
			if (pstmt!=null) try{pstmt.close();} catch (SQLException e) {}
			if (rs!=null) try{rs.close();} catch (SQLException e) {}
		}
		return tname;
	}
}