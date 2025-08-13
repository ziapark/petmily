package com.petmillie.admin.goods.controller;

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
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.admin.goods.service.AdminGoodsService;
import com.petmillie.common.base.BaseController;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.goods.vo.ImageFileVO;
import com.petmillie.member.vo.MemberVO;

@Controller("adminGoodsController")
@RequestMapping(value="/admin/goods")
public class AdminGoodsControllerImpl extends BaseController implements AdminGoodsController{
	private static final String CURR_IMAGE_REPO_PATH = "C:\\petupload\\goods";
	@Autowired
	private AdminGoodsService adminGoodsService;

	@RequestMapping(value="/adminGoodsMain.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView adminGoodsMain(@RequestParam Map<String, String> dateMap,
			 HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session=request.getSession();
		session=request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

		session.setAttribute("side_menu", "admin_mode");

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

		List<GoodsVO> newGoodsList=adminGoodsService.listNewGoods(condMap);
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


	@RequestMapping(value="/addNewGoods.do", method={RequestMethod.POST})
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
	    MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
	    String reg_id = memberVO.getMember_id();

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
	        int goods_num = adminGoodsService.addNewGoods(newGoodsMap);

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
	        message += " location.href='" + multipartRequest.getContextPath() + "/admin/goods/adminGoodsMain.do';";
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
	        message += " location.href='" + multipartRequest.getContextPath() + "/admin/goods/addNewGoodsForm.do';";
	        message += "</script>";

	        e.printStackTrace();
	    }

