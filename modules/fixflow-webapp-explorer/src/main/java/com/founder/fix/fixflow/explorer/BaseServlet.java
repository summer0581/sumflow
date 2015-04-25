/**
 *  Copyright 1996-2013 Founder International Co.,Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * @author 徐海洋
 */
package com.founder.fix.fixflow.explorer;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ObjectNode;

import com.founder.fix.fixflow.explorer.util.FileHandle;
import com.founder.fix.fixflow.explorer.util.ResultUtils;

/**
 * servlet基类
 * 职责：提供公共处理方法
 * 开发者：徐海洋
 */
public class BaseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public HttpServletRequest requestParm;
	public HttpServletResponse responseParm;
	
	public String getBasePath(){
		return requestParm.getSession().getServletContext().getRealPath("/");
	}
       
    public BaseServlet() {super();}
    
    private HashMap<String,Method> methods = new HashMap<String,Method>();
    
    private Class<?> []types = {};

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
       doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
       setRequestParm(request);setResponseParm(response);
       String command  = request.getParameter("method");
       if(null == command){
    	   try {
   			FileHandle.whenUploadFileBindParameter(request, response);
   			command = request.getAttribute("method").toString();
	   		} catch (Exception e) {}
       }
       Method method = null;
       method = getMethod(command);
       Object []args = {};
        try {
			method.invoke(this, args);
		} catch (Exception e) {
			e.printStackTrace();
			response.setContentType("text/html;charset=utf-8");
			response.getWriter().print("<script>alert('您没有权限,请登入！');window.location.href='"+request.getContextPath()+"/fixflow/login.jsp';</script>");
		}
    }

    protected Method getMethod(String name){
       synchronized(methods){
        Method method = (Method)methods.get(name);
        if (method == null){
         try {
          method = this.getClass().getMethod(name, types);
         } catch (Exception e) {
          e.printStackTrace();
         }
         methods.put(name, method);
        }
        return method;
       }
    }
    
	public  String request(String name){
		return requestParm.getParameter(name);
	}
	public  String requestAttribute(String name){
		return requestParm.getAttribute(name).toString();
	}
	
	public  String session(String name){
		return requestParm.getSession().getAttribute(name).toString();
	}
	
	public  void error(String desc){
		ObjectNode jsonNode = new ObjectMapper().createObjectNode();
		jsonNode.put("state", "error");
		jsonNode.put("result", desc);
		ResultUtils.getInstance(responseParm).renderJson(jsonNode);
	}
 
	public  void success(String desc,String... flag ){
		if(flag.length == 0)
			ResultUtils.getInstance(responseParm).renderJson("{\"state\":\"success\",\"result\":" + desc +" }");
		else
			ResultUtils.getInstance(responseParm).renderJson("{\"state\":\"success\",\"result\":\"" + desc +"\" }");
	}
 
	public  void ajaxResultObj(ObjectNode on) throws Exception{
		PrintWriter out = null;
		try {
			responseParm.setContentType("application/x-json"); 
			responseParm.setCharacterEncoding("utf-8");
			out = responseParm.getWriter();
			out.print(on);
		} catch (Exception e) {
			out.flush();
        	out.close();
        	throw new  Exception("打印json格式对象回页面出错!");
		}
       
	}
	
	public  String[] requests(String name){
		return requestParm.getParameterValues(name);
	}

	public HttpServletRequest getRequestParm() {
		return requestParm;
	}

	public void setRequestParm(HttpServletRequest requestParm) {
		this.requestParm = requestParm;
	}

	public HttpServletResponse getResponseParm() {
		return responseParm;
	}

	public void setResponseParm(HttpServletResponse responseParm) {
		this.responseParm = responseParm;
	}

}
