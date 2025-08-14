package com.petmillie.goods.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.petmillie.common.base.BaseController;
import com.petmillie.goods.service.GoodsService;
import com.petmillie.goods.vo.GoodsVO;
import com.petmillie.member.vo.MemberVO;
import com.petmillie.mypage.service.MyPageService;

import net.sf.json.JSONObject;

@Controller("goodsController")
@RequestMapping(value="/goods")
public class GoodsControllerImpl extends BaseController implements GoodsController {
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private GoodsVO goodsVO;
	@Autowired
	private MyPageService myPageService;
	
	@RequestMapping(value="/goodsDetail.do" ,method = RequestMethod.GET)
	public ModelAndView goodsDetail(@RequestParam("goods_num") int goods_num,
			                       HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("제품상세진입");
		String viewName=(String)request.getAttribute("viewName");
		HttpSession session=request.getSession();
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "제품상세");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		
		System.out.println("서비스 진입전 ");
		Map goodsMap=goodsService.goodsDetail(goods_num);
		System.out.println("서비스 진입 후: " +goodsMap);
		
		mav.addObject("goodsMap", goodsMap);
		GoodsVO goodsVO=(GoodsVO)goodsMap.get("goodsVO");
		mav.addObject("goodsVO", goodsVO); 
		addGoodsInQuick(goods_num,goodsVO,session);

		
		System.out.println("가격 확인: " + goodsVO.getGoods_sales_price());
		return mav;
	}
	
	@RequestMapping(value="/keywordSearch.do",method = RequestMethod.GET,produces = "application/text; charset=utf8")
	public @ResponseBody String  keywordSearch(@RequestParam("keyword") String keyword,
			                                  HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		//System.out.println(keyword);
		if(keyword == null || keyword.equals(""))
		   return null ;
	
		keyword = keyword.toUpperCase();
	    List<String> keywordList =goodsService.keywordSearch(keyword);
	    
	 //  ϼ JSONObject (ü)
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("keyword", keywordList);
		 		
	    String jsonInfo = jsonObject.toString();
	   // System.out.println(jsonInfo);
	    return jsonInfo ;
	}
	
	@RequestMapping(value="/searchGoods.do" ,method = RequestMethod.GET)
	public ModelAndView searchGoods(@RequestParam("searchWord") String searchWord,
			                       HttpServletRequest request, HttpServletResponse response) throws Exception{
		String viewName=(String)request.getAttribute("viewName");
		ModelAndView mav=new ModelAndView("/common/layout");
		mav.addObject("title", "제품검색");
		mav.addObject("body", "/WEB-INF/views" + viewName + ".jsp");
		List<GoodsVO> goodsList=goodsService.searchGoods(searchWord);
		mav.addObject("goodsList", goodsList);
		return mav;
		
	}
	
//	private void addGoodsInQuick(String goods_num,GoodsVO goodsVO,HttpSession session){
//		boolean already_existed=false;
//		List<GoodsVO> quickGoodsList; //ֱ  ǰ  ArrayList
//		quickGoodsList=(ArrayList<GoodsVO>)session.getAttribute("quickGoodsList");
//		
//		if(quickGoodsList!=null){
//			if(quickGoodsList.size() < 4){ //̸ ǰ Ʈ ǰ   
//				for(int i=0; i<quickGoodsList.size();i++){
//					GoodsVO _goodsBean=(GoodsVO)quickGoodsList.get(i);
//					if(goods_num.equals(_goodsBean.getGoods_num())){
//						already_existed=true;
//						break;
//					}
//				}
//				if(already_existed==false){
//					quickGoodsList.add(goodsVO);
//				}
//			}
//			
//		}else{
//			quickGoodsList =new ArrayList<GoodsVO>();
//			quickGoodsList.add(goodsVO);
//			
//		}
//		session.setAttribute("quickGoodsList",quickGoodsList);
//		session.setAttribute("quickGoodsListNum", quickGoodsList.size());
//	}
	private void addGoodsInQuick(int goods_num, GoodsVO goodsVO, HttpSession session) {
	    boolean already_existed = false;
	    List<GoodsVO> quickGoodsList = (ArrayList<GoodsVO>) session.getAttribute("quickGoodsList");

	    if (quickGoodsList != null) {
	        if (quickGoodsList.size() < 4) { 
	            for (int i = 0; i < quickGoodsList.size(); i++) {
	                GoodsVO _goodsBean = quickGoodsList.get(i);

	                // null 체크 추가
	                if (_goodsBean == null) {
	                    continue; // null이면 건너뜀
	                }

	                // int -> String 변환 후 비교
//	                if (goods_num.equals(String.valueOf(_goodsBean.getGoods_num()))) {
//	                    already_existed = true;
//	                    break;
//	                }
	            }
	            if (!already_existed) {
	                quickGoodsList.add(goodsVO);
	            }
	        }
	    } else {
	        quickGoodsList = new ArrayList<GoodsVO>();
	        quickGoodsList.add(goodsVO);
	        
	    }
	   
	    session.setAttribute("quickGoodsList", quickGoodsList);
	    session.setAttribute("quickGoodsListNum", quickGoodsList.size());
	}

	
	// 이 부분은 아마도 GoodsController 인터페이스의 추상 메소드를 구현한 것으로 보입니다.
	// 실제 웹 요청을 처리하는 @RequestMapping 메소드가 아니므로 이대로 두어도 됩니다.
	@Override
	public Map<String, List<GoodsVO>> listGoods() throws Exception {
	    // 이 메소드는 직접적인 HTTP 요청을 처리하지 않고, 다른 서비스나 컨트롤러에서 호출될 수 있습니다.
	    return goodsService.listGoods(); // goodsService의 listGoods() 호출
	}

	@RequestMapping(value="/goodsList.do", method = RequestMethod.GET)
	public ModelAndView goodsList(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    ModelAndView mav = new ModelAndView("/common/layout");

	    mav.addObject("title", "전체 상품");
	    mav.addObject("body", "/WEB-INF/views/goods/goodsList.jsp");

	    // 서비스 계층에서 List<GoodsVO> 직접 가져오기
	    List<GoodsVO> goodsList = goodsService.listAllGoods();
	    mav.addObject("goodsList", goodsList); // JSP로 전달

	    // 로그인 유저 기준으로 관심상품 Set 가져오기
	    HttpSession session = request.getSession();
	    MemberVO member = (MemberVO) session.getAttribute("memberInfo");
	    Set<Integer> likedGoodsSet = new HashSet<>();
	    if (member != null) {
	        likedGoodsSet = myPageService.getLikedGoodsSet(member.getMember_id()); 
	        // DB에서 해당 유저의 관심상품 번호만 뽑아서 Set<Integer>로 반환
	    }
	    mav.addObject("likedGoodsSet", likedGoodsSet); // JSP로 전달

	    return mav;
	}

    // --- 상품 목록을 표시하기 위해 추가/수정된 부분 끝 ---
	
}















