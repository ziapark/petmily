package com.petmillie.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.nio.file.Files;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import net.coobird.thumbnailator.Thumbnails;


@Controller
public class FileDownloadController {
	private static String CURR_BOARD_REPO_PATH = "C:\\petupload"; // 게시판 전용 경로
	private static String CURR_IMAGE_REPO_PATH = "C:\\petupload\\goods";
	
	@RequestMapping("/download.do")
	protected void download(@RequestParam("fileName") String fileName,
		                 	@RequestParam("goods_id") String goods_id,
			                 HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String filePath=CURR_IMAGE_REPO_PATH+"\\"+goods_id+"\\"+fileName;
		File image=new File(filePath);

		response.setHeader("Cache-Control","no-cache");
		response.addHeader("Content-disposition", "attachment; fileName="+fileName);
		FileInputStream in=new FileInputStream(image); 
		byte[] buffer=new byte[1024*8];
		while(true){
			int count=in.read(buffer); //���ۿ� �о���� ���ڰ���
			if(count==-1)  //������ �������� �����ߴ��� üũ
				break;
			out.write(buffer,0,count);
		}
		in.close();
		out.close();
	}
	
	
	@RequestMapping("/goods/thumbnails.do")
	protected void thumbnails(@RequestParam("fileName") String fileName,
                            	@RequestParam("goods_num") int goods_num,
			                 HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String filePath=CURR_IMAGE_REPO_PATH+"\\"+goods_num+"\\"+fileName;
		File image=new File(filePath);
		
		if (image.exists()) { 
			Thumbnails.of(image).size(121,154).outputFormat("png").toOutputStream(out);
		}
		byte[] buffer = new byte[1024 * 8];
		out.write(buffer);
		out.close();
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
	

}
