package com.petmillie.order.controller;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.common.base.BaseController;
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
	public ModelAndView orderAllCartGoods( @RequestParam("cart_goods_qty")  String[] cart_goods_qty,
			                 HttpServletRequest request, HttpServletResponse response)  throws Exception{
		ModelAndView mav = new ModelAndView("/common/layout");
		mav.addObject("body", "/WEB-INF/views/order/orderEachGoods2.jsp");
		HttpSession session=request.getSession();
		Map cartMap=(Map)session.getAttribute("cartMap");
		List myOrderList=new ArrayList<OrderVO>();
		
		List<GoodsVO> myGoodsList=(List<GoodsVO>)cartMap.get("myGoodsList");
		MemberVO memberVO=(MemberVO)session.getAttribute("memberInfo");
		
		for(int i=0; i<cart_goods_qty.length;i++){
			String[] cart_goods=cart_goods_qty[i].split(":");
			for(int j = 0; j< myGoodsList.size();j++) {
				GoodsVO goodsVO = myGoodsList.get(j);
				int goods_id = goodsVO.getGoods_num();
				if(goods_id==Integer.parseInt(cart_goods[0])) {
					OrderVO _orderVO=new OrderVO();
					String goods_title=goodsVO.getGoods_name();
					String goods_sales_price=goodsVO.getGoods_sales_price();
					String goods_fileName=goodsVO.getGoods_fileName();
					_orderVO.setGoods_num(goods_id);
					_orderVO.setGoods_name(goods_title);
					_orderVO.setGoods_sales_price(goods_sales_price);
					_orderVO.setGoods_fileName(goods_fileName);
					_orderVO.setGoods_qty(Integer.parseInt(cart_goods[1]));
					myOrderList.add(_orderVO);
					break;
				}
			}
		}
		session.setAttribute("myOrderList", myOrderList);
		session.setAttribute("memberInfo", memberVO);
		return mav;
	}	
	// 기존 결제 메서드
