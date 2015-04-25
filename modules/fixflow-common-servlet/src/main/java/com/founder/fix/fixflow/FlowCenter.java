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
 * @author shao
 */
package com.founder.fix.fixflow;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.founder.fix.fixflow.core.impl.util.StringUtil;
import com.founder.fix.fixflow.service.FlowCenterService;
import com.founder.fix.fixflow.service.FlowIdentityService;
import com.founder.fix.fixflow.util.CurrentThread;
import com.founder.fix.fixflow.util.JSONUtil;
import com.founder.fix.fixflow.util.SpringConfigLoadHelper;

/**
 * Servlet implementation class FlowCenter
 */
public class FlowCenter extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FlowCenter() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("ISGET", "ISGET");
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String userId = StringUtil.getString(request.getSession().getAttribute(
				FlowCenterService.LOGIN_USER_ID));
		
		if (StringUtil.isEmpty(userId)) {
			String context = request.getContextPath();
			response.sendRedirect(context + "/");
			return;
		}
		CurrentThread.init();
		ServletOutputStream out = null;
		String action = StringUtil.getString(request.getParameter("action"));
		if (StringUtil.isEmpty(action)) {
			action = StringUtil.getString(request.getAttribute("action"));
		}
		if (StringUtil.isEmpty(action)) {
			action = "getMyTask";
		}
		RequestDispatcher rd = null;
		try {
			Map<String, Object> filter = new HashMap<String, Object>();

			if (ServletFileUpload.isMultipartContent(request)) {
				ServletFileUpload Uploader = new ServletFileUpload(
						new DiskFileItemFactory());
				// Uploader.setSizeMax("); // 设置最大文件尺寸
				Uploader.setHeaderEncoding("utf-8");
				List<FileItem> fileItems = Uploader.parseRequest(request);
				for (FileItem item : fileItems) {
					filter.put(item.getFieldName(), item);
					if (item.getFieldName().equals("action"))
						action = item.getString();
				}
			} else {
				Enumeration enu = request.getParameterNames();
				while (enu.hasMoreElements()) {
					Object tmp = enu.nextElement();
					Object obj = request
							.getParameter(StringUtil.getString(tmp));

					// if (request.getAttribute("ISGET") != null)
					obj = new String(obj.toString().getBytes("ISO8859-1"),
							"utf-8");

					filter.put(StringUtil.getString(tmp), obj);
				}
			}

			Enumeration attenums = request.getAttributeNames();
			while (attenums.hasMoreElements()) {
				String paramName = (String) attenums.nextElement();

				Object paramValue = request.getAttribute(paramName);

				// 形成键值对应的map
				filter.put(paramName, paramValue);

			}

			filter.put("userId", userId);
			request.setAttribute("nowAction", action);
			if (action.equals("getMyProcess")) {
				rd = request.getRequestDispatcher("/fixflow/center/startTask.jsp");
				List<Map<String, String>> result = getFlowCenter()
						.queryStartProcess(userId);
				
				
				Map<String,List<Map<String, String>>> newResult = new HashMap<String,List<Map<String, String>>>();
				for(Map<String,String> tmp:result){
					String category = tmp.get("category");
					if(StringUtil.isEmpty(category))
						category = "默认分类";
					
					List<Map<String, String>> tlist = newResult.get(category);
					if(tlist==null){
						tlist= new ArrayList<Map<String, String>>();
					}
					tlist.add(tmp);
					newResult.put(category, tlist);
				}
				request.setAttribute("result", newResult);
				//获取最近使用流程在sqlserver下有已知语法bug，所以捕捉掉不影响功能使用
				request.setAttribute("userId", userId); // 返回userId add Rex
				try{
					List<Map<String,String>> lastestProcess = getFlowCenter().queryLastestProcess(userId);
					request.setAttribute("lastest", lastestProcess);
				}catch(Exception ex){
					ex.printStackTrace();
				}
			} else if (action.equals("getMyTask")) {
				rd = request.getRequestDispatcher("/fixflow/center/todoTask.jsp");
				filter.put("path", request.getSession().getServletContext()
						.getRealPath("/"));
				Map<String, Object> pageResult = getFlowCenter()
						.queryMyTaskNotEnd(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
				request.setAttribute("pageInfo", filter.get("pageInfo"));
			} else if (action.equals("getProcessImage")) {
				response.getOutputStream();
			} else if (action.equals("getAllProcess")) {
				rd = request.getRequestDispatcher("/fixflow/center/queryprocess.jsp");
				Map<String, Object> pageResult = getFlowCenter()
						.queryTaskInitiator(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
				request.setAttribute("pageInfo", filter.get("pageInfo"));
			} else if (action.equals("getPlaceOnFile")) {
				rd = request.getRequestDispatcher("/fixflow/center/placeOnFile.jsp");
				Map<String, Object> pageResult = getFlowCenter()
						.queryPlaceOnFile(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
				request.setAttribute("pageInfo", filter.get("pageInfo"));
			}else if (action.equals("getTaskDetailInfo")) {
				rd = request.getRequestDispatcher("/fixflow/center/flowGraphic.jsp");
				Map<String, Object> pageResult = getFlowCenter()
						.getTaskDetailInfo(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			}else if (action.equals("getTaskDetailInfoSVG")) {
				rd = request.getRequestDispatcher("/fixflow/center/flowGraphic.jsp");
				Map<String, Object> pageResult = getFlowCenter()
						.getTaskDetailInfoSVG(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			} else if (action.equals("getFlowGraph")) {
				InputStream is = getFlowCenter().getFlowGraph(filter);
				out = response.getOutputStream();
				response.setContentType("application/octet-stream;charset=UTF-8");
				byte[] buff = new byte[2048];
				int size = 0;
				while (is != null && (size = is.read(buff)) != -1) {
					out.write(buff, 0, size);
				}
			} else if (action.equals("getUserInfo")) {
				rd = request.getRequestDispatcher("/fixflow/common/userInfo.jsp");
				filter.put("path", request.getSession().getServletContext()
						.getRealPath("/"));
				Map<String, Object> pageResult = getFlowCenter().getUserInfo(
						filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			}else if (action.equals("getUserIcon")) {
				rd = request.getRequestDispatcher("/fixflow/common/userOperation.jsp");
				filter.put("path", request.getSession().getServletContext()
						.getRealPath("/"));
				Map<String, Object> pageResult = getFlowCenter().getUserInfo(
						filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			} else if (action.equals("updateUserIcon")) {
				rd = request.getRequestDispatcher("/FlowCenter?action=getUserInfo");
				filter.put("path", request.getSession().getServletContext()
						.getRealPath("/"));
				getFlowCenter().saveUserIcon(filter);
				
			} else if(action.equals("selectUserList")){	//选择用户列表
				String isMulti = request.getParameter("isMulti");
				rd = request.getRequestDispatcher("/fixflow/common/selectUserList.jsp?isMulti="+isMulti);
				Map<String, Object> pageResult = getFlowCenter().getAllUsers(filter);
				filter.putAll(pageResult);
				
				request.setAttribute("result", filter);
				request.setAttribute("isMulti", isMulti);
				request.setAttribute("pageInfo", filter.get("pageInfo"));
			} else if(action.equals("selectNodeList")){	//选择节点列表
				rd = request.getRequestDispatcher("/fixflow/common/selectNodeList.jsp");
				Map<String, Object> pageResult = getFlowCenter().getRollbackNode(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			} else if(action.equals("selectStepList")){	//选择步骤列表
				rd = request.getRequestDispatcher("/fixflow/common/selectStepList.jsp");
				Map<String, Object> pageResult = getFlowCenter().getRollbackTask(filter);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			} else if(action.equals("viewDelegation")){	//选择步骤列表
				rd = request.getRequestDispatcher("/fixflow/common/setDelegation.jsp");
				Map<String, Object> pageResult = new HashMap<String, Object>();
				pageResult = this.getFlowIdentityService().getUserDelegationInfo(userId);
				filter.putAll(pageResult);
				request.setAttribute("result", filter);
			}
			else if(action.equals("saveDelegation")){	//选择步骤列表
				
				String agentInfoJson = StringUtil.getString(request.getParameter("insertAndUpdate"));
				if(StringUtil.isNotEmpty(agentInfoJson)){
					Map<String, Object> delegationInfo = JSONUtil.parseJSON2Map(agentInfoJson);
					this.getFlowIdentityService().saveUserDelegationInfo(delegationInfo );
				}
				response.setContentType("text/html;charset=UTF-8"); 
				response.getWriter().write("<script>alert('保存完成');window.close();</script>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMsg", e.getMessage());
			try {
				CurrentThread.rollBack();
			} catch (SQLException e1) {
				e1.printStackTrace();
				request.setAttribute("errorMsg", e.getMessage());
			}
		} finally {
			if (out != null) {
				out.flush();
				out.close();
			}
			try {
				CurrentThread.clear();
			} catch (SQLException e) {
				request.setAttribute("errorMsg", e.getMessage());
				e.printStackTrace();
			}
		}
		if (rd != null){
			rd.forward(request, response);
		}
	}

	public FlowCenterService getFlowCenter() {
		return (FlowCenterService) SpringConfigLoadHelper
				.getBean("flowCenterServiceImpl");
	}
	
	public FlowIdentityService getFlowIdentityService(){
		return (FlowIdentityService)SpringConfigLoadHelper
				.getBean("flowIdentityServiceImpl");
	}

}
