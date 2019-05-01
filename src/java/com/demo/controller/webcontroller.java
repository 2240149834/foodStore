package com.demo.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.demo.entity.*;
import com.demo.service.OrderService;
import com.demo.service.ProductService;
import com.demo.service.userservice;
import com.demo.service.userdetail;
import com.demo.until.Code;
import com.demo.until.ordertime;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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
    public Map<String, Object> login(String verifyCode, String username, String password, HttpSession httpSession, String remember, HttpServletResponse httpServletResponse) {
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
                System.out.println("fileRealPath=" + fileRealPath + "/" + originalFilename);
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
    public Map createOrder(String message,HttpSession session, String[] productIds, String[] counts, String name, String address, String phone, HttpServletRequest request) {
        //创建订单
        user user = (user) session.getAttribute("currentUser");
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
        String result = orderService.addOrder(order);
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
        Map map = new HashMap();
        if (result.equals("success")) {
            session.setAttribute("orderItemList", list);
            map.put("result", "success");
            return map;
        }
        return map;
    }

    // 查看我的订单
    @RequestMapping(value = "findMyOrder")
    @ResponseBody
    public Map findMyOrder(HttpSession session) {
        /**
         * 1、用户已经登录，从session中获取用户信息，从用户信息中得到user_id 2、调用方法得到用户的订单的集合
         * 3、通过请求转发将订单集合显示在myorder.jsp页面上
         */
        user user = (user) session.getAttribute("currentUser");
        int user_id = user.getId();
        List<Order> list = orderService.findMyOrder(user_id);
        for (int i = 0; i < list.size(); i++) {
            List<orderItem> itemslist = list.get(i).getOrderItems();
            for (int j = 0; j < itemslist.size(); j++) {
                Product product = productService.getProduct(itemslist.get(j).getProduct_id());
                itemslist.get(j).setProduct(product);
            }
        }
        Map map = new HashMap();
        if (list != null) {
            session.setAttribute("myorderList", list);
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

    @RequestMapping(value = "payed")
    @ResponseBody
    /**
     * 支付成功时
     */
    public Map payed(String[] order_id) {
        // 更新订单信息
        Order order = orderService.getOrderBuyId(Integer.parseInt(order_id[0]));
        order.setStatus(1);
        order.setPay_date(new Date());
        List<orderItem> list = order.getOrderItems();
        Map map = new HashMap();
        //更新库存
        for (int i = 0; i < list.size(); i++) {
            orderItem orderItem = list.get(i);
            Product product = orderService.getProductBuyId(orderItem.getProduct_id());
            if (product.getPnum() - orderItem.getNumber()<0){
                map.put("result", "fail");
                return  map;
            }
            product.setPnum(product.getPnum() - orderItem.getNumber());
            orderItem.setProduct(product);
        }
        if (orderService.updateOrder(order)) {
            map.put("result", "success");
            return map;
        }
        return map;
    }

    @RequestMapping(value = "orderPay")
    public String orderPay(int id, HttpSession session) {
        session.removeAttribute("orderItemList");
        Order order = orderService.getOrderBuyId(id);
        List<orderItem> list = order.getOrderItems();
        for (int i = 0; i < list.size(); i++) {
            orderItem orderItem = list.get(i);
            Product product = orderService.getProductBuyId(orderItem.getProduct_id());
            orderItem.setProduct(product);
        }
        if (list != null) {
            session.setAttribute("orderItemList", list);
        }
        return "pay";
    }

    @RequestMapping(value = "findAllOrder")
    public String findAllOrder(HttpSession session) {
        /**
         * 查询全部用户订单
         */
        List<Order> list = orderService.findAllOrder();
        session.setAttribute("allorders", list);
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
