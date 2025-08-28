package com.petmillie.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnails;

@Controller
public class FileDownloadController {
	private static String CURR_BOARD_REPO_PATH = "C:\\petrepo\\board"; // 게시판 전용 경로
	private static String CURR_IMAGE_REPO_PATH = "C:\\petrepo\\goods"; // 상품 전용 경로
	private static String CURR_ROOM_REPO_PATH = "C:\\petrepo\\room";
	private static String CURR_REVIEW_REPO_PATH = "C:\\petrepo\\goodsreivew";
	private static String CURR_PENSION_REPO_PATH = "C:\\petrepo\\pension"; // 펜션사진 전용 경로
	private static String CURR_MYPET_REPO_PATH = "C:\\petrepo\\mypet"; // 나의 반려동물 전용 경로

	@RequestMapping("/download.do")
	protected void download(@RequestParam("fileName") String fileName, @RequestParam("goods_num") String goods_num,
			HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String filePath = CURR_IMAGE_REPO_PATH + "\\" + goods_num + "\\" + fileName;
		File image = new File(filePath);

		response.setHeader("Cache-Control", "no-cache");

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

		FileInputStream in = new FileInputStream(image);
		byte[] buffer = new byte[1024 * 8];
		while (true) {
			int count = in.read(buffer);
			if (count == -1)
				break;
			out.write(buffer, 0, count);
		}
		in.close();
		out.close();
	}

	// 상품 상세 이미지 출력
	@RequestMapping("/goods/thumbnails.do")
	protected void thumbnails(@RequestParam("fileName") String fileName, @RequestParam("goods_num") int goods_num,
			HttpServletResponse response) throws Exception {

		OutputStream out = response.getOutputStream();

		String filePath = CURR_IMAGE_REPO_PATH + "\\" + goods_num + "\\" + fileName;

		File image = new File(filePath);

		if (image.exists()) {
			response.setContentType("image/png");

			try {
				Thumbnails.of(image).size(121, 154).outputFormat("png").toOutputStream(out);
			} catch (Exception e) {
				e.printStackTrace();
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}

<<<<<<< HEAD
		out.close();
		System.out.println("[🔚 디버그] 썸네일 요청 처리 종료");
=======
	    out.close();
	 
>>>>>>> 72bb0ebeb4add253749066e3672c88fde24f5c7f
	}

	// 게시판 이미지 출력
	@RequestMapping("/board/image.do")
	public void displayBoardImage(@RequestParam("fileName") String fileName, @RequestParam("comu_id") String comuId,
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

		try (FileInputStream in = new FileInputStream(image); OutputStream out = response.getOutputStream()) {
			byte[] buffer = new byte[1024 * 8];
			int count;
			while ((count = in.read(buffer)) != -1) {
				out.write(buffer, 0, count);
			}
		}
	}

	// 리뷰 이미지 출력
	@RequestMapping("/review/image.do")
	public void reviewImage(@RequestParam("file_name") String fileName, @RequestParam("review_id") String review_id,
			HttpServletResponse response) throws Exception {

		String filePath = CURR_REVIEW_REPO_PATH + "\\" + fileName;
		File image = new File(filePath);
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

		try (FileInputStream in = new FileInputStream(image); OutputStream out = response.getOutputStream()) {
			byte[] buffer = new byte[1024 * 8];
			int count;
			while ((count = in.read(buffer)) != -1) {
				out.write(buffer, 0, count);
			}
		}
	}

	// ▼▼▼▼▼ [수정] 이 메소드의 파라미터를 수정했습니다. ▼▼▼▼▼
	@RequestMapping("/pension/image.do")
	public void pensionImage(@RequestParam("fileName") String fileName, HttpServletResponse response) throws Exception {
		String filePath = CURR_PENSION_REPO_PATH + "\\" + fileName;
		System.out.println("요청된 펜션 이미지 파일 경로: " + filePath);
		File file = new File(filePath);
		if (!file.exists()) {
			System.out.println("파일을 찾을 수 없습니다: " + filePath);
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

		try (FileInputStream in = new FileInputStream(file); OutputStream out = response.getOutputStream()) {
			byte[] buffer = new byte[1024 * 8];
			int count;
			while ((count = in.read(buffer)) != -1) {
				out.write(buffer, 0, count);
			}
		}
	}

	public String uploadPensionImage(MultipartFile mainImage) throws Exception {
		String originalFileName = null;
		if (mainImage != null && !mainImage.isEmpty()) {
			originalFileName = mainImage.getOriginalFilename();
			File repository = new File(CURR_PENSION_REPO_PATH);
			if (!repository.exists()) {
				repository.mkdirs();
			}
			File dest = new File(repository, originalFileName);
			mainImage.transferTo(dest);
			originalFileName = dest.getName();
		}
		return originalFileName;
	}

	// --- 반려동물 관련 메소드 ---
		@RequestMapping("/mypet/image.do")
		public void mypetImage(@RequestParam("fileName") String fileName, HttpServletResponse response) throws Exception {
			String filePath = CURR_MYPET_REPO_PATH + "\\" + fileName;
			System.out.println("요청된 반려동물 이미지 파일 경로: " + filePath);
			File file = new File(filePath);
			if (!file.exists()) {
				System.out.println("파일을 찾을 수 없습니다: " + filePath);
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

			// ▼▼▼ [수정] while문 안의 잘못된 중괄호를 제거했습니다 ▼▼▼
			try (FileInputStream in = new FileInputStream(file);
				 OutputStream out = response.getOutputStream()) {
				byte[] buffer = new byte[1024 * 8];
				int count;
				while ((count = in.read(buffer)) != -1) {
					out.write(buffer, 0, count);
				}
			}
		}

		public String uploadPetImage(MultipartFile petImage) throws Exception {
			String originalFileName = null;
			if (petImage != null && !petImage.isEmpty()) {
				originalFileName = petImage.getOriginalFilename();
				File repository = new File(CURR_MYPET_REPO_PATH);
				if (!repository.exists()) {
					repository.mkdirs();
				}
				File dest = new File(repository, originalFileName);
				petImage.transferTo(dest);
				originalFileName = dest.getName();
			}
			return originalFileName;
		}
	}


