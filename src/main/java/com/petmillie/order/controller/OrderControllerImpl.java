package com.petmillie.order.controller;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.member.service.MemberService;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.order.portone.PortoneService;
import com.petmillie.order.service.OrderService;
import com.petmillie.order.vo.ApiResponse;
import com.petmillie.order.vo.OrderItemDto;
import com.petmillie.order.vo.OrderVO;
import com.petmillie.order.vo.PayVO;
import com.petmillie.order.vo.PaymentRequestDto;

@Controller("orderController")
@RequestMapping(value="/order")
public class OrderControllerImpl extends BaseController implements OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderVO orderVO;
	@Autowired
	private PortoneService portoneService;
	@Autowired
	private MemberService memberService;
	
	@RequestMapping(value="/orderEachGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderEachGoods(@ModelAttribute("orderVO") OrderVO _orderVO,
			                       HttpServletRequest request, HttpServletResponse response)  throws Exception{
		
		request.setCharacterEncoding("utf-8");
		HttpSession session=request.getSession();
		session=request.getSession();
		
		Boolean isLogOn=(Boolean)session.getAttribute("isLogOn");
		String action=(String)session.getAttribute("action");
		//로그인 여부 체크
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
		mav.addObject("body", "/WEB-INF/views/order/orderEachGoods2.jsp");
		
		List myOrderList=new ArrayList<OrderVO>();
		myOrderList.add(orderVO);

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
	
	@Transactional
	@RequestMapping(value="/payToOrderGoods.do", method=RequestMethod.POST ) 
	@ResponseBody
	public ApiResponse payToOrderGoods(@RequestBody PaymentRequestDto payDto, HttpServletRequest request) throws Exception {	    
	    HttpSession session = request.getSession();
	    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
	    
	    if (memberInfo == null) {
	        System.err.println("치명적 오류: 결제는 성공했으나 세션이 만료되어 주문 정보를 저장할 수 없습니다.");
	        System.err.println("paymentId: " + payDto.getPaymentId() + ", imp_uid: " + payDto.getImp_uid());
	        return new ApiResponse(false, "세션이 만료되었습니다. 다시 로그인 후 고객센터로 문의해주세요.");
	    }
	    
	    int usedPoints = payDto.getUsed_point();
	    int goodsTotalPrice = 0;
	    List<GoodsVO> orderedGoodsList = new ArrayList<>();
	    
	    for (OrderItemDto item : payDto.getOrderItems()) {
	        GoodsVO goodsVO = orderService.goodsDetailForOrder(item.getGoods_num());
	        orderedGoodsList.add(goodsVO);
	        goodsTotalPrice += Integer.parseInt(goodsVO.getGoods_sales_price()) * item.getGoods_qty();
	    }

	    if ((goodsTotalPrice - usedPoints) != payDto.getPrice()) {
	    	portoneService.cancelPayment(payDto.getPaymentId(), payDto.getPrice());
	        return new ApiResponse(false, "결제 금액이 유효하지 않습니다. 주문이 취소되었습니다.");
	    }
	    
	    int orderId = (int) (System.currentTimeMillis() % Integer.MAX_VALUE);

	    for (int i = 0; i < payDto.getOrderItems().size(); i++) {
	        OrderItemDto item = payDto.getOrderItems().get(i); // 사용자가 보낸 주문 정보
	        GoodsVO goodsVO = orderedGoodsList.get(i);         // 서버가 DB에서 조회한 상품 정보

	        OrderVO orderVO = new OrderVO();

	        orderVO.setOrder_id(orderId); 
	        orderVO.setMember_id(memberInfo.getMember_id());
	        orderVO.setReceiver_name(payDto.getReceiver_name());
	        orderVO.setTel1(payDto.getTel1());
	        orderVO.setTel2(payDto.getTel2());
	        orderVO.setTel3(payDto.getTel3());
	        orderVO.setZipcode(payDto.getZipcode());
	        orderVO.setRoadAddress(payDto.getRoadAddress());
	        orderVO.setJibunAddress(payDto.getJibunAddress());
	        orderVO.setNamujiAddress(payDto.getNamujiAddress());
	        orderVO.setDelivery_message(payDto.getDelivery_message());

	        orderVO.setReward_point(item.getReward_point());
	        orderVO.setGoods_num(item.getGoods_num());
	        orderVO.setGoods_qty(String.valueOf(item.getGoods_qty()));
	        orderVO.setGoods_name(goodsVO.getGoods_name());
	        orderVO.setGoods_sales_price(Integer.parseInt(goodsVO.getGoods_sales_price()));
	        orderVO.setFileName(goodsVO.getFileName());
	        
	        orderService.addNewOrder(orderVO); 
	    }

	    PayVO payVO = new PayVO();
	    
	    payVO.setOrder_id(orderId);
	    payVO.setImp_uid(payDto.getImp_uid());
	    payVO.setPayment_amount(String.valueOf(payDto.getPrice()));
	    payVO.setPayment_status(payDto.getPaymentStatus());
	    payVO.setBuyer_name(memberInfo.getMember_name());
	    payVO.setBuyer_email(memberInfo.getEmail1() + "@" + memberInfo.getEmail2());
	    payVO.setUsed_point(payDto.getUsed_point());
	    payVO.setPaymentId(payDto.getPaymentId());
	    
	    orderService.addNewpay(payVO);

	    orderService.removeOrderedItemsFromCart(payDto.getOrderItems(), memberInfo.getMember_id());
	    
	    int final_point = memberInfo.getPoint() - payDto.getUsed_point();  
	    orderService.deductionPoint(memberInfo.getMember_id(), final_point);
	    
	    session.setAttribute("myOrderList", orderedGoodsList); // DB에서 조회한 상품 정보 리스트
	    session.setAttribute("myPayInfo", payVO);             // 방금 저장한 결제 정보
	    
	    MemberVO memberVO = memberService.login(memberInfo.getMember_id(), memberInfo.getMember_pw());
	    session.setAttribute("memberInfo", memberVO);
	    
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
	
	@RequestMapping(value="/payComplete.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView payComplete(HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
	    
	    ModelAndView mav = new ModelAndView("/common/layout");
	    mav.addObject("title", "주문 완료");
	    mav.addObject("body", "/WEB-INF/views/order/payComplete.jsp"); 
	    
	    // 이전 페이지에서 세션에 저장한 주문/결제 정보를 가져옵니다.
	    List<GoodsVO> myOrderList = (List<GoodsVO>) session.getAttribute("myOrderList");
	    PayVO myPayInfo = (PayVO) session.getAttribute("myPayInfo");
	    
	    // 사용이 끝난 세션 정보는 제거
	    session.removeAttribute("myOrderList");
	    session.removeAttribute("myPayInfo");
	    
	    mav.addObject("myOrderList", myOrderList);
	    mav.addObject("myPayInfo", myPayInfo);

	    return mav;
	}

	@RequestMapping(value="/cancelPayment.do", method=RequestMethod.POST)
	@ResponseBody
	public ApiResponse cancelPayment(@RequestBody Map<String, Object> cancelData, HttpServletRequest request) {
	    try {
	        String payment_id = (String) cancelData.get("payment_id");

	        String amountStr = String.valueOf(cancelData.get("amount"));
	        int amount = (amountStr == null || amountStr.isEmpty() || "null".equals(amountStr)) ? 0 : Integer.parseInt(amountStr);

	        // JSP에서 used_points 값이 비어있거나 null일 경우를 대비해 기본값 0을 설정합니다.
	        String usedPointsStr = String.valueOf(cancelData.get("used_points"));
	        int used_points = (usedPointsStr == null || usedPointsStr.isEmpty() || "null".equals(usedPointsStr)) ? 0 : Integer.parseInt(usedPointsStr);
	        
	        HttpSession session = request.getSession();
	        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
	        
	        portoneService.cancelPayment(payment_id, amount); 

	        orderService.updateOrderStatusToCancel(payment_id);
	        
	        if (used_points > 0) {
	            Map<String, Object> params = new HashMap<>();
	            params.put("member_id", memberInfo.getMember_id());
	            params.put("points_to_restore", used_points);
	            orderService.restorePoints(params);
	        }
	        
	        return new ApiResponse(true, "결제가 성공적으로 취소되었습니다.");

	    } catch (Exception e) {
	    	e.printStackTrace();
	        return new ApiResponse(false, "결제 취소에 실패했습니다: " + e.getMessage());
	    }
	}
}