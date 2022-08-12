package com.example.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.example.model1.AdminDAO;
import com.example.model1.BoardDAO;
import com.example.model1.BoardListTO;
import com.example.model1.BoardTO;
import com.example.model1.CommentDAO;
import com.example.model1.CommentTO;
import com.example.model1.MainTeamPageTO;
import com.example.model1.MainTeamTO;
import com.example.model1.MemberDAO;
import com.example.model1.MemberTO;
import com.example.model1.PageAdminTeamTO;
import com.example.model1.PageMainTeamTO;
import com.example.model1.PageMemberTO;
import com.example.model1.PageTeamMemberTO;
import com.example.model1.SignUpDAO;
import com.example.model1.SignUpTO;
import com.example.model1.TeamDAO;
import com.example.model1.TeamTO;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@RestController

public class MukjoController {
	@Autowired
	private SignUpDAO sdao;

	@Autowired
	private MemberDAO mdao;
	
	@Autowired
	private AdminDAO adao;
	
	@Autowired
	private BoardDAO bdao;
	private String uploadPath="C:/git/MukjoLoginSignup/src/main/webapp/upload";

	@Autowired
	private TeamDAO tdao;
	
	@Autowired
	private CommentDAO cdao;
	
	@RequestMapping(value = "/login.do")
	public ModelAndView login(HttpServletRequest request, Model model) {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("login");
		
		return modelAndView;
	}

	@RequestMapping(value = "/loginok.do")
	public ModelAndView loginOk(HttpSession session, HttpServletRequest request, Model model) {
		int flag = 10;

		String userName = request.getParameter("username");
		String password = request.getParameter("password");

		MemberTO mto = new MemberTO();
		mto.setEmail(userName);
		mto.setPassword(password);

		flag = mdao.CheckedLogin(mto);
		String name = "";
		if (flag == 1) {
			mto = mdao.MemberLogin(mto);
			session.setAttribute("loginedMemberSeq", mto.getSeq());
			session.setAttribute("loginedMemberName", mto.getName());
		}
		
		
		ModelAndView modelAndView = new ModelAndView();

		modelAndView.setViewName("loginok");
		modelAndView.addObject("flag", flag);

		return modelAndView;
	}

	@RequestMapping(value = "/logoutok.do")
	public ModelAndView logoutOk(HttpSession session, HttpServletRequest request, Model model) {
		String loginedMemberSeq = (String) session.getAttribute("loginedMemberSeq");


		int flag = 10;
		if (loginedMemberSeq != null) {
			flag = 1;
			session.removeAttribute("loginedMemberSeq");
			session.removeAttribute("loginedMemberName");
		}

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("logoutok");
		modelAndView.addObject("flag", flag);

		return modelAndView;
	}

	@RequestMapping(value="/forgotpw.do")
	   public ModelAndView forgotPw(HttpSession session,HttpServletRequest request, Model model) {


	      return new ModelAndView("forgotpw");
    }
	   
	@RequestMapping(value="/forgotpw_ok.do")
	public ModelAndView forgotPwOk(HttpSession session,HttpServletRequest request, Model model) {
		  int flag = 10;
	      
	      
		  String mail = request.getParameter("usermail");
		  String name = request.getParameter("username");
		  MemberTO mto = new MemberTO();
		  mto.setEmail(mail);
		  mto.setName(name);
		  
		  
		  flag = mdao.forgotPw(mto);
		  
		  
		  model.addAttribute("flag",flag);


	      return new ModelAndView("forgotpw_ok");
	}

	@RequestMapping(value = "/signup.do")
	public ModelAndView signup(HttpServletRequest request, Model model) {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup");
		return modelAndView;
	}

	@RequestMapping(value = "/signup_ok.do")
	public ModelAndView signup_ok(HttpServletRequest request, Model model) {
		SignUpTO sto = new SignUpTO();
		sto.setEmail(request.getParameter("email"));
		sto.setPassword(request.getParameter("password"));
		sto.setName(request.getParameter("name"));
		sto.setPhone(request.getParameter("phone"));
		sto.setBirth(request.getParameter("birth"));

		int flag = sdao.SignUpOk(sto);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("signup_ok");
		modelAndView.addObject("flag", flag);
		return modelAndView;
	}

