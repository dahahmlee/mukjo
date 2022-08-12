package com.example.model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class TeamDAO {
	
	@Autowired
	private DataSource dataSource;

	// 메인 페이지 전체 소모임
	public ArrayList<TeamTO> mainteamList() {
		ArrayList<TeamTO> lists = new ArrayList<TeamTO>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = this.dataSource.getConnection();
			
			String sql = "select tseq, tname, name, memcount from team inner join member where team.seq=member.seq order by tname";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				TeamTO to = new TeamTO();
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setSeq(rs.getString("seq"));
				to.setMemcount(rs.getString("memcount"));
				to.setName(rs.getString("name"));
				
				lists.add(to);
			}
		} catch(SQLException e) {
			System.out.println("[에러]: " + e.getMessage());
		} finally {
			if(rs != null) try{ rs.close(); } catch(SQLException e) {}
			if(pstmt != null) try{ pstmt.close(); } catch(SQLException e) {}
			if(conn != null) try{ conn.close(); } catch(SQLException e) {}
		}
		return lists;
	}
	
	// 소모임 이름
	public boolean CheckTname(String tname, String seq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean result = false;
		
		try {
			conn = this.dataSource.getConnection();
			
			String sql = "select tname from team where tname = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, tname);
			rs = pstmt.executeQuery();
			
			// 소모임 이름이 있다면 true
			if(rs.next()) {
				result = true;
			} else {
				sql = "insert into team values (0, ?, ?, 1)";
				pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, tname);
				pstmt.setString(2, seq);
				
				pstmt.executeUpdate();
				rs = pstmt.getGeneratedKeys();
				if(rs.next()) {
					// tseq값 가져오기
					int tseq = rs.getInt(1);
					
					String tsql = "insert into teammember values (1, ?, 1), (?, ?, 1)";
					pstmt = conn.prepareStatement(tsql);
					pstmt.setInt(1, tseq);
					pstmt.setString(2, seq);
					pstmt.setInt(3, tseq);
					
					pstmt.executeUpdate();
				}
			}
		} catch(SQLException e) {
			System.out.println("[에러]: " + e.getMessage());
		} finally {
			if(rs != null) try{ rs.close(); } catch(SQLException e) {}
			if(pstmt != null) try{ pstmt.close(); } catch(SQLException e) {}
			if(conn != null) try{ conn.close(); } catch(SQLException e) {}
		}
		return result;
	}
	
	// 메인페이지 전체소모임리스트 - 페이징
	public PageMainTeamTO mainteamList(PageMainTeamTO pageMainTeamTO) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int cpage = pageMainTeamTO.getCpage();
		int recordPerPage = pageMainTeamTO.getRecordPerPage();
		int blockPerPage = pageMainTeamTO.getBlockPerPage();

		try {
			conn = this.dataSource.getConnection();
			
			String sql = "select tseq, tname, name, memcount from team inner join member where team.seq=member.seq order by tname";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = pstmt.executeQuery();

			rs.last(); //읽기 커서를 맨 마지막 행으로 이동
			pageMainTeamTO.setTotalRecord(rs.getRow());
			rs.beforeFirst(); //읽기 커서를 맨 첫행으로 이동

			//전체 페이지
			pageMainTeamTO.setTotalPage((pageMainTeamTO.getTotalRecord() - 1) / recordPerPage + 1);

			//시작번호 - 읽을 데이터 위치 지정
			int skip = (cpage - 1) * recordPerPage;
			if(skip != 0) rs.absolute(skip); //커서를 주어진 행으로 이동
				ArrayList<TeamTO> mainteamLists = new ArrayList<TeamTO>();
			for(int i = 0 ; i < recordPerPage && rs.next() ; i++) {
				TeamTO to = new TeamTO();
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setName(rs.getString("name"));
				to.setMemcount(rs.getString("memcount"));
				
				mainteamLists.add(to);
			}
			pageMainTeamTO.setMainTeamLists(mainteamLists);
			pageMainTeamTO.setStartBlock((cpage-1)/blockPerPage*blockPerPage+1);
			pageMainTeamTO.setEndBlock((cpage-1)/blockPerPage*blockPerPage+blockPerPage);
			if (pageMainTeamTO.getEndBlock()>=pageMainTeamTO.getTotalPage()) {
				pageMainTeamTO.setEndBlock(pageMainTeamTO.getTotalPage());
			}
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if(conn != null) try { conn.close(); } catch(SQLException e) {}
			if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
			if(rs != null) try { rs.close(); } catch(SQLException e) {}
		}
		return pageMainTeamTO;
	}

	//관리자 페이지 - 소모임 리스트
	public ArrayList<TeamTO> teamList() {
		
		ArrayList<TeamTO> lists=new ArrayList<TeamTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = this.dataSource.getConnection();
			
			String sql="select tseq, tname, name from team inner join member where team.seq=member.seq";
			pstmt=conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				TeamTO to=new TeamTO();
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setName(rs.getString("name"));
				
				lists.add(to);
			}
		} catch(SQLException e) {
			System.out.println("[에러]: " + e.getMessage());
		} finally {
			if(rs != null) try{ rs.close(); } catch(SQLException e) {}
			if(pstmt != null) try{ pstmt.close(); } catch(SQLException e) {}
			if(conn != null) try{ conn.close(); } catch(SQLException e) {}
		}
		
		return lists;
	}
	
	//관리자페이지-소모임리스트 - 페이징
	public PageAdminTeamTO teamList(PageAdminTeamTO pageAdminTeamTO) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;

		int cpage=pageAdminTeamTO.getCpage();
		int recordPerPage=pageAdminTeamTO.getRecordPerPage();
		int blockPerPage=pageAdminTeamTO.getBlockPerPage();

		try {
			conn=this.dataSource.getConnection();

			String sql="select tseq, tname, name from team inner join member where team.seq=member.seq";
			pstmt=conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs=pstmt.executeQuery();

			rs.last(); //읽기 커서를 맨 마지막 행으로 이동
			pageAdminTeamTO.setTotalRecord(rs.getRow());
			rs.beforeFirst(); //읽기 커서를 맨 첫행으로 이동

			//전체 페이지
			pageAdminTeamTO.setTotalPage((pageAdminTeamTO.getTotalRecord()-1)/recordPerPage+1);

			//시작번호 - 읽을 데이터 위치 지정
			int skip=(cpage-1)*recordPerPage;
			if (skip!=0) rs.absolute(skip); //커서를 주어진 행으로 이동

			ArrayList<TeamTO> teamLists=new ArrayList<TeamTO>();
			for (int i=0;i<recordPerPage && rs.next();i++) {
				TeamTO to=new TeamTO();
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setName(rs.getString("name"));

				teamLists.add(to);
			}
			pageAdminTeamTO.setTeamLists(teamLists);
			pageAdminTeamTO.setStartBlock((cpage-1)/blockPerPage*blockPerPage+1);
			pageAdminTeamTO.setEndBlock((cpage-1)/blockPerPage*blockPerPage+blockPerPage);
			if (pageAdminTeamTO.getEndBlock()>=pageAdminTeamTO.getTotalPage()) {
				pageAdminTeamTO.setEndBlock(pageAdminTeamTO.getTotalPage());
			}
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try {conn.close();} catch (SQLException e) {}
			if (pstmt!=null) try {pstmt.close();} catch (SQLException e) {}
			if (rs!=null) try {rs.close();} catch (SQLException e) {}
		}
		return pageAdminTeamTO;
	}
	
	//소모임 삭제(관리자)
	public int adDeleteTeam(String tseq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
	
		int flag=1;
		try {
			conn = this.dataSource.getConnection();
			
			String sql = "delete from teammember where tseq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, tseq);
			pstmt.executeUpdate();
			
			String sql2 = "delete from review where tseq=?";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1, tseq);
			pstmt.executeUpdate();
			
			String sql3 = "delete from board where tseq=?";
			pstmt = conn.prepareStatement(sql3);
			pstmt.setString(1, tseq);
			pstmt.executeUpdate();
			
			String sql4="delete from team where tseq=?";
			pstmt = conn.prepareStatement(sql4);
			pstmt.setString(1, tseq);
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
	
	//메인페이지 - 가입한 소모임 - 페이징
	public MainTeamPageTO teamList(MainTeamPageTO mainTeamPageTO, String seq) {
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ResultSet rs2=null;

		int cpage=mainTeamPageTO.getCpage();
		int recordPerPage=mainTeamPageTO.getRecordPerPage();
		int blockPerPage=mainTeamPageTO.getBlockPerPage();

		String jangseq="";
		try {
			conn=this.dataSource.getConnection();
			String sql="select teammember.tseq as tseq, tname, team.seq as jangseq, memcount from teammember inner join team where teammember.tseq=team.tseq and teammember.seq=? order by tname";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1,seq);
			
			rs=pstmt.executeQuery();
		
			rs.last(); //읽기 커서를 맨 마지막 행으로 이동
			mainTeamPageTO.setTotalRecord(rs.getRow());
			rs.beforeFirst(); //읽기 커서를 맨 첫행으로 이동

			//전체 페이지
			mainTeamPageTO.setTotalPage((mainTeamPageTO.getTotalRecord()-1)/recordPerPage+1);

			//시작번호 - 읽을 데이터 위치 지정
			int skip=(cpage-1)*recordPerPage;
			if (skip!=0) rs.absolute(skip); //커서를 주어진 행으로 이동

			ArrayList<MainTeamTO> teamLists=new ArrayList<MainTeamTO>();
			for (int i=0;i<recordPerPage && rs.next();i++) {
				MainTeamTO to=new MainTeamTO();
				to.setSeq(rs.getString("seq"));
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setJangseq(rs.getString("jangseq"));
				to.setMemcount(rs.getString("memcount"));
				jangseq=rs.getString("jangseq");
				
				sql="select name from member where seq=?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1,jangseq);
				
				rs2=pstmt.executeQuery();
			
				if (rs2.next()) {
					to.setJangname(rs2.getString("name"));
				}
				
				teamLists.add(to);
			}
			mainTeamPageTO.setTeamLists(teamLists);
			mainTeamPageTO.setStartBlock((cpage-1)/blockPerPage*blockPerPage+1);
			mainTeamPageTO.setEndBlock((cpage-1)/blockPerPage*blockPerPage+blockPerPage);
			if (mainTeamPageTO.getEndBlock()>=mainTeamPageTO.getTotalPage()) {
				mainTeamPageTO.setEndBlock(mainTeamPageTO.getTotalPage());
			}
			
				
			
		} catch (SQLException e) {
			System.out.println("[에러]:"+e.getMessage());
		} finally {
			if (conn!=null) try {conn.close();} catch (SQLException e) {}
			if (pstmt!=null) try {pstmt.close();} catch (SQLException e) {}
			if (rs!=null) try {rs.close();} catch (SQLException e) {}
		}
		return mainTeamPageTO;
	}
}

