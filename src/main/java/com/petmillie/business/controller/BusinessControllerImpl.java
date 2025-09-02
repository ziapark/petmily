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
import com.petmillie.business.vo.Room_image;
import com.petmillie.common.base.BaseController;
import com.petmillie.common.file.FileDownloadController;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.vo.OrderVO;

@Controller("businessController")
@RequestMapping("/business")
public class BusinessControllerImpl extends BaseController implements BusinessController {
	private static final String CURR_IMAGE_GOODS_REPO_PATH = "C:\\petrepo\\goods";
	private static final String CURR_IMAGE_PENSION_REPO_PATH = "C:\\petrepo\\pension";
	private static final String PENSION_IMAGE_REPO = "C:\\petrepo\\room";
	@Autowired
	private BusinessService businessService;
	@Autowired
	private BusinessVO businessVO;
	@Autowired
	private PensionVO pensionVO;
	@Autowired
	private RoomVO roomVO;
	@Autowired
    private FileDownloadController fileDownloadController;
	
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
				//탈퇴한 회원
				if("Y".equals(businessVO.getDel_yn())) {
					mav.addObject("title", "로그인");
					mav.addObject("message", "탈퇴한 회원 입니다. 회원가입해주세요.");
					mav.addObject("body", "/WEB-INF/views/member/loginForm.jsp");
					
					return mav;
				}
				
				//로그인 성공
				mav.addObject("title", "메인페이지");
				HttpSession session = request.getSession();
				String business_id = businessVO.getBusiness_id();
				session.setAttribute("isLogOn", true);
				session.setAttribute("businessInfo", businessVO);	 // 기본 정보
				
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
		
		String isDuplicate = businessService.isBusinessNumberDuplicate(businessVO.getBusiness_number());
		
