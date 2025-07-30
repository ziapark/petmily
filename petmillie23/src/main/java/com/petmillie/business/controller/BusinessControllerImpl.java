package com.petmillie.business.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petmillie.business.service.BusinessService;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;


@Controller("businessController")
@RequestMapping("/business")
public class BusinessControllerImpl implements BusinessController {
	@Autowired
	private BusinessService businessService;
	@Autowired
	private BusinessVO businessVO;
	@Autowired
	private PensionVO pensionVO;
	@Autowired
	private RoomVO roomVO;
	
	@RequestMapping(value = "/busilogin.do", method = RequestMethod.POST)
	public ModelAndView login(@RequestParam Map<String, String> loginMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		businessVO = businessService.login(loginMap);
		if (businessVO != null && businessVO.getSeller_id() != null && "seller".equals(businessVO.getRole())) {
			System.out.println("이름" + businessVO.getSeller_id());
			System.out.println("권한" +businessVO.getRole());
			HttpSession session = request.getSession();
			String business_id = businessVO.getBusiness_id();
	        PensionVO pension = businessService.pension(business_id); // 펜션 정보 조회
			session.setAttribute("isLogOn", true);
			session.setAttribute("businessInfo", businessVO);	 // 기본 정보
			
			if(pension != null) {
			session.setAttribute("pensionInfo", pension);        // 펜션 정보
	        session.setAttribute("p_num", pension.getP_num());   // p_num 따로 꺼내기 (편의성)
			}else {
				System.out.println("등록된 펜션 정보 없음");
			}  // p_num 따로 꺼내기 (편의성)
				mav.setViewName("redirect:/main/main.do");
			
		} else {
			String message = "로그인에 실패했습니다.";
			ModelAndView mav2 = new ModelAndView("/common/layout");
			mav2.addObject("message", message);
			mav2.addObject("title", "로그인");
			mav2.addObject("body", "/WEB-INF/views/business/loginForm.jsp");
			return mav2;
		}
		return mav;
	}
	
	@RequestMapping("/*Form.do")
	public ModelAndView Form(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		return mav;
	}
	
	@Override
	@RequestMapping(value = "/addSeller.do", method = RequestMethod.POST)
	public ResponseEntity addSeller(@ModelAttribute("BusinessVO") BusinessVO businessVO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		System.out.println("오너명 : " + businessVO.getOwner_name());
		System.out.println("업체명 : " + businessVO.getBusiness_name());
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			businessService.addSeller(businessVO);
			HttpSession session = request.getSession();
		    session.setAttribute("isLogOn", true);
		    session.setAttribute("businessInfo", businessVO);
			message = "<script>";
			message += " alert('회원가입 성공');";
			message += " location.href='" + request.getContextPath() + "/main/main.do';";
			message += " </script>";

		} catch (Exception e) {
			message = "<script>";
			message += " alert('회원가입 실패');";
			message += " location.href='" + request.getContextPath() + "/business/businessForm.do';";
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
		int result = businessService.overlapped(id);
		return (result == 0) ? "false" : "true";
	}
	
	@Override
	@RequestMapping(value="/mypension.do" ,method = RequestMethod.GET)
	public ModelAndView myPageMain(@RequestParam(required = false,value="message")  String message, @RequestParam(value="p_num", required= false) String p_num,  HttpServletRequest request, HttpServletResponse response)  throws Exception {
		if(businessVO == null && businessVO.getBusiness_number() == null) {

		}
		HttpSession session=request.getSession();
		session=request.getSession();
		businessVO=(BusinessVO)session.getAttribute("businessInfo");

		
	    if (businessVO == null || businessVO.getBusiness_number() == null) {
	        // 로그인 안 됐을 경우 처리
	        return new ModelAndView("redirect:/business/loginForm.do");
	    }
		
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		String business_number=businessVO.getBusiness_number();
		String business_id = businessVO.getBusiness_id();
		
			
		BusinessVO mypension = businessService.mypension(business_number);
		PensionVO pension = businessService.pension(business_id);

		
		if (p_num == null || p_num.trim().isEmpty()) {
		    Object sessionPnum = session.getAttribute("p_num");
		    if (sessionPnum != null) {
		        p_num = sessionPnum.toString();
		    } else {
		        p_num = String.valueOf(pensionVO.getP_num()); // session에도 없으면 DB에서 가져온 값 사용
		    }
		}
	    List<RoomVO> list = businessService.roomList(p_num);
	    String del_yn = pension.getDel_yn();
		System.out.println("business_id : " +business_id);
		System.out.println("business_number : " +business_number);
		System.out.println("p_num : " +p_num);
		System.out.println("del_yn : " +del_yn);
		
		mav.addObject("message", message);
		mav.addObject("pensionList", mypension);
		mav.addObject("pensionInfo", pension);
		mav.addObject("roomInfo", list);
		session.setAttribute("pensionInfo", pension);
		session.setAttribute("pensionList", mypension);
		session.setAttribute("roomInfo", list);
		session.setAttribute("p_num", p_num);

		return mav;

	}

