package com.example.model1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MapDAO {
   
   public ArrayList<String> resDetail(String rescode) {
      BufferedReader br=null;
      
      ArrayList<String> resDetail=new ArrayList<String>();
      String rname="";
      String rloc="";
      String rfac="";
      String rphone="";
      String rtime="";
      String rsite="";
      
      try {
         URL url=new URL("https://m.place.naver.com/restaurant/"+rescode+"/home");

         br=new BufferedReader(new InputStreamReader(url.openStream()));
         
         String line=null;
         while ((line=br.readLine())!=null) {
            
            if (line.contains("class=\"_3XamX\"")) {
               String what=br.readLine().trim();
               
               rname=what.substring(what.indexOf("line-title")+12, what.indexOf("data-line-description")-2).replace("&amp;", "&");
               rloc=what.substring(what.indexOf("line-description")+18, what.indexOf("data-kakaotalk")-2);
               //System.out.println("식당이름: "+what.substring(what.indexOf("line-title")+12, what.indexOf("data-line-description")-2).replace("&amp;", "&"));
               //System.out.println("위치: "+what.substring(what.indexOf("line-description")+18, what.indexOf("data-kakaotalk")-2));
            
            }
            
            if (line.contains("<span class=\"place_blind\">편의</span>")) {
               rfac=line.split("<span class=\"place_blind\">편의</span>")[1].split("</strong><div class=\"_1h3B_\">")[1].split("</div>")[0];
               //System.out.println("편의: "+line.split("<span class=\"place_blind\">편의</span>")[1].split("</strong><div class=\"_1h3B_\">")[1].split("</div>")[0]);               

            }
            
            
            if (line.contains("<span class=\"_3ZA0S\">")) {
               rphone=line.split("_3ZA0S\">")[1].split("</span")[0];
               //System.out.println("전화번호: "+line.split("_3ZA0S\">")[1].split("</span")[0]);
            } 
            
            
            if (line.contains("<div class=\"_2ZP3j _2vK84 _2XDa2\">")) {
               String what=line.split("<div class=\"_2ZP3j _2vK84 _2XDa2\"><div class=\"_20Y9l\"><div class=\"_20pEw\">")[1].split("<time aria-hidden=\"true\">")[1].split("</time><span class")[0];
               
               rtime=what;
            
            } else if (line.contains("_2BDci _1OkoP") && line.contains("<div class=\"_2ZP3j _2vK84\"><div class=\"_20Y9l\">")) {
               String what=line.split("<time aria-hidden=\"true\">")[1].split("</time><span class=\"place_blind\">")[0];
               
               rtime=what;
            } else if (line.contains("_2BDci _1OkoP") && line.contains("<div class=\"_2ZP3j\"><div class=\"_20Y9l\">")) {
               String what=line.split("<a href=\"#\" role=\"button\" class=\"_2BDci _1OkoP\" aria-expanded=\"false\"><div class=\"_2ZP3j\"><div class=\"_20Y9l\"><span class=\"_20pEw\">")[1].split("</span></div></div></a></div></li><li class=\"_1M_Iz _3xPmJ\">")[0];
               String why=what.replace("</span><span class=\"_1aKLL\"><svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 12 7\" class=\"_12Coj\" aria-hidden=\"true\"><path d=\"M11.47.52a.74.74 0 0 0-1.04 0l-4.4 4.45v.01L1.57.52A.74.74 0 1 0 .53 1.57l5.12 5.08a.5.5 0 0 0 .7 0l5.12-5.08a.74.74 0 0 0 0-1.05z\"></path></svg><span class=\"place_blind\">펼쳐보기</span></span></div></div><div class=\"_2ZP3j\"><div class=\"_20Y9l\"><span class=\"_20pEw\">", " / ");
               String where=why.replace("<!-- --> <!-- -->", " ");
            
               rtime=where;
            }
            
            if (line.contains("<div class=\"_14J59\">")) {
               rsite=line.split("class=\"_14J59\">")[1].split("role=\"button\" class=\"_1RUzg\">")[0].replace("<a href=", "").replace("\"", "");
               //System.out.println("사이트: "+line.split("class=\"_14J59\">")[1].split("role=\"button\" class=\"_1RUzg\">")[0].replace("<a href=", "").replace("\"", ""));
            }
            
         }
      } catch (MalformedURLException e) {
         e.printStackTrace();
      } catch (IOException e) {
         e.printStackTrace();
      } finally {
         if (br!=null) try {br.close();} catch(IOException e) {}
      }
      
      resDetail.add(rname);
      resDetail.add(rloc);
      resDetail.add(rfac);
      resDetail.add(rphone);
      resDetail.add(rtime);
      resDetail.add(rsite);
   
      return resDetail;
   }
}   
   