	@RequestMapping(value = "/checkmail.do")
	public ModelAndView checkmail(HttpServletRequest request, Model model) {
		String mail = request.getParameter("email");
		boolean result = sdao.CheckMail(mail);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("checkmail");
		modelAndView.addObject("result", result);
		return modelAndView;
	}

	//가입한 소모임 리스트
	@RequestMapping(value = "/main.do")
	public ModelAndView main(HttpSession session, HttpServletRequest request, Model model) {
		
		String seq=(String) session.getAttribute("loginedMemberSeq");

		int cpage = 1;
		if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		MainTeamPageTO mainTeamPageTO=new MainTeamPageTO();
		mainTeamPageTO.setCpage(cpage);
		
		mainTeamPageTO = tdao.teamList(mainTeamPageTO, seq);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main");
		modelAndView.addObject("mainTeamPageTO", mainTeamPageTO);

		return modelAndView;
	}
	
	@RequestMapping(value = "/mainjoin.do")
	public ModelAndView mainjoin(HttpServletRequest request, Model model) {
		String tseq = request.getParameter("tseq");
		
		int cpage = 1;
		if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		PageTeamMemberTO pageTeamMemberTO = new PageTeamMemberTO();
		pageTeamMemberTO.setCpage(cpage);
		
		pageTeamMemberTO = mdao.teamMemberList(pageTeamMemberTO, tseq);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("mainjoin");
	    modelAndView.addObject("pageTeamMemberTO", pageTeamMemberTO);
	    return modelAndView;
	}
	
	@RequestMapping(value = "/mainall.do")
	public ModelAndView mainall(HttpServletRequest request, Model model) {
		int cpage = 1;
		if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		PageMainTeamTO pageMainTeamTO = new PageMainTeamTO();
		pageMainTeamTO.setCpage(cpage);
		
		pageMainTeamTO = tdao.mainteamList(pageMainTeamTO);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("mainall");
	    modelAndView.addObject("pageMainTeamTO", pageMainTeamTO);
	    return modelAndView;
	}
	
	@RequestMapping(value = "/checktname.do")
	public ModelAndView checktname(HttpServletRequest request, Model model) {
		String tname = request.getParameter("tname");
		String seq = request.getParameter("seq");
		boolean result = tdao.CheckTname(tname, seq);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("checktname");
		modelAndView.addObject("result", result);
		return modelAndView;
	}
	
	// 소모임 가입
	@RequestMapping(value = "/jointeam.do")
	public ModelAndView jointeam(HttpServletRequest request, Model model) {
		String tseq = request.getParameter("tseq");
		String seq = request.getParameter("seq");
		int flag = tdao.Jointeam(tseq, seq);
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jointeam");
		modelAndView.addObject("flag", flag);
		return modelAndView;
	}
	
	//구글 - 회원가입? 로그인?
    @RequestMapping(value="/sociallogin/googlelogin.do")
	public ModelAndView googlelogin(HttpSession session,HttpServletRequest request, Model model) {
		
		OAuth2User user = getCurrentUser();
		
		String email=(String)user.getAttributes().get("email");
		int count=mdao.EmailCheck(email); 
		
		ModelAndView modelAndView=new ModelAndView();
		
		if(count==0) { //비회원 --> 회원 가입
			modelAndView.setViewName("signup_google");
			modelAndView.addObject("email",email);
		} else if (count==1) { //회원 --> 로그인			
			int flag=1;
			
			MemberTO mto = new MemberTO();
			mto.setEmail(email);
			
			mto=mdao.EmailLogin(mto);
			session.setAttribute("loginedMemberSeq", mto.getSeq());
			session.setAttribute("loginedMemberName", mto.getName());
			modelAndView.setViewName("loginok");
			modelAndView.addObject("flag",flag);
		} else {
			System.out.println("대환장 에러");
		}

		return modelAndView;
		
	}
	
