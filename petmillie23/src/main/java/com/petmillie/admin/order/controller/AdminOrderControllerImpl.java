package com.petmillie.admin.order.controller;

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
			                        HttpServletRequest request, HttpServletResponse response)  throws Exception {
		adminOrderService.modifyDeliveryState(deliveryMap);
		
		String message = null;
		ResponseEntity resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		message  = "mod_success";
		resEntity =new ResponseEntity(message, responseHeaders, HttpStatus.OK);
		return resEntity;
		
	}
	
	
	// AdminOrderControllerImpl.java
	// ...
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