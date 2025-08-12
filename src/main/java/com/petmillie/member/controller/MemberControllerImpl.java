package com.petmillie.member.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petmillie.common.base.BaseController;
import com.petmillie.member.service.MailService;
import com.petmillie.member.service.MemberService;
import com.petmillie.member.vo.MemberVO;

@Controller("memberController")
@RequestMapping(value = "/member")
public class MemberControllerImpl extends BaseController implements MemberController {
	@Autowired
	private MemberService memberService;
	@Autowired
	private MemberVO memberVO;
	@Autowired
	private MailService mailService;
	
	@RequestMapping(value = "/login.do", method = RequestMethod.POST)
	public ModelAndView login(@RequestParam("member_id") String member_id, @RequestParam("member_pw") String member_pw, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//회원 로그인
		ModelAndView mav = new ModelAndView("/common/layout");
		int result = memberService.overlapped(member_id);
		
		if(result != 0) {
			//아이디 존재
			MemberVO memberVO = memberService.login(member_id, member_pw);
			if(memberVO == null) {
				//비밀번호 틀림
				mav.addObject("title", "로그인");
				mav.addObject("message", "비밀번호가 일치하지 않습니다.");
				mav.addObject("body", "/WEB-INF/views/member/loginForm.jsp");
			}else {
				//로그인 성공
				HttpSession session = request.getSession();
				session.setAttribute("isLogOn", true);
				session.setAttribute("memberInfo", memberVO);
				
				String action = (String) session.getAttribute("action");
				if ("admin".equals(memberVO.getMember_id())) {
					session.setAttribute("side_menu", "admin_mode");
				} else {
					session.setAttribute("side_menu", "my_page");
				}
				
				// 액션 리다이렉트
				if (action != null && action.equals("/order/orderEachGoods.do")) {
					mav.setViewName("forward:" + action);
				} else {
					mav.setViewName("redirect:/main/main.do");
				}
			}		
		}else {
			mav.addObject("title", "로그인");
			mav.addObject("message", "존재하지 않는 아이디 입니다.");
			mav.addObject("body", "/WEB-INF/views/member/loginForm.jsp");
		}
		
		return mav;
	}

