package com.petmillie.board.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.board.service.BoardService;
import com.petmillie.board.vo.BoardVO;
import com.petmillie.board.vo.CommentVO;
import com.petmillie.member.vo.MemberVO;

@Controller("boardController")
@RequestMapping(value="/board")
public class BoardControllerImpl implements BoardController{
	
	@Autowired
    private BoardService boardService;

	@RequestMapping("/boardList.do")
	public ModelAndView boardList(HttpServletRequest request) {
		
		
	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");

	    String boardType = request.getParameter("board_type");
	    if (boardType == null || boardType.equals("")) {
	        boardType = "notice"; // 기본 게시판
	    }

	    Map<String, Object> result = boardService.getBoardList(request);
	    
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    mav.addObject("boardList", result.get("boardList"));
	    mav.addObject("total_record", result.get("total_record"));
	    mav.addObject("pageNum", result.get("pageNum"));
	    mav.addObject("total_page", result.get("total_page"));

	   
	    return mav;
	}

	@RequestMapping("/view.do")
	public ModelAndView boardView(HttpServletRequest request, HttpSession session) {
	    String viewName = (String) request.getAttribute("viewName");
	    int comu_id = Integer.parseInt(request.getParameter("num"));
	    
	    BoardVO vo = boardService.getBoardView(comu_id);

	    
	 // 로그인 사용자 정보 꺼내기
	    MemberVO member = (MemberVO) session.getAttribute("memberInfo");
	    boolean liked = false;
	    if (member != null) {
	        liked = boardService.isLiked(member.getMember_id(), comu_id);
	    }
	 // 좋아요 수 가져오기
	    int likeCount = boardService.countLikes(comu_id);   
	    
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    mav.addObject("vo", vo);
	    mav.addObject("page", request.getParameter("page"));
	    // 좋아요 여부 추가
	    mav.addObject("liked", liked);
	    // 좋아요 개수 카운트 
	    mav.addObject("likeCount",likeCount);
	    return mav;
	}

	@RequestMapping("/writeForm.do")
	public ModelAndView writeForm(HttpServletRequest request) {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    return mav;
	}

	
	@RequestMapping("/write.do")
	public ModelAndView write(@ModelAttribute BoardVO boardVO, @RequestParam("uploadFile") MultipartFile file, HttpServletRequest request) throws Exception {
			
		HttpSession session = request.getSession();
	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

	    if (memberInfo == null) {
	        return new ModelAndView("redirect:/member/loginForm.do");
	    }
	    String board_type = boardVO.getBoard_type();
	    
	    String memberId = memberInfo.getMember_id();
	    boardVO.setMember_id(memberId);
	    boardVO.setBoard_type(board_type);
	    // **C드라이브에 저장할 경로 설정** 
	    String saveDir = "C:\\petupload\\";
	    File uploadPath = new File(saveDir);
	    if (!uploadPath.exists()) uploadPath.mkdirs();

	    if (!file.isEmpty()) {
	        String originalFileName = file.getOriginalFilename();
	        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;

	        file.transferTo(new File(saveDir + savedFileName));
	        boardVO.setFile_name(savedFileName);
	    } else {
	        boardVO.setFile_name(null);
	    }

	    boardService.writeBoard(boardVO);

	    return new ModelAndView("redirect:/board/boardList.do?board_type=" + board_type);
	}
	
	@RequestMapping("/updateForm.do")
	public ModelAndView updateForm(HttpServletRequest request) {
		
		int comu_id = Integer.parseInt(request.getParameter("num"));

	    BoardVO board = boardService.getBoardView(comu_id); 

	    String viewName = (String) request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    
	    String board_type = request.getParameter("board_type");
	    
	    mav.addObject("vo", board); // 수정할 글 정보
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
	    return mav;
	}
	@RequestMapping("/update.do")
	public ModelAndView update(@ModelAttribute BoardVO boardVO, 
	                           @RequestParam("uploadFile") MultipartFile file,
	                           @RequestParam("originalFileName") String originalFileName,
	                           HttpServletRequest request) throws Exception {

	    String saveDir = "C:\\petupload\\";
	    File uploadPath = new File(saveDir);
	    if (!uploadPath.exists()) uploadPath.mkdirs();

	    // 새 파일 업로드 했을 경우
	    if (!file.isEmpty()) {
	        // 기존 파일 삭제
	        if (originalFileName != null && !originalFileName.isEmpty()) {
	            File oldFile = new File(saveDir + originalFileName);
	            if (oldFile.exists()) {
	                oldFile.delete(); // 삭제
	            }
	        }

	        // 새 파일 저장
	        String originalFileNameNew = file.getOriginalFilename();
	        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileNameNew;
	        file.transferTo(new File(saveDir + savedFileName));
	        boardVO.setFile_name(savedFileName);
	    } else {
	        // 파일 안 바꿨으면 기존 파일 유지
	        boardVO.setFile_name(originalFileName);
	    }
	    String board_type = request.getParameter("board_type");
	    
	    boardVO.setBoard_type(board_type);
	    
	    boardService.updateBoard(boardVO);
	    return new ModelAndView("redirect:/board/boardList.do?board_type=" + board_type);
	}

