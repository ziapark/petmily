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
	@Autowired
	private GoodsVO goodsVO;
	
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

	@RequestMapping(value="/modifyGoods.do" ,method={RequestMethod.POST})
	public ResponseEntity modifyGoods(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception {

	    // 1. 기본 설정
	    multipartRequest.setCharacterEncoding("utf-8");
	    response.setContentType("text/html; charset=utf-8");
	    
	    Map<String, Object> goodsMap = new HashMap<>();
	    
	    // 2. 폼의 텍스트 파라미터들을 Map에 담기
	    Enumeration<String> enu = multipartRequest.getParameterNames();
	    while (enu.hasMoreElements()) {
	        String name = enu.nextElement();
	        // 이미지 파일 자체(<input type="file">)는 파라미터로 담지 않음
	        if (!name.startsWith("main_image") && !name.startsWith("detail_image")) {
	            String value = multipartRequest.getParameter(name);
	            goodsMap.put(name, value);
	        }
	    }
	    
	    // 3. 숫자여야 하는 값들을 String에서 숫자 타입으로 직접 변환
	    if (goodsMap.get("goods_num") != null) {
	        goodsMap.put("goods_num", Integer.parseInt((String)goodsMap.get("goods_num")));
	    }
	    if (goodsMap.get("goods_sales_price") != null && !((String)goodsMap.get("goods_sales_price")).isEmpty()) {
	        goodsMap.put("goods_sales_price", Integer.parseInt((String)goodsMap.get("goods_sales_price")));
	    }
	    if (goodsMap.get("goods_point") != null && !((String)goodsMap.get("goods_point")).isEmpty()) {
	        goodsMap.put("goods_point", Integer.parseInt((String)goodsMap.get("goods_point")));
	    }
	    if (goodsMap.get("goods_stock") != null && !((String)goodsMap.get("goods_stock")).isEmpty()) {
	        goodsMap.put("goods_stock", Integer.parseInt((String)goodsMap.get("goods_stock")));
	    }
	    
	    // 4. (중요) 이미지 파일 업로드 로직을 여기에 직접 구현
	    List<ImageFileVO> imageFileList = new ArrayList<>();
	    File tempDir = new File(CURR_IMAGE_REPO_PATH + File.separator + "temp");
	    if (!tempDir.exists()) {
	        tempDir.mkdirs(); // 임시 폴더 생성
	    }
	    
	    Iterator<String> fileNames = multipartRequest.getFileNames();
	    while(fileNames.hasNext()) {
	        String formFieldName = fileNames.next();
	        MultipartFile mFile = multipartRequest.getFile(formFieldName);
	        
	        if (mFile != null && !mFile.isEmpty()) {
	            ImageFileVO imageFileVO = new ImageFileVO();
	            imageFileVO.setFileType(formFieldName);
	            
	            String originalFileName = new File(mFile.getOriginalFilename()).getName(); // 순수 파일명 추출
	            String extension = FilenameUtils.getExtension(originalFileName);
	            String newFileName = UUID.randomUUID().toString() + "." + extension; // 중복 방지 파일명 생성
	            imageFileVO.setFileName(newFileName);
	            
	            File fileToSave = new File(tempDir, newFileName); // 임시 폴더에 저장할 파일 객체 생성
	            mFile.transferTo(fileToSave); // 파일 저장
	            
	            imageFileList.add(imageFileVO);
	        }
	    }
	    
	    if (!imageFileList.isEmpty()) {
	        goodsMap.put("imageFileList", imageFileList);
	        for (ImageFileVO imageFileVO : imageFileList) {
	            if ("main_image".equals(imageFileVO.getFileType())) {
	                goodsMap.put("goods_fileName", imageFileVO.getFileName());
	                break;
	            }
	        }
	    }
	    
	    // 5. DB 업데이트 및 결과 처리
	    String goods_num = String.valueOf(goodsMap.get("goods_num"));
	    String message;
	    ResponseEntity resEntity = null;
	    HttpHeaders responseHeaders = new HttpHeaders();
	    responseHeaders.add("Content-Type", "text/html; charset=utf-8");
	    
	    try {
	        adminGoodsService.modifyGoods(goodsMap); // 서비스 호출

	        // 6. DB 성공 시 임시 파일을 최종 폴더로 이동
	        if (!imageFileList.isEmpty()) {
	            for (ImageFileVO imageFileVO : imageFileList) {
	                String imageFileName = imageFileVO.getFileName();
	                File srcFile = new File(tempDir, imageFileName);
	                File destDir = new File(CURR_IMAGE_REPO_PATH + File.separator + goods_num);
	                if (!destDir.exists()) {
	                    destDir.mkdirs(); // 최종 폴더 생성
	                }
	                FileUtils.moveFileToDirectory(srcFile, destDir, true);
	            }
	        }
	        
	        message = "<script> alert('상품 정보를 성공적으로 수정했습니다.'); location.href='" + multipartRequest.getContextPath() + "/admin/goods/modifyGoodsForm.do?goods_num=" + goods_num + "'; </script>";

	    } catch (Exception e) {
	        // ... (에러 처리: temp 파일 삭제 등)
	        e.printStackTrace();
	        message = "<script> alert('수정 중 오류가 발생했습니다.'); location.href='" + multipartRequest.getContextPath() + "/admin/goods/modifyGoodsForm.do?goods_num=" + goods_num + "'; </script>";
	    }
	    
	    resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
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

	// --- 상품 삭제 메서드 ---
	@RequestMapping(value="/removeGoods.do", method={RequestMethod.POST})
	public ResponseEntity removeGoods(@RequestParam("goods_num") int goods_num,
	                                HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String message;
	    ResponseEntity resEntity = null;
	    HttpHeaders responseHeaders = new HttpHeaders();
	    responseHeaders.add("Content-Type", "text/html; charset=utf-8");

	    try {
	        adminGoodsService.removeGoods(goods_num);

	        // ✅ 1. 세션에서 로그인 정보 확인
	        HttpSession session = request.getSession();
	        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
	        String redirectUrl;

	        // ✅ 2. 로그인한 사용자가 admin인지 확인
	        if (memberInfo != null && "admin".equals(memberInfo.getMember_id())) {
	            // admin이면 관리자 목록으로
	            redirectUrl = request.getContextPath() + "/admin/goods/adminGoodsMain.do";
	        } else {
	            // admin이 아니면(사업자면) 사업자 목록으로
	            redirectUrl = request.getContextPath() + "/business/businessGoodsMain.do";
	        }

	        // ✅ 3. 역할에 맞는 URL로 이동하는 스크립트 생성
	        message = "<script>";
	        message += " alert('상품을 성공적으로 삭제했습니다.');";
	        message += " location.href='" + redirectUrl + "';";
	        message += "</script>";

	    } catch (Exception e) {
	        e.printStackTrace();
	        message = "<script>";
	        message += " alert('삭제 중 오류가 발생했습니다.');";
	        message += " history.back();";
	        message += "</script>";
	    }

	    resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	    return resEntity;
	}
    
	// --- 상품 복원 메서드 ---
	@RequestMapping(value="/restoreGoods.do", method={RequestMethod.POST})
	public ResponseEntity restoreGoods(@RequestParam("goods_num") int goods_num,
	                                HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String message;
	    ResponseEntity resEntity = null;
	    HttpHeaders responseHeaders = new HttpHeaders();
	    responseHeaders.add("Content-Type", "text/html; charset=utf-8");

	    try {
	        adminGoodsService.restoreGoods(goods_num);

	        message = "<script>";
	        message += " alert('상품을 성공적으로 복원했습니다.');";
	        message += " location.href='" + request.getContextPath() + "/admin/goods/modifyGoodsForm.do?goods_num=" + goods_num + "';";
	        message += "</script>";

	    } catch (Exception e) {
	        e.printStackTrace();
	        message = "<script>";
	        message += " alert('복원 중 오류가 발생했습니다.');";
	        message += " history.back();";
	        message += "</script>";
	    }

	    resEntity = new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	    return resEntity;
	}

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
	
	@RequestMapping(value="/updateGoodsStatus.do" ,method=RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> updateGoodsStatus(@RequestParam("goods_num") int goods_num, @RequestParam("goods_status") String goods_status, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "마이페이지");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");

		goodsVO.setGoods_num(goods_num);
		goodsVO.setGoods_status(goods_status);
		
		try {
			if(goods_status.equals("삭제")) {
				adminGoodsService.removeGoods(goods_num);
			}else {
				adminGoodsService.updateGoodsStatus(goodsVO);
			}
			return ResponseEntity.ok("success");
		}catch(Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error");
		}
	}
	

}