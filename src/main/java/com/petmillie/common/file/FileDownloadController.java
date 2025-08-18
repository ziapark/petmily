package com.petmillie.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import net.coobird.thumbnailator.Thumbnails;


@Controller
public class FileDownloadController {
	private static String CURR_BOARD_REPO_PATH = "C:\\petrepo\\board"; // 게시판 전용 경로
	private static String CURR_IMAGE_REPO_PATH = "C:\\petrepo\\goods"; // 상품 전용 경로
	private static String CURR_ROOM_REPO_PATH = "C:\\petrepo\\room";
	
	@RequestMapping("/download.do")
	protected void download(@RequestParam("fileName") String fileName,
		                 	@RequestParam("goods_num") String goods_num,
			                 HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String filePath=CURR_IMAGE_REPO_PATH+"\\"+goods_num+"\\"+fileName;
		File image=new File(filePath);

		response.setHeader("Cache-Control","no-cache");
		
        String contentType = "application/octet-stream"; // 기본값 설정
        String lowerFileName = fileName.toLowerCase(); // 확장자 비교를 위해 소문자로 변경
        
        if (lowerFileName.endsWith(".png")) {
            contentType = "image/png";
        } else if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
            contentType = "image/jpeg";
        } else if (lowerFileName.endsWith(".gif")) {
            contentType = "image/gif";
        }
        
        response.setContentType(contentType);
        
		FileInputStream in=new FileInputStream(image); 
		byte[] buffer=new byte[1024*8];
		while(true){
			int count=in.read(buffer);
			if(count==-1)
				break;
			out.write(buffer,0,count);
		}
		in.close();
		out.close();
	}
	
	//상품 상세 이미지 출력
	@RequestMapping("/goods/thumbnails.do")
	protected void thumbnails(@RequestParam("fileName") String fileName,
	                          @RequestParam("goods_num") int goods_num,
	                          HttpServletResponse response) throws Exception {
	    System.out.println("[🔍 디버그] 썸네일 요청 들어옴");
	    System.out.println("[🔍 디버그] fileName: " + fileName);
	    System.out.println("[🔍 디버그] goods_num: " + goods_num);

	    OutputStream out = response.getOutputStream();

	    String filePath = CURR_IMAGE_REPO_PATH + "\\" + goods_num + "\\" + fileName;
	    System.out.println("[🔍 디버그] 실제 이미지 경로: " + filePath);

	    File image = new File(filePath);

	    if (image.exists()) {
	        System.out.println("[✅ 디버그] 이미지 존재 확인됨");
	        response.setContentType("image/png");

	        try {
	            Thumbnails.of(image)
	                      .size(121, 154)
	                      .outputFormat("png")
	                      .toOutputStream(out);
	            System.out.println("[✅ 디버그] 썸네일 변환 및 출력 성공");
	        } catch (Exception e) {
	            System.out.println("[❌ 오류] 썸네일 처리 중 예외 발생: " + e.getMessage());
	            e.printStackTrace();
	            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        }
	    } else {
	        System.out.println("[❌ 디버그] 이미지 파일이 존재하지 않습니다.");
	        response.sendError(HttpServletResponse.SC_NOT_FOUND);
	    }

	    out.close();
	    System.out.println("[🔚 디버그] 썸네일 요청 처리 종료");
	}
	
	
	// 게시판 이미지 출력
	@RequestMapping("/board/image.do")
	public void displayBoardImage(@RequestParam("fileName") String fileName,
	                              @RequestParam("comu_id") String comuId,
	                              HttpServletResponse response) throws Exception {

		String filePath = CURR_BOARD_REPO_PATH + "\\" + fileName;
		File image = new File(filePath);
		System.out.println("이미지 경로: " + filePath);
		if (!image.exists()) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
		
		String contentType = "application/octet-stream";
		if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
			contentType = "image/jpeg";
		} else if (fileName.endsWith(".png")) {
			contentType = "image/png";
		}
		response.setContentType(contentType);
		
		try (FileInputStream in = new FileInputStream(image);
		     OutputStream out = response.getOutputStream()) {
			byte[] buffer = new byte[1024 * 8];
			int count;
			while ((count = in.read(buffer)) != -1) {
				out.write(buffer, 0, count);
			}
		}
	}
	
	@RequestMapping("/room/image.do")
	public void roomImage(@RequestParam("fileimage") String image, @RequestParam("room_id") String room_id, HttpServletResponse response) throws Exception{
		String filePath = CURR_ROOM_REPO_PATH + "\\" + image;
		 System.out.println("요청 이미지 파일 경로: " + filePath);
		File file = new File(filePath);
		if(!file.exists()) {
			  System.out.println("파일 없음!");
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
		String contentType="application/octet-stream";
	    if (image.endsWith(".jpg") || image.endsWith(".jpeg")) {
	        contentType = "image/jpeg";
	    } else if (image.endsWith(".png")) {
	        contentType = "image/png";
	    }
	    response.setContentType(contentType);
	    
	    try(FileInputStream in = new FileInputStream(file);
	    	OutputStream out = response.getOutputStream()) {
	    	byte[] buffer = new byte[1024 * 8];
	    	int count;
	    	while ((count = in.read(buffer)) != -1) {
	    		out.write(buffer, 0, count);
	    	}
	    }
	    System.out.println("이미지 스트리밍 완료!");
	}

}