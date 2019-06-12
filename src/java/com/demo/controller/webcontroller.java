package com.demo.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.demo.entity.*;
import com.demo.service.OrderService;
import com.demo.service.ProductService;
import com.demo.service.userservice;
import com.demo.service.userdetail;
import com.demo.until.AlipayConfig;
import com.demo.until.Code;
import com.demo.until.ordertime;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.*;

@Controller
public class webcontroller {
    static final Log log = LogFactory.getLog(webcontroller.class);
    @Autowired
    private userservice userservice;
    @Autowired
    private ProductService productService;
    @Autowired
    private userdetail userdetail;
    @Autowired
    private OrderService orderService;

    @RequestMapping(value = "/login")
    @ResponseBody
    public Map<String, Object> login(String verifyCode, String username, String password, HttpSession httpSession) {
        Map map = new HashMap();
        String result;
        String code = (String) httpSession.getAttribute("code");
        if (!verifyCode.equalsIgnoreCase(code)) {
            result = "wrong";
        } else {
            user user = userservice.islogin(username, password);
            if (user != null) {
                result = "success";
                httpSession.setAttribute("currentUser", user);
            } else {
                result = "fail";
            }
        }
        map.put("message", result);
        return map;
    }

    @RequestMapping(value = "/gllogin")
    @ResponseBody
    public Map<String, Object> gllogin(String verifyCode, String username, String password, HttpSession httpSession) {
        Map map = new HashMap();
        String result;
        String code = (String) httpSession.getAttribute("code");
        if (!verifyCode.equalsIgnoreCase(code)) {
            result = "wrong";
        } else {
            glyuan glyuan = userservice.gllogin(username, password);
            if (glyuan != null) {
                result = "success";
                httpSession.setAttribute("currentUser", glyuan);
            } else {
                result = "fail";
            }
        }
        map.put("message", result);
        return map;
    }

    @RequestMapping(value = "/zhuce")
    @ResponseBody
    public Map zhuce(String username, String email, String nickName, String password) {
        String result;
        //判断要注册的用户名是否已存在
        if (userservice.getUserByName(username) != null) {
            result = "nameExist";
        } else {
            user user = new user();
            user.setUsername(username);
            user.setPassword(password);
            userservice.iszhuce(user);
            user = userservice.getUserByName(username);
            userDetail userDetail = new userDetail();
            userDetail.setId(user.getId());
            userDetail.setEmail(email);
            userDetail.setNicheng(nickName);
            userDetail.setRole(0);
            if (userdetail.addUserDetail(userDetail)) {
                result = "success";
            } else {
                result = "fail";
            }
        }
        Map resultMap = new HashMap();
        resultMap.put("result", result);
        return resultMap;
    }

    @RequestMapping(value = "/getAllProducts", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getallproduct() {
        List<Product> productList = productService.getAllProduct();
        String allProducts = JSONArray.toJSONString(productList);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("allProducts", allProducts);
        log.info(allProducts);
//        httpSession.setAttribute("mess",allProducts);
        return resultMap;
    }

    @RequestMapping(value = "/searchPre")
    @ResponseBody
    public Map<String, Object> searchPre(String searchKeyWord, HttpSession httpSession) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        httpSession.setAttribute("searchKeyWord", searchKeyWord);
        resultMap.put("result", "success");
        return resultMap;
    }

    @RequestMapping(value = "/searchProduct")
    @ResponseBody
    public Map<String, Object> searchProduct(String searchKeyWord) {
        log.info(searchKeyWord);
        List<Product> list = productService.searchProduct(searchKeyWord);
        Map<String, Object> resultMap = new HashMap<String, Object>();
        if (list.size() > 0) {
            String searchResult = JSONArray.toJSONString(list);
            resultMap.put("result", searchResult);
            return resultMap;
        }
        return resultMap;
    }

    @RequestMapping(value = "/search")
    public String search() {
        return "search";
    }

    @RequestMapping(value = "/productDe")
    @ResponseBody
    public Map<String, Object> productDetail(int id, HttpSession httpSession) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Product product = productService.getProduct(id);
        if (product != null) {
            httpSession.setAttribute("productDetail", product);
            resultMap.put("result", "success");
            return resultMap;
        }
        resultMap.put("result", "error");
        return resultMap;
    }