	@RequestMapping("/delete.do")
	public ModelAndView delete(HttpServletRequest request) {
		int num = Integer.parseInt(request.getParameter("num"));
	    boardService.deleteBoard(num);
	    return new ModelAndView("redirect:/board/boardList.do");
	}
	
	
	@ResponseBody //@ResponseBody를 붙이면 리턴 문자열이 JSON 데이터로 응답됨
	@RequestMapping("/commentReg.do")
	public String addcomment(HttpServletRequest request) {
		
		//세션에서 아이디꺼내기
		HttpSession session = request.getSession();
		MemberVO member = (MemberVO) session.getAttribute("memberInfo");
		String member_id = member.getMember_id();
		String _comu_id  = request.getParameter("comu_id");
		int comu_id = Integer.parseInt(_comu_id);
		String comment_content = request.getParameter("textareaWord");
		
	    boardService.addComment(comment_content, member_id, comu_id);
	    
	    return "{\"result\": \"success\"}";
	}
	
	@RequestMapping("/commentList.do")
	public String selectComment(HttpServletRequest request, Model model) {
	
		String comu_id  = request.getParameter("comu_id");
		int _comu_id= Integer.parseInt(comu_id);
		List<CommentVO> commentList = boardService.selectComment(_comu_id);
	    
	    model.addAttribute("commentList", commentList);

	    return "board/commentList"; 
	}
	@ResponseBody
	@RequestMapping("/commentDelete.do")
	public String deleteComment(HttpServletRequest request) {
		
		 try {
			 	String _comment_id  = request.getParameter("comment_id");
				int comment_id= Integer.parseInt(_comment_id);
		        
		        // 삭제 실행 (void라 결과값 없음)
		        boardService.deleteComment(comment_id);
		        
		        // 예외 없으면 성공
		        return "success";
		    } catch (Exception e) {
		        e.printStackTrace();
		        return "false";
		    }
	}
	
	//댓글수정 1 - 댓글수정창 열기
	  @RequestMapping("/updateCommentInput.do") 
		public String updateCommentInput(HttpServletRequest request, Model model) {
		
		String _comment_id = request.getParameter("comment_id");
		int comment_id= Integer.parseInt(_comment_id);
		
	    CommentVO commentVO = boardService.selectCommentOne(comment_id);
	    model.addAttribute("vo", commentVO);
	
	  return "board/updateCommentInput"; 
	  
	  }
	//댓글수정 2 - 댓글수정
	  @ResponseBody
	  @RequestMapping("/commentUpdate.do") 
	  public String updateComment(HttpServletRequest request) {
	  
		  try {
			 	String _comment_id  = request.getParameter("comment_id");
				int comment_id= Integer.parseInt(_comment_id);
				String comment_content = request.getParameter("content");
				
				CommentVO vo = new CommentVO();
				
				vo.setComment_content(comment_content);
				vo.setComment_id(comment_id);
				
				
		        // 수정 실행 (void라 결과값 없음)
		        boardService.updateComment(vo);
		        
		        // 예외 없으면 성공
		        return "success";
		    } catch (Exception e) {
		        e.printStackTrace();
		        return "false";
		    }
	  
	  }
	  //좋아요
	  @PostMapping(value = "/like.do", produces = "application/json; charset=UTF-8")
	  @ResponseBody
	  public Map<String, Object> toggleLike(@RequestParam("comu_id") int comu_id, HttpSession session) {
	      Map<String, Object> result = new HashMap<>();
	      MemberVO member = (MemberVO) session.getAttribute("memberInfo");

	      if (member == null) {
	          result.put("status", "unauthorized");
	          return result;
	      }

	      String member_id = member.getMember_id();
	      boolean likedNow = boardService.toggleLike(member_id, comu_id); // 수정된 서비스 호출
	      int likeCount = boardService.countLikes(comu_id);

	      result.put("status", "success");
	      result.put("liked", likedNow);      // 좋아요 누른 상태(true/false)
	      result.put("likeCount", likeCount); // 최신 좋아요 수

	      return result;
	  }

}