/*	@RequestMapping(value="/payToOrderGoods.do" ,method = RequestMethod.POST)
	public ModelAndView payToOrderGoods(@RequestParam Map<String, String> receiverMap,
			                       HttpServletRequest request, HttpServletResponse response)  throws Exception{
		String viewName=(String)request.getAttribute("viewName");

		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "구매완료");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		HttpSession session=request.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("memberInfo");
		if (memberVO == null) {
		    // 로그인 안 된 상태면 로그인 화면으로 이동
		    return new ModelAndView("redirect:/member/loginForm.do");
		}
		String member_id=memberVO.getMember_id();
		String orderer_name=memberVO.getMember_name();
		List<OrderVO> myOrderList=(List<OrderVO>)session.getAttribute("myOrderList");
		
		for(int i=0; i<myOrderList.size();i++){
			OrderVO orderVO=(OrderVO)myOrderList.get(i);
			orderVO.setMember_id(member_id);
			orderVO.setOrder_name(orderer_name);
			orderVO.setReceiver_name(receiverMap.get("receiver_name"));
			orderVO.setTel1(receiverMap.get("tel1"));
			orderVO.setTel2(receiverMap.get("tel2"));
			orderVO.setTel3(receiverMap.get("tel3"));
			orderVO.setTotal_price(receiverMap.get("total_price"));
			orderVO.setZipcode(receiverMap.get("zipcode"));
			orderVO.setRoadAddress(receiverMap.get("roadAddress"));
			orderVO.setJibunAddress(receiverMap.get("jibunAddress"));
			orderVO.setNamujiAddress(receiverMap.get("namujiAddress"));
			orderVO.setDelivery_method(receiverMap.get("delivery_method"));
			orderVO.setDelivery_message(receiverMap.get("namujiAddress"));
			orderVO.setPay_order_tel(receiverMap.get("pay_order_tel"));
			int sales_price = Integer.parseInt(orderVO.getGoods_sales_price());
		    //orderVO.setGoods_qty(goods_qty);
		  
			myOrderList.set(i, orderVO); 
			}//end for
		PayVO payVO =  new PayVO();
		payVO.setOrder_num(myOrderList.get(0).getOrder_num());
		payVO.setPay_method(receiverMap.get("pay_method"));
		payVO.setCard_com_name(receiverMap.get("card_com_name"));
		payVO.setCard_pay_month(receiverMap.get("card_pay_month"));
		payVO.setPay_order_tel(receiverMap.get("pay_order_tel"));
		payVO.setPayment_amount(receiverMap.get("payment_amount"));
		payVO.setPayment_status("success");
		payVO.setPg_tid(receiverMap.get("pg_tid"));
		
	    orderService.addNewOrder(myOrderList, payVO);
		mav.addObject("myOrderInfo",receiverMap);//OrderVO�� �ֹ���� ��������  �ֹ��� ������ ǥ���Ѵ�.
		mav.addObject("myOrderList", myOrderList);
		return mav;
	}  */
	
	//포트원 결제 메서드
	@RequestMapping(value="/payToOrderGoods.do", method=RequestMethod.POST ) 
	@ResponseBody
	public ApiResponse payToOrderGoods(@RequestBody Map<String, Object> payData, HttpServletRequest request) throws Exception {
	    
	    // 필수값 추출
	    String paymentKey = (String) payData.get("portone_paymentKey");

	    // paymentKey가 null이면 에러 처리
	    if (paymentKey == null || paymentKey.isBlank()) {
	        return new ApiResponse(false, "결제 실패: paymentKey 없음");
	    }

	    // 여기서 검증 로직 필요 시 portoneService.verify() 호출
	    // 주문/결제 DB 저장
	    OrderVO orderVO = new OrderVO();
	    orderVO.setReceiver_name((String) payData.get("receiver_name"));
	    orderVO.setTel1((String) payData.get("tel1"));
	    orderVO.setTel2((String) payData.get("tel2"));
	    orderVO.setTel3((String) payData.get("tel3"));
	    orderVO.setZipcode((String) payData.get("zipcode"));
	    orderVO.setRoadAddress((String) payData.get("roadAddress"));
	    orderVO.setJibunAddress((String) payData.get("jibunAddress"));
	    orderVO.setNamujiAddress((String) payData.get("namujiAddress"));
	    orderVO.setDelivery_method((String) payData.get("delivery_method"));
	    orderVO.setPay_order_tel((String) payData.get("pay_order_tel"));
	    orderVO.setDelivery_message((String) payData.get("delivery_message"));
	    orderVO.setTotal_price(String.valueOf(payData.get("price")));

	    PayVO payVO = new PayVO();
	    payVO.setPayment_id((String) payData.get("paymentId"));
	    payVO.setPay_method((String) payData.get("pay_method"));
	    payVO.setCard_com_name((String) payData.get("card_com_name"));
	    payVO.setCard_pay_month((String) payData.get("card_pay_month"));
	    payVO.setPayment_status((String) payData.get("paymentStatus"));
	    payVO.setPg_tid((String) payData.get("portone_paymentKey"));
	    payVO.setPay_order_tel((String) payData.get("pay_order_tel"));

	    // 금액 필드는 타입 주의
	    String priceStr = String.valueOf(payData.get("price"));
	    try {
	        int final_price = Integer.parseInt(priceStr);
	        payVO.setFinal_total_price(final_price);        // int 필드
	        payVO.setPayment_amount(priceStr);        // String 필드도 같이 채움
	    } catch (NumberFormatException e) {
	        // 금액 파싱 실패 시 예외처리
	        return new ApiResponse(false, "금액 데이터가 올바르지 않습니다.");
	    }

	    // 결제 시간은 현재 시간으로 넣는 것도 방법
	    String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
	    payVO.setPay_order_time(now);
	    payVO.setPayment_time(now);

	    orderService.addNewOrder(List.of(orderVO), payVO);

	    return new ApiResponse(true, "주문 및 결제 완료되었습니다!");
	}

}