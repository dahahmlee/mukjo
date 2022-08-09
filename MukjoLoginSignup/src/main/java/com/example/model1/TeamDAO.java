package com.example.model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
			
			String sql = "select tseq, tname, t.seq, memcount, m.name from team t inner join member m where t.seq = m.seq";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				TeamTO to = new TeamTO();
				to.setTseq(rs.getString("tseq"));
				to.setTname(rs.getString("tname"));
				to.setSeq(rs.getString("t.seq"));
				to.setMemcount(rs.getString("memcount"));
				to.setTleader(rs.getString("m.name"));
				
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
			
			String sql = "SET foreign_key_checks = 0";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			
			String sql2 = "delete from team where tseq=?";
			pstmt = conn.prepareStatement(sql2);
			pstmt.setString(1, tseq);
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
}