	public OAuth2User getCurrentUser() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		return ((OAuth2AuthenticationToken)auth).getPrincipal();
	}
		
	//관리자 페이지
	@RequestMapping(value = "/admin.do")
    public ModelAndView admin(HttpServletRequest request, Model model) {

		int btoday=adao.boardToday();
		int bone=adao.boardOne();
		int btwo=adao.boardTwo();
		int bthree=adao.boardThree();
		int bfour=adao.boardFour();
		int bfive=adao.boardFive();
		int bsix=adao.boardSix();
		int bseven=adao.boardSeven();
		int rtoday=adao.reviewToday();
		int rone=adao.reviewOne();
		int rtwo=adao.reviewTwo();
		int rthree=adao.reviewThree();
		int rfour=adao.reviewFour();
		int rfive=adao.reviewFive();
		int rsix=adao.reviewSix();
		int rseven=adao.reviewSeven();
		String today=adao.today();
		String one=adao.one();
		String two=adao.two();
		String three=adao.three();
		String four=adao.four();
		String five=adao.five();
		String six=adao.six();
		String seven=adao.seven();

	    ModelAndView mv = new ModelAndView();
	    mv.setViewName("admin");
	    mv.addObject("btoday",btoday);
	    mv.addObject("bone",bone);
	    mv.addObject("btwo",btwo);
	    mv.addObject("bthree",bthree);
	    mv.addObject("bfour",bfour);
	    mv.addObject("bfive",bfive);
	    mv.addObject("bsix",bsix);
	    mv.addObject("bseven",bseven);
	    mv.addObject("rtoday",rtoday);
	    mv.addObject("rone",rone);
	    mv.addObject("rtwo",rtwo);
	    mv.addObject("rthree",rthree);
	    mv.addObject("rfour",rfour);
	    mv.addObject("rfive",rfive);
	    mv.addObject("rsix",rsix);
	    mv.addObject("rseven",rseven);
	    mv.addObject("today",today);
	    mv.addObject("one",one);
	    mv.addObject("two",two);
	    mv.addObject("three",three);
	    mv.addObject("four",four);
	    mv.addObject("five",five);
	    mv.addObject("six",six);
	    mv.addObject("seven",seven);
	    
	    return mv;
	}
 
	@RequestMapping(value = "/adminmemberlists.do")
	    public ModelAndView adminmemberlists(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		PageMemberTO pageMemberTO=new PageMemberTO();
		pageMemberTO.setCpage(cpage);
		
		pageMemberTO = mdao.memberList(pageMemberTO);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminmemberlists");
	    modelAndView.addObject("pageMemberTO",pageMemberTO);
	
	    return modelAndView;
	 }
	 
	 //회원 추방 확인
	 @RequestMapping(value = "/addeletemember.do")
	    public ModelAndView addeletemember(HttpServletRequest request, Model model) {
	
		String name=request.getParameter("name");
		String seq=request.getParameter("seq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("addeletemember");
	    modelAndView.addObject("name",name);
	    modelAndView.addObject("seq",seq);
	
	    return modelAndView;
	 }
	 
	 //회원 추방 확인 후 삭제
	 @RequestMapping(value = "/addeletemember_ok.do")
	    public ModelAndView adminmemberdeleteok(HttpServletRequest request, Model model) {
	
		String seq=request.getParameter("seq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("addeletemember_ok");
	    int flag=mdao.adDeleteMember(seq);
	    modelAndView.addObject("flag",flag);
	
	    return modelAndView;
	 }
	 
	//소모임 목록
	 @RequestMapping(value = "/adminteam.do")
	    public ModelAndView adminteam(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		PageAdminTeamTO pageAdminTeamTO=new PageAdminTeamTO();
		pageAdminTeamTO.setCpage(cpage);
		
		pageAdminTeamTO = tdao.teamList(pageAdminTeamTO);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminteam");
	    modelAndView.addObject("pageAdminTeamTO",pageAdminTeamTO);
	    
	    return modelAndView;
	 }
	 
	 //소모임 삭제 확인
	 @RequestMapping(value = "/addeleteteam.do")
	    public ModelAndView addeleteteam(HttpServletRequest request, Model model) {
	
		String tseq=request.getParameter("tseq");
		String tname=request.getParameter("tname");
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("addeleteteam");
	    modelAndView.addObject("tname",tname);
	    modelAndView.addObject("tseq",tseq);
	
	    return modelAndView;
	 }
	 
	 //소모임 삭제 확인 후 삭제
	 @RequestMapping(value = "/addeleteteam_ok.do")
	    public ModelAndView addeleteteamok(HttpServletRequest request, Model model) {
	
		String tseq=request.getParameter("tseq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("addeleteteam_ok");
	    int flag=tdao.adDeleteTeam(tseq);
	    modelAndView.addObject("flag",flag);
	
	    return modelAndView;
	 }
	 
	 @RequestMapping(value = "/adminnotice.do")
	    public ModelAndView adminnotice(HttpServletRequest request, Model model) {
	    
		int cpage = 1;
		if(request.getParameter( "cpage" ) != null && !request.getParameter( "cpage" ).equals( "" ) ) {
			cpage = Integer.parseInt( request.getParameter( "cpage" ) );
		}
		
		BoardListTO boardListTO = new BoardListTO();

		boardListTO.setCpage(cpage);
		//listTO.setTseq("1");
		
		boardListTO = bdao.noticeList(boardListTO);
		
		ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice");
	    modelAndView.addObject("boardListTO",boardListTO);
	
	    return modelAndView;
	 }
	 
	 @RequestMapping(value = "/adminnotice_write.do")
	    public ModelAndView adminnotice_write(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if( request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}
		
		BoardListTO listTO = new BoardListTO();		
		listTO.setCpage(cpage);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice_write");
	    modelAndView.addObject("cpage",cpage);
	
	    return modelAndView;
	 }
	 
	 @RequestMapping(value = "/adminnotice_writeok.do")
	     public ModelAndView adminnotice_writeok(HttpSession sess,HttpServletRequest request,HttpServletResponse response,Model model) {
	
		 //String uploadPath = "C:\\Users\\JungGyuJin\\Desktop\\mukjo_project\\gitMukjo\\mukjo\\MukjoLoginSignup\\src\\main\\webapp\\upload";

		 int maxFileSize = 20 * 1024 * 1024;
		 String encoding = "utf-8";
	
		 int flag = 10;
	
		 MultipartRequest multi = null;
		 BoardTO bto = new BoardTO();
		 try {
			 multi=new MultipartRequest(request, uploadPath, maxFileSize, encoding, new DefaultFileRenamePolicy());
			
			 bto.setSeq((String)sess.getAttribute("loginedMemberSeq"));
			 bto.setWriter( (String)sess.getAttribute("loginedMemberName") );
			
			 bto.setSubject( multi.getParameter( "subject" ) );
			 bto.setContent( multi.getParameter( "content" ) ); 
	
			 bto.setFilename( multi.getFilesystemName( "upload" ) );
			 if( multi.getFile( "upload" ) != null ) {
				 bto.setFilesize( multi.getFile( "upload" ).length() );
			 }
			 
			 flag = bdao.noticeWriteOk(bto);
		} catch (IOException e) {
			System.out.println( "[에러] " + e.getMessage() );
		}
	
	     ModelAndView modelAndView = new ModelAndView();
	     modelAndView.setViewName("adminnotice_writeok");
	     modelAndView.addObject("flag",flag);
	
	     return modelAndView;
	 }
	 
	 @RequestMapping(value = "/adminnotice_view.do")
	    public ModelAndView adminnotice_view(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if ( request.getParameter( "cpage" ) != null && !request.getParameter( "cpage" ).equals("") ) {
			cpage = Integer.parseInt( request.getParameter( "cpage" ) );
		}
		
		BoardListTO listTO = new BoardListTO();
		listTO.setCpage(cpage);
		
		BoardTO to=new BoardTO();
		to.setBseq(request.getParameter("bseq"));
		to=bdao.noticeView(to);
			
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice_view");
	    modelAndView.addObject("to",to);
		modelAndView.addObject("cpage",cpage);
	
	    return modelAndView;
	 }
		
	 @RequestMapping(value = "/adminnotice_modify.do")
	    public ModelAndView adminnotice_modify(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if( request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}

		BoardListTO listTO = new BoardListTO();		
		listTO.setCpage(cpage);	
		
		BoardTO to = new BoardTO();
		to.setBseq(request.getParameter("bseq"));
		
		to = bdao.noticeModify(to);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice_modify");
	    modelAndView.addObject("to",to);
		modelAndView.addObject("cpage",cpage);
		
	    return modelAndView;
	 }
	
	 //공지 수정 - 확인 후 수정
	 @RequestMapping(value = "/adminnotice_modifyok.do")
	    public ModelAndView adminnotice_modifyok(HttpServletRequest request, Model model) {
	
		int cpage = 1;

		BoardListTO listTO = new BoardListTO();		

		int maxFileSize=2*1024*1024; //2메가
		String encType="utf-8";
		
		MultipartRequest multi = null;
		int flag=100;
		String bseq="";
		
		try {
			multi = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy() );
			
			cpage=Integer.parseInt(multi.getParameter("cpage"));
			listTO.setCpage(cpage);	
			
			BoardTO to=new BoardTO();
			to.setBseq(multi.getParameter("bseq"));
			to.setSubject(multi.getParameter("subject"));
			to.setContent(multi.getParameter("content"));

			//새 파일명
			to.setNewFileName(multi.getFilesystemName("upload"));
			to.setNewFileSize(0);
			if (multi.getFile("upload")!=null) {
				to.setNewFileSize(multi.getFile("upload").length());
			}
			bseq = multi.getParameter("bseq");
			flag=bdao.noticeModifyOk(to);
		} catch (IOException e) {
			System.out.println( "[에러] " + e.getMessage() );
		}
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice_modifyok");
	    modelAndView.addObject("flag",flag);
		modelAndView.addObject("cpage",cpage);
		modelAndView.addObject("bseq",bseq);
		
	    return modelAndView;
	 }
	
	 
	 //공지 삭제 확인
	 @RequestMapping(value = "/adminnotice_delete.do")
	    public ModelAndView adminnotice_delete(HttpServletRequest request, Model model) {
	
		String bseq=request.getParameter("bseq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice_delete");
	    modelAndView.addObject("bseq",bseq);
	
	    return modelAndView;
	 }
	 
	 //공지 삭제 확인 후 삭제
	 @RequestMapping(value = "/adminnotice_deleteok.do")
	    public ModelAndView adminnotice_deleteok(HttpServletRequest request, Model model) {
	
		String bseq=request.getParameter("bseq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("adminnotice_deleteok");
	    int flag=bdao.noticeDelete(bseq);
	    modelAndView.addObject("flag",flag);
	
	    return modelAndView;
	 }
	 
	 @RequestMapping(value = "/favorite.do")
	    public ModelAndView favorite(HttpServletRequest request, Model model) {
	
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("favorite");
	
	    return modelAndView;
	 }
	 
	@RequestMapping( "/somoimboard.do")	
	public ModelAndView boardList(HttpServletRequest request,HttpServletResponse response,Model model) {
		int cpage = 1;
		if(request.getParameter( "cpage" ) != null && !request.getParameter( "cpage" ).equals( "" ) ) {
			cpage = Integer.parseInt( request.getParameter( "cpage" ) );
		}
		
		BoardListTO listTO = new BoardListTO();
		listTO.setCpage(cpage);
		listTO.setTseq(request.getParameter("tseq"));
		TeamTO tto = bdao.teamName(listTO.getTseq());
		model.addAttribute("tseq",listTO.getTseq());
		model.addAttribute("tname",tto.getTname());
		listTO = bdao.boardList(listTO);
		
		ArrayList<BoardTO> noticeLists = bdao.noticeList();
		
		model.addAttribute("noticeLists",noticeLists);
		model.addAttribute("listTO",listTO);

		return new ModelAndView("somoimboard_list"); 
	}
	
	@RequestMapping( "/somoimboard_write.do")	
	public ModelAndView boardWrite(HttpServletRequest request,HttpServletResponse response,Model model) {


		return new ModelAndView("somoimboard_write"); 
	}
	
	@RequestMapping( "/somoimboard_writeok.do")	
	public ModelAndView boardWriteOk(HttpSession sess,HttpServletRequest request,HttpServletResponse response,Model model) throws IOException {
		
		//String uploadPath = "C:\\Users\\JungGyuJin\\Desktop\\mukjo_project\\새 폴더\\mukjo\\MukjoLoginSignup\\src\\main\\webapp\\upload";

		int maxFileSize = 20 * 1024 * 1024;
		String encoding = "utf-8";
		int flag = 10;
		
		MultipartRequest multi = new MultipartRequest(request, uploadPath, maxFileSize, encoding, new DefaultFileRenamePolicy());
		BoardTO bto = new BoardTO();
		
		
		bto.setTseq(multi.getParameter("tseq"));
		model.addAttribute("tseq",bto.getTseq());
		bto.setSeq((String)sess.getAttribute("loginedMemberSeq"));
		bto.setWriter( (String)sess.getAttribute("loginedMemberName") );
		
		bto.setSubject( multi.getParameter( "subject" ) );
		bto.setContent( multi.getParameter( "content" ) ); 

		bto.setFilename( multi.getFilesystemName( "upload" ) );
		File file = multi.getFile( "upload" ); 
		if( file != null ) {
			bto.setFilesize( file.length() );
		}
		
		
		flag = bdao.boardWriteOk(bto);
		
		model.addAttribute("flag",flag);
		
		
		return new ModelAndView("somoimboard_writeok"); 
	}

	@RequestMapping( "/somoimboard_view.do")   
	   public ModelAndView boardView(HttpServletRequest request,HttpServletResponse response,Model model) {

		String tseq = request.getParameter("tseq");
		String bseq = request.getParameter("bseq");
		BoardTO bto = new BoardTO();
		bto.setBseq(bseq);
		bto.setTseq(tseq);
		
		bto = bdao.boardView(bto);
		ArrayList<CommentTO> commentLists = cdao.commentView(bseq);
		
		model.addAttribute("bto",bto);
		model.addAttribute("commentLists",commentLists);
		
	      return new ModelAndView("somoimboard_view"); 
	}
	
	
	
	@RequestMapping( "/somoimcmt_writeok.do")   
	   public ModelAndView cmtWriteOk(HttpSession sess,HttpServletRequest request,HttpServletResponse response,Model model) {
		CommentTO cto = new CommentTO();
		
		cto.setSeq((String)sess.getAttribute("loginedMemberSeq"));
		cto.setBseq( request.getParameter("bseq") );
		cto.setCContent( request.getParameter( "cContent" ) ); 

		int flag = cdao.commentWrite(cto);
		
		model.addAttribute("flag",flag);
		

		
	      return new ModelAndView("somoimboardcmt_writeok"); 
	}
	
	@RequestMapping(value = "/myPage.do")
	    public ModelAndView myPage(HttpSession session, HttpServletRequest request, Model model) {
	
		String seq=(String) session.getAttribute("loginedMemberSeq");
		
		int cpage = 1;
		if(request.getParameter( "cpage" ) != null && !request.getParameter( "cpage" ).equals( "" ) ) {
			cpage = Integer.parseInt( request.getParameter( "cpage" ) );
		}
		
		BoardListTO boardListTO = new BoardListTO();
	
		boardListTO.setCpage(cpage);
		
		boardListTO = bdao.myPageList(boardListTO, seq);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage");
	    modelAndView.addObject("boardListTO",boardListTO);
	
	    return modelAndView;
	 }
		
	@RequestMapping(value = "/myPage_view.do")
	    public ModelAndView myPage_view(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if ( request.getParameter( "cpage" ) != null && !request.getParameter( "cpage" ).equals("") ) {
			cpage = Integer.parseInt( request.getParameter( "cpage" ) );
		}
		
		BoardListTO listTO = new BoardListTO();
		listTO.setCpage(cpage);
		
		BoardTO to=new BoardTO();
		to.setBseq(request.getParameter("bseq"));
		to=bdao.myPageView(to);
		String tname=bdao.myPageViewTname(to.getTseq());
			
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_view");
	    modelAndView.addObject("to",to);
		modelAndView.addObject("cpage",cpage);
		modelAndView.addObject("tname",tname);
	
	    return modelAndView;
	 }
	
	//내가 쓴 글 보기에서 게시물 삭제 확인
	 @RequestMapping(value = "/myPage_delete.do")
	    public ModelAndView myPage_delete(HttpServletRequest request, Model model) {
	
		String bseq=request.getParameter("bseq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_delete");
	    modelAndView.addObject("bseq",bseq);
	
	    return modelAndView;
	 }
	 
	 //내가 쓴 글 보기에서 게시물 삭제 
	 @RequestMapping(value = "/myPage_deleteok.do")
	    public ModelAndView myPage_deleteok(HttpServletRequest request, Model model) {
	
		String bseq=request.getParameter("bseq");

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_deleteok");
	    int flag=bdao.noticeDelete(bseq);
	    modelAndView.addObject("flag",flag);
	
	    return modelAndView;
	 }
	
	 //글 수정
	 @RequestMapping(value = "/myPage_modify.do")
	    public ModelAndView myPage_modify(HttpServletRequest request, Model model) {
	
		int cpage = 1;
		if( request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")) {
			cpage = Integer.parseInt(request.getParameter("cpage"));
		}

		BoardListTO listTO = new BoardListTO();		
		listTO.setCpage(cpage);	
		
		BoardTO to = new BoardTO();
		to.setBseq(request.getParameter("bseq"));
		
		to = bdao.noticeModify(to);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_modify");
	    modelAndView.addObject("to",to);
		modelAndView.addObject("cpage",cpage);
		
	    return modelAndView;
	 }
	
	 //글 수정 - 확인 후 수정
	 @RequestMapping(value = "/myPage_modifyok.do")
	    public ModelAndView myPage_modifyok(HttpServletRequest request, Model model) {
	
		int cpage = 1;

		BoardListTO listTO = new BoardListTO();		
			
		int maxFileSize=2*1024*1024; //2메가
		String encType="utf-8";
		
		MultipartRequest multi = null;
		int flag=100;
		String bseq="";
		
		try {
			multi = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy() );
			
			cpage=Integer.parseInt(multi.getParameter("cpage"));
			listTO.setCpage(cpage);
			
			BoardTO to=new BoardTO();
			to.setBseq(multi.getParameter("bseq"));
			to.setSubject(multi.getParameter("subject"));
			to.setContent(multi.getParameter("content"));

			//새 파일명
			to.setNewFileName(multi.getFilesystemName("upload"));
			to.setNewFileSize(0);
			if (multi.getFile("upload")!=null) {
				to.setNewFileSize(multi.getFile("upload").length());
			}
			bseq = multi.getParameter("bseq");
			flag=bdao.noticeModifyOk(to);
		} catch (IOException e) {
			System.out.println( "[에러] " + e.getMessage() );
		}
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_modifyok");
	    modelAndView.addObject("flag",flag);
		modelAndView.addObject("cpage",cpage);
		modelAndView.addObject("bseq",bseq);
		
	    return modelAndView;
	 }
	 
	//내 정보수정 확인
	@RequestMapping(value = "/myPage_info_modify.do")
	    public ModelAndView mypage_modify(HttpSession session, HttpServletRequest request, Model model) {
	
		String seq=(String) session.getAttribute("loginedMemberSeq");
		MemberTO to=mdao.myPageModify(seq);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_info_modify");
	    modelAndView.addObject("to",to);
	    
	    return modelAndView;
	 }
	
	//내정보수정 
	@RequestMapping(value = "/myPage_info_modifyok.do")
	    public ModelAndView mypage_modifyok(HttpSession session, HttpServletRequest request, Model model) {
	
		String seq=(String) session.getAttribute("loginedMemberSeq");
		MemberTO to=new MemberTO();
		to.setSeq(seq);
		to.setEmail(request.getParameter("email"));
		to.setBirth(request.getParameter("birth"));
		to.setPhone(request.getParameter("phone"));
		to.setPassword(request.getParameter("pwd1"));
	
		int flag=mdao.myPageModifyOk(to);
		
	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("myPage_info_modifyok");
	    modelAndView.addObject("flag",flag);
	    
	    return modelAndView;
	 }
	
	// 소모임페이지
		@RequestMapping( "/somoimboard_home.do")	
		public ModelAndView boardHome(HttpServletRequest request,HttpServletResponse response,Model model) {

			return new ModelAndView("somoimboard_home"); 
		}
		
		@RequestMapping( "/somoimboard_review.do")	
		public ModelAndView boardReview(HttpServletRequest request,HttpServletResponse response,Model model) {

			return new ModelAndView("somoimboard_review"); 
		}
		
		@RequestMapping( "/somoimboard_menu.do")	
		public ModelAndView boardMenu(HttpServletRequest request,HttpServletResponse response,Model model) {

			return new ModelAndView("somoimboard_menu"); 
		}
		
		@RequestMapping( "/somoimboard_picture.do")	
		public ModelAndView boardPicture(HttpServletRequest request,HttpServletResponse response,Model model) {

			return new ModelAndView("somoimboard_picture"); 
		}
		
		@RequestMapping( "/somoimboard_search.do")	
		public ModelAndView boardSearch(HttpServletRequest request,HttpServletResponse response,Model model) {

			return new ModelAndView("somoimboard_search"); 
		}
}
