package com.example.model1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sql.DataSource;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FoodDAO {
	@Autowired
	private DataSource dataSource;
	
	public static JSONObject jsonParser(String content) {
		JSONParser parser = new JSONParser();
		JSONObject jsonObj = null;

		try {
			Object obj = parser.parse(content);
			jsonObj = (JSONObject)obj;

		} catch(Exception e) {
			e.printStackTrace();
		}
		return jsonObj;
	}

	public static ArrayList<FoodTO> crawler(String search) {
		ArrayList<FoodTO> lists = new ArrayList<FoodTO>();
		Document doc = null;

		try {
			if(search == null) {
				doc = Jsoup.connect("https://m.map.naver.com/search2/search.nhn?query=강남역 맛집&sm=hty&style=v5").get();
			} else {
				doc = Jsoup.connect("https://m.map.naver.com/search2/search.nhn?query=" + search + " 맛집&sm=hty&style=v5").get();
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		Elements scripts = doc.getElementsByTag("script");

		String a = null;

		for(Element element : scripts) {
			if(element.data().contains("var searchResult")) {
				Pattern pattern = Pattern.compile(".*var searchResult = ([^;]*);");
				Matcher matcher = pattern.matcher(element.data());
				if(matcher.find()) {
					a = matcher.group(1);
					break;
				} else {
					System.err.println("No match found!");
				}
				break;
			}
		}
		
		for (Object i : (ArrayList<Object>)jsonParser(jsonParser(a).get("site").toString()).get("list")){
			FoodTO to = new FoodTO();
			to.setId(jsonParser(i.toString()).get("id").toString());
			to.setName(jsonParser(i.toString()).get("name").toString());
			to.setCategory(jsonParser(i.toString()).get("category").toString());
			to.setLatitude(jsonParser(i.toString()).get("y").toString());
			to.setLongitude(jsonParser(i.toString()).get("x").toString());
			to.setThumurl(jsonParser(i.toString()).get("thumUrl").toString());
			
			lists.add(to);
		}
		return lists;
	}
	
	// tseq로 소모임 이름 알아내기
		public String tnameFromTseq(String tseq) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String tname="";
			try {
				conn = this.dataSource.getConnection();
				
				String sql = "select tname from team where tseq=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, tseq);
				rs = pstmt.executeQuery();

				if (rs.next()) {
					tname=rs.getString("tname");
				}
				
			} catch (SQLException e) {
				System.out.println("[에러]:"+e.getMessage());
			} finally {
				if(conn != null) try { conn.close(); } catch(SQLException e) {}
				if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
				if(rs != null) try { rs.close(); } catch(SQLException e) {}
			}
			return tname;
		}
}