	@Override
	@RequestMapping(value="/businessDetailInfo.do" ,method = {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView businessDetailInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		String business_number = businessVO.getBusiness_number();
		System.out.println(business_number);
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "사업자정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		BusinessVO businessVO = businessService.businessDetailInfo(business_number);
		mav.addObject("businessInfo", businessVO);
		
		return mav;
	}

	@Override
	@RequestMapping(value="/modifyMyInfo.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public ResponseEntity modifyMyInfo(String attribute, String value, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map<String,String> businessMap=new HashMap<String,String>();
		String val[]=null;
		HttpSession session=request.getSession();
		businessVO = (BusinessVO)session.getAttribute("businessInfo");
		String business_number=businessVO.getBusiness_number();
			if(attribute.equals("phone")){
			val=value.split(",");
			businessMap.put("phone1",val[0]);
			businessMap.put("phone2",val[1]);
			businessMap.put("phone3",val[2]);
		}else if(attribute.equals("email")){
			val=value.split(",");
			businessMap.put("email1",val[0]);
			businessMap.put("email2",val[1]);
		}else if(attribute.equals("address")){
			val=value.split(",");
			businessMap.put("zipcode",val[0]);
			businessMap.put("roadAddress",val[1]);
			businessMap.put("jibunAddress", val[2]);
			businessMap.put("namujiAddress", val[3]);
		}else if(attribute.equals("seller_pw")){
			businessMap.put("seller_pw", value);
		}else if(attribute.equals("bank_name")){
			businessMap.put("bank_name", value);
		}else if(attribute.equals("bank_account")) {
			businessMap.put("bank_account", value);
		}else if(attribute.equals("bank_holder")) {
			businessMap.put("bank_holder", value);
		}else {
			businessMap.put(attribute,value);	
		}
		
		businessMap.put("business_number", business_number);
		
		businessVO = (BusinessVO)businessService.modifyInfo(businessMap);
		session.removeAttribute("businessInfo");
		session.setAttribute("businessInfo", businessVO);
		
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message  = "mod_success";
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}

	@Override
	@RequestMapping(value="addpension.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public ResponseEntity addpension(@ModelAttribute("PensionVO")PensionVO pensionVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		System.out.println("업체명 : " + pensionVO.getP_name());
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			businessService.addpension(pensionVO);
			HttpSession session = request.getSession();
		    session.setAttribute("pensionInfo", pensionVO);
			message = "<script>";
			message += " alert('등록 성공');";
			message += " location.href='" + request.getContextPath() + "/business//mypension.do';";
			message += " </script>";

		} catch (Exception e) {
			message = "<script>";
			message += " alert('등록 실패');";
			message += " location.href='" + request.getContextPath() + "/business/addpensionForm.do';";
			message += " </script>";

			e.printStackTrace();
		}
		resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}

