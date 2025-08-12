package com.petmillie.business.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petmillie.business.service.BusinessService;
import com.petmillie.business.vo.BusinessVO;
import com.petmillie.business.vo.PensionVO;
import com.petmillie.business.vo.RoomVO;
import com.petmillie.common.base.BaseController;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;

@Controller("businessController")
@RequestMapping("/business")
public class BusinessControllerImpl extends BaseController implements BusinessController {
	private static final String CURR_IMAGE_REPO_PATH = "C:\\petupload\\goods";
	@Autowired
	private BusinessService businessService;
	@Autowired
	private BusinessVO businessVO;
	@Autowired
	private PensionVO pensionVO;
	@Autowired
	private RoomVO roomVO;
	
	@Override
	@RequestMapping(value = "/busilogin.do", method = RequestMethod.POST)
	public ModelAndView login(@RequestParam("seller_id") String seller_id, @RequestParam("seller_pw") String seller_pw, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//사업자 로그인
		ModelAndView mav = new ModelAndView("/common/layout");
		int result = businessService.overlapped(seller_id);

		if(result != 0) {
			//아이디 존재
			BusinessVO businessVO = businessService.login(seller_id, seller_pw);
			if(businessVO == null) {
				//비밀번호 틀림
				mav.addObject("title", "로그인");
				mav.addObject("message", "비밀번호가 일치하지 않습니다.");
				mav.addObject("body", "/WEB-INF/views/business/loginForm.jsp");
			}else {
				//로그인 성공
				mav.addObject("title", "메인페이지");
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
				}
				mav.setViewName("redirect:/main/main.do");
			}
		}else {
			mav.addObject("title", "로그인");
			mav.addObject("message", "존재하지 않는 아이디 입니다.");
			mav.addObject("body", "/WEB-INF/views/business/loginForm.jsp");
		}
		