	@Override
	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		session.setAttribute("isLogOn", false);
		session.removeAttribute("memberInfo");
		session.removeAttribute("businessInfo");
		mav.setViewName("redirect:/main/main.do");
		return mav;
	}

	@Override
	@RequestMapping(value = "/addMember.do", method = RequestMethod.POST)
	public ResponseEntity addMember(@ModelAttribute("memberVO") MemberVO _memberVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		System.out.println("id: " + _memberVO.getMember_id());
		System.out.println("name: " + _memberVO.getMember_name());
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			memberService.addMember(_memberVO);
			HttpSession session = request.getSession();
		    session.setAttribute("isLogOn", true);
		    session.setAttribute("memberInfo", _memberVO);
			message = "<script>";
			message += " alert('회원가입 성공');";
			message += " location.href='" + request.getContextPath() + "/member/loginForm.do';";
			message += " </script>";

		} catch (Exception e) {
			message = "<script>";
			message += " alert('회원가입 실패');";
			message += " location.href='" + request.getContextPath() + "/member/memberForm.do';";
			message += " </script>";

			e.printStackTrace();
		}
		resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}

	@Override
	@RequestMapping(value = "/overlapped.do", method = RequestMethod.POST)
	@ResponseBody
	public String overlapped(@RequestParam("id") String id, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		int result = memberService.overlapped(id);
		return (result == 0) ? "false" : "true";
	}
	
	@Override
	@RequestMapping(value="/sendAuthCode.do", method=RequestMethod.POST)
	@ResponseBody
	public String sendAuthCode(@RequestParam("email1") String email1, @RequestParam("email2") String email2) throws Exception{
		//이메일 인증
		String overlappedByEmail = memberService.overlappedByEmail(email1, email2);
		if(overlappedByEmail.equals("true")) {
			return overlappedByEmail;
		}else {
			String email = email1 + "@" + email2;
			String authCode = mailService.joinEmail(email);
			return authCode;
		}
	}

	@RequestMapping(value = "/*Form.do", method = RequestMethod.GET)
	public ModelAndView Form(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		return mav;
	}

	@Override
	@RequestMapping(value="/kakaoLogin.do", method= {RequestMethod.GET, RequestMethod.POST})
	public String kakaoLogin(@RequestParam("code") String code, @RequestParam Map<String, String> loginMap, HttpSession session, Model model) throws Exception {
		// 1. code 파라미터가 잘 들어왔는지 확인!
	    System.out.println("카카오 인증코드: " + code);
	    
	    String reqUrl = "https://kauth.kakao.com/oauth/token";
	    RestTemplate restTemplate = new RestTemplate();

	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", "69cca3f6669288cd3162c12fa845a93d");
	    params.add("redirect_uri", "http://localhost:8090/petmillie/member/kakaoLogin.do");
	    params.add("code", code);
	    params.add("client_secret", "pPyFlBfKwC0yp4VrrO58yOLD1ksvY1Fu");
	    
	    System.out.println("client_id: 69cca3f6669288cd3162c12fa845a93d");
	    System.out.println("redirect_uri: http://localhost:8090/petmillie/member/kakaoLogin.do");
	    System.out.println("code: " + code);

	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

	    HttpEntity<MultiValueMap<String, String>> httpEntity = new HttpEntity<>(params, headers);

	    ResponseEntity<String> response = restTemplate.postForEntity(reqUrl, httpEntity, String.class);
	    String body = response.getBody();
	    System.out.println("카카오 토큰 응답: " + body);
	    
	    JSONObject jsonObj = new JSONObject(body);
	    String accessToken = jsonObj.getString("access_token");
	    System.out.println("카카오 access_token: " + accessToken);
	    
	    String infoUrl = "https://kapi.kakao.com/v2/user/me";
	    HttpHeaders infoHeaders = new HttpHeaders();
	    infoHeaders.add("Authorization", "Bearer " + accessToken);

	    HttpEntity<String> infoEntity = new HttpEntity<>(infoHeaders);

	    ResponseEntity<String> infoResponse = restTemplate.exchange(infoUrl, HttpMethod.GET, infoEntity, String.class);
	    String userInfo = infoResponse.getBody();
	    System.out.println("카카오 회원정보: " + userInfo);
	    
	    JSONObject userObj = new JSONObject(userInfo);
	    long kakaoid = userObj.getLong("id");
	    String email1 = "";
	    String email2 = "";
	    String nickname = "";

	    if(userObj.has("kakao_account")){
	        JSONObject account = userObj.getJSONObject("kakao_account");
	        if(account.has("email")){
	            String email = account.getString("email");   // 예: sample@naver.com
	            int idx = email.indexOf("@");
	            if (idx > 0) {
	                email1 = email.substring(0, idx);     // sample
	                email2 = email.substring(idx + 1);    // naver.com
	        }
	    }
	    }
	    if(userObj.has("properties")){
	        JSONObject properties = userObj.getJSONObject("properties");
	        if(properties.has("nickname")){
	            nickname = properties.getString("nickname");
	        }
	    }

	    // 1) DB에서 kakaoId로 회원 조회
	    MemberVO memberVO = memberService.findkakaoid(String.valueOf(kakaoid));
	    
	    if(memberVO != null){
	        // 이미 가입된 회원 → 로그인 처리
			session.setAttribute("isLogOn", true);
			session.setAttribute("memberInfo", memberVO);
	    	return "redirect:/main/main.do";
	    }else {
			
	        // 최초 카카오 로그인 → 회원가입 유도
	    	session.setAttribute("kakao_id", kakaoid);
	    	session.setAttribute("kakao_name", nickname);
	    	session.setAttribute("kakao_email1", email1);
	    	session.setAttribute("kakao_email2", email2);
	    	session.setAttribute("social_type", "kakao");
	        return "redirect:/member/kakaoForm.do"; // 회원가입 폼으로 이동
	    }
	}
	
	@RequestMapping(value="/deleteMember.do", method= {RequestMethod.GET,RequestMethod.POST})
	public String deleteMember(@RequestParam("member_id") String member_id, HttpSession session, RedirectAttributes redirectAttributes) throws Exception {
	    memberService.removeMember(member_id);
	    session.invalidate(); // 세션도 끊자!
	    redirectAttributes.addFlashAttribute("message", "회원탈퇴가 완료되었습니다.");
	    return "redirect:/main/main.do";
	}
	}




	    