	    resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	    return resEntity;
	}


		
	

	@RequestMapping(value="/modifyGoodsForm.do" ,method={RequestMethod.GET,RequestMethod.POST})
	public ModelAndView modifyGoodsForm(@RequestParam("goods_num") int goods_num,
			 HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/" + viewName + ".jsp");

		Map goodsMap=adminGoodsService.goodsDetail(goods_num);
		mav.addObject("goodsMap",goodsMap);

		return mav;
	}

	@RequestMapping(value="/modifyGoodsInfo.do" ,method={RequestMethod.POST})
	public ResponseEntity modifyGoodsInfo( @RequestParam("goods_num") String goods_num,
			 @RequestParam("attribute") String attribute,
			 @RequestParam("value") String value,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		Map<String,String> goodsMap=new HashMap<String,String>();
		goodsMap.put("goods_num", goods_num);
		goodsMap.put(attribute, value);
		adminGoodsService.modifyGoodsInfo(goodsMap);

		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message = "mod_success";
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
	}


	@RequestMapping(value="/modifyGoodsImageInfo.do", method=RequestMethod.POST)
	public void modifyGoodsImageInfo(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception {
	    HttpSession session = multipartRequest.getSession(false);
	    if (session == null) {
	        response.getWriter().write("error: 세션이 없습니다. 로그인 후 이용하세요.");
	        return;
	    }
	    MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
	    if (memberVO == null) {
	        response.getWriter().write("error: 로그인 정보가 없습니다. 로그인 후 이용하세요.");
	        return;
	    }
	    String reg_id = memberVO.getMember_id();

	    multipartRequest.setCharacterEncoding("utf-8");
	    response.setContentType("text/html; charset=utf-8");

	    String imageFileName = null;
	    Map<String, String> goodsMap = new HashMap<>();
	    Enumeration<String> enu = multipartRequest.getParameterNames();
	    while (enu.hasMoreElements()) {
	        String name = enu.nextElement();
	        String value = multipartRequest.getParameter(name);
	        goodsMap.put(name, value);
	    }

	    int goods_num = Integer.parseInt(goodsMap.get("goods_num"));
	    int image_id = Integer.parseInt(goodsMap.get("image_id"));

	    List<ImageFileVO> imageFileList = null;
	    try {
	        imageFileList = upload(multipartRequest);
	        if (imageFileList != null && !imageFileList.isEmpty()) {
	            for (ImageFileVO imageFileVO : imageFileList) {
	                imageFileVO.setGoods_num(goods_num);
	                imageFileVO.setImage_id(image_id);
	                imageFileVO.setReg_id(reg_id);

	                imageFileName = imageFileVO.getFileName();
	                File srcFile = new File(CURR_IMAGE_REPO_PATH + "\\temp\\" + imageFileName);
	                File destDir = new File(CURR_IMAGE_REPO_PATH + "\\" + goods_num);

	                if (!destDir.exists()) {
	                    destDir.mkdirs();
	                }

	                File destFile = new File(destDir, imageFileName);
	                String baseName = FilenameUtils.getBaseName(imageFileName);
	                String extension = FilenameUtils.getExtension(imageFileName);
	                int count = 1;
	                while (destFile.exists()) {
	                    String newFileName = baseName + "_" + count + "." + extension;
	                    destFile = new File(destDir, newFileName);
	                    count++;
	                }

	                FileUtils.moveFile(srcFile, destFile);
	                imageFileVO.setFileName(destFile.getName());
	            }

	            adminGoodsService.modifyGoodsImage(imageFileList);
	            response.getWriter().write("mod_success");
	        } else {
	            response.getWriter().write("error: 업로드된 파일이 없습니다.");
	        }
	    } catch (Exception e) {
	        if (imageFileList != null) {
	            for (ImageFileVO imageFileVO : imageFileList) {
	                imageFileName = imageFileVO.getFileName();
	                File srcFile = new File(CURR_IMAGE_REPO_PATH + "\\temp\\" + imageFileName);
	                if (srcFile.exists()) {
	                    srcFile.delete();
	                }
	            }
	        }
	        e.printStackTrace();
	        response.getWriter().write("error: 파일 처리 중 예외 발생");
	    }
	}

	@Override
	@RequestMapping(value="/addNewGoodsImage.do" ,method={RequestMethod.POST})
	public void addNewGoodsImage(MultipartHttpServletRequest multipartRequest, HttpServletResponse response)
			throws Exception {
		System.out.println("addNewGoodsImage");
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		String imageFileName=null;

		Map goodsMap = new HashMap();
		Enumeration enu=multipartRequest.getParameterNames();
		while(enu.hasMoreElements()){
			String name=(String)enu.nextElement();
			String value=multipartRequest.getParameter(name);
			goodsMap.put(name,value);
		}

		HttpSession session = multipartRequest.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
		String reg_id = memberVO.getMember_id();

		List<ImageFileVO> imageFileList=null;
		int goods_num=0;
		try {
			imageFileList =upload(multipartRequest);
			if(imageFileList!= null && imageFileList.size()!=0) {
				for(ImageFileVO imageFileVO : imageFileList) {
					goods_num = Integer.parseInt((String)goodsMap.get("goods_num"));
					imageFileVO.setGoods_num(goods_num);
					imageFileVO.setReg_id(reg_id);
				}

            adminGoodsService.addNewGoodsImage(imageFileList);
				for(ImageFileVO imageFileVO:imageFileList) {
					imageFileName = imageFileVO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"//"+"temp"+"//"+imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH+"//"+goods_num);
					FileUtils.moveFileToDirectory(srcFile, destDir,true);
				}
			}
		}catch(Exception e) {
			if(imageFileList!=null && imageFileList.size()!=0) {
				for(ImageFileVO imageFileVO:imageFileList) {
					imageFileName = imageFileVO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\"+"temp"+"\\"+imageFileName);
					srcFile.delete();
				}
			}
			e.printStackTrace();
		}
	}

	@Override
	@RequestMapping(value="/removeGoodsImage.do" ,method={RequestMethod.POST})
	public void removeGoodsImage(@RequestParam("goods_num") int goods_num,
			 @RequestParam("image_id") int image_id,
			 @RequestParam("imageFileName") String imageFileName,
			 HttpServletRequest request, HttpServletResponse response) throws Exception {

		adminGoodsService.removeGoodsImage(image_id);
		try{
			File srcFile = new File(CURR_IMAGE_REPO_PATH+"\\"+goods_num+"\\"+imageFileName);
			srcFile.delete();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

    // --- 상품 삭제 메서드  ---
    @RequestMapping(value="/removeGoods.do", method={RequestMethod.POST})
    @ResponseBody // JSP의 AJAX 요청에 응답할 때 필수!
    public ResponseEntity removeGoods(@RequestParam("goods_num") int goods_num,
                                    HttpServletRequest request, HttpServletResponse response) throws Exception {
        String message = null;
        ResponseEntity resEntity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.add("Content-Type", "text/html; charset=utf-8"); // 응답 헤더 설정

        try {
            // !!! 이 라인을 추가하세요 !!!
            adminGoodsService.removeGoods(goods_num); // <---- 이 부분이 누락되었습니다!

            message = "remove_success"; // JSP로 보낼 성공 메시지
        } catch (Exception e) {
            System.err.println("상품 삭제 중 컨트롤러에서 오류 발생: " + e.getMessage()); // 에러 로그 강화
            e.printStackTrace(); // 서버 콘솔에 에러 스택 트레이스 출력
            message = "failed"; // JSP로 보낼 실패 메시지
        }

        resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
        return resEntity;
    }
    // --- 상품 삭제 메서드 끝 ---
    
    
    
    // --- 상품 복원 메서드 (del_yn='N'으로 업데이트) ---
    @RequestMapping(value="/restoreGoods.do", method={RequestMethod.POST})
    @ResponseBody
    public ResponseEntity restoreGoods(@RequestParam("goods_num") int goods_num,
                                    HttpServletRequest request, HttpServletResponse response) throws Exception {
        String message = null;
        ResponseEntity resEntity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        responseHeaders.add("Content-Type", "text/html; charset=utf-8");

        try {
            adminGoodsService.restoreGoods(goods_num); // 서비스 계층을 호출하여 상품의 del_yn을 'N'으로 업데이트합니다.

            message = "restore_success"; // 성공 메시지
        } catch (Exception e) {
            System.err.println("상품 복원 중 컨트롤러에서 오류 발생: " + e.getMessage());
            e.printStackTrace();
            message = "failed"; // 실패 메시지
        }

        resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
        return resEntity;
    }
    // --- 상품 복원 메서드 끝 ---

	@RequestMapping(value="/addNewGoodsForm.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView addNewGoodsForm(@RequestParam Map<String, String> dateMap,
			 HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session=request.getSession();
		session=request.getSession();
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");


		return mav;

	}

}