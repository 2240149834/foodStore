package com.demo.until;

import com.demo.entity.user;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;

/**
 * 登录拦截器：
 *
 */
public class LoginInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 在业务处理器处理请求之前被调用
	 * - 如果返回false
	 * 从当前的拦截器往回执行所有拦截器的afterCompletion()方法，再退出拦截器链
	 * - 如果返回true
	 * 执行下一个拦截器，知道素有的拦截器都执行完毕
	 * 再执行被拦截的Controller
	 * 然后进入拦截器链，
	 * 从最后一个拦截器往回执行所有的postHandel()方法
	 * 接着再从最后一个拦截器往回执行所有的afterCompletion()方法
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		HttpSession session = request.getSession();
		String[] noNeedAuthPage = new String[]{
				"/control",
				"/getAllUser",
				"/updateInfo",
				"/deleteUser",
				"/deleteProduct",
				"/createOrder",
				"/findMyOrder",
				"/payed",
				"/orderPay",
				"/findAllOrder",
				"/orderDelivery",
				"/comfire"
		};
		String uri = request.getRequestURI();
		if (!Arrays.asList(noNeedAuthPage).contains(uri)) {
			user user = (user) session.getAttribute("currentUser");
			if (null == user) {
				response.sendRedirect("/getAllProducts");
				return false;
			}
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}
}
