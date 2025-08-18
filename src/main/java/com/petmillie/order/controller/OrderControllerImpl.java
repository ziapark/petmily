package com.petmillie.order.controller;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.petmillie.common.base.BaseController;
import com.petmillie.goods.service.GoodsService;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.portone.PortoneService;
import com.petmillie.order.service.OrderService;
import com.petmillie.order.vo.ApiResponse;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.order.vo.PayVO;

@Controller("orderController")
@RequestMapping(value="/order")
public class OrderControllerImpl extends BaseController implements OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderVO orderVO;
	@Autowired
	private PortoneService portoneService;
	
	@RequestMapping(value="/orderEachGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderEachGoods(@ModelAttribute("orderVO") OrderVO _orderVO,
			                       HttpServletRequest request, HttpServletResponse response)  throws Exception{
		
		request.setCharacterEncoding("utf-8");
		HttpSession session=request.getSession();
		session=request.getSession();
		
		Boolean isLogOn=(Boolean)session.getAttribute("isLogOn");
		String action=(String)session.getAttribute("action");
		//로그인 여부 체크
		//이전에 로그인 상태인 경우는 주문과정 진행
		//로그아웃 상태인 경우 로그인 화면으로 이동
		if(isLogOn==null || isLogOn==false){
			session.setAttribute("orderInfo", _orderVO);
			session.setAttribute("action", "/order/orderEachGoods.do");
			return new ModelAndView("redirect:/member/loginForm.do");
		}else{
			 if(action!=null && action.equals("/order/orderEachGoods.do")){
				orderVO=(OrderVO)session.getAttribute("orderInfo");
				session.removeAttribute("action");
			 }else {
				 orderVO=_orderVO;
			 }
		 }
		
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "제품구매");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		List myOrderList=new ArrayList<OrderVO>();
		myOrderList.add(orderVO);

		MemberVO memberInfo=(MemberVO)session.getAttribute("memberInfo");

		session.setAttribute("myOrderList", myOrderList);
		
		return mav;
	}
	
	
	@RequestMapping(value="/orderAllCartGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderAllCartGoods(@RequestParam("goods_num") int[] goods_num_arr, @RequestParam("cart_goods_qty") int[] cart_goods_qty_arr, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/order/orderEachGoods2.jsp");
		
		HttpSession session=request.getSession();
		List<OrderVO> myOrderList = new ArrayList<OrderVO>();
		
		for(int i=0; i<goods_num_arr.length; i++){
	        int goods_num = goods_num_arr[i];
	        int goods_qty = cart_goods_qty_arr[i];
	        
	        GoodsVO goodsVO = orderService.goodsDetailForOrder(goods_num);

	        OrderVO orderVO = new OrderVO(); 

	        orderVO.setGoods_num(goods_num);
	        orderVO.setGoods_name(goodsVO.getGoods_name());
	        orderVO.setGoods_sales_price(Integer.parseInt(goodsVO.getGoods_sales_price()));
	        orderVO.setGoods_qty(String.valueOf(goods_qty));
	        orderVO.setGoods_delivery_price(goodsVO.getGoods_delivery_price());
	        orderVO.setPoint(goodsVO.getGoods_point());
	        orderVO.setFileName(goodsVO.getFileName());
	        
	        myOrderList.add(orderVO);
	    }
		
	    session.setAttribute("myOrderList", myOrderList);
	    session.setAttribute("memberInfo", (MemberVO)session.getAttribute("memberInfo"));

	    return mav;
	}

	
	//포트원 결제 메서드
	@RequestMapping(value="/payToOrderGoods.do", method=RequestMethod.POST ) 
	@ResponseBody
	public ApiResponse payToOrderGoods(@RequestBody Map<String, Object> payData, HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
	    // 필수값 추출
	    String paymentKey = (String) payData.get("portone_paymentKey");
        Object goodsNumObj = payData.get("goods_num");
        Object orIdxObj = payData.get("or_idx");
        if (orIdxObj == null) {
            throw new IllegalArgumentException("or_idx가 null입니다!");
        }
        int orderId = ((Number) orIdxObj).intValue();
	    // paymentKey가 null이면 에러 처리
	    if (paymentKey == null || paymentKey.isBlank()) {
	        return new ApiResponse(false, "결제 실패: paymentKey 없음");
	    }
	    
	    // 주문/결제 DB 저장
	    OrderVO orderVO = new OrderVO();
	    orderVO.setMember_id(memberInfo.getMember_id());
	    orderVO.setOrder_id(orderId);
        orderVO.setGoods_name((String) payData.get("goods_name"));
        orderVO.setReceiver_name((String) payData.get("receiver_name"));
        orderVO.setGoods_sales_price((int)payData.get("goods_sales_price"));

        int goodsNum = Integer.parseInt(goodsNumObj.toString());
        orderVO.setGoods_num(goodsNum);
	    orderVO.setTel1((String) payData.get("tel1"));
	    orderVO.setTel2((String) payData.get("tel2"));
	    orderVO.setTel3((String) payData.get("tel3"));
	    orderVO.setZipcode((String) payData.get("zipcode"));
	    orderVO.setRoadAddress((String) payData.get("roadAddress"));
	    orderVO.setJibunAddress((String) payData.get("jibunAddress"));
	    orderVO.setNamujiAddress((String) payData.get("namujiAddress"));
	    orderVO.setDelivery_message((String) payData.get("delivery_message"));

        // 결제 금액 파싱
        String priceStr = String.valueOf(payData.get("price"));
        int final_price;
        try {
            final_price = Integer.parseInt(priceStr);
        } catch (NumberFormatException e) {
            return new ApiResponse(false, "금액 데이터가 올바르지 않습니다.");
        }

        // 현재 시간        
        List<OrderVO> myOrderList = List.of(orderVO);
        orderService.addNewOrder(myOrderList);
        int generatedOrderNum = orderVO.getOrder_num();
        PayVO payVO = new PayVO();
        payVO.setOrder_num(generatedOrderNum);
        payVO.setPayment_id((int) payData.get("paymentId"));
        payVO.setPay_method((String) payData.get("pay_method"));
        payVO.setCard_com_name((String) payData.get("card_com_name"));
        payVO.setCard_pay_month((String) payData.get("card_pay_month"));
        payVO.setPayment_status((String) payData.get("paymentStatus"));
        payVO.setPg_tid((String) payData.get("portone_paymentKey"));
        payVO.setPg_tid(paymentKey);
        payVO.setPay_order_tel((String) payData.get("pay_order_tel"));

        // 결제 시간은 현재 시간으로 넣는 것도 방법
        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        payVO.setPayment_amount(priceStr);
        payVO.setPayment_time(now);

        // 결제 insert    
        orderService.addNewpay(payVO);    
        orderService.removeCartItem(memberInfo.getMember_id(), orderVO.getGoods_num());
        
        session.setAttribute("PayVO", payVO);
        session.setAttribute("OrderList", myOrderList);

        return new ApiResponse(true, "주문 및 결제 완료되었습니다!");
    }
	
	@ExceptionHandler(RuntimeException.class)
	@ResponseBody
	public Map<String, Object> handleRuntimeException(RuntimeException ex) {
	    Map<String, Object> map = new HashMap<>();
	    map.put("success", false);
	    try {
	        // 혹시 던진 메시지가 JSON이면 파싱해서 반환
	        ObjectMapper mapper = new ObjectMapper();
	        JsonNode json = mapper.readTree(ex.getMessage());
	        map.put("message", json.has("message") ? json.get("message").asText() : ex.getMessage());
	    } catch (Exception e) {
	        map.put("message", ex.getMessage());
	    }
	    return map;
	}

}