	@Override
	@RequestMapping(value="addroom.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public String addpension2(@ModelAttribute("RoomVO") RoomVO roomVO, HttpServletRequest request, HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) throws Exception {
			response.setContentType("text/html; charset=UTF-8");
			request.setCharacterEncoding("utf-8");
			System.out.println("객실명 : " + roomVO.getRoom_name());
			HttpHeaders responseHeaders = new HttpHeaders();
			responseHeaders.add("Content-Type", "text/html; charset=utf-8");

			try {
				businessService.addpension2(roomVO);
				HttpSession session = request.getSession();
			    session.setAttribute("roomInfo", roomVO);
			    session.setAttribute("message", "등록이 완료 되었습니다");	
			    return "redirect:/business/mypension.do";
			} catch (Exception e) {
				e.printStackTrace();
				HttpSession session = request.getSession();
				session.setAttribute("message", "등록에 실패 하였습니다");
			    return "redirect:/business/addroomForm.do";
			}
	}
	@Override
	@RequestMapping(value="/roomdetailInfo.do" ,method = {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView roomdetailInfo(@RequestParam("room_id") String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		System.out.println("room_id : " +room_id);
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "사업자정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		if (businessVO != null) {
	        String business_number = businessVO.getBusiness_number();
	        String business_id = businessVO.getBusiness_id();

	        BusinessVO mypension = businessService.mypension(business_number);
	        PensionVO pension = businessService.pension(business_id);

	        RoomVO roomVO = businessService.roomDetailInfo(room_id);
	        session.setAttribute("roomInfo", roomVO);
	    }
		
		return mav;
	}
	
	@Override
	@RequestMapping(value="/modifyroom.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public ResponseEntity modifyroom(@RequestParam("attribute") String attribute,@RequestParam("value") String value, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map<String,String> roomMap=new HashMap<String,String>();
		HttpSession session=request.getSession();
		roomVO = (RoomVO)session.getAttribute("roomInfo");
		String room_id=roomVO.getRoom_id();
			if(attribute.equals("room_name")){
				roomMap.put("room_name",value);
		}else if(attribute.equals("price")){
			roomMap.put("price",value);
		}else if(attribute.equals("room_type")){
			roomMap.put("room_type",value);
		}else if(attribute.equals("bed_type")){
			roomMap.put("bed_type", value);
		}else if(attribute.equals("max_capacity")){
			roomMap.put("max_capacity", value);
		}else if(attribute.equals("room_size")) {
			roomMap.put("room_size", value);
		}else if(attribute.equals("room_description")) {
			roomMap.put("room_description", value);
		}else if(attribute.equals("amenities")) {
			roomMap.put("amenities", value);
		}else {
			roomMap.put(attribute,value);	
		}
			
			roomMap.put("room_id", room_id);
			
			roomVO = (RoomVO)businessService.modifyroom(roomMap);
			session.removeAttribute("roomInfo");
			session.setAttribute("roomInfo", roomVO);
			
			String message = null;
			ResponseEntity resEntity = null;
			HttpHeaders responseHeaders = new HttpHeaders();
			message  = "mod_success";
			resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
			return resEntity;
	}

	@Override
	@RequestMapping(value="/removeroom.do", method={RequestMethod.POST,RequestMethod.GET})
	@ResponseBody
	public String removeroom(@RequestParam("room_id")String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
			System.out.println("객실 번호 : " + room_id );
			int id = Integer.parseInt(room_id);
			int result = businessService.removeroom(id);
			return (result == '0') ? "false" : "true";
	}

	@Override
	@RequestMapping(value="/pensiondetail.do", method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView pensiondetailInfo(String p_num, HttpServletRequest request, HttpServletRequest response)
			throws Exception {
		HttpSession session = request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		System.out.println("받은 p_num : " +p_num);
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "사업자정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		return mav;
	}

	@Override
	@RequestMapping(value="/modifypension.do", method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView modifypension(HttpServletRequest request,	HttpServletResponse response) throws Exception {
		String p_name = request.getParameter("p_name");
		String tel1 = request.getParameter("tel1");
		String tel2 = request.getParameter("tel2");
		String tel3 = request.getParameter("tel3");
		String room_count = request.getParameter("room_count");
		String facilities = request.getParameter("facilities");
		String description = request.getParameter("description");
		
		PensionVO pensionVO = new PensionVO();
		pensionVO.setP_name(p_name);
		pensionVO.setTel1(tel1);
		pensionVO.setTel2(tel2);
		pensionVO.setTel3(tel3);
		pensionVO.setRoom_count(room_count);
		pensionVO.setFacilities(facilities);
		pensionVO.setDescription(description);
		int result = businessService.updatepension(pensionVO);
		HttpSession session = request.getSession();
		//리
		request.getSession().setAttribute("message", "수정이 완료 되었습니다");
		System.out.println("세션에 message 넣음: " + session.getAttribute("message"));
		ModelAndView mav = new ModelAndView("redirect:/business/mypension.do");
		return mav;
	}

	@Override
	@RequestMapping(value="/removepension.do", method={RequestMethod.POST,RequestMethod.GET})
	@ResponseBody
	public String removepension(@RequestParam ("p_num")String p_num, HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("펜션 번호 : " + p_num );
		int id = Integer.parseInt(p_num);
		System.out.println(id);
		int result = businessService.removepension(id);
		System.out.println(result);
		return (result == 0 ) ? "false" : "true";
	}
}


