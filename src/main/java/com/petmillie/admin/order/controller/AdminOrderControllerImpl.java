package com.petmillie.admin.order.controller;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.admin.order.service.AdminOrderService;
import com.petmillie.common.base.BaseController;
import com.petmillie.order.vo.OrderVO;

@Controller("adminOrderController")
@RequestMapping(value="/admin/order")
public class AdminOrderControllerImpl extends BaseController  implements AdminOrderController{
	@Autowired
	private AdminOrderService adminOrderService;
	@Override
	@RequestMapping(value="/adminOrderMain.do" ,method={RequestMethod.GET, RequestMethod.POST})
	public ModelAndView adminOrderMain(@RequestParam Map<String, String> dateMap,
	                                   HttpServletRequest request, HttpServletResponse response)  throws Exception {
	    String viewName=(String)request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");
	    
	    // viewName 변수에서 '/WEB-INF/views' 경로를 제거하고, JSP의 상대 경로만 남깁니다.
	    mav.addObject("body", "/WEB-INF/views"+viewName +".jsp");

	    String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
	    String section = dateMap.get("section");
	    String pageNum = dateMap.get("pageNum");
	    String beginDate=null,endDate=null;

	    String [] tempDate=calcSearchPeriod(fixedSearchPeriod).split(",");
	    beginDate=tempDate[0];
	    endDate=tempDate[1];
	    dateMap.put("beginDate", beginDate);
	    dateMap.put("endDate", endDate);

	    HashMap<String,Object> condMap=new HashMap<String,Object>();
	    if(section== null) {
	        section = "1";
	    }
	    if(pageNum== null) {
	        pageNum = "1";
	    }
	    int sectionInt = Integer.parseInt(section);
	    int pageNumInt = Integer.parseInt(pageNum);
	    int offset = (sectionInt - 1) * 100 + (pageNumInt - 1) * 10;
	    int limit = 10;
	    condMap.put("offset", offset);
	    condMap.put("limit", limit);

	    condMap.put("beginDate",beginDate);
	    condMap.put("endDate", endDate);

	    List<OrderVO> newOrderList=adminOrderService.listNewOrder(condMap);
	    mav.addObject("newOrderList",newOrderList);
	    
		
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
	
	@Override
	@RequestMapping(value="/modifyDeliveryState.do" ,method={RequestMethod.POST})
	public ResponseEntity modifyDeliveryState(@RequestParam Map<String, String> deliveryMap, 
	                                          HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
	    // 1. 기존 배송 상태 DB 업데이트 (원래 있던 코드)
	    adminOrderService.modifyDeliveryState(deliveryMap);
	    
	    // ▼▼▼▼▼ 여기에 원시그널 알림 코드를 추가합니다 ▼▼▼▼▼
	    try {
	        String order_id = deliveryMap.get("order_id");
	        String delivery_state = deliveryMap.get("delivery_state");
	        String notificationMessage = "";

	        // 2. (1단계에서 만든) 주문 ID로 회원 ID 조회
	        String member_id = adminOrderService.getMemberIdByOrderId(order_id);

	        // 3. 배송 상태에 따라 보낼 메시지 결정
	        if ("delivering".equals(delivery_state)) {
	            notificationMessage = "주문하신 상품의 배송이 시작되었습니다. 🚚";
	        } else if ("finished_delivering".equals(delivery_state)) {
	            notificationMessage = "주문하신 상품이 배송 완료되었습니다. 🎉";
	        }
	        // 필요하다면 다른 상태(주문취소, 반품완료 등)에 대한 알림도 추가 가능

	        // 4. 알림을 보낼 조건(회원ID 존재, 보낼 메시지 존재)이 맞으면 OneSignal API 호출
	        if (member_id != null && !member_id.isEmpty() && !notificationMessage.isEmpty()) {
	            String jsonBody = "{"
	                          + "\"app_id\": \"14ed38d9-71e5-4fc8-aec3-457b8a7ca88d\","  // 본인 APP ID로 변경
	                          + "\"headings\": {\"en\": \"📦 주문 상태 변경 알림\"},"
	                          + "\"contents\": {\"en\": \"" + notificationMessage + "\"},"
	                          + "\"include_external_user_ids\": [\"" + member_id + "\"]" // 핵심: 특정 회원에게만 발송
	                          + "}";

	            URL url = new URL("https://onesignal.com/api/v1/notifications");
	            HttpURLConnection http = (HttpURLConnection) url.openConnection();
	            http.setRequestMethod("POST");
	            http.setDoOutput(true);
	            http.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
	            http.setRequestProperty("Authorization", "Basic os_v2_app_ctwtrwlr4vh4rlwdiv5yu7firvg7r3gnj7du5ueju7vbgaxiuk4jbewdwvcpsgookttodpoj6enjurjzijhl6mdrn76hsflz5dia32y"); // 본인 REST API KEY로 변경

	            byte[] out = jsonBody.getBytes(StandardCharsets.UTF_8);
	            OutputStream stream = http.getOutputStream();
	            stream.write(out);

	            System.out.println("OneSignal Response: " + http.getResponseCode() + " " + http.getResponseMessage());
	            http.disconnect();
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); // 알림 발송에 실패하더라도 원래 기능은 계속되어야 하므로 에러만 기록
	    }
	    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲

	    // 5. 기존 응답 반환 (원래 있던 코드)
	    String message = "mod_success";
	    HttpHeaders responseHeaders = new HttpHeaders();
	    return new ResponseEntity(message, responseHeaders, HttpStatus.OK);
	}
	
	@Override
	@RequestMapping(value="/detailOrder.do" ,method={RequestMethod.GET,RequestMethod.POST})
	public ModelAndView orderDetail(@RequestParam("order_id") int order_id, 
	                                HttpServletRequest request, HttpServletResponse response)  throws Exception {
	    String viewName=(String)request.getAttribute("viewName");
	    ModelAndView mav = new ModelAndView("/common/layout");

	    // JSP 파일의 정확한 상대 경로를 직접 지정해 줍니다.
	    // detailOrder.jsp 파일이 있는 위치가 WEB-INF/views/admin/order 아래에 있다고 가정합니다.
	    mav.addObject("body", "/WEB-INF/views/"+viewName+".jsp");

	    Map orderMap =adminOrderService.orderDetail(order_id);
	    mav.addObject("orderMap", orderMap);
	    return mav;
	}
}