		if(isDuplicate.equals("true")) {
			//이미 가입된 사업자 번호
		    String message = "<script>";
		    message += " alert('이미 가입된 사업자번호입니다.');";
		    message += " location.href='" + request.getContextPath() + "/business/loginForm.do';";
		    message += "</script>";

		    HttpHeaders responseHeaders = new HttpHeaders();
		    responseHeaders.add("Content-Type", "text/html; charset=utf-8");

		    return new ResponseEntity<>(message, responseHeaders, HttpStatus.OK);
		}else {
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
	
	@RequestMapping("/addroomForm.do")
	public ModelAndView addroomForm(@RequestParam(value="p_num", required = false) int p_num, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		mav.addObject("p_num", p_num);
		return mav;
	}
	
	@Override
	@RequestMapping(value="/mypension.do", method = RequestMethod.GET)
	public ModelAndView myPageMain(@RequestParam(value="business_id", required = false) String business_id, HttpServletRequest request, HttpServletResponse response)  throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		PensionVO pension = businessService.pension(business_id);
		BusinessVO pensionList = businessService.mypension(business_id);
		
		List<RoomVO> list = new ArrayList<>();
		if (pension != null) {
			list = businessService.roomList(pension.getP_num());
		}

		mav.addObject("pensionList", pensionList);
		mav.addObject("pensionInfo", pension);
		mav.addObject("roomInfo", list);

		return mav;
	}

	
	@Override
	@RequestMapping(value="/businessDetailInfo.do" ,method = {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView businessDetailInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 1. 세션에서 로그인한 사업자 정보를 가져옵니다.
		HttpSession session = request.getSession();
		BusinessVO sessionBusinessVO = (BusinessVO) session.getAttribute("businessInfo");

		// 2. 만약 로그인 정보가 없으면 로그인 페이지로 보냅니다.
		if (sessionBusinessVO == null) {
			return new ModelAndView("redirect:/business/loginForm.do");
		}

		String viewName=(String)request.getAttribute("viewName");
		
		// 3. 세션에서 가져온 business_number를 사용합니다.
		String business_number = sessionBusinessVO.getBusiness_number();
		
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "사업자정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		// 4. DB에서 최신 정보를 조회하여 화면에 전달합니다.
		BusinessVO businessVO = businessService.businessDetailInfo(business_number);
		mav.addObject("businessInfo", businessVO);
		
		return mav;
	}


	@Override
	@RequestMapping(value="/modifyMyInfo.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public ResponseEntity modifyMyInfo(String attribute, String value, HttpServletRequest request,
	        HttpServletResponse response) throws Exception {

	    HttpSession session = request.getSession();
	    BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");

	    // 세션에 businessInfo가 없으면 바로 실패 응답
	    if (businessVO == null) {
	        String message = "failed";
	        HttpHeaders responseHeaders = new HttpHeaders();
	        return new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	    }

	    Map<String,String> businessMap = new HashMap<>();
	    String[] val = null;
	    String business_number = businessVO.getBusiness_number();

	    if(attribute.equals("phone")){
	        val = value.split(",");
	        businessMap.put("phone1", val[0]);
	        businessMap.put("phone2", val[1]);
	        businessMap.put("phone3", val[2]);
	    } else if(attribute.equals("email")){
	        val = value.split(",");
	        businessMap.put("email1", val[0]);
	        businessMap.put("email2", val[1]);
	    } else if(attribute.equals("address")){
	        val = value.split(",");
	        businessMap.put("zipcode", val[0]);
	        businessMap.put("roadAddress", val[1]);
	        businessMap.put("jibunAddress", val[2]);
	        businessMap.put("namujiAddress", val[3]);
	    } else if(attribute.equals("seller_pw")){
	        businessMap.put("seller_pw", value);
	    } else if(attribute.equals("bank_name")){
	        businessMap.put("bank_name", value);
	    } else if(attribute.equals("bank_account")) {
	        businessMap.put("bank_account", value);
	    } else if(attribute.equals("bank_holder")) {
	        businessMap.put("bank_holder", value);
	    } else {
	        businessMap.put(attribute, value);    
	    }

	    businessMap.put("business_number", business_number);

	    // Service 호출
	    businessVO = (BusinessVO) businessService.modifyInfo(businessMap);

	    // 세션 업데이트
	    session.removeAttribute("businessInfo");
	    session.setAttribute("businessInfo", businessVO);

	    String message = "mod_success";
	    HttpHeaders responseHeaders = new HttpHeaders();
	 
	    return new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	}
	
	@Override
	@RequestMapping(value="/deleteForm.do", method=RequestMethod.GET)
	public ModelAndView deleteForm(HttpServletRequest request, HttpServletResponse response) throws Exception{
	    HttpSession session = request.getSession();
	    MemberVO memberVO =(MemberVO) session.getAttribute("memberInfo");
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "메인페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		mav.addObject("memberInfo", memberVO);
		
		return mav;
	}
	
	@RequestMapping(value="/deleteMember.do", method= {RequestMethod.POST,RequestMethod.GET})
	public String deleteMember (@RequestParam("seller_id") String seller_id, HttpSession session, RedirectAttributes redirectAttributes) throws Exception{
		businessService.removeMember(seller_id);
		session.invalidate();
		redirectAttributes.addFlashAttribute("message","회원탈퇴가 완료되었습니다.");
		return "redirect:/main/main.do";
	}

	@RequestMapping(value="/addpension.do" , method= {RequestMethod.POST}) // GET 방식은 파일 업로드에 부적합하므로 POST만 사용
    // ▼▼▼ 5. 파라미터 수정: 이미지 파일을 받기 위해 @RequestParam("mainImage") MultipartFile 추가
    public ResponseEntity addpension(@ModelAttribute("pensionVO") PensionVO pensionVO,
                                     @RequestParam("mainImage") MultipartFile mainImage, 
                                     HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 기존 코드와 동일 (인코딩 설정)
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("utf-8");
        String message = null;
        ResponseEntity resEntity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.add("Content-Type", "text/html; charset=utf-8");

        try {
            // ▼▼▼ 6. 파일 업로드 로직 호출 및 파일명 설정
            // FileDownloadController에 파일 저장을 요청하고, 저장된 파일명을 받아옵니다.
            String fileName = fileDownloadController.uploadPensionImage(mainImage);
            // PensionVO 객체에 DB에 저장할 파일명을 설정합니다.
            pensionVO.setFileName(fileName); 

            // --- 이 아래는 기존 코드와 거의 동일합니다 ---
            HttpSession session = request.getSession();
            String business_id_to_check = pensionVO.getBusiness_id();

            if (business_id_to_check == null || business_id_to_check.isEmpty()) {
                BusinessVO loginBusinessVO = (BusinessVO) session.getAttribute("businessInfo");
                if (loginBusinessVO == null) {
                    message = "<script>alert('로그인 정보가 만료되었습니다.'); location.href='"+request.getContextPath()+"/business/loginForm.do';</script>";
                    return new ResponseEntity(message, responseHeaders, HttpStatus.OK);
                }
                business_id_to_check = loginBusinessVO.getBusiness_id();
                pensionVO.setBusiness_id(business_id_to_check);
            }

            PensionVO existingPension = businessService.pension(business_id_to_check);
            if (existingPension != null) {
                message = "<script>alert('이미 등록된 펜션이 있습니다. 펜션은 하나만 등록할 수 있습니다.');history.back();</script>";
                return new ResponseEntity(message, responseHeaders, HttpStatus.OK);
            }
            
            // DB에 펜션 정보와 파일명을 함께 저장
            businessService.addpension(pensionVO);

            String redirectUrl = (session.getAttribute("adminInfo") != null)
                                ? request.getContextPath() + "/admin/pension/adminPensionList.do"
                                : request.getContextPath() + "/business/mypension.do";

            message = "<script>alert('등록 성공'); location.href='" + redirectUrl + "';</script>";

        } catch (Exception e) {
            message = "<script>alert('등록 실패'); location.href='" + request.getContextPath() + "/business/addpensionForm.do';</script>";
            e.printStackTrace();
        }
        resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
        return resEntity;
    }

	
	@RequestMapping(value="addroom.do" , method= {RequestMethod.POST,RequestMethod.GET})
	public String addpension2(RoomVO roomVO, 
							  @RequestParam(value="files", required = false) List<MultipartFile> files, 
	                          HttpServletRequest request, 
	                          HttpServletResponse response, 
	                          Model model, 
	                          RedirectAttributes redirectAttributes) throws Exception {
	    response.setContentType("text/html; charset=UTF-8");
	    request.setCharacterEncoding("utf-8"); 

	    if (files == null || files.isEmpty() || files.get(0).isEmpty()) {
	        redirectAttributes.addFlashAttribute("message", "이미지를 1장 이상 반드시 선택해주세요.");
	        redirectAttributes.addAttribute("p_num", roomVO.getP_num()); 
	        return "redirect:/business/addroomForm.do";
	    }

	    try {
	    	int newRoomId = businessService.addNewRoomAndGetId(roomVO);
	    	
	        List<Room_image> imageFileList = new ArrayList<>();
	        File uploadPath = new File(PENSION_IMAGE_REPO);
	        if (!uploadPath.exists()) uploadPath.mkdirs();
	        
	        String saveDir = "C:\\petrepo\\room";
	        uploadPath = new File(saveDir);
	        if (!uploadPath.exists()) uploadPath.mkdirs();

	        for (MultipartFile file : files) {
	            // 파일 이름 고유하게 만들기
	            String originalFileName = file.getOriginalFilename();
	            String uuid = UUID.randomUUID().toString();
	            String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
	            String savedFileName = uuid + extension;

	            // 서버에 파일 저장
	            File saveFile = new File(uploadPath, savedFileName);
	            file.transferTo(saveFile);

	            Room_image imageVO = new Room_image();
	            imageVO.setRoom_id(newRoomId); // 방금 만든 객실 ID와 연결
	            imageVO.setFileName(savedFileName); // 서버에 저장된 파일 이름
	            imageFileList.add(imageVO);
	        }
	        
	        businessService.addRoomImages(imageFileList);

	        HttpSession session = request.getSession();
	        BusinessVO businessInfo = (BusinessVO) session.getAttribute("businessInfo");
	        
	        if (businessInfo != null) {
	            redirectAttributes.addAttribute("business_id", businessInfo.getBusiness_id());
	        }
	        
	        redirectAttributes.addFlashAttribute("message", "객실 등록이 완료되었습니다.");
	        // mypension.do 로 p_num을 보내줘야 해당 펜션의 객실 목록을 볼 수 있습니다.
	        redirectAttributes.addAttribute("p_num", roomVO.getP_num()); 
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
	public ModelAndView roomdetailInfo(@RequestParam("room_id") int room_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
	public ResponseEntity modifyroom(@RequestParam("attribute") String attribute, @RequestParam("value") String value, @RequestParam("room_id") String room_id, HttpServletRequest request,
		HttpServletResponse response) throws Exception {
		
		Map<String,String> roomMap=new HashMap<String,String>();
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
		
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message  = "mod_success";
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}

	@RequestMapping(value="/modifyRoomImage.do", method=RequestMethod.POST)
	public ResponseEntity<String> modifyRoomImage(@RequestParam("room_id") int room_id,
	                                                @RequestParam("file") MultipartFile file,
	                                                HttpServletRequest request) throws Exception {

	    // 1. 새로운 이미지 파일을 서버에 저장하는 로직
	    String originalFileName = file.getOriginalFilename();
	    
	    // 중복을 피하기 위해 고유한 파일 이름 생성 (UUID 사용)
	    String uuid = UUID.randomUUID().toString();
	    String extension = originalFileName.substring(originalFileName.lastIndexOf("."));
	    String savedFileName = uuid + extension;

	    // 파일 저장 경로 설정 (기존에 사용하시던 경로)
	    String saveDir = "C:\\petrepo\\room";
	    File uploadPath = new File(saveDir);
	    if (!uploadPath.exists()) {
	        uploadPath.mkdirs();
	    }
	    
	    // 파일을 실제로 저장
	    File saveFile = new File(uploadPath, savedFileName);
	    file.transferTo(saveFile);


	    // 2. 데이터베이스에 저장할 정보를 Map에 담기
	    Map<String, Object> imageFileMap = new HashMap<>();
	    imageFileMap.put("room_id", room_id);
	    imageFileMap.put("fileName", savedFileName); // DB에는 새로 저장된 파일 이름을 업데이트

	    // 3. Service 계층에 DB 업데이트 요청
	    try {
	        businessService.modifyRoomImage(imageFileMap);
	        // TODO: 기존에 있던 이미지 파일은 서버에서 삭제해주는 로직을 추가하면 더 좋습니다.
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        // 만약 DB 업데이트 실패 시, 방금 업로드한 파일도 삭제해주는 것이 좋습니다.
	        saveFile.delete();
	        return new ResponseEntity<>("mod_failed", HttpStatus.INTERNAL_SERVER_ERROR);
	    }

	    // 4. 성공 응답 반환
	    return new ResponseEntity<>("mod_success", HttpStatus.OK);
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
	public ModelAndView pensiondetailInfo(@RequestParam("p_num") int p_num, HttpServletRequest request, HttpServletRequest response) throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("title", "사업자정보관리");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		PensionVO pensionInfo = new PensionVO();
		pensionInfo = businessService.pensiondetailInfo(p_num);
		mav.addObject("pensionInfo", pensionInfo);
		
		return mav;
	}

	@Override
    @RequestMapping(value="/modifypension.do", method={RequestMethod.POST})
    public ModelAndView modifypension(@ModelAttribute("pensionVO") PensionVO pensionVO,
                                      @RequestParam("mainImage") MultipartFile mainImage,
                                      @RequestParam("originalFileName") String originalFileName,
                                      HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 새 이미지 파일이 첨부되었는지 확인
        if (mainImage != null && !mainImage.isEmpty()) {
            // 새 파일이 있으면 업로드하고, 새로운 파일명을 받아옵니다.
            String newFileName = fileDownloadController.uploadPensionImage(mainImage);
            // pensionVO에 새로운 파일명을 설정합니다.
            pensionVO.setFileName(newFileName);
        } else {
            // 새 파일이 없으면, 기존 파일명을 그대로 사용합니다.
            pensionVO.setFileName(originalFileName);
        }
        
        // 2. Service를 호출하여 DB 정보 업데이트 (텍스트 정보 + 파일명)
        businessService.updatepension(pensionVO);
        
        // 3. 수정 완료 후 마이페이지로 리다이렉트
        ModelAndView mav = new ModelAndView("redirect:/business/mypension.do");
        
        // 수정 완료 메시지를 전달하고 싶으면 RedirectAttributes를 사용하는 것이 더 좋습니다.
        // request.getSession().setAttribute("message", "수정이 완료 되었습니다");
        
        return mav;
    }

	@Override
	@RequestMapping(value="/removepension.do", method={RequestMethod.POST,RequestMethod.GET})
	@ResponseBody
	public String removepension(@RequestParam ("p_num")String p_num, HttpServletRequest request, HttpServletResponse response) throws Exception {
		int id = Integer.parseInt(p_num);
		int result = businessService.removepension(id);
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

	    //이미지 업로드 처리
	    List<ImageFileVO> imageFileList = new ArrayList<>();
	    Iterator<String> fileNames = multipartRequest.getFileNames();
	    
	    int fileOrder = 0;
	    while (fileNames.hasNext()) {
	        MultipartFile multipartFile = multipartRequest.getFile(fileNames.next());

	        if (multipartFile != null && !multipartFile.isEmpty()) {
	            String originalName = multipartFile.getOriginalFilename();
	            String ext = originalName.substring(originalName.lastIndexOf("."));
	            String newFileName = UUID.randomUUID().toString() + ext;

	            File tempDir = new File(CURR_IMAGE_GOODS_REPO_PATH + File.separator + "temp");
	            if (!tempDir.exists()) {
	                tempDir.mkdirs();
	            }

	            File destFile = new File(tempDir, newFileName);
	            multipartFile.transferTo(destFile); //실제 파일 저장

	            ImageFileVO imageFileVO = new ImageFileVO();
	       
	            imageFileVO.setFileName(newFileName);
	            imageFileVO.setReg_id(reg_id);
	            if (fileOrder == 0) {
	                imageFileVO.setFileType("main"); // 첫 번째 파일
	            } else {
	                imageFileVO.setFileType("sub");  // 두 번째부터
	            }

	            imageFileList.add(imageFileVO);
	            fileOrder++;
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
	                File srcFile = new File(CURR_IMAGE_GOODS_REPO_PATH + File.separator + "temp" + File.separator + imageFileName);
	                File destDir = new File(CURR_IMAGE_GOODS_REPO_PATH + File.separator + goods_num);
	                FileUtils.moveFileToDirectory(srcFile, destDir, true);
	            }
	        }

	        message = "<script>";
	        message += " alert('상품이 등록되었습니다.');";
	        message += " location.href='" + multipartRequest.getContextPath() + "/business/businessGoodsMain.do';";
	        message += "</script>";

	    } catch (Exception e) {
	        if (!imageFileList.isEmpty()) {
	            for (ImageFileVO imageFileVO : imageFileList) {
	                imageFileName = imageFileVO.getFileName();
	                File srcFile = new File(CURR_IMAGE_GOODS_REPO_PATH + File.separator + "temp" + File.separator + imageFileName);
	                if (srcFile.exists()) srcFile.delete();
	            }
	        }

	        message = "<script>";
	        message += " alert('상품 등록에 실패했습니다. 다시 시도해주세요.');";
	        message += " location.href='" + multipartRequest.getContextPath() + "/business/addNewGoodsForm.do';";
	        message += "</script>";

	        e.printStackTrace();
	    }

	    resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	    return resEntity;
	}
	

	//사업자 등록 상품 리스트 보기
	
	@RequestMapping(value="/businessGoodsMain.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView businessGoodsMain(@RequestParam Map<String, String> dateMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    HttpSession session=request.getSession();
	    String viewName=(String)request.getAttribute("viewName");
	    ModelAndView mav=new ModelAndView("/common/layout");
	    mav.addObject("title", "상품관리");
	    mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

	    // ▼▼▼▼▼ 1. 페이지 파라미터 받기 ▼▼▼▼▼
	    String section_str = dateMap.get("section");
	    String pageNum_str = dateMap.get("pageNum");
	    if(section_str== null) {
	        section_str = "1";
	    }
	    if(pageNum_str== null) {
	        pageNum_str = "1";
	    }
	    int section = Integer.parseInt(section_str);
	    int pageNum = Integer.parseInt(pageNum_str);

	    // ▼▼▼▼▼ 2. 날짜 및 검색 조건 설정 (핵심 수정 부분) ▼▼▼▼▼
	    
	    // DB 조회를 위한 조건 맵(condMap) 생성
	    Map<String,Object> condMap=new HashMap<String,Object>();
	    
	    // ⭐⭐⭐ 사용자가 날짜를 클릭했을 때만(fixedSearchPeriod가 있을 때만) 날짜 조건을 Map에 추가 ⭐⭐⭐
	    String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
	    if(fixedSearchPeriod != null && !fixedSearchPeriod.isEmpty()) {
	        String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
	        String beginDate=tempDate[0];
	        String endDate=tempDate[1];
	        condMap.put("beginDate",beginDate);
	        condMap.put("endDate", endDate);
	        
	        // JSP에 조회 기간을 표시하기 위해 날짜 정보를 mav에 추가
	        String beginDate1[]=beginDate.split("-");
	        String endDate2[]=endDate.split("-");
	        mav.addObject("beginYear",beginDate1[0]);
	        mav.addObject("beginMonth",beginDate1[1]);
	        mav.addObject("beginDay",beginDate1[2]);
	        mav.addObject("endYear",endDate2[0]);
	        mav.addObject("endMonth",endDate2[1]);
	        mav.addObject("endDay",endDate2[2]);
	    }
	    
	    BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");
	    String seller_id = businessVO.getSeller_id();
	    condMap.put("seller_id", seller_id);
	    
	    // ▼▼▼▼▼ 3. 페이지 정보 계산 (이전과 동일) ▼▼▼▼▼
	    int totalGoodsCount = businessService.getGoodsCount(condMap); 
	    int pageSize = 10;
	    int sectionSize = 10;
	    int totalPageCount = (int)Math.ceil((double)totalGoodsCount / pageSize);
	    int currentPageNum = (section - 1) * sectionSize + pageNum;
	    int totalPagesInSection = 0;
	    int lastSection = (int)Math.ceil((double)totalPageCount / sectionSize);
	    if (section < lastSection) {
	        totalPagesInSection = sectionSize;
	    } else {
	        totalPagesInSection = totalPageCount > 0 ? (totalPageCount % sectionSize == 0 ? sectionSize : totalPageCount % sectionSize) : 0;
	    }
	    
	    Map<String, Object> pageInfo = new HashMap<>();
	    pageInfo.put("totalPageCount", totalPageCount);
	    pageInfo.put("section", section);
	    pageInfo.put("currentPageNum", currentPageNum);
	    pageInfo.put("totalPagesInSection", totalPagesInSection);
	    
	    mav.addObject("pageInfo", pageInfo);

	    // ▼▼▼▼▼ 4. DB 조회를 위한 offset, limit 설정 (이전과 동일) ▼▼▼▼▼
	    int offset = (currentPageNum - 1) * pageSize;
	    int limit = pageSize;
	    
	    condMap.put("offset", offset);
	    condMap.put("limit", limit);
	    
	    // ▼▼▼▼▼ 5. DB에서 상품 목록 조회 및 mav에 추가 (이전과 동일) ▼▼▼▼▼
	    List<GoodsVO> newGoodsList=businessService.listNewGoods(condMap);
	    mav.addObject("newGoodsList", newGoodsList);

	    return mav;
	}
	//사업자 상품 상태 변경
	@RequestMapping(value = "/updateGoodsStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateGoodsStatus(@RequestParam("goods_num") int goods_num, @RequestParam("goods_status") String goods_status, HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    BusinessVO businessVO = (BusinessVO) session.getAttribute("businessInfo");
	    String seller_id = businessVO.getSeller_id();

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("goods_num", goods_num);
	    paramMap.put("goods_status", goods_status);
	    paramMap.put("seller_id", seller_id); // 소유자 확인용
	    
	    try {
	        int result = businessService.updateGoodsStatus(paramMap);
	        if (result > 0) {
	            return "success"; // 성공
	        } else {
	            return "fail";    // 실패 (상품 소유자가 아니거나, DB 오류)
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "fail";
	    }
	}
	
	// 상품명 중복 체크(사업자/관리자 같이 사용)
	@RequestMapping(value = "/checkGoodsName.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkGoodsName(HttpServletRequest request) throws Exception {
	    String goods_name = request.getParameter("goods_name");
	    int count = businessService.checkOverlappedGoodsName(goods_name);

	    if (count == 0) {
	        return "true"; // 사용하는 사람이 없으면 true
	    } else {
	        return "false"; // 이미 사용 중이면 false
	    }
	}
	
	@RequestMapping(value="/restoreroom.do", method={RequestMethod.POST,RequestMethod.GET})
	@ResponseBody
	public String restoreroom(@RequestParam("room_id") String room_id, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    System.out.println("객실 복구 번호 : " + room_id );
	    int id = Integer.parseInt(room_id);
	    int result = businessService.restoreroom(id);
	    return (result > 0) ? "true" : "false";
	}
	
	@Override
	@RequestMapping(value="/businessOrderMain.do" ,method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView businessOrderMain(@RequestParam Map<String, String> dateMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String viewName=(String)request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views"+viewName +".jsp");

	    // ▼▼▼▼▼ 1. 페이지 파라미터 받기 (기존 코드) ▼▼▼▼▼
	    String section_str = dateMap.get("section"); // JSP에서는 chapter로 보내지만, 여기선 section으로 받음
	    String pageNum_str = dateMap.get("pageNum");
	    if(section_str == null) {
	        section_str = "1";
	    }
	    if(pageNum_str == null) {
	        pageNum_str = "1";
	    }
	    int section = Integer.parseInt(section_str);
	    int pageNum = Integer.parseInt(pageNum_str);

	    // ▼▼▼▼▼ 2. 날짜 및 검색 조건 설정 (기존 코드) ▼▼▼▼▼
	    String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
	    String beginDate=null,endDate=null;

	    String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
	    beginDate=tempDate[0];
	    endDate=tempDate[1];
	    
	    // DB 조회를 위한 조건 맵(condMap) 생성
	    HashMap<String,Object> condMap=new HashMap<String,Object>();
	    condMap.put("beginDate",beginDate);
	    condMap.put("endDate", endDate);

	    String seller_id = "";
	    HttpSession session = request.getSession();
	    Object obj = session.getAttribute("businessInfo");
	    if (obj != null) {
	        BusinessVO businessVO = (BusinessVO) obj;
	        seller_id = businessVO.getSeller_id();
	    }
	    condMap.put("seller_id", seller_id);
	    
	    // ▼▼▼▼▼ 3. ⭐⭐⭐ 페이지 정보 계산 (핵심 추가 부분) ⭐⭐⭐ ▼▼▼▼▼
	    
	    // 3-1. 필터링된 전체 주문 개수 가져오기 (Service에 추가해야 할 메소드)
	    int totalOrderCount = businessService.getNewOrderCount(condMap); 

	    // 3-2. 페이지 계산에 필요한 변수 설정
	    int pageSize = 10; // 한 페이지에 보여줄 주문 수
	    int sectionSize = 10; // 한 섹션(블록)에 보여줄 페이지 수

	    // 3-3. 전체 페이지 수 계산
	    int totalPageCount = (int)Math.ceil((double)totalOrderCount / pageSize);

	    // 3-4. 현재 페이지 번호 (절대값) 계산
	    int currentPageNum = (section - 1) * sectionSize + pageNum;

	    // 3-5. 현재 섹션에 표시할 페이지 수 계산 (마지막 섹션 처리)
	    int totalPagesInSection = 0;
	    int lastSection = (int)Math.ceil((double)totalPageCount / sectionSize);
	    if (section < lastSection) {
	        totalPagesInSection = sectionSize;
	    } else {
	        totalPagesInSection = totalPageCount % sectionSize;
	        if (totalPagesInSection == 0) {
	            totalPagesInSection = sectionSize;
	        }
	    }
	    
	    // 3-6. JSP로 보낼 pageInfo 맵 생성
	    Map<String, Object> pageInfo = new HashMap<>();
	    pageInfo.put("totalPageCount", totalPageCount);       // 전체 페이지 수
	    pageInfo.put("section", section);                      // 현재 섹션 번호
	    pageInfo.put("currentPageNum", currentPageNum);        // 현재 페이지 번호
	    pageInfo.put("totalPagesInSection", totalPagesInSection); // 현재 섹션의 페이지 수
	    
	    mav.addObject("pageInfo", pageInfo); // JSP로 pageInfo 객체 전달

	    // ▼▼▼▼▼ 4. DB 조회를 위한 offset, limit 설정 (수정된 부분) ▼▼▼▼▼
	    int offset = (currentPageNum - 1) * pageSize; // (현재 페이지-1) * 페이지당 개수
	    int limit = pageSize;
	    
	    condMap.put("offset", offset);
	    condMap.put("limit", limit);

	    // ▼▼▼▼▼ 5. DB에서 주문 목록 조회 및 mav에 추가 (기존 코드) ▼▼▼▼▼
	    List<OrderVO> newOrderList=businessService.listNewOrder(condMap);
	    mav.addObject("newOrderList",newOrderList);
	    
	    String beginDate1[]=beginDate.split("-");
	    String endDate2[]=endDate.split("-");
	    mav.addObject("beginYear",beginDate1[0]);
	    mav.addObject("beginMonth",beginDate1[1]);
	    mav.addObject("beginDay",beginDate1[2]);
	    mav.addObject("endYear",endDate2[0]);
	    mav.addObject("endMonth",endDate2[1]);
	    mav.addObject("endDay",endDate2[2]);
	    
	    // section, pageNum은 이제 pageInfo 객체로 전달되므로 굳이 따로 보낼 필요는 없습니다.
	    // mav.addObject("section", section);
	    // mav.addObject("pageNum", pageNum);
	    
	    return mav;
	}
	
	// [추가] 관리자용 펜션 등록 페이지를 보여주는 메서드
	@RequestMapping(value="/admin/addPensionForm.do", method=RequestMethod.GET)
	public ModelAndView adminAddPensionForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    // 1. 드롭다운 메뉴에 표시할 모든 사업자 목록을 가져옵니다.
	    List<BusinessVO> businessList = businessService.getAllBusinesses();
	    
	    ModelAndView mav = new ModelAndView("/common/layout");
	    // 2. 사용자가 저장한 JSP 경로를 지정합니다.
	    mav.addObject("body", "/WEB-INF/views/admin/pension/adminAddPension.jsp");
	    mav.addObject("title", "관리자 펜션 등록");
	    // 3. JSP에서 사용할 수 있도록 사업자 목록을 전달합니다.
	    mav.addObject("businessList", businessList);
	    return mav;
	}

	
	// [추가] 1. 관리자용 전체 펜션 목록 페이지를 보여주는 메서드
	@RequestMapping(value="/admin/pensionList.do", method=RequestMethod.GET)
	public ModelAndView adminPensionList(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    List<PensionVO> allPensions = businessService.getAllPensionsWithBusinessInfo();
	    
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("body", "/WEB-INF/views/admin/pension/adminPensionList.jsp");
	    mav.addObject("title", "관리자 펜션 관리");
	    mav.addObject("allPensions", allPensions); // JSP로 데이터 전달
	    return mav;
	}

	// [추가] 2. 펜션의 승인 상태를 변경하는 메서드 (AJAX)
	@RequestMapping(value="/admin/pension/updatePensionStatus.do", method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updatePensionStatus(@RequestParam("p_num") int p_num, @RequestParam("status") String status) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        Map<String, Object> pensionMap = new HashMap<>();
	        pensionMap.put("p_num", p_num);
	        pensionMap.put("pension_status", status);
	        businessService.updatePensionStatus(pensionMap);
	        
	        response.put("success", true);
	    } catch (Exception e) {
	        response.put("success", false);
	        response.put("message", e.getMessage());
	        e.printStackTrace();
	    }
	    return new ResponseEntity<>(response, HttpStatus.OK);
	}

	// [추가] 3. 특정 펜션의 객실 목록을 가져오는 메서드 (AJAX)
	@RequestMapping(value="/admin/pension/getRoomList.do", method=RequestMethod.GET)
	public ModelAndView getRoomListForAdmin(@RequestParam("p_num") int p_num) throws Exception {

	    ModelAndView mav = new ModelAndView("/admin/pension/_roomListPartial");
	    
	    List<RoomVO> roomList = businessService.roomList(p_num);
	    mav.addObject("roomList", roomList);
	    
	    return mav;
	}
	
}