//    @RequestMapping(value = "/getUserAddress")
//    @ResponseBody
//    public Map<String,Object> getUserAddress(int id) {
//        String address = userdetail.getAddress(id);
//        Map<String,Object> map = new HashMap();
//        if (address != null) {
//            map.put("result", address);
//            return map;
//        }
//        return map;
//    }
//
//    @RequestMapping(value = "/getUserPhoneNumber")
//    @ResponseBody
//    public Map<String,Object> getUserPhoneNumber(int id) {
//        Map<String,Object> map = new HashMap();
//        String phoneNumber = userdetail.phoneNumber(id);
//        if (phoneNumber!=null){
//            map.put("result", phoneNumber);
//        }
//        return map;
//    }
//    @RequestMapping(value = "/getlianxiren")
//    @ResponseBody
//    public Map getlianxiren(int id){
//        Map map=new HashMap();
//       String lianxiren= userdetail.lianxiren(id);
//       if (lianxiren!=null){
//           map.put("result",lianxiren);
//           return map;
//       }
//       return  map;
//    }

    @RequestMapping(value = "/exit")
    public String doLogout(HttpSession httpSession, HttpServletResponse httpServletResponse) {
        //删除用户信息，重定向到登录页面
        httpSession.removeAttribute("currentUser");
        Cookie c = new Cookie("user", "");
        c.setMaxAge(0);
        httpServletResponse.addCookie(c);
        return "redirect:index.jsp";
    }

    @RequestMapping(value = "/getProductById")
    @ResponseBody
    public Map<String, Object> getProductById(int id) {
        Product product = productService.getProduct(id);
        Map<String, Object> map = new HashMap();
        String productResult = JSONArray.toJSONString(product);
        map.put("result", productResult);
        return map;
    }

    @RequestMapping(value = "addShoppingCar")
    @ResponseBody
    public Map shoopCar(int productId, int counts, HttpServletRequest request) {
        // 2.根据id查找商品
        Product p = productService.getProduct(productId);
        // 3.得到购物车
        HttpSession session = request.getSession();
        Map<Product, Integer> cart = (Map<Product, Integer>) session.getAttribute("cart");
        if (cart == null) {// 如果cart不存在，说明是第一次购物.
            cart = new HashMap();
        }
        // 判断购物车中是否有要添加商品。
        Integer count = cart.put(p, counts);
        if (count != null) {
            // 说明有商品
            cart.put(p, count + counts);
        } else {
            cart.put(p, counts);
        }
        session.setAttribute("cart", cart);
        Map map = new HashMap();
        map.put("result", "success");
        return map;
    }


    @RequestMapping(value = "/getAllUser")
    @ResponseBody
    /**
     * 获取除了管理员外的全部用户
     */
    public Map getAllUser(HttpSession session) {
        session.removeAttribute("user");
        List<user> user = userservice.getalluser();
        Map map = new HashMap();
        if (user.size() > 0) {
            session.setAttribute("user", user);
            return map;
        }
        map.put("result", "fail");
        return map;
    }

    // 从购物车中删除商品
    @RequestMapping(value = "delShoopingCar")
    @ResponseBody
    public Map remove(String[] id, HttpServletRequest request) {
        // 得到购物车
        int num = id.length;
        int count = 0;
        HttpSession session = request.getSession();
        Map<Product, Integer> cart = (Map<Product, Integer>) session.getAttribute("cart");
        for (int i = 0; i < id.length; i++) {
            Product p = new Product();
            p.setId(Integer.parseInt(id[i]));
            if (cart.remove(p).intValue() > 0) {
                count++;
            }
        }
        Map map = new HashMap();
        log.info(count + "," + num);
        if (num == count) {
            map.put("result", "删除成功");
        } else {
            map.put("result", "删除失败");
        }
        if (cart.size() == 0) {
            session.removeAttribute("cart");
        }
        return map;
    }

    // 修改购物车中商品数量
    @RequestMapping(value = "setShoopingCar")
    @ResponseBody
    public Map update(int id, int count, HttpServletRequest request) {
        // 这是要修改的商品
        log.info("id的值：" + id + " " + "count is:" + count);
        Product p = new Product();
        p.setId(id);

        // 得到购物车
        HttpSession session = request.getSession();
        Map<Product, Integer> cart = (Map<Product, Integer>) session.getAttribute("cart");

        // 修改商品的数量
        if (count == 0) {
            cart.remove(p); // 将商品从购物车中移除
        } else {
            cart.put(p, count);
        }
        session.setAttribute("cart", cart);
        Map map = new HashMap();
        map.put("result", "success");
        return map;
    }

    @RequestMapping(value = "getUserById")
    @ResponseBody
    public Map getUserById(int id) {
        user user = userservice.getUserById(id);
        String userString = JSON.toJSONString(user);
        Map map = new HashMap();
        map.put("result", userString);
        return map;
    }

    @RequestMapping(value = "getUserDetailById")
    @ResponseBody
    public Map getUserDetailById(int id) {
        userDetail userDetail = userdetail.getUserDetailById(id);
        String userString = JSON.toJSONString(userDetail);
        Map map = new HashMap();
        map.put("result", userString);
        return map;
    }

    @RequestMapping(value = "updateInfo")
    @ResponseBody
    /**
     * 修改用户信息
     */
    public Map updateInfo(String email, String nickName, int id) {
        userDetail userDetail = new userDetail();
        userDetail.setNicheng(nickName);
        userDetail.setEmail(email);
        userDetail.setId(id);
        userdetail.updateInfo(userDetail);
        Map map = new HashMap();
        map.put("result", "success");
        return map;
    }

    @RequestMapping(value = "deleteUser")
    @ResponseBody
    /**
     * 批量删除用户
     */
    public Map deleteuser(String[] ids) {
        int[] id = new int[ids.length];
        for (int i = 0; i < ids.length; i++) {
            id[i] = Integer.parseInt(ids[i]);
        }
        Map map = new HashMap();
        userdetail.deleteUser(id);
        if (userservice.deleteUser(id)) {
            map.put("result", "删除成功");
            return map;
        }
        map.put("result", "删除失败");
        return map;
    }

    @RequestMapping(value = "deleteProduct")
    @ResponseBody
    public Map deleteProduct(int id) {
        Map map = new HashMap();
        if (productService.deleteProduct(id)) {
            map.put("result", "删除成功");
            return map;
        }
        map.put("result", "删除失败");
        return map;
    }

    @RequestMapping("/upload")
    @ResponseBody
    /**
     * 图片上传,格式没有要求
     */
    public Map uploadPic(@RequestParam MultipartFile productImgUpload, HttpServletRequest request, HttpSession httpSession) throws IllegalStateException {
        if (httpSession.getAttribute("path") != null) {
            httpSession.removeAttribute("path");
        }
        String result = "fail";
        Map<String, Object> resultMap = new HashMap<String, Object>();
        try {
            if (productImgUpload != null && !productImgUpload.isEmpty()) {
                String fileRealPath = request.getSession().getServletContext().getRealPath("/imgs");
                // 获取图片原始文件名
                String originalFilename = productImgUpload.getOriginalFilename();
                File fileFolder = new File(fileRealPath);
//                System.out.println("fileRealPath=" + fileRealPath + "/" + originalFilename);
                if (!fileFolder.exists()) {
                    fileFolder.mkdirs();
                }
                File file = new File(fileFolder, originalFilename);
                productImgUpload.transferTo(file);
                result = "success";
                httpSession.setAttribute("path", "imgs/" + originalFilename);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resultMap.put("result", result);
        return resultMap;
    }

    @RequestMapping(value = "addProduct1")
    @ResponseBody
    public Map addProduct(String name, String description, int type, String price, String counts, HttpSession httpSession) {
        Map map = new HashMap();
        Product product = new Product();
        product.setDescription(description);
        String imgurl = (String) httpSession.getAttribute("path");
        product.setImgurl(imgurl);
        product.setName(name);
        product.setPnum(Integer.parseInt(counts));
        product.setType(type);
        product.setPrice(Double.parseDouble(price));
        if (productService.addProduct(product)) {
            map.put("result", "success");
            return map;
        }
        map.put("result", "fail");
        return map;
    }

    @RequestMapping(value = "getOrderInfo")
    @ResponseBody
    /**
     * 订单生成前获取商品信息
     */
    public Map getOrderInfo(HttpSession session, String[] productIds, String[] counts) {
        Map<Product, Integer> map = new HashMap();
        for (int i = 0; i < productIds.length; i++) {
            Product product = productService.getProduct(Integer.parseInt(productIds[i]));
            map.put(product, Integer.parseInt(counts[i]));
        }
        session.setAttribute("productList", map);
        Map resultMap = new HashMap();
        resultMap.put("result", "success");
        return resultMap;
    }

    @RequestMapping(value = "createOrder")
    @ResponseBody
    public Map createOrder(String message,HttpSession session, String[] productIds, String[] counts, String name, String address, String phone, String orderCode) {
        //创建订单
        Map map = new HashMap();
        user user = (user) session.getAttribute("currentUser");
        if (orderCode==null||orderCode.equals("")) {
            System.out.println("===========================================================");
            Order order = new Order();
            // 补全字段
            order.setOrder_code(ordertime.getOrderIdByTime());
            order.setCreate_date(new Date());
            order.setStatus(0);
            order.setReceiver(name);
            order.setMobile(phone);
            order.setAddress(address);
            order.setUser_id(user.getId());
            List<orderItem> list = new ArrayList();
            for (int i = 0; i < productIds.length; i++) {
                orderItem orderItem = new orderItem();
                orderItem.setProduct_id(Integer.parseInt(productIds[i]));
                Product product = productService.getProduct(orderItem.getProduct_id());
                orderItem.setProduct(product);
                orderItem.setNumber(Integer.parseInt(counts[i]));
                // 订单项加入list集合
                list.add(orderItem);
            }
            order.setOrderItems(list);
            // 添加订单和订单项
            orderService.addOrder(order);
            session.setAttribute("creatorderr", order.getOrder_code());
        }else {
            session.setAttribute("creatorderr", orderCode);
        }
        //判断是直接购买还是从购物车购买
        if (message!=null||!message.equals("")) {
            //删除购物车中已结算的商品
            Map<Product, Integer> cart = (Map<Product, Integer>) session.getAttribute("cart");
            if (cart != null) {
                for (int i = 0; i < productIds.length; i++) {
                    Product p = new Product();
                    p.setId(Integer.parseInt(productIds[i]));
                    cart.remove(p);
                }
                if (cart.size() == 0) {
                    session.removeAttribute("cart");
                }
            }
        }
            map.put("result", "success");
            return map;
    }

    // 查看我的订单
    @RequestMapping(value = "findMyOrder")
    @ResponseBody
    public Map findMyOrder(@RequestParam(defaultValue="1") Integer page,HttpSession session) {
        /**
         * 用户已经登录，从session中获取用户信息，从用户信息中得到user_id ,调用方法得到用户的订单的集合
         *
         */
        if (page==0){
            page++;
        }
        PageHelper.startPage(page, 5);
        user user = (user) session.getAttribute("currentUser");
        int user_id = user.getId();
        List<Order> list = orderService.findMyOrder(user_id);
//        for (int i = 0; i < list.size(); i++) {
//            List<orderItem> itemslist = list.get(i).getOrderItems();
//            for (int j = 0; j < itemslist.size(); j++) {
//                Product product = productService.getProduct(itemslist.get(j).getProduct_id());
//                itemslist.get(j).setProduct(product);
//            }
//        }
        PageInfo<Order> p=new PageInfo<>(list);
        Map map = new HashMap();
        if (list != null) {
//            session.setAttribute("myorderList", list);
            session.setAttribute("page",p);
            map.put("result", "success");
            return map;
        }
        return map;
    }

    // 查看订单的详情
    @RequestMapping(value = "findOrderItem")
    public String findOrderItem(int id, HttpSession session) {
        /**
         * 1、从请求转发中获取订单的id 2、调用方法得到订单详情的集合 3、通过请求转发将订单详情在页面上显示
         */
        List<orderItem> list = orderService.findOrderItem(id);
        for (int i = 0; i < list.size(); i++) {
            int Product_id = list.get(i).getProduct_id();
            Product product = productService.getProduct(Product_id);
            list.get(i).setProduct(product);
        }
        if (list != null) {
            Order order=orderService.getOrderBuyId(id);
            session.setAttribute("orderItemList", list);
            session.setAttribute("orderxq",order);
        }
        return "orderItem";
    }

    @RequestMapping(value = "deleteOrder")
    @ResponseBody
    public Map deleteOrder(int id) {
        // 取消/删除订单
        Order order=orderService.getOrderBuyId(id);
        if (order.getConfirm_date()==null||order.getConfirm_date().equals("")) {
            List<orderItem> list = order.getOrderItems();
            for (int i = 0; i < list.size(); i++) {
                Product product = orderService.getProductBuyId(list.get(i).getProduct_id());
                product.setPnum(product.getPnum() + list.get(i).getNumber());
                productService.updatePnum(product);
            }
        }
        Map map = new HashMap();
        if (orderService.delete(id)) {
            map.put("result", "success");
            return map;
        }
        return map;
    }

    @RequestMapping(value = "/goAlipay", produces = "text/html; charset=UTF-8")
    @ResponseBody
    public String goAlipay(HttpSession session) throws Exception {
        String ordercode= (String) session.getAttribute("creatorderr");
        Order order = orderService.getOrderByorderCode(ordercode);
        List<orderItem> list = order.getOrderItems();
        double sum=0;
        for (int i = 0; i < list.size(); i++) {
            orderItem orderItem = list.get(i);
            Product product = orderService.getProductBuyId(orderItem.getProduct_id());
            sum+=product.getPrice()*orderItem.getNumber();
            }
        //获得初始化的AlipayClient
        AlipayClient alipayClient = new DefaultAlipayClient(AlipayConfig.gatewayUrl, AlipayConfig.app_id, AlipayConfig.merchant_private_key, "json", AlipayConfig.charset, AlipayConfig.alipay_public_key, AlipayConfig.sign_type);

        //设置请求参数
        AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();
        alipayRequest.setReturnUrl(AlipayConfig.return_url);
        alipayRequest.setNotifyUrl(AlipayConfig.notify_url);

        //商户订单号，商户网站订单系统中唯一订单号，必填
        String out_trade_no = order.getOrder_code();
        //付款金额，必填
        String total_amount = sum+"";
        //订单名称，必填
        String subject = "商品支付订单";
        //商品描述，可空
        String body = "";

        // 该笔订单允许的最晚付款时间，逾期将关闭交易。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。
        String timeout_express = "1c";

        alipayRequest.setBizContent("{\"out_trade_no\":\""+ out_trade_no +"\","
                + "\"total_amount\":\""+ total_amount +"\","
                + "\"subject\":\""+ subject +"\","
                + "\"body\":\""+ body +"\","
                + "\"timeout_express\":\""+ timeout_express +"\","
                + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");

        //请求
        String result = alipayClient.pageExecute(alipayRequest).getBody();
        System.out.println(result);
        return result;
    }

    /**
     * @Description: 支付宝同步通知页面
     */
    @RequestMapping(value = "alipayReturnNotice")
    public ModelAndView alipayReturnNotice(HttpServletRequest request) throws Exception {
        log.info("--------------------------------------------支付成功, 进入同步通知接口-----------------------------------------------------");
        //获取支付宝GET过来反馈信息
        Map<String,String> params = new HashMap<String,String>();
        Map<String,String[]> requestParams = request.getParameterMap();
        for (Iterator<String> iter = requestParams.keySet().iterator(); iter.hasNext();) {
            String name =iter.next();
            String[] values = requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用
            valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
        }
        ModelAndView mv = new ModelAndView("myOrder");
        boolean signVerified = false;
        try{
            signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.alipay_public_key, AlipayConfig.charset, AlipayConfig.sign_type); //调用SDK验证签名
        }catch (Exception e) {
            System.out.println("SDK验证签名出现异常");
        }
        //——请在这里编写您的程序（以下代码仅作参考）——
        if(signVerified) {
            //商户订单号
            String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");

            //付款金额
            String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"),"UTF-8");
            Order order=orderService.getOrderByorderCode(out_trade_no);
            order.setStatus(1);
            order.setPay_date(new Date());
            List<orderItem> list = order.getOrderItems();
            Map map = new HashMap();
            //更新库存
            for (int i = 0; i < list.size(); i++) {
                orderItem orderItem = list.get(i);
                Product product = orderService.getProductBuyId(orderItem.getProduct_id());
                product.setPnum(product.getPnum() - orderItem.getNumber());
                orderItem.setProduct(product);
            }
            if (orderService.updateOrder(order)) {
                map.put("result", "success");

            }
        }else {
            log.info("支付, 验签失败...");
        }

        return mv;
    }

    /**
     * @Description: 支付宝异步 通知页面
     */
    @RequestMapping(value = "alipayNotifyNotice")
    @ResponseBody
    public String alipayNotifyNotice(HttpServletRequest request) throws Exception {

        log.info("支付成功, 进入异步通知接口...");

        //获取支付宝POST过来反馈信息
        Map<String,String> params = new HashMap<String,String>();
        Map<String,String[]> requestParams = request.getParameterMap();
        for (Iterator<String> iter = requestParams.keySet().iterator(); iter.hasNext();) {
            String name = iter.next();
            String[] values = requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用
//			valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
        }

        boolean signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.alipay_public_key, AlipayConfig.charset, AlipayConfig.sign_type); //调用SDK验证签名

        //——请在这里编写您的程序（以下代码仅作参考）——

		/* 实际验证过程建议商户务必添加以下校验：
		1、需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
		2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
		3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）
		4、验证app_id是否为该商户本身。
		*/
        if(signVerified) {//验证成功
            log.info("支付成功...");

        }else {//验证失败
            log.info("支付, 验签失败...");
        }
        return "success";
    }

    @RequestMapping(value = "orderPay")
    public String orderPay(int id, HttpSession session) {
        session.removeAttribute("productList");
        Order order = orderService.getOrderBuyId(id);
        List<orderItem> list = order.getOrderItems();
        Map map=new HashMap();
        for (int i = 0; i < list.size(); i++) {
            orderItem orderItem = list.get(i);
            Product product = orderService.getProductBuyId(orderItem.getProduct_id());
            map.put(product,orderItem.getNumber());
            orderItem.setProduct(product);
        }
        if (list != null) {
            session.setAttribute("creatorders", order.getOrder_code());
            session.setAttribute("productList",map);
        }
        return "buyPage";
    }

    @RequestMapping(value = "findAllOrder")
    public String findAllOrder(HttpSession session,@RequestParam(defaultValue="1") int page) {
        /**
         * 查询全部用户订单
         */
        if (page==0){
            page++;
        }
        System.out.println("page的值为"+page);
        PageHelper.startPage(page, 8);
        List<Order> list = orderService.findAllOrder();
        PageInfo<Order> p=new PageInfo<>(list);
//        session.setAttribute("allorders", list);
        session.setAttribute("pageO",p);
        return "listOrder";
    }

    @RequestMapping(value = "getCode")
    public void getCode(HttpSession session, HttpServletResponse resp) {
        /**
         *  获取验证码
         */
        int width = 120;
        int height = 30;
        BufferedImage bufferedImage = new BufferedImage(width, height,
                BufferedImage.TYPE_INT_RGB);
        String randomCode = Code.getCode(bufferedImage, width, height);
        session.setAttribute("code", randomCode);
        // 禁止图像缓存。
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setDateHeader("Expires", 0);
        resp.setContentType("image/jpeg");
        // 将图像输出到Servlet输出流中。
        ServletOutputStream sos;
        try {
            sos = resp.getOutputStream();
            ImageIO.write(bufferedImage, "jpeg", sos);
            sos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "foundpass")
    @ResponseBody
    public Map foundpass(String password, int id) {
        /**
         * 忘记密码
         */
        user user = new user();
        user.setPassword(password);
        user.setId(id);
        Map map = new HashMap();
        if (userservice.updateInfo(user)) {
            map.put("result", "success");
            return map;
        }
        return map;
    }

    @RequestMapping(value = "getUserByemail")
    @ResponseBody
    public Map getUserByemail(HttpSession session, String email) {
        user user = userservice.getUserByemail(email);
        Map map = new HashMap();
        if (user != null) {
            map.put("result", "success");
            session.setAttribute("founduser", user);
            return map;
        }
        return map;
    }

    @RequestMapping(value = "orderDelivery")
    @ResponseBody
    public Map orderDelivery(int id) {
        /**
         * 发货
         */
        Order order=new Order();
        order.setDelivery_date(new Date());
        order.setStatus(2);
        order.setId(id);
        Map map = new HashMap();
        if(orderService.updateStatus(order)){
            map.put("result", "success");
            return map;
        }
        return map;
    }

    @RequestMapping(value = "comfire")
    @ResponseBody
    public Map comfire(int id) {
        /**
         * 确认收货
         */
        Order orders = new Order();
        orders.setStatus(3);
        orders.setId(id);
        orders.setConfirm_date(new Date());
        Map map = new HashMap();
        if (orderService.updateStatus(orders)) {
            map.put("result", "success");
            return map;
        }
        return map;
    }

    @RequestMapping(value = "quxiaoOrder")
    @ResponseBody
    public Map quxiaoOrder(int id) {
        /**
         * 取消订单
         */
        Order orders = new Order();
        orders.setStatus(4);
        orders.setId(id);
        Map map = new HashMap();
        if (orderService.updateStatus(orders)) {
            map.put("result", "success");
            return map;
        }
        return map;
    }

    @RequestMapping(value = "noagree")
    @ResponseBody
    public Map noagree(int id) {
        /**
         * 不同意取消订单
         */
        Order order=orderService.getOrderBuyId(id);
        if (order.getPay_date()==null){
            order.setStatus(0);
        }else {
            order.setStatus(1);
        }
        Map map = new HashMap();
        if (orderService.updateStatus(order)) {
            map.put("result", "success");
            return map;
        }
        return map;
    }
}