		return mav;
	}
	
	@Override
	@RequestMapping(value = "/addSeller.do", method = RequestMethod.POST)
	public ResponseEntity addSeller(@ModelAttribute("BusinessVO") BusinessVO businessVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//사업자 회원가입
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("utf-8");
		
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
			message += " alert('회원가입이 완료되었습니다. 반갑습니다.');";
			message += " location.href='" + request.getContextPath() + "/main/main.do';";
			message += " </script>";

		} catch (Exception e) {
			message = "<script>";
			message += " alert('회원가입에 실패했습니다. 다시 시도해주세요.');";
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
	public String overlapped(@RequestParam("id") String id, HttpServletRequest request, HttpServletResponse response) throws Exception {
		//아이디 중복체크
		int result = businessService.overlapped(id);
		return (result == 0) ? "false" : "true";
	}
	
	@RequestMapping("/*Form.do")
	public ModelAndView Form(HttpServletRequest request, HttpServletResponse response) throws Exception {
		//입력 폼 출력
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		return mav;
	}
	
	@Override
	@RequestMapping(value="/mypension.do", method = RequestMethod.GET)
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
	
	@RequestMapping(value="/deleteMember.do", method= {RequestMethod.POST,RequestMethod.GET})
	public String deleteMember (@RequestParam("business_number") String business_number,HttpSession session, RedirectAttributes redirectAttributes) throws Exception{
		businessService.removeMember(business_number);
		session.invalidate();
		redirectAttributes.addFlashAttribute("message","회원탈퇴가 완료되었습니다.");
		return "redirect:/main/main.do";
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

	@RequestMapping(value="addroom.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public String addpension2(RoomVO roomVO, 
	                          @RequestParam(value="file", required = false) MultipartFile fileimage, 
	                          HttpServletRequest request, 
	                          HttpServletResponse response, 
	                          Model model, 
	                          RedirectAttributes redirectAttributes) throws Exception {

	    System.out.println("addroom.do 컨트롤러 진입");
	    response.setContentType("text/html; charset=UTF-8");
	    request.setCharacterEncoding("utf-8"); 
	    System.out.println("객실명 : " + roomVO.getRoom_name());

	    if (fileimage == null || fileimage.isEmpty()) {
	        redirectAttributes.addFlashAttribute("message", "이미지를 반드시 선택해주세요.");
	        return "redirect:/business/addroomForm.do";
	    }

	    try {
	        String saveDir = "C:\\petupload\\room";
	        File uploadPath = new File(saveDir);
	        if (!uploadPath.exists()) uploadPath.mkdirs();

	        // 🔧 UUID로 파일명 변환
	        String originalFileName = fileimage.getOriginalFilename();
	        String uuid = UUID.randomUUID().toString();
	        String extension = "";

	        // 확장자 추출
	        int dotIndex = originalFileName.lastIndexOf(".");
	        if (dotIndex != -1) {
	            extension = originalFileName.substring(dotIndex);
	        }

	        String savedFileName = uuid + extension;
	        System.out.println("저장할 파일명: " + savedFileName);

	        File saveFile = new File(uploadPath, savedFileName);
	        fileimage.transferTo(saveFile);  // 실제 파일 저장

	        roomVO.setFileimage(savedFileName);  // 🔧 UUID 적용된 이름으로 저장
	        businessService.addpension2(roomVO);

	        HttpSession session = request.getSession();
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
	
	@Override
	@RequestMapping(value="/addNewGoods.do", method={RequestMethod.POST,RequestMethod.GET})
	@ResponseBody
	public ResponseEntity addNewGoods(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception {
	    multipartRequest.setCharacterEncoding("utf-8");
	    response.setContentType("text/html; charset=UTF-8");
	    String imageFileName = null;

	    Map<String, Object> newGoodsMap = new HashMap<>();
	    Enumeration<?> enu = multipartRequest.getParameterNames();
	    while (enu.hasMoreElements()) {
	        String name = (String) enu.nextElement();
	        String value = multipartRequest.getParameter(name);
	        newGoodsMap.put(name, value);
	    }

	    HttpSession session = multipartRequest.getSession();
	    BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");
	    String reg_id = businessVO.getSeller_id();

	    // ✅ 이미지 업로드 처리
	    List<ImageFileVO> imageFileList = new ArrayList<>();
	    Iterator<String> fileNames = multipartRequest.getFileNames();

	    while (fileNames.hasNext()) {
	        MultipartFile multipartFile = multipartRequest.getFile(fileNames.next());

	        if (multipartFile != null && !multipartFile.isEmpty()) {
	            String originalName = multipartFile.getOriginalFilename();
	            String ext = originalName.substring(originalName.lastIndexOf("."));
	            String newFileName = UUID.randomUUID().toString() + ext;

	            File tempDir = new File(CURR_IMAGE_REPO_PATH + File.separator + "temp");
	            if (!tempDir.exists()) {
	                tempDir.mkdirs();
	            }

	            File destFile = new File(tempDir, newFileName);
	            multipartFile.transferTo(destFile); // ✅ 실제 파일 저장

	            ImageFileVO imageFileVO = new ImageFileVO();
	            imageFileVO.setFileName(newFileName);
	            imageFileVO.setReg_id(reg_id);

	            String extension = ext.toLowerCase();
	            if (extension.matches(".jpg|.jpeg|.png|.gif")) {
	                imageFileVO.setFileType("image");
	            } else {
	                imageFileVO.setFileType("etc");
	            }

	            imageFileList.add(imageFileVO);
	        }
	    }

	    if (!imageFileList.isEmpty()) {
	        String mainImageFileName = imageFileList.get(0).getFileName();
	        newGoodsMap.put("goods_fileName", mainImageFileName);
	        newGoodsMap.put("imageFileList", imageFileList);
	    }

	    String message = null;
	    ResponseEntity resEntity = null;
	    HttpHeaders responseHeaders = new HttpHeaders();
	    responseHeaders.add("Content-Type", "text/html; charset=utf-8");

	    try {
	        int goods_num = businessService.addNewGoods(newGoodsMap);

	        if (!imageFileList.isEmpty()) {
	            for (ImageFileVO imageFileVO : imageFileList) {
	                imageFileName = imageFileVO.getFileName();
	                File srcFile = new File(CURR_IMAGE_REPO_PATH + File.separator + "temp" + File.separator + imageFileName);
	                File destDir = new File(CURR_IMAGE_REPO_PATH + File.separator + goods_num);
	                FileUtils.moveFileToDirectory(srcFile, destDir, true);
	            }
	        }

	        message = "<script>";
	        message += " alert('등록성공.');";
	        message += " location.href='" + multipartRequest.getContextPath() + "/business/businessGoodsMain.do';";
	        message += "</script>";

	    } catch (Exception e) {
	        if (!imageFileList.isEmpty()) {
	            for (ImageFileVO imageFileVO : imageFileList) {
	                imageFileName = imageFileVO.getFileName();
	                File srcFile = new File(CURR_IMAGE_REPO_PATH + File.separator + "temp" + File.separator + imageFileName);
	                if (srcFile.exists()) srcFile.delete();
	            }
	        }

	        message = "<script>";
	        message += " alert('등록실패');";
	        message += " location.href='" + multipartRequest.getContextPath() + "/business/addNewGoodsForm.do';";
	        message += "</script>";

	        e.printStackTrace();
	    }

	    resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	    return resEntity;
	}
	

	@RequestMapping(value="/businessGoodsMain.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView businessGoodsMain(@RequestParam Map<String, String> dateMap,
			 HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session=request.getSession();
		session=request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

		session.setAttribute("side_menu", "business_mode");

		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String section = dateMap.get("section");
		String pageNum = dateMap.get("pageNum");
		String beginDate=null,endDate=null;

		String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
		beginDate=tempDate[0];
		endDate=tempDate[1];
		dateMap.put("beginDate", beginDate);
		dateMap.put("endDate", endDate);

		Map<String,Object> condMap=new HashMap<String,Object>();
		if(section== null) {
			section = "1";
		}
		condMap.put("section",section);
		if(pageNum== null) {
			pageNum = "1";
		}
		condMap.put("pageNum",pageNum);
		condMap.put("beginDate",beginDate);
		condMap.put("endDate", endDate);

        int pageSize = 10;
        int currentPage = Integer.parseInt(pageNum);
        int offset = (currentPage - 1) * pageSize;

        condMap.put("offset", offset);
        condMap.put("limit", pageSize);

	    BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");
	    String reg_id = businessVO.getBusiness_number();
	    
		List<GoodsVO> newGoodsList=businessService.listNewGoods(condMap);
		mav.addObject("newGoodsList", newGoodsList);

		String beginDate1[]=beginDate.split("-");
		String endDate2[]=endDate.split("-");
		mav.addObject("beginYear",beginDate1[0]);
		mav.addObject("beginMonth",beginDate1[1]);
		mav.addObject("beginDay",beginDate1[2]);
		mav.addObject("endYear",endDate2[0]);
		mav.addObject("endMonth",endDate2[1]);
		mav.addObject("endDay",endDate2[2]);

		mav.addObject("section", section);
		mav.addObject("pageNum", pageNum);
		return mav;

	}
}


